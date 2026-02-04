/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:18
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ClaimType] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[ClaimValue] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ProviderKey] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ProviderDisplayName] [nvarchar](max) COLLATE Modern_Spanish_CI_AS NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

