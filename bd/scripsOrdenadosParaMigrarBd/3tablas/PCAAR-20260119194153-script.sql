/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:53
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Servicios](
	[ServicioID] [int] IDENTITY(1,1) NOT NULL,
	[NombreServicio] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Descripcion] [nvarchar](255) COLLATE Modern_Spanish_CI_AS NULL,
	[TipoServicio] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Costo] [decimal](10, 2) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[sysdiagrams](
	[name] [sysname] COLLATE Modern_Spanish_CI_AS NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TipoRutina](
	[idTipoRutina] [int] IDENTITY(1,1) NOT NULL,
	[nombreTipoRutina] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaDeCreacion] [datetime] NULL,
	[fechaDeModificacion] [datetime] NULL
) ON [PRIMARY]

GO

