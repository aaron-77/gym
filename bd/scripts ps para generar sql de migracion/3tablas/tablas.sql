/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR$SQLEXPRESS at 01/23/2026 16:00:56
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ProductVersion] [nvarchar](32) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AccessTokens](
	[AccessTokenId] [uniqueidentifier] NOT NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ClientId] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[TokenHash] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[IssuedAt] [datetime2](7) NOT NULL,
	[ExpiresAt] [datetime2](7) NOT NULL,
	[RevokedAt] [datetime2](7) NULL,
	[IpAddress] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[UserAgent] [nvarchar](250) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ClaimType] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[ClaimValue] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Name] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[NormalizedName] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[ConcurrencyStamp] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ClaimType] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[ClaimValue] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO	

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ProviderKey] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ProviderDisplayName] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[RoleId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[NombreCompleto] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[UserName] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[NormalizedUserName] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[Email] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[NormalizedEmail] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[SecurityStamp] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[ConcurrencyStamp] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[PhoneNumber] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[NumeroDeIdentificacion] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Direccion] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[FechaDeNacimiento] [datetime2](7) NOT NULL,
	[Apellido] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Estado] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[FechaDeRegistro] [datetime2](7) NOT NULL,
	[IdAntiguo] [int] NULL,
	[IdSecundario] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetUserTokens](
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[LoginProvider] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Name] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Value] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[beneficiosDeClase](
	[idBeneficio] [int] IDENTITY(1,1) NOT NULL,
	[fkClase] [int] NOT NULL,
	[beneficio] [nvarchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaDeCreacion] [datetime] NULL,
	[fechaDeModificacion] [datetime] NULL,
	[fkIcon] [int] NULL,
	[descripcionBeneficio] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Citas](
	[CitaID] [int] IDENTITY(1,1) NOT NULL,
	[FechaHora] [datetime] NOT NULL,
	[TipoCita] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Estado] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[FechaHoraFin] [datetime] NOT NULL,
	[EntrenadorId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Clases](
	[ClaseID] [int] IDENTITY(1,1) NOT NULL,
	[NombreClase] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Cupo] [int] NOT NULL,
	[Descripcion] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[duracionEnMinutos] [int] NULL,
	[fkIntensidad] [int] NULL,
	[fkDificultad] [int] NULL,
	[tiempoDeDescansoEnMinutos] [int] NOT NULL,
	[duracionEnMinutosConDescansoIncluido] [int] NOT NULL,
	[fkEstadoClase] [int] NULL,
	[InstructorId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[clasesProgramadas](
	[idProgramacionClase] [int] IDENTITY(1,1) NOT NULL,
	[fkClase] [int] NOT NULL,
	[cupoMaximo] [int] NOT NULL,
	[fkEstadoClaseProgramada] [int] NOT NULL,
	[fechaCreacion] [datetime] NULL,
	[fechaModificacion] [datetime] NULL,
	[fkEntrenador] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaDeLaClase] [date] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[consejosParaLasClases](
	[idConsejo] [int] IDENTITY(1,1) NOT NULL,
	[fkClase] [int] NULL,
	[fkEjercicio] [int] NULL,
	[introduccionDeConsejo] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[consejos] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Cupones](
	[CuponID] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[DescuentoID] [int] NULL,
	[FechaExpiracion] [datetime] NOT NULL,
	[Estado] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Descuentos](
	[DescuentoID] [int] IDENTITY(1,1) NOT NULL,
	[Porcentaje] [decimal](5, 2) NOT NULL,
	[Descripcion] [nvarchar](255) COLLATE Modern_Spanish_CI_AS NULL,
	[FechaInicio] [datetime] NOT NULL,
	[FechaFin] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DetalleEntrenamiento](
	[DetalleID] [int] IDENTITY(1,1) NOT NULL,
	[RegistroID] [int] NULL,
	[EjercicioID] [int] NULL,
	[Sets] [int] NULL,
	[Repeticiones] [int] NULL,
	[Peso] [decimal](5, 2) NULL,
	[Tiempo] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[diasFestivosVariables](
	[idDiaFestivoVariable] [int] IDENTITY(1,1) NOT NULL,
	[nombreDiasFestivoVariable] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[deQueSemana] [int] NULL,
	[deQueMes] [int] NULL,
	[deQueDia] [int] NOT NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[fechaModificacion] [datetime] NULL,
	[fkTipoDeRecurrenciaDelFestivo] [int] NOT NULL,
	[fkEstadoActividadLaboral] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[diasFestivosYDescansos](
	[idDiaFestivo] [int] IDENTITY(1,1) NOT NULL,
	[fechaFestivaODescanso] [date] NOT NULL,
	[descripcion] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[fkEstadoActividadLaboral] [int] NOT NULL,
	[fechaCreacion] [datetime] NULL,
	[fcehaModificacion] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[duracionCitas](
	[DuracionID] [int] IDENTITY(1,1) NOT NULL,
	[Duracion] [int] NOT NULL,
	[FrecuenciaNotificaciones] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EjercicioEquipos](
	[EjercicioEquipoID] [int] IDENTITY(1,1) NOT NULL,
	[EjercicioID] [int] NULL,
	[EquipoID] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Ejercicios](
	[EjercicioID] [int] IDENTITY(1,1) NOT NULL,
	[NombreEjercicio] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[TipoEjercicio] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Descripcion] [nvarchar](255) COLLATE Modern_Spanish_CI_AS NULL,
	[fkIcon] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ejercicios_parametrosDeMedicion](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fkEjercicio] [int] NOT NULL,
	[fkParametro] [int] NOT NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[fechaModificacion] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Equipos](
	[EquipoID] [int] IDENTITY(1,1) NOT NULL,
	[NombreEquipo] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Descripcion] [nvarchar](255) COLLATE Modern_Spanish_CI_AS NULL,
	[fkIcon] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[estadosClasesProgramadas](
	[idEstadoClaseProgramada] [int] IDENTITY(1,1) NOT NULL,
	[nombresEstado] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaCreacion] [datetime] NULL,
	[fechaModificacion] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[estadosDeActividadLaboral](
	[idEstadoActividadLaboral] [int] IDENTITY(1,1) NOT NULL,
	[nombreEstadoActividadLaboral] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaCreacion] [datetime] NULL,
	[fcehaModificacion] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[estadosDeClases](
	[idEstadoClase] [int] IDENTITY(1,1) NOT NULL,
	[nombreEstado] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[descripcionEstado] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaCreacion] [datetime] NULL,
	[fechaModificacion] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[estadosHorarioClaseProgramada](
	[idEstadoHorarioClase] [int] IDENTITY(1,1) NOT NULL,
	[nombreEstadoHorario] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaCreacion] [datetime] NULL,
	[fechaModificacion] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[estadosInscripciones](
	[idEstadoInscripcion] [int] IDENTITY(1,1) NOT NULL,
	[nombreEstadoInscripcion] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaCreacion] [datetime] NULL,
	[fechaModificacion] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[estructuraDeClase](
	[idBloque] [int] IDENTITY(1,1) NOT NULL,
	[fkClase] [int] NOT NULL,
	[numeroConsecutivoDelBloque] [int] NOT NULL,
	[duracionMenorEnMinutos] [int] NOT NULL,
	[duracionMayorEnMinutos] [int] NOT NULL,
	[tituloBloque] [nvarchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[descripcionBloque] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaDeCreacion] [datetime] NULL,
	[fechaDeModificacion] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[horariosDeClasesProgramadas](
	[idHorarioDeClaseProgramada] [int] IDENTITY(1,1) NOT NULL,
	[fkClaseProgramada] [int] NOT NULL,
	[fkHorarioLaboral] [int] NOT NULL,
	[fkEstadoHorarioClase] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[horasLaborales](
	[idHora] [int] IDENTITY(1,1) NOT NULL,
	[horaInicio] [time](7) NOT NULL,
	[horaFin] [time](7) NOT NULL,
	[fechaCreacion] [datetime] NULL,
	[fechaModificacion] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[iconsForParameters](
	[iconId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[urlPrivada] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[urlPublica] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[imagesForClases](
	[idClassImage] [int] IDENTITY(1,1) NOT NULL,
	[fkClase] [int] NOT NULL,
	[urlParaBanner] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[urlParaParaDescripcionDeClase] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[urlParaBloqueConsejos] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[FechaDeCreacion] [datetime] NOT NULL,
	[FechaDeModificacion] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[imagesForExercises](
	[idImage] [int] IDENTITY(1,1) NOT NULL,
	[fkEjercicio] [int] NOT NULL,
	[nombreParaElFront] [nvarchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[urlPrivada] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[urlPublica] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[inscripcionesDeClases](
	[idInscripcion] [int] IDENTITY(1,1) NOT NULL,
	[fkProgramacionClase] [int] NOT NULL,
	[fechaDeInscripcion] [datetime] NULL,
	[fkEstadoInscripcion] [int] NOT NULL,
	[fkCliente] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[intenciones](
	[intencionId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaDeRegistro] [datetime] NOT NULL,
	[fechaModificacionDeRegistro] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LogErrores](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[procedimiento] [nvarchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[mensaje] [nvarchar](4000) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[severidad] [int] NOT NULL,
	[estado] [int] NOT NULL,
	[fecha] [datetime] NULL,
	[usuario] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[host] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[aplicacion] [nvarchar](200) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[medidas](
	[medidaId] [int] IDENTITY(1,1) NOT NULL,
	[fechaDeCreacion] [datetime] NULL,
	[fkParametro] [int] NULL,
	[valor] [decimal](10, 2) NULL,
	[fkEjercicio] [int] NULL,
	[fkUsuario] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[metas](
	[metaId] [int] IDENTITY(1,1) NOT NULL,
	[fkIntencion] [int] NOT NULL,
	[fkParametro] [int] NOT NULL,
	[fkEjercicio] [int] NULL,
	[valorObjetivo] [decimal](10, 2) NOT NULL,
	[fechaDeInicioDeLaMeta] [datetime] NOT NULL,
	[fechaLimite] [datetime] NOT NULL,
	[fechaDeRegistro] [datetime] NOT NULL,
	[fechaDeModificacionDeRegistro] [datetime] NULL,
	[fkNivelDeLogro] [int] NOT NULL,
	[fkUsuario] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[nivelesDeDificultadDeClase](
	[idNivelDeDificultadDeClase] [int] IDENTITY(1,1) NOT NULL,
	[nombreNivelDeDificultad] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaDeCreacion] [datetime] NULL,
	[fechaDeModificacion] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[nivelesDeIntensidadDeClase](
	[idNivelDeIntensidad] [int] IDENTITY(1,1) NOT NULL,
	[nombreNivelDeIntensidad] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaDeCreacion] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[nivelesDeLogro](
	[idNivelDeLogro] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaDeRegistro] [datetime] NOT NULL,
	[fechaModificacionDeRegistro] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Pagos](
	[PagoID] [int] IDENTITY(1,1) NOT NULL,
	[Monto] [decimal](10, 2) NOT NULL,
	[FechaPago] [datetime] NULL,
	[MetodoPago] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Estado] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[parametros_unidadesDeMedida](
	[fkParametroDeMedicion] [int] NOT NULL,
	[fkUnidadDeMedida] [int] NOT NULL,
	[fechaDeRegistro] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[parametrosDeMedicion](
	[parametroMedicionId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaDeRegistro] [datetime] NOT NULL,
	[fechaModificacionDeRegistro] [datetime] NULL,
	[fkIcon] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[preReservasDeHorario](
	[idPreReserva] [int] IDENTITY(1,1) NOT NULL,
	[fechaInicioDeLaReserva] [datetime] NOT NULL,
	[fechaDeExpiracionDeLaReserva] [datetime] NOT NULL,
	[fkHoraLaboral] [int] NOT NULL,
	[idUsuarioQueReserva] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaReservada] [date] NOT NULL,
	[idClase] [int] NULL,
	[fechaDeLaClase] [date] NULL,
	[idEntrenador] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RefreshTokens](
	[RefreshTokenId] [uniqueidentifier] NOT NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ClientId] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[TokenHash] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[IssuedAt] [datetime2](7) NOT NULL,
	[ExpiresAt] [datetime2](7) NOT NULL,
	[RevokedAt] [datetime2](7) NULL,
	[ReplacedByTokenId] [uniqueidentifier] NULL,
	[IpAddress] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[UserAgent] [nvarchar](250) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RegistrosEntrenamiento](
	[RegistroID] [int] IDENTITY(1,1) NOT NULL,
	[RutinaID] [int] NULL,
	[FechaRegistro] [datetime] NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Roles](
	[RolID] [int] IDENTITY(1,1) NOT NULL,
	[NombreRol] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RutinaEjercicios](
	[RutinaEjercicioID] [int] IDENTITY(1,1) NOT NULL,
	[RutinaID] [int] NULL,
	[EjercicioID] [int] NULL,
	[Sets] [int] NULL,
	[Repeticiones] [int] NULL,
	[Peso] [decimal](5, 2) NULL,
	[Tiempo] [int] NULL,
	[MetaRepeticiones] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Rutinas](
	[RutinaID] [int] IDENTITY(1,1) NOT NULL,
	[FechaCreacion] [datetime] NULL,
	[Observaciones] [nvarchar](255) COLLATE Modern_Spanish_CI_AS NULL,
	[fkClase] [int] NULL,
	[fkTipoRutina] [int] NULL,
	[EntrenadorId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Servicios](
	[ServicioID] [int] IDENTITY(1,1) NOT NULL,
	[NombreServicio] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Descripcion] [nvarchar](255) COLLATE Modern_Spanish_CI_AS NULL,
	[TipoServicio] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Costo] [decimal](10, 2) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TipoRutina](
	[idTipoRutina] [int] IDENTITY(1,1) NOT NULL,
	[nombreTipoRutina] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaDeCreacion] [datetime] NULL,
	[fechaDeModificacion] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tiposDeRecurrenciaDeDiasFestivos](
	[idTipoDeRecurrenciaDeDiaFestivo] [int] IDENTITY(1,1) NOT NULL,
	[nombreTipoDeRecurrencia] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[descripcion] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[fechaModificacion] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[unidadesDeMedida](
	[unidadDeMedidaId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaDeRegistro] [datetime] NOT NULL,
	[fechaModificacionDeRegistro] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Usuarios](
	[UsuarioID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Apellido] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Email] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Telefono] [nvarchar](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[NombreUsuario] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Contrasena] [nvarchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[FechaRegistro] [datetime] NULL,
	[RolID] [int] NULL,
	[Estado] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]

GO

