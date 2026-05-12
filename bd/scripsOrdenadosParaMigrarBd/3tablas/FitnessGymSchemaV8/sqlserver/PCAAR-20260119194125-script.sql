/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:25
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Cupones](
	[CuponID] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[DescuentoID] [int] NULL,
	[FechaExpiracion] [datetime] NOT NULL,
	[Estado] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Descuentos](
	[DescuentoID] [int] IDENTITY(1,1) NOT NULL,
	[Porcentaje] [decimal](5, 2) NOT NULL,
	[Descripcion] [nvarchar](255) COLLATE Modern_Spanish_CI_AS NULL,
	[FechaInicio] [datetime] NOT NULL,
	[FechaFin] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DetalleEntrenamiento](
	[DetalleID] [int] IDENTITY(1,1) NOT NULL,
	[RegistroID] [int] NULL,
	[EjercicioID] [int] NULL,
	[Sets] [int] NULL,
	[Repeticiones] [int] NULL,
	[Peso] [decimal](5, 2) NULL,
	[Tiempo] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[diasFestivosVariables](
	[idDiaFestivoVariable] [int] IDENTITY(1,1) NOT NULL,
	[nombreDiasFestivoVariable] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[deQueSemana] [int] NULL,
	[deQueMes] [int] NULL,
	[deQueDia] [int] NOT NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[fechaModificacion] [datetime] NULL,
	[fkTipoDeRecurrenciaDelFestivo] [int] NOT NULL,
	[fkEstadoActividadLaboral] [int] NOT NULL
) ON [PRIMARY]

GO

