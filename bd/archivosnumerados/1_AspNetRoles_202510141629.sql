use FitnessCenterDB;

SET IDENTITY_INSERT dbo.preReservasDeHorario OFF;
INSERT INTO FitnessCenterDB.dbo.AspNetRoles (Id,Name,NormalizedName,ConcurrencyStamp) VALUES
	 (N'1',N'empleado',N'EMPLEADO',NULL),
	 (N'2',N'cliente',N'CLIENTE',NULL);


INSERT INTO FitnessCenterDB.dbo.AspNetUsers (Id,NombreCompleto,UserName,NormalizedUserName,Email,NormalizedEmail,EmailConfirmed,PasswordHash,SecurityStamp,ConcurrencyStamp,PhoneNumber,PhoneNumberConfirmed,TwoFactorEnabled,LockoutEnd,LockoutEnabled,AccessFailedCount,NumeroDeIdentificacion,Direccion,FechaDeNacimiento,Apellido,Estado,FechaDeRegistro,IdAntiguo) VALUES
	 (N'44e25915-a3df-4bdb-8520-07dca77ecb69',N'Rebeca',N'rebeca@gmail.com',N'REBECA@GMAIL.COM',N'rebeca@gmail.com',N'REBECA@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEAlR4VRZOCaRSFVeGIQDPEnLXDCuI9qdt+9MhRfdw2vCGy+WV9pFwMKhF+0x4pg1jQ==',N'V2FZC6Q32QDD7AL5ECPAXIWAAOXZR273',N'7224b2ec-2edd-49d0-89a5-9b9d0f9a32e7',N'9999999',0,0,NULL,1,0,N'ROROA3334',N'aslalalsa','2024-08-17 00:00:00.0000000',N'delgado',N'activo','0001-01-01 00:00:00.0000000',17),
	 (N'5696d821-ab0c-40d5-9cd2-123232bc4eec',N'matias',N'matias@gmail.com',N'MATIAS@GMAIL.COM',N'matias@gmail.com',N'MATIAS@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEFEPyneTGhticpIqlRp0ScT1ycIa05W+SuOgM45yKkIaQhtTZDXeHNVb0TqLDRMk4w==',N'ECU5XD2BC3FCLC7OSVCITFHDZJUVZ5CK',N'aa24b10e-e8e6-4064-8e1a-33bf6ce2f3bc',N'9999999',0,0,NULL,1,0,N'RORA12350',N'aslalalsa','2024-08-06 00:00:00.0000000',N'botero',N'activo','0001-01-01 00:00:00.0000000',16),
	 (N'574820a9-b28b-4b37-a665-029d2f41e272',N'Valeria',N'valeriag@gmail.com',N'VALERIAG@GMAIL.COM',N'valeriag@gmail.com',N'VALERIAG@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEBu6np9P4Qo0qwjSt7I1E2utQXI34GXD4D+ASchriTMkzpw7k6UTxclxC2ewrEnDyw==',N'CCGYZQ4XVQR6AISH5SA3GW7VOY3RAKRT',N'550a096c-69c9-4489-b318-9f42eaa1cd92',N'9999999',0,0,NULL,1,0,N'ROROA3334',N'aslalalsa','1998-10-06 00:00:00.0000000',N'Gomez',N'activo','0001-01-01 00:00:00.0000000',19),
	 (N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'Yesenia',N'yesyes@gmail.com',N'YESYES@GMAIL.COM',N'yesyes@gmail.com',N'YESYES@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEGFV7o2rnKEDIcs3F/c8G4UVZOn0MsY2lUn8iJtL0xw6rhRzB/ueP5TrOI/upqRQPA==',N'PAVNRX6B7H3OILFOEDBBJM2ZLLKXZ2N2',N'f00ddca9-192b-4a88-aec7-cb5139354919',N'9999999',0,0,NULL,1,0,N'RORA12350',N'aslalalsa','0001-11-15 00:00:00.0000000',N'esquivel',N'activo','0001-01-01 00:00:00.0000000',15),
	 (N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5',N'Juan',N'aaronhl1313@gmail.com',N'AARONHL1313@GMAIL.COM',N'aaronhl1313@gmail.com',N'AARONHL1313@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEIdeJlW2345fcSJLtEqSGyqmUV+l9kqkpGI1lvxfSvcxQzd4onsxsL1Gp8oa47nOTQ==',N'E6OO45X37OYE5ZSTBR42ZDCYASXJIF5I',N'dd0b6615-1ee2-441c-83b6-792d30f0f07c',N'9999999',0,0,NULL,1,0,N'RORO12350',N'aslalalsa','2024-01-15 00:00:00.0000000',N'Martinez',N'activo','0001-01-01 00:00:00.0000000',3),
	 (N'e47637e0-1971-4e46-99fb-186db0847fac',N'aaron',N'uno@gmail.com',N'UNO@GMAIL.COM',N'uno@gmail.com',N'UNO@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEL3XDmXzqqKV8bEy/ZCfViYt6Nl+QxhL5R239sV3Oliu7Y+3+j2ZjviDRXli+4h0Bg==',N'HPTR4SJOAVCGNCXHJPXQXD4COT55K2TP',N'56be8c9f-7b09-409f-b920-42971f19ef95',N'+522263647876',0,0,NULL,1,0,N'V777AA6777',N'123 Calle Principal, ciudad de mexico, Mexico','1959-05-15 00:00:00.0000000',N'Azcarraga',N'activo','2025-09-11 12:39:17.3200000',13),
	 (N'ec4a4f9d-02b8-402a-b274-8924adb46e46',N'antonio',N'antoniom@gmail.com',N'ANTONIOM@GMAIL.COM',N'antoniom@gmail.com',N'ANTONIOM@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEPVSSb1GEl6j2K5kbJ/EaE/2nUUIB4hFJKAuK6YYe/Wp5WBxPT1/UZr62t0lYSpwvw==',N'SBFEQMKV5F63Y6XB3NUK3HZQTALELKHD',N'c33ab3eb-ca17-420a-a741-f6d13275d6f4',N'9999999',0,0,NULL,1,0,N'ROROA3334',N'aslalalsa','2025-04-16 00:00:00.0000000',N'marquez',N'activo','0001-01-01 00:00:00.0000000',22);


INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'Error de conversión al convertir el valor varchar ''ninguno'' al tipo de datos int.',16,1,'2025-03-18 15:58:37.84',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 16:02:33.82',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 4 Ejercicio: 4 mes 3 año 2025',1,3,'2025-03-18 16:03:23.193',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 16:07:40.867',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 16:07:46.327',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 4 Ejercicio: 4 mes 3 año 2025',1,3,'2025-03-18 16:09:07.31',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 16:18:46.88',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 4 Ejercicio: 4 mes 3 año 2025',1,3,'2025-03-18 16:18:56.583',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio: 4 mes 3 año 2025',1,3,'2025-03-18 16:20:52.19',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 2 Ejercicio: 4 mes 3 año 2025',1,3,'2025-03-18 16:21:02.58',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 3 Ejercicio: 4 mes 3 año 2025',1,3,'2025-03-18 16:21:08.537',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 4 Ejercicio: 4 mes 3 año 2025',1,3,'2025-03-18 16:21:13.983',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio: 4 mes 3 año 2025',1,3,'2025-03-18 16:23:45.79',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 2 Ejercicio: 4 mes 3 año 2025',1,3,'2025-03-18 16:23:57.343',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio: 4 mes 3 año 2025',1,3,'2025-03-18 16:25:07.91',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio: 4 mes 3 año 2025',1,3,'2025-03-18 16:34:21.663',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 16:34:39.34',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 3 año 2025',1,3,'2025-03-18 16:35:10.237',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 2 Ejercicio:  mes 3 año 2025',1,3,'2025-03-18 16:35:27.027',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 3 Ejercicio:  mes 3 año 2025',1,3,'2025-03-18 16:36:23.54',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 16:52:36.603',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 16:54:42.61',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:00:18.803',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:01:57.253',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:03:08.86',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:04:01.23',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:09:54.36',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:11:24.157',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:12:49.943',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:17:32.873',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:20:54.317',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:21:35.713',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:21:59.2',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:22:08.307',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:22:47.177',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:23:19.363',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:30:24.127',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:31:45.71',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:39:57.643',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-18 17:41:16.23',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-24 20:45:26.013',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-24 20:53:39.61',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-24 21:04:46.28',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-24 21:05:21.737',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-24 21:07:45.69',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-03-24 21:28:39.513',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 09:58:57.407',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 10:46:08.23',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 10:47:31.78',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:00:22.11',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:01:05.733',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:05:29.763',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:05:46.927',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:06:16.79',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:10:44.903',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:10:58.38',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:11:19.6',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:14:12.323',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:21:15.87',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:21:43.607',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 11:40:41.073',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 12:13:23.1',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 12:18:58.823',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 12:19:22.9',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 12:24:31.013',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 13:25:29.503',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 13:26:29.477',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 13:41:33.28',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 4 año 2025',1,3,'2025-04-03 13:41:38.27',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 4 año 2025',1,3,'2025-04-03 13:41:44.113',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 4 año 2025',1,3,'2025-04-03 13:41:59.477',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 13:42:08.987',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2025',1,3,'2025-04-03 13:42:19.597',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 13:43:19.45',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 13:44:19.183',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 14:10:33.76',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 14:10:39.657',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 14:10:43.06',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMedidasDelUsuarioPorTiempo',N'mensaje de prueba',1,1,'2025-04-03 17:15:56.27',NULL,NULL,NULL),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 17:42:10.62',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 17:42:25.16',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 17:51:18.82',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 18:23:53.847',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMedidasDelUsuarioPorTiempo',N'idCliente: 16, idParametro: 1, idEjercicio: NULL, Espaciado Temporal: individual, Tipo de Búsqueda: año, Meses: 7, Años: 2024,2025, Fecha de Inicio: NULL, Fecha Fin: NULL, Con Detalles: 1',1,1,'2025-04-03 18:24:03.913',NULL,NULL,NULL),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 18:24:09.393',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMedidasDelUsuarioPorTiempo',N'idCliente: 16, idParametro: 1, idEjercicio: NULL, Espaciado Temporal: individual, Tipo de Búsqueda: año, Meses: 7, Años: 2024,2025, Fecha de Inicio: NULL, Fecha Fin: NULL, Con Detalles: 1',1,1,'2025-04-03 19:00:20.79',NULL,NULL,NULL),
	 (N'sp_obtenerMedidasDelUsuarioPorTiempo',N'idCliente: 16, idParametro: 1, idEjercicio: NULL, años2024,2025,Con Detalles: 1',1,1,'2025-04-03 19:00:20.89',NULL,NULL,NULL),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 19:00:24.523',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMedidasDelUsuarioPorTiempo',N'idCliente: 16, idParametro: 1, idEjercicio: NULL, Espaciado Temporal: individual, Tipo de Búsqueda: año, Meses: 7, Años: 2024,2025, Fecha de Inicio: NULL, Fecha Fin: NULL, Con Detalles: 1',1,1,'2025-04-03 19:04:26.61',NULL,NULL,NULL),
	 (N'sp_obtenerMedidasDelUsuarioPOrAñosEspecificos',N'idCliente: 16, idParametro: 1, idEjercicio: NULL, años2024,2025,Con Detalles: 1',1,1,'2025-04-03 19:04:26.697',NULL,NULL,NULL);
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 año 2024',1,3,'2025-04-03 19:04:26.707',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_registrarClaseProgramada',N'547',16,0,'2025-05-06 21:41:41.603',N'Instrucción INSERT en conflicto con la restricción FOREIGN KEY ''FK_ClasesProgramadas_Clase''. El conf',N'27',NULL),
	 (N'sp_registrarClaseProgramada',N'547',16,0,'2025-05-06 21:44:14.18',N'Instrucción INSERT en conflicto con la restricción FOREIGN KEY ''FK_ClasesProgramadas_Clase''. El conf',N'27',NULL),
	 (N'sp_registrarClaseProgramada',N'313',16,2,'2025-05-19 17:01:15.543',N'Se proporcionó un número insuficiente de argumentos para el procedimiento o la función dbo.yaExisteP',N'59',NULL),
	 (N'sp_registrarClaseProgramada',N'4121',16,1,'2025-05-19 17:04:46.89',N'No se encuentra la columna ''dbo'' o la función definida por el usuario o agregado ''dbo.esFiaFestivo'';',N'59',NULL),
	 (N'sp_registrarClaseProgramada',N'4121',16,1,'2025-05-19 17:05:21.51',N'No se encuentra la columna ''dbo'' o la función definida por el usuario o agregado ''dbo.esFiaFestivo'';',N'59',NULL),
	 (N'sp_registrarClaseProgramada',N'4121',16,1,'2025-05-19 17:05:33.323',N'No se encuentra la columna ''dbo'' o la función definida por el usuario o agregado ''dbo.esFiaFestivo'';',N'59',NULL),
	 (N'sp_registrarClaseProgramada',N'515',16,2,'2025-05-20 11:18:26.917',N'No se puede insertar el valor NULL en la columna ''fkEntrenador'', tabla ''FitnessCenterDB.dbo.horarios',N'8',NULL),
	 (N'sp_registrarClaseProgramada',N'515',16,2,'2025-05-20 11:25:41.603',N'No se puede insertar el valor NULL en la columna ''fkEntrenador'', tabla ''FitnessCenterDB.dbo.horarios',N'8',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-02 11:12:51.42',N'1/5 No hay clases por cancelar en ese fecha',N'16',NULL);
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-02 11:14:41.99',N'1/5 No hay clases por cancelar en ese fecha',N'16',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-02 18:44:28.51',N'1/5 No hay clases por cancelar en ese fecha',N'19',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-02 18:45:44.933',N'1/5 No hay clases por cancelar en ese fecha',N'19',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-02 18:59:12.753',N'1/5 No hay clases por cancelar en ese fecha',N'19',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-03 12:21:08.073',N'1/5 No hay clases por cancelar en esa fecha',N'19',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-03 12:30:13.023',N'1/5 No hay clases por cancelar en esa fecha',N'19',NULL),
	 (N'sp_cancelarInscripcionAClase',N'51000',16,1,'2025-06-03 14:14:44.5',N'no existe una insrcipcion con ese id',N'23',NULL),
	 (N'sp_cancelarInscripcionAClase',N'51000',16,1,'2025-06-03 14:14:47.463',N'no existe una insrcipcion con ese id',N'23',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-04 11:47:37.21',N'1/5 No hay clases por cancelar en esa fecha',N'20',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-04 11:51:40.27',N'1/5 No hay clases por cancelar en esa fecha',N'20',NULL);
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-04 11:54:13.197',N'1/5 No hay clases por cancelar en esa fecha',N'20',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-04 12:05:14.1',N'1/5 No hay clases por cancelar en esa fecha',N'20',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-04 12:05:58.37',N'1/5 No hay clases por cancelar en esa fecha',N'20',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-04 12:06:11.91',N'1/5 No hay clases por cancelar en esa fecha',N'20',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-04 12:07:41.69',N'1/5 No hay clases por cancelar en esa fecha',N'20',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-04 12:21:28.743',N'1/5 No hay clases por cancelar en esa fecha',N'20',NULL),
	 (N'sp_registrarClaseProgramada',N'547',16,0,'2025-06-11 14:17:04.263',N'Instrucción INSERT en conflicto con la restricción FOREIGN KEY ''FK_horasLborales_horariosClasesProgr',N'9',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-11 15:46:44.26',N'1/5 No hay clases por cancelar en esa fecha',N'21',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-11 15:46:55.983',N'1/5 No hay clases por cancelar en esa fecha',N'21',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-11 15:53:53.767',N'No se encontraron clases activas para cancelar',N'60',NULL);
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_procesoCompletoCancelacionDeInscripcionAClase',N'51000',16,1,'2025-06-12 11:51:49.477',N'Esa inscripción no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.',N'11',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'51000',16,1,'2025-06-12 12:37:32.07',N'Esa inscripción no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.',N'11',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'50000',16,1,'2025-06-12 13:37:33.003',N'Estás intentando reagendar una clase diferente a la original.',N'32',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'51000',16,1,'2025-06-12 13:52:52.933',N'Esa inscripción no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.',N'11',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'51000',16,1,'2025-06-12 14:48:06.39',N'Esa inscripción no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.',N'11',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'51000',16,1,'2025-06-12 14:49:24.13',N'Esa inscripción no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.',N'11',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'50000',16,1,'2025-06-12 14:53:37.333',N'Estás intentando reagendar una clase diferente a la original.',N'32',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'50000',16,1,'2025-06-12 14:54:00.233',N'Estás intentando reagendar una clase diferente a la original.',N'32',NULL),
	 (N'sp_registrarInsrcipcionAClase',N'50000',16,1,'2025-07-30 15:25:07.633',N'Ya no hay cupos disponibles para esa clase',N'18',NULL),
	 (N'sp_registrarCita',N'242',16,3,'2025-09-30 15:44:15.507',N'La conversión del tipo de datos nvarchar en datetime produjo un valor fuera de intervalo.',N'22',NULL);
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_registrarCita',N'La conversión del tipo de datos nvarchar en datetime produjo un valor fuera de intervalo.22',16,3,'2025-09-30 16:32:15.34',N'aaronlogin',N'fedora',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_registrarCita',N'La conversión del tipo de datos nvarchar en datetime produjo un valor fuera de intervalo.24  Sep 30 2025  4:46PM Sep 30 2025  5:46PM',16,3,'2025-09-30 16:46:58.277',N'aaronlogin',N'fedora',N'Core Microsoft SqlClient Data Provider');



	 INSERT INTO FitnessCenterDB.dbo.Roles (NombreRol) VALUES
	 (N'cliente'),
	 (N'empleado');

INSERT INTO FitnessCenterDB.dbo.TipoRutina (nombreTipoRutina,fechaDeCreacion,fechaDeModificacion) VALUES
	 (N'clase','2025-04-16 12:44:46.527','2025-04-16 12:44:46.527'),
	 (N'personal','2025-04-16 12:44:46.527','2025-04-16 12:44:46.527');






	 -- Export ordenado de datos FitnessCenterDB (Grupo 1 en orden a partir de __EFMigrationsHistory)

-- __EFMigrationsHistory
INSERT INTO FitnessCenterDB.dbo.[__EFMigrationsHistory] (MigrationId,ProductVersion) VALUES
	 (N'20250806212755_IdentityInicial',N'8.0.19'),
	 (N'20250813001705_SeedRoles',N'8.0.19'),
	 (N'20250813002524_SeedRoles2',N'8.0.19'),
	 (N'20250813003236_SeedRoles3',N'8.0.19'),
	 (N'20250813210445_NumeroDeIdentificacionAdded',N'8.0.19'),
	 (N'20250813210639_NumeroDeIdentificacionAdded2',N'8.0.19'),
	 (N'20250820181715_DireccionAndFechaAdded',N'8.0.19'),
	 (N'20250820185017_SeedUsuariosActualizados',N'8.0.19'),
	 (N'20250904004429_AddedTokenTables',N'8.0.19'),
	 (N'20250911183018_addmisinguusariosfields',N'8.0.19');
INSERT INTO FitnessCenterDB.dbo.[__EFMigrationsHistory] (MigrationId,ProductVersion) VALUES
	 (N'20250911185215_addIdAntiguoField',N'8.0.19'),
	 (N'20250915191036_addedNewFkFieldsForAspnetusersRelations',N'8.0.19');

-- AspNetRoles
INSERT INTO FitnessCenterDB.dbo.AspNetRoles (Id,Name,NormalizedName,ConcurrencyStamp) VALUES
	 (N'1',N'empleado',N'EMPLEADO',NULL),
	 (N'2',N'cliente',N'CLIENTE',NULL);

-- AspNetUsers
INSERT INTO FitnessCenterDB.dbo.AspNetUsers (Id,NombreCompleto,UserName,NormalizedUserName,Email,NormalizedEmail,EmailConfirmed,PasswordHash,SecurityStamp,ConcurrencyStamp,PhoneNumber,PhoneNumberConfirmed,TwoFactorEnabled,LockoutEnd,LockoutEnabled,AccessFailedCount,NumeroDeIdentificacion,Direccion,FechaDeNacimiento,Apellido,Estado,FechaDeRegistro,IdAntiguo) VALUES
	 (N'44e25915-a3df-4bdb-8520-07dca77ecb69',N'Rebeca',N'rebeca@gmail.com',N'REBECA@GMAIL.COM',N'rebeca@gmail.com',N'REBECA@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEAlR4VRZOCaRSFVeGIQDPEnLXDCuI9qdt+9MhRfdw2vCGy+WV9pFwMKhF+0x4pg1jQ==',N'V2FZC6Q32QDD7AL5ECPAXIWAAOXZR273',N'7224b2ec-2edd-49d0-89a5-9b9d0f9a32e7',N'9999999',0,0,NULL,1,0,N'ROROA3334',N'aslalalsa','2024-08-17 00:00:00.0000000',N'delgado',N'activo','0001-01-01 00:00:00.0000000',17),
	 (N'5696d821-ab0c-40d5-9cd2-123232bc4eec',N'matias',N'matias@gmail.com',N'MATIAS@GMAIL.COM',N'matias@gmail.com',N'MATIAS@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEFEPyneTGhticpIqlRp0ScT1ycIa05W+SuOgM45yKkIaQhtTZDXeHNVb0TqLDRMk4w==',N'ECU5XD2BC3FCLC7OSVCITFHDZJUVZ5CK',N'aa24b10e-e8e6-4064-8e1a-33bf6ce2f3bc',N'9999999',0,0,NULL,1,0,N'RORA12350',N'aslalalsa','2024-08-06 00:00:00.0000000',N'botero',N'activo','0001-01-01 00:00:00.0000000',16),
	 (N'574820a9-b28b-4b37-a665-029d2f41e272',N'Valeria',N'valeriag@gmail.com',N'VALERIAG@GMAIL.COM',N'valeriag@gmail.com',N'VALERIAG@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEBu6np9P4Qo0qwjSt7I1E2utQXI34GXD4D+ASchriTMkzpw7k6UTxclxC2ewrEnDyw==',N'CCGYZQ4XVQR6AISH5SA3GW7VOY3RAKRT',N'550a096c-69c9-4489-b318-9f42eaa1cd92',N'9999999',0,0,NULL,1,0,N'ROROA3334',N'aslalalsa','1998-10-06 00:00:00.0000000',N'Gomez',N'activo','0001-01-01 00:00:00.0000000',19),
	 (N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'Yesenia',N'yesyes@gmail.com',N'YESYES@GMAIL.COM',N'yesyes@gmail.com',N'YESYES@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEGFV7o2rnKEDIcs3F/c8G4UVZOn0MsY2lUn8iJtL0xw6rhRzB/ueP5TrOI/upqRQPA==',N'PAVNRX6B7H3OILFOEDBBJM2ZLLKXZ2N2',N'f00ddca9-192b-4a88-aec7-cb5139354919',N'9999999',0,0,NULL,1,0,N'RORA12350',N'aslalalsa','0001-11-15 00:00:00.0000000',N'esquivel',N'activo','0001-01-01 00:00:00.0000000',15),
	 (N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5',N'Juan',N'aaronhl1313@gmail.com',N'AARONHL1313@GMAIL.COM',N'aaronhl1313@gmail.com',N'AARONHL1313@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEIdeJlW2345fcSJLtEqSGyqmUV+l9kqkpGI1lvxfSvcxQzd4onsxsL1Gp8oa47nOTQ==',N'E6OO45X37OYE5ZSTBR42ZDCYASXJIF5I',N'dd0b6615-1ee2-441c-83b6-792d30f0f07c',N'9999999',0,0,NULL,1,0,N'RORO12350',N'aslalalsa','2024-01-15 00:00:00.0000000',N'Martinez',N'activo','0001-01-01 00:00:00.0000000',3),
	 (N'e47637e0-1971-4e46-99fb-186db0847fac',N'aaron',N'uno@gmail.com',N'UNO@GMAIL.COM',N'uno@gmail.com',N'UNO@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEL3XDmXzqqKV8bEy/ZCfViYt6Nl+QxhL5R239sV3Oliu7Y+3+j2ZjviDRXli+4h0Bg==',N'HPTR4SJOAVCGNCXHJPXQXD4COT55K2TP',N'56be8c9f-7b09-409f-b920-42971f19ef95',N'+522263647876',0,0,NULL,1,0,N'V777AA6777',N'123 Calle Principal, ciudad de mexico, Mexico','1959-05-15 00:00:00.0000000',N'Azcarraga',N'activo','2025-09-11 12:39:17.3200000',13),
	 (N'ec4a4f9d-02b8-402a-b274-8924adb46e46',N'antonio',N'antoniom@gmail.com',N'ANTONIOM@GMAIL.COM',N'antoniom@gmail.com',N'ANTONIOM@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEPVSSb1GEl6j2K5kbJ/EaE/2nUUIB4hFJKAuK6YYe/Wp5WBxPT1/UZr62t0lYSpwvw==',N'SBFEQMKV5F63Y6XB3NUK3HZQTALELKHD',N'c33ab3eb-ca17-420a-a741-f6d13275d6f4',N'9999999',0,0,NULL,1,0,N'ROROA3334',N'aslalalsa','2025-04-16 00:00:00.0000000',N'marquez',N'activo','0001-01-01 00:00:00.0000000',22);

-- Descuentos (vacío)

-- Roles
INSERT INTO FitnessCenterDB.dbo.Roles (RolID,NombreRol) VALUES
	 (1,N'cliente'),
	 (2,N'empleado');

-- Servicios (vacío)

-- TipoRutina
INSERT INTO FitnessCenterDB.dbo.TipoRutina (idTipoRutina,nombreTipoRutina,fechaDeCreacion,fechaDeModificacion) VALUES
	 (1,N'clase','2025-04-16 12:44:46.527','2025-04-16 12:44:46.527'),
	 (2,N'personal','2025-04-16 12:44:46.527','2025-04-16 12:44:46.527');

-- __EFMigrationsHistory ya incluido arriba

-- duracionCitas
INSERT INTO FitnessCenterDB.dbo.duracionCitas (DuracionID,Duracion,FrecuenciaNotificaciones) VALUES
	 (3,1,15);

-- estadosClasesProgramadas
INSERT INTO FitnessCenterDB.dbo.estadosClasesProgramadas (idEstadoClaseProgramada,nombresEstado,fechaCreacion,fechaModificacion) VALUES
	 (1,N'disponible','2025-04-16 12:25:39.853','2025-04-16 12:25:39.853'),
	 (2,N'no disponible','2025-04-16 12:25:39.853','2025-04-16 12:25:39.853'),
	 (3,N'cancelada','2025-04-16 12:25:39.853','2025-04-16 12:25:39.853');

-- estadosDeActividadLaboral
INSERT INTO FitnessCenterDB.dbo.estadosDeActividadLaboral (idEstadoActividadLaboral,nombreEstadoActividadLaboral,fechaCreacion,fcehaModificacion) VALUES
	 (1,N'no se labora','2025-05-14 11:43:09.443','2025-05-14 11:43:09.443'),
	 (2,N'si se labora','2025-05-14 11:43:09.443','2025-05-14 11:43:09.443');

-- estadosDeClases
INSERT INTO FitnessCenterDB.dbo.estadosDeClases (idEstadoClase,nombreEstado,descripcionEstado,fechaCreacion,fechaModificacion) VALUES
	 (1,N'Activa',N'La clase está activa y disponible para inscripciones','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47'),
	 (2,N'Inactiva',N'La clase está temporalmente suspendida','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47'),
	 (3,N'Cancelada',N'La clase ha sido cancelada permanentemente','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47'),
	 (4,N'Completa',N'La clase ha alcanzado su cupo máximo','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47');

-- estadosHorarioClaseProgramada
INSERT INTO FitnessCenterDB.dbo.estadosHorarioClaseProgramada (idEstadoHorarioClase,nombreEstadoHorario,fechaCreacion,fechaModificacion) VALUES
	 (1,N'activo','2025-05-07 14:42:05.153','2025-05-07 14:42:05.153'),
	 (2,N'cancelada','2025-05-07 14:42:05.153','2025-05-07 14:42:05.153');

-- estadosInscripciones
INSERT INTO FitnessCenterDB.dbo.estadosInscripciones (idEstadoInscripcion,nombreEstadoInscripcion,fechaCreacion,fechaModificacion) VALUES
	 (1,N'vigente','2025-05-30 14:19:13.587','2025-05-30 14:19:13.587'),
	 (2,N'en curso','2025-05-30 14:19:13.587','2025-05-30 14:19:13.587'),
	 (3,N'terminada','2025-05-30 14:19:13.587','2025-05-30 14:19:13.587'),
	 (4,N'cancelada','2025-05-30 14:19:13.587','2025-05-30 14:19:13.587'),
	 (5,N'pendiente de aprobacion','2025-05-30 14:19:13.587','2025-05-30 14:19:13.587');

-- horasLaborales
INSERT INTO FitnessCenterDB.dbo.horasLaborales (idHora,horaInicio,horaFin,fechaCreacion,fechaModificacion) VALUES
	 (1,'08:00:00.0000000','09:00:00.0000000','2025-05-05 19:56:39.733','2025-05-05 19:56:39.733'),
	 (2,'09:00:00.0000000','10:00:00.0000000','2025-05-05 19:56:39.733','2025-05-05 19:56:39.733'),
	 (3,'10:00:00.0000000','11:00:00.0000000','2025-05-05 19:56:39.733','2025-05-05 19:56:39.733'),
	 (4,'11:00:00.0000000','12:00:00.0000000','2025-05-05 19:56:39.733','2025-05-05 19:56:39.733'),
	 (5,'12:00:00.0000000','13:00:00.0000000','2025-05-05 19:56:39.733','2025-05-05 19:56:39.733'),
	 (6,'14:00:00.0000000','15:00:00.0000000','2025-05-05 19:56:39.733','2025-05-05 19:56:39.733'),
	 (7,'15:00:00.0000000','16:00:00.0000000','2025-05-05 19:56:39.733','2025-05-05 19:56:39.733'),
	 (8,'16:00:00.0000000','17:00:00.0000000','2025-05-05 19:56:39.733','2025-05-05 19:56:39.733'),
	 (9,'17:00:00.0000000','18:00:00.0000000','2025-05-05 19:56:39.733','2025-05-05 19:56:39.733'),
	 (10,'18:00:00.0000000','19:00:00.0000000','2025-05-05 19:56:39.733','2025-05-05 19:56:39.733');

-- iconsForParameters
INSERT INTO FitnessCenterDB.dbo.iconsForParameters (iconId,nombre,urlPrivada,urlPublica) VALUES
	 (1,N'pesas',N'/home/aaron/archivosl/general/estudio/proyectos/gymwebapp linux/GymFrontend/wwwroot/content/gymworkout.png',N'/content/gymworkout.png'),
	 (2,N'fuerza',N'/home/aaron/archivosl/general/estudio/proyectos/gymwebapp linux/GymFrontend/wwwroot/content/strenght.png.png',N'/content/strenght.png'),
	 (3,N'Mancuernas Ligeras',N'../img/svgmacuerna.svg',N'../img/svgmacuerna.svg'),
	 (4,N'Klettlebells',N'../img/svgmacuerna.svg',N'../img/svgklettlebells.svg'),
	 (5,N'Esterilla',N'../img/esterilla.svg',N'../img/esterilla.svg'),
	 (6,N'Botella de agua',N'../img/aquabottle.svg',N'../img/esterilla.svg'),
	 (7,N'corazon',N'../img/heart.svg',N'../img/heart.svg'),
	 (8,N'flama',N'../img/flame.svg',N'../img/flame.svg'),
	 (9,N'acceso24',N'../img/svgacceso24black.svg',N'../img/svgacceso24black.svg');

-- intenciones
INSERT INTO FitnessCenterDB.dbo.intenciones (intencionId,nombre,fechaDeRegistro,fechaModificacionDeRegistro) VALUES
	 (1,N'disminuir','2024-12-31 12:02:56.303',NULL),
	 (2,N'aumentar','2024-12-31 12:02:56.303',NULL),
	 (3,N'mantener','2024-12-31 12:02:56.303',NULL);

-- nivelesDeDificultadDeClase
INSERT INTO FitnessCenterDB.dbo.nivelesDeDificultadDeClase (idNivelDeDificultadDeClase,nombreNivelDeDificultad,fechaDeCreacion,fechaDeModificacion) VALUES
	 (1,N'principiante',NULL,NULL),
	 (2,N'intermedio',NULL,NULL),
	 (3,N'avanzado',NULL,NULL);

-- nivelesDeIntensidadDeClase
INSERT INTO FitnessCenterDB.dbo.nivelesDeIntensidadDeClase (idNivelDeIntensidad,nombreNivelDeIntensidad,fechaDeCreacion) VALUES
	 (1,N'baja','2025-04-15 18:01:10.103'),
	 (2,N'media','2025-04-15 18:01:10.103'),
	 (3,N'alta','2025-04-15 18:01:10.103');

-- nivelesDeLogro
INSERT INTO FitnessCenterDB.dbo.nivelesDeLogro (idNivelDeLogro,nombre,fechaDeRegistro,fechaModificacionDeRegistro) VALUES
	 (1,N'no conseguida','2024-12-31 11:21:39.54','2024-12-31 11:21:39.54'),
	 (2,N'alcanzada','2024-12-31 11:21:39.54','2024-12-31 11:21:39.54'),
	 (3,N'superada','2024-12-31 11:21:39.54','2024-12-31 11:21:39.54');

-- sysdiagrams (no hay archivo)

-- tiposDeRecurrenciaDeDiasFestivos
INSERT INTO FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos (idTipoDeRecurrenciaDeDiaFestivo,nombreTipoDeRecurrencia,descripcion,fechaCreacion,fechaModificacion) VALUES
	 (1,N'semanal',N'Se repite cada semana, es un o unos dias especificos de la semana, por ejemplo domingo o sabao y domingo','2025-05-14 14:42:43.34',NULL),
	 (2,N'mensual',N'Se repite cada mes en una fecha fija,no es comun pero debe tomarse en cuenta','2025-05-14 14:42:43.34',NULL),
	 (3,N'anual',N'Se repite cada año en una fecha fija, por ejemplo 10 de mayo,2 de noviembre','2025-05-14 14:42:43.34',NULL),
	 (4,N'semanaDia',N'Se repite pero la fecha es variable,por ejemplo dia del padre','2025-05-14 14:42:43.34','2025-05-16 11:46:05.737'),
	 (5,N'diaRelativo',N'pensado para los dias de descanso establecidos de fin de semana, osea un dia de la semana tal cual,sabado,domingo,sin importar el mes,año o semana','2025-05-16 11:49:03.813',NULL),
	 (6,N'diaConsecutivo',N'un dia del año especifico considerando su numero consecutivo en el año,osea 1-365,por ejemplo dia del programador que es el dia 256 del año','2025-05-16 11:51:06.347',NULL);

-- unidadesDeMedida
INSERT INTO FitnessCenterDB.dbo.unidadesDeMedida (unidadDeMedidaId,nombre,fechaDeRegistro,fechaModificacionDeRegistro) VALUES
	 (1,N'kg','2024-12-30 14:54:34.76',NULL),
	 (2,N' kg/m²','2024-12-30 14:54:34.76',NULL),
	 (3,N'm','2024-12-30 15:30:49.63',NULL);

-- =============================
-- Grupo 2: Tablas con dependencias de Grupo 1
-- =============================

-- AccessTokens (GRAN VOLUMEN): se añadirá en la siguiente parte

-- AspNetRoleClaims (vacío)

-- AspNetUserClaims (vacío)

-- AspNetUserLogins (vacío)

-- AspNetUserRoles
SET IDENTITY_INSERT dbo.AspNetUserRoles ON;
INSERT INTO FitnessCenterDB.dbo.AspNetUserRoles (UserId,RoleId) VALUES
	 (N'5696d821-ab0c-40d5-9cd2-123232bc4eec',N'1'),
	 (N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'1'),
	 (N'e47637e0-1971-4e46-99fb-186db0847fac',N'1'),
	 (N'ec4a4f9d-02b8-402a-b274-8924adb46e46',N'1'),
	 (N'44e25915-a3df-4bdb-8520-07dca77ecb69',N'2'),
	 (N'574820a9-b28b-4b37-a665-029d2f41e272',N'2'),
	 (N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5',N'2'),
	 (N'e47637e0-1971-4e46-99fb-186db0847fac',N'2');
SET IDENTITY_INSERT dbo.AspNetUserRoles OFF;
-- AspNetUserTokens (vacío)

-- Citas
SET IDENTITY_INSERT dbo.Citas ON;
INSERT INTO FitnessCenterDB.dbo.Citas (CitaID,FechaHora,TipoCita,Estado,FechaHoraFin,EntrenadorId,UserId) VALUES
	 (9,'2024-08-15 12:54:00.0',N'Entrenamiento Personal',N'Completada','2024-08-15 14:54:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (10,'2024-08-10 12:56:00.0',N'Medicion',N'Cancelada','2024-08-10 23:56:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (11,'2024-08-16 14:02:00.0',N'Medicion',N'Completada','2024-08-16 21:02:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (12,'2024-08-16 14:09:00.0',N'Medicion',N'Completada','2024-08-16 21:09:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (13,'2024-08-16 14:17:00.0',N'Medicion',N'Completada','2024-08-16 21:17:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (14,'2024-08-31 16:44:00.0',N'Medicion',N'Completada','2024-08-31 23:44:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (15,'2024-08-16 22:53:00.0',N'Medicion',N'Completada','2024-08-17 05:53:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (16,'2024-08-17 22:55:00.0',N'Medicion',N'Completada','2024-08-17 05:55:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (17,'2024-08-17 00:28:00.0',N'Medicion',N'Agendada','2024-08-17 03:28:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (18,'2024-08-17 01:57:00.0',N'Medicion',N'Completada','2024-08-17 06:57:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'574820a9-b28b-4b37-a665-029d2f41e272');
INSERT INTO FitnessCenterDB.dbo.Citas (CitaID,FechaHora,TipoCita,Estado,FechaHoraFin,EntrenadorId,UserId) VALUES
	 (25,'2025-09-30 16:55:00.0',N'Medicion',N'Agendada','2025-09-30 17:55:00.0',N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (26,'2025-09-30 17:01:00.0',N'Medicion',N'Agendada','2025-09-30 18:01:00.0',N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (27,'2025-09-30 17:10:00.0',N'Medicion',N'Agendada','2025-09-30 18:10:00.0',N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (28,'2025-09-30 17:20:00.0',N'Medicion',N'Agendada','2025-09-30 18:20:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (29,'2025-10-01 13:52:00.0',N'Medicion',N'Agendada','2025-10-01 14:52:00.0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'574820a9-b28b-4b37-a665-029d2f41e272');
SET IDENTITY_INSERT dbo.Citas OFF;
-- Clases
SET IDENTITY_INSERT dbo.Clases ON;
INSERT INTO FitnessCenterDB.dbo.Clases (ClaseID,NombreClase,Cupo,Descripcion,duracionEnMinutos,fkIntensidad,fkDificultad,tiempoDeDescansoEnMinutos,duracionEnMinutosConDescansoIncluido,fkEstadoClase,InstructorId) VALUES
	 (1,N'pecho',10,N'ejericios para desarrollar pecho',NULL,NULL,NULL,15,60,1,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (2,N'pecho',10,N'ejericios para desarrollar pecho',NULL,NULL,NULL,15,60,1,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (5,N'Hiit',10,N' El Entrenamiento por Intervalos de Alta Intensidad (HIIT) alterna entre ráfagas intensas de actividad y períodos fijos de actividad menos intensa o descanso. Nuestras clases HIIT están diseñadas para aumentar tu ritmo cardíaco y quemar más grasa en menos tiempo.
Este tipo de entrenamiento te proporciona un entrenamiento completo mientras mejora tu condición cardiovascular y maximiza la quema de calorías. Los estudios han demostrado que el HIIT puede quemar hasta un 30% más de calorías que otras formas de cardio en el mismo período de tiempo. ',45,2,3,15,60,1,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (6,N'Crossfit',10,N' El Entrenamiento por Intervalos de Alta Intensidad (HIIT) alterna entre ráfagas intensas de actividad y períodos fijos de actividad menos intensa o descanso. Nuestras clases HIIT están diseñadas para aumentar tu ritmo cardíaco y quemar más grasa en menos tiempo.
Este tipo de entrenamiento te proporciona un entrenamiento completo mientras mejora tu condición cardiovascular y maximiza la quema de calorías. Los estudios han demostrado que el HIIT puede quemar hasta un 30% más de calorías que otras formas de cardio en el mismo período de tiempo. ',45,3,3,15,60,1,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (7,N'Fuerza y potencia',10,NULL,45,3,3,15,60,1,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (8,N'Boxeo',10,NULL,45,2,1,15,60,1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (9,N'Entrenamiento Funcional',10,NULL,45,1,1,15,60,1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (10,N'Entrenamiento Personal',10,NULL,45,1,3,15,60,1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (12,N'Yoga Avanzado',20,N'Sesión de yoga nivel avanzado enfocada en flexibilidad y respiración.',45,2,3,15,60,1,N'8094a747-55d9-4782-9b31-b6602a79b7ed');
SET IDENTITY_INSERT dbo.Clases OFF;
-- Cupones (vacío)

-- Ejercicios
SET IDENTITY_INSERT dbo.Ejercicios ON;
INSERT INTO FitnessCenterDB.dbo.Ejercicios (EjercicioID,NombreEjercicio,TipoEjercicio,Descripcion,fkIcon) VALUES
	 (1,N'Dominadas',N'Peso',N'levantamiento con los brazos colgado a una barra',NULL),
	 (2,N'Abdominales',N'AMRAP',N'flexiones de abdomen acostado',NULL),
	 (4,N'peso muerto',N'Peso',N'levantamiento de peso muerto convencional',1),
	 (8,N'Burpees',N'AMRAP',N'Ejercicio de cuerpo completo que combina sentadilla, plancha, flexión y salto. Excelente para desarrollar resistencia cardiovascular y fuerza.',NULL),
	 (9,N'Mountain Climbers',N'Tiempo',N'En posición de plancha, alternamos llevando las rodillas hacia el pecho. Trabaja el core y eleva el ritmo cardíaco.',NULL),
	 (10,N'Jumping Jacks',N'Tiempo',N'Saltos abriendo y cerrando piernas y brazos simultáneamente. Excelente ejercicio cardiovascular que involucra todo el cuerpo.',NULL),
	 (11,N'Sentadillas con Salto',N'AMRAP',N'Sentadilla tradicional seguida de un salto explosivo. Desarrolla potencia en el tren inferior y eleva el ritmo cardíaco.',NULL),
	 (12,N'Planchas Laterales',N'Tiempo',N'Mantenemos el cuerpo recto apoyados sobre un antebrazo y el lateral del pie. Fortalece el core y los estabilizadores laterales.',NULL),
	 (13,N'High Knees',N'Tiempo',N'Carrera estática elevando las rodillas al máximo. Excelente ejercicio cardiovascular que también trabaja el core.',NULL);
	 SET IDENTITY_INSERT dbo.Ejercicios OFF;
-- Equipos
SET IDENTITY_INSERT dbo.Equipos ON;
INSERT INTO FitnessCenterDB.dbo.Equipos (EquipoID,NombreEquipo,Descripcion,fkIcon) VALUES
	 (1,N'Mancuernas Ligeras',N'Para añadir resistencia a ejercicios como sentadillas o press de hombros.',3),
	 (2,N'Kettlebells',N'Ideales para ejercicios balísticos como swings o clean and press.',4),
	 (3,N'Esterilla',N'Para mayor comodidad en ejercicios de suelo como planchas o abdominales.',5),
	 (4,N'Botella de Agua',N'Fundamental para mantenerte hidratado durante el entrenamiento intenso.',6);
	 SET IDENTITY_INSERT dbo.Equipos OFF;
-- Pagos (vacío)

-- RefreshTokens (GRAN VOLUMEN): se añadirá en la siguiente parte

-- Usuarios
SET IDENTITY_INSERT dbo.Equipos ON;
INSERT INTO FitnessCenterDB.dbo.Usuarios (UsuarioID,Nombre,Apellido,Email,Telefono,NombreUsuario,Contrasena,FechaNacimiento,FechaRegistro,RolID,Estado) VALUES
	 (3,N'Juan',N'Martinez',N'aaronhl1313@gmail.com',N'9999999',N'elusuario',N'password123','2024-01-15','2024-07-19 14:32:30.477',1,N'activo'),
	 (13,N'aaron',N'Azcarraga',N'uno@gmail.com',N'2291250501',N'elusuario20/07/2024 03:15:36 p. m.',N'password1','2024-07-16','2024-07-20 15:15:38.87',2,N'activo'),
	 (15,N'Yesenia',N'esquivel',N'yesyes@gmail.com',N'33289392929',N'yes92',N'yes123','2024-11-15','2024-08-03 03:38:05.413',2,N'activo'),
	 (16,N'matias',N'botero',N'matias@gmail.com',N'+522291250501',N'elusuario10/08/2024 12:17:41 a. m.',N'$2a$11$amSmPDPY/lzbqu1BGS.Q0O6cq0tlb.m.sOHr7yij6hwzQtFn0xhnK','2024-08-06','2024-08-10 00:17:45.923',2,N'activo'),
	 (17,N'Rebeca',N'delgado',N'rebeca@gmail.com',N'227372828399',N'elusuario17/08/2024 01:24:35 a. m.',N'$2a$11$at7qAllPsGTMSrzEBiacYerCbDNAyjVJTsApHPfHS69iUIUk7vNr.','2024-08-17','2024-08-17 01:24:44.85',1,N'activo'),
	 (19,N'Valeria',N'Gomez',N'valeriag@gmail.com',N'337483839202',N'elusuario17/08/2024 01:31:50 a. m.',N'$2a$11$aKH3BpGNJtDqBopYlLTABulWQx9lRYembOjJtSjfl/B.nB9kRSDHG','1998-10-06','2024-08-17 01:31:50.3',1,N'activo'),
	 (22,N'antonio',N'marquez',N'antoniom@gmail.com',N'2237940475',N'elusuario30/4/2025 11:15:06',N'$2a$11$g4MxQsmf4jbLP5J3IjtZkuJYTFjSaG9zpHS0gwERelpN56hQNl1e2','2025-04-16','2025-04-30 11:15:06.423',2,N'activo');
SET IDENTITY_INSERT dbo.Equipos OFF;
-- diasFestivosVariables (pendiente, no leído aún)
-- diasFestivosYDescansos (pendiente, no leído aún)

-- parametrosDeMedicion
SET IDENTITY_INSERT dbo.parametrosDeMedicion ON;
INSERT INTO FitnessCenterDB.dbo.parametrosDeMedicion (parametroMedicionId,nombre,fechaDeRegistro,fechaModificacionDeRegistro,fkIcon) VALUES
	 (1,N'peso','2024-12-30 15:08:38.46',NULL,NULL),
	 (2,N'imc','2024-12-30 15:08:38.46',NULL,NULL),
	 (3,N'altura','2024-12-30 15:31:14.317',NULL,NULL),
	 (4,N'fuerza','2025-01-08 12:48:35.283',NULL,2);
SET IDENTITY_INSERT dbo.parametrosDeMedicion OFF;
-- preReservasDeHorario
SET IDENTITY_INSERT dbo.preReservasDeHorario ON;
INSERT INTO FitnessCenterDB.dbo.preReservasDeHorario (idPreReserva,fechaInicioDeLaReserva,fechaDeExpiracionDeLaReserva,fkHoraLaboral,idUsuarioQueReserva,fechaReservada) VALUES
	 (95,'2025-08-04 17:33:36.06','2025-08-04 17:38:36.06',5,N'16','2025-09-30'),
	 (96,'2025-08-04 17:33:43.34','2025-08-04 17:38:43.34',4,N'16','2025-09-30'),
	 (97,'2025-08-04 17:34:02.727','2025-08-04 17:39:02.727',8,N'16','2025-09-30'),
	 (98,'2025-08-04 17:34:26.69','2025-08-04 17:39:26.69',9,N'16','2025-09-30'),
	 (99,'2025-08-04 17:51:06.703','2025-08-04 17:56:06.703',7,N'16','2025-09-30'),
	 (100,'2025-08-05 15:26:23.38','2025-08-05 15:31:23.38',1,N'16','2025-08-05'),
	 (101,'2025-08-05 15:38:55.993','2025-08-05 15:43:55.993',5,N'16','2025-08-05'),
	 (102,'2025-09-22 15:00:03.557','2025-09-22 15:05:03.557',5,N'16','2025-09-22'),
	 (103,'2025-09-22 15:47:43.27','2025-09-22 15:52:43.27',5,N'16','2025-09-22'),
	 (104,'2025-09-22 15:47:43.27','2025-09-22 15:52:43.27',7,N'16','2025-09-22');
INSERT INTO FitnessCenterDB.dbo.preReservasDeHorario (idPreReserva,fechaInicioDeLaReserva,fechaDeExpiracionDeLaReserva,fkHoraLaboral,idUsuarioQueReserva,fechaReservada) VALUES
	 (105,'2025-09-22 15:47:43.41','2025-09-22 15:52:43.41',10,N'16','2025-09-22'),
	 (106,'2025-09-22 15:47:43.86','2025-09-22 15:52:43.86',6,N'16','2025-09-22'),
	 (107,'2025-09-22 15:47:43.86','2025-09-22 15:52:43.86',8,N'16','2025-09-22'),
	 (108,'2025-09-22 15:47:43.86','2025-09-22 15:52:43.86',9,N'16','2025-09-22'),
	 (109,'2025-09-22 15:47:43.86','2025-09-22 15:52:43.86',3,N'16','2025-09-22'),
	 (110,'2025-09-22 15:47:43.86','2025-09-22 15:52:43.86',4,N'16','2025-09-22'),
	 (111,'2025-09-22 15:47:43.86','2025-09-22 15:52:43.86',1,N'16','2025-09-22'),
	 (112,'2025-09-22 15:47:43.86','2025-09-22 15:52:43.86',2,N'16','2025-09-22'),
	 (113,'2025-09-23 13:04:21.273','2025-09-23 13:09:21.273',1,N'16','2025-09-23'),
	 (114,'2025-09-23 13:12:03.49','2025-09-23 13:17:03.49',3,N'16','2025-09-23');
INSERT INTO FitnessCenterDB.dbo.preReservasDeHorario (idPreReserva,fechaInicioDeLaReserva,fechaDeExpiracionDeLaReserva,fkHoraLaboral,idUsuarioQueReserva,fechaReservada) VALUES
	 (115,'2025-09-23 13:29:24.29','2025-09-23 13:34:24.29',5,N'16','2025-09-23'),
	 (116,'2025-09-23 13:45:16.067','2025-09-23 13:50:16.067',5,N'16','2025-09-23'),
	 (117,'2025-09-23 13:57:33.0','2025-09-23 14:02:33.0',3,N'16','2025-09-23'),
	 (118,'2025-09-23 14:37:36.337','2025-09-23 14:42:36.337',5,N'16','2025-09-23'),
	 (119,'2025-09-23 15:06:47.48','2025-09-23 15:11:47.48',1,N'16','2025-09-23'),
	 (120,'2025-09-23 15:12:53.467','2025-09-23 15:17:53.467',3,N'16','2025-09-23'),
	 (121,'2025-09-23 15:14:52.193','2025-09-23 15:19:52.193',6,N'16','2025-09-23'),
	 (122,'2025-09-23 15:16:34.597','2025-09-23 15:21:34.597',2,N'16','2025-09-23'),
	 (123,'2025-09-23 15:18:04.63','2025-09-23 15:23:04.63',8,N'16','2025-09-23'),
	 (124,'2025-09-23 15:18:15.677','2025-09-23 15:23:15.677',4,N'16','2025-09-23');
INSERT INTO FitnessCenterDB.dbo.preReservasDeHorario (idPreReserva,fechaInicioDeLaReserva,fechaDeExpiracionDeLaReserva,fkHoraLaboral,idUsuarioQueReserva,fechaReservada) VALUES
	 (125,'2025-09-23 15:18:49.94','2025-09-23 15:23:49.94',7,N'16','2025-09-23'),
	 (126,'2025-09-23 15:18:57.663','2025-09-23 15:23:57.663',9,N'16','2025-09-23'),
	 (127,'2025-09-23 15:24:40.88','2025-09-23 15:29:40.88',8,N'16','2025-09-23'),
	 (128,'2025-09-23 15:26:23.447','2025-09-23 15:31:23.447',9,N'16','2025-09-23'),
	 (129,'2025-09-24 14:33:56.21','2025-09-24 14:38:56.21',2,N'16','2025-09-24'),
	 (131,'2025-09-24 16:21:30.14','2025-09-24 16:26:30.14',1,N'16','2025-09-24'),
	 (132,'2025-09-24 16:21:55.843','2025-09-24 16:26:55.843',7,N'16','2025-09-24'),
	 (133,'2025-09-24 17:32:31.647','2025-09-24 17:37:31.647',3,N'16','2025-09-24'),
	 (134,'2025-09-24 17:38:47.337','2025-09-24 17:43:47.337',3,N'16','2025-09-24'),
	 (135,'2025-09-24 17:45:13.79','2025-09-24 17:50:13.79',3,N'16','2025-09-24');
INSERT INTO FitnessCenterDB.dbo.preReservasDeHorario (idPreReserva,fechaInicioDeLaReserva,fechaDeExpiracionDeLaReserva,fkHoraLaboral,idUsuarioQueReserva,fechaReservada) VALUES
	 (136,'2025-09-24 17:48:38.153','2025-09-24 17:53:38.153',4,N'16','2025-09-24'),
	 (137,'2025-09-24 17:52:09.903','2025-09-24 17:57:09.903',3,N'16','2025-09-24'),
	 (139,'2025-09-24 17:59:18.54','2025-09-24 18:04:18.54',3,N'16','2025-09-24'),
	 (141,'2025-09-24 18:03:10.44','2025-09-24 18:08:10.44',7,N'16','2025-09-24'),
	 (143,'2025-10-07 17:47:49.217','2025-10-07 17:52:49.217',4,N'','2025-10-08'),
	 (144,'2025-10-07 18:55:59.22','2025-10-07 19:00:59.22',4,N'','2025-10-08'),
	 (145,'2025-10-08 11:54:42.52','2025-10-08 11:59:42.52',4,N'','2025-10-08'),
	 (146,'2025-10-08 12:04:40.147','2025-10-08 12:09:40.147',4,N'','2025-10-08'),
	 (147,'2025-10-08 12:12:15.05','2025-10-08 12:17:15.05',4,N'','2025-10-08'),
	 (148,'2025-10-08 12:18:43.757','2025-10-08 12:23:43.757',4,N'','2025-10-08');
INSERT INTO FitnessCenterDB.dbo.preReservasDeHorario (idPreReserva,fechaInicioDeLaReserva,fechaDeExpiracionDeLaReserva,fkHoraLaboral,idUsuarioQueReserva,fechaReservada) VALUES
	 (149,'2025-10-08 12:29:44.047','2025-10-08 12:34:44.047',4,N'','2025-10-08'),
	 (150,'2025-10-08 14:09:37.49','2025-10-08 14:14:37.49',4,N'','2025-10-08'),
	 (151,'2025-10-08 14:20:39.13','2025-10-08 14:25:39.13',4,N'','2025-10-08'),
	 (152,'2025-10-08 14:26:54.87','2025-10-08 14:31:54.87',6,N'','2025-10-08'),
	 (153,'2025-10-08 14:35:18.447','2025-10-08 14:40:18.447',4,N'','2025-10-08'),
	 (154,'2025-10-08 14:39:01.983','2025-10-08 14:44:01.983',2,N'','2025-10-08'),
	 (155,'2025-10-08 14:43:24.47','2025-10-08 14:48:24.47',4,N'','2025-10-08'),
	 (158,'2025-10-08 15:52:47.78','2025-10-08 15:57:47.78',2,N'','2025-10-08'),
	 (163,'2025-10-09 10:55:03.43','2025-10-09 11:00:03.43',9,N'','2025-10-09'),
	 (164,'2025-10-09 10:55:32.07','2025-10-09 11:00:32.07',7,N'','2025-10-09');
INSERT INTO FitnessCenterDB.dbo.preReservasDeHorario (idPreReserva,fechaInicioDeLaReserva,fechaDeExpiracionDeLaReserva,fkHoraLaboral,idUsuarioQueReserva,fechaReservada) VALUES
	 (167,'2025-10-09 10:58:36.127','2025-10-09 11:03:36.127',10,N'','2025-10-09'),
	 (168,'2025-10-09 11:06:10.08','2025-10-09 11:11:10.08',4,N'','2025-10-09'),
	 (169,'2025-10-09 11:06:18.74','2025-10-09 11:11:18.74',5,N'','2025-10-09'),
	 (170,'2025-10-09 11:11:57.473','2025-10-09 11:16:57.473',4,N'','2025-10-09'),
	 (171,'2025-10-09 11:12:11.503','2025-10-09 11:17:11.503',10,N'','2025-10-09'),
	 (172,'2025-10-09 11:28:47.003','2025-10-09 11:33:47.003',9,N'','2025-10-09'),
	 (173,'2025-10-09 11:37:48.763','2025-10-09 11:42:48.763',7,N'','2025-10-09'),
	 (174,'2025-10-09 11:38:42.527','2025-10-09 11:43:42.527',6,N'','2025-10-09'),
	 (175,'2025-10-09 11:43:48.247','2025-10-09 11:48:48.247',4,N'','2025-10-09'),
	 (176,'2025-10-09 11:44:05.57','2025-10-09 11:49:05.57',5,N'','2025-10-09');
INSERT INTO FitnessCenterDB.dbo.preReservasDeHorario (idPreReserva,fechaInicioDeLaReserva,fechaDeExpiracionDeLaReserva,fkHoraLaboral,idUsuarioQueReserva,fechaReservada) VALUES
	 (177,'2025-10-09 11:54:11.577','2025-10-09 11:59:11.577',4,N'','2025-10-09'),
	 (178,'2025-10-09 11:54:27.907','2025-10-09 11:59:27.907',10,N'','2025-10-09'),
	 (179,'2025-10-09 12:30:10.173','2025-10-09 12:35:10.173',5,N'','2025-10-09'),
	 (180,'2025-10-09 12:31:00.75','2025-10-09 12:36:00.75',10,N'','2025-10-09'),
	 (181,'2025-10-09 12:46:25.293','2025-10-09 12:51:25.293',4,N'','2025-10-09'),
	 (182,'2025-10-09 12:46:33.847','2025-10-09 12:51:33.847',9,N'','2025-10-09'),
	 (183,'2025-10-09 13:01:42.37','2025-10-09 13:06:42.37',4,N'','2025-10-09'),
	 (184,'2025-10-09 13:01:49.813','2025-10-09 13:06:49.813',5,N'','2025-10-09');

	 SET IDENTITY_INSERT dbo.preReservasDeHorario OFF;