/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on PCAAR at 01/19/2026 19:41:10
	See https://dbatools.io/Export-DbaScript for more information
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ProductVersion] [nvarchar](32) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]

GO

