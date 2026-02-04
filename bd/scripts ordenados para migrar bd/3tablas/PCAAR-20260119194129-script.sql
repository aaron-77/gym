/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:29
	See https://dbatools.io/Export-DbaScript for more information
*/
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

