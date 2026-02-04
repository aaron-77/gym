/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:51
	See https://dbatools.io/Export-DbaScript for more information
*/
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

