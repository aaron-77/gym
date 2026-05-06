/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:56
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[unidadesDeMedida](
	[unidadDeMedidaId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaDeRegistro] [datetime] NOT NULL,
	[fechaModificacionDeRegistro] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Usuarios](
	[UsuarioID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Apellido] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Email] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Telefono] [nvarchar](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[NombreUsuario] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Contrasena] [nvarchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[FechaRegistro] [datetime] NULL,
	[RolID] [int] NULL,
	[Estado] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]

GO

