/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:44
	See https://dbatools.io/Export-DbaScript for more information
*/
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

