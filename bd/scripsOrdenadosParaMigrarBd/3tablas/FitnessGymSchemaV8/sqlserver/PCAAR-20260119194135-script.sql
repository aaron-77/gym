/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:35
	See https://dbatools.io/Export-DbaScript for more information
*/
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

