/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:45
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Pagos](
	[PagoID] [int] IDENTITY(1,1) NOT NULL,
	[Monto] [decimal](10, 2) NOT NULL,
	[FechaPago] [datetime] NULL,
	[MetodoPago] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Estado] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[parametros_unidadesDeMedida](
	[fkParametroDeMedicion] [int] NOT NULL,
	[fkUnidadDeMedida] [int] NOT NULL,
	[fechaDeRegistro] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[parametrosDeMedicion](
	[parametroMedicionId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaDeRegistro] [datetime] NOT NULL,
	[fechaModificacionDeRegistro] [datetime] NULL,
	[fkIcon] [int] NULL
) ON [PRIMARY]

GO

