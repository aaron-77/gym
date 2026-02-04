/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:24
	See https://dbatools.io/Export-DbaScript for more information
*/
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

