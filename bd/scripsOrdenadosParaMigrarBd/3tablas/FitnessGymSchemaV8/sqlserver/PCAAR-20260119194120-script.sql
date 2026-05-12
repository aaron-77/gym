/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:20
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[NombreCompleto] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[UserName] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[NormalizedUserName] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[Email] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[NormalizedEmail] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[SecurityStamp] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[ConcurrencyStamp] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[PhoneNumber] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[NumeroDeIdentificacion] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Direccion] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[FechaDeNacimiento] [datetime2](7) NOT NULL,
	[Apellido] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Estado] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[FechaDeRegistro] [datetime2](7) NOT NULL,
	[IdAntiguo] [int] NULL,
	[IdSecundario] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

