/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:30
	See https://dbatools.io/Export-DbaScript for more information
*/
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

