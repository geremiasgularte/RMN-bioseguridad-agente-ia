-- =====================================================================
-- DATA WAREHOUSE - RMN_DW (T-SQL, misma instancia que RMN_OLTP)
-- v2: repetible (recrea la base), fact_sesiones, tuvo_sesion en
--     fact_turnos y segundos_alerta en fact_alertas_bioseguridad.
-- ATENCION: si RMN_DW existe, se BORRA y se vuelve a crear.
-- =====================================================================
USE master;
GO

IF DB_ID('RMN_DW') IS NOT NULL
BEGIN
    ALTER DATABASE RMN_DW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RMN_DW;
END
GO

CREATE DATABASE RMN_DW;
GO

USE RMN_DW;
GO

CREATE SCHEMA dw;
GO

-- ---------------------------------------------------------------------
-- DIMENSIONES
-- ---------------------------------------------------------------------
CREATE TABLE dw.dim_tiempo (
    sk_tiempo        INT PRIMARY KEY,
    fecha            DATE NOT NULL UNIQUE,
    anio             SMALLINT NOT NULL,
    trimestre        SMALLINT NOT NULL,
    mes              SMALLINT NOT NULL,
    nombre_mes       VARCHAR(20) NOT NULL,
    dia              SMALLINT NOT NULL,
    dia_semana       VARCHAR(20) NOT NULL,
    es_fin_de_semana BIT NOT NULL
);

CREATE TABLE dw.dim_paciente (
    sk_paciente          INT IDENTITY(1,1) PRIMARY KEY,
    paciente_id_origen   UNIQUEIDENTIFIER NOT NULL UNIQUE,
    tipo_documento       VARCHAR(10),
    numero_documento     VARCHAR(20),
    nombre               VARCHAR(100),
    apellido             VARCHAR(100),
    fecha_nacimiento     DATE,
    genero               VARCHAR(20),
    cobertura_principal  VARCHAR(100),
    fecha_alta_cobertura DATETIME,
    activo               BIT
);

CREATE TABLE dw.dim_estudio (
    sk_estudio                       INT IDENTITY(1,1) PRIMARY KEY,
    estudio_id_origen                INT NOT NULL UNIQUE,
    nombre_estudio                   VARCHAR(150),
    modalidad                        VARCHAR(20),
    requiere_evaluacion_bioseguridad BIT
);

CREATE TABLE dw.dim_resonador (
    sk_resonador        INT IDENTITY(1,1) PRIMARY KEY,
    resonador_id_origen INT NOT NULL UNIQUE,
    nombre              VARCHAR(100),
    fabricante          VARCHAR(100),
    modelo              VARCHAR(100),
    campo_tesla         DECIMAL(5,1)
);

CREATE TABLE dw.dim_motivo_cancelacion (
    sk_motivo_cancelacion INT IDENTITY(1,1) PRIMARY KEY,
    motivo_id_origen      INT NOT NULL UNIQUE,
    descripcion_motivo    VARCHAR(200)
);

CREATE TABLE dw.dim_tipo_protesis (
    sk_tipo_protesis         INT IDENTITY(1,1) PRIMARY KEY,
    tipo_protesis_id_origen  INT NOT NULL UNIQUE,
    nombre_tipo              VARCHAR(100),
    nivel_riesgo_por_defecto VARCHAR(20)
);

CREATE TABLE dw.dim_protesis_declarada (
    sk_protesis_declarada    INT IDENTITY(1,1) PRIMARY KEY,
    declaracion_id_origen    UNIQUEIDENTIFIER NOT NULL UNIQUE,
    sk_paciente              INT REFERENCES dw.dim_paciente(sk_paciente),
    sk_tipo_protesis         INT REFERENCES dw.dim_tipo_protesis(sk_tipo_protesis),
    marca                    VARCHAR(100),
    modelo                   VARCHAR(100),
    fabricante               VARCHAR(100),
    estado_identificacion    VARCHAR(30),
    fecha_declaracion        DATETIME
);

CREATE TABLE dw.dim_usuario (
    sk_usuario         INT IDENTITY(1,1) PRIMARY KEY,
    usuario_id_origen  INT NOT NULL UNIQUE,
    legajo             VARCHAR(20),
    nombre_completo    VARCHAR(150),
    rol                VARCHAR(30)
);

-- ---------------------------------------------------------------------
-- HECHOS
-- ---------------------------------------------------------------------
CREATE TABLE dw.fact_turnos (
    sk_turno               BIGINT IDENTITY(1,1) PRIMARY KEY,
    turno_id_origen        UNIQUEIDENTIFIER NOT NULL UNIQUE,
    sk_tiempo              INT REFERENCES dw.dim_tiempo(sk_tiempo),
    sk_paciente            INT REFERENCES dw.dim_paciente(sk_paciente),
    sk_estudio             INT REFERENCES dw.dim_estudio(sk_estudio),
    sk_resonador           INT REFERENCES dw.dim_resonador(sk_resonador),
    sk_motivo_cancelacion  INT REFERENCES dw.dim_motivo_cancelacion(sk_motivo_cancelacion),
    evaluacion_id_origen   UNIQUEIDENTIFIER,  -- degenerada: si no es NULL, la cancelacion vino de una evaluacion de bioseguridad
    estado_turno           VARCHAR(20) NOT NULL,
    dias_anticipacion      INT,
    tuvo_sesion            BIT NOT NULL DEFAULT 0,   -- 1 si el paciente abrio el chat para este turno
    estado_sesion          VARCHAR(20),              -- NULL si no hubo sesion
    flag_cancelado         BIT NOT NULL DEFAULT 0,
    flag_no_asistio        BIT NOT NULL DEFAULT 0,
    cantidad_turnos        INT NOT NULL DEFAULT 1
);

CREATE TABLE dw.fact_sesiones (
    sk_sesion                      BIGINT IDENTITY(1,1) PRIMARY KEY,
    sesion_id_origen               VARCHAR(100) NOT NULL UNIQUE,
    sk_turno                       BIGINT REFERENCES dw.fact_turnos(sk_turno),
    sk_tiempo                      INT REFERENCES dw.dim_tiempo(sk_tiempo),   -- fecha de inicio de la sesion
    sk_paciente                    INT REFERENCES dw.dim_paciente(sk_paciente),
    sk_estudio                     INT REFERENCES dw.dim_estudio(sk_estudio),
    estado_sesion                  VARCHAR(20) NOT NULL,
    estado_turno                   VARCHAR(20),      -- estado del turno asociado (degenerada)
    cantidad_preguntas_respondidas INT NOT NULL,
    cantidad_protesis_declaradas   INT NOT NULL,
    duracion_minutos               DECIMAL(10,2),    -- NULL si la sesion no tiene fecha_fin
    tuvo_alerta                    BIT NOT NULL DEFAULT 0,
    cantidad_sesiones              INT NOT NULL DEFAULT 1
);

CREATE TABLE dw.fact_alertas_bioseguridad (
    sk_alerta               BIGINT IDENTITY(1,1) PRIMARY KEY,
    alerta_id_origen        UNIQUEIDENTIFIER NOT NULL UNIQUE,
    declaracion_id_origen   UNIQUEIDENTIFIER NOT NULL,
    sk_tiempo               INT REFERENCES dw.dim_tiempo(sk_tiempo),
    sk_paciente             INT REFERENCES dw.dim_paciente(sk_paciente),
    sk_tipo_protesis        INT REFERENCES dw.dim_tipo_protesis(sk_tipo_protesis),
    sk_protesis_declarada   INT REFERENCES dw.dim_protesis_declarada(sk_protesis_declarada),
    sk_usuario_resolucion   INT REFERENCES dw.dim_usuario(sk_usuario),
    tipo_alerta             VARCHAR(40) NOT NULL,
    motivo_alerta           VARCHAR(500),
    estado_alerta           VARCHAR(20) NOT NULL,
    nivel_urgencia          VARCHAR(20) NOT NULL,
    segundos_alerta         DECIMAL(10,3),   -- declaracion -> alerta generada (requisito: <= 60 s)
    horas_resolucion        DECIMAL(10,2),   -- alerta -> resolucion
    cantidad_alertas        INT NOT NULL DEFAULT 1
);

CREATE TABLE dw.fact_evaluaciones_bioseguridad (
    sk_evaluacion             BIGINT IDENTITY(1,1) PRIMARY KEY,
    evaluacion_id_origen      UNIQUEIDENTIFIER NOT NULL UNIQUE,
    declaracion_id_origen     UNIQUEIDENTIFIER NOT NULL,
    sk_tiempo                 INT REFERENCES dw.dim_tiempo(sk_tiempo),
    sk_paciente               INT REFERENCES dw.dim_paciente(sk_paciente),
    sk_tipo_protesis          INT REFERENCES dw.dim_tipo_protesis(sk_tipo_protesis),
    sk_protesis_declarada     INT REFERENCES dw.dim_protesis_declarada(sk_protesis_declarada),
    sk_usuario_evaluador      INT REFERENCES dw.dim_usuario(sk_usuario),
    estado_evaluacion         VARCHAR(20) NOT NULL,
    resultado_compatibilidad  VARCHAR(30),
    nivel_urgencia            VARCHAR(20),
    horas_resolucion          DECIMAL(10,2),
    cantidad_evaluaciones     INT NOT NULL DEFAULT 1
);
GO

CREATE INDEX idx_fact_turnos_tiempo ON dw.fact_turnos(sk_tiempo);
CREATE INDEX idx_fact_turnos_paciente ON dw.fact_turnos(sk_paciente);
CREATE INDEX idx_fact_sesiones_tiempo ON dw.fact_sesiones(sk_tiempo);
CREATE INDEX idx_fact_sesiones_turno ON dw.fact_sesiones(sk_turno);
CREATE INDEX idx_fact_alertas_tiempo ON dw.fact_alertas_bioseguridad(sk_tiempo);
CREATE INDEX idx_fact_evaluaciones_tiempo ON dw.fact_evaluaciones_bioseguridad(sk_tiempo);
GO
