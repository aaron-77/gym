/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:34
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[horasLaborales](
	[idHora] [int] IDENTITY(1,1) NOT NULL,
	[horaInicio] [time](7) NOT NULL,
	[horaFin] [time](7) NOT NULL,
	[fechaCreacion] [datetime] NULL,
	[fechaModificacion] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[iconsForParameters](
	[iconId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[urlPrivada] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[urlPublica] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

