/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:14
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AccessTokens](
	[AccessTokenId] [uniqueidentifier] NOT NULL,
	[UserId] [nvarchar](450) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ClientId] [nvarchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[TokenHash] [nvarchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[IssuedAt] [datetime2](7) NOT NULL,
	[ExpiresAt] [datetime2](7) NOT NULL,
	[RevokedAt] [datetime2](7) NULL,
	[IpAddress] [nvarchar](50) COLLATE Modern_Spanish_CI_AS NULL,
	[UserAgent] [nvarchar](250) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO

