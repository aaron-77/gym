USE [FitnessCenterDB]
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'aaronlogin')
CREATE USER [aaronlogin] FOR LOGIN [aaronlogin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [aaronlogin]
GO
ALTER ROLE [db_datareader] ADD MEMBER [aaronlogin]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [aaronlogin]
GO
GRANT CONNECT TO [aaronlogin] AS [dbo];
GO

USE [FitnessCenterDB]
GO
DENY EXECUTE ON OBJECT::[dbo].[fn_diagramobjects] TO [guest] AS [dbo];
GO
DENY EXECUTE ON OBJECT::[dbo].[sp_alterdiagram] TO [guest] AS [dbo];
GO
DENY EXECUTE ON OBJECT::[dbo].[sp_creatediagram] TO [guest] AS [dbo];
GO
DENY EXECUTE ON OBJECT::[dbo].[sp_dropdiagram] TO [guest] AS [dbo];
GO
DENY EXECUTE ON OBJECT::[dbo].[sp_helpdiagramdefinition] TO [guest] AS [dbo];
GO
DENY EXECUTE ON OBJECT::[dbo].[sp_helpdiagrams] TO [guest] AS [dbo];
GO
DENY EXECUTE ON OBJECT::[dbo].[sp_renamediagram] TO [guest] AS [dbo];
GO


