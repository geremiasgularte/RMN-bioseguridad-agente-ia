USE [master]
GO
/****** Object:  Database [RMN_OLTP]    Script Date: 5/11/2026 22:22:26 ******/
CREATE DATABASE [RMN_OLTP]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RMN_OLTP', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\RMN_OLTP.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'RMN_OLTP_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\RMN_OLTP_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [RMN_OLTP] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RMN_OLTP].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [RMN_OLTP] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [RMN_OLTP] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [RMN_OLTP] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [RMN_OLTP] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [RMN_OLTP] SET ARITHABORT OFF 
GO
ALTER DATABASE [RMN_OLTP] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [RMN_OLTP] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [RMN_OLTP] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [RMN_OLTP] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [RMN_OLTP] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [RMN_OLTP] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [RMN_OLTP] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [RMN_OLTP] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [RMN_OLTP] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [RMN_OLTP] SET  ENABLE_BROKER 
GO
ALTER DATABASE [RMN_OLTP] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [RMN_OLTP] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [RMN_OLTP] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [RMN_OLTP] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [RMN_OLTP] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [RMN_OLTP] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [RMN_OLTP] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [RMN_OLTP] SET RECOVERY FULL 
GO
ALTER DATABASE [RMN_OLTP] SET  MULTI_USER 
GO
ALTER DATABASE [RMN_OLTP] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [RMN_OLTP] SET DB_CHAINING OFF 
GO
ALTER DATABASE [RMN_OLTP] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [RMN_OLTP] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [RMN_OLTP] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [RMN_OLTP] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'RMN_OLTP', N'ON'
GO
ALTER DATABASE [RMN_OLTP] SET QUERY_STORE = ON
GO
ALTER DATABASE [RMN_OLTP] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [RMN_OLTP]
GO
/****** Object:  Table [dbo].[alertas_bioseguridad]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alertas_bioseguridad](
	[alerta_id] [uniqueidentifier] NOT NULL,
	[declaracion_id] [uniqueidentifier] NOT NULL,
	[tipo_alerta] [varchar](40) NOT NULL,
	[motivo_alerta] [varchar](500) NULL,
	[estado_alerta] [varchar](20) NOT NULL,
	[nivel_urgencia] [varchar](20) NOT NULL,
	[fecha_alerta] [datetime] NOT NULL,
	[fecha_resolucion] [datetime] NULL,
	[usuario_resolucion_id] [int] NULL,
	[observaciones_resolucion] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[alerta_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bot_preguntas_config]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bot_preguntas_config](
	[pregunta_id] [int] NOT NULL,
	[codigo_pregunta] [varchar](50) NOT NULL,
	[texto_pregunta] [varchar](500) NOT NULL,
	[orden] [int] NOT NULL,
	[es_critica] [bit] NOT NULL,
	[aplica_a] [varchar](20) NOT NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pregunta_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[orden] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[codigo_pregunta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bot_respuestas_log]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bot_respuestas_log](
	[respuesta_id] [bigint] IDENTITY(1,1) NOT NULL,
	[sesion_id] [varchar](100) NOT NULL,
	[pregunta_id] [int] NOT NULL,
	[respuesta_texto] [varchar](500) NULL,
	[respuesta_valor] [varchar](50) NULL,
	[fecha_respuesta] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[respuesta_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_sesion_pregunta] UNIQUE NONCLUSTERED 
(
	[sesion_id] ASC,
	[pregunta_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bot_sesiones]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bot_sesiones](
	[sesion_id] [varchar](100) NOT NULL,
	[paciente_id] [uniqueidentifier] NOT NULL,
	[turno_id] [uniqueidentifier] NOT NULL,
	[canal] [varchar](30) NOT NULL,
	[fecha_inicio] [datetime] NOT NULL,
	[fecha_fin] [datetime] NULL,
	[estado_sesion] [varchar](20) NOT NULL,
	[cantidad_preguntas_respondidas] [int] NOT NULL,
	[cantidad_protesis_declaradas] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sesion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[turno_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[coberturas_medicas]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[coberturas_medicas](
	[cobertura_id] [int] IDENTITY(1,1) NOT NULL,
	[nombre_cobertura] [varchar](100) NOT NULL,
	[cuit] [varchar](20) NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cobertura_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre_cobertura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[documentos_adjuntos]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[documentos_adjuntos](
	[documento_id] [uniqueidentifier] NOT NULL,
	[declaracion_id] [uniqueidentifier] NOT NULL,
	[tipo_documento] [varchar](50) NULL,
	[url_storage] [varchar](500) NULL,
	[ocr_texto_extraido] [varchar](max) NULL,
	[estado_ocr] [varchar](30) NOT NULL,
	[fecha_subida] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[documento_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[estudios]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[estudios](
	[estudio_id] [int] IDENTITY(1,1) NOT NULL,
	[nombre_estudio] [varchar](150) NOT NULL,
	[modalidad] [varchar](20) NOT NULL,
	[requiere_evaluacion_bioseguridad] [bit] NOT NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[estudio_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre_estudio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[evaluaciones_bioseguridad]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[evaluaciones_bioseguridad](
	[evaluacion_id] [uniqueidentifier] NOT NULL,
	[declaracion_id] [uniqueidentifier] NOT NULL,
	[usuario_evaluador_id] [int] NOT NULL,
	[estado_evaluacion] [varchar](20) NOT NULL,
	[resultado_compatibilidad] [varchar](30) NULL,
	[nivel_urgencia] [varchar](20) NULL,
	[observaciones_medicas] [varchar](500) NULL,
	[fecha_asignacion] [datetime] NOT NULL,
	[fecha_evaluacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[evaluacion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[logs_acceso_datos]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[logs_acceso_datos](
	[log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[usuario_id] [int] NOT NULL,
	[paciente_id] [uniqueidentifier] NULL,
	[accion] [varchar](20) NOT NULL,
	[tabla_afectada] [varchar](100) NULL,
	[registro_id] [varchar](100) NULL,
	[ip_origen] [varchar](50) NULL,
	[fecha_hora] [datetime] NOT NULL,
	[observaciones] [varchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[motivos_cancelacion_turnos]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[motivos_cancelacion_turnos](
	[motivo_id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion_motivo] [varchar](200) NOT NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[motivo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[descripcion_motivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[paciente_coberturas]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[paciente_coberturas](
	[paciente_id] [uniqueidentifier] NOT NULL,
	[cobertura_id] [int] NOT NULL,
	[nro_afiliado] [varchar](50) NULL,
	[es_principal] [bit] NOT NULL,
	[fecha_alta] [datetime] NOT NULL,
 CONSTRAINT [PK_paciente_coberturas] PRIMARY KEY CLUSTERED 
(
	[paciente_id] ASC,
	[cobertura_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[paciente_protesis_declaradas]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[paciente_protesis_declaradas](
	[declaracion_id] [uniqueidentifier] NOT NULL,
	[sesion_id] [varchar](100) NOT NULL,
	[paciente_id] [uniqueidentifier] NOT NULL,
	[tipo_protesis_id] [int] NOT NULL,
	[descripcion_paciente] [varchar](500) NULL,
	[marca] [varchar](100) NULL,
	[modelo] [varchar](100) NULL,
	[fabricante] [varchar](100) NULL,
	[url_certificado] [varchar](500) NULL,
	[texto_ocr] [varchar](max) NULL,
	[estado_identificacion] [varchar](30) NOT NULL,
	[fecha_declaracion] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[declaracion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pacientes]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pacientes](
	[paciente_id] [uniqueidentifier] NOT NULL,
	[tipo_documento] [varchar](10) NOT NULL,
	[numero_documento] [varchar](20) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[apellido] [varchar](100) NOT NULL,
	[fecha_nacimiento] [date] NOT NULL,
	[genero] [varchar](20) NULL,
	[telefono] [varchar](30) NULL,
	[email] [varchar](150) NULL,
	[fecha_registro] [datetime] NOT NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[paciente_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[numero_documento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[resonadores]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[resonadores](
	[resonador_id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[fabricante] [varchar](100) NULL,
	[modelo] [varchar](100) NULL,
	[campo_tesla] [decimal](3, 1) NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[resonador_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipos_protesis]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tipos_protesis](
	[tipo_protesis_id] [int] NOT NULL,
	[nombre_tipo] [varchar](100) NOT NULL,
	[descripcion] [varchar](300) NULL,
	[nivel_riesgo_por_defecto] [varchar](20) NOT NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tipo_protesis_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre_tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[turnos]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[turnos](
	[turno_id] [uniqueidentifier] NOT NULL,
	[paciente_id] [uniqueidentifier] NOT NULL,
	[estudio_id] [int] NOT NULL,
	[resonador_id] [int] NULL,
	[fecha_hora_turno] [datetime] NOT NULL,
	[estado_turno] [varchar](20) NOT NULL,
	[fecha_creacion] [datetime] NOT NULL,
	[observaciones] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[turno_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[turnos_cancelados_log]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[turnos_cancelados_log](
	[cancelacion_id] [uniqueidentifier] NOT NULL,
	[turno_id] [uniqueidentifier] NOT NULL,
	[motivo_id] [int] NOT NULL,
	[evaluacion_id] [uniqueidentifier] NULL,
	[fecha_cancelacion] [datetime] NOT NULL,
	[observaciones] [varchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[cancelacion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuarios_sistema]    Script Date: 5/11/2026 22:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarios_sistema](
	[usuario_id] [int] IDENTITY(1,1) NOT NULL,
	[legajo] [varchar](20) NOT NULL,
	[nombre_completo] [varchar](150) NOT NULL,
	[rol] [varchar](30) NOT NULL,
	[email] [varchar](150) NULL,
	[activo] [bit] NOT NULL,
	[fecha_alta] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[legajo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [UX_evaluacion_abierta_por_declaracion]    Script Date: 5/11/2026 22:22:26 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_evaluacion_abierta_por_declaracion] ON [dbo].[evaluaciones_bioseguridad]
(
	[declaracion_id] ASC
)
WHERE ([estado_evaluacion] IN ('Pendiente', 'En Revision'))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_paciente_cobertura_principal]    Script Date: 5/11/2026 22:22:26 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_paciente_cobertura_principal] ON [dbo].[paciente_coberturas]
(
	[paciente_id] ASC
)
WHERE ([es_principal]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[alertas_bioseguridad] ADD  DEFAULT (newid()) FOR [alerta_id]
GO
ALTER TABLE [dbo].[alertas_bioseguridad] ADD  DEFAULT (getdate()) FOR [fecha_alerta]
GO
ALTER TABLE [dbo].[bot_preguntas_config] ADD  DEFAULT ((0)) FOR [es_critica]
GO
ALTER TABLE [dbo].[bot_preguntas_config] ADD  DEFAULT ('Todos') FOR [aplica_a]
GO
ALTER TABLE [dbo].[bot_preguntas_config] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[bot_respuestas_log] ADD  DEFAULT (getdate()) FOR [fecha_respuesta]
GO
ALTER TABLE [dbo].[bot_sesiones] ADD  DEFAULT ('Web') FOR [canal]
GO
ALTER TABLE [dbo].[bot_sesiones] ADD  DEFAULT ((0)) FOR [cantidad_preguntas_respondidas]
GO
ALTER TABLE [dbo].[bot_sesiones] ADD  DEFAULT ((0)) FOR [cantidad_protesis_declaradas]
GO
ALTER TABLE [dbo].[coberturas_medicas] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[documentos_adjuntos] ADD  DEFAULT (newid()) FOR [documento_id]
GO
ALTER TABLE [dbo].[documentos_adjuntos] ADD  DEFAULT (getdate()) FOR [fecha_subida]
GO
ALTER TABLE [dbo].[estudios] ADD  DEFAULT ('RMN') FOR [modalidad]
GO
ALTER TABLE [dbo].[estudios] ADD  DEFAULT ((1)) FOR [requiere_evaluacion_bioseguridad]
GO
ALTER TABLE [dbo].[estudios] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[evaluaciones_bioseguridad] ADD  DEFAULT (newid()) FOR [evaluacion_id]
GO
ALTER TABLE [dbo].[evaluaciones_bioseguridad] ADD  DEFAULT (getdate()) FOR [fecha_asignacion]
GO
ALTER TABLE [dbo].[logs_acceso_datos] ADD  DEFAULT (getdate()) FOR [fecha_hora]
GO
ALTER TABLE [dbo].[motivos_cancelacion_turnos] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[paciente_coberturas] ADD  DEFAULT ((0)) FOR [es_principal]
GO
ALTER TABLE [dbo].[paciente_coberturas] ADD  DEFAULT (getdate()) FOR [fecha_alta]
GO
ALTER TABLE [dbo].[paciente_protesis_declaradas] ADD  DEFAULT (newid()) FOR [declaracion_id]
GO
ALTER TABLE [dbo].[paciente_protesis_declaradas] ADD  DEFAULT (getdate()) FOR [fecha_declaracion]
GO
ALTER TABLE [dbo].[pacientes] ADD  DEFAULT (newid()) FOR [paciente_id]
GO
ALTER TABLE [dbo].[pacientes] ADD  DEFAULT (getdate()) FOR [fecha_registro]
GO
ALTER TABLE [dbo].[pacientes] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[resonadores] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[tipos_protesis] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[turnos] ADD  DEFAULT (newid()) FOR [turno_id]
GO
ALTER TABLE [dbo].[turnos] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [dbo].[turnos_cancelados_log] ADD  DEFAULT (newid()) FOR [cancelacion_id]
GO
ALTER TABLE [dbo].[turnos_cancelados_log] ADD  DEFAULT (getdate()) FOR [fecha_cancelacion]
GO
ALTER TABLE [dbo].[usuarios_sistema] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[usuarios_sistema] ADD  DEFAULT (getdate()) FOR [fecha_alta]
GO
ALTER TABLE [dbo].[alertas_bioseguridad]  WITH CHECK ADD  CONSTRAINT [FK_ab_declaracion] FOREIGN KEY([declaracion_id])
REFERENCES [dbo].[paciente_protesis_declaradas] ([declaracion_id])
GO
ALTER TABLE [dbo].[alertas_bioseguridad] CHECK CONSTRAINT [FK_ab_declaracion]
GO
ALTER TABLE [dbo].[alertas_bioseguridad]  WITH CHECK ADD  CONSTRAINT [FK_ab_usuario] FOREIGN KEY([usuario_resolucion_id])
REFERENCES [dbo].[usuarios_sistema] ([usuario_id])
GO
ALTER TABLE [dbo].[alertas_bioseguridad] CHECK CONSTRAINT [FK_ab_usuario]
GO
ALTER TABLE [dbo].[bot_respuestas_log]  WITH CHECK ADD  CONSTRAINT [FK_brl_pregunta] FOREIGN KEY([pregunta_id])
REFERENCES [dbo].[bot_preguntas_config] ([pregunta_id])
GO
ALTER TABLE [dbo].[bot_respuestas_log] CHECK CONSTRAINT [FK_brl_pregunta]
GO
ALTER TABLE [dbo].[bot_respuestas_log]  WITH CHECK ADD  CONSTRAINT [FK_brl_sesion] FOREIGN KEY([sesion_id])
REFERENCES [dbo].[bot_sesiones] ([sesion_id])
GO
ALTER TABLE [dbo].[bot_respuestas_log] CHECK CONSTRAINT [FK_brl_sesion]
GO
ALTER TABLE [dbo].[bot_sesiones]  WITH CHECK ADD  CONSTRAINT [FK_bs_paciente] FOREIGN KEY([paciente_id])
REFERENCES [dbo].[pacientes] ([paciente_id])
GO
ALTER TABLE [dbo].[bot_sesiones] CHECK CONSTRAINT [FK_bs_paciente]
GO
ALTER TABLE [dbo].[bot_sesiones]  WITH CHECK ADD  CONSTRAINT [FK_bs_turno] FOREIGN KEY([turno_id])
REFERENCES [dbo].[turnos] ([turno_id])
GO
ALTER TABLE [dbo].[bot_sesiones] CHECK CONSTRAINT [FK_bs_turno]
GO
ALTER TABLE [dbo].[documentos_adjuntos]  WITH CHECK ADD  CONSTRAINT [FK_da_declaracion] FOREIGN KEY([declaracion_id])
REFERENCES [dbo].[paciente_protesis_declaradas] ([declaracion_id])
GO
ALTER TABLE [dbo].[documentos_adjuntos] CHECK CONSTRAINT [FK_da_declaracion]
GO
ALTER TABLE [dbo].[evaluaciones_bioseguridad]  WITH CHECK ADD  CONSTRAINT [FK_eb_declaracion] FOREIGN KEY([declaracion_id])
REFERENCES [dbo].[paciente_protesis_declaradas] ([declaracion_id])
GO
ALTER TABLE [dbo].[evaluaciones_bioseguridad] CHECK CONSTRAINT [FK_eb_declaracion]
GO
ALTER TABLE [dbo].[evaluaciones_bioseguridad]  WITH CHECK ADD  CONSTRAINT [FK_eb_usuario] FOREIGN KEY([usuario_evaluador_id])
REFERENCES [dbo].[usuarios_sistema] ([usuario_id])
GO
ALTER TABLE [dbo].[evaluaciones_bioseguridad] CHECK CONSTRAINT [FK_eb_usuario]
GO
ALTER TABLE [dbo].[logs_acceso_datos]  WITH CHECK ADD  CONSTRAINT [FK_log_paciente] FOREIGN KEY([paciente_id])
REFERENCES [dbo].[pacientes] ([paciente_id])
GO
ALTER TABLE [dbo].[logs_acceso_datos] CHECK CONSTRAINT [FK_log_paciente]
GO
ALTER TABLE [dbo].[logs_acceso_datos]  WITH CHECK ADD  CONSTRAINT [FK_log_usuario] FOREIGN KEY([usuario_id])
REFERENCES [dbo].[usuarios_sistema] ([usuario_id])
GO
ALTER TABLE [dbo].[logs_acceso_datos] CHECK CONSTRAINT [FK_log_usuario]
GO
ALTER TABLE [dbo].[paciente_coberturas]  WITH CHECK ADD  CONSTRAINT [FK_pc_cobertura] FOREIGN KEY([cobertura_id])
REFERENCES [dbo].[coberturas_medicas] ([cobertura_id])
GO
ALTER TABLE [dbo].[paciente_coberturas] CHECK CONSTRAINT [FK_pc_cobertura]
GO
ALTER TABLE [dbo].[paciente_coberturas]  WITH CHECK ADD  CONSTRAINT [FK_pc_paciente] FOREIGN KEY([paciente_id])
REFERENCES [dbo].[pacientes] ([paciente_id])
GO
ALTER TABLE [dbo].[paciente_coberturas] CHECK CONSTRAINT [FK_pc_paciente]
GO
ALTER TABLE [dbo].[paciente_protesis_declaradas]  WITH CHECK ADD  CONSTRAINT [FK_ppd_paciente] FOREIGN KEY([paciente_id])
REFERENCES [dbo].[pacientes] ([paciente_id])
GO
ALTER TABLE [dbo].[paciente_protesis_declaradas] CHECK CONSTRAINT [FK_ppd_paciente]
GO
ALTER TABLE [dbo].[paciente_protesis_declaradas]  WITH CHECK ADD  CONSTRAINT [FK_ppd_sesion] FOREIGN KEY([sesion_id])
REFERENCES [dbo].[bot_sesiones] ([sesion_id])
GO
ALTER TABLE [dbo].[paciente_protesis_declaradas] CHECK CONSTRAINT [FK_ppd_sesion]
GO
ALTER TABLE [dbo].[paciente_protesis_declaradas]  WITH CHECK ADD  CONSTRAINT [FK_ppd_tipo] FOREIGN KEY([tipo_protesis_id])
REFERENCES [dbo].[tipos_protesis] ([tipo_protesis_id])
GO
ALTER TABLE [dbo].[paciente_protesis_declaradas] CHECK CONSTRAINT [FK_ppd_tipo]
GO
ALTER TABLE [dbo].[turnos]  WITH CHECK ADD  CONSTRAINT [FK_turnos_estudio] FOREIGN KEY([estudio_id])
REFERENCES [dbo].[estudios] ([estudio_id])
GO
ALTER TABLE [dbo].[turnos] CHECK CONSTRAINT [FK_turnos_estudio]
GO
ALTER TABLE [dbo].[turnos]  WITH CHECK ADD  CONSTRAINT [FK_turnos_paciente] FOREIGN KEY([paciente_id])
REFERENCES [dbo].[pacientes] ([paciente_id])
GO
ALTER TABLE [dbo].[turnos] CHECK CONSTRAINT [FK_turnos_paciente]
GO
ALTER TABLE [dbo].[turnos]  WITH CHECK ADD  CONSTRAINT [FK_turnos_resonador] FOREIGN KEY([resonador_id])
REFERENCES [dbo].[resonadores] ([resonador_id])
GO
ALTER TABLE [dbo].[turnos] CHECK CONSTRAINT [FK_turnos_resonador]
GO
ALTER TABLE [dbo].[turnos_cancelados_log]  WITH CHECK ADD  CONSTRAINT [FK_tcl_evaluacion] FOREIGN KEY([evaluacion_id])
REFERENCES [dbo].[evaluaciones_bioseguridad] ([evaluacion_id])
GO
ALTER TABLE [dbo].[turnos_cancelados_log] CHECK CONSTRAINT [FK_tcl_evaluacion]
GO
ALTER TABLE [dbo].[turnos_cancelados_log]  WITH CHECK ADD  CONSTRAINT [FK_tcl_motivo] FOREIGN KEY([motivo_id])
REFERENCES [dbo].[motivos_cancelacion_turnos] ([motivo_id])
GO
ALTER TABLE [dbo].[turnos_cancelados_log] CHECK CONSTRAINT [FK_tcl_motivo]
GO
ALTER TABLE [dbo].[turnos_cancelados_log]  WITH CHECK ADD  CONSTRAINT [FK_tcl_turno] FOREIGN KEY([turno_id])
REFERENCES [dbo].[turnos] ([turno_id])
GO
ALTER TABLE [dbo].[turnos_cancelados_log] CHECK CONSTRAINT [FK_tcl_turno]
GO
ALTER TABLE [dbo].[alertas_bioseguridad]  WITH CHECK ADD CHECK  (([estado_alerta]='Cancelada' OR [estado_alerta]='Resuelta' OR [estado_alerta]='En Revision' OR [estado_alerta]='Disparada'))
GO
ALTER TABLE [dbo].[alertas_bioseguridad]  WITH CHECK ADD CHECK  (([nivel_urgencia]='Critica' OR [nivel_urgencia]='Alta' OR [nivel_urgencia]='Media' OR [nivel_urgencia]='Baja'))
GO
ALTER TABLE [dbo].[alertas_bioseguridad]  WITH CHECK ADD CHECK  (([tipo_alerta]='Otro' OR [tipo_alerta]='Informacion Insuficiente' OR [tipo_alerta]='Posible Incompatibilidad' OR [tipo_alerta]='Documentacion Faltante' OR [tipo_alerta]='Dispositivo Electronico' OR [tipo_alerta]='Protesis Declarada'))
GO
ALTER TABLE [dbo].[bot_preguntas_config]  WITH CHECK ADD CHECK  (([aplica_a]='Mujeres' OR [aplica_a]='Todos'))
GO
ALTER TABLE [dbo].[bot_sesiones]  WITH CHECK ADD CHECK  (([estado_sesion]='Error' OR [estado_sesion]='Abandonada' OR [estado_sesion]='Finalizada' OR [estado_sesion]='En_Progreso'))
GO
ALTER TABLE [dbo].[documentos_adjuntos]  WITH CHECK ADD CHECK  (([estado_ocr]='Error' OR [estado_ocr]='Sin Texto' OR [estado_ocr]='Exitoso' OR [estado_ocr]='No Realizado'))
GO
ALTER TABLE [dbo].[evaluaciones_bioseguridad]  WITH CHECK ADD CHECK  (([estado_evaluacion]='Cancelada' OR [estado_evaluacion]='Finalizada' OR [estado_evaluacion]='En Revision' OR [estado_evaluacion]='Pendiente'))
GO
ALTER TABLE [dbo].[evaluaciones_bioseguridad]  WITH CHECK ADD CHECK  (([resultado_compatibilidad]='Informacion Insuficiente' OR [resultado_compatibilidad]='No Determinado' OR [resultado_compatibilidad]='MR Unsafe' OR [resultado_compatibilidad]='MR Conditional' OR [resultado_compatibilidad]='MR Safe'))
GO
ALTER TABLE [dbo].[logs_acceso_datos]  WITH CHECK ADD CHECK  (([accion]='OTHER' OR [accion]='EXPORT' OR [accion]='DELETE' OR [accion]='UPDATE' OR [accion]='INSERT' OR [accion]='VIEW' OR [accion]='LOGIN'))
GO
ALTER TABLE [dbo].[paciente_protesis_declaradas]  WITH CHECK ADD CHECK  (([estado_identificacion]='Informacion Insuficiente' OR [estado_identificacion]='No Identificada' OR [estado_identificacion]='Identificada' OR [estado_identificacion]='Pendiente'))
GO
ALTER TABLE [dbo].[pacientes]  WITH CHECK ADD CHECK  (([tipo_documento]='PAS' OR [tipo_documento]='LE' OR [tipo_documento]='LC' OR [tipo_documento]='DNI'))
GO
ALTER TABLE [dbo].[tipos_protesis]  WITH CHECK ADD CHECK  (([nivel_riesgo_por_defecto]='No Determinado' OR [nivel_riesgo_por_defecto]='Alto' OR [nivel_riesgo_por_defecto]='Medio' OR [nivel_riesgo_por_defecto]='Bajo'))
GO
ALTER TABLE [dbo].[turnos]  WITH CHECK ADD CHECK  (([estado_turno]='No Asistio' OR [estado_turno]='Realizado' OR [estado_turno]='Cancelado' OR [estado_turno]='Confirmado' OR [estado_turno]='En Evaluacion' OR [estado_turno]='Programado'))
GO
ALTER TABLE [dbo].[usuarios_sistema]  WITH CHECK ADD CHECK  (([rol]='Otro' OR [rol]='Administrador' OR [rol]='Tecnico Resonancia' OR [rol]='Medico Radiologo'))
GO
USE [master]
GO
ALTER DATABASE [RMN_OLTP] SET  READ_WRITE 
GO
