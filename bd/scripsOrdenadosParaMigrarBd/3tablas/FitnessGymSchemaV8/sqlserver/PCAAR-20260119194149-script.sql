/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:49
	See https://dbatools.io/Export-DbaScript for more information
*/
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

