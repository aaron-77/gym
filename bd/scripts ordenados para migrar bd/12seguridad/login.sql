/*
	Created by PCAAR\aaron using dbatools Export-DbaLogin for objects on localhost\SQLEXPRESS at 2026-01-29 12:59:06.797
	See https://dbatools.io/Export-DbaLogin for more information
*/
USE master

GO
IF NOT EXISTS (SELECT loginname FROM master.dbo.syslogins WHERE name = 'aaronlogin') CREATE LOGIN [aaronlogin] WITH PASSWORD = 0x02003BD837E59D017096AAB4D60E223A5FB4227E9169FD30DF1C17EB24191BF71525456E4D8E425F07F8EB5EFA42BBE97AB1FCAAA6C7EA99413C7EC4E31DA2F235E1C1A4EDAC HASHED, SID = 0xF8D4F9B4DB89884EAC4833F802194E84, DEFAULT_DATABASE = [FitnessCenterDB], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF, DEFAULT_LANGUAGE = [Español]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [aaronlogin]
GO

USE master

GO
Grant CONNECT SQL TO [aaronlogin]  AS [sa]
GO

USE [FitnessCenterDB]

GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'aaronlogin')
CREATE USER [aaronlogin] FOR LOGIN [aaronlogin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [aaronlogin]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [aaronlogin]
GO
ALTER ROLE [db_owner] ADD MEMBER [aaronlogin]
GO
Grant CONNECT TO [aaronlogin]  AS [dbo]
GO

USE master

GO
IF NOT EXISTS (SELECT loginname FROM master.dbo.syslogins WHERE name = 'PCAAR\aaron') CREATE LOGIN [PCAAR\aaron] FROM WINDOWS WITH DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = [us_english]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [PCAAR\aaron]
GO

USE master

GO
Grant CONNECT SQL TO [PCAAR\aaron]  AS [sa]
GO

USE [FitnessCenterDB]

GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'dbo')
CREATE USER [dbo] FOR LOGIN [PCAAR\aaron] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [dbo]
GO
Grant CONNECT TO [PCAAR\aaron]  AS [dbo]
GO
