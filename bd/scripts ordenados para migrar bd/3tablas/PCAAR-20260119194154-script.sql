/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:54
	See https://dbatools.io/Export-DbaScript for more information
*/
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

