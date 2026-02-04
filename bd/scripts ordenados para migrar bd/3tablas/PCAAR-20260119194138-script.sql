/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:38
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[intenciones](
	[intencionId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaDeRegistro] [datetime] NOT NULL,
	[fechaModificacionDeRegistro] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LogErrores](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[procedimiento] [nvarchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[mensaje] [nvarchar](4000) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[severidad] [int] NOT NULL,
	[estado] [int] NOT NULL,
	[fecha] [datetime] NULL,
	[usuario] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[host] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[aplicacion] [nvarchar](200) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

