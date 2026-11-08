-- =====================================================================
-- TRANSFORM v2 - carga RMN_DW.dw directamente desde RMN_OLTP
-- Correr DESPUES de: 01_oltp_ddl.sql (+ carga de datos del OLTP) y 02_dw_ddl.sql
-- Repetible: vacia el DW antes de cargar.
-- =====================================================================
USE RMN_DW;
GO

SET LANGUAGE spanish;
SET DATEFIRST 1;   -- lunes = 1 ... sabado = 6, domingo = 7
GO

-- Guarda: el OLTP debe estar poblado
DECLARE @t INT = (SELECT COUNT(*) FROM RMN_OLTP.dbo.turnos);
DECLARE @s INT = (SELECT COUNT(*) FROM RMN_OLTP.dbo.bot_sesiones);
DECLARE @a INT = (SELECT COUNT(*) FROM RMN_OLTP.dbo.alertas_bioseguridad);
IF @t = 0 OR @s = 0 OR @a = 0
    THROW 51000, 'RMN_OLTP no esta poblado: correr los scripts 03 a 13 antes del transform.', 1;
GO

-- ---------------------------------------------------------------------
-- LIMPIEZA (hechos primero, luego dimensiones)
-- ---------------------------------------------------------------------
DELETE FROM dw.fact_evaluaciones_bioseguridad;
DELETE FROM dw.fact_alertas_bioseguridad;
DELETE FROM dw.fact_sesiones;
DELETE FROM dw.fact_turnos;
DELETE FROM dw.dim_protesis_declarada;
DELETE FROM dw.dim_usuario;
DELETE FROM dw.dim_tipo_protesis;
DELETE FROM dw.dim_motivo_cancelacion;
DELETE FROM dw.dim_resonador;
DELETE FROM dw.dim_estudio;
DELETE FROM dw.dim_paciente;
DELETE FROM dw.dim_tiempo;
DBCC CHECKIDENT ('dw.fact_evaluaciones_bioseguridad', RESEED, 0) WITH NO_INFOMSGS;
DBCC CHECKIDENT ('dw.fact_alertas_bioseguridad', RESEED, 0) WITH NO_INFOMSGS;
DBCC CHECKIDENT ('dw.fact_sesiones', RESEED, 0) WITH NO_INFOMSGS;
DBCC CHECKIDENT ('dw.fact_turnos', RESEED, 0) WITH NO_INFOMSGS;
DBCC CHECKIDENT ('dw.dim_protesis_declarada', RESEED, 0) WITH NO_INFOMSGS;
DBCC CHECKIDENT ('dw.dim_usuario', RESEED, 0) WITH NO_INFOMSGS;
DBCC CHECKIDENT ('dw.dim_tipo_protesis', RESEED, 0) WITH NO_INFOMSGS;
DBCC CHECKIDENT ('dw.dim_motivo_cancelacion', RESEED, 0) WITH NO_INFOMSGS;
DBCC CHECKIDENT ('dw.dim_resonador', RESEED, 0) WITH NO_INFOMSGS;
DBCC CHECKIDENT ('dw.dim_estudio', RESEED, 0) WITH NO_INFOMSGS;
DBCC CHECKIDENT ('dw.dim_paciente', RESEED, 0) WITH NO_INFOMSGS;
GO

-- ---------------------------------------------------------------------
-- DIM_TIEMPO (sabado = 6, domingo = 7 con DATEFIRST 1; sin depender de tildes)
-- ---------------------------------------------------------------------
;WITH fechas AS (
    SELECT CAST('2023-01-01' AS DATE) AS fecha
    UNION ALL
    SELECT DATEADD(DAY, 1, fecha) FROM fechas WHERE fecha < '2027-12-31'
)
INSERT INTO dw.dim_tiempo (sk_tiempo, fecha, anio, trimestre, mes, nombre_mes, dia, dia_semana, es_fin_de_semana)
SELECT
    CONVERT(INT, CONVERT(CHAR(8), fecha, 112)),
    fecha,
    YEAR(fecha),
    DATEPART(QUARTER, fecha),
    MONTH(fecha),
    DATENAME(MONTH, fecha),
    DAY(fecha),
    DATENAME(WEEKDAY, fecha),
    CASE WHEN DATEPART(WEEKDAY, fecha) IN (6, 7) THEN 1 ELSE 0 END
FROM fechas
OPTION (MAXRECURSION 0);
GO

-- ---------------------------------------------------------------------
-- DIMENSIONES
-- ---------------------------------------------------------------------
INSERT INTO dw.dim_paciente
    (paciente_id_origen, tipo_documento, numero_documento, nombre, apellido,
     fecha_nacimiento, genero, cobertura_principal, fecha_alta_cobertura, activo)
SELECT
    p.paciente_id, p.tipo_documento, p.numero_documento, p.nombre, p.apellido,
    p.fecha_nacimiento, p.genero, cm.nombre_cobertura, pc.fecha_alta, p.activo
FROM RMN_OLTP.dbo.pacientes p
LEFT JOIN RMN_OLTP.dbo.paciente_coberturas pc
    ON pc.paciente_id = p.paciente_id AND pc.es_principal = 1
LEFT JOIN RMN_OLTP.dbo.coberturas_medicas cm ON cm.cobertura_id = pc.cobertura_id;

INSERT INTO dw.dim_estudio (estudio_id_origen, nombre_estudio, modalidad, requiere_evaluacion_bioseguridad)
SELECT estudio_id, nombre_estudio, modalidad, requiere_evaluacion_bioseguridad
FROM RMN_OLTP.dbo.estudios;

INSERT INTO dw.dim_resonador (resonador_id_origen, nombre, fabricante, modelo, campo_tesla)
SELECT resonador_id, nombre, fabricante, modelo, campo_tesla
FROM RMN_OLTP.dbo.resonadores;

INSERT INTO dw.dim_motivo_cancelacion (motivo_id_origen, descripcion_motivo)
SELECT motivo_id, descripcion_motivo
FROM RMN_OLTP.dbo.motivos_cancelacion_turnos;

INSERT INTO dw.dim_tipo_protesis (tipo_protesis_id_origen, nombre_tipo, nivel_riesgo_por_defecto)
SELECT tipo_protesis_id, nombre_tipo, nivel_riesgo_por_defecto
FROM RMN_OLTP.dbo.tipos_protesis;

INSERT INTO dw.dim_usuario (usuario_id_origen, legajo, nombre_completo, rol)
SELECT usuario_id, legajo, nombre_completo, rol
FROM RMN_OLTP.dbo.usuarios_sistema;
GO

INSERT INTO dw.dim_protesis_declarada
    (declaracion_id_origen, sk_paciente, sk_tipo_protesis, marca, modelo,
     fabricante, estado_identificacion, fecha_declaracion)
SELECT
    ppd.declaracion_id,
    dp.sk_paciente,
    dtp.sk_tipo_protesis,
    ppd.marca,
    ppd.modelo,
    ppd.fabricante,
    ppd.estado_identificacion,
    ppd.fecha_declaracion
FROM RMN_OLTP.dbo.paciente_protesis_declaradas ppd
LEFT JOIN dw.dim_paciente dp ON dp.paciente_id_origen = ppd.paciente_id
LEFT JOIN dw.dim_tipo_protesis dtp ON dtp.tipo_protesis_id_origen = ppd.tipo_protesis_id;
GO

-- ---------------------------------------------------------------------
-- FACT_TURNOS (incluye tuvo_sesion / estado_sesion)
-- ---------------------------------------------------------------------
INSERT INTO dw.fact_turnos
    (turno_id_origen, sk_tiempo, sk_paciente, sk_estudio, sk_resonador,
     sk_motivo_cancelacion, evaluacion_id_origen, estado_turno, dias_anticipacion,
     tuvo_sesion, estado_sesion, flag_cancelado, flag_no_asistio, cantidad_turnos)
SELECT
    t.turno_id,
    CONVERT(INT, CONVERT(CHAR(8), t.fecha_hora_turno, 112)),
    dp.sk_paciente,
    de.sk_estudio,
    dr.sk_resonador,
    dm.sk_motivo_cancelacion,
    tcl.evaluacion_id,
    t.estado_turno,
    DATEDIFF(DAY, t.fecha_creacion, t.fecha_hora_turno),
    CASE WHEN bs.sesion_id IS NULL THEN 0 ELSE 1 END,
    bs.estado_sesion,
    CASE WHEN t.estado_turno = 'Cancelado' THEN 1 ELSE 0 END,
    CASE WHEN t.estado_turno = 'No Asistio' THEN 1 ELSE 0 END,
    1
FROM RMN_OLTP.dbo.turnos t
LEFT JOIN RMN_OLTP.dbo.turnos_cancelados_log tcl ON tcl.turno_id = t.turno_id
LEFT JOIN RMN_OLTP.dbo.bot_sesiones bs ON bs.turno_id = t.turno_id
LEFT JOIN dw.dim_paciente dp ON dp.paciente_id_origen = t.paciente_id
LEFT JOIN dw.dim_estudio de ON de.estudio_id_origen = t.estudio_id
LEFT JOIN dw.dim_resonador dr ON dr.resonador_id_origen = t.resonador_id
LEFT JOIN dw.dim_motivo_cancelacion dm ON dm.motivo_id_origen = tcl.motivo_id;
GO

-- ---------------------------------------------------------------------
-- FACT_SESIONES
-- ---------------------------------------------------------------------
INSERT INTO dw.fact_sesiones
    (sesion_id_origen, sk_turno, sk_tiempo, sk_paciente, sk_estudio, estado_sesion,
     estado_turno, cantidad_preguntas_respondidas, cantidad_protesis_declaradas,
     duracion_minutos, tuvo_alerta, cantidad_sesiones)
SELECT
    bs.sesion_id,
    ft.sk_turno,
    CONVERT(INT, CONVERT(CHAR(8), bs.fecha_inicio, 112)),
    dp.sk_paciente,
    ft.sk_estudio,
    bs.estado_sesion,
    ft.estado_turno,
    bs.cantidad_preguntas_respondidas,
    bs.cantidad_protesis_declaradas,
    CASE WHEN bs.fecha_fin IS NULL THEN NULL
         ELSE DATEDIFF(SECOND, bs.fecha_inicio, bs.fecha_fin) / 60.0 END,
    CASE WHEN EXISTS (
        SELECT 1
        FROM RMN_OLTP.dbo.paciente_protesis_declaradas ppd
        JOIN RMN_OLTP.dbo.alertas_bioseguridad ab ON ab.declaracion_id = ppd.declaracion_id
        WHERE ppd.sesion_id = bs.sesion_id) THEN 1 ELSE 0 END,
    1
FROM RMN_OLTP.dbo.bot_sesiones bs
LEFT JOIN dw.fact_turnos ft ON ft.turno_id_origen = bs.turno_id
LEFT JOIN dw.dim_paciente dp ON dp.paciente_id_origen = bs.paciente_id;
GO

-- ---------------------------------------------------------------------
-- FACT_ALERTAS_BIOSEGURIDAD (segundos_alerta = declaracion -> alerta)
-- ---------------------------------------------------------------------
INSERT INTO dw.fact_alertas_bioseguridad
    (alerta_id_origen, declaracion_id_origen, sk_tiempo, sk_paciente, sk_tipo_protesis,
     sk_protesis_declarada, sk_usuario_resolucion, tipo_alerta, motivo_alerta,
     estado_alerta, nivel_urgencia, segundos_alerta, horas_resolucion, cantidad_alertas)
SELECT
    ab.alerta_id,
    ab.declaracion_id,
    CONVERT(INT, CONVERT(CHAR(8), ab.fecha_alerta, 112)),
    dp.sk_paciente,
    dtp.sk_tipo_protesis,
    dpd.sk_protesis_declarada,
    du.sk_usuario,
    ab.tipo_alerta,
    ab.motivo_alerta,
    ab.estado_alerta,
    ab.nivel_urgencia,
    DATEDIFF(MILLISECOND, ppd.fecha_declaracion, ab.fecha_alerta) / 1000.0,
    DATEDIFF(MINUTE, ab.fecha_alerta, ab.fecha_resolucion) / 60.0,
    1
FROM RMN_OLTP.dbo.alertas_bioseguridad ab
JOIN RMN_OLTP.dbo.paciente_protesis_declaradas ppd ON ppd.declaracion_id = ab.declaracion_id
LEFT JOIN dw.dim_paciente dp ON dp.paciente_id_origen = ppd.paciente_id
LEFT JOIN dw.dim_tipo_protesis dtp ON dtp.tipo_protesis_id_origen = ppd.tipo_protesis_id
LEFT JOIN dw.dim_protesis_declarada dpd ON dpd.declaracion_id_origen = ab.declaracion_id
LEFT JOIN dw.dim_usuario du ON du.usuario_id_origen = ab.usuario_resolucion_id;
GO

-- ---------------------------------------------------------------------
-- FACT_EVALUACIONES_BIOSEGURIDAD
-- ---------------------------------------------------------------------
INSERT INTO dw.fact_evaluaciones_bioseguridad
    (evaluacion_id_origen, declaracion_id_origen, sk_tiempo, sk_paciente, sk_tipo_protesis,
     sk_protesis_declarada, sk_usuario_evaluador, estado_evaluacion, resultado_compatibilidad,
     nivel_urgencia, horas_resolucion, cantidad_evaluaciones)
SELECT
    eb.evaluacion_id,
    eb.declaracion_id,
    CONVERT(INT, CONVERT(CHAR(8), eb.fecha_asignacion, 112)),
    dp.sk_paciente,
    dtp.sk_tipo_protesis,
    dpd.sk_protesis_declarada,
    du.sk_usuario,
    eb.estado_evaluacion,
    eb.resultado_compatibilidad,
    eb.nivel_urgencia,
    DATEDIFF(MINUTE, eb.fecha_asignacion, eb.fecha_evaluacion) / 60.0,
    1
FROM RMN_OLTP.dbo.evaluaciones_bioseguridad eb
JOIN RMN_OLTP.dbo.paciente_protesis_declaradas ppd ON ppd.declaracion_id = eb.declaracion_id
LEFT JOIN dw.dim_paciente dp ON dp.paciente_id_origen = ppd.paciente_id
LEFT JOIN dw.dim_tipo_protesis dtp ON dtp.tipo_protesis_id_origen = ppd.tipo_protesis_id
LEFT JOIN dw.dim_protesis_declarada dpd ON dpd.declaracion_id_origen = eb.declaracion_id
LEFT JOIN dw.dim_usuario du ON du.usuario_id_origen = eb.usuario_evaluador_id;
GO

-- ---------------------------------------------------------------------
-- VERIFICACION 1: conteos (esperado: 1500 / 1500 / 1208 / 438 / 438 / 438)
-- ---------------------------------------------------------------------
SELECT 'dim_tiempo' AS tabla, COUNT(*) AS filas FROM dw.dim_tiempo
UNION ALL SELECT 'dim_paciente', COUNT(*) FROM dw.dim_paciente
UNION ALL SELECT 'dim_estudio', COUNT(*) FROM dw.dim_estudio
UNION ALL SELECT 'dim_resonador', COUNT(*) FROM dw.dim_resonador
UNION ALL SELECT 'dim_motivo_cancelacion', COUNT(*) FROM dw.dim_motivo_cancelacion
UNION ALL SELECT 'dim_tipo_protesis', COUNT(*) FROM dw.dim_tipo_protesis
UNION ALL SELECT 'dim_usuario', COUNT(*) FROM dw.dim_usuario
UNION ALL SELECT 'dim_protesis_declarada (438)', COUNT(*) FROM dw.dim_protesis_declarada
UNION ALL SELECT 'fact_turnos (1500)', COUNT(*) FROM dw.fact_turnos
UNION ALL SELECT 'fact_sesiones (1208)', COUNT(*) FROM dw.fact_sesiones
UNION ALL SELECT 'fact_alertas_bioseguridad (438)', COUNT(*) FROM dw.fact_alertas_bioseguridad
UNION ALL SELECT 'fact_evaluaciones_bioseguridad (438)', COUNT(*) FROM dw.fact_evaluaciones_bioseguridad;
GO

-- ---------------------------------------------------------------------
-- VERIFICACION 2: controles de integridad (todos deben dar 0, salvo el ultimo)
-- ---------------------------------------------------------------------
SELECT 'turnos sin paciente/estudio/tiempo (debe ser 0)' AS control, COUNT(*) AS valor
FROM dw.fact_turnos WHERE sk_paciente IS NULL OR sk_estudio IS NULL OR sk_tiempo IS NULL
UNION ALL SELECT 'sesiones sin turno (debe ser 0)', COUNT(*) FROM dw.fact_sesiones WHERE sk_turno IS NULL
UNION ALL SELECT 'alertas sin declaracion en dim (debe ser 0)', COUNT(*) FROM dw.fact_alertas_bioseguridad WHERE sk_protesis_declarada IS NULL
UNION ALL SELECT 'evaluaciones sin declaracion en dim (debe ser 0)', COUNT(*) FROM dw.fact_evaluaciones_bioseguridad WHERE sk_protesis_declarada IS NULL
UNION ALL SELECT 'turnos con tuvo_sesion distinto de sesiones (debe ser 0)',
    ABS((SELECT COUNT(*) FROM dw.fact_turnos WHERE tuvo_sesion = 1) - (SELECT COUNT(*) FROM dw.fact_sesiones))
UNION ALL SELECT 'alertas con segundos_alerta > 60 (debe ser 0)', COUNT(*) FROM dw.fact_alertas_bioseguridad WHERE segundos_alerta > 60
UNION ALL SELECT 'dias de fin de semana en dim_tiempo (informativo, > 0)', COUNT(*) FROM dw.dim_tiempo WHERE es_fin_de_semana = 1;
GO
