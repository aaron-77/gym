/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:40
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[medidas](
	[medidaId] [int] IDENTITY(1,1) NOT NULL,
	[fechaDeCreacion] [datetime] NULL,
	[fkParametro] [int] NULL,
	[valor] [decimal](10, 2) NULL,
	[fkEjercicio] [int] NULL,
	[fkUsuario] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

