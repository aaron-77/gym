/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:28
	See https://dbatools.io/Export-DbaScript for more information
*/
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

