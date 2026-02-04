/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:41
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[metas](
	[metaId] [int] IDENTITY(1,1) NOT NULL,
	[fkIntencion] [int] NOT NULL,
	[fkParametro] [int] NOT NULL,
	[fkEjercicio] [int] NULL,
	[valorObjetivo] [decimal](10, 2) NOT NULL,
	[fechaDeInicioDeLaMeta] [datetime] NOT NULL,
	[fechaLimite] [datetime] NOT NULL,
	[fechaDeRegistro] [datetime] NOT NULL,
	[fechaDeModificacionDeRegistro] [datetime] NULL,
	[fkNivelDeLogro] [int] NOT NULL,
	[fkUsuario] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

