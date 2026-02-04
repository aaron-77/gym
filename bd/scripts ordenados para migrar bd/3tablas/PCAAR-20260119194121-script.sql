/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:21
	See https://dbatools.io/Export-DbaScript for more information
*/
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

