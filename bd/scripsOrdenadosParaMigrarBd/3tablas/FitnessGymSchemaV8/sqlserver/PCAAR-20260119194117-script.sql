/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:17
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ClaimType] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[ClaimValue] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Name] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[NormalizedName] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NULL,
	[ConcurrencyStamp] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

