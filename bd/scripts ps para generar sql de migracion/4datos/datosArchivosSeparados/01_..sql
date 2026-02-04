/*
	Created by PCAAR\aaron using dbatools Export-DbaScript for objects on localhost$SQLEXPRESS at 01/26/2026 11:47:51
	See https://dbatools.io/Export-DbaScript for more information
*/
USE [FitnessCenterDB]
GO

SET IDENTITY_INSERT [dbo].[Usuarios] ON 

GO

INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Telefono], [NombreUsuario], [Contrasena], [FechaNacimiento], [FechaRegistro], [RolID], [Estado]) VALUES (3, N'Juan', N'Martinez', N'aaronhl1313@gmail.com', N'9999999', N'elusuario', N'password123', CAST(N'2024-01-15' AS Date), CAST(N'2024-07-19T14:32:30.477' AS DateTime), 1, N'activo')
GO

INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Telefono], [NombreUsuario], [Contrasena], [FechaNacimiento], [FechaRegistro], [RolID], [Estado]) VALUES (13, N'aaron', N'Azcarraga', N'uno@gmail.com', N'2291250501', N'elusuario20/07/2024 03:15:36 p. m.', N'password1', CAST(N'2024-07-16' AS Date), CAST(N'2024-07-20T15:15:38.870' AS DateTime), 2, N'activo')
GO

INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Telefono], [NombreUsuario], [Contrasena], [FechaNacimiento], [FechaRegistro], [RolID], [Estado]) VALUES (15, N'Yesenia', N'esquivel', N'yesyes@gmail.com', N'33289392929', N'yes92', N'yes123', CAST(N'2024-11-15' AS Date), CAST(N'2024-08-03T03:38:05.413' AS DateTime), 2, N'activo')
GO

INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Telefono], [NombreUsuario], [Contrasena], [FechaNacimiento], [FechaRegistro], [RolID], [Estado]) VALUES (16, N'matias', N'botero', N'matias@gmail.com', N'+522291250501', N'elusuario10/08/2024 12:17:41 a. m.', N'$2a$11$amSmPDPY/lzbqu1BGS.Q0O6cq0tlb.m.sOHr7yij6hwzQtFn0xhnK', CAST(N'2024-08-06' AS Date), CAST(N'2024-08-10T00:17:45.923' AS DateTime), 2, N'activo')
GO

INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Telefono], [NombreUsuario], [Contrasena], [FechaNacimiento], [FechaRegistro], [RolID], [Estado]) VALUES (17, N'Rebeca', N'delgado', N'rebeca@gmail.com', N'227372828399', N'elusuario17/08/2024 01:24:35 a. m.', N'$2a$11$at7qAllPsGTMSrzEBiacYerCbDNAyjVJTsApHPfHS69iUIUk7vNr.', CAST(N'2024-08-17' AS Date), CAST(N'2024-08-17T01:24:44.850' AS DateTime), 1, N'activo')
GO

INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Telefono], [NombreUsuario], [Contrasena], [FechaNacimiento], [FechaRegistro], [RolID], [Estado]) VALUES (19, N'Valeria', N'Gomez', N'valeriag@gmail.com', N'337483839202', N'elusuario17/08/2024 01:31:50 a. m.', N'$2a$11$aKH3BpGNJtDqBopYlLTABulWQx9lRYembOjJtSjfl/B.nB9kRSDHG', CAST(N'1998-10-06' AS Date), CAST(N'2024-08-17T01:31:50.300' AS DateTime), 1, N'activo')
GO

INSERT [dbo].[Usuarios] ([UsuarioID], [Nombre], [Apellido], [Email], [Telefono], [NombreUsuario], [Contrasena], [FechaNacimiento], [FechaRegistro], [RolID], [Estado]) VALUES (22, N'antonio', N'marquez', N'antoniom@gmail.com', N'2237940475', N'elusuario30/4/2025 11:15:06', N'$2a$11$g4MxQsmf4jbLP5J3IjtZkuJYTFjSaG9zpHS0gwERelpN56hQNl1e2', CAST(N'2025-04-16' AS Date), CAST(N'2025-04-30T11:15:06.423' AS DateTime), 2, N'activo')
GO

SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO

