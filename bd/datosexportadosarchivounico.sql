use FitnessCenterDB;
select * from RutinaEjercicios
BEGIN TRY
BEGIN TRANSACTION;

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
	 (N'sp_obtenerMetasDeMedidas',N'Error de conversi�n al convertir el valor varchar ''ninguno'' al tipo de datos int.',16,1,'2025-03-18 15:58:37.84',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 16:02:33.82',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 4 Ejercicio: 4 mes 3 a�o 2025',1,3,'2025-03-18 16:03:23.193',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 16:07:40.867',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 16:07:46.327',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 4 Ejercicio: 4 mes 3 a�o 2025',1,3,'2025-03-18 16:09:07.31',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 16:18:46.88',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 4 Ejercicio: 4 mes 3 a�o 2025',1,3,'2025-03-18 16:18:56.583',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio: 4 mes 3 a�o 2025',1,3,'2025-03-18 16:20:52.19',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 2 Ejercicio: 4 mes 3 a�o 2025',1,3,'2025-03-18 16:21:02.58',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 3 Ejercicio: 4 mes 3 a�o 2025',1,3,'2025-03-18 16:21:08.537',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 4 Ejercicio: 4 mes 3 a�o 2025',1,3,'2025-03-18 16:21:13.983',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio: 4 mes 3 a�o 2025',1,3,'2025-03-18 16:23:45.79',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 2 Ejercicio: 4 mes 3 a�o 2025',1,3,'2025-03-18 16:23:57.343',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio: 4 mes 3 a�o 2025',1,3,'2025-03-18 16:25:07.91',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio: 4 mes 3 a�o 2025',1,3,'2025-03-18 16:34:21.663',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 16:34:39.34',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 3 a�o 2025',1,3,'2025-03-18 16:35:10.237',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 2 Ejercicio:  mes 3 a�o 2025',1,3,'2025-03-18 16:35:27.027',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 3 Ejercicio:  mes 3 a�o 2025',1,3,'2025-03-18 16:36:23.54',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 16:52:36.603',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 16:54:42.61',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:00:18.803',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:01:57.253',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:03:08.86',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:04:01.23',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:09:54.36',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:11:24.157',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:12:49.943',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:17:32.873',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:20:54.317',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:21:35.713',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:21:59.2',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:22:08.307',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:22:47.177',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:23:19.363',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:30:24.127',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:31:45.71',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:39:57.643',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-18 17:41:16.23',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-24 20:45:26.013',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-24 20:53:39.61',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-24 21:04:46.28',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-24 21:05:21.737',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-24 21:07:45.69',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-03-24 21:28:39.513',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 09:58:57.407',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 10:46:08.23',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 10:47:31.78',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:00:22.11',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:01:05.733',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:05:29.763',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:05:46.927',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:06:16.79',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:10:44.903',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:10:58.38',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:11:19.6',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:14:12.323',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:21:15.87',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:21:43.607',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 11:40:41.073',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 12:13:23.1',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 12:18:58.823',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 12:19:22.9',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 12:24:31.013',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 13:25:29.503',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 13:26:29.477',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 13:41:33.28',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 4 a�o 2025',1,3,'2025-04-03 13:41:38.27',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 4 a�o 2025',1,3,'2025-04-03 13:41:44.113',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 4 a�o 2025',1,3,'2025-04-03 13:41:59.477',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 13:42:08.987',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2025',1,3,'2025-04-03 13:42:19.597',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 13:43:19.45',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 13:44:19.183',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 14:10:33.76',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 14:10:39.657',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 14:10:43.06',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMedidasDelUsuarioPorTiempo',N'mensaje de prueba',1,1,'2025-04-03 17:15:56.27',NULL,NULL,NULL),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 17:42:10.62',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider');
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 17:42:25.16',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 17:51:18.82',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 18:23:53.847',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMedidasDelUsuarioPorTiempo',N'idCliente: 16, idParametro: 1, idEjercicio: NULL, Espaciado Temporal: individual, Tipo de B�squeda: a�o, Meses: 7, A�os: 2024,2025, Fecha de Inicio: NULL, Fecha Fin: NULL, Con Detalles: 1',1,1,'2025-04-03 18:24:03.913',NULL,NULL,NULL),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 18:24:09.393',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMedidasDelUsuarioPorTiempo',N'idCliente: 16, idParametro: 1, idEjercicio: NULL, Espaciado Temporal: individual, Tipo de B�squeda: a�o, Meses: 7, A�os: 2024,2025, Fecha de Inicio: NULL, Fecha Fin: NULL, Con Detalles: 1',1,1,'2025-04-03 19:00:20.79',NULL,NULL,NULL),
	 (N'sp_obtenerMedidasDelUsuarioPorTiempo',N'idCliente: 16, idParametro: 1, idEjercicio: NULL, a�os2024,2025,Con Detalles: 1',1,1,'2025-04-03 19:00:20.89',NULL,NULL,NULL),
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 19:00:24.523',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_obtenerMedidasDelUsuarioPorTiempo',N'idCliente: 16, idParametro: 1, idEjercicio: NULL, Espaciado Temporal: individual, Tipo de B�squeda: a�o, Meses: 7, A�os: 2024,2025, Fecha de Inicio: NULL, Fecha Fin: NULL, Con Detalles: 1',1,1,'2025-04-03 19:04:26.61',NULL,NULL,NULL),
	 (N'sp_obtenerMedidasDelUsuarioPOrA�osEspecificos',N'idCliente: 16, idParametro: 1, idEjercicio: NULL, a�os2024,2025,Con Detalles: 1',1,1,'2025-04-03 19:04:26.697',NULL,NULL,NULL);
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_obtenerMetasDeMedidas',N'idCliente 16 Parametro: 1 Ejercicio:  mes 7 a�o 2024',1,3,'2025-04-03 19:04:26.707',N'aaronlogin',N'localhost',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_registrarClaseProgramada',N'547',16,0,'2025-05-06 21:41:41.603',N'Instrucci�n INSERT en conflicto con la restricci�n FOREIGN KEY ''FK_ClasesProgramadas_Clase''. El conf',N'27',NULL),
	 (N'sp_registrarClaseProgramada',N'547',16,0,'2025-05-06 21:44:14.18',N'Instrucci�n INSERT en conflicto con la restricci�n FOREIGN KEY ''FK_ClasesProgramadas_Clase''. El conf',N'27',NULL),
	 (N'sp_registrarClaseProgramada',N'313',16,2,'2025-05-19 17:01:15.543',N'Se proporcion� un n�mero insuficiente de argumentos para el procedimiento o la funci�n dbo.yaExisteP',N'59',NULL),
	 (N'sp_registrarClaseProgramada',N'4121',16,1,'2025-05-19 17:04:46.89',N'No se encuentra la columna ''dbo'' o la funci�n definida por el usuario o agregado ''dbo.esFiaFestivo'';',N'59',NULL),
	 (N'sp_registrarClaseProgramada',N'4121',16,1,'2025-05-19 17:05:21.51',N'No se encuentra la columna ''dbo'' o la funci�n definida por el usuario o agregado ''dbo.esFiaFestivo'';',N'59',NULL),
	 (N'sp_registrarClaseProgramada',N'4121',16,1,'2025-05-19 17:05:33.323',N'No se encuentra la columna ''dbo'' o la funci�n definida por el usuario o agregado ''dbo.esFiaFestivo'';',N'59',NULL),
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
	 (N'sp_registrarClaseProgramada',N'547',16,0,'2025-06-11 14:17:04.263',N'Instrucci�n INSERT en conflicto con la restricci�n FOREIGN KEY ''FK_horasLborales_horariosClasesProgr',N'9',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-11 15:46:44.26',N'1/5 No hay clases por cancelar en esa fecha',N'21',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-11 15:46:55.983',N'1/5 No hay clases por cancelar en esa fecha',N'21',NULL),
	 (N'sp_procesoCompletoCancelarClasesProgramadas',N'51000',16,1,'2025-06-11 15:53:53.767',N'No se encontraron clases activas para cancelar',N'60',NULL);
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_procesoCompletoCancelacionDeInscripcionAClase',N'51000',16,1,'2025-06-12 11:51:49.477',N'Esa inscripci�n no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.',N'11',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'51000',16,1,'2025-06-12 12:37:32.07',N'Esa inscripci�n no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.',N'11',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'50000',16,1,'2025-06-12 13:37:33.003',N'Est�s intentando reagendar una clase diferente a la original.',N'32',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'51000',16,1,'2025-06-12 13:52:52.933',N'Esa inscripci�n no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.',N'11',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'51000',16,1,'2025-06-12 14:48:06.39',N'Esa inscripci�n no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.',N'11',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'51000',16,1,'2025-06-12 14:49:24.13',N'Esa inscripci�n no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.',N'11',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'50000',16,1,'2025-06-12 14:53:37.333',N'Est�s intentando reagendar una clase diferente a la original.',N'32',NULL),
	 (N'sp_procesoCompletoReagendacionDeInscripcion',N'50000',16,1,'2025-06-12 14:54:00.233',N'Est�s intentando reagendar una clase diferente a la original.',N'32',NULL),
	 (N'sp_registrarInsrcipcionAClase',N'50000',16,1,'2025-07-30 15:25:07.633',N'Ya no hay cupos disponibles para esa clase',N'18',NULL),
	 (N'sp_registrarCita',N'242',16,3,'2025-09-30 15:44:15.507',N'La conversi�n del tipo de datos nvarchar en datetime produjo un valor fuera de intervalo.',N'22',NULL);
INSERT INTO FitnessCenterDB.dbo.LogErrores (procedimiento,mensaje,severidad,estado,fecha,usuario,host,aplicacion) VALUES
	 (N'sp_registrarCita',N'La conversi�n del tipo de datos nvarchar en datetime produjo un valor fuera de intervalo.22',16,3,'2025-09-30 16:32:15.34',N'aaronlogin',N'fedora',N'Core Microsoft SqlClient Data Provider'),
	 (N'sp_registrarCita',N'La conversi�n del tipo de datos nvarchar en datetime produjo un valor fuera de intervalo.24  Sep 30 2025  4:46PM Sep 30 2025  5:46PM',16,3,'2025-09-30 16:46:58.277',N'aaronlogin',N'fedora',N'Core Microsoft SqlClient Data Provider');



	 SET IDENTITY_INSERT FitnessCenterDB.dbo.Roles ON;
INSERT INTO FitnessCenterDB.dbo.Roles (RolID,NombreRol) VALUES
	 (1,N'cliente'),
	 (2,N'empleado');
SET IDENTITY_INSERT FitnessCenterDB.dbo.Roles OFF;

SET IDENTITY_INSERT FitnessCenterDB.dbo.TipoRutina ON;
INSERT INTO FitnessCenterDB.dbo.TipoRutina (idTipoRutina,nombreTipoRutina,fechaDeCreacion,fechaDeModificacion) VALUES
	 (1,N'clase','2025-04-16 12:44:46.527','2025-04-16 12:44:46.527'),
	 (2,N'personal','2025-04-16 12:44:46.527','2025-04-16 12:44:46.527');
SET IDENTITY_INSERT FitnessCenterDB.dbo.TipoRutina OFF;






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



-- Descuentos (vac�o)

-- Servicios (vac�o)

-- __EFMigrationsHistory ya incluido arriba

-- duracionCitas
SET IDENTITY_INSERT FitnessCenterDB.dbo.duracionCitas ON;
INSERT INTO FitnessCenterDB.dbo.duracionCitas (DuracionID,Duracion,FrecuenciaNotificaciones) VALUES
	 (3,1,15);
SET IDENTITY_INSERT FitnessCenterDB.dbo.duracionCitas OFF;
-- estadosClasesProgramadas
SET IDENTITY_INSERT FitnessCenterDB.dbo.estadosClasesProgramadas ON;
INSERT INTO FitnessCenterDB.dbo.estadosClasesProgramadas (idEstadoClaseProgramada,nombresEstado,fechaCreacion,fechaModificacion) VALUES
	 (1,N'disponible','2025-04-16 12:25:39.853','2025-04-16 12:25:39.853'),
	 (2,N'no disponible','2025-04-16 12:25:39.853','2025-04-16 12:25:39.853'),
	 (3,N'cancelada','2025-04-16 12:25:39.853','2025-04-16 12:25:39.853');
SET IDENTITY_INSERT FitnessCenterDB.dbo.estadosClasesProgramadas OFF;
-- estadosDeActividadLaboral
SET IDENTITY_INSERT FitnessCenterDB.dbo.estadosDeActividadLaboral ON;
INSERT INTO FitnessCenterDB.dbo.estadosDeActividadLaboral (idEstadoActividadLaboral,nombreEstadoActividadLaboral,fechaCreacion,fcehaModificacion) VALUES
	 (1,N'no se labora','2025-05-14 11:43:09.443','2025-05-14 11:43:09.443'),
	 (2,N'si se labora','2025-05-14 11:43:09.443','2025-05-14 11:43:09.443');
SET IDENTITY_INSERT FitnessCenterDB.dbo.estadosDeActividadLaboral OFF;
-- estadosDeClases
SET IDENTITY_INSERT FitnessCenterDB.dbo.estadosDeClases ON;
INSERT INTO FitnessCenterDB.dbo.estadosDeClases (idEstadoClase,nombreEstado,descripcionEstado,fechaCreacion,fechaModificacion) VALUES
	 (1,N'Activa',N'La clase est� activa y disponible para inscripciones','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47'),
	 (2,N'Inactiva',N'La clase est� temporalmente suspendida','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47'),
	 (3,N'Cancelada',N'La clase ha sido cancelada permanentemente','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47'),
	 (4,N'Completa',N'La clase ha alcanzado su cupo m�ximo','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47');
SET IDENTITY_INSERT FitnessCenterDB.dbo.estadosDeClases OFF;
-- estadosHorarioClaseProgramada
SET IDENTITY_INSERT FitnessCenterDB.dbo.estadosHorarioClaseProgramada ON;
INSERT INTO FitnessCenterDB.dbo.estadosHorarioClaseProgramada (idEstadoHorarioClase,nombreEstadoHorario,fechaCreacion,fechaModificacion) VALUES
	 (1,N'activo','2025-05-07 14:42:05.153','2025-05-07 14:42:05.153'),
	 (2,N'cancelada','2025-05-07 14:42:05.153','2025-05-07 14:42:05.153');
SET IDENTITY_INSERT FitnessCenterDB.dbo.estadosHorarioClaseProgramada OFF;
-- estadosInscripciones
SET IDENTITY_INSERT FitnessCenterDB.dbo.estadosInscripciones ON;
INSERT INTO FitnessCenterDB.dbo.estadosInscripciones (idEstadoInscripcion,nombreEstadoInscripcion,fechaCreacion,fechaModificacion) VALUES
	 (1,N'vigente','2025-05-30 14:19:13.587','2025-05-30 14:19:13.587'),
	 (2,N'en curso','2025-05-30 14:19:13.587','2025-05-30 14:19:13.587'),
	 (3,N'terminada','2025-05-30 14:19:13.587','2025-05-30 14:19:13.587'),
	 (4,N'cancelada','2025-05-30 14:19:13.587','2025-05-30 14:19:13.587'),
	 (5,N'pendiente de aprobacion','2025-05-30 14:19:13.587','2025-05-30 14:19:13.587');
SET IDENTITY_INSERT FitnessCenterDB.dbo.estadosInscripciones OFF;
-- horasLaborales
SET IDENTITY_INSERT FitnessCenterDB.dbo.horasLaborales ON;
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
SET IDENTITY_INSERT FitnessCenterDB.dbo.horasLaborales OFF;
-- iconsForParameters
SET IDENTITY_INSERT FitnessCenterDB.dbo.iconsForParameters ON;
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
SET IDENTITY_INSERT FitnessCenterDB.dbo.iconsForParameters OFF;
-- intenciones
SET IDENTITY_INSERT FitnessCenterDB.dbo.intenciones ON;
INSERT INTO FitnessCenterDB.dbo.intenciones (intencionId,nombre,fechaDeRegistro,fechaModificacionDeRegistro) VALUES
	 (1,N'disminuir','2024-12-31 12:02:56.303',NULL),
	 (2,N'aumentar','2024-12-31 12:02:56.303',NULL),
	 (3,N'mantener','2024-12-31 12:02:56.303',NULL);
SET IDENTITY_INSERT FitnessCenterDB.dbo.intenciones OFF;
-- nivelesDeDificultadDeClase
SET IDENTITY_INSERT FitnessCenterDB.dbo.nivelesDeDificultadDeClase ON;
INSERT INTO FitnessCenterDB.dbo.nivelesDeDificultadDeClase (idNivelDeDificultadDeClase,nombreNivelDeDificultad,fechaDeCreacion,fechaDeModificacion) VALUES
	 (1,N'principiante',NULL,NULL),
	 (2,N'intermedio',NULL,NULL),
	 (3,N'avanzado',NULL,NULL);
SET IDENTITY_INSERT FitnessCenterDB.dbo.nivelesDeDificultadDeClase OFF;
-- nivelesDeIntensidadDeClase
SET IDENTITY_INSERT FitnessCenterDB.dbo.nivelesDeIntensidadDeClase ON;
INSERT INTO FitnessCenterDB.dbo.nivelesDeIntensidadDeClase (idNivelDeIntensidad,nombreNivelDeIntensidad,fechaDeCreacion) VALUES
	 (1,N'baja','2025-04-15 18:01:10.103'),
	 (2,N'media','2025-04-15 18:01:10.103'),
	 (3,N'alta','2025-04-15 18:01:10.103');
SET IDENTITY_INSERT FitnessCenterDB.dbo.nivelesDeIntensidadDeClase OFF;
-- nivelesDeLogro
SET IDENTITY_INSERT FitnessCenterDB.dbo.nivelesDeLogro ON;
INSERT INTO FitnessCenterDB.dbo.nivelesDeLogro (idNivelDeLogro,nombre,fechaDeRegistro,fechaModificacionDeRegistro) VALUES
	 (1,N'no conseguida','2024-12-31 11:21:39.54','2024-12-31 11:21:39.54'),
	 (2,N'alcanzada','2024-12-31 11:21:39.54','2024-12-31 11:21:39.54'),
	 (3,N'superada','2024-12-31 11:21:39.54','2024-12-31 11:21:39.54');
SET IDENTITY_INSERT FitnessCenterDB.dbo.nivelesDeLogro OFF;
-- sysdiagrams (no hay archivo)

-- tiposDeRecurrenciaDeDiasFestivos
SET IDENTITY_INSERT FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos ON;
INSERT INTO FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos (idTipoDeRecurrenciaDeDiaFestivo,nombreTipoDeRecurrencia,descripcion,fechaCreacion,fechaModificacion) VALUES
	 (1,N'semanal',N'Se repite cada semana, es un o unos dias especificos de la semana, por ejemplo domingo o sabao y domingo','2025-05-14 14:42:43.34',NULL),
	 (2,N'mensual',N'Se repite cada mes en una fecha fija,no es comun pero debe tomarse en cuenta','2025-05-14 14:42:43.34',NULL),
	 (3,N'anual',N'Se repite cada a�o en una fecha fija, por ejemplo 10 de mayo,2 de noviembre','2025-05-14 14:42:43.34',NULL),
	 (4,N'semanaDia',N'Se repite pero la fecha es variable,por ejemplo dia del padre','2025-05-14 14:42:43.34','2025-05-16 11:46:05.737'),
	 (5,N'diaRelativo',N'pensado para los dias de descanso establecidos de fin de semana, osea un dia de la semana tal cual,sabado,domingo,sin importar el mes,a�o o semana','2025-05-16 11:49:03.813',NULL),
	 (6,N'diaConsecutivo',N'un dia del a�o especifico considerando su numero consecutivo en el a�o,osea 1-365,por ejemplo dia del programador que es el dia 256 del a�o','2025-05-16 11:51:06.347',NULL);
SET IDENTITY_INSERT FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos OFF;
-- unidadesDeMedida
SET IDENTITY_INSERT FitnessCenterDB.dbo.unidadesDeMedida ON;
INSERT INTO FitnessCenterDB.dbo.unidadesDeMedida (unidadDeMedidaId,nombre,fechaDeRegistro,fechaModificacionDeRegistro) VALUES
	 (1,N'kg','2024-12-30 14:54:34.76',NULL),
	 (2,N' kg/m�','2024-12-30 14:54:34.76',NULL),
	 (3,N'm','2024-12-30 15:30:49.63',NULL);
SET IDENTITY_INSERT FitnessCenterDB.dbo.unidadesDeMedida OFF;
-- =============================
-- Grupo 2: Tablas con dependencias de Grupo 1
-- =============================

-- AccessTokens (GRAN VOLUMEN): se a�adir� en la siguiente parte

-- AspNetRoleClaims (vac�o)

-- AspNetUserClaims (vac�o)

-- AspNetUserLogins (vac�o)

-- AspNetUserRoles

INSERT INTO FitnessCenterDB.dbo.AspNetUserRoles (UserId,RoleId) VALUES
	 (N'5696d821-ab0c-40d5-9cd2-123232bc4eec',N'1'),
	 (N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'1'),
	 (N'e47637e0-1971-4e46-99fb-186db0847fac',N'1'),
	 (N'ec4a4f9d-02b8-402a-b274-8924adb46e46',N'1'),
	 (N'44e25915-a3df-4bdb-8520-07dca77ecb69',N'2'),
	 (N'574820a9-b28b-4b37-a665-029d2f41e272',N'2'),
	 (N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5',N'2'),
	 (N'e47637e0-1971-4e46-99fb-186db0847fac',N'2');

-- AspNetUserTokens (vac�o)

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
	 (5,N'Hiit',10,N' El Entrenamiento por Intervalos de Alta Intensidad (HIIT) alterna entre r�fagas intensas de actividad y per�odos fijos de actividad menos intensa o descanso. Nuestras clases HIIT est�n dise�adas para aumentar tu ritmo card�aco y quemar m�s grasa en menos tiempo.
Este tipo de entrenamiento te proporciona un entrenamiento completo mientras mejora tu condici�n cardiovascular y maximiza la quema de calor�as. Los estudios han demostrado que el HIIT puede quemar hasta un 30% m�s de calor�as que otras formas de cardio en el mismo per�odo de tiempo. ',45,2,3,15,60,1,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (6,N'Crossfit',10,N' El Entrenamiento por Intervalos de Alta Intensidad (HIIT) alterna entre r�fagas intensas de actividad y per�odos fijos de actividad menos intensa o descanso. Nuestras clases HIIT est�n dise�adas para aumentar tu ritmo card�aco y quemar m�s grasa en menos tiempo.
Este tipo de entrenamiento te proporciona un entrenamiento completo mientras mejora tu condici�n cardiovascular y maximiza la quema de calor�as. Los estudios han demostrado que el HIIT puede quemar hasta un 30% m�s de calor�as que otras formas de cardio en el mismo per�odo de tiempo. ',45,3,3,15,60,1,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (7,N'Fuerza y potencia',10,NULL,45,3,3,15,60,1,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (8,N'Boxeo',10,NULL,45,2,1,15,60,1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (9,N'Entrenamiento Funcional',10,NULL,45,1,1,15,60,1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (10,N'Entrenamiento Personal',10,NULL,45,1,3,15,60,1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (12,N'Yoga Avanzado',20,N'Sesi�n de yoga nivel avanzado enfocada en flexibilidad y respiraci�n.',45,2,3,15,60,1,N'8094a747-55d9-4782-9b31-b6602a79b7ed');
SET IDENTITY_INSERT dbo.Clases OFF;
-- Cupones (vac�o)

-- Ejercicios
SET IDENTITY_INSERT dbo.Ejercicios ON;
INSERT INTO FitnessCenterDB.dbo.Ejercicios (EjercicioID,NombreEjercicio,TipoEjercicio,Descripcion,fkIcon) VALUES
	 (1,N'Dominadas',N'Peso',N'levantamiento con los brazos colgado a una barra',NULL),
	 (2,N'Abdominales',N'AMRAP',N'flexiones de abdomen acostado',NULL),
	 (4,N'peso muerto',N'Peso',N'levantamiento de peso muerto convencional',1),
	 (8,N'Burpees',N'AMRAP',N'Ejercicio de cuerpo completo que combina sentadilla, plancha, flexi�n y salto. Excelente para desarrollar resistencia cardiovascular y fuerza.',NULL),
	 (9,N'Mountain Climbers',N'Tiempo',N'En posici�n de plancha, alternamos llevando las rodillas hacia el pecho. Trabaja el core y eleva el ritmo card�aco.',NULL),
	 (10,N'Jumping Jacks',N'Tiempo',N'Saltos abriendo y cerrando piernas y brazos simult�neamente. Excelente ejercicio cardiovascular que involucra todo el cuerpo.',NULL),
	 (11,N'Sentadillas con Salto',N'AMRAP',N'Sentadilla tradicional seguida de un salto explosivo. Desarrolla potencia en el tren inferior y eleva el ritmo card�aco.',NULL),
	 (12,N'Planchas Laterales',N'Tiempo',N'Mantenemos el cuerpo recto apoyados sobre un antebrazo y el lateral del pie. Fortalece el core y los estabilizadores laterales.',NULL),
	 (13,N'High Knees',N'Tiempo',N'Carrera est�tica elevando las rodillas al m�ximo. Excelente ejercicio cardiovascular que tambi�n trabaja el core.',NULL);
	 SET IDENTITY_INSERT dbo.Ejercicios OFF;
-- Equipos
SET IDENTITY_INSERT dbo.Equipos ON;
INSERT INTO FitnessCenterDB.dbo.Equipos (EquipoID,NombreEquipo,Descripcion,fkIcon) VALUES
	 (1,N'Mancuernas Ligeras',N'Para a�adir resistencia a ejercicios como sentadillas o press de hombros.',3),
	 (2,N'Kettlebells',N'Ideales para ejercicios bal�sticos como swings o clean and press.',4),
	 (3,N'Esterilla',N'Para mayor comodidad en ejercicios de suelo como planchas o abdominales.',5),
	 (4,N'Botella de Agua',N'Fundamental para mantenerte hidratado durante el entrenamiento intenso.',6);
	 SET IDENTITY_INSERT dbo.Equipos OFF;
-- Pagos (vac�o)

-- RefreshTokens (GRAN VOLUMEN): se a�adir� en la siguiente parte

-- Usuarios
SET IDENTITY_INSERT FitnessCenterDB.dbo.Usuarios ON;
INSERT INTO FitnessCenterDB.dbo.Usuarios (UsuarioID,Nombre,Apellido,Email,Telefono,NombreUsuario,Contrasena,FechaNacimiento,FechaRegistro,RolID,Estado) VALUES
	 (3,N'Juan',N'Martinez',N'aaronhl1313@gmail.com',N'9999999',N'elusuario',N'password123','2024-01-15','2024-07-19 14:32:30.477',1,N'activo'),
	 (13,N'aaron',N'Azcarraga',N'uno@gmail.com',N'2291250501',N'elusuario20/07/2024 03:15:36 p. m.',N'password1','2024-07-16','2024-07-20 15:15:38.87',2,N'activo'),
	 (15,N'Yesenia',N'esquivel',N'yesyes@gmail.com',N'33289392929',N'yes92',N'yes123','2024-11-15','2024-08-03 03:38:05.413',2,N'activo'),
	 (16,N'matias',N'botero',N'matias@gmail.com',N'+522291250501',N'elusuario10/08/2024 12:17:41 a. m.',N'$2a$11$amSmPDPY/lzbqu1BGS.Q0O6cq0tlb.m.sOHr7yij6hwzQtFn0xhnK','2024-08-06','2024-08-10 00:17:45.923',2,N'activo'),
	 (17,N'Rebeca',N'delgado',N'rebeca@gmail.com',N'227372828399',N'elusuario17/08/2024 01:24:35 a. m.',N'$2a$11$at7qAllPsGTMSrzEBiacYerCbDNAyjVJTsApHPfHS69iUIUk7vNr.','2024-08-17','2024-08-17 01:24:44.85',1,N'activo'),
	 (19,N'Valeria',N'Gomez',N'valeriag@gmail.com',N'337483839202',N'elusuario17/08/2024 01:31:50 a. m.',N'$2a$11$aKH3BpGNJtDqBopYlLTABulWQx9lRYembOjJtSjfl/B.nB9kRSDHG','1998-10-06','2024-08-17 01:31:50.3',1,N'activo'),
	 (22,N'antonio',N'marquez',N'antoniom@gmail.com',N'2237940475',N'elusuario30/4/2025 11:15:06',N'$2a$11$g4MxQsmf4jbLP5J3IjtZkuJYTFjSaG9zpHS0gwERelpN56hQNl1e2','2025-04-16','2025-04-30 11:15:06.423',2,N'activo');
SET IDENTITY_INSERT FitnessCenterDB.dbo.Usuarios OFF;


SET IDENTITY_INSERT dbo.diasFestivosVariables ON; 
INSERT INTO FitnessCenterDB.dbo.diasFestivosVariables (idDiaFestivoVariable,nombreDiasFestivoVariable,deQueSemana,deQueMes,deQueDia,fechaCreacion,fechaModificacion,fkTipoDeRecurrenciaDelFestivo,fkEstadoActividadLaboral) VALUES
	 (1,N' dia variable mensual de prueba 1',1,NULL,1,'2025-05-16 12:43:19.9',NULL,2,1),
	 (2,N' dia variable mensual de prueba 2',NULL,NULL,7,'2025-05-16 17:14:18.637',NULL,2,1);
 SET IDENTITY_INSERT dbo.diasFestivosVariables OFF; 


SET IDENTITY_INSERT dbo.diasFestivosYDescansos ON; 
INSERT INTO FitnessCenterDB.dbo.diasFestivosYDescansos (idDiaFestivo,fechaFestivaODescanso,descripcion,fkEstadoActividadLaboral,fechaCreacion,fcehaModificacion) VALUES
	 (3,'2025-05-17',N'dia de descanso de prueba',1,'2025-05-16 09:54:34.127','2025-05-16 09:54:34.127'),
	 (4,'2025-05-16',N'dia de descanso de prueba',1,'2025-05-16 09:56:00.29','2025-05-16 09:56:00.29');
 SET IDENTITY_INSERT dbo.diasFestivosYDescansos OFF; 


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
 
 

INSERT INTO FitnessCenterDB.dbo.parametros_unidadesDeMedida (fkParametroDeMedicion,fkUnidadDeMedida,fechaDeRegistro) VALUES
	 (1,1,'2025-01-01 12:59:35.08'),
	 (2,2,'2025-01-01 12:59:35.08'),
	 (3,3,'2025-01-01 12:59:35.08'),
	 (4,1,'2025-01-08 14:33:06.443');


INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'6E314471-7B58-445E-A6E1-00051D2B44A0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'E9M0+PJHssEluCT8FKVn6jzN/zmGrgsAYIdufDwmvgQ=','2025-10-08 17:53:47.5576544','2025-10-08 18:53:47.5574117',NULL,N'::1',N''),
	 (N'E98AEDA3-10BE-4C5E-BF2D-000C5E5507BC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'GFdEoSy6hzcr1p7LxSJbEU1/gjxx1xpykDVlxTKveoQ=','2025-09-29 21:43:46.8471981','2025-09-29 22:43:46.8017736',NULL,N'::1',N''),
	 (N'9EBAD2F8-CB33-4B70-9914-001B663A678B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'iyCWM3TmUlvuaugUARBXCO7/oZOB+u7/csxQIGhNCXc=','2025-10-03 21:20:15.3774686','2025-10-03 21:22:15.3773072',NULL,N'::1',N''),
	 (N'7490CE15-9980-403C-951E-0023833D40DE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qLc3Yc2LjX03iZyd8CP0h+QKrJQ1SezWGvN6DtIdgyU=','2025-10-06 19:45:57.2980442','2025-10-06 19:47:57.2979549',NULL,N'::1',N''),
	 (N'91C77606-4E73-4C8E-A576-004D92F9D027',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'AevzHskH8Wel5Jlc5uZDxOmPy5o0l/g6jmkTOhCqVFM=','2025-09-30 19:48:12.1821266','2025-09-30 19:50:12.1817025',NULL,N'::1',N''),
	 (N'AB343E9E-EEF6-431A-AD70-006877FF4D9C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'JZItcgX7fJ8l9MKbfF6guSTY3AdYYAEse2a9r6nWWu0=','2025-09-08 20:34:32.6824383','2025-09-08 21:34:32.6745505',NULL,N'::1',N''),
	 (N'4D81C8DE-CE6C-4B39-9138-00AA05AC6C30',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'I+0Kjq4CzqJpIdkd+DI+ABh2Fa4/51gdOvIR7GUivV8=','2025-09-16 19:44:49.0603068','2025-09-16 20:44:49.0602204',NULL,N'::1',N''),
	 (N'6E6A64EB-DDE1-431A-B034-00C26EAB335D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'JmQwTy1yYr6gvxv6Lfb2Yu+uE0qDZeRvAb/SR7hae9g=','2025-09-05 22:45:33.9099359','2025-09-05 23:45:33.9089627',NULL,N'::1',N''),
	 (N'ADDBB8D7-2AC9-430C-A204-0116632F294B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jBL1qD7d5tMweiS/fMcB27oeMdMJ4tkjPmMftF0CjXQ=','2025-09-22 19:48:15.6861403','2025-09-22 20:48:15.6740922',NULL,N'::1',N''),
	 (N'CA8F8F5C-B9FC-4F72-8E51-0124EFA38087',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'XdRPKKB1Wqi5C6YBrIuMY3iTVfAoP8ZjEivLKggofwc=','2025-10-01 22:01:30.7573712','2025-10-01 22:03:30.7573252',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'656DBE67-9F90-487E-8204-01C506E2B4AE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'f42KlZ52PFuFwuvKzf9E4fX9mW7259MBM/qw7tjiw74=','2025-10-06 19:50:02.0741341','2025-10-06 19:52:02.0640451',NULL,N'::1',N''),
	 (N'BC630C2A-1290-4C5E-B73C-01C73013336F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lgKEq3fyrxrDBnohsbOCoYA+zIY7M5bgfyzhzmqTQck=','2025-10-03 21:08:00.2761123','2025-10-03 21:10:00.2688254',NULL,N'::1',N''),
	 (N'6394C513-C3F7-4B17-8B6E-01D37B9724B4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KZ7fWK9LtNmTpSrDlaEOUXZ+11ufFQwH2faVFcccW/Y=','2025-09-17 02:08:36.6334457','2025-09-17 03:08:36.6185006',NULL,N'::1',N''),
	 (N'36A83AB6-5950-4989-87C7-01E07DD10E61',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'l0dJ4uK+CWgGrESLuwqfn9qF9xcYC7vFdZ89nnjZmSM=','2025-10-01 20:23:45.7002718','2025-10-01 20:25:45.6371791',NULL,N'::1',N''),
	 (N'F292DE11-C56F-4752-9481-01EA82EE9B11',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N't7r9TUV4xZGDShnm8IuaeCVSPBC5ZzR70UL5fEDuCUA=','2025-10-03 20:13:27.1446068','2025-10-03 20:15:27.1160539',NULL,N'::1',N''),
	 (N'2935EB21-2FA0-4742-A0CB-0223F13521FD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fXJO2vdldUF4SapahCBNuYEVEFTNsXgZlxDzX7OYl/M=','2025-09-24 20:36:44.2770891','2025-09-24 21:36:44.2663496',NULL,N'::1',N''),
	 (N'466C7268-A17E-4F8C-92FC-027D337E512C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'XuuWlqL2cFor9yLiMZdc6z5BT9CerkATB1mD/vwYE0g=','2025-10-07 18:53:47.2093387','2025-10-07 18:55:47.2051867',NULL,N'::1',N''),
	 (N'6FFB3C84-1377-464E-91F8-028536F029E2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'5qz9yEhRbYbr/Fb26X9+PqiyVPLOhEsihNwQj3EKEa8=','2025-10-08 00:54:51.0902942','2025-10-08 01:54:51.0900129',NULL,N'::1',N''),
	 (N'8DC06777-D5F7-40BD-8C3E-028D73D6360F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'I2FDVIC9TW7JzM8V4kvMbV5tzkyFaw+2NAOG/qYM+zg=','2025-10-03 19:41:38.9736558','2025-10-03 19:43:38.9728851',NULL,N'::1',N''),
	 (N'39F86977-7C2F-4081-B3E1-02A887E52E0E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kiL8fQGjMXDzuMI3QpDIRl0BEUKJwHhzmWNUWplj60c=','2025-10-01 21:56:55.7744929','2025-10-01 21:58:55.7744476',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'198D41F2-DEE0-48A6-9839-0314A1FEF9B5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wOgpyCCtODedsmBV/wKsDw4521o8wZO9ISfscOo3K0Y=','2025-10-09 18:39:17.6929345','2025-10-09 19:39:17.6832395',NULL,N'::1',N''),
	 (N'B0BE74F1-1C76-46B4-92D8-03179F959C20',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'wGE41m3qT+/vPvU0JSKi0NNlZWjxYhF9i6kuGKdJXC4=','2025-10-01 19:48:20.8485654','2025-10-01 19:50:20.8483153',NULL,N'::1',N''),
	 (N'DB7AF702-55A6-4C7E-B925-037FF0410927',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'H2P8oRyws6nuLqpYECbtJJvXssdsYzPXIPh8+EJZwZ0=','2025-10-01 21:30:50.6217501','2025-10-01 21:32:50.6216157',NULL,N'::1',N''),
	 (N'8C4CC016-ADA7-4B8C-9713-03DAAFE16ACF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'+Rf0xNjR6DD6MW6VuR1XznBfLr0gtOd7TlPEcAUCvS4=','2025-10-08 18:03:40.5621608','2025-10-08 19:03:40.5448682',NULL,N'::1',N''),
	 (N'2BAE71B3-7C3E-4612-BA90-0443779B11C8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'e8/9CaF1nFxP138+FQkJD38oVsfPwGByTPGaF4V7b7M=','2025-09-24 21:56:02.2461109','2025-09-24 22:56:02.2459033',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'8807E061-73B5-487B-A8A6-04A76024C99E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OGYNFk5I0GWO410hGXWAoJrRNaS00wsR9IW0Ps8oHpw=','2025-09-16 18:32:02.4819061','2025-09-16 19:32:02.4737558',NULL,N'::1',N''),
	 (N'ABB132AA-5AA1-4F7C-9EC5-04B85C3F8F4D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jC6jJb3MSbGgkzKFvg/Wb21aJ7bCXR3ogx2qG+/lins=','2025-09-19 00:33:11.8152726','2025-09-19 01:33:11.8041521',NULL,N'::1',N''),
	 (N'3A941960-F623-4FB1-8340-04C42BB947E7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'FKGaEWiKcBxZ36lZwtcqucVJd1iBJe0D7homNUSt958=','2025-09-22 21:30:47.9947516','2025-09-22 22:30:47.9812165',NULL,N'::1',N''),
	 (N'946E779A-1951-4BBA-858C-04C6D4104C49',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'wBV/RenWq243yxYceQG16JpRqDFeVqXG/zHoiBFgfwE=','2025-09-30 19:15:25.4666422','2025-09-30 19:17:25.4263065',NULL,N'::1',N''),
	 (N'8CF9E2BC-1737-41F2-BA0C-04EB0DE7F175',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ECANA+PbDR5y89B5wtUfF06gJNEn0vYp0De1nBAmQVI=','2025-10-03 21:17:37.4922299','2025-10-03 21:19:37.4917797',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'8F28E175-E41B-4176-A15F-051CCB014177',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Ep+51UNgU098WrHsL969vCsiNCZ6cZn78i/iW+XNLJw=','2025-10-03 20:08:42.5383497','2025-10-03 20:10:42.5381878',NULL,N'::1',N''),
	 (N'68CD717B-EC95-4321-9A2D-05B3D1C8852D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'skAHfXhfTDZE8wyBwJACl2tdPx6w+ucCoOxkidmeK4U=','2025-10-09 18:44:58.5429649','2025-10-09 19:44:58.5428947',NULL,N'::1',N''),
	 (N'3FFB7687-EBBD-4BBE-8245-05EBC6AB19B1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Sc1Ru7VxDsawG4Y6ayJ9HxA3kI5zbaB34EhsujXjm70=','2025-10-03 20:52:48.7755630','2025-10-03 20:54:48.7754405',NULL,N'::1',N''),
	 (N'700E467A-1538-4683-9310-06A128E33318',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'XjVdBg6QnR6rXCoGcuDyKtvMMlBJ8vCBhODNB4eI5Xs=','2025-10-03 21:12:46.1461174','2025-10-03 21:14:46.1371200',NULL,N'::1',N''),
	 (N'C75355F6-5573-419E-89AE-06E1E4427650',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'XVIN/nfVn/0fozQ7azB9dp1NTLMYPLHTiyy+nNS+Bhk=','2025-10-01 21:51:53.0232309','2025-10-01 21:53:53.0150303',NULL,N'::1',N''),
	 (N'3534F618-FC58-4C60-84B0-06FCC37EAFFD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'N7cM1d3+sA7Wj4m4FCYxIYNrJQ1QYfgY7qct5Ybv8+c=','2025-10-03 20:36:07.6102059','2025-10-03 20:38:07.6100844',NULL,N'::1',N''),
	 (N'1AE4B82F-A6BE-4137-BBF5-0724931B8EE7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nQ6r7p/p6hwiDbFQ2gpvk3mwWIMd81ClbVgKQlcuIW4=','2025-09-18 23:45:47.7992643','2025-09-19 00:45:47.7963858',NULL,N'::1',N''),
	 (N'EFEC3E4E-9D7E-4C03-98EE-07345D7C0306',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WWir/RX8RVluLqnPbm5/d03CvERMH7FEpJlUdZeegNY=','2025-10-03 19:42:46.3794143','2025-10-03 19:44:46.3793316',NULL,N'::1',N''),
	 (N'04F49A95-51F6-4A7F-BEDB-073A25AA24A2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2hOwklTUtsoiHRVix62bLqqVJAJ4niug1kmhOd3L4zU=','2025-09-17 01:38:07.2313340','2025-09-17 02:38:07.2236998',NULL,N'::1',N''),
	 (N'8849AADE-5BA1-4B5D-BA1C-07A396C48F4D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'kwM3NnoaxFKEw85SQm5/Y6Ab3JQgk8iucfXr+iT1hUo=','2025-10-07 19:13:57.1238271','2025-10-07 19:15:57.1236653',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'A785AC11-8577-4F47-86DB-07DD8C08214B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'GeBrspbAcLcDdFdHZDAB3wm09/6ni5be6fYgLixAw2c=','2025-10-03 21:18:52.5791244','2025-10-03 21:20:52.5782384',NULL,N'::1',N''),
	 (N'16480371-F951-4DB6-9E4A-082ED07F0784',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6A1InknW5c4LndOMhv49Bgj3cuDHRGsLvAFLSDMdByo=','2025-09-30 23:16:45.3569192','2025-09-30 23:18:45.2760181',NULL,N'::1',N''),
	 (N'37734656-0C13-489F-9D44-0859B145EC05',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cz6VcIjH9+/wJTsyUHJnMzzrLKJ+j8BvKEdwfE3b8Ws=','2025-10-01 21:30:43.4109211','2025-10-01 21:32:43.3795365',NULL,N'::1',N''),
	 (N'5A9E0143-C847-4C62-8061-08983A9CFD26',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KoUJykbLTzmEHFmIiY/ahRN5snP61idxxxlFwrIYEOk=','2025-09-12 19:27:47.8759576','2025-09-12 20:27:47.8626819',NULL,N'::1',N''),
	 (N'6F2D7BD5-B81C-493A-A954-089FF22A26C4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8c6kKJsXo4w273XRtVDDsnEYDZPuRwLrEJr1XFKNShU=','2025-09-08 22:14:29.4572476','2025-09-08 23:14:29.4068745',NULL,N'::1',N''),
	 (N'3F5F9669-1F88-4283-A990-08E4090EA5BB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qRwUZBydu6BxcHCUiA98/6rlhCaz350/zIqccu3l2pE=','2025-10-03 19:21:59.8595503','2025-10-03 19:23:59.8594771',NULL,N'::1',N''),
	 (N'4B232E9C-1A66-4E96-B4E5-095B0A107D7F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ca2N6kYnSSX1iD9zld+ykiNlLvKZuFtF6FCzVX7Aqdk=','2025-09-30 19:11:14.1424653','2025-09-30 19:13:14.0891187',NULL,N'::1',N''),
	 (N'ED06461B-4FBA-4AAC-B8C9-095CE4F32A57',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zoc9Qfa7VHErVmAlpOiE6a978cYkyt+Pbi8CH74MP8Q=','2025-10-01 19:48:24.2819055','2025-10-01 19:50:24.2715446',NULL,N'::1',N''),
	 (N'8EBED5DD-144B-4D03-9552-09CC90AD3282',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'NDacTNNV43nUNvc3vFSvOilWKR7WBhGlLz83GSm2G0s=','2025-10-06 19:47:19.9399064','2025-10-06 19:49:19.9393563',NULL,N'::1',N''),
	 (N'7DE290E0-20B1-415D-BFF3-09F8BBA0B61A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'J5nLOWkk72rNWnfI6C87qMoCdmb37PY5ZcsO/qOgz5g=','2025-10-07 17:07:13.0815189','2025-10-07 17:09:13.0770454',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'3DDDA782-AA4A-429D-B7FA-0A28924E78E9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KXTCChb17qrn9SJ3Huwiz1CF3fw6TjT3CutMwMVysg0=','2025-09-30 20:09:22.2789412','2025-09-30 20:11:22.2415963',NULL,N'::1',N''),
	 (N'7AA64662-9145-4B5A-B10B-0A629BFD4695',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KPGNGCtb8Tfan5RifkRRN/WUye7kbZVrJ7faVQxcBdg=','2025-10-01 19:51:42.3950308','2025-10-01 19:53:42.3949629',NULL,N'::1',N''),
	 (N'16AC6E13-3A30-4805-921C-0A7175E131AD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Jo8/QQstYFQif+z7MJcDKF8AgwOqBjjbF2pEr5T2lPE=','2025-09-18 21:59:31.8235041','2025-09-18 22:59:31.8232305',NULL,N'::1',N''),
	 (N'2986C129-3AA4-4F16-B42C-0ABBCFCFBE9D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IAQqS7ZXdSnkEySN4RW+iwXYV+joyam4suLcLMlUMTA=','2025-09-29 21:45:52.0583567','2025-09-29 22:45:52.0582963',NULL,N'::1',N''),
	 (N'E7588767-1CB3-4CA8-84BF-0ACD18DE2717',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'sVHvnBIdl7acmMWqU/pl9xaoNsBZJGhu/Dxypnc9KHw=','2025-09-22 21:20:15.3617996','2025-09-22 22:20:15.3440305',NULL,N'::1',N''),
	 (N'02C6BEAD-593B-4D60-8C45-0AD51938D89D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lyKge8C5e0BZRBgTxy4VkcuZt7iZ1wRnb1SHm7CdZUU=','2025-10-01 21:49:34.8531911','2025-10-01 21:51:34.8212229',NULL,N'::1',N''),
	 (N'7741C366-8188-41C6-8F65-0B07898DEEB6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jFivtw5ZG5926AUqDgEdcC7BDTpsmzQJBk7U04PvYjc=','2025-09-05 23:26:54.0290872','2025-09-06 00:26:54.0134924',NULL,N'::1',N''),
	 (N'3942BDAF-FE2F-4378-BFBB-0B3B46A4BF66',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'r5OsmYooFqoYUnV/O4sTZktda/Ta06wj5jWN4Y6vIFs=','2025-10-01 21:52:37.9004843','2025-10-01 21:54:37.8615521',NULL,N'::1',N''),
	 (N'AE928686-5D49-4499-8EF8-0B6549DFA7F7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dltS1PM+3+6YDSXCKmuGhO1BtUbnXEFtcIAwOaq2bNY=','2025-09-30 20:04:47.9891822','2025-09-30 20:06:47.9779199',NULL,N'::1',N''),
	 (N'F911C572-8184-444E-8909-0B6A948F54F1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'LAxRoPsUDXP8nSY1le6ZqVDa0FSXVRgIYNB0RIKbTDU=','2025-10-01 21:57:35.8539106','2025-10-01 21:59:35.8537753',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'96C73E38-DA00-4C8D-AAAC-0CE805E19BAE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zhTJsuQXBBxrwxS8Pt/YiYIQo1hKds2AC0hXEwsG4o8=','2025-09-05 22:00:08.2740088','2025-09-05 23:00:01.8648416',NULL,N'::1',N''),
	 (N'327383AD-2EEB-446D-9578-0CF50A73B276',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'sVHvnBIdl7acmMWqU/pl9xaoNsBZJGhu/Dxypnc9KHw=','2025-09-22 21:20:15.6830521','2025-09-22 22:20:15.6816536',NULL,N'::1',N''),
	 (N'820C1AF1-8F21-4E1F-B050-0D41504C267E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'DZ0uskzdh47WXDWkCyrH6GeSE0AgVa7M4ALLX8NmS38=','2025-10-01 22:15:06.3997185','2025-10-01 22:17:06.3929744',NULL,N'::1',N''),
	 (N'961A3F7F-29E5-4ECF-8B0A-0D990942D2CB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'3+/3UwQYhlg+vy/bEjA5naDnchVvkUaKWezCrwyd3iU=','2025-10-01 22:37:52.1054412','2025-10-01 22:39:52.1053991',NULL,N'::1',N''),
	 (N'E6B81697-6617-4A18-8904-0DA441BA66A4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cBft3z9xXBJ5KrRpg9cmvgojFHhmLK4OemEQqJFoZXE=','2025-10-07 18:20:16.0820715','2025-10-07 19:20:16.0820122',NULL,N'::1',N''),
	 (N'DD79C087-4B09-492D-9014-0DC0C4C87DA5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'eisBPtsdjrZ8N9x97zw/jAeodOIP6HpEIBJErjZ5vng=','2025-10-08 20:09:32.6085053','2025-10-08 21:09:32.6084461',NULL,N'::1',N''),
	 (N'3529AFD3-3359-4B81-9720-0DCB4CFF7284',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qlTPCGDghUYbnrr+ZVt3ltvyFPSahpb89Ainx8M5T/o=','2025-09-30 22:31:46.5993802','2025-09-30 22:51:46.5929721',NULL,N'::1',N''),
	 (N'0B3D9757-4BDA-4F86-9FFF-0DD3A5B172EC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'j0TvaFhNN+gfs53unPZVUgrozOeb4cwDrsxWwwKprsU=','2025-10-01 21:52:37.6038895','2025-10-01 21:54:37.6037497',NULL,N'::1',N''),
	 (N'A998B44A-25C7-40F3-BBB3-0E04B11F6213',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'UQMoALJSFY+16rkEBvph8PDmz4R2QE7SsRiiB/q4xi4=','2025-10-07 18:20:34.2638719','2025-10-07 19:20:34.2590121',NULL,N'::1',N''),
	 (N'78C198E7-4783-4813-B248-0E3DEE1A8AB0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kE0E+ZjDzYFfz1b/ZbzozvAziB3hHRcSNieFc3XKzSY=','2025-09-17 21:10:40.9613382','2025-09-17 22:10:40.9545348',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'E3FA88F3-17EF-4D9E-8EE2-0E5AF9D6915E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'jDE84F5iPoCYwmgBriDnHbnNV207TakPt8Jqo/sQ3f8=','2025-10-06 19:36:44.9233788','2025-10-06 19:38:44.9230427',NULL,N'::1',N''),
	 (N'84EB6C82-3FCF-48E9-9A85-0E858E3DB487',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZZGBLcCY8cURnrfu1Bah5MLUCYtl5JULHqZDkQKmWRM=','2025-09-05 22:56:38.9690794','2025-09-05 23:56:38.9689684',NULL,N'::1',N''),
	 (N'13925296-8170-4B15-9410-0EB5C71EAC75',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'AKyC7+UjjTiIkqbDFB/miyiTvoseKQk4Ep6DplEZLC8=','2025-09-24 23:48:00.3414688','2025-09-25 00:48:00.3414020',NULL,N'::1',N''),
	 (N'B9FDCC74-CEA8-41C7-9790-0EFF610AC37B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'AsZSj0ZYqbGOJyq7KH88UPUgz6Wuu7DfIe2nsJ+Dycc=','2025-10-01 21:59:43.4521820','2025-10-01 22:01:43.4461710',NULL,N'::1',N''),
	 (N'AECB6E0F-899D-4D0E-AC27-0F694571F994',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Jo8/QQstYFQif+z7MJcDKF8AgwOqBjjbF2pEr5T2lPE=','2025-09-18 21:59:31.8397536','2025-09-18 22:59:31.8396837',NULL,N'::1',N''),
	 (N'5CA0E79B-3C5D-4839-A7B0-0F7B3040B741',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'29UptLb3Ar3FS1mlRTsattQG2wn770zPISN4ohQlFIo=','2025-10-08 20:20:19.3384056','2025-10-08 21:20:19.3381195',NULL,N'::1',N''),
	 (N'18888E67-432E-4E22-977F-1090344DC154',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7H9aliGImjYz+9dXgkJYku/LsrD+TitKPOHrnaxMo3A=','2025-10-03 20:52:48.8483441','2025-10-03 20:54:48.8387960',NULL,N'::1',N''),
	 (N'8E21A21A-847F-4C17-83C9-10B7919AC066',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'QClYzbrTPqrqvvPssZ2RgT7WbiZ0rkphD2P1h8FRDbk=','2025-10-01 20:36:32.1107220','2025-10-01 20:38:32.0827851',NULL,N'::1',N''),
	 (N'E5869A22-9F49-4BA4-B6C1-10ECEBCA5707',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Md3TLhtXw+0Jbg9DV1fb1WuAUsknQyotrCa5jV1C8ic=','2025-09-05 23:26:50.3900398','2025-09-06 00:26:50.3885932',NULL,N'::1',N''),
	 (N'42932A39-8DC2-4E45-B9BF-1162F65641FA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uMgfgh5J8tw+3Rgw6PwhgLFLSdWNrMNnEpmIwnkvh1E=','2025-10-03 20:26:38.0694377','2025-10-03 20:28:38.0693932',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'A39E1FF0-B0C2-48DC-84EF-11A3479D0DE4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'n1FOYa9jNgwYq4aNy0nJi+rWUnYNEt1EAwSMHcobd0k=','2025-10-01 22:19:27.3391018','2025-10-01 22:21:27.3389515',NULL,N'::1',N''),
	 (N'ACF53DB4-4B17-45D3-85B3-12065F63BD71',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'e5we6vyGePtKQOz7yy/qvEpY/jlCSGbdpgXKk16D+i8=','2025-09-16 19:38:53.2912709','2025-09-16 20:38:53.2894308',NULL,N'::1',N''),
	 (N'11FC4078-F24A-4597-B288-12151FFFDB8A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'FzujSymDkktMXwqvo524flmTtCU+SSrhEyVckckk8Ao=','2025-09-09 17:52:55.3092834','2025-09-09 18:52:55.2809805',NULL,N'::1',N''),
	 (N'9383C6A6-ED15-4E42-B773-128C8F5A8C9A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dwONxUPvlq1X4XZWXOT6VZeQ3DCDrgQn0h8lPfdHfqs=','2025-09-18 21:58:40.7725190','2025-09-18 22:58:40.7707004',NULL,N'::1',N''),
	 (N'DC6421E4-E326-4E52-ABA0-12A268B0BB0E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'luBqB/BcmK6Ww31Up516S9HPLcv+XyHHoeF//ayzK14=','2025-10-03 21:08:00.2688833','2025-10-03 21:10:00.2688254',NULL,N'::1',N''),
	 (N'DDD049EE-4ECE-4A66-B279-12DC0D23BD0C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'CFfnF5ixuQ6syOEgart4Ixr8Ju2v/82KIl/WQEHo16M=','2025-09-18 17:43:36.5960681','2025-09-18 18:43:36.5940225',NULL,N'::1',N''),
	 (N'5142D45D-7D23-47B8-B8BD-12E758281BA3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9fpgNV4xWgNPIEeyx7lQas3/nubC3ArxqAXYReiNVAk=','2025-09-09 17:33:23.3979591','2025-09-09 18:33:23.3840098',NULL,N'::1',N''),
	 (N'68404C2C-1E8D-482B-B4A3-131F18CEEAEE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'g61pOxbAYu1Fdu/WhI5zEg4INRejTtuqNwnbezRjjIA=','2025-10-06 19:44:22.6080825','2025-10-06 19:46:22.5959398',NULL,N'::1',N''),
	 (N'82AF3FDB-9518-4625-8FDF-13251B88A2F3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'igG1/eNC9Vw8Ba1O4+JRxTvRl7SBJYwn40aQKtm5v14=','2025-10-03 20:38:25.2447394','2025-10-03 20:40:25.2354174',NULL,N'::1',N''),
	 (N'AB7E065F-E279-4BC5-8220-137FFB7BC85D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'BIpCZkcgd87VTsV39SKW5sEtxnN44xP4IsUKvCuZFcA=','2025-09-17 17:01:35.3721804','2025-09-17 18:01:35.3559381',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'CB1321C8-EC18-4308-8CB2-13873B0C034A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'LJGxd+YTELqQX3nhkwxj83PEo4dbtAHNIXXPjk7KsyI=','2025-09-18 21:58:57.3632462','2025-09-18 22:58:57.3630402',NULL,N'::1',N''),
	 (N'BC353EBD-D170-4589-9188-13A1BE3CE9EE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'HqcoSS03dHH302f7XBwyFULyx110EdJXyixscMpBKPo=','2025-10-03 20:37:06.1773750','2025-10-03 20:39:06.1708668',NULL,N'::1',N''),
	 (N'D99BE7B8-C9C6-4507-9FE6-13AFE6C9CE0E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'hQtSsWwygUneXhxhTmbOCxwxHipnhzzHqkwXX6fGyLw=','2025-10-03 20:11:41.2039262','2025-10-03 20:13:41.2037628',NULL,N'::1',N''),
	 (N'AFDBA840-316D-4861-A2B2-13C51F03F8EE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'RNGPGsf7/dvbAdQ9xpH6pepXoGbLe5ceLqynNyJ8a+I=','2025-10-03 20:45:32.2097625','2025-10-03 20:47:32.2095864',NULL,N'::1',N''),
	 (N'2BD17E16-DF93-415C-A9A8-13CAAE50E3B0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'7fpIF2r5PHlLor1nUWuH/a59asIE1FI16Q7W8etZTcs=','2025-10-01 19:46:02.2042998','2025-10-01 19:48:02.0383647',NULL,N'::1',N''),
	 (N'71F36487-0E13-434C-968C-13D691F6EE7C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GtzOCFDoCO7oZ7kHLDtw8ohSHiVK8y/J/GhLbhy/MS8=','2025-10-09 16:43:44.7817011','2025-10-09 17:43:44.7700595',NULL,N'::1',N''),
	 (N'4DFED10E-23DB-4075-9787-140314111EF4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'N9U1DqhiGsYp7o/HMREcHgA35syPHFV4teW8mjLGiZQ=','2025-09-30 20:15:30.9841289','2025-09-30 20:17:30.9469652',NULL,N'::1',N''),
	 (N'E7C38B42-DE74-4C90-97A3-141F80DE4372',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OSPoACCPRyFt6PlvrnebAP5/d7GfeqQfmDdDwdsq8yo=','2025-10-08 00:54:51.1121747','2025-10-08 01:54:51.1048941',NULL,N'::1',N''),
	 (N'A81BB450-632A-4B79-B622-1484232B1BB0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'4iVAzOBVQHRpFYvjqQA09/cZLmrJ9xnjw/ja/ZhAcpg=','2025-10-03 19:38:53.0821525','2025-10-03 19:40:53.0820698',NULL,N'::1',N''),
	 (N'9B8A393E-FFDF-4888-A159-14B14ADE7EE8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'H2P8oRyws6nuLqpYECbtJJvXssdsYzPXIPh8+EJZwZ0=','2025-10-01 21:30:51.9170188','2025-10-01 21:32:51.9169786',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'6BE34AB9-546B-4DA9-85A8-14BAA1A9DC3F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kd19Q+o0lsaRVVY5yTCkg070P1PS1M3XVyqC8eh//kw=','2025-10-01 21:23:50.0652562','2025-10-01 21:25:50.0264707',NULL,N'::1',N''),
	 (N'0E85E3EE-2FE9-4E41-9791-14C154454E3A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dTMQUuwWrNhv+jwLGn22f673CJcDCLwcBxMORsSrbkE=','2025-09-29 22:03:21.0615727','2025-09-29 23:03:21.0509450',NULL,N'::1',N''),
	 (N'3B9F6611-9B9A-4464-B180-1554EAA27ADA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'tYQh9uV6fqz9Z1dwnGunHMk315BWkvbjWS1gkhnP5Zc=','2025-09-08 21:40:07.8497500','2025-09-08 22:40:07.7985157',NULL,N'::1',N''),
	 (N'483A11A3-1204-422F-920E-159E6A46421F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IuRgmeuhAO4VaesFIFPe16OgOtNFoCmzP6akVD+FrlM=','2025-10-01 22:16:01.8937198','2025-10-01 22:18:01.8513225',NULL,N'::1',N''),
	 (N'0E99B557-48A4-468C-A2BC-15AC7668B404',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9t3IuHd0Risch4AjDAKNXpqp5tb1+R4590o8RRIUEB8=','2025-09-16 18:30:41.8365112','2025-09-16 19:30:41.8344838',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'B78EC55E-A17B-4589-B4D2-15C0FE74F2E0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'TTHOaLM41plnwMpzacqHcMK6p4CV6ySF/aXkRZGfri0=','2025-09-30 19:51:57.6996099','2025-09-30 19:53:57.6994866',NULL,N'::1',N''),
	 (N'C56C4AA8-6230-4A80-9F23-15C593B8BBF8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WdBgZjiO5MdSj9wWDtvlzA8pmq+X5lDrsEf6WxDNJuo=','2025-09-30 23:01:32.9163895','2025-09-30 23:21:32.9053228',NULL,N'::1',N''),
	 (N'2C2F135C-B07B-45B1-829E-160E2DA132C0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GbxoaGQ7vd9ILQ6Pjs+nNVHhIvH4DLKn9dLkg4i2N6c=','2025-09-17 17:58:13.8602023','2025-09-17 18:58:13.8601241',NULL,N'::1',N''),
	 (N'74FB5B95-0590-4109-A701-16264EE6002C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RjeaXYbgZCjJWnj1SgtJg+PQiHml7Ef5jPJAun3a3ms=','2025-10-08 18:18:13.0823629','2025-10-08 19:18:13.0821649',NULL,N'::1',N''),
	 (N'E213D0BC-CE1E-4D3B-95CB-163393FB42C0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'G/82u7dVBUzWu2oUZcBLwnDpKgn/IT4VCeUTHsKdP6U=','2025-09-30 00:22:12.8626285','2025-09-30 01:22:12.8625516',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'128D6E51-210E-4CA0-AB25-164AB82EDF29',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'jTah6lF0M8kn0x7l6g8QbCUoMRKjz5WmcPwfILTmWKE=','2025-10-01 22:43:21.7746013','2025-10-01 22:45:21.7745001',NULL,N'::1',N''),
	 (N'CEDA9EB4-927D-45FC-A956-1668A95D7FD2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KzjEoKNiPjYogaTu9K6ckmG979ygdko05omzYRcwIuQ=','2025-10-07 18:20:12.0910430','2025-10-07 19:20:12.0895425',NULL,N'::1',N''),
	 (N'270276E3-8417-44F6-9E79-16769AF54F45',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'JtspojxYy+oXU4GUwcSXYF27UY/cklF5Sun7WQmfoes=','2025-10-07 18:51:01.4586975','2025-10-07 18:53:01.4574253',NULL,N'::1',N''),
	 (N'BFC333DB-D636-4559-9EDE-169226A06816',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'o6LKSkc9rBnc6pr66EhMs6j5ByJ0EOZQDaFzNrVQj8I=','2025-09-17 17:58:13.8687545','2025-09-17 18:58:13.8601241',NULL,N'::1',N''),
	 (N'030B32D8-1D36-42BD-BA5D-16EFE6E5081B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ewY9hSZ5MhGBeLWAf9RbeYibQ/06B96/wDXrUkYu3HU=','2025-10-01 21:28:38.4718287','2025-10-01 21:30:38.4716682',NULL,N'::1',N''),
	 (N'1D045C65-4EA9-40BB-AB48-179ADBD5D186',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nOHs75UAUfhZpdfy+q4YcAnFfoyH3iuDpQC5zCXTYEc=','2025-10-06 19:36:45.0459262','2025-10-06 19:38:45.0339575',NULL,N'::1',N''),
	 (N'F82811EE-2A36-4CD3-869B-17B0B270351A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'awlTi4NTjs6p0HOQ6HUFwcQMhTSC+32aAPGgzJ7IUnA=','2025-10-01 21:59:43.4462100','2025-10-01 22:01:43.4461710',NULL,N'::1',N''),
	 (N'55A51C0C-0533-42DB-9D11-189C94794380',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bDvRvIuA3y5V5ni90NrZguHjB1qtUpkfNvz3vDeQpX0=','2025-09-23 21:12:35.4032728','2025-09-23 22:12:35.3928219',NULL,N'::1',N''),
	 (N'39FBBF40-0A96-4A07-B97D-18B5D34A4982',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'LX8tiUnRMRHVpjXtKfdlFYqRg8kzqDHn+2O9fBUteUo=','2025-10-01 22:17:30.0330981','2025-10-01 22:19:30.0330553',NULL,N'::1',N''),
	 (N'888204BD-825E-49F5-A181-18F2706B1D30',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'C3+YrbLkGTfmh16F0GfqAoWohIgsrvnELE7mxp9MlSg=','2025-10-01 22:15:06.3930241','2025-10-01 22:17:06.3929744',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'E13C4156-54F4-4573-B880-19719C9A5868',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'v4xL6WbpPwNVOUrdysm5keRoOGztJ3vseQAE4etZgT0=','2025-09-05 22:53:36.2183057','2025-09-05 23:53:36.2170470',NULL,N'::1',N''),
	 (N'0E2DD54F-56CE-41F2-B0DB-198121C14022',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'r5OsmYooFqoYUnV/O4sTZktda/Ta06wj5jWN4Y6vIFs=','2025-10-01 21:52:37.6879760','2025-10-01 21:54:37.6727297',NULL,N'::1',N''),
	 (N'C78B3426-7BAE-4AC7-850B-19949F1236ED',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7hE5H4OhFNnwyD1YO0iIrx7OilS0dmcVEzVZ4iqWYGQ=','2025-09-05 21:56:17.4151935','2025-09-05 22:56:17.4039761',NULL,N'::1',N''),
	 (N'775C166C-BDFC-4B78-9812-19B3CD7D04F6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7yic331cM/Vtji526zU6IK9/5uBSMgpGkwUrAoF949Q=','2025-09-18 21:59:10.4879809','2025-09-18 22:59:10.4801382',NULL,N'::1',N''),
	 (N'2F73B2EB-70CD-4CAF-BBF7-19BE0E23CB8F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Rrci1Y6VfE2fFtIuv7IxBnL9yGxSdrigWKpbg1woWqk=','2025-09-18 21:59:10.4598460','2025-09-18 22:59:10.4595741',NULL,N'::1',N''),
	 (N'D081976E-9C71-4C8A-8760-1A77A14D6C3F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'X4aDPC2QAhjR0dLJVVhJLkRZsq5SyOQsWkxJdZzCJDs=','2025-09-30 20:00:10.1130843','2025-09-30 20:02:10.1130303',NULL,N'::1',N''),
	 (N'9A2DE4C5-B057-468F-927F-1A83A45A85AB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'isbKJMlE0B61TLOxiXPp56T5kiFUM2nBr8jbTa9V32M=','2025-09-17 19:56:31.1913047','2025-09-17 20:56:31.1818037',NULL,N'::1',N''),
	 (N'A7E16CE1-EE70-4DE3-8660-1ABCD90511BF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'oToX3nXvzw2+B2c8apQ4yiElmRJ4RB52Jy+YzYFbBqg=','2025-10-01 21:23:50.0265539','2025-10-01 21:25:50.0264707',NULL,N'::1',N''),
	 (N'0EE78CB4-7493-40F5-99C8-1AE33011DED2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'XdRPKKB1Wqi5C6YBrIuMY3iTVfAoP8ZjEivLKggofwc=','2025-10-01 22:01:30.7435277','2025-10-01 22:03:30.7434064',NULL,N'::1',N''),
	 (N'6525CE4B-621D-466E-A501-1AEB01969FD2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uGLEmvLSk5xO8PaZmKeaMFHS0mIA2E1FF0+6rVL1WZc=','2025-10-03 20:11:41.2286448','2025-10-03 20:13:41.2212557',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'1B96CB62-0A16-4AB8-A330-1B8D61150A94',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'QW8gQRoDFIs5I3iWHn3MQOhJ/kq8wwJVu1iWG932jHs=','2025-09-30 19:58:47.2583995','2025-09-30 20:00:47.2581518',NULL,N'::1',N''),
	 (N'B5FA5779-54C7-4344-9914-1BAF729B4D8A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lVIijXsNKYZePaE9dCjYMP4ejR5XjFjUx365QSyOqvo=','2025-10-07 17:37:21.4514139','2025-10-07 18:37:21.4513319',NULL,N'::1',N''),
	 (N'8AB7542B-84B4-4304-A340-1BCEA80446F2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jDE84F5iPoCYwmgBriDnHbnNV207TakPt8Jqo/sQ3f8=','2025-10-06 19:36:45.0340247','2025-10-06 19:38:45.0339575',NULL,N'::1',N''),
	 (N'7AEAC16A-3AE7-4447-B3B8-1C6BBF69FEFC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'gZvaQZ2Mua04PALnbScHbZ6D9qbM0BcWHiZNdwRLon0=','2025-10-07 17:08:55.3056209','2025-10-07 17:10:55.3000574',NULL,N'::1',N''),
	 (N'BBC304FA-F743-44CA-B63C-1D0E57DB4956',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'oToX3nXvzw2+B2c8apQ4yiElmRJ4RB52Jy+YzYFbBqg=','2025-10-01 21:23:47.7637715','2025-10-01 21:25:47.7636089',NULL,N'::1',N''),
	 (N'8944C46D-556D-4935-8285-1D42B01DC9A3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+n3ZCV9m+F398gLDsC6TNIU1srEPVk2pBP04L2fKvx8=','2025-09-16 19:50:50.8589369','2025-09-16 20:50:50.8457756',NULL,N'::1',N''),
	 (N'BE24AD63-C4E0-4F22-9B8F-1D6FB8A6D97F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'zMO4A5hv/JcnFAM6x9u0UQr977Sicahm6MA637o0sh0=','2025-09-08 20:34:32.6124242','2025-09-08 21:34:32.6121850',NULL,N'::1',N''),
	 (N'45741B57-52A5-43E4-9C4F-1D70D1AD09A6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'RZeQVEag9fQe1dbhP+ioYGNwcEI4N6ZBKTXHH/cu4gE=','2025-10-03 21:20:38.6527256','2025-10-03 21:22:38.6506055',NULL,N'::1',N''),
	 (N'F2B16E57-B59B-4596-AED3-1D7D220AB2DC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'qV/gYK/roKRhuoJNBdi1TBsfubYyryf4Nj1UC/hzsaI=','2025-09-22 19:45:36.8924190','2025-09-22 20:45:36.8920822',NULL,N'::1',N''),
	 (N'A7424D96-0726-4EE6-91B4-1D9E7B9DB144',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'YFmAgg2DGpwMAerjApPWHzJs2i+D+yHaAFvmUmildMA=','2025-10-07 23:41:27.3433650','2025-10-08 00:41:27.3338421',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'3FB7E1C1-3743-4053-9FD1-1E0814C07A19',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'O/o6ye6lNhpniKKHjFNUcCmkZOlDxed8Nj6OMGvwjvI=','2025-09-24 23:44:15.7956368','2025-09-25 00:44:15.7852622',NULL,N'::1',N''),
	 (N'A9ADD60A-E678-4ACE-8D80-1E0C6EF0874E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'KvojlVmhDdh1xXAyv/3YL37E7hbF3ajKC15l446iZ1k=','2025-09-30 23:27:24.7355092','2025-09-30 23:29:24.7351445',NULL,N'::1',N''),
	 (N'01818E75-241D-43F6-8B49-1EB6448F173B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZLCmGm4Sk3whfBByA+xwKNk5fg825sETzKAJQk+NpQI=','2025-09-16 19:56:57.1838957','2025-09-16 20:56:57.1480847',NULL,N'::1',N''),
	 (N'50B1D91C-84C2-4E63-A312-1EBA13F36F8A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'4rObOX+6f0pF6FuemUEs+4LGxgGmDbYdHBM2NnUJlOg=','2025-10-03 20:27:58.6500951','2025-10-03 20:29:58.6499217',NULL,N'::1',N''),
	 (N'45A411A7-52A3-4B23-982D-1FD586B42F18',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N't4Vl1UWCuRYdigJWxhtjKqAZkqqd2wM20mAHOEH9nhc=','2025-09-17 16:12:42.7141891','2025-09-17 17:12:42.5421797',NULL,N'::1',N''),
	 (N'7BF30A6E-4952-41ED-A8BC-1FF530D0EFBF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nNzLR4zHDUhpbbdikuhE+ed3HMbk5HdQUPtNzNlGyzA=','2025-10-01 21:28:39.8714275','2025-10-01 21:30:39.8579333',NULL,N'::1',N''),
	 (N'1F1BB0FC-DC36-4E8F-B8F9-203A3CFD8208',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'PqRM3VJ+t/ojjzwmHPl7RZMYPvVeA6Lzx6ZnUvlJGwI=','2025-10-01 21:49:31.9635687','2025-10-01 21:51:31.9625818',NULL,N'::1',N''),
	 (N'831A60E3-2285-4F5C-8130-205CDCEED84D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'k6Z2S/JwAaDsdcDD+BRd85hnc/M8l5X9s+8qCsMt31s=','2025-09-09 18:03:27.6371800','2025-09-09 19:03:27.6236350',NULL,N'::1',N''),
	 (N'3BAB37AB-F6D4-4362-92D6-2062A21F9328',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qQDUvDKXUEiM/4XoH3ExPYEMk1RFs0wKmIEVpA4FbqQ=','2025-09-16 19:46:34.2150370','2025-09-16 20:46:34.2129634',NULL,N'::1',N''),
	 (N'D1C39ACB-CEF9-4732-84B4-20930605EFFC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'j+4ooazBY6EjCOR9f8CWJcSQm1Ghv+dygquIbmUUVF0=','2025-09-30 19:21:54.0689019','2025-09-30 19:23:54.0687993',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'1E6FF770-73D7-487D-8BCE-20E66F06F4D7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OsTOnSU87mCtufBLOP1+6w7asDLO9xsLva6gNv9zqeQ=','2025-09-30 20:24:33.6278710','2025-09-30 20:26:33.6277938',NULL,N'::1',N''),
	 (N'788AF6B8-C813-43C1-A2B4-2116FFC8598B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'U0ouezxNorYiSkxAx/dcrePP3lEPi630D7YQlbmhRdY=','2025-09-22 19:45:36.9308389','2025-09-22 20:45:36.9216122',NULL,N'::1',N''),
	 (N'45809E7D-FFF0-462C-85DA-213B3EA63EA2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'9anVly1JnvRAXcXnJLWHekrL+q+9OmjdQcoSY/bbhX8=','2025-09-16 20:22:16.3815623','2025-09-16 21:22:16.3674029',NULL,N'::1',N''),
	 (N'661EADC1-98DB-4543-B739-217522BED9A5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'qLc3Yc2LjX03iZyd8CP0h+QKrJQ1SezWGvN6DtIdgyU=','2025-10-06 19:45:57.2306781','2025-10-06 19:47:57.2303479',NULL,N'::1',N''),
	 (N'FA21A104-C03A-4228-BAAA-217B590CA33F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'M5WyrJGv5QQ7jOfg7jopk0kCDr7vfEFnXJm29frsZSU=','2025-09-10 19:43:44.3066194','2025-09-10 20:43:44.3064177',NULL,N'::1',N''),
	 (N'3066BDFE-8A35-4408-B531-2210016EB361',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'82rKry/X6drBoV+FodvEMVyg1vfq+NZ+tNlHR36CYw8=','2025-10-01 21:51:53.0150739','2025-10-01 21:53:53.0150303',NULL,N'::1',N''),
	 (N'0C406581-E396-4E00-A99A-22A4FE06047D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'6fYyUABMw7Cnb7jOG76xY1VUurj/3vKpBJJS39Zc3is=','2025-09-18 23:55:26.0483633','2025-09-19 00:55:26.0344924',NULL,N'::1',N''),
	 (N'5147A148-93B5-43F3-9927-23343BCCE352',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5RCc+ysg8DUkhsIce+RAhIR6a5WMZ9CiBdjbgIE2PIQ=','2025-10-01 21:19:14.5142353','2025-10-01 21:21:14.4843248',NULL,N'::1',N''),
	 (N'44BECED9-7422-4D52-A599-2354D54EC014',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Bag3WOTJr630Me1eRUVPucPyJZxDMJ9MRReoti1FJ94=','2025-10-03 20:29:28.3709218','2025-10-03 20:31:28.3708866',NULL,N'::1',N''),
	 (N'AE6A4AE1-43D8-46CE-A727-236E4DBFE985',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Nj0/R1UMFq3guqPd+sXiaQIeHdK6yLcsw1drAb7wD7k=','2025-10-08 20:09:21.1913936','2025-10-08 21:09:21.1897659',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'10534E1C-D40F-465C-BB23-2376050DAE3A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Ia3iT4LXCYfmYo8NzueGVDuqHWShyJ49gF+XDynlKG8=','2025-09-05 23:18:29.4760894','2025-09-06 00:18:26.9849265',NULL,N'::1',N''),
	 (N'C10FBE53-4700-4412-8E89-239D1DDA40B2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'hoNvIwfZ5mcw5f0Zp6gtficDRq/Si4Q1gNbL+5mGdUk=','2025-10-03 20:28:30.8485034','2025-10-03 20:30:30.8483714',NULL,N'::1',N''),
	 (N'66BF01E4-F747-4BD5-A989-23A4F7DFC9E9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5miRSKfpew7hlGUh+P90DiAWNcIRYj6E0DH98Y/XMfo=','2025-09-09 16:40:47.0084707','2025-09-09 17:40:46.9956339',NULL,N'::1',N''),
	 (N'CA179AF9-6CED-41D5-A170-23C3A0B38E19',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'8GhKk/NQxinT+df+oQcgXS2N1GfmISH/w+kFmXnBC0A=','2025-09-22 20:14:47.6799480','2025-09-22 21:14:47.6793616',NULL,N'::1',N''),
	 (N'EA06C6D5-7F29-4ED1-829D-24656ABD4752',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'WDYKK3R55YWAWHxE/orCZZU88QHXMyiU5Z5fJzv1tVg=','2025-09-24 21:48:16.7544555','2025-09-24 22:48:16.7021069',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'1CFE95A7-BB07-47AB-874A-2474D556C350',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'j8upKuNdfaW+XoeehB1+IPrjgqJFOcHqKezsZh3xgKA=','2025-10-03 20:39:52.0545651','2025-10-03 20:41:52.0238019',NULL,N'::1',N''),
	 (N'48C62221-6DD9-4319-A002-24C58EEFB2AA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cf++pCDEUYPS0R5q8A0HNF2VjP/G2tsGSMW5zxVsBPY=','2025-09-22 19:48:15.6755249','2025-09-22 20:48:15.6740922',NULL,N'::1',N''),
	 (N'1DF6CE95-C068-4973-AB47-24D0BD34918A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ww3Ix6GTQcLWBVLw3d40++HKpGwtNnz51/PWETZ68/A=','2025-10-08 20:38:41.7366053','2025-10-08 21:38:41.7269675',NULL,N'::1',N''),
	 (N'4C85D6D0-1810-4823-A53A-254C631FC5DE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'PtWmC4/NsZR65jKVeKVe9fC3hEFrGjXtayDKEqHWAP0=','2025-09-05 22:52:55.3421372','2025-09-05 23:52:55.3410164',NULL,N'::1',N''),
	 (N'FFD82504-0E5B-4CD1-BF99-25514FA49130',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'T13c7L8awni+mE2MEKXy0yV8De/Sq2qAvpoS4KnoLnY=','2025-09-30 23:01:32.5534212','2025-09-30 23:21:32.5372758',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'2521C8C9-1FB3-4D10-9F76-2553072CFDDB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2oyKlp+T77zxMMSbJgrQGC55MaO5DzjqUHCvB3jCfv8=','2025-10-07 18:55:07.5376490','2025-10-07 18:57:07.5375891',NULL,N'::1',N''),
	 (N'76BB2919-8504-472A-861C-2620D838C008',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'4vI1GhGra01xN6PNiHlSVYKa7hZPuNOw82OLXosG9c4=','2025-10-03 21:12:46.0837223','2025-10-03 21:14:46.0834270',NULL,N'::1',N''),
	 (N'B0DED9A4-2DF0-41C2-AA8F-26331A1837C6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'yN/33ybHvZhoK/hvdQczebKzuHnAz8Ca4vYpfWeZdCI=','2025-09-05 21:56:17.4053437','2025-09-05 22:56:17.4039761',NULL,N'::1',N''),
	 (N'35A94DE6-5C59-4BE6-8A99-265BC9B262FC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'BHYnMnRpfwL5YC/rtSJ9keaWYkL9AuV0UqFzE1zHgpY=','2025-09-17 20:11:44.6800445','2025-09-17 21:11:44.6782528',NULL,N'::1',N''),
	 (N'3396D1B1-F47B-4898-9494-26E1380484C8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'3E3JTb3Nl9Lb/Q/qMeKTR8NOnxXAkreAZc6xL+vjd1w=','2025-09-10 18:27:38.4518731','2025-09-10 19:27:38.4438595',NULL,N'::1',N''),
	 (N'233ECF3C-3BED-468F-A9A1-2733E2823FC4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vVWnAyNwP9i020GSiPInmZckxdjiLyPZ8AyBEeFkkng=','2025-10-01 22:39:48.2365497','2025-10-01 22:41:48.2364181',NULL,N'::1',N''),
	 (N'694C7E80-1B06-4278-822B-2768F0F57C26',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'soapJyj4yQiqppPxHCEBBf7k7EY5X9tDGsywwqSGrNU=','2025-09-30 21:43:47.5523076','2025-09-30 22:03:47.5520589',NULL,N'::1',N''),
	 (N'AFA49A85-BA62-4ED0-8F9F-279C2FD65260',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1Q0hMNr9CGBauQKquqmZ+NadW8SPXuwlqD7VVOpKOZQ=','2025-09-09 01:35:04.4444136','2025-09-09 02:35:04.4355608',NULL,N'::1',N''),
	 (N'0DCFF245-6CC3-4BFD-82E6-279DDB86DD2E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'6ciaH8j3XTsiz2i3R0JboiH/ct3xxI+PgrqkyYokiWk=','2025-09-17 21:10:39.2486870','2025-09-17 22:10:39.2340713',NULL,N'::1',N''),
	 (N'09B4ED90-D341-4092-9564-27AC51A59CA2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/dU+7+ZsUHvyject2eXPaXOX7aKF74VTnw0BCxHFfPQ=','2025-09-05 22:40:29.2016061','2025-09-05 23:40:26.4990697',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'BFAD6DA0-3EBD-40BA-8982-27D784EF9169',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dWgMwo51V/60YQZmpuLdP25XAPuUu2BQK3UooQMvOLM=','2025-10-03 21:22:22.4084908','2025-10-03 21:24:22.3850868',NULL,N'::1',N''),
	 (N'94AEC4ED-8734-4C41-A6D2-27ED4758F1F1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Iidi+ni5E3mVq7AL9yp7x8hN2zN9shCRRXuvfCFynh4=','2025-09-18 21:58:40.7811352','2025-09-18 22:58:40.7707004',NULL,N'::1',N''),
	 (N'FB27FC54-3793-4715-B9AD-27F4F301A97E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'i500+jw0rITbchMvPU2q2pe3nl6KjSrns4uBDjlKn5U=','2025-10-07 18:59:42.8117257','2025-10-07 19:01:42.8116642',NULL,N'::1',N''),
	 (N'C1E21873-EE56-4C36-A120-27F9E1F152A5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'NuCimaNpq0ryPdgipu35ol8ui1/JeT3EHrgMXZUGVtE=','2025-09-10 18:56:46.1336271','2025-09-10 19:56:46.1335632',NULL,N'::1',N''),
	 (N'848E6B79-641A-44EB-88BA-28D23D2EEB78',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IcQawwbzWOERsy2JIcaEqTw2mEAFPGHMgddirX2EhiM=','2025-10-09 00:11:55.2072183','2025-10-09 01:11:55.1973714',NULL,N'::1',N''),
	 (N'FC53E506-941D-4DA5-B6B8-292C431BC4BD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WBFv4fNYp12yrYGEMfCE3OKbvGJBHgQGvXmpauOBHLA=','2025-10-08 18:18:12.8861946','2025-10-08 19:18:12.8750505',NULL,N'::1',N''),
	 (N'B07C7F64-9062-4F39-8F83-295D0FB1A89F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'RUYEwfnZAv/5InmNQvgDmzG9GJ2pV3mkY/X3MecJD8A=','2025-09-18 21:59:57.0355500','2025-09-18 22:59:57.0352629',NULL,N'::1',N''),
	 (N'93AB610D-4B35-4E2B-A269-296FA35F1253',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qf+7FaLjTzB8J5heM3JBHVPepILN5JV2aPvVVQkW/pk=','2025-10-07 17:07:12.9731893','2025-10-07 17:09:12.9616352',NULL,N'::1',N''),
	 (N'639DBB33-F0BE-4F0C-8BED-29C09F52175F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'VgIK2F9u4mY3iglGyX9ZQCBwP1PrP0BalaUkAoudSJU=','2025-10-07 23:41:34.0738947','2025-10-08 00:41:34.0738290',NULL,N'::1',N''),
	 (N'0D2502A8-C892-4381-8D20-29E6B653D565',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2llxm6EyMRKEces7zMZO1rc3Zi+2daLLhyXK1DQaC88=','2025-09-08 22:14:29.4082951','2025-09-08 23:14:29.4068745',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'A4564A32-D7FD-49D0-93AF-2B43CF8D2D8E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'X4aDPC2QAhjR0dLJVVhJLkRZsq5SyOQsWkxJdZzCJDs=','2025-09-30 20:00:05.7567392','2025-09-30 20:02:05.7565000',NULL,N'::1',N''),
	 (N'B07DB3C0-C31C-425F-83BD-2B443B5B3031',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uQbxXGbL8mnGS1jZXNIvkl1koiMYaf3/VmfYcpFuLcA=','2025-10-09 00:11:55.1986204','2025-10-09 01:11:55.1973714',NULL,N'::1',N''),
	 (N'451C8E46-C1C7-4D13-A92D-2B63303FF21A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dwthCaGhfVyPQgMHa+XPWr1u2VVhGhZMBnULTl2EPcQ=','2025-09-30 20:09:22.2475539','2025-09-30 20:11:22.2415963',NULL,N'::1',N''),
	 (N'BAEA0C3C-E64C-4E98-A3A9-2B6FDED7573F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'kiL8fQGjMXDzuMI3QpDIRl0BEUKJwHhzmWNUWplj60c=','2025-10-01 21:56:55.7391576','2025-10-01 21:58:55.7388612',NULL,N'::1',N''),
	 (N'92B9DC6C-8365-4C00-951C-2B825944506A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'h6HU9p3wD3ax7YjyZ9p4DzT4RhTQbXlb7xftm8QoI/A=','2025-09-30 20:12:46.3031244','2025-09-30 20:14:46.3014484',NULL,N'::1',N''),
	 (N'44786C7F-C0D9-404D-BD54-2B9A93C0E66D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'PqRM3VJ+t/ojjzwmHPl7RZMYPvVeA6Lzx6ZnUvlJGwI=','2025-10-01 21:49:34.8213167','2025-10-01 21:51:34.8212229',NULL,N'::1',N''),
	 (N'1E9E80B8-4184-44B8-A84F-2BC1057AD595',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'UOSM7+/oEqDu9142Vgm25/7Iou23i+IWhXY6EcQ+CLs=','2025-09-17 20:54:12.1667156','2025-09-17 21:54:12.1577420',NULL,N'::1',N''),
	 (N'74C31AF1-EE25-463C-9C66-2BDBE1421256',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KmY3nM+EivL7Qx2Y0BAEMeviyaoJpXZ4PzpyCPtwnWI=','2025-10-07 17:11:38.4026053','2025-10-07 18:11:38.4014025',NULL,N'::1',N''),
	 (N'B1DE85E2-044A-47E8-87DA-2C1B27EEA504',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'H+hbvs2qH01tCfqbJsP6cGNhADkLpg9Mo0ALIb/jHCE=','2025-09-17 01:14:48.1418957','2025-09-17 02:14:48.1404610',NULL,N'::1',N''),
	 (N'DEEC991E-C228-43F7-A1FF-2C3424FC76C0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'n4C5/lkkGocLDAT8Rv7FfHvkWKoDYys6CGQHF9CRiN8=','2025-10-01 21:47:58.3249858','2025-10-01 21:49:58.3248110',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'FCFC5CD5-26D2-46B7-92BE-2C57E35CCD67',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lg2Jtf/rUW2vimmTok3p+cNeuRpNC7Ly8Vvc40dMSqg=','2025-10-01 21:38:01.3373083','2025-10-01 21:40:01.3372487',NULL,N'::1',N''),
	 (N'67723F3B-7F71-46BF-8A71-2C59054B33D3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Mig0BEIrnb5/ByKwzKbZGF2GlSmCSZioRkCdaGu23r4=','2025-10-06 19:54:02.2271015','2025-10-06 19:56:02.1862456',NULL,N'::1',N''),
	 (N'F2A79CE3-DC2E-45BE-9C40-2CDBD31BD8B5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Ioqjbtm5T6LuRM5N5axLFWmWl4w/6Fbsd/aE44IDWYo=','2025-09-23 19:11:35.5460846','2025-09-23 20:11:35.5440617',NULL,N'::1',N''),
	 (N'086B807C-3E24-4334-A5A7-2CF680C62EF9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'E0ClcFmbA4s/vZsJtRf7k6sYBWW4XBluvpcFtm+mUMs=','2025-09-19 00:09:35.6028193','2025-09-19 01:09:35.5716331',NULL,N'::1',N''),
	 (N'73A5BE21-3E52-406E-8CBE-2CF6DC8D54D9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'3lXC2iKd8imqh8031HPnsDzzUJSYNOI3Ru3dvlLfwiM=','2025-09-05 23:13:52.7930503','2025-09-06 00:13:52.7600240',NULL,N'::1',N''),
	 (N'BA09F3CB-A9DB-4125-9FC4-2D47F9DECB76',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Q28CPKp1FCzEWJE5Kvd15vwhPIPf5+kxzSkwgHw9SGE=','2025-09-30 20:45:30.9015009','2025-09-30 20:47:30.8997076',NULL,N'::1',N''),
	 (N'86D394C8-153B-404C-8356-2DC4E8E5FFDF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'UWS3lRi39KzFzsQoXyhafriO3pX2di7b4KgUsXcqZbA=','2025-09-30 19:44:16.0616369','2025-09-30 19:46:16.0598919',NULL,N'::1',N''),
	 (N'12A90CED-43DA-4DD7-A84E-2DF71A44C83B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'/t8x2AOHVRUWWT2ccrAov9kdzoBB8fNJBTKjcIay0JE=','2025-10-01 21:27:24.6634918','2025-10-01 21:29:24.6633398',NULL,N'::1',N''),
	 (N'540F7F07-8F2E-4D9F-9F48-2E0CCE691C40',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fSN4WG73MCql+eu9lrSYH7y0LM1ZJ/O/FyLtx7wAjnA=','2025-10-01 22:31:17.2521523','2025-10-01 22:33:17.2458200',NULL,N'::1',N''),
	 (N'8214D03B-1969-4C81-9CAE-2E480ABA68E0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6fYyUABMw7Cnb7jOG76xY1VUurj/3vKpBJJS39Zc3is=','2025-09-18 23:55:26.3746294','2025-09-19 00:55:26.3735131',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'6AFC2EA6-72F2-4750-A58E-2ED36513EA9F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'l8ldm6R6zwBuMus1kElHIYQAVjEE+2rkXP9y+s2NR9E=','2025-10-03 20:10:08.5958605','2025-10-03 20:12:08.5955853',NULL,N'::1',N''),
	 (N'0BBA6817-1083-4497-8BF5-2F835B254479',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'eWRSh56v4IlgPhetiTdu2lFtwieOMPZ/PrQWlKbNB/c=','2025-09-16 19:38:53.3002528','2025-09-16 20:38:53.2894308',NULL,N'::1',N''),
	 (N'B7445570-4714-4DD4-8FA5-2F8AA599C0FA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'42abDMINrPeLMJo5bYVfQhK11Bs3flINkHNBWKV5gu0=','2025-09-30 19:54:36.4943945','2025-09-30 19:56:36.4942967',NULL,N'::1',N''),
	 (N'31216B32-DFCD-4248-AC3E-2FA6004CD141',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'x6onlK5guAflNw4r2avJK5JYmU//7ZUb41TGLuhVkH0=','2025-10-03 20:51:35.9893320','2025-10-03 20:53:35.9892958',NULL,N'::1',N''),
	 (N'E207C416-5729-4467-8DD9-3045A38B659A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dy/1OEhl+Rte8cIcaMnIwuVy9NTIHQQEsJF1uAhyNCE=','2025-09-17 02:08:36.6198184','2025-09-17 03:08:36.6185006',NULL,N'::1',N''),
	 (N'77CC0142-80C3-4598-9F4C-3068248A3A2E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cVw9hqc7DFkrYupvNGyX1p1yA2fI4cDcNZ+VceSkukw=','2025-09-22 18:39:55.2407926','2025-09-22 19:39:55.2289027',NULL,N'::1',N''),
	 (N'50871B58-D186-4BA7-A2BF-306A07BCF900',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'n1FOYa9jNgwYq4aNy0nJi+rWUnYNEt1EAwSMHcobd0k=','2025-10-01 22:19:27.3118650','2025-10-01 22:21:27.3110162',NULL,N'::1',N''),
	 (N'FF8EE9A5-C9DE-4FD3-9D53-3187CF828F24',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wGE41m3qT+/vPvU0JSKi0NNlZWjxYhF9i6kuGKdJXC4=','2025-10-01 19:48:24.2716267','2025-10-01 19:50:24.2715446',NULL,N'::1',N''),
	 (N'00B8475F-A8A6-4259-BD96-319020218DC0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/VM/18xUIPQxrEdAF6pQ+wHfL08NDX8A8neBmqQhnLU=','2025-09-17 02:04:21.9121025','2025-09-17 03:04:21.9106724',NULL,N'::1',N''),
	 (N'3F4613EE-2080-46D0-B1CB-31A299608409',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'unz0Sehis2K4rrZIzOifEAE+szshRyyFrEAlTF5oGEI=','2025-10-01 22:15:11.6312916','2025-10-01 22:17:11.6311693',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'A2C59904-8B2A-4CD3-886A-31E95F9DEF27',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'2lhWVxM1L2jOZoPX4R/BcBlodpoGag8olV8PpWZAryY=','2025-09-05 22:55:56.5163451','2025-09-05 23:55:56.5160830',NULL,N'::1',N''),
	 (N'F69E2F31-F198-41EB-BC5F-3201A04EE1B1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Xctn/BWV9PKbCLIrI8kkprjL+VO3u5rpfvYW4zwWPmY=','2025-09-09 18:26:04.7727444','2025-09-09 19:26:04.7592818',NULL,N'::1',N''),
	 (N'1C145B76-1524-4685-9635-321466CD32CD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'aBzRbpK5fTNHQzJt6HdjUrfp84sGE5jut0R7rNUIucs=','2025-10-03 21:11:28.1509008','2025-10-03 21:13:28.1508436',NULL,N'::1',N''),
	 (N'478FC353-04CA-438A-A86E-3238EAAECF05',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'sNz0cM5QJrkLDht+Svhe/IuZy8nSYXZxcInyQBLJefc=','2025-09-09 01:35:59.5851482','2025-09-09 02:35:59.5530224',NULL,N'::1',N''),
	 (N'7AF244F3-FE7B-4394-A33D-327C8B9F7CBA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'pUMhJ6z4GGYkTGfg8Ecs1tBGfRREmpRYg/xLGrETNwI=','2025-09-09 00:54:21.9412577','2025-09-09 01:54:21.9409674',NULL,N'::1',N''),
	 (N'6370A07B-F3CF-46D5-9C98-329A7AE1EC2F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'LX8tiUnRMRHVpjXtKfdlFYqRg8kzqDHn+2O9fBUteUo=','2025-10-01 22:17:30.0140617','2025-10-01 22:19:30.0139481',NULL,N'::1',N''),
	 (N'14329CDA-C10B-4623-9517-32A432D069E1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WDYKK3R55YWAWHxE/orCZZU88QHXMyiU5Z5fJzv1tVg=','2025-09-24 21:48:17.2520328','2025-09-24 22:48:17.2500091',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'05C1A490-C79C-47C2-A688-32B497063418',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/y54+G3GZzeV6l5Xf1guP5yS9SbEgnudgNXTpx57ctU=','2025-09-17 19:56:31.1831562','2025-09-17 20:56:31.1818037',NULL,N'::1',N''),
	 (N'F5E89FF3-F42B-44AC-90E6-32C03E1FB169',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Y8EzQIrKEl7bWeME7p79I4GwiQ1FQ07oE8AiJpeDdmc=','2025-09-17 17:05:59.9528415','2025-09-17 18:05:59.9527728',NULL,N'::1',N''),
	 (N'AF50A87D-C7F8-4F83-8A43-32DFC8F95F04',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'w1VumfSxb0GbnnX0MKORrqHnJcSKYMLZGrBf7yvZvU8=','2025-09-17 16:39:15.8914444','2025-09-17 17:39:15.8907294',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'C0C89397-00BF-49B4-A1D1-32E315C57F50',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'oRGnb0Ke5ovnxtWj3gGk/Cp3z05ZkwmEUCY9ESsYIq0=','2025-09-22 19:06:56.0214316','2025-09-22 20:06:56.0200698',NULL,N'::1',N''),
	 (N'803133AB-6897-4B37-A3D2-32E9B3474680',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Bag3WOTJr630Me1eRUVPucPyJZxDMJ9MRReoti1FJ94=','2025-10-03 20:29:28.3200620','2025-10-03 20:31:28.3199267',NULL,N'::1',N''),
	 (N'A0CF6622-4197-4217-A4C0-33091799D66A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'sGnI8wZo+ikctAtF4dpVQiP+I2E54ogEQHphzVqMA9w=','2025-10-01 21:27:51.3779921','2025-10-01 21:29:51.3376905',NULL,N'::1',N''),
	 (N'87D3349D-FDFA-4655-9E40-330B14ABDDF1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qynVquuYMi+NgvKAgnEEZueA9LcI2AsyfW/5GoN8Vi0=','2025-10-01 21:56:55.7833955','2025-10-01 21:58:55.7744476',NULL,N'::1',N''),
	 (N'AE8FC635-2C3D-44FA-AFD6-337350714FF4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'rMWbGOtnHg26PRAUb0GPiIwBnpKS4PH44TDFPkvQR/A=','2025-10-08 17:53:23.3368095','2025-10-08 18:53:23.1370518',NULL,N'::1',N''),
	 (N'8AB9CA13-F29C-4033-8871-33C8D5C63276',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'NTgmxdAWcDm+mgbYEueozYrWafy4i9k4FRWKsmpnrz4=','2025-09-30 20:03:06.4213615','2025-09-30 20:05:06.4102767',NULL,N'::1',N''),
	 (N'B57095A8-F889-4730-AAEA-343E8912F0C3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'AzZRkTRzPAgpLoEqDPBmCPeYDDyyddBjUdXTjLUCcFE=','2025-10-01 22:39:39.8071688','2025-10-01 22:41:39.8010399',NULL,N'::1',N''),
	 (N'1ACE559B-846C-4F24-AF2D-34528EDAA55C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'felY73QF4q93hCwhdbkbTBDNqRzrpwsb1MdmO9RKWTE=','2025-10-01 22:16:01.8514361','2025-10-01 22:18:01.8513225',NULL,N'::1',N''),
	 (N'35B5B7FD-81C0-46F1-A475-34E21BD59939',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'rvCq9gOp01DHuSRw8abO+o8O4O5KE+JWsdovB41vaVk=','2025-10-03 20:15:04.7068197','2025-10-03 20:17:04.7066841',NULL,N'::1',N''),
	 (N'842563FB-4292-43E9-B171-35283DD455E0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vatzPV1qT0NRdkSEKJ3Pt6QTBnTMi5ARKH9PqvxmoPk=','2025-09-16 20:24:25.9417105','2025-09-16 21:24:25.9209501',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'5F4B078D-2550-47C6-BCB1-357633680E0C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'7D9x5iFuym0/Osn9QRcbLhXeiY1Zp1gydAXUcFzBEfk=','2025-09-17 16:27:29.0462954','2025-09-17 17:27:29.0460284',NULL,N'::1',N''),
	 (N'555A2DC8-FFBD-4132-A233-3592ADE07EED',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'uQbxXGbL8mnGS1jZXNIvkl1koiMYaf3/VmfYcpFuLcA=','2025-10-09 00:11:54.8710014','2025-10-09 01:11:54.8579568',NULL,N'::1',N''),
	 (N'82757D86-2011-45CD-AB48-35D6AEC486F4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'J5G2fvoyTdGtsh0S84/cju5Es0lQCWo3fehhJaW8DiY=','2025-10-09 16:43:44.7701240','2025-10-09 17:43:44.7700595',NULL,N'::1',N''),
	 (N'A9B0FE66-FE98-4096-8E8E-3602F5ECE187',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cDlOwIsI9haVJq93ucrR4fZpDsxl3hCLXh3lIXuH5XE=','2025-10-03 20:28:56.5132174','2025-10-03 20:30:56.4874707',NULL,N'::1',N''),
	 (N'355B43BE-793C-4651-9988-364A4ACA3BD9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'i2x0bMsYQx00LmH3hHmGD4U2EabUE10c3g89kp30inU=','2025-10-07 18:57:19.8760112','2025-10-07 18:59:19.8757994',NULL,N'::1',N''),
	 (N'848161F1-F6D0-43C7-BF53-366349AD8D82',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1Pd9Hs6ZmWWibKHoyhM76X3V3QYrF0q/G12xA06a4D4=','2025-10-01 22:30:49.6150913','2025-10-01 22:32:49.6149611',NULL,N'::1',N''),
	 (N'8F65F6AE-4FBB-495B-9DC2-36EDECC87C3B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'SQl3RjOShsLDygOwShQLGCKLQZueD2CGwonEkux+NXE=','2025-09-09 03:32:05.1094841','2025-09-09 04:32:05.1081406',NULL,N'::1',N''),
	 (N'E93B2259-B3BD-4A8A-9EC7-3729CA4F8E5C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'6ztU5oxJTpQR63jxQjXGIG/qrrvKde8Qj0xQE/JSoPs=','2025-09-18 22:20:31.2003460','2025-09-18 23:20:31.1613209',NULL,N'::1',N''),
	 (N'4E40C738-9A73-4DBE-B2D6-3753813992CE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8zyAHFbL8RsY4sMxC1UNLw8fxJKPlkRc+sbzbezGhUk=','2025-09-22 18:55:47.2406123','2025-09-22 19:55:47.1841834',NULL,N'::1',N''),
	 (N'72C26669-4764-404C-B0F7-37B3887E983E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'W7JDTPbScf7igF8K7RVJbYeDL1hB/Vaj/rABc0yrnlU=','2025-10-03 20:06:36.9779496','2025-10-03 20:08:36.9698853',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'079E6E27-05B2-4EBE-8CAC-37FB84137F4F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qDRuVzsQ2S4BcX/pqHDjYKSZVFke7Wz6gh8YHP1hs+M=','2025-09-17 16:32:55.7802864','2025-09-17 17:32:55.7238493',NULL,N'::1',N''),
	 (N'77BC4E3C-4089-439C-9387-38420AECB398',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'29UptLb3Ar3FS1mlRTsattQG2wn770zPISN4ohQlFIo=','2025-10-08 20:20:19.3556734','2025-10-08 21:20:19.3555877',NULL,N'::1',N''),
	 (N'E168D79A-ED72-4808-962B-38A5E8F9E9F5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'I+0Kjq4CzqJpIdkd+DI+ABh2Fa4/51gdOvIR7GUivV8=','2025-09-16 19:44:49.0303081','2025-09-16 20:44:49.0300595',NULL,N'::1',N''),
	 (N'E6BA224F-E308-4CCD-9CE9-38FFDDC5DE5E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9anVly1JnvRAXcXnJLWHekrL+q+9OmjdQcoSY/bbhX8=','2025-09-16 20:22:16.7166932','2025-09-16 21:22:16.7145005',NULL,N'::1',N''),
	 (N'714ECF53-1D70-497D-AE6D-393674C90955',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WajFgp+4xVusHlUbUQOFNS6JdR/oNyG93IAxWrE92Sc=','2025-09-16 20:11:12.3618960','2025-09-16 21:11:12.3608421',NULL,N'::1',N''),
	 (N'B99F5EAD-703C-443D-ACD2-3977994DE709',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RZeQVEag9fQe1dbhP+ioYGNwcEI4N6ZBKTXHH/cu4gE=','2025-10-03 21:20:38.7492849','2025-10-03 21:22:38.7492300',NULL,N'::1',N''),
	 (N'D4467E43-C002-414A-A094-3A2A475BC2FA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'eisBPtsdjrZ8N9x97zw/jAeodOIP6HpEIBJErjZ5vng=','2025-10-08 20:09:32.0503979','2025-10-08 21:09:32.0488663',NULL,N'::1',N''),
	 (N'C38C2D80-27D6-49B7-A96C-3A6C4BB1B569',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'0zp/Ud3dMYFi+ffSljpTMqB09TZWEG6tOz0i5RtZYuM=','2025-09-05 22:58:46.7219731','2025-09-05 23:58:46.7217171',NULL,N'::1',N''),
	 (N'E16D3B83-913B-4CDD-BDDD-3A82A63D8D18',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ECANA+PbDR5y89B5wtUfF06gJNEn0vYp0De1nBAmQVI=','2025-10-03 21:17:37.5461291','2025-10-03 21:19:37.5459415',NULL,N'::1',N''),
	 (N'C86EA091-E3AA-418F-9C97-3A9C06414B39',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'eisBPtsdjrZ8N9x97zw/jAeodOIP6HpEIBJErjZ5vng=','2025-10-08 20:09:32.6094765','2025-10-08 21:09:32.6094115',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'285CE0A2-D29C-4F99-B040-3AB7935029FB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'1Pd9Hs6ZmWWibKHoyhM76X3V3QYrF0q/G12xA06a4D4=','2025-10-01 22:30:49.5692009','2025-10-01 22:32:49.5690798',NULL,N'::1',N''),
	 (N'08FD9880-E991-4E02-8A62-3AC1CACDA86D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'T13c7L8awni+mE2MEKXy0yV8De/Sq2qAvpoS4KnoLnY=','2025-09-30 23:01:32.9067366','2025-09-30 23:21:32.9053228',NULL,N'::1',N''),
	 (N'8691B623-AB75-43BE-949E-3AF732311D71',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'NX9KWUIcU9GRYGCd0hc1YSCyPqskXM0vxvD0KgwJzPc=','2025-09-09 18:26:05.1297761','2025-09-09 19:26:05.0927140',NULL,N'::1',N''),
	 (N'781AF4D3-73B5-4747-A958-3B600B4DC05F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'PAcLyk+KXj8IvTKXmnyQn6+6g2xvZC8sb6w4Evsv0+Q=','2025-09-24 21:55:33.8910669','2025-09-24 22:55:33.8802292',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'5C4A08E7-1EE7-4F3B-A67A-3B88EF57442D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'jl8w+Qk71ImLiULyTLLR5dJUFQLuQPLZVRO2hH6uHFw=','2025-10-01 21:50:04.5251544','2025-10-01 21:52:04.5250221',NULL,N'::1',N''),
	 (N'44103957-D6DF-4A68-9F2A-3BB72DB36B74',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'LJGxd+YTELqQX3nhkwxj83PEo4dbtAHNIXXPjk7KsyI=','2025-09-18 21:58:57.3781193','2025-09-18 22:58:57.3780485',NULL,N'::1',N''),
	 (N'C332A049-01B6-4EEB-8E33-3BC82500E45A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'skAHfXhfTDZE8wyBwJACl2tdPx6w+ucCoOxkidmeK4U=','2025-10-09 18:44:58.5263955','2025-10-09 19:44:58.5258893',NULL,N'::1',N''),
	 (N'34AC9FD7-7A59-4E14-A064-3BE8C116A70C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'CsPBueVw1KI+gc3t7m8rJSljkGHiuqo+65gt6T0sw14=','2025-09-24 21:53:16.0572054','2025-09-24 22:53:15.9809204',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'81DAC115-07C3-41EA-9ABE-3C11710CA887',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rl3kjVPs6OHxkmh/AA2riIVJf6OpvKlRlHBqjqltxj8=','2025-09-30 21:16:55.5922626','2025-09-30 21:36:55.5908300',NULL,N'::1',N''),
	 (N'5B9F69B4-AC60-48C9-AC95-3C4740C0252B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'dy/1OEhl+Rte8cIcaMnIwuVy9NTIHQQEsJF1uAhyNCE=','2025-09-17 02:08:36.2538501','2025-09-17 03:08:36.2412308',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'249D8705-09F6-425C-B197-3C6D6E5B04BE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'4UM102jQnJtT/it7F/lEFF1q/cbIRc7OHnxU7WMau1Q=','2025-10-01 22:39:48.2716412','2025-10-01 22:41:48.2364181',NULL,N'::1',N''),
	 (N'81AEF587-1F4E-4B49-98AB-3C95C0FE051A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6b1V6VcLM1aZh/l7GxL1r/ykfEkung3p+2xAKD9wDo4=','2025-10-06 19:44:37.4233838','2025-10-06 19:46:37.4233146',NULL,N'::1',N''),
	 (N'B7A3AE31-52AC-42D1-9416-3CB958F4FFCA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'zKSF8KBrJ7MVyVKatislBt0mY5l04arILDVeBW2YQ9k=','2025-09-23 22:04:25.0872230','2025-09-23 23:04:25.0732970',NULL,N'::1',N''),
	 (N'1F293D58-8037-4B07-A21B-3CE9C665E7AE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zg4dOyg8Cz9NifxpnevuxFvSEes33mfXAAozjR+PWYI=','2025-09-24 23:24:38.0893761','2025-09-25 00:24:38.0794946',NULL,N'::1',N''),
	 (N'9EC97A3F-B5BB-459E-9E63-3D2A6264F06D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8yMgWLeQlXeiFDU7SUJNweDTMubNFKFZI2E9V2G4Fsw=','2025-09-05 23:24:39.4451672','2025-09-06 00:24:39.3745821',NULL,N'::1',N''),
	 (N'DE43A250-D833-4EA6-8503-3D3391DB2A20',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'9/NU+eieYIugJihZEzc2KK+XLV8PVkl356m+WEkmv40=','2025-09-22 20:01:48.2334239','2025-09-22 21:01:48.2156512',NULL,N'::1',N''),
	 (N'D07A4FD4-1350-40A1-93E5-3D45FDE9798D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'vVWnAyNwP9i020GSiPInmZckxdjiLyPZ8AyBEeFkkng=','2025-10-01 22:39:47.5423039','2025-10-01 22:41:47.5420190',NULL,N'::1',N''),
	 (N'4B315500-BC31-48F5-8613-3D47FDA8C70C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jx2R5RInIwLPhJ8AOvhBdlHr8qFVPi8fOTRH7oXg+yE=','2025-09-08 20:31:35.9122711','2025-09-08 21:31:35.9105263',NULL,N'::1',N''),
	 (N'BBA8DB54-494A-451E-BEDC-3DE2ADFE595F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rvCq9gOp01DHuSRw8abO+o8O4O5KE+JWsdovB41vaVk=','2025-10-03 20:15:04.7975991','2025-10-03 20:17:04.7767806',NULL,N'::1',N''),
	 (N'2819FF44-360B-49DE-87E5-3E090F4EB903',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'nT5Lbxgu9ZTynZGky/ZnfY9nAC8CE2x79nD8XtDtbx8=','2025-10-03 20:37:06.1564638','2025-10-03 20:39:06.1563397',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'559AB729-7022-4C5C-8F6C-3E4AFF61DB9C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Dm5iJiF80G0ewv+ZzQfjHNCbdES8mkCgT7cFtBSrbjc=','2025-09-10 18:53:08.0331575','2025-09-10 19:53:08.0122035',NULL,N'::1',N''),
	 (N'41C90A36-56F1-4A65-95AA-3E7796D21021',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'GbxoaGQ7vd9ILQ6Pjs+nNVHhIvH4DLKn9dLkg4i2N6c=','2025-09-17 17:58:13.8419644','2025-09-17 18:58:13.8414582',NULL,N'::1',N''),
	 (N'FCE17753-6219-4331-982D-3E9F381629E0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WquxtO08OLMy0YgOBNoayQYeSnfcUin/OqtviC/ibIU=','2025-10-03 19:38:52.0596874','2025-10-03 19:40:52.0291991',NULL,N'::1',N''),
	 (N'8503CE73-111C-4030-A12C-3EB59177C1C7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ODORL2rwvoOfttv6aU+qU61WEYrsXP7n+7C/YJjvXIk=','2025-10-01 21:01:05.6949613','2025-10-01 21:03:05.6845126',NULL,N'::1',N''),
	 (N'3C37C5CA-881A-4D7F-B8E2-3EE02C421D28',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'iueUqtigUa+QUwjYS8rHI7WMyAm5+r91EKNaK1wK1L0=','2025-10-08 20:35:08.0700138','2025-10-08 21:35:08.0622717',NULL,N'::1',N''),
	 (N'2D13C945-96FB-4719-A425-3F0C74872407',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'+gy9Raj3PJ/f+vRz8sSXACqbjgX/6Wh/jtRcqc5VAHQ=','2025-10-07 19:16:05.9286287','2025-10-07 20:16:05.9030420',NULL,N'::1',N''),
	 (N'231211B8-8495-4CB8-A668-3F23CB31FCCE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5b0ADe0rkLRXzSM9ruZqQ9p3cQqO7MY9iG4LmXXZIi8=','2025-10-06 19:54:02.1864006','2025-10-06 19:56:02.1862456',NULL,N'::1',N''),
	 (N'C3F02AD2-4209-4A56-8A85-3F8D88E308FA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jqjGugP5wUKKVPIN55ZwQNMD5L80zKT3YKIXvaQBZMg=','2025-10-03 21:02:58.3427534','2025-10-03 21:04:58.3427109',NULL,N'::1',N''),
	 (N'4B999B49-9738-4B98-9AD6-3FA6ADCC9D83',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'xRCGzeEdILRudkPmpr4JeRP1J3kIOHm6b6d0nOlhbgU=','2025-09-22 18:55:47.0029172','2025-09-22 19:55:47.0026645',NULL,N'::1',N''),
	 (N'43BE2F7D-E18D-47C2-BA35-3FDEE6E5A77A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'igWik4Drb8qoRr1uz6ARWoFZkGI7h+kHRdj44R0MoCY=','2025-10-01 20:36:29.1501609','2025-10-01 20:38:29.1499684',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'FD466F7E-AF4B-4588-8D16-40215F1DAD39',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nT5Lbxgu9ZTynZGky/ZnfY9nAC8CE2x79nD8XtDtbx8=','2025-10-03 20:37:06.1709107','2025-10-03 20:39:06.1708668',NULL,N'::1',N''),
	 (N'96D2231C-1B86-4C8D-8248-40C0B8174A71',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'xyVM2nemeShsqiBu0r4YvI6djMA0xAA0uWR4tTGiB7A=','2025-09-09 16:44:47.5789752','2025-09-09 17:44:47.5769731',NULL,N'::1',N''),
	 (N'75CBCCC1-2828-4693-BC57-411CC15A06BD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'1OZ1ExZEm+g5H4MnqggpmJ+Kx89ELUOh+Oe25Emr6uM=','2025-09-30 19:30:43.1912031','2025-09-30 19:32:43.1909494',NULL,N'::1',N''),
	 (N'E1BDBD61-48AC-424B-92A9-411FC2683EDC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8yMgWLeQlXeiFDU7SUJNweDTMubNFKFZI2E9V2G4Fsw=','2025-09-05 23:24:39.4667054','2025-09-06 00:24:39.3747052',NULL,N'::1',N''),
	 (N'DB12BC84-E8CE-4376-8970-41381C61D058',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WbGiK/tFHAmLyxadiUhmSQm2IInqfNmV0CacSi5Ja7k=','2025-09-23 19:11:35.5571063','2025-09-23 20:11:35.5440617',NULL,N'::1',N''),
	 (N'2C7ADE58-8C3E-4313-9D9B-41748E81EE4D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'tt7MwgLM5x8aaeOUGFwl9ZGQOo8hxuk4dR+tf7Dm5FY=','2025-10-07 17:07:13.0773337','2025-10-07 17:09:13.0770454',NULL,N'::1',N''),
	 (N'C08FAA2C-A24F-440D-829B-41857FEBB32E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'+87O/12rW5M5CCcQMmyccnew4zyVcUXeoOUP7ZOW5ww=','2025-10-08 20:38:41.2859072','2025-10-08 21:38:41.2699136',NULL,N'::1',N''),
	 (N'AEC9CD10-822E-4726-A330-4234B99CA4A7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'tt7MwgLM5x8aaeOUGFwl9ZGQOo8hxuk4dR+tf7Dm5FY=','2025-10-07 17:07:12.3168943','2025-10-07 17:09:12.1704133',NULL,N'::1',N''),
	 (N'60F203EF-06FD-4850-9606-42A0C7084A72',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'9jtP20rt7agETxgAZcHfxreV4A0QF6NBXU45F1DorpE=','2025-10-03 21:15:11.7906127','2025-10-03 21:17:11.7751725',NULL,N'::1',N''),
	 (N'FD98EEB1-D2DB-495A-9F22-42D063618BB9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'bmSmPpLfGFdU5kfzTbCf+gkBsB6EsYccIcmAJWCLVqk=','2025-09-18 23:30:41.9917324','2025-09-19 00:30:41.9767288',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'80087C9B-7088-477D-8117-42E8367DDEDA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'fDq4exFYv80sfxxSaMGbTnUfgj4K3T5qaHYtSNdSI0U=','2025-10-09 17:43:35.0603529','2025-10-09 18:43:35.0601112',NULL,N'::1',N''),
	 (N'3FBB1683-2BD1-4519-B77E-43553E1601B6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'DsVwE2RfsDruze3+63+G+IQtyI6vF9TA1xYfGuM0jcs=','2025-10-03 20:13:27.1160974','2025-10-03 20:15:27.1160539',NULL,N'::1',N''),
	 (N'82E04CFF-114F-47D1-99F8-435F2848063F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'XezQNzx2kV3RjFDX7JRPu4IyDoXFLLkxbfYOIB1ZjsM=','2025-09-30 19:27:26.9849641','2025-09-30 19:29:26.9848657',NULL,N'::1',N''),
	 (N'8B4D6230-4CC8-4431-9421-438247CE1154',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lSfZa9DjtXOHkz4ZfAbkLHadT1MAH+1s7Vs5rKY7lyU=','2025-09-17 20:20:12.6292387','2025-09-17 21:20:12.6191721',NULL,N'::1',N''),
	 (N'0C12BF00-BC42-4CFE-A694-442B057721DD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'UU+yZ3LbyqgIs52cFaMBd/avABhKmjHyNWiezcoc3mw=','2025-09-17 01:33:40.8959416','2025-09-17 02:33:40.8864423',NULL,N'::1',N''),
	 (N'D3AAE9B9-0839-43EA-B089-445258F9E48D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'qGOcvuecFvlIHqGIylbxkPk5VOA0bO2Q5xgV/rkfZi4=','2025-09-30 20:08:03.4931454','2025-09-30 20:10:03.4929077',NULL,N'::1',N''),
	 (N'3575E9DF-1DE8-4AB0-8F97-44533B11FF04',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'qQDUvDKXUEiM/4XoH3ExPYEMk1RFs0wKmIEVpA4FbqQ=','2025-09-16 19:46:33.8883245','2025-09-16 20:46:33.8736636',NULL,N'::1',N''),
	 (N'2502CA0B-34FD-4699-8C6B-44577B758B03',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'HC+aoB1BLILDyArUsMakXFpULUZjmTnEXJ7vYMQTCjs=','2025-09-05 23:16:47.0691801','2025-09-06 00:16:47.0144187',NULL,N'::1',N''),
	 (N'629DA346-2052-4C1B-885F-446154693F83',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'MqtkCB1mfZOlmY8jQQ8O+QoPAYjA5zUwQ89lmcpuhOE=','2025-09-24 21:57:46.9697945','2025-09-24 22:57:46.9678358',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'801720C8-9080-4F18-8CD8-446A0E9959BC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6MfQF+/xt6ZF6SvM07xwM8fFnvVLHAkt26PKthr6d1o=','2025-10-01 22:30:49.6747522','2025-10-01 22:32:49.6149611',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'8B8DCE23-BC3A-4B2C-9AA9-44DD9339ACB0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'l99neINoHhvOlyHCJldlVdUuKRg0ls4qY2az9/XBNf8=','2025-09-05 22:46:34.3621759','2025-09-05 23:46:34.3524366',NULL,N'::1',N''),
	 (N'BB930C6D-806B-4F8D-9B8C-450F32274AA5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'TzF9sguSFUJQj2LdN69f4/so8CaOabzPUHiGTvtdGEY=','2025-10-08 20:43:04.9515515','2025-10-08 21:43:04.9498547',NULL,N'::1',N''),
	 (N'FA5CBB44-2276-4596-927B-451936B03688',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'K0LD3I03zvSY0K1bVhKMuHRVvT+5Iw1QzLQQMFmj338=','2025-09-25 23:21:59.0209608','2025-09-26 00:21:59.0181330',NULL,N'::1',N''),
	 (N'E5B6B4B6-17B9-4F53-A940-453F67379EC5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WXiRulnh8keaQC+SkAVVdrEkKLijD5K3Ugr4LhlOUkc=','2025-10-07 23:41:34.1662082','2025-10-08 00:41:34.0738290',NULL,N'::1',N''),
	 (N'A7567B6A-C538-49A7-B44A-45831119DEDB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'V0DvcQKW+htI7Pc8jC40p5Zhn09fWi7W1LyW1JDPEAQ=','2025-10-03 19:47:05.9697776','2025-10-03 19:49:05.9697168',NULL,N'::1',N''),
	 (N'B629A4FC-4CCB-4E96-A8A1-45A182D8FAAA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vvJtYRx6BY53lBRptha10EktPf25kLjknRw8HJT8nlk=','2025-10-01 20:11:31.6776209','2025-10-01 20:13:31.6774448',NULL,N'::1',N''),
	 (N'83964EA5-41C7-4CFD-8B67-45F4821B14A0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N's9U7d7eWbeOq4XYe5gAOVHbL1lzvHHUEgjbh57qN1yk=','2025-09-10 18:51:20.0189383','2025-09-10 19:51:20.0185929',NULL,N'::1',N''),
	 (N'DC27B928-283D-45B3-BF88-4602A396E355',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'nBL/v/CyNOu7vPVj/pGGJ87MBBRRlUNVyGewtXzUBSA=','2025-09-22 23:05:58.2065702','2025-09-23 00:05:58.1930887',NULL,N'::1',N''),
	 (N'5CA90E14-5BD2-4565-A2C3-462A816732A9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'SDQbSk17L72pd0cBKctHN94jgEX2dCww8etJ7D30Ez4=','2025-09-22 22:46:17.0970267','2025-09-22 23:46:17.0969570',NULL,N'::1',N''),
	 (N'CED0FC79-E76C-4595-9900-463EA39E8F30',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+izGerveUzCcK/hUn8gb+QItN+QeF3o1nWGWX9LPj4o=','2025-10-07 18:20:16.0884109','2025-10-07 19:20:16.0820122',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'EAD1E9AF-8D35-44F8-B88C-46A02CFF7DC6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'v4xL6WbpPwNVOUrdysm5keRoOGztJ3vseQAE4etZgT0=','2025-09-05 22:53:36.2298870','2025-09-05 23:53:36.2298291',NULL,N'::1',N''),
	 (N'4D8FC9EA-3300-4AEE-9BE3-46B8ACCEBD59',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'tJXOjHdwXISMbb7JOOiBRPb2A0WXSza8TEz3LXItHiA=','2025-10-01 22:31:17.2458672','2025-10-01 22:33:17.2458200',NULL,N'::1',N''),
	 (N'10127EB9-6D68-4045-80F7-46E03B847E4A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'nmANCFrnLzfDowLIXH2GZsnR+U7+0nFZPU2zAPtO0X0=','2025-09-22 18:47:25.8069592','2025-09-22 19:47:25.8064629',NULL,N'::1',N''),
	 (N'6392C005-2980-4589-8B7F-46F83AE5AB4A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'E9M0+PJHssEluCT8FKVn6jzN/zmGrgsAYIdufDwmvgQ=','2025-10-08 17:53:47.5804609','2025-10-08 18:53:47.5803811',NULL,N'::1',N''),
	 (N'C94461EB-A87F-4E39-978E-47073E557AA0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'BVjRAKBhUsnKeRFVPQ2m5G5/1xcoAXDawj3kuRYBvas=','2025-09-16 20:44:51.2783339','2025-09-16 21:44:51.2761800',NULL,N'::1',N''),
	 (N'71116A9B-9E77-4F95-A0D5-47291C71B18E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N's9WNm5KAVjefm/Pf5XniGQWComyrb4WaCcml5TVfI2A=','2025-09-24 21:57:46.9782285','2025-09-24 22:57:46.9678358',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'90854DB5-A66B-4AAE-B09D-4742912367FE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'vDNlFmsbWGYXj1M0YB6Ys5K8eu01ZFCnsVmaPO6cnLQ=','2025-09-23 19:57:23.4314350','2025-09-23 20:57:23.4132767',NULL,N'::1',N''),
	 (N'12DD5714-17A6-4C21-8A5C-4749CA8E1066',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'26ltoVQ9QkPmuZYnkvfrFy9QoeqgyDBIfSw/3UwR7oI=','2025-10-09 16:43:38.1447185','2025-10-09 17:43:38.1430532',NULL,N'::1',N''),
	 (N'5486172B-D8F6-4C7B-B0E2-479848E14CB2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rLy6L/awZFS04O9isVq7dWAn3a7f+FomMdHatz7j2UA=','2025-09-17 17:55:05.9890228','2025-09-17 18:55:05.9876143',NULL,N'::1',N''),
	 (N'17792393-448A-4B00-9279-484186FAB36D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+E77+LRe6fVe2gVxDx0teSS5CzZwULuxAemkEv7A8vQ=','2025-10-01 22:43:41.6829016','2025-10-01 22:45:41.6770402',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'EA1632EC-7C8E-4538-AA99-489DB79C0715',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rc4J4ufadrY5Xjh+Jthu7MGT4jB7kg/J9c9Pn3A0UWM=','2025-10-08 20:22:50.8207809','2025-10-08 21:22:50.7736967',NULL,N'::1',N''),
	 (N'537AF610-CFA2-4A81-A1DF-48A551B033E1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vDNlFmsbWGYXj1M0YB6Ys5K8eu01ZFCnsVmaPO6cnLQ=','2025-09-23 19:57:23.8571333','2025-09-23 20:57:23.8552147',NULL,N'::1',N''),
	 (N'D228B6C3-BF5D-44E5-9D86-48C13FC6ADFA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'VEMwi74DXEFR/hjdPfmXVhkjZnaq7zavuYOXekE5V/E=','2025-09-23 19:04:07.2693956','2025-09-23 20:04:07.2674124',NULL,N'::1',N''),
	 (N'8F0E7EE2-E17F-4D89-9DF4-49750A709DF2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'LAxRoPsUDXP8nSY1le6ZqVDa0FSXVRgIYNB0RIKbTDU=','2025-10-01 21:57:35.8883252','2025-10-01 21:59:35.8882846',NULL,N'::1',N''),
	 (N'1CFDF804-6C61-4063-B9BA-49890384ED55',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OSVMsaLXBHl6vMGgELIBELBhGlFo68cLfG6L2iJkzhU=','2025-10-03 20:43:59.9752961','2025-10-03 20:45:59.9568518',NULL,N'::1',N''),
	 (N'6A054153-83E5-4F7E-8AE2-498CA6B0C399',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'PK4B6JCCwCUwrRMggeuHoa7PvDsh3V/U9yjIW3hAVxM=','2025-10-06 19:35:23.7312593','2025-10-06 19:37:23.7309486',NULL,N'::1',N''),
	 (N'9BCDA119-B8C5-426E-8B7D-499E12BBED97',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'0fBhaejvVikKw+MIWV+ccGCA3Xw2ker0y3ribLzlRFQ=','2025-10-01 20:22:20.6231791','2025-10-01 20:24:20.6229425',NULL,N'::1',N''),
	 (N'AD393FE9-98BB-44F8-8592-49D89C8EC402',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'X351Nyu4q5cDp+n5ngkWS5UQmU32aYUQ/QOPQLikbW4=','2025-09-23 23:10:54.8075757','2025-09-24 00:10:54.7937661',NULL,N'::1',N''),
	 (N'5557410E-F0CF-4DD7-9FE7-49E3831492F5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'4pzW4aB4//HKNcJ5yTqm9kFk66/wbuIZeQ/ykJO+zVs=','2025-09-17 17:55:05.9989251','2025-09-17 18:55:05.9876143',NULL,N'::1',N''),
	 (N'7A0BD5F0-ACAC-4EF3-A22D-4A50ED8F8D28',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'CXfCzNi7yS9Bl7RPw50+88+eqY58l8Sea8XBaPGk/r0=','2025-10-09 18:39:17.3386417','2025-10-09 19:39:17.3243895',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'8CBC257B-514A-479A-BF88-4A7AA6E6F9EC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'6yHwFkhJ67E3OG+P3rOW6/DiAvHFBRcap8PK+i5Ym8Y=','2025-09-24 21:51:51.7578711','2025-09-24 22:51:51.7554337',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'017EE1D2-CCED-41C9-90BC-4A8F58DB8C18',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'7tHgWSO6fQAOXLD+Eml/9LsyCkSoi5JR5IYnxB9K/dk=','2025-10-03 19:39:10.0220530','2025-10-03 19:41:10.0218108',NULL,N'::1',N''),
	 (N'4B4B2D54-8632-4D8C-84CD-4AA55F63D810',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'xPZLANQoPYwGdm7wjP2MODb4RRmOeVR/vEcdW4DnLZ0=','2025-10-07 18:20:12.0986765','2025-10-07 19:20:12.0895425',NULL,N'::1',N''),
	 (N'7B7ACFEC-FA62-470C-A606-4B40FD8D1FC1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'dy/1OEhl+Rte8cIcaMnIwuVy9NTIHQQEsJF1uAhyNCE=','2025-09-17 02:08:36.2538552','2025-09-17 03:08:36.2412253',NULL,N'::1',N''),
	 (N'33BC20C0-E4FF-4618-8752-4B99889B360E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vkWvkZh9aoSUiUW2w4mdS5sDQ7FxPztQaxPmPKU/S9c=','2025-09-09 16:40:46.9974130','2025-09-09 17:40:46.9956339',NULL,N'::1',N''),
	 (N'229D0FE2-80A4-46CF-8439-4B9A8C402458',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'pJQAHWkmn4568Y19E2rtmuHbwg1bYNECOR8Cq2ED/Ho=','2025-10-08 17:53:47.5892465','2025-10-08 18:53:47.5803811',NULL,N'::1',N''),
	 (N'E6DCC4CA-EF05-4241-AA92-4C2EEC77B80E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'tt7MwgLM5x8aaeOUGFwl9ZGQOo8hxuk4dR+tf7Dm5FY=','2025-10-07 17:07:12.3165421','2025-10-07 17:09:12.1684910',NULL,N'::1',N''),
	 (N'A9EA1050-C87E-4F7E-A494-4CB55494FF82',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'xPZLANQoPYwGdm7wjP2MODb4RRmOeVR/vEcdW4DnLZ0=','2025-10-07 18:20:12.0986767','2025-10-07 19:20:12.0895408',NULL,N'::1',N''),
	 (N'102E71FD-65B7-4538-A113-4D8A25515E76',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5ZM8PbKn502kAu4A0qWySAi0qcOq6ef9U7L7pAmXvas=','2025-10-01 22:17:30.0393104','2025-10-01 22:19:30.0330553',NULL,N'::1',N''),
	 (N'58753588-CB19-4D07-A58F-4DA767418C51',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ISz7VHlKUBx3Vsg3Tu2h5ly4M3WGKWAD0QCzjsDdBww=','2025-09-17 20:54:12.1588306','2025-09-17 21:54:12.1577420',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'8674BD8C-F23A-4261-820B-4E18968882C1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ziLlMnB2fFhHhby92chKn3Zq4GncbqkahBCqPkixEbE=','2025-09-17 16:43:02.6728961','2025-09-17 17:43:02.6589846',NULL,N'::1',N''),
	 (N'229E67BE-45B7-479D-A2E2-4EE659BD4F54',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'VgIK2F9u4mY3iglGyX9ZQCBwP1PrP0BalaUkAoudSJU=','2025-10-07 23:41:34.0738947','2025-10-08 00:41:34.0738290',NULL,N'::1',N''),
	 (N'C3752073-BEA3-4D28-B9DA-4F06BA46845B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2Cyx6iMVT7pKLcVMriccaXlEXgsAGDVekiAQFK67lkQ=','2025-09-16 19:44:02.4827964','2025-09-16 20:44:02.4827367',NULL,N'::1',N''),
	 (N'1A5B24F9-3E74-461A-9A24-4F2FCEE0D039',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'EHR3A3pM5IaSWBEKW+rUwQCSJBVPsAaBwGdcP31q5og=','2025-09-05 22:48:43.8794295','2025-09-05 23:48:43.8793593',NULL,N'::1',N''),
	 (N'2FA6A46E-FDB6-4CD4-8895-4F42611A1D91',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vPmlzHx08nBDDHlcN1hzDO+I632SeDJ+OHV3iuzXnlw=','2025-09-23 21:06:37.6036377','2025-09-23 22:06:37.5939465',NULL,N'::1',N''),
	 (N'9E86389B-3A08-487D-A72B-4F4312DB7EC0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'koZwDlKDYiz+1Lr1fg7AldOw3SxyUBtV4CqzLXXgtUs=','2025-10-03 21:02:58.3510302','2025-10-03 21:04:58.3427109',NULL,N'::1',N''),
	 (N'BC510BE9-770A-4954-B304-4F4E55506C5D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GmC/6vKZn4eED3ea6LJHk1Yq8lCKSKxLRVpZl1Pq7GA=','2025-09-17 02:04:21.9203822','2025-09-17 03:04:21.9106724',NULL,N'::1',N''),
	 (N'2415191C-8C93-4841-A756-4F927CFF36E8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'l8ldm6R6zwBuMus1kElHIYQAVjEE+2rkXP9y+s2NR9E=','2025-10-03 20:10:08.4865958','2025-10-03 20:12:08.4854787',NULL,N'::1',N''),
	 (N'6863599F-EF9C-48EE-8E74-4FBD9A651F8E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'PK4B6JCCwCUwrRMggeuHoa7PvDsh3V/U9yjIW3hAVxM=','2025-10-06 19:35:23.7562463','2025-10-06 19:37:23.7559005',NULL,N'::1',N''),
	 (N'6507DC14-A63E-4ACB-A059-4FFE3BAB3367',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'+JQX4bSPPyFqcyU7ogvx4Ldxxf481/OqwfCWFkBZ/Gs=','2025-09-09 01:35:59.4850374','2025-09-09 02:35:59.4803417',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'5C732CAC-36B7-4ED0-9C8D-500EE7C52386',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'YDPL7eH3H7Bu50AOemqfmLOX35M/q2hF46HhdG8ISIg=','2025-10-03 20:03:45.7691737','2025-10-03 20:05:45.7690319',NULL,N'::1',N''),
	 (N'23503042-4B5C-4530-9E6F-5015BA80235F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0dO0mytVeeKc1T/mG2uhDFMFuy/GPIlhUe6/b1YWbmA=','2025-09-17 20:11:44.7127746','2025-09-17 21:11:44.6782528',NULL,N'::1',N''),
	 (N'3AF03246-BE79-41AF-8D2E-5084F01C3DB9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'SO2OR9YCliFEtwZXKmlrysuxB6DaYNAAk00qJQNVZz4=','2025-10-07 18:20:34.2479802','2025-10-07 19:20:34.2477475',NULL,N'::1',N''),
	 (N'0F61B943-9FC9-448F-B7B3-50DBF0DC21E2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'cBft3z9xXBJ5KrRpg9cmvgojFHhmLK4OemEQqJFoZXE=','2025-10-07 18:20:16.0301435','2025-10-07 19:20:16.0299296',NULL,N'::1',N''),
	 (N'BDCCE11E-8F2E-4FD0-98C8-50DD60EC56B0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'CyFwMs9MMQFzCSZsXuCJM1kRKAaSem0BrjyyupnXjqw=','2025-09-29 21:54:35.7627533','2025-09-29 22:54:35.7623027',NULL,N'::1',N''),
	 (N'3A36CAAB-BE5D-4841-BD99-50E7274BB105',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N's58EYL+L9BKLUKdxwqhO8R5EcDfrV4tDyJBxwsLr/uQ=','2025-10-03 19:40:18.7174322','2025-10-03 19:42:18.6522803',NULL,N'::1',N''),
	 (N'DEA1240F-8711-404C-B558-50E879D8D5FC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uWJf+Yko/B2h5APz3pJDI+6YKyYjrk+jZs6ljyOzQkE=','2025-09-29 22:03:21.0523652','2025-09-29 23:03:21.0509450',NULL,N'::1',N''),
	 (N'CC5F1BC3-9784-4C7B-BE32-511BFFF3952B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nZSzXNN+ahPYA54SLyq/sgAEVJ9ZleINx3RvnZjOxRg=','2025-10-03 20:51:35.9955026','2025-10-03 20:53:35.9892958',NULL,N'::1',N''),
	 (N'AFE0A159-CB96-484B-ACA4-5151F83C0B97',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fDq4exFYv80sfxxSaMGbTnUfgj4K3T5qaHYtSNdSI0U=','2025-10-09 17:43:35.2005063','2025-10-09 18:43:35.2004240',NULL,N'::1',N''),
	 (N'9750EF02-361C-4FA9-8CAF-5239BF6DE39E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fEYipb+oRwSE6ycjQPOFkkgeU8tUMuU8hNWWfhP3eQA=','2025-10-09 17:43:35.2243670','2025-10-09 18:43:35.2004240',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'DF8FC083-31B2-4EBA-9362-5256D6F83A40',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9MPc4F6ZH2rOmZmnf0oWSkgyhEeLczUrGecnkvdv7Ew=','2025-09-30 19:51:57.7101586','2025-09-30 19:53:57.6994866',NULL,N'::1',N''),
	 (N'53926EC3-1911-4071-8978-525D27BBF5DE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dV/Su18j2uxxZOiHpANEt0/5udQOydagnKellTQ7jL8=','2025-10-03 19:41:39.1970408','2025-10-03 19:43:39.1761394',NULL,N'::1',N''),
	 (N'2722B211-8387-4981-B403-5262B9205803',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'gIKGLo9Y++Ah7rSPp+o1aCcFsKm52ODJbiQhb7SAZCU=','2025-09-24 22:05:23.6074680','2025-09-24 23:05:23.5961322',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'CA1A45F3-E8F9-46E3-877C-532729929431',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'6b1V6VcLM1aZh/l7GxL1r/ykfEkung3p+2xAKD9wDo4=','2025-10-06 19:44:37.3032852','2025-10-06 19:46:37.3029422',NULL,N'::1',N''),
	 (N'62878343-5A5D-4592-B62A-53603521EED5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'+qNUw5Xk4W7VOifkilw1N6lXwPaG4FN0fkf6wRxYCYw=','2025-09-16 19:42:53.5636866','2025-09-16 20:42:53.5634091',NULL,N'::1',N''),
	 (N'C0E33C73-A7A1-42F8-8E71-536A69747B60',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'2Cyx6iMVT7pKLcVMriccaXlEXgsAGDVekiAQFK67lkQ=','2025-09-16 19:44:02.4454885','2025-09-16 20:44:02.4450977',NULL,N'::1',N''),
	 (N'9B8D56B0-70FD-4F12-BBA2-5376A94D1D43',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'jhl6r9/zBLiFz0usMzvCK3bojsD//DEXSjUPEmbt3tY=','2025-09-17 21:10:40.9371459','2025-09-17 22:10:40.9366812',NULL,N'::1',N''),
	 (N'11690C26-68F6-46F1-87CF-53DDB8A0FFAD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'aCuTvV6ozM7ZrrYQeJEY/i9MX27DD/gAq1yIOE9qAkY=','2025-09-24 20:33:37.8119450','2025-09-24 21:33:37.8100814',NULL,N'::1',N''),
	 (N'B9228308-6E73-4A43-B8F4-54CC43C75938',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'EPm0LX292CpATPdP/5N5nAlLpZ3/ZE/S/gsR03ZeSks=','2025-09-17 19:27:46.4532602','2025-09-17 20:27:46.4513544',NULL,N'::1',N''),
	 (N'CBFF537A-2A5A-45D6-888B-54D936F44E7F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lqrEV0Da0I4grjcsO5O4h7djW+zEKKihjpbBwZJl7Eo=','2025-10-01 21:57:44.7353936','2025-10-01 21:59:44.7265321',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'B3898DED-6A65-49FA-9733-54E1476582CF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'YFFqQtX4x3NfVhPX2LsuxBkCAJRT2qNGvJ9niaVStvk=','2025-10-01 21:38:11.0569247','2025-10-01 21:40:11.0568740',NULL,N'::1',N''),
	 (N'512B0D91-4455-4D5F-AF67-54E30B05E5B4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+gy9Raj3PJ/f+vRz8sSXACqbjgX/6Wh/jtRcqc5VAHQ=','2025-10-07 19:16:06.2194724','2025-10-07 20:16:06.2180769',NULL,N'::1',N''),
	 (N'0C3029C3-0B75-40FD-81FE-551B81C8EFCD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'3b1FgLGEybVQKpdK34AystjHQvpOI6m7tfuXENQEk1I=','2025-09-23 19:04:07.3009535','2025-09-23 20:04:07.2674124',NULL,N'::1',N''),
	 (N'BCB70AFC-4D65-426C-8E72-559E1C8D64C7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dy/1OEhl+Rte8cIcaMnIwuVy9NTIHQQEsJF1uAhyNCE=','2025-09-17 02:08:36.6198183','2025-09-17 03:08:36.6180708',NULL,N'::1',N''),
	 (N'A684F782-9614-4AC4-8532-55A389E02603',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wMy7WjD2Z8fZdhdjfBP0FAx2l6fAaRDnynzMrxLNM3I=','2025-09-30 19:44:16.0712880','2025-09-30 19:46:16.0598919',NULL,N'::1',N''),
	 (N'6E8DD66E-918B-46AB-B909-564D5605D82B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'BZem93uXjRhD9pO+gZoytdUKb8SPhYNH/YqbrsDtYR8=','2025-10-07 18:34:18.1991053','2025-10-07 18:36:18.1684672',NULL,N'::1',N''),
	 (N'9123982C-8935-4165-8D5B-566FF2C0DEE4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9kjX4k33IZ046ue49rKaE+rmhnwGp8FE4BdrTEwhacY=','2025-10-03 20:10:33.3183909','2025-10-03 20:12:33.3119031',NULL,N'::1',N''),
	 (N'FEB5D847-4766-47AC-80B1-569EA40C6E3E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'2KaY8P8H6ct5QhSlYLRMeJ6Mw3OBzn3sP6TgmwM70Ps=','2025-10-01 22:32:32.7506887','2025-10-01 22:34:32.7504190',NULL,N'::1',N''),
	 (N'0CFA894F-F446-467A-BB49-5756F23D6777',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'G1pxvlumBipMZLLyPD27xyitfLuEt3oixydfCGa9IvA=','2025-09-19 00:27:55.5689524','2025-09-19 01:27:55.5675181',NULL,N'::1',N''),
	 (N'6D021D47-685A-43E5-AD79-57587A229D5B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KvojlVmhDdh1xXAyv/3YL37E7hbF3ajKC15l446iZ1k=','2025-09-30 23:27:24.7700878','2025-09-30 23:29:24.7700142',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'6644CA78-B32D-48E2-A7FB-577470F19BF0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'34+U/Tng07kY3HtE2rxtR/nhnjYMrE4GvTxpYwmAKkU=','2025-10-07 19:16:06.2248769','2025-10-07 20:16:06.2180769',NULL,N'::1',N''),
	 (N'A90C8466-DC66-4176-BDC4-57B2428A1B35',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'luBqB/BcmK6Ww31Up516S9HPLcv+XyHHoeF//ayzK14=','2025-10-03 21:08:00.2476576','2025-10-03 21:10:00.2470549',NULL,N'::1',N''),
	 (N'9D95BA7B-100E-4C24-9474-58026A51F22C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'K9E/DT+NLPFqACtqV/Pi5o8rQXzOeEz9ElLV8GbHbOE=','2025-09-29 21:45:52.0675757','2025-09-29 22:45:52.0582963',NULL,N'::1',N''),
	 (N'9C061EA8-5C73-465D-B1EC-583788429FCD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wBV/RenWq243yxYceQG16JpRqDFeVqXG/zHoiBFgfwE=','2025-09-30 19:15:32.3952597','2025-09-30 19:17:32.3935367',NULL,N'::1',N''),
	 (N'BE607814-D2A3-4AB4-AA35-58766940EE0E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'EcexR+OiqiFjDr5mE3MQghAaNo6ft4mgj5pSgRgltCo=','2025-09-22 23:05:58.5360336','2025-09-23 00:05:58.5262851',NULL,N'::1',N''),
	 (N'DB860A50-8C6B-41FE-ADF1-58BC7DF03522',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'YvT4PEynwJBPXiEgbIsKhEZ1DBAmsJLP3zOB3cghhN0=','2025-09-16 20:01:41.1373343','2025-09-16 21:01:41.1221311',NULL,N'::1',N''),
	 (N'10D30F98-6E01-4824-847F-5910FCE9BDE3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+h/SCBNn3FiDgfyIlhxJo0L/BF5qF3jzFAO+812UKNE=','2025-09-25 00:02:02.4092224','2025-09-25 01:02:02.4081128',NULL,N'::1',N''),
	 (N'C6EB049C-5D98-463F-8412-59285135C9A8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'kEMejNS25tN9lyXEUMIoavpUbO9gdY2oUFVCeO2BoI0=','2025-09-09 17:43:54.1655999','2025-09-09 18:43:54.1651987',NULL,N'::1',N''),
	 (N'D3C7D777-AC42-4F1E-975D-592E77A42878',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'HC+aoB1BLILDyArUsMakXFpULUZjmTnEXJ7vYMQTCjs=','2025-09-05 23:17:08.3467649','2025-09-06 00:17:08.3451043',NULL,N'::1',N''),
	 (N'DB23D3DB-0EBA-4356-B1D6-59DE149A00F2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'G6ZZK5TI/o30tQMzH7+i1txQn2vOSlMYxdirSk3tRSo=','2025-09-30 19:39:49.8914941','2025-09-30 19:41:49.8914359',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'77B41BC2-1B3A-4AFD-9085-59E61C0F8C41',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'XQkIvdlWOXQ11ySUCH5ShsGpPzn+F7PYxZa+r8zFuxg=','2025-09-18 23:55:26.4040974','2025-09-19 00:55:26.3735131',NULL,N'::1',N''),
	 (N'4F9F88E6-FBFD-4AC4-AE74-59FBAD041CF6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rkaqlh8jjztK9ml6D7E1mDH4C/JNKQDMETA+vrfgdJY=','2025-09-30 19:38:47.5504083','2025-09-30 19:40:47.5503154',NULL,N'::1',N''),
	 (N'D2E86723-DCDE-41E6-A5EB-5A2072A7A152',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'xCfq/pRi31R7NMcaLvXztnHq0HlIWtEr22LJJStveTY=','2025-09-22 21:20:15.6914301','2025-09-22 22:20:15.6816536',NULL,N'::1',N''),
	 (N'4348732E-FF31-4E57-B579-5A983FEA3D9D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RWVc+IMbeHDjv4ODY05GQbV5PD52arxvwlY7o5m29A4=','2025-09-24 23:44:15.7853314','2025-09-25 00:44:15.7852622',NULL,N'::1',N''),
	 (N'3A53B9D3-EC28-491D-BCBF-5ADEABF6006C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Tcbl17gSrspAYszOwAVEOnGNAmKYdwnygcexDmFYR4Q=','2025-10-03 20:32:49.1967945','2025-10-03 20:34:49.1597636',NULL,N'::1',N''),
	 (N'3EB5D62A-968B-482B-90B6-5AE512E85A00',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'BZByGt1/cUyT4+OuW5KrH6ZNc0afANZoLxVRO3RhdsU=','2025-09-18 23:05:52.0850681','2025-09-19 00:05:52.0746727',NULL,N'::1',N''),
	 (N'B08F7A58-8C07-4E64-856A-5B223A3CF026',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'aCuTvV6ozM7ZrrYQeJEY/i9MX27DD/gAq1yIOE9qAkY=','2025-09-24 20:33:37.3657979','2025-09-24 21:33:37.1828829',NULL,N'::1',N''),
	 (N'EC365BE5-CA29-45E2-8B2E-5B67C7DF7DB1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lrLbln9EsUoPH4NBg+4MjlAew5iRzksv162J1sQlDHI=','2025-10-01 19:49:54.2965783','2025-10-01 19:51:54.2061374',NULL,N'::1',N''),
	 (N'D6EBC95D-86D7-42AF-AAD3-5B7F3E11D7CE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dbPjFVpYFhRwcX6jh+uPsKLLAXY5VKGLgKGnDkvF57E=','2025-09-16 19:46:34.2261023','2025-09-16 20:46:34.2129634',NULL,N'::1',N''),
	 (N'95DC1D11-B82C-4A67-8598-5BC2C8D24571',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zZK8t1dgxkms7ttrHfiJ5S76wDoh/yFAQgVOffuU3ww=','2025-09-22 23:13:32.0792708','2025-09-23 00:13:32.0779048',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'B2285D29-6876-499F-BBE7-5BD1C2881806',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nmANCFrnLzfDowLIXH2GZsnR+U7+0nFZPU2zAPtO0X0=','2025-09-22 18:47:25.9083365','2025-09-22 19:47:25.9081460',NULL,N'::1',N''),
	 (N'F92E920F-3530-4D8A-89A4-5C3C309EB1E2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'098yYrI3Odyl/QPOipWFiGL9g7xEb8oTlbpBR4L5x9M=','2025-10-01 20:33:03.9270473','2025-10-01 20:35:03.9260147',NULL,N'::1',N''),
	 (N'38F2E07B-717A-402E-9CAC-5C5C512A4BAD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dqZ4ZPO1S4uKtQikWMn/jjI4lTu52eVLfZ36sTOoLIk=','2025-09-17 17:01:35.7548815','2025-09-17 18:01:35.7435964',NULL,N'::1',N''),
	 (N'397C5E96-DC2C-4DA6-9584-5CC88E1DCF60',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zVBbncH4Kp3VZbFnZ72VKUNBmYGZmgqAR6DcmxxCPHU=','2025-09-05 22:48:43.8937761','2025-09-05 23:48:43.8793593',NULL,N'::1',N''),
	 (N'F2341C24-A721-484C-9E1B-5CFBF0C759A1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'mLrmS/m9YLsqKbGAmONnj3CAfFFZNIGACmCPe53LeZk=','2025-10-08 18:03:40.9536296','2025-10-08 19:03:40.9417261',NULL,N'::1',N''),
	 (N'986AF585-D8B2-4E30-BBC2-5D38704CF98F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'pUMhJ6z4GGYkTGfg8Ecs1tBGfRREmpRYg/xLGrETNwI=','2025-09-09 00:54:22.0351270','2025-09-09 01:54:22.0350448',NULL,N'::1',N''),
	 (N'4DCF9A30-F638-4924-BCFD-5DDCBA83D626',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9/NU+eieYIugJihZEzc2KK+XLV8PVkl356m+WEkmv40=','2025-09-22 20:01:48.5765179','2025-09-22 21:01:48.5746677',NULL,N'::1',N''),
	 (N'1B7D78C2-FD9F-45B7-83B8-5E59930ABB94',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'yg/qhZiQ0NlPEWaiCXzSmGU6QbS98Hq4ZNgD4zWkNMY=','2025-10-01 21:27:27.1392858','2025-10-01 21:29:27.1038266',NULL,N'::1',N''),
	 (N'65169E02-E79F-41B3-ACDF-5EC52EBAFE12',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'rey8z08VGsO5b7BYrucQ6Jf6C/8MXXx4bkSwMf7ZScA=','2025-10-01 22:00:21.2263855','2025-10-01 22:02:21.2262536',NULL,N'::1',N''),
	 (N'71B17795-5D85-4BE8-BDCA-5F204BD98A5F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Z0utC5xKKfNsBF6vg22m8AoMf1GHz3VblLMGiL2gmbQ=','2025-09-08 21:28:24.9509827','2025-09-08 22:28:24.9409182',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'593189A2-86F8-445C-9382-60165F98FCBD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'OkrWpqNwEy5Yke9osT2DKfeIoVzLZWd0mUC4Hbz4pUw=','2025-10-03 20:38:25.1931994','2025-10-03 20:40:25.1930749',NULL,N'::1',N''),
	 (N'682D7F66-7BA4-4B18-8299-605984F0C563',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'blc1BWpj+kc4VUqa5aherPWW2PvLvPIWooj9s1mgjbo=','2025-10-03 20:53:22.3822883','2025-10-03 20:55:22.3822451',NULL,N'::1',N''),
	 (N'5BB6358F-561C-43F3-9EC1-6075BE07A8FF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Z/4koN5s++fsALmE5hJ7OP3ggPA3XobKhgzDllrULZo=','2025-09-22 19:01:21.3612506','2025-09-22 20:01:21.3608482',NULL,N'::1',N''),
	 (N'7D67DAD7-C062-4490-9CEB-60B5A80911BA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'PTvUW2KPWUMf7dZdeIYF46HGJ2ukgcHSHJYrk/bA5P4=','2025-09-23 22:28:24.6589596','2025-09-23 23:28:24.6430264',NULL,N'::1',N''),
	 (N'68C744FE-2DBC-4981-9D9E-611605EAF179',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8vPuRS3BRL+LKRvs4gpxzeYU1iQHrxOClJaLr40dcEY=','2025-09-24 20:36:44.2664358','2025-09-24 21:36:44.2663496',NULL,N'::1',N''),
	 (N'10616FD9-D13D-4C6D-BAB3-616A25F6B4B7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ge08L30+pNmCXWwsydUJnO+8lv51/nb+vON+7EpUxpE=','2025-09-09 01:44:24.3669112','2025-09-09 02:44:24.3653782',NULL,N'::1',N''),
	 (N'3249F4FE-B90F-40BA-B188-618CF35190EB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'KPGNGCtb8Tfan5RifkRRN/WUye7kbZVrJ7faVQxcBdg=','2025-10-01 19:51:34.2712802','2025-10-01 19:53:34.2709594',NULL,N'::1',N''),
	 (N'C8369558-C1DA-48A2-B743-61F158C92964',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'CSn7iO990Hab3+TFmxpfGR54U8/kppaz0d5whdyEjoE=','2025-09-16 20:44:51.2869831','2025-09-16 21:44:51.2761800',NULL,N'::1',N''),
	 (N'65464A3A-D57A-43B2-8EEC-61F9D35627BA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'CMUOJoaWUVaDc5YugxUpifD6/xwg8h6B3vpd8vUAH/g=','2025-10-01 22:39:43.0273389','2025-10-01 22:41:43.0091228',NULL,N'::1',N''),
	 (N'5198F2B3-0897-486C-A966-621D0A6CE5CE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'CyFwMs9MMQFzCSZsXuCJM1kRKAaSem0BrjyyupnXjqw=','2025-09-29 21:54:35.7877279','2025-09-29 22:54:35.7876738',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'9C2C80E7-C234-4091-8273-62585AE9AA7C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'h/WT9wAqkaTjsmlwZPTTQQRDddrHghWmPbqju+gIDQw=','2025-10-03 20:03:45.8011191','2025-10-03 20:05:45.7947062',NULL,N'::1',N''),
	 (N'281C7037-A0A1-4EFC-A776-62CFFF0CF8CC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'MYshHLErTQ4b2592dOat63wfXfHYKoqX3lgapUCMvXA=','2025-09-16 19:56:57.1500550','2025-09-16 20:56:57.1480847',NULL,N'::1',N''),
	 (N'8430ECFC-3820-48AB-9C11-632243646C83',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rVkwykiMsS2nLrs/rLqfBDbfXlu07GzsqVAwTaQpcQs=','2025-10-03 21:07:25.1173096','2025-10-03 21:09:25.1158076',NULL,N'::1',N''),
	 (N'6D4D8B3B-C8E2-4403-81BA-63870D26C578',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qh8cZG6W0PX8V215byDXBXnmv6PUskKN9/hWJ3uIFvI=','2025-09-09 01:35:04.4366246','2025-09-09 02:35:04.4355608',NULL,N'::1',N''),
	 (N'90505B7C-3023-451D-AB07-63AE9A23E4A4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GeBrspbAcLcDdFdHZDAB3wm09/6ni5be6fYgLixAw2c=','2025-10-03 21:18:52.7706873','2025-10-03 21:20:52.7705667',NULL,N'::1',N''),
	 (N'5A442F75-4798-44B0-BA7D-63C70BF60264',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'twhKwzuDXZmssKPwM5eoYDgWbtGVKi6WL0iwijNBhoc=','2025-09-19 00:09:35.2493835','2025-09-19 01:09:35.2344051',NULL,N'::1',N''),
	 (N'6B5A5A29-8FD0-471B-9605-63FAE0F8B688',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'KaHk1VZCSYx3VDapiAuSdjXZbez4vsNHmfU2McE1dfw=','2025-09-05 23:24:35.9278199','2025-09-06 00:24:35.9271260',NULL,N'::1',N''),
	 (N'FF549146-CC9C-4D8E-90E3-63FDB74622CD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'e/GkB2mZgzDF0ScDnWuS8hsym10D/+z7U3bZ2pVU5SE=','2025-09-18 21:59:31.8469102','2025-09-18 22:59:31.8396837',NULL,N'::1',N''),
	 (N'EA321A3F-DE96-4B3D-9D5A-642A5521511A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/e7IxMmRUc3vOybSpHwCjkF8OhpAcU1eup1ucwg+uhU=','2025-10-07 18:55:07.5432030','2025-10-07 18:57:07.5375891',NULL,N'::1',N''),
	 (N'D60495A9-3CAE-41F3-9637-6438EACA3EB0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0YSu/rXrsco9WHKKbOPIQYdM39wJ0e4QpvV5GPCmuqA=','2025-10-01 22:00:54.2840159','2025-10-01 22:02:54.2839369',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'31228E1F-B0A4-4322-88D4-64426DFDC92F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'RWVc+IMbeHDjv4ODY05GQbV5PD52arxvwlY7o5m29A4=','2025-09-24 23:44:15.7424539','2025-09-25 00:44:15.7421252',NULL,N'::1',N''),
	 (N'D311204F-1CCA-4250-AEFB-648376F5E22C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'uMgfgh5J8tw+3Rgw6PwhgLFLSdWNrMNnEpmIwnkvh1E=','2025-10-03 20:26:38.0468806','2025-10-03 20:28:38.0467525',NULL,N'::1',N''),
	 (N'9478541C-E8D3-4E78-80D2-64976D209AF7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'j0TvaFhNN+gfs53unPZVUgrozOeb4cwDrsxWwwKprsU=','2025-10-01 21:52:37.6727719','2025-10-01 21:54:37.6727297',NULL,N'::1',N''),
	 (N'7FE51B1D-220C-41DE-A744-64F287DC97F4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ktqhr5UNgEZBeHvominT2SDVAnpyRppWmIahOH9aILE=','2025-09-30 23:16:44.8008533','2025-09-30 23:18:44.7507253',NULL,N'::1',N''),
	 (N'F0863036-E147-4FC6-B6DD-64F87188FCAB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ISHas+QGCQC+WbSgsvT6q4w/ZVS6twQEGkZ+S3eZ8aE=','2025-09-30 20:59:13.9803266','2025-09-30 21:01:13.9789607',NULL,N'::1',N''),
	 (N'8064CBFC-256B-4D76-B8A3-6571E990A1E4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ymzklw75jiq3TBwdUilEVmVtKthCp0kseG81PM50b7U=','2025-10-01 21:30:33.4460449','2025-10-01 21:32:33.4459870',NULL,N'::1',N''),
	 (N'BBED3641-49F4-4A93-9F5B-65A51780FCCE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'aK4ntvGZsuRw1HLGYJIQ1dCIa44PD0cVyK8a56i5oEM=','2025-09-10 18:27:38.4439363','2025-09-10 19:27:38.4438595',NULL,N'::1',N''),
	 (N'06F14562-11F9-41A1-9FA8-664BA0EE2581',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'CvxlJwiA7CxbxV0s5nxr1CSk6/1rp/E/SoF3DGspYYA=','2025-09-30 19:30:46.1998182','2025-09-30 19:32:46.1794943',NULL,N'::1',N''),
	 (N'23B46040-A693-4378-AB7E-666876537291',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wN9DjvfEDX4SjUZMJhitH5vyLeIi14C4aUgC8VIKAao=','2025-09-17 02:04:23.0354662','2025-09-17 03:04:23.0353979',NULL,N'::1',N''),
	 (N'5B483560-875B-450E-AEE0-669E9DC31092',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'PkYuWtfp+m9LhWXiaSMhIBvMSRF2Q7AB4nWm6CNyVLY=','2025-09-10 18:18:46.2320919','2025-09-10 19:18:46.2205134',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'810007F6-EB3D-46C4-BAA0-670166296E0F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Kko3gxmQIXkDdIlRVAOVHvJYmHwYMBi82HXdeNbp1ns=','2025-09-22 20:01:48.5854340','2025-09-22 21:01:48.5746677',NULL,N'::1',N''),
	 (N'5B2FEA61-F3EE-4AAC-AE36-673413BCCDA9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bmSmPpLfGFdU5kfzTbCf+gkBsB6EsYccIcmAJWCLVqk=','2025-09-18 23:30:42.3072879','2025-09-19 00:30:42.3058594',NULL,N'::1',N''),
	 (N'6697E50A-6FF0-46D7-BA32-6771A641D35E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Znf4i+fcyZFk8h3WxG6R2ZmNPhaDv1yVzcQSYJZtNL4=','2025-09-24 23:41:29.0122529','2025-09-25 00:41:29.0048101',NULL,N'::1',N''),
	 (N'6904DEFB-F894-4F48-9A54-677BED7FBF75',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'e5we6vyGePtKQOz7yy/qvEpY/jlCSGbdpgXKk16D+i8=','2025-09-16 19:38:52.8870503','2025-09-16 20:38:52.8701235',NULL,N'::1',N''),
	 (N'1DD06DFF-9535-4B7C-B5BF-681C22863211',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9l3nj6vQOIZYLgJ6yOdDFz/QfrS+mt52KR+ZVFxkWlA=','2025-10-03 20:50:59.3232330','2025-10-03 20:52:59.3083153',NULL,N'::1',N''),
	 (N'86863AB3-4C81-456B-B531-68203B799B5F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'VEMwi74DXEFR/hjdPfmXVhkjZnaq7zavuYOXekE5V/E=','2025-09-23 19:04:06.8201112','2025-09-23 20:04:06.7789857',NULL,N'::1',N''),
	 (N'6F84B4C6-D2F6-46FA-A2C2-688020890269',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nTzw8l1MrnDexcMsrCwQXu9AXsc2AT6NBPsYNKndyQY=','2025-09-30 20:00:10.1221774','2025-09-30 20:02:10.1130303',NULL,N'::1',N''),
	 (N'123CE819-7806-4A52-95FA-688CA376E9AE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'S1bhGNXd6o9nyCc+Zy2rNx3qa0aasVov6BSAMvKiE/g=','2025-10-01 21:28:40.3801164','2025-10-01 21:30:40.3800713',NULL,N'::1',N''),
	 (N'895EB81B-0BEE-4ABD-A3D9-6890CE1F8FC2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Ur3UnUTOARiftr6CwVnH2BnCyUUJPFdb02LREcvowTc=','2025-09-05 22:46:34.3525263','2025-09-05 23:46:34.3524366',NULL,N'::1',N''),
	 (N'ACD8355B-5321-42F0-A634-6891C167211D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'tt7MwgLM5x8aaeOUGFwl9ZGQOo8hxuk4dR+tf7Dm5FY=','2025-10-07 17:07:12.9632358','2025-10-07 17:09:12.9619321',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'0459F4FF-2A53-47F5-809D-68A0BBB3E826',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'd3QVFiRGqQyfrBPMsl4qUBOAWpB86Q2EvK0vF7R+8rk=','2025-10-01 21:53:07.2579613','2025-10-01 21:55:07.2579160',NULL,N'::1',N''),
	 (N'157E77BF-BFAB-4595-AB77-68B5D957B6F7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'IAQqS7ZXdSnkEySN4RW+iwXYV+joyam4suLcLMlUMTA=','2025-09-29 21:45:52.0353032','2025-09-29 22:45:52.0350257',NULL,N'::1',N''),
	 (N'F22DA5FD-7E11-4704-BCF5-68F69C797F6B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'NCv+lvBhIp39PtEvZrEFIF6wOhvm1H0tUTAZccxbOqY=','2025-10-03 21:20:27.0818530','2025-10-03 21:22:27.0816108',NULL,N'::1',N''),
	 (N'8CDCF22F-115C-4269-B131-6931A70B7D3F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'0H+Uh9I4GStrJhZRPjiOmzyjfp5QFwy/nTfwisXpN/0=','2025-09-30 20:02:59.7502570','2025-09-30 20:04:59.7500216',NULL,N'::1',N''),
	 (N'080A2AE4-6635-4F23-BA4F-69EFCAC69686',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'UWS3lRi39KzFzsQoXyhafriO3pX2di7b4KgUsXcqZbA=','2025-09-30 19:44:12.9580477','2025-09-30 19:46:12.9423204',NULL,N'::1',N''),
	 (N'27431E65-16B3-41F8-9597-69F27401F631',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N's+LneVJrXlYN2/shKaQRDCq6mOW50y3b4iynWm2qY20=','2025-10-01 21:19:05.2544503','2025-10-01 21:21:05.2470511',NULL,N'::1',N''),
	 (N'891CB00A-9CB2-4225-81DF-69FFF3F5C72D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'KzjEoKNiPjYogaTu9K6ckmG979ygdko05omzYRcwIuQ=','2025-10-07 18:20:11.7222737','2025-10-07 19:20:11.5977968',NULL,N'::1',N''),
	 (N'4B58403F-C47A-4CBD-B726-6A33B5B3E3A1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'b5iS1H+918eHGLCoirdHy2ZZldaRzxgoSHcFgV9uoXc=','2025-09-30 20:12:46.3128165','2025-09-30 20:14:46.3014484',NULL,N'::1',N''),
	 (N'CE253A88-2B88-4466-87F5-6A43CE2DC245',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'HWwMnp2mg0sX4Fx2C8alhx3lTL/+6yjHQQWcG5AZcBI=','2025-09-29 22:15:47.6400928','2025-09-29 23:15:47.6321146',NULL,N'::1',N''),
	 (N'A9BD556D-60B3-4901-83AA-6AA726E7B506',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KuITsRTf3M18SZHgK9IimIK4wM0QQ8h7VhYcVhRAIzQ=','2025-10-01 22:44:46.1765649','2025-10-01 22:46:46.1765230',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'0BCFC26F-2EF9-4298-9C0E-6ACA0EEFDC77',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hQtSsWwygUneXhxhTmbOCxwxHipnhzzHqkwXX6fGyLw=','2025-10-03 20:11:41.2212986','2025-10-03 20:13:41.2212557',NULL,N'::1',N''),
	 (N'D53DFE6B-3362-493E-B370-6B0D886C4A19',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'oRGnb0Ke5ovnxtWj3gGk/Cp3z05ZkwmEUCY9ESsYIq0=','2025-09-22 19:06:55.6317684','2025-09-22 20:06:55.6160454',NULL,N'::1',N''),
	 (N'0CD3013D-72BE-40C7-8F09-6B1CB79272C5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'grkf1Jn77EBl3YTJP3X4fVHC1wAKJQ6NWGx/q+aawkg=','2025-09-05 22:58:46.7383607','2025-09-05 23:58:46.7338817',NULL,N'::1',N''),
	 (N'3270CA4B-B931-48E8-A218-6BAA22461315',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'4LPB+OngWeeI5lD02xdDoCKcgLh63UIIzzFGhLWAPY4=','2025-09-16 18:32:02.4738153','2025-09-16 19:32:02.4737558',NULL,N'::1',N''),
	 (N'9A4BF8A4-998D-4B7B-A363-6BB9724F48B0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lNePVZwqpg+0Jc+yROYRd15KaPiHvevLkh0Dgwb8wYs=','2025-10-01 21:48:00.9315103','2025-10-01 21:50:00.9225669',NULL,N'::1',N''),
	 (N'0CB275F5-99A9-41F8-9059-6C0C6B3F9E8F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5qz9yEhRbYbr/Fb26X9+PqiyVPLOhEsihNwQj3EKEa8=','2025-10-08 00:54:51.1049883','2025-10-08 01:54:51.1048941',NULL,N'::1',N''),
	 (N'7601578F-A0DD-40E8-AA0A-6C6FD5221EE7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'oco6YlEa9kmNzu+HYB0ClxA5TFiTOmEWl2IoL0G9NDE=','2025-09-05 23:00:50.0525042','2025-09-06 00:00:49.9870795',NULL,N'::1',N''),
	 (N'90996BA9-AD8B-462B-A265-6C72C0F9E9A3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jhl6r9/zBLiFz0usMzvCK3bojsD//DEXSjUPEmbt3tY=','2025-09-17 21:10:40.9546233','2025-09-17 22:10:40.9545348',NULL,N'::1',N''),
	 (N'227D5A80-4C85-45A6-A722-6CAA0A5CD6C9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'4vI1GhGra01xN6PNiHlSVYKa7hZPuNOw82OLXosG9c4=','2025-10-03 21:12:46.1371968','2025-10-03 21:14:46.1371200',NULL,N'::1',N''),
	 (N'D4418919-FF8C-4B2A-85D6-6CC1CFFED25C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N's9U7d7eWbeOq4XYe5gAOVHbL1lzvHHUEgjbh57qN1yk=','2025-09-10 18:51:20.0521577','2025-09-10 19:51:20.0510824',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'461BE9B9-C3B3-496F-983C-6CC4CD244FF3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cRsG3CttSDlGVA9EME4J2EPIZCf9FzO0350kbs1ADcI=','2025-09-30 19:39:49.9054918','2025-09-30 19:41:49.8914359',NULL,N'::1',N''),
	 (N'815EEDD8-D8FE-4CE9-8471-6CDE9C6A0614',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'MYaYeiN4GWbuR4dXuwsDleMPUiOBGlTgMjdQU41C4sg=','2025-10-01 22:46:30.8004734','2025-10-01 22:48:30.8001966',NULL,N'::1',N''),
	 (N'2EBE380D-22A7-49D9-940F-6CE48979766C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ff/NM1+KGsYbWYGXk6b4NJ5CdOgRuTd8dAJHnfc+4Uw=','2025-10-01 20:44:53.6436836','2025-10-01 20:46:53.5912348',NULL,N'::1',N''),
	 (N'52E56830-2430-448C-A1B5-6D2E31EA9978',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Y1XWuxEA0XdT1tnhEJmRst+rwp6veiFX1+XFbpRTcNI=','2025-09-17 01:14:48.1546279','2025-09-17 02:14:48.1404610',NULL,N'::1',N''),
	 (N'57EE9E91-8A0B-48DC-8EE2-6D70B8D184E5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'MTMsjbHlNbZXLhvD2ftvZUTnbkc7DQ6/wtT8sRRa+rw=','2025-09-24 23:24:38.0807225','2025-09-25 00:24:38.0794946',NULL,N'::1',N''),
	 (N'0BD5591F-45BA-4B02-8A16-6E0D07993531',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rmOXSro8lS8RHGDw741bbDVA01OMrt1RSyFECHMpghA=','2025-10-01 20:23:45.6373421','2025-10-01 20:25:45.6371791',NULL,N'::1',N''),
	 (N'8B434CF5-245F-49D2-BE29-6E0EC0CE1BD6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'gSvgOFr+a7Q2HYmdS/04KjFaREXbv6rzuy/JNDNxxHY=','2025-09-16 21:22:22.5522750','2025-09-16 22:22:22.5509234',NULL,N'::1',N''),
	 (N'D54F7AAC-F5E9-4672-94EA-6E3D0A5C2E89',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'enIl9++nmA5frhaZU0Swn4nbZjydDWFAkcMl0XWROyQ=','2025-09-17 17:47:18.2758147','2025-09-17 18:47:18.2742659',NULL,N'::1',N''),
	 (N'D5B4FCB6-3799-486E-A52B-6E8F27B52FAE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'thURIeLBB3w1uG2rsQh7jp+fnu4NzullS0yAaU9N/YE=','2025-10-01 22:19:27.3743156','2025-10-01 22:21:27.3389515',NULL,N'::1',N''),
	 (N'59D8E85D-891D-433B-8F7C-6EB674B4DC1C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'E3ZHDHvG5u69DAnO2vBofLMbmN2StG4YDb5Mt5FYNjs=','2025-09-16 20:16:06.1941054','2025-09-16 21:16:06.1929549',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'C8C6443E-633E-4761-A220-6EED89531783',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'RC3eRTbYXhiY5DFx4toqTmYkBTqCD6rkXEuPAB4eApo=','2025-09-24 22:03:38.9070726','2025-09-24 23:03:38.9054263',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'1626A978-E619-4492-8F19-6F01E9A4E36B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'blc1BWpj+kc4VUqa5aherPWW2PvLvPIWooj9s1mgjbo=','2025-10-03 20:53:22.3304259','2025-10-03 20:55:22.3302968',NULL,N'::1',N''),
	 (N'B409698B-76F8-4EE2-B6D3-6F1470C659EC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'yKNokqrwaB8btKKMFtEBd5eATp4UJPlM73RsDqSd+Rk=','2025-09-30 19:27:26.9975505','2025-09-30 19:29:26.9848657',NULL,N'::1',N''),
	 (N'395971D3-E037-4EB5-BE8D-6FDA26047403',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1RJRjPVkPAtPFp29VX5R/GtDwlXryimosjkmas46Uvw=','2025-10-03 20:15:04.8209279','2025-10-03 20:17:04.7767806',NULL,N'::1',N''),
	 (N'0DAD3EF8-D2CF-4CEE-A705-6FFCE36118A3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'yG6b7CNd5BNLpYFdK/PhXGjlQZSBgnu/NvuGuA0w7HE=','2025-10-01 21:38:01.3714030','2025-10-01 21:40:01.3372487',NULL,N'::1',N''),
	 (N'E7BD05E5-B768-4B6F-9B5E-6FFD02660C36',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qFWwQWdHUcAsOeizDAHvZlnstMYeZsxh2fN4T1UdogA=','2025-09-17 21:04:44.9718300','2025-09-17 22:04:44.9621350',NULL,N'::1',N''),
	 (N'3F7FA872-9D72-423B-937F-704687A99761',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lQfaE+Recfhd0ToedG/zpJy8PhwxT2TV0RAYkf9lLEQ=','2025-09-05 22:56:38.9795500','2025-09-05 23:56:38.9689684',NULL,N'::1',N''),
	 (N'A9CCD13B-D106-49E5-AABB-708B5C38FC5E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ENbkzjCdb9DkudXISXLbRmhuRlHkypLWkX0P0RVuG9k=','2025-10-01 22:43:41.6770820','2025-10-01 22:45:41.6770402',NULL,N'::1',N''),
	 (N'90C57462-DCCA-49A2-B455-7093138817CE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'd3QVFiRGqQyfrBPMsl4qUBOAWpB86Q2EvK0vF7R+8rk=','2025-10-01 21:53:07.2037197','2025-10-01 21:55:07.2034203',NULL,N'::1',N''),
	 (N'A64A8AC4-2DD8-48EF-9BD9-70E7AB0FBA4F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'KuITsRTf3M18SZHgK9IimIK4wM0QQ8h7VhYcVhRAIzQ=','2025-10-01 22:44:46.0943632','2025-10-01 22:46:46.0942345',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'98499849-F677-4143-9B02-70FE70625767',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'N7cM1d3+sA7Wj4m4FCYxIYNrJQ1QYfgY7qct5Ybv8+c=','2025-10-03 20:36:07.6650464','2025-10-03 20:38:07.6649990',NULL,N'::1',N''),
	 (N'8DDBD026-3A42-4BF3-878E-712A2467FE16',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'f0Bbn6bonI2RTQ1KZ05fG8sGH1oZBiWrf5C6hLHGmKU=','2025-10-06 19:52:45.5829997','2025-10-06 19:54:45.5827374',NULL,N'::1',N''),
	 (N'FCD9862E-B235-444F-8848-7137EF6AE012',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fv5RQFtmhmXnVZ6CT4OIXn6CLeBHyBGSKO3pgNLlKMY=','2025-10-01 19:49:54.2063111','2025-10-01 19:51:54.2061374',NULL,N'::1',N''),
	 (N'21BFAF51-3F6D-432B-9902-715D5F14A444',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uahrjC1bYbTLwXDediMzOm/aYuwx5mkFOaWXr5MGxUE=','2025-10-03 20:16:29.3051240','2025-10-03 20:18:29.2740069',NULL,N'::1',N''),
	 (N'E3F09181-BD8E-46F3-9C23-71D15251BC7A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'icZPQc3oDtJHull66qka3M05KOju7BkPMZWQE/oBMe8=','2025-09-19 00:33:11.8055693','2025-09-19 01:33:11.8041521',NULL,N'::1',N''),
	 (N'492695A6-7717-4F05-8DF0-72F4E7E5E527',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZbjQsAbsfGPZqweVIOSaeI2Edg3K4oqZpY5TX7X9QG4=','2025-10-03 20:16:29.2740560','2025-10-03 20:18:29.2740069',NULL,N'::1',N''),
	 (N'75B18CA1-CEB5-4D5A-B74B-7319C154AD67',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Nj0/R1UMFq3guqPd+sXiaQIeHdK6yLcsw1drAb7wD7k=','2025-10-08 20:09:20.8199170','2025-10-08 21:09:20.8010966',NULL,N'::1',N''),
	 (N'09F523E2-394D-45DF-ADAE-732C456FF9F0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'afF5PyIl3k9holeRtoGFGfexpAKJlNg1NBRoiUG1ITQ=','2025-10-07 17:11:38.4085100','2025-10-07 18:11:38.4014025',NULL,N'::1',N''),
	 (N'74B5FB29-FC6F-45D4-A0E2-73E875EC16AE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'/y54+G3GZzeV6l5Xf1guP5yS9SbEgnudgNXTpx57ctU=','2025-09-17 19:56:30.8731485','2025-09-17 20:56:30.8585444',NULL,N'::1',N''),
	 (N'ACC244B0-CEB6-42A8-A610-7445EB01A6A4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'PTvUW2KPWUMf7dZdeIYF46HGJ2ukgcHSHJYrk/bA5P4=','2025-09-23 22:28:25.0207421','2025-09-23 23:28:25.0193680',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'E71B6FA0-7845-4CD0-8D44-748CC032758D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N's3GeWFV1J48g+rW2EldMYiA/55DkW7TFY0SqUjVWMMw=','2025-09-30 22:31:46.5930832','2025-09-30 22:51:46.5929721',NULL,N'::1',N''),
	 (N'62501587-A0D4-4F44-BB36-749BE1F39D7F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'p58XbsZEd4wC3kdHTblPrBT/rFZjWZKuDx/xZNnp5ik=','2025-09-18 22:26:05.9351236','2025-09-18 23:26:05.8978517',NULL,N'::1',N''),
	 (N'EE257F48-6C7E-44ED-9288-74B229AA9A8E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'rVkwykiMsS2nLrs/rLqfBDbfXlu07GzsqVAwTaQpcQs=','2025-10-03 21:07:24.7606255','2025-10-03 21:09:24.7458466',NULL,N'::1',N''),
	 (N'AABA52AB-E59D-4244-849A-74F54A6ADA8C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'KaHk1VZCSYx3VDapiAuSdjXZbez4vsNHmfU2McE1dfw=','2025-09-05 23:24:35.8396805','2025-09-06 00:24:35.7513244',NULL,N'::1',N''),
	 (N'FD8AF401-9558-41EB-887B-7512E3181032',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'hahENn3UfUIorrE6LUGJ4mLx5S8WEH7k/oAM+HdvdWo=','2025-10-08 18:18:12.8534802','2025-10-08 19:18:12.8532587',NULL,N'::1',N''),
	 (N'E4D47688-A071-4151-A098-75CF3C6E5A26',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'W45zrabEAK4oMExDhyPW1qcF3R9sARFRqgT93DklkkQ=','2025-09-16 22:30:59.7352712','2025-09-16 23:30:59.7338143',NULL,N'::1',N''),
	 (N'5C470676-50FD-4C6F-A226-75DFD45BB517',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'jx2R5RInIwLPhJ8AOvhBdlHr8qFVPi8fOTRH7oXg+yE=','2025-09-08 20:31:30.3859549','2025-09-08 21:31:30.3094180',NULL,N'::1',N''),
	 (N'71553E90-6C48-4F89-9F53-76032309CB3D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2lhWVxM1L2jOZoPX4R/BcBlodpoGag8olV8PpWZAryY=','2025-09-05 22:55:56.5313427','2025-09-05 23:55:56.5312743',NULL,N'::1',N''),
	 (N'9F409E57-776C-4676-8AD1-7679DE32B456',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ekoXi7K6GdipOwOEx5bPW/ERES8HtFvmaWxYfpjiGg8=','2025-10-01 21:50:15.7571045','2025-10-01 21:52:15.7491045',NULL,N'::1',N''),
	 (N'8EF74A7C-5E66-4EA8-97F2-767B2207A944',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'FKGaEWiKcBxZ36lZwtcqucVJd1iBJe0D7homNUSt958=','2025-09-22 21:30:48.3847947','2025-09-22 22:30:48.3832816',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'42E524A4-DA6C-49F8-A83C-768B4CFEF253',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'9Zfsz/H+z3sIorz9kREsUrnGcTrtVuKSaoB4/pPLRf8=','2025-09-24 21:53:15.8891281','2025-09-24 22:53:15.8886208',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'40D88A3F-BB52-474A-A254-76929E94108F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6xY8RHRFFooai3CY3xcN72bL2RtiZXT3Q29EWvTagAM=','2025-10-06 19:44:37.4350803','2025-10-06 19:46:37.4233146',NULL,N'::1',N''),
	 (N'222E71D2-8151-4B96-9982-7692B98CD17B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'UNFjsLwEiR73p6DVD2aLYUBMorQWyunYKLuevmU/Wo0=','2025-09-18 22:32:53.0834807','2025-09-18 23:32:53.0687424',NULL,N'::1',N''),
	 (N'86A23088-F246-4330-8B5C-76975434A697',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IsW8fH3HulmGYyVWxh0elqTcQY/wUXWpgCbo7W14VQk=','2025-09-24 21:55:51.3765475','2025-09-24 22:55:51.3764526',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'9286A5C7-AF04-448E-824C-76BB48DEBFF0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'82rKry/X6drBoV+FodvEMVyg1vfq+NZ+tNlHR36CYw8=','2025-10-01 21:51:52.9986435','2025-10-01 21:53:52.9985326',NULL,N'::1',N''),
	 (N'F4A1F22B-B14F-44DC-B5B6-76F0E8084D1D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'twhKwzuDXZmssKPwM5eoYDgWbtGVKi6WL0iwijNBhoc=','2025-09-19 00:09:35.5732777','2025-09-19 01:09:35.5716331',NULL,N'::1',N''),
	 (N'84C590F2-0C02-4EE1-BC17-7719B15AD967',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RYLsG/NKaI3GGX0HsDM6ps8D3PLZRhA6gtRemU6LeQY=','2025-09-23 22:28:25.0289951','2025-09-23 23:28:25.0193680',NULL,N'::1',N''),
	 (N'B8C6E2D1-5922-4FCE-8065-7726365EA0F7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'e0WtMhV+1HP5fEFbzeAHeVTednfuJLWhOABOIWPSKrs=','2025-09-17 16:32:55.7239936','2025-09-17 17:32:55.7238493',NULL,N'::1',N''),
	 (N'85CADF89-9A05-40C3-ADDE-77571100B224',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qf+7FaLjTzB8J5heM3JBHVPepILN5JV2aPvVVQkW/pk=','2025-10-07 17:07:12.9721088','2025-10-07 17:09:12.9619321',NULL,N'::1',N''),
	 (N'52343EE3-0568-489B-8AE4-77D7C47CC0AA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'VzO9Ur8egKTYplYVQPlKerpPyWw0AkZ9EeLcrZYSQ8U=','2025-10-03 20:06:36.9509504','2025-10-03 20:08:36.9507308',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'BEFA2FB3-4CDA-4C06-8C2E-78BAFEE53EF3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'felY73QF4q93hCwhdbkbTBDNqRzrpwsb1MdmO9RKWTE=','2025-10-01 22:16:01.7746744','2025-10-01 22:18:01.7745530',NULL,N'::1',N''),
	 (N'43008165-ACF9-4ACD-85BD-78E603E8B9CB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Q28CPKp1FCzEWJE5Kvd15vwhPIPf5+kxzSkwgHw9SGE=','2025-09-30 20:45:30.5283650','2025-09-30 20:47:30.5105608',NULL,N'::1',N''),
	 (N'63CC9067-4554-4C17-8011-79010C61B73B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'tYQh9uV6fqz9Z1dwnGunHMk315BWkvbjWS1gkhnP5Zc=','2025-09-08 21:40:08.1561510','2025-09-08 22:40:08.1550720',NULL,N'::1',N''),
	 (N'7FD56840-10D6-4FEF-8307-79012347FA66',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rxrGT1guQuddXIrNp53Dlcp4mtmPbAuf9FTlsBLhah4=','2025-09-09 03:22:21.4862286','2025-09-09 04:22:21.4744623',NULL,N'::1',N''),
	 (N'6327BCF2-35EC-46C3-8F9E-79122DBD8C33',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'KIAw0jWPFSUuwXdwMiA1g5zFT/7BmEGFsjyAGxuoptY=','2025-09-24 22:05:23.1773951','2025-09-24 23:05:23.1134329',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'2BE38FBA-5315-4B5B-9258-7942B1A52FFD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'NDacTNNV43nUNvc3vFSvOilWKR7WBhGlLz83GSm2G0s=','2025-10-06 19:47:20.0599761','2025-10-06 19:49:20.0598098',NULL,N'::1',N''),
	 (N'37D7B205-5BDA-470F-A38F-79AE8C8FD9EC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hoNvIwfZ5mcw5f0Zp6gtficDRq/Si4Q1gNbL+5mGdUk=','2025-10-03 20:28:30.9241511','2025-10-03 20:30:30.9240192',NULL,N'::1',N''),
	 (N'7A16C1F5-88D2-44AF-A246-7A59FDB04E27',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5Rryvz1kf7kZKcJjuxrkqZ03gkbx2QFv0LGrl/troPg=','2025-09-24 21:56:02.2725178','2025-09-24 22:56:02.2652477',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'DDC8BEB7-914E-4425-8887-7AA8882A1DC7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'fYGHp0st97yVByCkgMRGYakPJq7IJDKk5bcMoezfaxQ=','2025-09-23 20:37:22.1737944','2025-09-23 21:37:22.1734750',NULL,N'::1',N''),
	 (N'38AD52B7-593E-496A-93A0-7ABA68907B3B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'WGZocXETrOvaeOMax+xXAif/v2IhrS2ycQsUlKodWDk=','2025-09-23 19:44:45.6669769','2025-09-23 20:44:45.6447421',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'F635FD94-FDB0-4F97-8CD6-7B0EBEE47A48',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'B9TsaBdOgRwwUkWHAx52029XjFiRh/qRqxzQwyctkPY=','2025-10-08 00:54:52.8309457','2025-10-08 01:54:52.8176535',NULL,N'::1',N''),
	 (N'FE003E2B-4AF6-4B08-8EC1-7B91AD353647',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ZbjQsAbsfGPZqweVIOSaeI2Edg3K4oqZpY5TX7X9QG4=','2025-10-03 20:16:29.2334024','2025-10-03 20:18:29.2332693',NULL,N'::1',N''),
	 (N'2F59CD2F-4858-490A-B0BC-7BEABBBCD21E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qV/gYK/roKRhuoJNBdi1TBsfubYyryf4Nj1UC/hzsaI=','2025-09-22 19:45:36.9217175','2025-09-22 20:45:36.9216122',NULL,N'::1',N''),
	 (N'CC8D7DD1-8510-4310-9BB0-7C113BFE7D7A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'3eTuPmj0lioUF2zuxScCxKDO22hNYpSy9PpZ2dmoD3Y=','2025-09-16 21:55:26.5525871','2025-09-16 22:55:26.5393140',NULL,N'::1',N''),
	 (N'A4938E63-0AF9-478B-A66E-7C2441DDEC1E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'i7GTSVsrLR50B4HLGagKwHjYSzI84fVy5K5OtCRk9fo=','2025-10-08 20:22:50.7246230','2025-10-08 21:22:50.7232691',NULL,N'::1',N''),
	 (N'931D90DE-3F4E-4E3D-B213-7C2F400F982D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+87O/12rW5M5CCcQMmyccnew4zyVcUXeoOUP7ZOW5ww=','2025-10-08 20:38:41.7283407','2025-10-08 21:38:41.7269675',NULL,N'::1',N''),
	 (N'19C12F55-31F0-4D7F-A6A1-7C39D5157A7A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0YTig28nu4B728LmSuO+Cc6ulnDBxHMt8yKH7LoAPP0=','2025-10-03 20:48:58.9386172','2025-10-03 20:50:58.9385699',NULL,N'::1',N''),
	 (N'275C0D07-E2C3-406A-B4F0-7C3D58C83261',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'XezQNzx2kV3RjFDX7JRPu4IyDoXFLLkxbfYOIB1ZjsM=','2025-09-30 19:27:23.5564358','2025-09-30 19:29:23.5561666',NULL,N'::1',N''),
	 (N'A5258ECE-282B-4228-A472-7C60730A8EE9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'tt7MwgLM5x8aaeOUGFwl9ZGQOo8hxuk4dR+tf7Dm5FY=','2025-10-07 17:07:12.6580430','2025-10-07 17:09:12.6574079',NULL,N'::1',N''),
	 (N'5916809D-84D6-4685-BCDA-7CA32E320BE7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'L7MJZZZhrY+w7vx9WvhDZYv7XbdDWL/iIVupBcmahQ0=','2025-10-03 20:34:13.4526383','2025-10-03 20:36:13.4456577',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'1C05ABDF-1E0F-4DCD-AD28-7D0ACC680F2B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'CxU2+dppHcOTKww7/rH6FcWZRMR/V7+mhggh5Ibbd+8=','2025-10-03 21:22:22.2044182','2025-10-03 21:24:22.2037235',NULL,N'::1',N''),
	 (N'878AA632-82E2-4A4E-89E3-7D38D269779B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'+ovVQjMmuZ1FsLIxsCRLz0FZme8fdLQa/broDMufSzM=','2025-10-03 19:38:51.9058937','2025-10-03 19:40:51.9049482',NULL,N'::1',N''),
	 (N'AF4A3A8D-5C1E-481A-B9F8-7D6DEA22796C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6j1AgSbuVSPXLJXcg3JzPmicLZ+xQlSTOIC3WbOrqmk=','2025-09-17 19:27:46.4639025','2025-09-17 20:27:46.4513544',NULL,N'::1',N''),
	 (N'47EB78A8-3F4C-4483-B8AC-7D714A31361B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2EJxW9JEvfPmNf8eb68+RNu7KR+n195tKFoZZiTzNxc=','2025-09-30 19:54:36.5180761','2025-09-30 19:56:36.4942967',NULL,N'::1',N''),
	 (N'DBCAAC2C-5FC8-4633-8AD8-7E774BA39B33',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'XWq+pNP9M+fcJIPslxWNdbotRzqPQ4UtTX5QfvFbMeQ=','2025-09-18 17:43:36.6270914','2025-09-18 18:43:36.5940225',NULL,N'::1',N''),
	 (N'DBECE388-4FB8-479A-ADA8-7E84A3A4E310',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WNFmgk5nZGFv+3g8zVLOdoAaeW6nuijJ5Zt79QLowgM=','2025-09-05 22:44:16.1262756','2025-09-05 23:44:14.0942529',NULL,N'::1',N''),
	 (N'2251DB7E-3A2A-4FC0-AF31-7EA4CD3E8A78',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'yN/33ybHvZhoK/hvdQczebKzuHnAz8Ca4vYpfWeZdCI=','2025-09-05 21:56:16.9877054','2025-09-05 22:56:16.7939364',NULL,N'::1',N''),
	 (N'362AE728-0FEF-4BC6-91C2-7ECFAF361B8E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'gcKTrFe4LFFdNMw63OGG8QTG/KjMXFmfJA0qPLlsUrI=','2025-09-16 21:22:22.5609548','2025-09-16 22:22:22.5509234',NULL,N'::1',N''),
	 (N'D5864E57-8932-433D-85A1-7EE4D067F074',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'68zH7+z30IiJMkPTtfrmu+XmclEICkKqTlwqDmHhP4w=','2025-10-01 20:44:50.4935145','2025-10-01 20:46:50.4933604',NULL,N'::1',N''),
	 (N'6D7349EF-51B9-4329-9C3D-7F2EDCE1377F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jaKpQ36gQQnHyd7VAYt0yMFr6cdFsp6Xj+9aG1HY83E=','2025-09-23 21:12:35.3928917','2025-09-23 22:12:35.3928219',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'BEA7F68F-C813-4CD7-9553-7F75371F7CF9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Z/4koN5s++fsALmE5hJ7OP3ggPA3XobKhgzDllrULZo=','2025-09-22 19:01:21.3863424','2025-09-22 20:01:21.3862704',NULL,N'::1',N''),
	 (N'BC3B6290-D858-4E99-8696-7FE0A66EB28F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N's+LneVJrXlYN2/shKaQRDCq6mOW50y3b4iynWm2qY20=','2025-10-01 21:19:14.4843712','2025-10-01 21:21:14.4843248',NULL,N'::1',N''),
	 (N'A321AA03-2C9D-47E3-BE5D-7FF8F3058D92',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hfMW8sNczrNDzfOdFGVK84FhyECoP5mtO6Hfv6GTJPU=','2025-10-03 20:34:13.4457011','2025-10-03 20:36:13.4456577',NULL,N'::1',N''),
	 (N'C1E3EAAF-D2AA-49BD-B960-801E94001B25',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'WWir/RX8RVluLqnPbm5/d03CvERMH7FEpJlUdZeegNY=','2025-10-03 19:42:46.2056122','2025-10-03 19:44:46.2050397',NULL,N'::1',N''),
	 (N'A427DE6A-FB1E-4340-A4E5-802993255351',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'mFrLv0J7ZRkMxw26EAv2mQ78b+2OLBhd45SzUPjPj/E=','2025-10-03 19:21:59.8740283','2025-10-03 19:23:59.8594771',NULL,N'::1',N''),
	 (N'AC979586-3581-46D7-B0F6-80E3DA303DF1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'16QH5jLCPLP6ZUEdBq4x5YmHrs0KmKRmLnONl/Tka0s=','2025-09-16 20:24:25.5072720','2025-09-16 21:24:25.4930377',NULL,N'::1',N''),
	 (N'D88CBE9C-8F1E-47D4-8F7A-816A21589B4A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6pXI7DzL1mjflKM/gfaU+07mRxSTjf0Tj7QtZZD8MBM=','2025-09-09 00:52:35.7317150','2025-09-09 01:52:35.7231130',NULL,N'::1',N''),
	 (N'1255FB8E-E332-4BD7-A6DA-817B86D1DEBC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'W45zrabEAK4oMExDhyPW1qcF3R9sARFRqgT93DklkkQ=','2025-09-16 22:30:59.4205489','2025-09-16 23:30:59.4092510',NULL,N'::1',N''),
	 (N'D5EF67FE-9B5F-4DB4-8B2A-81C979736CA2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'IKiN2QvurNQrmZEcAR51StLJ5/pjvLnhF17GZSocyOM=','2025-10-01 21:01:03.0033584','2025-10-01 21:03:03.0031970',NULL,N'::1',N''),
	 (N'06BEDB42-6375-4BE4-A302-82BBA2D1A659',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'TBMXS+REZK0M/pjMNz59FCpGS5uRRpD0+U640sSFaPc=','2025-10-03 21:01:26.0721065','2025-10-03 21:03:26.0720587',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'0F3AB54F-C01D-4140-823B-82FC44B7DE7F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'JtspojxYy+oXU4GUwcSXYF27UY/cklF5Sun7WQmfoes=','2025-10-07 18:51:01.1708690','2025-10-07 18:53:01.1474845',NULL,N'::1',N''),
	 (N'610AE0F0-ED5F-4D72-9BB4-8322F2B11CEF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/bxO+L89KsBdtKbMuDvwtuiP6353IyS9iQenvv+6Ry4=','2025-09-18 22:00:27.4789581','2025-09-18 23:00:27.4788901',NULL,N'::1',N''),
	 (N'A9C5310C-63ED-409F-AF3F-837E8013725C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rF0ccNt6MpNgNFHfim+72iI5g9K5xnQpo186VkDrYBk=','2025-09-10 18:51:20.0824752','2025-09-10 19:51:20.0510824',NULL,N'::1',N''),
	 (N'2836CA56-FE30-4137-804A-838BAD0962CD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2h5iQFUottLZdimCkndWMIInE9KpbwrYb00fXs29xRc=','2025-09-30 20:14:22.9376762','2025-09-30 20:16:22.9291914',NULL,N'::1',N''),
	 (N'1B4259B0-3A7D-4993-AC4A-839A1DC0BD89',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'E3ZHDHvG5u69DAnO2vBofLMbmN2StG4YDb5Mt5FYNjs=','2025-09-16 20:16:05.8435119','2025-09-16 21:16:05.8268528',NULL,N'::1',N''),
	 (N'59CC4CBD-7D5A-4CF3-BDE5-839F2F1000D7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8GhKk/NQxinT+df+oQcgXS2N1GfmISH/w+kFmXnBC0A=','2025-09-22 20:14:47.7118826','2025-09-22 21:14:47.7118195',NULL,N'::1',N''),
	 (N'9001C2E5-4E00-4E3F-A619-83E165D118D4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'dwONxUPvlq1X4XZWXOT6VZeQ3DCDrgQn0h8lPfdHfqs=','2025-09-18 21:58:40.6194254','2025-09-18 22:58:40.5708991',NULL,N'::1',N''),
	 (N'980686D4-069A-4E4C-A06F-8419FC464766',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'4iVAzOBVQHRpFYvjqQA09/cZLmrJ9xnjw/ja/ZhAcpg=','2025-10-03 19:38:52.9238515','2025-10-03 19:40:52.9218684',NULL,N'::1',N''),
	 (N'4E78963E-87C8-471F-8304-842319D59BCA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9DyITg/r5AkNc7+ISEJfk6FCENY+3chMRsMnId7/yW8=','2025-10-07 19:13:57.1413037','2025-10-07 19:15:57.1382736',NULL,N'::1',N''),
	 (N'E927506E-E1F2-44EA-96D4-8476700DD625',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+Rf0xNjR6DD6MW6VuR1XznBfLr0gtOd7TlPEcAUCvS4=','2025-10-08 18:03:40.9433986','2025-10-08 19:03:40.9417261',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'9917C629-3483-4561-B4D7-84A99B9F5C2F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bxbNOPtHwhTJO3NY/mdY3lllVcFSyUgF6J4tQ0JKb5U=','2025-09-18 22:26:06.2611890','2025-09-18 23:26:06.2506661',NULL,N'::1',N''),
	 (N'07B3E586-0380-4E6F-BFB9-84D4CB804036',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'YC0mnz49zAJ2ON2wGuKb3HmZJqMsf2PvqtphLzg87zU=','2025-10-08 20:35:08.0438170','2025-10-08 21:35:08.0436428',NULL,N'::1',N''),
	 (N'1F22A955-75BF-4F12-B417-84DF8D3F7CC6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hHZAESIQqJjqSjmnViXz51x9UHo7CqA7ygTOHqpJvBs=','2025-09-23 19:28:39.1289189','2025-09-23 20:28:39.0967029',NULL,N'::1',N''),
	 (N'2EA1E754-366B-40AF-955C-8550C9E2F60B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'C8nVhHVJzGRq6cXL9OVOnI0fhaf2Oi5Cki/VJ0Yp+P8=','2025-09-30 23:27:24.7815373','2025-09-30 23:29:24.7700142',NULL,N'::1',N''),
	 (N'4825AD51-51EB-4958-A9B2-856B58A433FB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'mtn1QjeoFbNJ4tUg513s10ss7AWYKkBS+vnEQKaRHXI=','2025-09-17 02:04:23.0431264','2025-09-17 03:04:23.0353979',NULL,N'::1',N''),
	 (N'A8B63069-58A0-4A21-A487-859BE94750D8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'YFFqQtX4x3NfVhPX2LsuxBkCAJRT2qNGvJ9niaVStvk=','2025-10-01 21:38:09.8309489','2025-10-01 21:40:09.8308233',NULL,N'::1',N''),
	 (N'0E3183D6-C495-47E0-9345-85C13BE65151',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'xRCGzeEdILRudkPmpr4JeRP1J3kIOHm6b6d0nOlhbgU=','2025-09-22 18:55:47.1843582','2025-09-22 19:55:47.1841834',NULL,N'::1',N''),
	 (N'2D8E7F5D-D2F0-42F8-8741-85CC12D7FE00',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'lVIijXsNKYZePaE9dCjYMP4ejR5XjFjUx365QSyOqvo=','2025-10-07 17:37:21.4361708','2025-10-07 18:37:21.4358904',NULL,N'::1',N''),
	 (N'489A4DF2-E4B4-4AAB-B753-85DE3758A603',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ozWGHUFcnF6cEHnj9AtfQz5Md6may+Xuqaw416JdaAg=','2025-09-18 22:01:40.2158698','2025-09-18 23:01:40.2157759',NULL,N'::1',N''),
	 (N'23F0A79D-65E6-4B83-BE48-8608FE36DD21',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'gj/vN+ilxZLHN36Czh7S9IJ50CPikSfV9qrMzX57KkQ=','2025-09-25 23:21:59.0328015','2025-09-26 00:21:59.0181330',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'E085B20F-8F5E-4F49-80BF-86A6CB39A7B8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZkfAZvX1/5RWtnWHpKPu/8aOwUiNRSSv9b6U4TAQYYE=','2025-09-30 20:08:05.4513644','2025-09-30 20:10:05.4366119',NULL,N'::1',N''),
	 (N'1259578C-20B7-44F8-AC1E-86EB5B9A6272',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'4LPB+OngWeeI5lD02xdDoCKcgLh63UIIzzFGhLWAPY4=','2025-09-16 18:32:02.4432624','2025-09-16 19:32:02.4430069',NULL,N'::1',N''),
	 (N'849A58BF-F356-4F6D-8963-8827C27C9BB5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zpe/kU+Wf14iu/DDdN38RM4vpnGhjoejdUTpSCfhF4A=','2025-10-03 21:09:19.5104850','2025-10-03 21:11:19.5104261',NULL,N'::1',N''),
	 (N'DE08A205-7B84-41F3-B211-887B7C610D20',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ulb8UHBT5ND66wlZsu3CWZ/mG5Dnp38dA0aYn59XZ0w=','2025-09-09 00:53:36.0604925','2025-09-09 01:53:36.0604308',NULL,N'::1',N''),
	 (N'4A120419-93EF-4A2D-A389-888D94E919DF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'G/82u7dVBUzWu2oUZcBLwnDpKgn/IT4VCeUTHsKdP6U=','2025-09-30 00:22:12.8446995','2025-09-30 01:22:12.8435413',NULL,N'::1',N''),
	 (N'F522BD50-6A1F-4D6C-A890-88D988181141',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'E+xwAz6rZt1MIgwTMhTj65knKKMCJQVN07+XdIwkRYo=','2025-09-18 23:30:42.3162556','2025-09-19 00:30:42.3058594',NULL,N'::1',N''),
	 (N'8FA7BB4C-298A-433F-B975-88E7C58F3A63',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Md3TLhtXw+0Jbg9DV1fb1WuAUsknQyotrCa5jV1C8ic=','2025-09-05 23:26:54.0135707','2025-09-06 00:26:54.0134924',NULL,N'::1',N''),
	 (N'4F1CA5B9-8BB5-4FC3-AE03-89005A15E577',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'hbJQStiz5UUoKcgCYBOXLsvWHrtWqQ5nCetYnLB2yVg=','2025-09-09 00:52:35.4407547','2025-09-09 01:52:35.3953464',NULL,N'::1',N''),
	 (N'EBAFDC84-D6F4-4301-A001-892EB9886A02',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'593lleUy1N9xoaZ+7QBQY2JY6iQ0x9F68IKdBKvRdng=','2025-09-24 21:48:17.2650333','2025-09-24 22:48:17.2500091',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'7E1FEAAF-9263-41BA-8863-893F25F926B2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'itZeRjHjJ7/bMZKiX1tH/qYsl0G8H7sXnRMhRIcFOWk=','2025-10-01 21:30:41.8274807','2025-10-01 21:32:41.8273109',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'DAE03AB4-1BFD-46C3-8AD4-8947FE835984',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'y9YPpAQy+5xzXKKAl817S3mTuOn7CB9xDi+9wfXs+RA=','2025-09-30 20:04:42.0850613','2025-09-30 20:06:42.0844291',NULL,N'::1',N''),
	 (N'7BD5C24E-0A72-4EF4-9A53-894C9CCF9ABA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'TBZ7QiVDMLlsofJ2aHB0/dpb8ZRBlB2hwAwRes7bCK4=','2025-10-01 21:30:33.4575829','2025-10-01 21:32:33.4459870',NULL,N'::1',N''),
	 (N'0449113C-112D-468D-B80B-89965BA6458C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'zZK8t1dgxkms7ttrHfiJ5S76wDoh/yFAQgVOffuU3ww=','2025-09-22 23:13:31.7479937','2025-09-23 00:13:31.7318397',NULL,N'::1',N''),
	 (N'DAC04FE6-1D70-4DC1-874C-899F675998D0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GVF7l3dfGxyCK3ivFsW1v1Rv5VdsYqDAqEOeVk+Mxns=','2025-10-03 21:11:28.1580771','2025-10-03 21:13:28.1508436',NULL,N'::1',N''),
	 (N'057B5FC9-B51F-4410-A277-89D269FDDD95',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ymzklw75jiq3TBwdUilEVmVtKthCp0kseG81PM50b7U=','2025-10-01 21:30:30.2244775','2025-10-01 21:32:30.2243394',NULL,N'::1',N''),
	 (N'C8C457CE-7152-403E-A892-8A3B1741BCD1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ULjyAf3Bx2DPf0vAtMJ3XhlQf3XxWPnB5dP0bHHEXK8=','2025-09-30 19:33:52.9970590','2025-09-30 19:35:52.9847636',NULL,N'::1',N''),
	 (N'B05449E9-7E13-48B3-953A-8A66B04B94D4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GX/WDoXfLkfc9F2EibvqTcgaKBwb9WzohlEvijxN0HE=','2025-09-18 23:19:31.8482718','2025-09-19 00:19:31.8391338',NULL,N'::1',N''),
	 (N'B1746117-BA2F-4525-93E3-8AC10C3247E4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'BVjRAKBhUsnKeRFVPQ2m5G5/1xcoAXDawj3kuRYBvas=','2025-09-16 20:44:50.9517305','2025-09-16 21:44:50.9369766',NULL,N'::1',N''),
	 (N'A55D220D-317E-4DFB-B2FA-8AFA3D746A40',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'5b0ADe0rkLRXzSM9ruZqQ9p3cQqO7MY9iG4LmXXZIi8=','2025-10-06 19:54:01.9749144','2025-10-06 19:56:01.9745688',NULL,N'::1',N''),
	 (N'55BAE57F-D42A-4E79-98E1-8B4F720627DF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zKSF8KBrJ7MVyVKatislBt0mY5l04arILDVeBW2YQ9k=','2025-09-23 22:04:25.4198197','2025-09-23 23:04:25.4184519',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'2AADB560-17D9-47FA-8562-8BB1689F88B7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'EPm0LX292CpATPdP/5N5nAlLpZ3/ZE/S/gsR03ZeSks=','2025-09-17 19:27:46.0819689','2025-09-17 20:27:46.0646606',NULL,N'::1',N''),
	 (N'3D3D1850-6F21-4985-92A0-8BF0BE7C8686',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'VgIK2F9u4mY3iglGyX9ZQCBwP1PrP0BalaUkAoudSJU=','2025-10-07 23:41:33.6837139','2025-10-08 00:41:33.6607727',NULL,N'::1',N''),
	 (N'EDAFE435-714D-4AC9-A1D7-8CFB2A0A3DC7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'k5n/RG3QfjvjYYGNUNAPOU0P8R6N7dFVcMY2+0jvi8c=','2025-10-07 18:58:33.5380223','2025-10-07 19:00:33.5345525',NULL,N'::1',N''),
	 (N'3C25A737-8C9C-4B4D-8AA7-8D17AECA4EDC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'YdsL+N3P2p5iJMph/M+9ogYga2HnbD4uWbFPJLBOcTY=','2025-10-01 22:32:38.9850402','2025-10-01 22:34:38.9625891',NULL,N'::1',N''),
	 (N'2B626C90-B8B5-4DDD-AD2E-8D46149C2BEF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'YwLgae7aEHevLFl08pJ1CsfYL1Q++AbalksG/NMe0ZA=','2025-09-25 00:02:02.4178444','2025-09-25 01:02:02.4081128',NULL,N'::1',N''),
	 (N'7370BCFC-3CD7-443B-BB10-8D6DF21EF17B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'FyToVUS+PjjyREuFff+zCfH5nEuxMEmSFpuGfxzllj8=','2025-09-22 18:39:54.7476099','2025-09-22 19:39:54.5856158',NULL,N'::1',N''),
	 (N'62B7B7F0-0E3C-4989-A1EF-8DCCF9EB14BA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'gSvgOFr+a7Q2HYmdS/04KjFaREXbv6rzuy/JNDNxxHY=','2025-09-16 21:22:22.1834394','2025-09-16 22:22:22.1689699',NULL,N'::1',N''),
	 (N'84D5B92F-EF12-47B1-B199-8EB9068E1C6B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GSE1IXWaoaWSk/Kyfav0V9N5ulEuvddUYCH3YC+XLbI=','2025-10-01 22:32:38.9626338','2025-10-01 22:34:38.9625891',NULL,N'::1',N''),
	 (N'7A7A16B8-FBBA-499E-A58B-8F9195847215',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'zd1ceunPb5+4vbHmV0sQoJdcsYJ6d4GCosYVzAbokvM=','2025-09-09 17:52:55.2490499','2025-09-09 18:52:55.2487527',NULL,N'::1',N''),
	 (N'EE8BCEB5-912D-44A1-8273-9026FD78DD16',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'/rkmwtu4Nl0SGqKHiYvrPHwAfWr6o6vnUowsOIWIKVE=','2025-10-01 22:39:39.7873735','2025-10-01 22:41:39.7872285',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'85F9F277-EDBF-4A74-9F17-90381C1EB132',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'rmOXSro8lS8RHGDw741bbDVA01OMrt1RSyFECHMpghA=','2025-10-01 20:23:41.9233404','2025-10-01 20:25:41.9231589',NULL,N'::1',N''),
	 (N'8484B8FC-68AE-43A9-AF61-906B5DDE08CB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'vkWvkZh9aoSUiUW2w4mdS5sDQ7FxPztQaxPmPKU/S9c=','2025-09-09 16:40:46.5924156','2025-09-09 17:40:46.3916194',NULL,N'::1',N''),
	 (N'89FCA444-FF89-4BCF-B482-9087F776F726',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'k6VQf5YJhEUj5EjBrQh98xDNPaRbt+BOxQLEsOhwHJ4=','2025-09-24 23:31:13.8392528','2025-09-25 00:31:13.8320615',NULL,N'::1',N''),
	 (N'2EFFD6F1-9EA0-443E-9B5B-913F01DE595C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'2llxm6EyMRKEces7zMZO1rc3Zi+2daLLhyXK1DQaC88=','2025-09-08 22:14:29.1037456','2025-09-08 23:14:29.0540019',NULL,N'::1',N''),
	 (N'743A27BB-5EB3-4C2A-8B75-9152ED40574D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'VRAlTGBXBVyNkRg48nJLVMXaI6Wf/EN4hOEgCTgi9C4=','2025-09-18 21:59:57.0613901','2025-09-18 22:59:57.0546343',NULL,N'::1',N''),
	 (N'B2B0D915-1D6A-4BEC-8D93-91A53188DA2F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N't7k9bukcriu4hrGUvFA3n+lI7y0X2ReL20SxyfeL9g8=','2025-09-30 19:33:50.0725807','2025-09-30 19:35:50.0270793',NULL,N'::1',N''),
	 (N'A58A6FA8-3ADD-47F5-B6AF-91D0486DFC2B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'WajFgp+4xVusHlUbUQOFNS6JdR/oNyG93IAxWrE92Sc=','2025-09-16 20:11:12.0534428','2025-09-16 21:11:12.0411196',NULL,N'::1',N''),
	 (N'F64649CF-0587-451D-B988-91D8B4C45C07',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'v31P3gkt2LrAV9sT9dIGWWJvN5P6bwPx1dcovXAhvss=','2025-09-10 18:56:46.1639138','2025-09-10 19:56:46.1335632',NULL,N'::1',N''),
	 (N'4C6F0266-F554-405E-9377-91F493866D6D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WBrwHFEwXwh2pvAR5Z+qwnyU8y/fwmgdkHzOqp3jf8g=','2025-10-01 21:30:51.9655026','2025-10-01 21:32:51.9169786',NULL,N'::1',N''),
	 (N'F19F9C0A-EDD0-45E0-831B-91FF5EE196C8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'44N9pF7nfELsXQyb/+MQk0v71AVzpEThOuHMgNA1SWk=','2025-10-03 19:47:05.9908640','2025-10-03 19:49:05.9697168',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'19DE506F-8E94-4318-8506-92207AC52949',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N's3FKQpeVpos7RhUxVNRKX07LJUVdsv3nLuYFkKcgNCU=','2025-10-01 21:57:35.8949397','2025-10-01 21:59:35.8882846',NULL,N'::1',N''),
	 (N'DC1C82A5-6B6C-4113-B21C-92426D98453A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'MYaYeiN4GWbuR4dXuwsDleMPUiOBGlTgMjdQU41C4sg=','2025-10-01 22:46:30.8672127','2025-10-01 22:48:30.8671630',NULL,N'::1',N''),
	 (N'8FAB14F5-2A2F-4E1B-ADAC-9266B13DEE4F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IDDWrkDpU7cNHB3Aj9jvyazc88MMQhFNoKegP7aEbVU=','2025-10-06 19:51:32.4402054','2025-10-06 19:53:32.4399935',NULL,N'::1',N''),
	 (N'BC44B5E1-29FD-49F3-A041-926B4E33F97A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Dm5iJiF80G0ewv+ZzQfjHNCbdES8mkCgT7cFtBSrbjc=','2025-09-10 18:53:08.0858951','2025-09-10 19:53:08.0858288',NULL,N'::1',N''),
	 (N'5AC0E60E-767D-4C32-8200-92C99BBE843E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'H47i9yzLCG8I+g5SVOMS8jEHwSer1pCB00t/SE4OsDE=','2025-09-05 23:18:28.0675921','2025-09-06 00:18:26.9849265',NULL,N'::1',N''),
	 (N'376D1E69-3B03-4051-8438-936C5F52CE0F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'N61KwJ0WSYiII+Prdhi5WjIXfocTXF5gyrLRUJbWzxM=','2025-09-30 21:43:47.5799251','2025-09-30 22:03:47.5715266',NULL,N'::1',N''),
	 (N'1C9C23B3-3A62-4D8E-9AB4-938C01B0B553',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'qh8cZG6W0PX8V215byDXBXnmv6PUskKN9/hWJ3uIFvI=','2025-09-09 01:35:04.1626512','2025-09-09 02:35:04.1175737',NULL,N'::1',N''),
	 (N'94F1FE69-07FC-43B3-958D-93BC7BEED062',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Xn8slMRShr4RkqhRhRvMIvY5btWLhqExDBXc3kxUGhI=','2025-09-16 19:42:53.6218236','2025-09-16 20:42:53.5882559',NULL,N'::1',N''),
	 (N'6EB1608A-A165-4141-8642-93E067AB096C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'nQ6r7p/p6hwiDbFQ2gpvk3mwWIMd81ClbVgKQlcuIW4=','2025-09-18 23:45:47.4768209','2025-09-19 00:45:47.4602835',NULL,N'::1',N''),
	 (N'A3DA79FC-CA2E-42D1-9BBF-94198986C4BD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ktqhr5UNgEZBeHvominT2SDVAnpyRppWmIahOH9aILE=','2025-09-30 23:16:45.2797941','2025-09-30 23:18:45.2760181',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'4A3C2795-8E01-4237-8B5A-9539652C7DA4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZLbMfXFwcEH3bWXYWIU2yLE5ziOJ9ZLouCYpPu0mNUU=','2025-10-03 21:16:27.5532271','2025-10-03 21:18:27.5530761',NULL,N'::1',N''),
	 (N'83EFCD0C-29C4-4EE2-9A4D-95DC1C9FCB48',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'H2jOS96SlsvLxzJFwT2ZZBFgXWvL+oLWCS6CJjBVboc=','2025-10-03 20:08:42.5603992','2025-10-03 20:10:42.5528059',NULL,N'::1',N''),
	 (N'938D478E-DE0F-4031-B717-96490451B74D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N's3GeWFV1J48g+rW2EldMYiA/55DkW7TFY0SqUjVWMMw=','2025-09-30 22:31:46.5772901','2025-09-30 22:51:46.5770034',NULL,N'::1',N''),
	 (N'0BCECF11-B81E-4202-81D7-96F6F29B8B1F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6yHwFkhJ67E3OG+P3rOW6/DiAvHFBRcap8PK+i5Ym8Y=','2025-09-24 21:51:51.7812175','2025-09-24 22:51:51.7811411',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'CEB4D2FF-3BEC-4B67-A0DA-9716475301AE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6VxKKnmJYla3JAhcXuAPEHh3qdKo/SZFLpDlkI4SZRE=','2025-10-03 21:20:15.4045683','2025-10-03 21:22:15.3773072',NULL,N'::1',N''),
	 (N'3ECFB516-DB64-408F-812C-971B88A6F1BE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'4rObOX+6f0pF6FuemUEs+4LGxgGmDbYdHBM2NnUJlOg=','2025-10-03 20:27:58.7029222','2025-10-03 20:29:58.7028800',NULL,N'::1',N''),
	 (N'EEC1BD14-30AF-42A8-9917-972AE7D4D478',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lDvRM/eTtTMesuxOFOKv+tnQg+23LaTEWAvaugoC2/4=','2025-09-17 01:38:07.2237786','2025-09-17 02:38:07.2236998',NULL,N'::1',N''),
	 (N'AB98F168-A1CD-472D-A83D-977200471C7C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lA1GreQhn6IV/TPnl6udOANjgWTlPFbyDLZV8USL1CA=','2025-10-01 21:35:19.7976485','2025-10-01 21:37:19.7976073',NULL,N'::1',N''),
	 (N'0D0342B0-C192-4DF6-8906-980CE589EDBA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vPinzBVBUVQyNAcMYPcWM02poZMKmAhVNCTOxXZ5rQI=','2025-10-06 19:50:02.0641035','2025-10-06 19:52:02.0640451',NULL,N'::1',N''),
	 (N'D9645E6C-5B98-4E5E-947D-9815DE8DE29E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'12GQ4dL64dnnWLraCbZVljeOS9MLV7eDTfXelEPKXic=','2025-09-24 21:55:51.3894325','2025-09-24 22:55:51.3764526',NULL,N'::1',N'PostmanRuntime/7.44.1');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'18A82B06-24A1-48D5-9CF3-984C0AB6FC2D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Okb5PEqGgUZFt5GF0hiQYTGojy/BYZFDutGLaiCSY/k=','2025-09-24 23:31:13.8130323','2025-09-25 00:31:13.8128038',NULL,N'::1',N''),
	 (N'237B3812-569D-4502-8BBD-9862224866D1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'TBMXS+REZK0M/pjMNz59FCpGS5uRRpD0+U640sSFaPc=','2025-10-03 21:01:26.0511577','2025-10-03 21:03:26.0510566',NULL,N'::1',N''),
	 (N'146F9FE8-0DB9-404D-8FAD-98B84F91F262',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'zpe/kU+Wf14iu/DDdN38RM4vpnGhjoejdUTpSCfhF4A=','2025-10-03 21:09:19.4227960','2025-10-03 21:11:19.4225248',NULL,N'::1',N''),
	 (N'05AAF676-F893-45BC-BE62-99046B8F8C09',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WbA+KXM55lvwZAEe2i5JPw5UkGOJ9mh41WpgUMWrEDc=','2025-10-03 21:16:27.5825261','2025-10-03 21:18:27.5530761',NULL,N'::1',N''),
	 (N'720AD7F9-0AAE-4E7E-BEF5-9904936A02E9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'YWBJm1vFSic3KeBomlz3MjFctK5F4q+EW8khKABq4+A=','2025-09-10 18:18:45.8891980','2025-09-10 19:18:45.8348326',NULL,N'::1',N''),
	 (N'5A0238A6-DD91-42AC-BC93-994EE558615E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'DsVwE2RfsDruze3+63+G+IQtyI6vF9TA1xYfGuM0jcs=','2025-10-03 20:13:27.0994046','2025-10-03 20:15:27.0992497',NULL,N'::1',N''),
	 (N'3E170782-C249-4359-A6CF-9986CDC5E967',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'CttRsPq+Vw42rrDbLOe7WCUZZM9TsaZSThdefrUf4WQ=','2025-09-30 20:45:30.9111362','2025-09-30 20:47:30.8997076',NULL,N'::1',N''),
	 (N'8CD795C0-80F1-4B56-96DB-999AD66DC940',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IKiN2QvurNQrmZEcAR51StLJ5/pjvLnhF17GZSocyOM=','2025-10-01 21:01:05.6845631','2025-10-01 21:03:05.6845126',NULL,N'::1',N''),
	 (N'A0BC701F-0251-4A4F-B7DF-99A434178A2F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'76c7xbcGL4+rmCwvl6/3ZT+UgXERQ0IQqluRCaLHHq4=','2025-10-01 20:22:24.4081117','2025-10-01 20:24:24.3406936',NULL,N'::1',N''),
	 (N'ED3F6D79-F549-4A54-876C-99A5191F2AD6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'16QH5jLCPLP6ZUEdBq4x5YmHrs0KmKRmLnONl/Tka0s=','2025-09-16 20:24:25.9253449','2025-09-16 21:24:25.9209501',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'7B6442C8-6FA4-45C9-965D-99D916DED894',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'j6V8kcmO1OSsY9HYPaIs+Jn1Ul/rVgKlWPyM9sCzKB4=','2025-09-18 23:45:47.8094666','2025-09-19 00:45:47.7963858',NULL,N'::1',N''),
	 (N'DE730378-AE90-4235-B271-99E79DE0E0F6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WGZocXETrOvaeOMax+xXAif/v2IhrS2ycQsUlKodWDk=','2025-09-23 19:44:46.2734273','2025-09-23 20:44:46.2704725',NULL,N'::1',N''),
	 (N'9FDE131E-0A2C-4DFB-B8D8-9A6B7773F100',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'OsTOnSU87mCtufBLOP1+6w7asDLO9xsLva6gNv9zqeQ=','2025-09-30 20:24:33.5720758','2025-09-30 20:26:33.5717406',NULL,N'::1',N''),
	 (N'1483ABC0-8283-4B9F-8DA4-9A7F82B1C13E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'rGLGPuSrN2s+556Dqju1oDGrgfZEqTx/2z11AQfhqbA=','2025-09-12 19:27:47.4293810','2025-09-12 20:27:47.0107884',NULL,N'::1',N''),
	 (N'25B2BEAD-6E9F-4AD5-9C3A-9AA6F1EE8F2D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'BHYnMnRpfwL5YC/rtSJ9keaWYkL9AuV0UqFzE1zHgpY=','2025-09-17 20:11:44.3126527','2025-09-17 21:11:44.2983247',NULL,N'::1',N''),
	 (N'9BBB8FB9-E4F4-4B15-B146-9AE9FB5CA464',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Ep+51UNgU098WrHsL969vCsiNCZ6cZn78i/iW+XNLJw=','2025-10-03 20:08:42.5528500','2025-10-03 20:10:42.5528059',NULL,N'::1',N''),
	 (N'0A35233F-DD57-4CE3-99DD-9B15AE7DABEC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kBtFDtmUChOD1suBeAz/nBGd+pmiO1DOqA9efgW4Pog=','2025-10-01 21:53:07.2870432','2025-10-01 21:55:07.2579160',NULL,N'::1',N''),
	 (N'F69C8D38-C527-42B6-91D8-9B5053468DE7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'aTqbOYjHoLiYjsdU4k68Rdovwsq6QefV8g+7HY8PrFI=','2025-09-17 01:27:50.6881014','2025-09-17 02:27:50.6786707',NULL,N'::1',N''),
	 (N'60E05926-74DB-4C76-B30D-9B561E517E35',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'AKyC7+UjjTiIkqbDFB/miyiTvoseKQk4Ep6DplEZLC8=','2025-09-24 23:48:00.3165709','2025-09-25 00:48:00.3163376',NULL,N'::1',N''),
	 (N'1878DE17-76BA-4AFC-B4FF-9B6400F5FF60',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'eGFtSxgGvDbiBGwrkCT5SamjHnTPTb7IFgMdmFz32dI=','2025-10-07 18:46:52.7571410','2025-10-07 18:48:52.7527945',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'999A4AC7-FCAC-47B1-988A-9B6515C3F92A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cT2FNHIhRwDly3frxGtnKQzwmZRJxEVnq/avmDgixkc=','2025-10-07 23:41:27.3353077','2025-10-08 00:41:27.3338421',NULL,N'::1',N''),
	 (N'53FFE88F-4102-41F7-87BF-9B8FA4BD205C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KIAw0jWPFSUuwXdwMiA1g5zFT/7BmEGFsjyAGxuoptY=','2025-09-24 22:05:23.5972489','2025-09-24 23:05:23.5961322',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'740E01C5-3207-449F-9ED6-9BA7721A187D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'JpR0pLqkFuGG5cw97Y3sVn+rpMsJN8CrLwcDr1sjzAc=','2025-09-23 23:06:39.7001680','2025-09-24 00:06:39.6980608',NULL,N'::1',N''),
	 (N'9CCF2FD0-E492-4D13-8C25-9BB54217D352',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'EHR3A3pM5IaSWBEKW+rUwQCSJBVPsAaBwGdcP31q5og=','2025-09-05 22:48:43.8538458','2025-09-05 23:48:43.8531716',NULL,N'::1',N''),
	 (N'BF1E7301-25CF-4446-90E1-9C2205A22640',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'JSe3zgf5j1fA4e4Cm5Z+mWSa1ZDhY3hbFglMEK7+9e0=','2025-10-03 20:43:45.1022266','2025-10-03 20:45:45.1020441',NULL,N'::1',N''),
	 (N'A7B2DA2A-B239-4E0B-8EA8-9C642C4F7389',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Y8EzQIrKEl7bWeME7p79I4GwiQ1FQ07oE8AiJpeDdmc=','2025-09-17 17:05:59.9301956','2025-09-17 18:05:59.9299179',NULL,N'::1',N''),
	 (N'7685E812-B241-4AE9-9FB1-9C83B607C20C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8O2WSJALtCdTKxh1We1wEhsBEExLtSbTUdYiKOs2egk=','2025-09-23 21:06:37.5950349','2025-09-23 22:06:37.5939465',NULL,N'::1',N''),
	 (N'B2A4183C-4153-4D55-B2F6-9CBA90793388',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ccnqMT8/yhk92EhDEak7HSNyY1C7i6wb7C469bbCvqc=','2025-10-03 19:45:51.5416930','2025-10-03 19:47:51.4980316',NULL,N'::1',N''),
	 (N'D9D43F27-24C5-45DF-AD3E-9CDDE68EB2C7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'4Th0spmXwUTreCFtPvRNOxIrcJoRvuZ+cOjd641mLQY=','2025-10-07 17:08:55.3001349','2025-10-07 17:10:55.3000574',NULL,N'::1',N''),
	 (N'0B644CAB-7777-46FF-8A89-9CF67C7EEA6D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'WnYllteKiIRdVqU6mB7vpI/pLzGg+by9TozxpHSTw+M=','2025-10-07 18:58:33.5183521','2025-10-07 19:00:33.5181206',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'4AE2F8C5-B64D-48D1-AD9F-9D058B78B751',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+Zeaeb+lzQfvIOntWVGa6M/ulE1HixCFnFFUfgS2ehE=','2025-09-22 22:46:17.1039385','2025-09-22 23:46:17.0969570',NULL,N'::1',N''),
	 (N'8867BE13-D12E-4E71-9B43-9D2D8A5E992C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'gXQ/0Nyob+G6hZgVrELKOaqNIw+LXdVIVE01/5OR20g=','2025-10-07 19:12:44.5860845','2025-10-07 19:14:44.5828407',NULL,N'::1',N''),
	 (N'67046F4E-219E-4DA1-BBA5-9D56B55E48AC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'2oyKlp+T77zxMMSbJgrQGC55MaO5DzjqUHCvB3jCfv8=','2025-10-07 18:55:07.5001728','2025-10-07 18:57:07.4999066',NULL,N'::1',N''),
	 (N'2B7CBA6C-287C-4AB3-BBB5-9D6CF09F8E7D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'BIpCZkcgd87VTsV39SKW5sEtxnN44xP4IsUKvCuZFcA=','2025-09-17 17:01:35.7447985','2025-09-17 18:01:35.7435964',NULL,N'::1',N''),
	 (N'5F49C955-8E40-4846-B12D-9D8829600D5F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'chCf/4Rt3z/W9Hjo9Wqvt+rVGYvunwCvQPdroY71JvI=','2025-10-01 21:27:51.3377484','2025-10-01 21:29:51.3376905',NULL,N'::1',N''),
	 (N'8EC8D437-C05D-48B6-8BEC-9D95EDB39089',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'/H+I8ubfs6Ksx7r2ylIaQbTf0JgBKfgs5lvO2VdcrVE=','2025-09-18 23:05:51.7395788','2025-09-19 00:05:51.7238978',NULL,N'::1',N''),
	 (N'9F4B334E-2827-460E-9E9C-9DB3B0B66C73',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'EIqNpJ1RTVz4BsaJ1kR6Mc/wKhY2C/yYcrVIzG8TxWA=','2025-09-22 19:01:21.3935235','2025-09-22 20:01:21.3862704',NULL,N'::1',N''),
	 (N'7D4330E1-118E-4FD3-BD6F-9DE9A6A92CB5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GP9b4G/KO8qrEPRyBI8I2RGBbKOJhSHMeuaa2w1qP14=','2025-09-05 22:44:14.8822226','2025-09-05 23:44:14.0942529',NULL,N'::1',N''),
	 (N'AFD2DB43-7B2D-49F2-828C-9DEBE6030303',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'icZPQc3oDtJHull66qka3M05KOju7BkPMZWQE/oBMe8=','2025-09-19 00:33:11.4838651','2025-09-19 01:33:11.4675485',NULL,N'::1',N''),
	 (N'4636B4AC-3D5C-4542-90BD-9E1E18ED3F02',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Lx4AvpHDVxhAI0WD8ANkRBaTJLMZ1mUs3FVn8ZUQCQs=','2025-10-01 21:57:44.6732018','2025-10-01 21:59:44.6730826',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'CFE3C8CB-D498-43F1-887D-9E769F28B4E8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'vPinzBVBUVQyNAcMYPcWM02poZMKmAhVNCTOxXZ5rQI=','2025-10-06 19:50:02.0471023','2025-10-06 19:52:02.0468045',NULL,N'::1',N''),
	 (N'C0A05063-850E-43A0-8709-9EDB07107318',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'74TbYFtcBMps8KHCgbxcyM+bFhftgPty2ZpeipgZ8gM=','2025-09-29 21:43:47.1750269','2025-09-29 22:43:47.1647915',NULL,N'::1',N''),
	 (N'BC5A187D-680D-443F-B026-9EFF474D2167',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'skpWvfpBHUiFPOT6yY39jdKVKZEoZRQsUOi85aRC+dA=','2025-09-09 17:33:23.3860213','2025-09-09 18:33:23.3840098',NULL,N'::1',N''),
	 (N'7E5BB107-E940-4320-8281-9F117241AEFC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'lA1GreQhn6IV/TPnl6udOANjgWTlPFbyDLZV8USL1CA=','2025-10-01 21:35:17.3771868','2025-10-01 21:37:17.3770811',NULL,N'::1',N''),
	 (N'87C0C1C5-F3FF-4630-AB70-9F667412AD8E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2KaY8P8H6ct5QhSlYLRMeJ6Mw3OBzn3sP6TgmwM70Ps=','2025-10-01 22:32:32.8300028','2025-10-01 22:34:32.8299097',NULL,N'::1',N''),
	 (N'1BB9861B-A4CB-4DE2-8C02-9F92FE3FC6D4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ewY9hSZ5MhGBeLWAf9RbeYibQ/06B96/wDXrUkYu3HU=','2025-10-01 21:28:39.8579825','2025-10-01 21:30:39.8579333',NULL,N'::1',N''),
	 (N'167908A1-7C6A-4954-84E3-A03BBC8BE317',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7D9x5iFuym0/Osn9QRcbLhXeiY1Zp1gydAXUcFzBEfk=','2025-09-17 16:27:29.0744546','2025-09-17 17:27:29.0743879',NULL,N'::1',N''),
	 (N'0EB364AD-C39A-48BE-8352-A083F4ADF82C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nCd1AfTa2Ilo5snmdNz4PXy8QNXrta2381egVTt2QH0=','2025-09-24 21:49:24.6180252','2025-09-24 22:49:24.6159456',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'6385DEC9-F5B7-4022-A549-A08B37896432',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'prUwOIME4Jml9HwV+aO9Ajf6Zte8Y0hqQFOXeBIa+Kw=','2025-10-03 19:39:10.0501804','2025-10-03 19:41:10.0380736',NULL,N'::1',N''),
	 (N'9B659E99-9939-42D8-9660-A094896BFDD1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZgZTuxAlTMkhV3POgPpEeGRZI/MkGK1J5xuym8QU+oY=','2025-09-17 17:47:18.2858917','2025-09-17 18:47:18.2742659',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'94D1AE82-465E-44C1-9AE4-A0FC8768139B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jMXvkbT09QWv1QJuGoiy4Hc93viWpzzNkOgw2YwPDYw=','2025-09-16 21:55:26.9139277','2025-09-16 22:55:26.9043353',NULL,N'::1',N''),
	 (N'7BB50975-C8E1-465B-A237-A135B72A7ECA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'dwthCaGhfVyPQgMHa+XPWr1u2VVhGhZMBnULTl2EPcQ=','2025-09-30 20:09:19.5051669','2025-09-30 20:11:19.5049561',NULL,N'::1',N''),
	 (N'1FC719E3-4276-459C-83A8-A13CA6224A76',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'M5WyrJGv5QQ7jOfg7jopk0kCDr7vfEFnXJm29frsZSU=','2025-09-10 19:43:44.3590724','2025-09-10 20:43:44.3590083',NULL,N'::1',N''),
	 (N'2BF2B228-0F8C-46E1-B839-A169ADCF2AF4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'UNFjsLwEiR73p6DVD2aLYUBMorQWyunYKLuevmU/Wo0=','2025-09-18 22:32:53.4014733','2025-09-18 23:32:53.4000605',NULL,N'::1',N''),
	 (N'B44C1FB1-28A3-40CE-9067-A1F0889FD8E6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'xyVM2nemeShsqiBu0r4YvI6djMA0xAA0uWR4tTGiB7A=','2025-09-09 16:44:47.2101116','2025-09-09 17:44:47.1383564',NULL,N'::1',N''),
	 (N'FAD87B50-2DFE-4F9C-BCC8-A206C5252D88',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/H+I8ubfs6Ksx7r2ylIaQbTf0JgBKfgs5lvO2VdcrVE=','2025-09-18 23:05:52.0760605','2025-09-19 00:05:52.0746727',NULL,N'::1',N''),
	 (N'46FEF186-D864-416C-9D60-A272EB2CE2AF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rZdz6xR33jyQqpGHDaCoIaqwSQx0KdDjUtNOTU2M4FU=','2025-09-29 22:15:47.6321842','2025-09-29 23:15:47.6321146',NULL,N'::1',N''),
	 (N'6EE4C78B-132E-48F1-861B-A2E1375FCE9E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'tJXOjHdwXISMbb7JOOiBRPb2A0WXSza8TEz3LXItHiA=','2025-10-01 22:31:17.2307316','2025-10-01 22:33:17.2306264',NULL,N'::1',N''),
	 (N'B0D37836-8A16-481B-BF3A-A2F4E5573AFA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WXiRulnh8keaQC+SkAVVdrEkKLijD5K3Ugr4LhlOUkc=','2025-10-07 23:41:34.1664838','2025-10-08 00:41:34.0738290',NULL,N'::1',N''),
	 (N'1F162636-D4FA-4AD6-B6AE-A3236DF31CEB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'AuwX2ug5RSWeL7iqiZwsDCtTcpuYSdLCL7aNlBq3MUM=','2025-10-01 21:50:15.7491489','2025-10-01 21:52:15.7491045',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'970BDA55-11E4-4ED5-B331-A33959601BAE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ulb8UHBT5ND66wlZsu3CWZ/mG5Dnp38dA0aYn59XZ0w=','2025-09-09 00:53:36.0369879','2025-09-09 01:53:36.0356529',NULL,N'::1',N''),
	 (N'9C2DE870-E8B0-4238-BA8E-A34D6174769F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nvJFa5Pe7OSf6I24S5e40Dwo9TpoxWfISs95rLfixwk=','2025-10-03 21:11:00.2820858','2025-10-03 21:13:00.2812011',NULL,N'::1',N''),
	 (N'6F6CB724-391E-4D98-BBF7-A3719C7B9299',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'0YSu/rXrsco9WHKKbOPIQYdM39wJ0e4QpvV5GPCmuqA=','2025-10-01 22:00:54.2287710','2025-10-01 22:02:54.2284943',NULL,N'::1',N''),
	 (N'632AB16B-EC24-404C-A93F-A38E7519544C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'xdOBvG8blRJ4jbANFrxpV2vClhpNgvcJYDo9aP1Te1I=','2025-10-03 20:29:28.3771223','2025-10-03 20:31:28.3708866',NULL,N'::1',N''),
	 (N'AEE2E865-02E0-44B2-9106-A3D98BC4972D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'4Th0spmXwUTreCFtPvRNOxIrcJoRvuZ+cOjd641mLQY=','2025-10-07 17:08:55.2866240','2025-10-07 17:10:55.2863432',NULL,N'::1',N''),
	 (N'9449F6DF-047B-4787-9DAF-A3E8448C9B88',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'FZnLdiu62VJjx1rRZQvXn8rxzvpTpRVCj2SXY9ggLsc=','2025-09-09 19:21:41.7949576','2025-09-09 20:21:41.7931916',NULL,N'::1',N''),
	 (N'E9BC0B70-240C-4F39-80C1-A416495BE640',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'98T3EDBu8vFSuc87zNQJX9YN/9IYqXBBJXWjLDvanI4=','2025-10-07 18:53:47.2052341','2025-10-07 18:55:47.2051867',NULL,N'::1',N''),
	 (N'A4A55477-8570-40C7-AAE7-A428755EB093',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fdUX46XKmk1JKvtJRmli3U5Ewzd5lrYzVgTt2TYrbo8=','2025-09-16 19:50:50.8480631','2025-09-16 20:50:50.8457756',NULL,N'::1',N''),
	 (N'181D31E2-B295-4BA2-8C15-A48A78A44AB0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'+/19PdwAOWk9DbKaDeHH/BVpYma8Sj8Th+KgZfJ/krM=','2025-09-30 20:14:19.3456724','2025-09-30 20:16:19.3451056',NULL,N'::1',N''),
	 (N'0E944CE5-D427-433B-A62B-A4A8465785B2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7fpIF2r5PHlLor1nUWuH/a59asIE1FI16Q7W8etZTcs=','2025-10-01 19:46:16.3241209','2025-10-01 19:48:16.3220035',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'FD07583F-6BE9-4C11-AE4C-A50373C13583',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'K0LD3I03zvSY0K1bVhKMuHRVvT+5Iw1QzLQQMFmj338=','2025-09-25 23:21:58.6912523','2025-09-26 00:21:58.6382806',NULL,N'::1',N''),
	 (N'0F18A06D-F47C-491E-8098-A57531EE9C96',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lYMQtEfAaAUfZnkWnDE5gfefVcwnUK1iTCHmPAGkrjw=','2025-09-23 23:10:54.7962126','2025-09-24 00:10:54.7937661',NULL,N'::1',N''),
	 (N'B317F080-1BF1-4B69-B1BA-A598C39D70E9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'IDDWrkDpU7cNHB3Aj9jvyazc88MMQhFNoKegP7aEbVU=','2025-10-06 19:51:32.3660407','2025-10-06 19:53:32.3657515',NULL,N'::1',N''),
	 (N'37FB5B8D-0E23-4C95-B7C5-A5A27DF9763B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'rLy6L/awZFS04O9isVq7dWAn3a7f+FomMdHatz7j2UA=','2025-09-17 17:55:05.6536074','2025-09-17 18:55:05.6387107',NULL,N'::1',N''),
	 (N'A01DB1F4-7A6D-4ED3-8781-A6031EEEE419',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Cf1HvsMinJECYA14B4NnMqj65Wu9LTynfjPusvoj8Jw=','2025-09-05 23:07:40.6653905','2025-09-06 00:07:40.6089804',NULL,N'::1',N''),
	 (N'BDAE59C6-CE84-44D5-B8E0-A6300A2A23A1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'J5G2fvoyTdGtsh0S84/cju5Es0lQCWo3fehhJaW8DiY=','2025-10-09 16:43:44.6869477','2025-10-09 17:43:44.6866195',NULL,N'::1',N''),
	 (N'35C6800D-A65D-42F3-A4E5-A656EC4E8F57',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KaHk1VZCSYx3VDapiAuSdjXZbez4vsNHmfU2McE1dfw=','2025-09-05 23:24:39.3766008','2025-09-06 00:24:39.3745821',NULL,N'::1',N''),
	 (N'B9B5C7E6-4AC0-44B6-A968-A67F122CCC42',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wIEDHNHQraURZtuZMY/1FKmmsehWJMdWUuji2pZ6hNk=','2025-10-03 21:18:52.8144851','2025-10-03 21:20:52.7705667',NULL,N'::1',N''),
	 (N'311FD9D1-91AD-42DB-861F-A6A6690AC6C9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'iyCWM3TmUlvuaugUARBXCO7/oZOB+u7/csxQIGhNCXc=','2025-10-03 21:20:15.1824388','2025-10-03 21:22:15.1817667',NULL,N'::1',N''),
	 (N'03F72EB0-B376-4B26-A89C-A78D802F9AA0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'OPaRtrkEwTvqyZygR0jFd6+uW9UhK1k37UC9mr/0uGk=','2025-09-05 23:14:42.3213597','2025-09-06 00:14:42.3211175',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'3BFCF6BC-0AA6-4429-8663-A7951933455D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'0YTig28nu4B728LmSuO+Cc6ulnDBxHMt8yKH7LoAPP0=','2025-10-03 20:48:58.9209992','2025-10-03 20:50:58.9208248',NULL,N'::1',N''),
	 (N'26FAD33B-986E-4DD1-845C-A7C631470851',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'IsW8fH3HulmGYyVWxh0elqTcQY/wUXWpgCbo7W14VQk=','2025-09-24 21:55:51.2721048','2025-09-24 22:55:51.2671110',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'7A82DD14-082F-440D-A06B-A7D02001D4CF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'eCFb9D2+4hDUcXTXI/+gOyWUduZBHNTBT6UsoatQLXc=','2025-10-07 18:57:19.8880624','2025-10-07 18:59:19.8847138',NULL,N'::1',N''),
	 (N'28F52F88-5D27-4152-9B42-A7D2AB179F06',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9tkqPhtIGGGxCY/wPSxsdysd6zndOZNXSrNEtgMz0SQ=','2025-10-07 18:51:01.4637818','2025-10-07 18:53:01.4574253',NULL,N'::1',N''),
	 (N'B4F6B50E-C123-42A1-8F0A-A84A5D6BCCB1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nQbZsJdBH4HVtc1hCDV8lGV2XmFg5yhNl/V+gLDiBBY=','2025-09-16 19:44:02.4900244','2025-09-16 20:44:02.4827367',NULL,N'::1',N''),
	 (N'06E5ADCA-64B4-470B-9836-A85C13397CCA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'CKSqbAsJiLnE6qJz/U8D/f5kv2rxASiVt3FEjSkmrmk=','2025-10-01 21:20:37.1770975','2025-10-01 21:22:37.1663117',NULL,N'::1',N''),
	 (N'52224D21-4DCD-4DF9-B75D-A8634CAA0BAD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'NCv+lvBhIp39PtEvZrEFIF6wOhvm1H0tUTAZccxbOqY=','2025-10-03 21:20:26.9121109','2025-10-03 21:22:26.9111763',NULL,N'::1',N''),
	 (N'C40F6EDE-2EA0-474D-A9D9-A9521C2F348D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nOoHHN5PPdtIkwrP0FrDnR/39W/YlgdcZ4gM5ho4qlA=','2025-09-17 16:12:43.2254985','2025-09-17 17:12:43.2139451',NULL,N'::1',N''),
	 (N'5134DF82-4671-486C-9B26-A95CEF29C780',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'V6rOzl+wywqKNJtm49K7Nj40+jtGiHzsdXVdqSajgDc=','2025-10-07 18:46:52.7399338','2025-10-07 18:48:52.7395086',NULL,N'::1',N''),
	 (N'17C22AA7-55F6-417B-9F13-A9772AB0B48D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Y1XWuxEA0XdT1tnhEJmRst+rwp6veiFX1+XFbpRTcNI=','2025-09-17 01:14:48.1546278','2025-09-17 02:14:48.1404610',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'1905EF47-AE76-461C-A1A5-A99B7651D86E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+ovVQjMmuZ1FsLIxsCRLz0FZme8fdLQa/broDMufSzM=','2025-10-03 19:38:52.0292916','2025-10-03 19:40:52.0291991',NULL,N'::1',N''),
	 (N'6B6B8DF8-B01A-4C88-B991-A9DEE43288E7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'm2uGyZMgWLLsOTbUH+VU63BsIAt4h0ShZEMgUA0VHsw=','2025-10-07 18:34:18.6260434','2025-10-07 18:36:18.6180461',NULL,N'::1',N''),
	 (N'CA6D38DF-5725-4862-91DE-A9DFEE0629BA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'MT039k/IH/M4/l0Q3iDP3MN1XDqieAHQ/Rh+/gTRI3U=','2025-10-06 19:44:22.1714318','2025-10-06 19:46:22.1529760',NULL,N'::1',N''),
	 (N'7E339E94-989D-413A-8224-A9F4A11D03A6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'psuibhZ/HfPm09NedG0KZs1FCIAMDtxmAgGWgukesuI=','2025-09-24 22:21:13.2619158','2025-09-24 23:21:13.2601945',NULL,N'::1',N''),
	 (N'F653FCB4-C410-43F3-9FD4-AA67BDC1EBAA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+qNUw5Xk4W7VOifkilw1N6lXwPaG4FN0fkf6wRxYCYw=','2025-09-16 19:42:53.5883321','2025-09-16 20:42:53.5882559',NULL,N'::1',N''),
	 (N'7940C5E7-98E1-4CA5-863A-AAD1F745DDC3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bN1r6dTC0wxL2y6vyzPFVA63V7MVv3oJO16955RiHBc=','2025-09-30 19:21:54.1391525','2025-09-30 19:23:54.0687993',NULL,N'::1',N''),
	 (N'EA4A4508-FB7D-4324-BAC5-ABB28EFE3C62',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/rkmwtu4Nl0SGqKHiYvrPHwAfWr6o6vnUowsOIWIKVE=','2025-10-01 22:39:39.8010807','2025-10-01 22:41:39.8010399',NULL,N'::1',N''),
	 (N'3AF29050-0931-48DD-A2B5-AC0AB0F8C6EF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'TsjE+Y8kVMPM/3/c2Pl/wzbj8GNF5csP2E4fJi5Qc+I=','2025-10-07 18:51:41.4564700','2025-10-07 18:53:41.4520680',NULL,N'::1',N''),
	 (N'7FF950DB-4D88-4796-B5BB-AC425915BDD3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KaHk1VZCSYx3VDapiAuSdjXZbez4vsNHmfU2McE1dfw=','2025-09-05 23:24:39.3766552','2025-09-06 00:24:39.3747052',NULL,N'::1',N''),
	 (N'122AF989-F224-4807-A387-AC6C2ECD3D50',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7DapyMs2ZLJHFOmaTFeIyZaR7sGl90Khl4OidiPbR+g=','2025-09-30 19:58:49.6463742','2025-09-30 20:00:49.6311987',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'EFBC6E8B-C65A-4ABD-B144-AC6C8303525A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'SCXcgPNSsOG/s8Uav16dZK51mxcwMyHSGpp6/MqN1Pk=','2025-10-03 21:21:05.8216758','2025-10-03 21:23:05.6971739',NULL,N'::1',N''),
	 (N'B6323987-9242-41F5-9CEB-AC998BCA7095',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'AevzHskH8Wel5Jlc5uZDxOmPy5o0l/g6jmkTOhCqVFM=','2025-09-30 19:48:14.8041940','2025-09-30 19:50:14.8040552',NULL,N'::1',N''),
	 (N'F990110F-D33A-40B0-8672-ACBF8ABA1C32',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lwokLXktpKSO6IE/JfuHJIHFIz5zkhzt8nM3gTW42Pg=','2025-10-06 19:51:32.5170354','2025-10-06 19:53:32.4399935',NULL,N'::1',N''),
	 (N'5766DB75-04C2-4267-9498-ACCD758F17B7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OHBB0l3VYFcdJPP6E93dkTWw0S70I4+5DylkYWay4pY=','2025-09-23 19:57:23.8670824','2025-09-23 20:57:23.8552147',NULL,N'::1',N''),
	 (N'D22AC798-CD2E-4326-BB30-ACDDB2C3507E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qk8FYlTH6iO1aG6g/I8kBX7IKYoE22dRKFaI9DIwXLQ=','2025-09-30 20:24:33.6359780','2025-09-30 20:26:33.6277938',NULL,N'::1',N''),
	 (N'8C874810-E84A-4C51-BE77-ADBC883CD9A6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'w1VumfSxb0GbnnX0MKORrqHnJcSKYMLZGrBf7yvZvU8=','2025-09-17 16:39:15.9114357','2025-09-17 17:39:15.9113695',NULL,N'::1',N''),
	 (N'14202C55-A2B1-4F5F-9252-ADF2960E7EE8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'aEJzXXXxTz4UFB6QysiMKD0gY1MJ2Scd/rFGp91wG18=','2025-09-08 21:28:24.9425082','2025-09-08 22:28:24.9409182',NULL,N'::1',N''),
	 (N'52033793-AA17-47C5-9304-AE28701197BC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'/VM/18xUIPQxrEdAF6pQ+wHfL08NDX8A8neBmqQhnLU=','2025-09-17 02:04:21.5919837','2025-09-17 03:04:21.5767560',NULL,N'::1',N''),
	 (N'C16CDC63-4F17-4644-8232-AE5D8659D10C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OkrWpqNwEy5Yke9osT2DKfeIoVzLZWd0mUC4Hbz4pUw=','2025-10-03 20:38:25.2354647','2025-10-03 20:40:25.2354174',NULL,N'::1',N''),
	 (N'7BCC67C5-5BD3-4DFB-97A9-AEBA61704FA9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'MgOrlSuGHXlowYBqSoUO1i+A70zLNNT0zqpOQ74YjQM=','2025-10-03 20:50:59.2496626','2025-10-03 20:52:59.2495573',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'365E0D93-4F5E-4759-81B0-AF83F2566EAC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'lYMQtEfAaAUfZnkWnDE5gfefVcwnUK1iTCHmPAGkrjw=','2025-09-23 23:10:54.3851174','2025-09-24 00:10:54.3623219',NULL,N'::1',N''),
	 (N'AF566DBD-EEAB-4808-AB5E-AF83F99E418C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'UOOPrwckb8hc/GE0i53Zca4Tf+3CTD+qLGFDRoiraPU=','2025-10-01 22:32:32.8660981','2025-10-01 22:34:32.8299097',NULL,N'::1',N''),
	 (N'0862C3C1-9555-432C-B9DE-AFDB5633A862',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'tt7MwgLM5x8aaeOUGFwl9ZGQOo8hxuk4dR+tf7Dm5FY=','2025-10-07 17:07:12.9632358','2025-10-07 17:09:12.9616352',NULL,N'::1',N''),
	 (N'3EBF5953-D29D-49EB-94D2-B085F9C87C84',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'UsSkGm19b2atXgiGiMBUlXM8CU0TbQGrAlFtMfRNJS4=','2025-09-17 21:10:39.5447906','2025-09-17 22:10:39.5351733',NULL,N'::1',N''),
	 (N'63D82C20-06B8-442A-B602-B0F04B028B9C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'itZeRjHjJ7/bMZKiX1tH/qYsl0G8H7sXnRMhRIcFOWk=','2025-10-01 21:30:43.3795845','2025-10-01 21:32:43.3795365',NULL,N'::1',N''),
	 (N'1A0CC460-78F3-403D-84F8-B1BC3763662B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'akd1l5TEVj9ZcDBng//hBuEk0lwUND8DLZnCTKj7UIY=','2025-09-22 18:47:25.9711454','2025-09-22 19:47:25.9081460',NULL,N'::1',N''),
	 (N'58622265-B0AE-4F7A-8225-B1DD6FB5DE4E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rMWbGOtnHg26PRAUb0GPiIwBnpKS4PH44TDFPkvQR/A=','2025-10-08 17:53:23.7904944','2025-10-08 18:53:23.7884904',NULL,N'::1',N''),
	 (N'F5EA08F4-957A-4B9E-8AAF-B1EE06F52A56',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1OZ1ExZEm+g5H4MnqggpmJ+Kx89ELUOh+Oe25Emr6uM=','2025-09-30 19:30:46.1795687','2025-09-30 19:32:46.1794943',NULL,N'::1',N''),
	 (N'DF5F9284-0A7D-4BFC-B91A-B217E98AB710',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'JPD54cDCaTg3biEYb7kzhzvohGr961EpUTLhEF0QyiA=','2025-09-05 23:17:08.3781515','2025-09-06 00:17:08.3451043',NULL,N'::1',N''),
	 (N'124FDCFA-A478-4F50-ABD3-B237BBF1AD4B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'pXBf575pvozFkGlCruAy2n5TJYebBjTlVR8gPE2szQQ=','2025-09-24 23:41:29.0048944','2025-09-25 00:41:29.0048101',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'F273052C-DD5C-452A-8813-B2745D46F6D3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vYy1TV8E6fp/abubOvcW4wfzi4vVunBI25SUDb8Z/AI=','2025-10-08 20:20:19.4139737','2025-10-08 21:20:19.3555877',NULL,N'::1',N''),
	 (N'C4C0CF8B-D57A-49E6-B311-B2CC2A006C32',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'pBbmsL5b4BsQKtTGM2Fy6q1w+U90L5HNiOMqYKKnS2E=','2025-09-30 19:48:14.8175232','2025-09-30 19:50:14.8040552',NULL,N'::1',N''),
	 (N'6B7A2704-A4E6-4B6B-B333-B2E76D77C779',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'+KiFjyfOhc/uvl+B2i4q64zOLOa3DziFwbpLabVOPtE=','2025-09-17 16:43:02.2913231','2025-09-17 17:43:02.2750284',NULL,N'::1',N''),
	 (N'7BB5740A-3DD2-4B44-9769-B2E77EA54163',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'QhkyP0RF8ByKy/YFHPJz+Ujqa9R7tgcafkrEnbuH4Ok=','2025-09-10 18:58:52.0505489','2025-09-10 19:58:52.0504897',NULL,N'::1',N''),
	 (N'166F3E62-BF7F-445E-ACFE-B305C7CB390F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'mi3G5/4B88QS5QvGOA/X5gPuYXYuLfmDNPhxWGl0Rh4=','2025-10-03 19:40:18.5783036','2025-10-03 19:42:18.5780328',NULL,N'::1',N''),
	 (N'816B0405-19EB-4521-8D01-B3BB3CAFDF3B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'G6ZZK5TI/o30tQMzH7+i1txQn2vOSlMYxdirSk3tRSo=','2025-09-30 19:39:47.6252382','2025-09-30 19:41:47.6250180',NULL,N'::1',N''),
	 (N'425C51E2-17E3-46ED-B271-B40DF194BA47',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'MBLlMQyxKgA8KnBi36aYsjwRBMrjB05+8yUvB15WyII=','2025-09-09 17:43:54.2061015','2025-09-09 18:43:54.1959610',NULL,N'::1',N''),
	 (N'401A1818-B93A-4A24-9EAC-B41A0886EC94',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'I2FDVIC9TW7JzM8V4kvMbV5tzkyFaw+2NAOG/qYM+zg=','2025-10-03 19:41:39.1762276','2025-10-03 19:43:39.1761394',NULL,N'::1',N''),
	 (N'B432C02E-CB4E-4A63-9D43-B435F78D0B99',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fYGHp0st97yVByCkgMRGYakPJq7IJDKk5bcMoezfaxQ=','2025-09-23 20:37:22.2216109','2025-09-23 21:37:22.2215350',NULL,N'::1',N''),
	 (N'864D6F64-E958-4A77-9034-B48EA33D30EC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+aK/sTLdCuMhGKS6O/9RgPRAMk4WvML3HPIuDfjr0tA=','2025-09-18 22:32:53.4099239','2025-09-18 23:32:53.4000605',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'C09A2A58-0F84-41CA-BF79-B4CD7ED472D0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'wN9DjvfEDX4SjUZMJhitH5vyLeIi14C4aUgC8VIKAao=','2025-09-17 02:04:23.0185946','2025-09-17 03:04:23.0180574',NULL,N'::1',N''),
	 (N'CAEFAB1C-A503-446C-AC54-B4EB650DC856',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jl8w+Qk71ImLiULyTLLR5dJUFQLuQPLZVRO2hH6uHFw=','2025-10-01 21:50:06.3343999','2025-10-01 21:52:06.3343513',NULL,N'::1',N''),
	 (N'BAFBBCE5-A920-4E86-BA3F-B51334E34243',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'drviZH4geRrrnRdGVSfbnJCJWrJjQrs1GbA10BcvcVI=','2025-09-09 03:22:21.1294013','2025-09-09 04:22:21.0847171',NULL,N'::1',N''),
	 (N'64F643FB-3C4F-44C8-895E-B53A776E1938',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'66o2o9tUjWy7R4rxI/z9pyvDMp/EVakuPuJV4FV9VnY=','2025-09-24 22:03:38.9311383','2025-09-24 23:03:38.9240838',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'E28AB0F0-20FE-4FD2-8F29-B5517B9F0089',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'V5YFRG8/8Sn4cjzfkEasD531Hii9UuH7got4P6dan1g=','2025-10-01 22:37:52.1115018','2025-10-01 22:39:52.1053991',NULL,N'::1',N''),
	 (N'85A51EE8-64CB-433E-827A-B567E632259A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Okb5PEqGgUZFt5GF0hiQYTGojy/BYZFDutGLaiCSY/k=','2025-09-24 23:31:13.8321269','2025-09-25 00:31:13.8320615',NULL,N'::1',N''),
	 (N'641E31C2-60C2-4192-A4C2-B591242DCFF9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'dIxKtYZXfNwjmUosxDy1HcnnBjeJAsBXHd3FLTgWKWg=','2025-09-30 20:15:29.4083900','2025-09-30 20:17:29.4081156',NULL,N'::1',N''),
	 (N'D91D6196-5E30-4484-AAAE-B5E21C3B4D20',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Cxt1lZ0grxQWT9oxadS7HyglTnu/LVLhsJaEwucRZ54=','2025-09-10 18:53:08.0942189','2025-09-10 19:53:08.0858288',NULL,N'::1',N''),
	 (N'77816D2F-A3CC-4FEE-90E8-B63C98E188AD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cn2VtKsucaWoc9nx+65ThiER/5MO/sdA0UIKyon/B10=','2025-10-01 22:46:30.8741402','2025-10-01 22:48:30.8671630',NULL,N'::1',N''),
	 (N'52389EBC-EFAA-44D4-AAEB-B6D78C78FDDA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rGLGPuSrN2s+556Dqju1oDGrgfZEqTx/2z11AQfhqbA=','2025-09-12 19:27:47.8644556','2025-09-12 20:27:47.8626819',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'30139759-7A4D-4EFB-A381-B705BE209D5F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/t8x2AOHVRUWWT2ccrAov9kdzoBB8fNJBTKjcIay0JE=','2025-10-01 21:27:27.1039078','2025-10-01 21:29:27.1038266',NULL,N'::1',N''),
	 (N'6E1AF205-F992-4F97-9648-B74F611DA57C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'BP4zJLc5tLKR/mBt/1YWEHpdNwa7MACV0PO2mWK7ujU=','2025-10-01 22:18:46.5081622','2025-10-01 22:20:46.5081253',NULL,N'::1',N''),
	 (N'37CB7F47-64B4-4830-9ED8-B7597B71E824',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'msPcjxjLXtrn5wbIjzloQI8KxY8PmUDZuBY1Hh9Jk/Q=','2025-09-23 22:04:25.4282795','2025-09-23 23:04:25.4184519',NULL,N'::1',N''),
	 (N'FC4D4B39-E77A-489D-9BA4-B78850CEEF43',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'p58XbsZEd4wC3kdHTblPrBT/rFZjWZKuDx/xZNnp5ik=','2025-09-18 22:26:06.2519763','2025-09-18 23:26:06.2506661',NULL,N'::1',N''),
	 (N'FF792EBD-3D28-43A2-B286-B7A4D8643BFB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'/bxO+L89KsBdtKbMuDvwtuiP6353IyS9iQenvv+6Ry4=','2025-09-18 22:00:27.4618159','2025-09-18 23:00:27.4615525',NULL,N'::1',N''),
	 (N'F9DCE69C-3F19-47AF-AB43-B8BEB5D6754C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'YWBJm1vFSic3KeBomlz3MjFctK5F4q+EW8khKABq4+A=','2025-09-10 18:18:46.2218025','2025-09-10 19:18:46.2205134',NULL,N'::1',N''),
	 (N'51E2175A-A2CB-46FA-BB69-B94233FF5B70',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6ztU5oxJTpQR63jxQjXGIG/qrrvKde8Qj0xQE/JSoPs=','2025-09-18 22:20:31.5136876','2025-09-18 23:20:31.5123966',NULL,N'::1',N''),
	 (N'209D995C-4243-4D6C-B501-B9A692B4D9DD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lTtm7VCU2u+RehLYXdnjMgMWAdSVxi0bpTLa5Sko7yg=','2025-10-03 21:07:25.1259107','2025-10-03 21:09:25.1158076',NULL,N'::1',N''),
	 (N'F6D52A78-651A-494B-B2E4-B9AD96D8F10C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'H+hbvs2qH01tCfqbJsP6cGNhADkLpg9Mo0ALIb/jHCE=','2025-09-17 01:14:47.7453538','2025-09-17 02:14:47.7250280',NULL,N'::1',N''),
	 (N'DAC53F81-3EA1-4796-81AA-BA9415034A10',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'gLD2kjevEQZkizGgpcjE5rNloV5jqKxQ/tcgr1VaXPM=','2025-09-22 19:06:56.0310366','2025-09-22 20:06:56.0200698',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'EEAA77AA-EB25-48B8-BD37-BA96BD96C207',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'26ltoVQ9QkPmuZYnkvfrFy9QoeqgyDBIfSw/3UwR7oI=','2025-10-09 16:43:37.6976741','2025-10-09 17:43:37.5348531',NULL,N'::1',N''),
	 (N'DC2F2269-A990-4F7A-8C72-BA9F4C3321EA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'v8VQhoBwfR2c6yCodD63TvXPbzrBGpooZ2cT/iXEhX8=','2025-09-16 20:16:06.2047624','2025-09-16 21:16:06.1929549',NULL,N'::1',N''),
	 (N'C700DDF4-ADA3-491F-B66B-BAC94B5856F5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'A1H38Ui2iADGf8+RfzhhaNG44UsH283I43Pf7HZ7aog=','2025-09-09 16:44:47.5908898','2025-09-09 17:44:47.5769731',NULL,N'::1',N''),
	 (N'32E5E673-D071-494A-8029-BADFD42C48AF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'MT039k/IH/M4/l0Q3iDP3MN1XDqieAHQ/Rh+/gTRI3U=','2025-10-06 19:44:22.5983170','2025-10-06 19:46:22.5959398',NULL,N'::1',N''),
	 (N'5139427A-98AD-49A2-A968-BAE9A8DBF7D6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'p++qIgh6OUaLatkZhTTspQHeAcbIlY6kaMCyYpmKZfg=','2025-10-03 20:39:51.9673384','2025-10-03 20:41:51.9671904',NULL,N'::1',N''),
	 (N'999BA48B-9A1A-4831-A985-BB3C9B73D435',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'igWik4Drb8qoRr1uz6ARWoFZkGI7h+kHRdj44R0MoCY=','2025-10-01 20:36:32.0830032','2025-10-01 20:38:32.0827851',NULL,N'::1',N''),
	 (N'78FE2801-9B77-4791-AD43-BB76599472DA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6YuzF/x5pr20UHWq9THRQdIwVLoLicL3fISrXwv3FhI=','2025-09-17 17:05:59.9621776','2025-09-17 18:05:59.9527728',NULL,N'::1',N''),
	 (N'86C99C60-BD33-4B17-BF6F-BB7F4B0DF2FD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'rl3kjVPs6OHxkmh/AA2riIVJf6OpvKlRlHBqjqltxj8=','2025-09-30 21:16:55.2307720','2025-09-30 21:36:55.2114767',NULL,N'::1',N''),
	 (N'4F26EA25-6448-45E5-86B0-BBC2D1AAD632',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8vlx6iqLpo5EhRgKsJVwzi5ftGkrNKRFuxv1Tbyg6qo=','2025-09-30 19:15:32.4057478','2025-09-30 19:17:32.3935367',NULL,N'::1',N''),
	 (N'B7E69143-DB8B-48AD-AFBC-BBEF60D69ECD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'98T3EDBu8vFSuc87zNQJX9YN/9IYqXBBJXWjLDvanI4=','2025-10-07 18:53:47.1966576','2025-10-07 18:55:47.1964470',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'3ECF0EB4-E49D-468F-A467-BC5044F3B717',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hN9uMQwfDviag9sojKpsDxJChg82JQvTR3uwrhiB+Ow=','2025-10-07 18:51:41.4521391','2025-10-07 18:53:41.4520680',NULL,N'::1',N''),
	 (N'346B935B-811E-4AA8-AA3A-BCA475958183',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wyXbA2yFTvy/bUFByYef5qusQMJ6YISKtDi3QizTrDA=','2025-10-08 20:09:32.6707052','2025-10-08 21:09:32.6094115',NULL,N'::1',N''),
	 (N'EE661FDC-9A3B-4401-84D1-BCC510642B5B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'EG8EGSyjUl41GSp7zQUX1JjIYetbeWYhZCAZkVPavko=','2025-10-03 20:53:22.3900852','2025-10-03 20:55:22.3822451',NULL,N'::1',N''),
	 (N'DBC1D5A8-332D-4DE5-8C7E-BCD5309E59FE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'LEyi7K9A697Ah2ul7u2OIA42SC1lof0v2K5kIDFubRI=','2025-09-30 21:16:55.6025809','2025-09-30 21:36:55.5908300',NULL,N'::1',N''),
	 (N'7353587B-0D7E-460F-AB0F-BCEE4F3766C8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'f0Bbn6bonI2RTQ1KZ05fG8sGH1oZBiWrf5C6hLHGmKU=','2025-10-06 19:52:45.6509445','2025-10-06 19:54:45.6508780',NULL,N'::1',N''),
	 (N'EFFACAB5-0896-4177-9514-BD5737E0FFA2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ISHas+QGCQC+WbSgsvT6q4w/ZVS6twQEGkZ+S3eZ8aE=','2025-09-30 20:59:13.6303778','2025-09-30 21:01:13.6110029',NULL,N'::1',N''),
	 (N'49383910-5762-4D91-AC80-BD822221FA41',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'JpR0pLqkFuGG5cw97Y3sVn+rpMsJN8CrLwcDr1sjzAc=','2025-09-23 23:06:39.2990593','2025-09-24 00:06:39.2781156',NULL,N'::1',N''),
	 (N'16923EE5-BD6C-499D-9385-BD98520FDE2B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'3iJVj63RHdUfkZGr+fBRL1F3xkQI/ZCrqU6F492e+JQ=','2025-10-07 19:27:06.5497030','2025-10-07 20:27:06.5405721',NULL,N'::1',N''),
	 (N'262E4BC2-EFD4-44C0-9D63-BDB9451ED490',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'i2x0bMsYQx00LmH3hHmGD4U2EabUE10c3g89kp30inU=','2025-10-07 18:57:19.8847798','2025-10-07 18:59:19.8847138',NULL,N'::1',N''),
	 (N'3071B46F-0CD8-4F64-A860-BDC596C68D78',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hbJQStiz5UUoKcgCYBOXLsvWHrtWqQ5nCetYnLB2yVg=','2025-09-09 00:52:35.7241318','2025-09-09 01:52:35.7231130',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'8E1F22E3-D49D-4D90-984A-BE2C9DB71FC3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jTah6lF0M8kn0x7l6g8QbCUoMRKjz5WmcPwfILTmWKE=','2025-10-01 22:43:21.8405201','2025-10-01 22:45:21.8400566',NULL,N'::1',N''),
	 (N'263FDDDF-3914-4D5A-A4C2-BE4B5CC0DE1B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+KiFjyfOhc/uvl+B2i4q64zOLOa3DziFwbpLabVOPtE=','2025-09-17 16:43:02.6608359','2025-09-17 17:43:02.6589846',NULL,N'::1',N''),
	 (N'CC0AB472-FD02-4B00-B14A-BE5320190A41',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'uWJf+Yko/B2h5APz3pJDI+6YKyYjrk+jZs6ljyOzQkE=','2025-09-29 22:03:20.7118383','2025-09-29 23:03:20.6925967',NULL,N'::1',N''),
	 (N'3227C1E8-B6BB-4C41-9952-BEBA19A068D0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'QhkyP0RF8ByKy/YFHPJz+Ujqa9R7tgcafkrEnbuH4Ok=','2025-09-10 18:58:52.0308222','2025-09-10 19:58:52.0305693',NULL,N'::1',N''),
	 (N'7A63C0DA-DE03-46D6-8ACF-BEDBD76E5B2D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'H+hbvs2qH01tCfqbJsP6cGNhADkLpg9Mo0ALIb/jHCE=','2025-09-17 01:14:47.7453482','2025-09-17 02:14:47.7250341',NULL,N'::1',N''),
	 (N'616BA872-8941-4A9A-9CC2-BF287DFF49FB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Sc1Ru7VxDsawG4Y6ayJ9HxA3kI5zbaB34EhsujXjm70=','2025-10-03 20:52:48.8388504','2025-10-03 20:54:48.8387960',NULL,N'::1',N''),
	 (N'3268D587-8670-4BBB-B1DD-BF74C9741314',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Q8NR3XAnUSdBa6nisjLPtqKiLuE815tSmtegLcVVUiY=','2025-10-06 19:45:57.3351362','2025-10-06 19:47:57.2979549',NULL,N'::1',N''),
	 (N'6473B454-A739-4F0F-922C-BF7660ED1C7F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rey8z08VGsO5b7BYrucQ6Jf6C/8MXXx4bkSwMf7ZScA=','2025-10-01 22:00:21.2407281','2025-10-01 22:02:21.2406752',NULL,N'::1',N''),
	 (N'EB5258C3-C293-42C1-BE2B-BF7C56838277',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'soapJyj4yQiqppPxHCEBBf7k7EY5X9tDGsywwqSGrNU=','2025-09-30 21:43:47.5715921','2025-09-30 22:03:47.5715266',NULL,N'::1',N''),
	 (N'47C28D8F-7C17-47ED-A1F6-BFB35E794883',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'c/+8UgXlIPCDxVcyV3l+fiNTBk38/lLOu/T0T84B3nQ=','2025-10-08 20:43:04.9656162','2025-10-08 21:43:04.9498547',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'6382C18E-9EC5-430B-9C36-BFC1324B31DA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+HulmgUhBb1KRgYkGqC7i8+u1hkK2J/CtJOVjdJHw9g=','2025-09-22 23:13:32.1198801','2025-09-23 00:13:32.0779048',NULL,N'::1',N''),
	 (N'F19C37FB-FC9D-4326-A780-BFCB1157692F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'VzO9Ur8egKTYplYVQPlKerpPyWw0AkZ9EeLcrZYSQ8U=','2025-10-03 20:06:36.9699403','2025-10-03 20:08:36.9698853',NULL,N'::1',N''),
	 (N'052AE14E-17E8-48F8-B98E-BFE4F4BF1375',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ENbkzjCdb9DkudXISXLbRmhuRlHkypLWkX0P0RVuG9k=','2025-10-01 22:43:41.6614705','2025-10-01 22:45:41.6613398',NULL,N'::1',N''),
	 (N'488706D6-FB93-44BA-898B-C0082C3B3CA0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'H47i9yzLCG8I+g5SVOMS8jEHwSer1pCB00t/SE4OsDE=','2025-09-05 23:17:52.6149456','2025-09-06 00:17:52.6136415',NULL,N'::1',N''),
	 (N'4C904F40-0C58-4F19-AA60-C02A5E5790A9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RC3eRTbYXhiY5DFx4toqTmYkBTqCD6rkXEuPAB4eApo=','2025-09-24 22:03:38.9241621','2025-09-24 23:03:38.9240838',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'EC3876D9-2D05-4385-805F-C069BAEA5A80',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RUYEwfnZAv/5InmNQvgDmzG9GJ2pV3mkY/X3MecJD8A=','2025-09-18 21:59:57.0547092','2025-09-18 22:59:57.0546343',NULL,N'::1',N''),
	 (N'1692F92C-FCCF-4801-8581-C07EC645BF93',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7eagvwknYh4WsLm9TK/G6r6G7DuVZvziigDCo7Uy0qQ=','2025-10-03 21:20:38.7782099','2025-10-03 21:22:38.7492300',NULL,N'::1',N''),
	 (N'1300A8B8-6A19-46CE-9794-C09B0F53DCEC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GFdEoSy6hzcr1p7LxSJbEU1/gjxx1xpykDVlxTKveoQ=','2025-09-29 21:43:47.1662408','2025-09-29 22:43:47.1647915',NULL,N'::1',N''),
	 (N'1D4BAC69-7F2C-4FAE-8779-C0BF8C104854',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'098yYrI3Odyl/QPOipWFiGL9g7xEb8oTlbpBR4L5x9M=','2025-10-01 20:33:01.1642347','2025-10-01 20:35:01.1640446',NULL,N'::1',N''),
	 (N'E32CD307-7073-4A24-862C-C0CD0F687087',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'QjajhyXWpFqlWClyOwuTm3OWS7UXEg0lLp0c7v3RaxM=','2025-09-17 20:20:12.3080833','2025-09-17 21:20:12.2956553',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'EB60F81C-B69B-46D7-B906-C13554ADF4E1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RV7EMgtApzr9VUwCDlO4DeQIyWyinnQ5wJ2vwm2H7B4=','2025-09-24 21:49:24.6283424','2025-09-24 22:49:24.6159456',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'17FC1211-BF32-4FD1-B935-C18A830DB9F0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Q6u/a9vk5DtoiMl8hkg0Mgs8z0d4kgxAwLuxq1N+IC0=','2025-10-03 20:28:30.9756690','2025-10-03 20:30:30.9240192',NULL,N'::1',N''),
	 (N'7C8F6701-D5A4-4002-8AD2-C2096BABC663',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'N0Y2udK7rqINgnfCcR2Uq6gj8cCgrsgUnacYNgLsn0w=','2025-10-07 19:12:44.5746656','2025-10-07 19:14:44.5744764',NULL,N'::1',N''),
	 (N'8AB3FEB9-D24C-4E95-9CC6-C2C40F4E9423',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vH3gMnXA+DCLC5mb+AKkTGC+w51ZioLUGB+OeKazyM8=','2025-09-05 22:45:33.9930653','2025-09-05 23:45:33.9489097',NULL,N'::1',N''),
	 (N'7D48C436-629A-4975-9068-C2F66BACA842',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'YvT4PEynwJBPXiEgbIsKhEZ1DBAmsJLP3zOB3cghhN0=','2025-09-16 20:01:41.4828870','2025-09-16 21:01:41.4816406',NULL,N'::1',N''),
	 (N'7F08540C-C027-4277-99F4-C3413771E217',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'jaKpQ36gQQnHyd7VAYt0yMFr6cdFsp6Xj+9aG1HY83E=','2025-09-23 21:12:35.3752507','2025-09-23 22:12:35.3750180',NULL,N'::1',N''),
	 (N'A980673F-7357-40BB-9D12-C345A47A8C49',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'8EZ56odblrLRhWjlgrpeunb7yBKky1FDOQqM+rklFms=','2025-09-17 01:27:50.4068181','2025-09-17 02:27:50.3916853',NULL,N'::1',N''),
	 (N'2931DBC3-5F07-4ADA-B7B9-C3852D783E7C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'uOV8XBJRQy10PjoHp1osQU+gbA7ZBWPPmTPExgI6oSk=','2025-10-03 21:21:05.5958865','2025-10-03 21:23:05.5955282',NULL,N'::1',N''),
	 (N'9C73D085-61F3-4EEC-8E7F-C3CBA376376D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'j0TvaFhNN+gfs53unPZVUgrozOeb4cwDrsxWwwKprsU=','2025-10-01 21:52:37.8615957','2025-10-01 21:54:37.8615521',NULL,N'::1',N''),
	 (N'E51723E4-0634-4E3F-821B-C3FBECD16572',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'+h/SCBNn3FiDgfyIlhxJo0L/BF5qF3jzFAO+812UKNE=','2025-09-25 00:02:02.0543548','2025-09-25 01:02:02.0415492',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'0D3E6915-9338-4751-9125-C44F4E48CA1C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0fBhaejvVikKw+MIWV+ccGCA3Xw2ker0y3ribLzlRFQ=','2025-10-01 20:22:24.3408914','2025-10-01 20:24:24.3406936',NULL,N'::1',N''),
	 (N'183FFA7F-02CF-4D8A-9754-C4750D9A8F84',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'/VWTw4EB3XPNPxNyq6ZTFfFM4TWv4T0IgrGgomd5Fp8=','2025-09-29 22:29:28.2545856','2025-09-29 23:29:28.2543433',NULL,N'::1',N''),
	 (N'175247B3-8E6C-4DA5-84DF-C4AFDED67475',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'vP0SJsKoNJ2FN4tGNZd9JCrT0au2jIw1e1n8iPfdybk=','2025-09-23 19:28:38.7728549','2025-09-23 20:28:38.7566443',NULL,N'::1',N''),
	 (N'494D6CED-889C-43DF-B554-C4B7298891BE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vP0SJsKoNJ2FN4tGNZd9JCrT0au2jIw1e1n8iPfdybk=','2025-09-23 19:28:39.0985548','2025-09-23 20:28:39.0967029',NULL,N'::1',N''),
	 (N'F4A01046-6E66-441F-965B-C55D431A13E9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RNGPGsf7/dvbAdQ9xpH6pepXoGbLe5ceLqynNyJ8a+I=','2025-10-03 20:45:36.7750884','2025-10-03 20:47:36.7749296',NULL,N'::1',N''),
	 (N'F1D9C9BF-DF22-4351-8FCF-C5DAF09EAD80',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'EEu22VstOY0vYFV3FsBLIPavJFuoCL9AeqGgBTKLruY=','2025-09-05 22:00:21.8344409','2025-09-05 23:00:01.8648416',NULL,N'::1',N''),
	 (N'7D6471F2-994D-4F03-B838-C5DD5A2DBDEB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'rZdz6xR33jyQqpGHDaCoIaqwSQx0KdDjUtNOTU2M4FU=','2025-09-29 22:15:47.5986802','2025-09-29 23:15:47.5984067',NULL,N'::1',N''),
	 (N'18949759-5FD3-48D7-AF53-C5F2FA59BC81',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Esub9Qvftd6vObNbn5q5oZnXbIk37f84ZM+xvDWIhQ8=','2025-09-09 03:32:05.1179039','2025-09-09 04:32:05.1081406',NULL,N'::1',N''),
	 (N'2815A00E-CB6B-406F-821C-C66A72D15FAF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ZZGBLcCY8cURnrfu1Bah5MLUCYtl5JULHqZDkQKmWRM=','2025-09-05 22:56:38.9512989','2025-09-05 23:56:38.9508656',NULL,N'::1',N''),
	 (N'343322AE-3387-4355-BB05-C6ABFFD91AAD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hahENn3UfUIorrE6LUGJ4mLx5S8WEH7k/oAM+HdvdWo=','2025-10-08 18:18:12.8762859','2025-10-08 19:18:12.8750505',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'46E47456-CD72-4783-8B53-C6BEBC6A4653',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'sOiPJUIgOukeYYI4ICmgrGaBY/p5K+DJekGD8nRABYM=','2025-09-24 21:55:33.5188452','2025-09-24 22:55:33.4776735',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'81A4264A-D142-4773-A091-C7FB22451781',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1JDfctStscUvnBwFR+tx59Zdt9f9JxjFLOH6Ubml2Go=','2025-10-03 21:17:37.6193314','2025-10-03 21:19:37.5459415',NULL,N'::1',N''),
	 (N'6DB1EAE5-259C-4628-97C0-C8377BEA0A63',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6UPX6huzkEdaOg5gQzRWGWZ2WWBZZofYLWqv+Qlc13Q=','2025-09-16 19:44:49.0714989','2025-09-16 20:44:49.0602204',NULL,N'::1',N''),
	 (N'2361E1CE-12AD-4693-818F-C84AA375BD82',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ij1AtDerhCDKwKyAV6nPT2g6dOB4g4AaLdpjGJc0Crg=','2025-09-16 20:22:16.7515510','2025-09-16 21:22:16.7145005',NULL,N'::1',N''),
	 (N'A8424E87-C8C1-4943-B64F-C8719C42FCA7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8EZ56odblrLRhWjlgrpeunb7yBKky1FDOQqM+rklFms=','2025-09-17 01:27:50.6798029','2025-09-17 02:27:50.6786707',NULL,N'::1',N''),
	 (N'AE10C871-BFD5-4C1F-9578-C87D9A67D4AF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'9t3IuHd0Risch4AjDAKNXpqp5tb1+R4590o8RRIUEB8=','2025-09-16 18:30:41.5209114','2025-09-16 19:30:41.4511251',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'92613372-04A4-446E-BDD0-C87F3ADE27B1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'NuCimaNpq0ryPdgipu35ol8ui1/JeT3EHrgMXZUGVtE=','2025-09-10 18:56:46.0962216','2025-09-10 19:56:46.0960006',NULL,N'::1',N''),
	 (N'CB547AC8-8AED-4EAA-93C0-C8D93911EC48',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'F6qFemD1fH1ZsJIpO2HZAZASc0SXLXhM+qE0oiuS/js=','2025-09-29 22:29:28.2980525','2025-09-29 23:29:28.2898847',NULL,N'::1',N''),
	 (N'74A2F78A-A8C4-4F6E-8EC9-C93D08D555E3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'CxU2+dppHcOTKww7/rH6FcWZRMR/V7+mhggh5Ibbd+8=','2025-10-03 21:22:22.3852782','2025-10-03 21:24:22.3850868',NULL,N'::1',N''),
	 (N'027AD866-5F69-4353-86A5-C95F533DCBF2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rXP30JUZg4AS42Uu0zSZKwBVum0u1PDVTbHwEsV2avI=','2025-10-01 22:18:46.5141119','2025-10-01 22:20:46.5081253',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'D0DB8EDE-4C23-4E7A-B357-C977A55C7812',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OmeosFx8HI1wr3sGGidzzLnwj9lSwzFIiCcFo+eXI3s=','2025-10-01 22:43:21.8736181','2025-10-01 22:45:21.8400566',NULL,N'::1',N''),
	 (N'2DA7E779-8006-46A3-861A-C982544E7D4C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KzjEoKNiPjYogaTu9K6ckmG979ygdko05omzYRcwIuQ=','2025-10-07 18:20:12.0910265','2025-10-07 19:20:12.0895408',NULL,N'::1',N''),
	 (N'E5604B37-A54D-4BC1-A5FD-C983EE059284',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'lDvRM/eTtTMesuxOFOKv+tnQg+23LaTEWAvaugoC2/4=','2025-09-17 01:38:07.2051976','2025-09-17 02:38:07.2046583',NULL,N'::1',N''),
	 (N'E014C41F-E473-44D0-A793-C9EB417689E3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'lg2Jtf/rUW2vimmTok3p+cNeuRpNC7Ly8Vvc40dMSqg=','2025-10-01 21:37:58.5401152','2025-10-01 21:39:58.5400021',NULL,N'::1',N''),
	 (N'84676A24-D62E-4DBF-82F5-CA1E55B06561',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'FyToVUS+PjjyREuFff+zCfH5nEuxMEmSFpuGfxzllj8=','2025-09-22 18:39:55.2303363','2025-09-22 19:39:55.2289027',NULL,N'::1',N''),
	 (N'36B97971-F863-4CD2-9F25-CA2BB699D0BF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wCJONF0nle73ZKOsjKCddR9tGu3vDPBR66W6ime6MNE=','2025-10-03 19:20:37.9267806','2025-10-03 19:22:37.9131867',NULL,N'::1',N''),
	 (N'6D9BFD1E-6554-4E4A-9CF4-CA34A57DC73B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'4LusQskRtvrk8ibkcvLSFbnx/xujb9RQdi50x3Gshrg=','2025-09-18 22:01:40.2257090','2025-09-18 23:01:40.2157759',NULL,N'::1',N''),
	 (N'F6C68B9C-4787-456D-A7C6-CA70B6390F49',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'iiP0sv3Br/WC+ozFqgQcg2jFRdQGDoNXbTJnF1MOXvc=','2025-09-09 19:21:41.8034210','2025-09-09 20:21:41.7931916',NULL,N'::1',N''),
	 (N'7948C929-7429-4290-B220-CA714BF288FD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'pXBf575pvozFkGlCruAy2n5TJYebBjTlVR8gPE2szQQ=','2025-09-24 23:41:28.9853363','2025-09-25 00:41:28.9851227',NULL,N'::1',N''),
	 (N'58371F2B-2593-41F6-89FF-CA7B98785E25',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Upx2XYScknQqvBKtboZlbyCgu1PNWp0hMFpFmbA0Lvc=','2025-09-16 22:30:59.7439686','2025-09-16 23:30:59.7338143',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'0F9F91EF-1A9C-4CB9-BBA3-CADBB379D992',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8Oi4Ng7vmNYqQ/Q76GTwtjr1vBSMWR6SfdXGRqlV6lw=','2025-10-07 18:59:42.8166431','2025-10-07 19:01:42.8116642',NULL,N'::1',N''),
	 (N'808B1430-E10A-48AE-9753-CB01B4AD2AB7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Ioqjbtm5T6LuRM5N5axLFWmWl4w/6Fbsd/aE44IDWYo=','2025-09-23 19:11:35.1544198','2025-09-23 20:11:35.1390822',NULL,N'::1',N''),
	 (N'67D2E9B3-53EF-4A64-BA06-CB0EFF311BE2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'LAy91Q3cb3VqLLyrJ0wK1rg+ngk/AHQD3NsOq1IARdM=','2025-10-08 20:09:21.2011167','2025-10-08 21:09:21.1897659',NULL,N'::1',N''),
	 (N'3CA00A6D-90F1-473F-A2EF-CB2594A08283',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'BZem93uXjRhD9pO+gZoytdUKb8SPhYNH/YqbrsDtYR8=','2025-10-07 18:34:18.6198691','2025-10-07 18:36:18.6180461',NULL,N'::1',N''),
	 (N'DDD7E5A3-D76D-4567-9754-CBB393B6C85B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Gq+IdFTjvQ10h5YqZe5lLGaLAA1V1EEAZZbLFvV9YSo=','2025-09-05 22:55:56.5368614','2025-09-05 23:55:56.5312743',NULL,N'::1',N''),
	 (N'136B5970-524E-47F6-9F32-CC1D10D3585C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'VbE2GV41LFb8+Yfpq3MC9+gT44Vzpn7edQik6VgJUsk=','2025-10-03 20:26:38.0764054','2025-10-03 20:28:38.0693932',NULL,N'::1',N''),
	 (N'D4AE9770-3FE2-476B-BAF5-CC6D382ED08D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'jqjGugP5wUKKVPIN55ZwQNMD5L80zKT3YKIXvaQBZMg=','2025-10-03 21:02:58.3057025','2025-10-03 21:04:58.3055831',NULL,N'::1',N''),
	 (N'CA8CA2A8-B6B3-4948-8772-CC885F91DAEB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uOV8XBJRQy10PjoHp1osQU+gbA7ZBWPPmTPExgI6oSk=','2025-10-03 21:21:05.6973222','2025-10-03 21:23:05.6971739',NULL,N'::1',N''),
	 (N'808F40D5-42FA-4545-8F6C-CCA603198540',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'mi3G5/4B88QS5QvGOA/X5gPuYXYuLfmDNPhxWGl0Rh4=','2025-10-03 19:40:18.6525167','2025-10-03 19:42:18.6522803',NULL,N'::1',N''),
	 (N'A4E021B6-4D9C-4DFD-B488-CCAC7062AD87',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'cf++pCDEUYPS0R5q8A0HNF2VjP/G2tsGSMW5zxVsBPY=','2025-09-22 19:48:15.2907785','2025-09-22 20:48:15.2737830',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'B3817521-2C3D-431D-8775-CD3AAC8DC42B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZvYrwhi5syvFx1ItMaJCN1mvAni0Y93VBhr9EQx3mIs=','2025-10-03 20:32:49.1598319','2025-10-03 20:34:49.1597636',NULL,N'::1',N''),
	 (N'64EE16E3-CE19-40AF-B45D-CDD42E8DAE1A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'TTHOaLM41plnwMpzacqHcMK6p4CV6ySF/aXkRZGfri0=','2025-09-30 19:51:54.5248277','2025-09-30 19:53:54.5189751',NULL,N'::1',N''),
	 (N'34870147-0C24-4CDF-AF83-CDD9DFB35414',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5pS7oqni5bkYEup8jOdJVIqYbiRjPyNTImCNl667E+4=','2025-10-03 20:10:08.6406281','2025-10-03 20:12:08.5955853',NULL,N'::1',N''),
	 (N'6886284E-17CD-415A-A1CD-CE18C9677999',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Rh4ackIujZQJJRD7oQDYbdxYlfTul0GKI35UxbHN74A=','2025-09-24 21:51:51.7901990','2025-09-24 22:51:51.7811411',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'90446E50-8E40-44C3-B218-CE2204C253A7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'75vfRMJZc2Di2+CIeQ9nwuM8nB9XXyx/mSOdeJ9PGaA=','2025-09-17 01:33:40.5493377','2025-09-17 02:33:40.5288570',NULL,N'::1',N''),
	 (N'0BB1FC84-1812-45EB-ADEF-CEB7ED88FEF2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'qRwUZBydu6BxcHCUiA98/6rlhCaz350/zIqccu3l2pE=','2025-10-03 19:21:59.7670610','2025-10-03 19:23:59.7667897',NULL,N'::1',N''),
	 (N'B353A597-33CF-4249-99BC-CEF04D46976F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'd9DPT+QaZvHwhrLfnvNuofYVbGyB7qlT8RrvOX4Qk1s=','2025-09-23 19:44:46.3065537','2025-09-23 20:44:46.2704725',NULL,N'::1',N''),
	 (N'8CA9BC87-F6DC-4C61-A790-CFBD67E5673E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9jtP20rt7agETxgAZcHfxreV4A0QF6NBXU45F1DorpE=','2025-10-03 21:15:12.1312918','2025-10-03 21:17:12.1292844',NULL,N'::1',N''),
	 (N'4205A4A6-5C68-4D45-BF89-CFDE51455803',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Ersik+0pbAwfuPAfbFZyEhn8d8IiU8wtey+R+Ep7x+k=','2025-10-01 22:44:46.1960542','2025-10-01 22:46:46.1765230',NULL,N'::1',N''),
	 (N'EB792BBB-B5F6-4376-8940-CFEEE9CB78CE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ISz7VHlKUBx3Vsg3Tu2h5ly4M3WGKWAD0QCzjsDdBww=','2025-09-17 20:54:11.8274083','2025-09-17 21:54:11.8114335',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'B52A97DC-EDF6-40C8-A774-CFF727C1A231',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'p++qIgh6OUaLatkZhTTspQHeAcbIlY6kaMCyYpmKZfg=','2025-10-03 20:39:52.0238422','2025-10-03 20:41:52.0238019',NULL,N'::1',N''),
	 (N'97959FDD-42FE-42D8-9609-CFF9DDE9E37B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dIxKtYZXfNwjmUosxDy1HcnnBjeJAsBXHd3FLTgWKWg=','2025-09-30 20:15:30.9470375','2025-09-30 20:17:30.9469652',NULL,N'::1',N''),
	 (N'4F34EEF8-EF5A-4960-8E94-D00143379E8E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'sSF8fubqpe//aeGEGxLzJOssAkQwTIkRzEjpl0Sw15o=','2025-09-08 20:31:35.9241271','2025-09-08 21:31:35.9105263',NULL,N'::1',N''),
	 (N'324E005C-E6F7-4BCA-B24A-D03AFE247424',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'FkqakK1wlL/ARR15gesingJ7ONpPt5zi2jBbzmPPKCU=','2025-10-03 21:15:12.1400643','2025-10-03 21:17:12.1292844',NULL,N'::1',N''),
	 (N'C461B990-8311-4322-9378-D049C22DC02F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'U7Kx7QCZ15bFBTs0DeJlubhbyFEXgPdOenW5DGKeFHc=','2025-10-08 00:54:52.7271817','2025-10-08 01:54:52.7268931',NULL,N'::1',N''),
	 (N'EFE342F2-9753-434E-8E84-D073C2B96024',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'g4h8BUkJ2dsDhhQC73Lm1xUVcHgQ4Ru68mmc652pQKs=','2025-10-03 20:48:58.9714952','2025-10-03 20:50:58.9385699',NULL,N'::1',N''),
	 (N'4900F347-FC02-4BAF-B055-D0AD737991E9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'cT2FNHIhRwDly3frxGtnKQzwmZRJxEVnq/avmDgixkc=','2025-10-07 23:41:27.0159069','2025-10-08 00:41:27.0013516',NULL,N'::1',N''),
	 (N'1F5DB4A0-5D48-4591-8F2A-D0CB439DBA32',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZTIepXtj+pzX0lvtjkoFhA5UoTgSnNsm7x7ZQ/vtpsk=','2025-09-16 20:01:41.4916436','2025-09-16 21:01:41.4816406',NULL,N'::1',N''),
	 (N'386AC6CB-3057-47ED-AB32-D134200ECCB9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N't7k9bukcriu4hrGUvFA3n+lI7y0X2ReL20SxyfeL9g8=','2025-09-30 19:33:52.9848349','2025-09-30 19:35:52.9847636',NULL,N'::1',N''),
	 (N'125A93AF-6586-493F-8E46-D249C0065B4C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5vYPyq0OtVeYZ584+5y1b83SJqQIiq1NyZVhOfDNUcU=','2025-10-01 19:51:42.4058509','2025-10-01 19:53:42.3949629',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'F548486A-47C1-47CE-9A1D-D37E42469FCC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'8vPuRS3BRL+LKRvs4gpxzeYU1iQHrxOClJaLr40dcEY=','2025-09-24 20:36:44.2426033','2025-09-24 21:36:44.2422265',NULL,N'::1',N''),
	 (N'932E5C80-9870-4104-A2B1-D395BC7F4EC0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8/LvILJjv5rGllzoKIPJl6R3PghRpef83Habe30/7pc=','2025-09-16 20:11:12.3693776','2025-09-16 21:11:12.3608421',NULL,N'::1',N''),
	 (N'1049AD97-DF47-4FC9-9AF1-D3A229022968',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZfbAqewnZuTZaOsKAoLkA6c+NkUm0cWZ/s+aAu+vKpw=','2025-10-09 18:44:58.5496665','2025-10-09 19:44:58.5428947',NULL,N'::1',N''),
	 (N'FA58DF80-AF4D-4E1E-9C03-D3D6740695FD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'sNYX6Fp894v+xsR1ZGSJ9M49ER4dlMSrewW6N9n/R4A=','2025-09-18 23:19:31.5232687','2025-09-19 00:19:31.5072763',NULL,N'::1',N''),
	 (N'D1C2C5FC-D148-4A80-85A1-D3F681EDE4B8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'FZnLdiu62VJjx1rRZQvXn8rxzvpTpRVCj2SXY9ggLsc=','2025-09-09 19:21:41.4958318','2025-09-09 20:21:41.4810037',NULL,N'::1',N''),
	 (N'456EA87A-23C9-4F90-B7E9-D40875614381',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vn1vQNX86E9TfXn65K5Bu3oGmxOfyRFlttEPgZBeCxA=','2025-09-17 19:48:51.2597791','2025-09-17 20:48:51.2586744',NULL,N'::1',N''),
	 (N'11E26D11-4EDF-45F5-8C33-D483E57A7FF6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'f7/ubvGRWa+s3/AM/aJszoeYx+j4TaoAMCbi03EkFks=','2025-10-01 22:39:42.8922163','2025-10-01 22:41:42.8920785',NULL,N'::1',N''),
	 (N'C8C42E7C-9FFB-46E4-8CC0-D5564E235F3B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1GA19bFGOtjG4tNG9KUMradMp6dkWiK2+oAYaNp7jnw=','2025-09-30 00:06:31.3795292','2025-09-30 01:06:31.3771960',NULL,N'::1',N''),
	 (N'F33E347C-3FCF-4B73-9CCE-D57E64219D8E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GTA1vJG2qVtdbIJ/OmcZdkPogy/kL0eIsaWDK1S4Iro=','2025-09-17 20:05:35.7031431','2025-09-17 21:05:35.6937229',NULL,N'::1',N''),
	 (N'102F6EFE-FBC9-4A3A-A486-D5EAFBB1461D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'QjajhyXWpFqlWClyOwuTm3OWS7UXEg0lLp0c7v3RaxM=','2025-09-17 20:20:12.6206025','2025-09-17 21:20:12.6191721',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'1FAF400F-2E10-4E9F-981B-D62C8709C9EF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'KmY3nM+EivL7Qx2Y0BAEMeviyaoJpXZ4PzpyCPtwnWI=','2025-10-07 17:11:38.0052584','2025-10-07 18:11:37.9736754',NULL,N'::1',N''),
	 (N'3A2DCFF4-B893-410D-A1F5-D6557BEDAAE3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'09FsyD+4qvAis8bYdc6almP3uLyUyEMgHm9C1drvegM=','2025-09-30 00:22:12.8708744','2025-09-30 01:22:12.8625516',NULL,N'::1',N''),
	 (N'E7A3A6BC-FC02-4A4C-B7BF-D67F21F1F339',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'awlTi4NTjs6p0HOQ6HUFwcQMhTSC+32aAPGgzJ7IUnA=','2025-10-01 21:59:43.4335295','2025-10-01 22:01:43.4333953',NULL,N'::1',N''),
	 (N'5E3501C6-30AD-4A9C-AC9A-D6D2210D9313',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'U7Kx7QCZ15bFBTs0DeJlubhbyFEXgPdOenW5DGKeFHc=','2025-10-08 00:54:52.8177252','2025-10-08 01:54:52.8176535',NULL,N'::1',N''),
	 (N'F06DD129-B8D6-4344-AE38-D6F31F65ABE2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Xk7mEJ81rSYMIy67Xz5UJyY0PRInqHUcRqjyqrOiuxM=','2025-09-10 18:58:52.0820784','2025-09-10 19:58:52.0504897',NULL,N'::1',N''),
	 (N'3A081544-3A0D-43A0-8CBB-D710C5D4A630',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2IK7SbHU6YDXsCBonpfI2RNCAHcHtE0ucXHEBJa6PFs=','2025-10-06 19:52:45.6772811','2025-10-06 19:54:45.6508780',NULL,N'::1',N''),
	 (N'27916D59-1F76-4539-A6A0-D721645D53E7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'dIICmJk38ljjuipNbD4eiI94uTW9iEGb5RgsbpI+fXo=','2025-09-17 20:05:35.6774114','2025-09-17 21:05:35.6771493',NULL,N'::1',N''),
	 (N'4807A1DF-DB2A-416F-A167-D7C00BD3DB5D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'hN9uMQwfDviag9sojKpsDxJChg82JQvTR3uwrhiB+Ow=','2025-10-07 18:51:41.4423781','2025-10-07 18:53:41.4419419',NULL,N'::1',N''),
	 (N'BFD64BFD-4502-49BA-A295-D7C49570BF35',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'68zH7+z30IiJMkPTtfrmu+XmclEICkKqTlwqDmHhP4w=','2025-10-01 20:44:53.5913769','2025-10-01 20:46:53.5912348',NULL,N'::1',N''),
	 (N'C8B57C73-03D9-4D9B-AD1D-D7C4E0F861FF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'MqtkCB1mfZOlmY8jQQ8O+QoPAYjA5zUwQ89lmcpuhOE=','2025-09-24 21:57:46.6027433','2025-09-24 22:57:46.5567817',NULL,N'::1',N'PostmanRuntime/7.44.1');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'6833E4EF-AE3A-4F32-9651-D7DDE68E32A9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'e8/9CaF1nFxP138+FQkJD38oVsfPwGByTPGaF4V7b7M=','2025-09-24 21:56:02.2653016','2025-09-24 22:56:02.2652477',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'5694AEFA-73DC-4873-A40C-D805A71BB9A8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'drviZH4geRrrnRdGVSfbnJCJWrJjQrs1GbA10BcvcVI=','2025-09-09 03:22:21.4759159','2025-09-09 04:22:21.4744623',NULL,N'::1',N''),
	 (N'6BB69F74-56C9-49F6-BABE-D87399AC85BC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hBnuMEVO8AJnV1Vd/OyZWEVPl0y5bIixgi6hGeBWVzk=','2025-09-24 20:33:37.8224083','2025-09-24 21:33:37.8100814',NULL,N'::1',N''),
	 (N'57BC6918-5AEC-43B4-816D-D89656D33A77',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'sOiPJUIgOukeYYI4ICmgrGaBY/p5K+DJekGD8nRABYM=','2025-09-24 21:55:33.8812906','2025-09-24 22:55:33.8802292',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'4EDBAAA1-9648-43F1-BF37-D8D9124B08B0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Xctn/BWV9PKbCLIrI8kkprjL+VO3u5rpfvYW4zwWPmY=','2025-09-09 18:26:05.0940467','2025-09-09 19:26:05.0927140',NULL,N'::1',N''),
	 (N'FC342C6E-7491-4250-A4D3-D94672F43964',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Ap22KIOQemHRs7VT7c105RrusVRHYk+hOsyrtw9TmRI=','2025-09-18 22:00:27.4896384','2025-09-18 23:00:27.4788901',NULL,N'::1',N''),
	 (N'3F2576B2-AFA9-49DB-A1BA-D98203DDCC6E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'k6Z2S/JwAaDsdcDD+BRd85hnc/M8l5X9s+8qCsMt31s=','2025-09-09 18:03:28.0354947','2025-09-09 19:03:28.0341700',NULL,N'::1',N''),
	 (N'58FDAB73-03E6-4AE5-9E17-D9EDA87F6D1B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/gm0RCKExSvUPHf4vYdZvPdyW63CH+TtBLqEzzo11YU=','2025-09-05 22:52:55.3475644','2025-09-05 23:52:55.3410164',NULL,N'::1',N''),
	 (N'CF29A62D-3B2F-4180-8FE7-DA1BD6B68C92',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N't7+oOqHcsWRjDrvfl55m0o9iW5soxyXkAcuwMt6A3ls=','2025-10-08 17:53:23.8222004','2025-10-08 18:53:23.7884904',NULL,N'::1',N''),
	 (N'1574E624-C34A-4777-974F-DA7B64DFB077',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6ciaH8j3XTsiz2i3R0JboiH/ct3xxI+PgrqkyYokiWk=','2025-09-17 21:10:39.5365338','2025-09-17 22:10:39.5351733',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'9A2F3B5F-7B2B-4622-818E-DB7CA61E8A1B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'1GA19bFGOtjG4tNG9KUMradMp6dkWiK2+oAYaNp7jnw=','2025-09-30 00:06:30.9970415','2025-09-30 01:06:30.9789851',NULL,N'::1',N''),
	 (N'B7312736-A338-466E-8BBA-DC0DCE94F55D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nmRYX9/zDWHmpzpModkqlBNhxAWc7vTOP7jEUw/Gs04=','2025-10-07 19:27:06.5417718','2025-10-07 20:27:06.5405721',NULL,N'::1',N''),
	 (N'80EB2E07-E2A2-4867-ACDF-DC124EC31C9C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'e0WtMhV+1HP5fEFbzeAHeVTednfuJLWhOABOIWPSKrs=','2025-09-17 16:32:55.7004493','2025-09-17 17:32:55.7001603',NULL,N'::1',N''),
	 (N'28D37A5D-9D9A-4A25-9F70-DC51F34A80E0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bZPLx8iaJXwaiv/qWRtgz7vSK82ikMf0Uo29I3rlFAo=','2025-09-08 21:40:08.1655593','2025-09-08 22:40:08.1550720',NULL,N'::1',N''),
	 (N'2B4B2DE8-E01D-4291-BFAE-DC6877AFB707',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'E/fkwqTzSZA1PhVtSvI1oWVu9S2yj+McctnOTC6Ce1g=','2025-10-01 21:35:19.8262226','2025-10-01 21:37:19.7976073',NULL,N'::1',N''),
	 (N'E2FDB0D4-0B2E-459B-A938-DC8875630EA9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wlraC/O3Xr01GWTUKWiXNx+woWYYpT/qx3jObtoBXKM=','2025-10-01 21:50:06.3822637','2025-10-01 21:52:06.3343513',NULL,N'::1',N''),
	 (N'3D8942A5-4905-45EC-9BAC-DC9063B07463',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0zp/Ud3dMYFi+ffSljpTMqB09TZWEG6tOz0i5RtZYuM=','2025-09-05 22:58:46.7339415','2025-09-05 23:58:46.7338817',NULL,N'::1',N''),
	 (N'1D289E21-6A16-4569-98CD-DCABD8E6D7EB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'JmQwTy1yYr6gvxv6Lfb2Yu+uE0qDZeRvAb/SR7hae9g=','2025-09-05 22:45:33.9490329','2025-09-05 23:45:33.9489097',NULL,N'::1',N''),
	 (N'2802315B-F187-4EC7-8160-DD2279745A90',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nqe0OoK/WXQKUWkTLj3KtLgzyT7zeG18VmSjxmnyi64=','2025-09-05 22:53:36.2338821','2025-09-05 23:53:36.2298291',NULL,N'::1',N''),
	 (N'C8C691BE-0EE2-4833-AACA-DD90469F12EA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'fdUX46XKmk1JKvtJRmli3U5Ewzd5lrYzVgTt2TYrbo8=','2025-09-16 19:50:50.4523684','2025-09-16 20:50:50.4332769',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'F1BAE117-0B21-4455-B4CD-DDAB859F650F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'v8rFkQOSIQP9PuiKo2i0OfY47H7hjso167xh9rIJTNA=','2025-10-01 21:38:11.0885109','2025-10-01 21:40:11.0568740',NULL,N'::1',N''),
	 (N'14AE1F82-69BF-4B6F-8B4D-DDB41DAAC91E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nBL/v/CyNOu7vPVj/pGGJ87MBBRRlUNVyGewtXzUBSA=','2025-09-22 23:05:58.5276592','2025-09-23 00:05:58.5262851',NULL,N'::1',N''),
	 (N'AFC440F7-7C4D-443D-87D3-DDD446D8084B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'C3+YrbLkGTfmh16F0GfqAoWohIgsrvnELE7mxp9MlSg=','2025-10-01 22:15:06.3772410','2025-10-01 22:17:06.3771096',NULL,N'::1',N''),
	 (N'870F9CDD-339E-4753-BC6A-DE02FEF8A3F4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+JQX4bSPPyFqcyU7ogvx4Ldxxf481/OqwfCWFkBZ/Gs=','2025-09-09 01:35:59.5530971','2025-09-09 02:35:59.5530224',NULL,N'::1',N''),
	 (N'C92251D0-F80D-4B5C-8FF0-DE264CC8BD1B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ZLbMfXFwcEH3bWXYWIU2yLE5ziOJ9ZLouCYpPu0mNUU=','2025-10-03 21:16:27.3523099','2025-10-03 21:18:27.3517227',NULL,N'::1',N''),
	 (N'2EA397F0-ABF9-4EEC-9FD3-DE4BB64109FC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'XK11PPmzLkXx2PSW3bJVh0dqoqicqe/1P+jEljPAsM4=','2025-10-03 19:45:51.4981826','2025-10-03 19:47:51.4980316',NULL,N'::1',N''),
	 (N'E72A8788-2701-4192-9A85-DE60A5930361',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'4hmUrRe0yFXIERMTWjr1wnq9Fha1H4fmKzcBZ6wg7qU=','2025-10-03 20:36:07.6746866','2025-10-03 20:38:07.6649990',NULL,N'::1',N''),
	 (N'EF230BF5-59F1-4776-B68B-DE84E62771DA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'k+2YGzwzlcnUEF29jq39nqTOvNvI/UYnqqBU5tELsuc=','2025-10-01 20:11:31.7322014','2025-10-01 20:13:31.6774448',NULL,N'::1',N''),
	 (N'B7E36866-2FCC-4D3F-A726-DE8DC6AE6751',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'YC0mnz49zAJ2ON2wGuKb3HmZJqMsf2PvqtphLzg87zU=','2025-10-08 20:35:08.0623535','2025-10-08 21:35:08.0622717',NULL,N'::1',N''),
	 (N'8CC83EBD-FD4E-45DE-A8BA-DEAD1D0D9B13',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'w90kyPjzCwt204OAjXx+YlU5j4bpDkKRBvHBc71XX2Y=','2025-10-03 20:28:56.4875790','2025-10-03 20:30:56.4874707',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'91C981AF-926E-4EE0-B475-DEDD3C6BEEB9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+/19PdwAOWk9DbKaDeHH/BVpYma8Sj8Th+KgZfJ/krM=','2025-09-30 20:14:22.9292737','2025-09-30 20:16:22.9291914',NULL,N'::1',N''),
	 (N'DEA8B41E-093A-4978-A35D-DF178E45EA61',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'h6HU9p3wD3ax7YjyZ9p4DzT4RhTQbXlb7xftm8QoI/A=','2025-09-30 20:12:42.7531370','2025-09-30 20:14:42.7374714',NULL,N'::1',N''),
	 (N'9FD45FD5-4101-443E-97DB-E024D58A4031',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WnYllteKiIRdVqU6mB7vpI/pLzGg+by9TozxpHSTw+M=','2025-10-07 18:58:33.5346070','2025-10-07 19:00:33.5345525',NULL,N'::1',N''),
	 (N'9161D73E-3389-4F34-8252-E08C09D7866E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hlWuMAkty4fr5omXPmWoH61J5RkhrEJMXE+5iBzOu78=','2025-10-03 21:01:26.0781621','2025-10-03 21:03:26.0720587',NULL,N'::1',N''),
	 (N'90E4A8DA-9E24-4421-B7BC-E0942621E557',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'PtWmC4/NsZR65jKVeKVe9fC3hEFrGjXtayDKEqHWAP0=','2025-09-05 22:52:55.0769368','2025-09-05 23:52:55.0473084',NULL,N'::1',N''),
	 (N'85CC6CBB-3D5B-49CD-8E00-E0B3DF7024FC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6Cm9VGZLy188O+pye2epmXQeYCi9vI2LCyPopK0cU4E=','2025-09-17 16:27:29.0826507','2025-09-17 17:27:29.0743879',NULL,N'::1',N''),
	 (N'6EA161C9-F458-4C46-8EFC-E0E6CC5079A4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'aK4ntvGZsuRw1HLGYJIQ1dCIa44PD0cVyK8a56i5oEM=','2025-09-10 18:27:38.4196015','2025-09-10 19:27:38.4193467',NULL,N'::1',N''),
	 (N'03E55C9B-F76E-49DC-9745-E0FEBDAA0A21',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'n33+YHs1T0QDBOK4u2iEDE869SU9W3/C4SaJDlK+g5c=','2025-09-16 18:30:41.8457126','2025-09-16 19:30:41.8344838',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'94CEFD1D-A771-475E-87A2-E13B738F845B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Lx4AvpHDVxhAI0WD8ANkRBaTJLMZ1mUs3FVn8ZUQCQs=','2025-10-01 21:57:44.7265725','2025-10-01 21:59:44.7265321',NULL,N'::1',N''),
	 (N'BF821D00-6D2D-42E9-B8AD-E13EC21520DB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'sVkqQgoO+kRktBQDFTKeFV2kYjOIgXk4sJRigPlPg0s=','2025-10-01 21:20:34.8946809','2025-10-01 21:22:34.8945331',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'7877E4B4-DE00-460B-A09C-E17978100EAC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'nvJFa5Pe7OSf6I24S5e40Dwo9TpoxWfISs95rLfixwk=','2025-10-03 21:11:00.2629490','2025-10-03 21:13:00.2625938',NULL,N'::1',N''),
	 (N'C53E0DCE-5F62-4874-A24B-E18F6D80DD89',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'mZUQcF2LaIJswDS5Z2My4AvfehmLdUcJoWaFhY7rDG0=','2025-10-03 19:20:37.3315317','2025-10-03 19:22:37.1488771',NULL,N'::1',N''),
	 (N'0FB30057-6D72-4ECB-B3BE-E1B5281C407C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/DfXjG1NKJscnohgoqZ1XA0yOXxtLxksR7mSeJdDlZM=','2025-10-03 21:20:27.1506242','2025-10-03 21:22:27.0816108',NULL,N'::1',N''),
	 (N'9CC58B4E-4EB6-4CF8-96D3-E1D34BDD8293',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'aBzRbpK5fTNHQzJt6HdjUrfp84sGE5jut0R7rNUIucs=','2025-10-03 21:11:28.1366414','2025-10-03 21:13:28.1363767',NULL,N'::1',N''),
	 (N'11EE1AD2-F8AB-4C19-A378-E1E24C96ECAE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1jOEJwY5plW4vL4BR16CxzBCugFlnybt4hNuIYKUZ58=','2025-10-03 20:27:58.7132005','2025-10-03 20:29:58.7028800',NULL,N'::1',N''),
	 (N'A0DCF5E7-7BF6-464A-B7B0-E27456C514E1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'aEJzXXXxTz4UFB6QysiMKD0gY1MJ2Scd/rFGp91wG18=','2025-09-08 21:28:24.6270181','2025-09-08 22:28:24.5739336',NULL,N'::1',N''),
	 (N'0099E667-CE77-43BD-8AC1-E2E879BC7930',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'GP9b4G/KO8qrEPRyBI8I2RGBbKOJhSHMeuaa2w1qP14=','2025-09-05 22:44:05.6203069','2025-09-05 23:44:05.5197143',NULL,N'::1',N''),
	 (N'6C117E4B-BB0F-4C03-BE82-E31957C90BFC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7EqZHvY/9In5Jp/El8VRLWg71HPAXFwPcUxQNWxwiHo=','2025-10-01 21:28:40.3967645','2025-10-01 21:30:40.3800713',NULL,N'::1',N''),
	 (N'82D5AB11-50EF-4161-B9C5-E31BBF4EE40F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'MTMsjbHlNbZXLhvD2ftvZUTnbkc7DQ6/wtT8sRRa+rw=','2025-09-24 23:24:37.7222507','2025-09-25 00:24:37.7069780',NULL,N'::1',N''),
	 (N'7BA688FD-7E6C-4F59-B40D-E368E6F7FC90',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Cr1DsAXXIcBr6D9N7dpHvC80gZ9b8YXJpt5RCy09E18=','2025-09-17 19:48:51.2691986','2025-09-17 20:48:51.2586744',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'3F3ED048-D775-4603-8DEF-E3841244AB58',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'i7GTSVsrLR50B4HLGagKwHjYSzI84fVy5K5OtCRk9fo=','2025-10-08 20:22:50.7737598','2025-10-08 21:22:50.7736967',NULL,N'::1',N''),
	 (N'6FB2C0B4-5B2A-4FAA-8AF4-E4279BD8EE72',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'SO2OR9YCliFEtwZXKmlrysuxB6DaYNAAk00qJQNVZz4=','2025-10-07 18:20:34.2590714','2025-10-07 19:20:34.2590121',NULL,N'::1',N''),
	 (N'87917B97-34D3-4C99-B1E0-E440579AA95F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'3eTuPmj0lioUF2zuxScCxKDO22hNYpSy9PpZ2dmoD3Y=','2025-09-16 21:55:26.9058361','2025-09-16 22:55:26.9043353',NULL,N'::1',N''),
	 (N'72A40FD0-761C-42BA-956C-E44EDEF9EE48',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'skpWvfpBHUiFPOT6yY39jdKVKZEoZRQsUOi85aRC+dA=','2025-09-09 17:33:22.9787953','2025-09-09 18:33:22.9574629',NULL,N'::1',N''),
	 (N'7693CFBD-B5BF-44BB-9E30-E481E74F3637',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N't4Vl1UWCuRYdigJWxhtjKqAZkqqd2wM20mAHOEH9nhc=','2025-09-17 16:12:43.2154295','2025-09-17 17:12:43.2139451',NULL,N'::1',N''),
	 (N'2A8C5E54-F4B4-4AEF-B362-E4C6DE57CF84',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'vvJtYRx6BY53lBRptha10EktPf25kLjknRw8HJT8nlk=','2025-10-01 20:11:28.1450263','2025-10-01 20:13:28.1447357',NULL,N'::1',N''),
	 (N'9EB7B09A-E309-4247-85E1-E51DED39874A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'b6Yt13JKQeBbyYiY9YzF8vNj2ds0jmFb42cToM9WzYA=','2025-10-09 16:43:38.1545240','2025-10-09 17:43:38.1430532',NULL,N'::1',N''),
	 (N'5E245537-0FF5-4AD5-BD73-E571C5FCFFD3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GE1dX3ba/ToPjAN9attlqzKUsAbxfjPA0hQcIqlbroM=','2025-10-01 22:00:21.2466420','2025-10-01 22:02:21.2406752',NULL,N'::1',N''),
	 (N'6B579C43-0B89-42E2-BE43-E61598BC3EE0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+XfcIdxtNhkF7kXPthQqBji53RfjBbmPsqwfks5EdZ0=','2025-09-23 20:37:22.2627402','2025-09-23 21:37:22.2215350',NULL,N'::1',N''),
	 (N'52D198A5-6A1C-4861-9FD2-E64F900E75BB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'N0Y2udK7rqINgnfCcR2Uq6gj8cCgrsgUnacYNgLsn0w=','2025-10-07 19:12:44.5828827','2025-10-07 19:14:44.5828407',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'BB086EB1-6562-47C0-BC0C-E68BF9947A73',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'SMoe1lhbbxLzJ14FqQOVGVX1eEsF4S4mwoXZEqVVT8M=','2025-10-03 19:38:53.2569322','2025-10-03 19:40:53.0820698',NULL,N'::1',N''),
	 (N'885E4EAB-8753-41BC-8FA0-E6E3CF4C4063',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'i500+jw0rITbchMvPU2q2pe3nl6KjSrns4uBDjlKn5U=','2025-10-07 18:59:42.7897949','2025-10-07 19:01:42.7889600',NULL,N'::1',N''),
	 (N'5573B799-8EE8-4BA4-8F92-E715FC88B419',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dX8Rju1wY9MFR4il6YPvHkBtuWP6dppPtH/ROoQhJ6k=','2025-09-29 21:54:35.7950239','2025-09-29 22:54:35.7876738',NULL,N'::1',N''),
	 (N'FC74811C-4F66-411D-AA60-E74EB9035705',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Uz/X4+hdKUp/O0ZuXMgpgfbxIWeVCrYBttExdb4vbmY=','2025-10-06 19:32:57.7721041','2025-10-06 19:34:57.7563755',NULL,N'::1',N''),
	 (N'6F967D1F-728A-47D1-9466-E7599727302F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1IE8N4zPmYx52Azj89oTJ3I3USpF1FcqlHOoXVSCBLA=','2025-09-23 23:06:39.7089691','2025-09-24 00:06:39.6980608',NULL,N'::1',N''),
	 (N'3B100573-8A7E-4D10-ACC7-E7626A797AA8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'm6dQnk9meSQ3Fj/vJLi+7U1qcefNzh0Td6mhbWCcsEw=','2025-09-24 22:21:13.2706308','2025-09-24 23:21:13.2601945',NULL,N'::1',N''),
	 (N'9D54FE3B-747E-4B56-B4DD-E7845B1690E6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'xnSz5HYmu5xXImkecIAABZhLG1XuZ93Qkjew1LzGliI=','2025-10-03 21:09:19.5192071','2025-10-03 21:11:19.5104261',NULL,N'::1',N''),
	 (N'14184D83-65C0-423E-8509-E78B5688535C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'zhTJsuQXBBxrwxS8Pt/YiYIQo1hKds2AC0hXEwsG4o8=','2025-09-05 21:59:40.0162959','2025-09-05 22:59:40.0093954',NULL,N'::1',N''),
	 (N'19147AD2-F654-4140-9013-E7C08B721AFF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'chCf/4Rt3z/W9Hjo9Wqvt+rVGYvunwCvQPdroY71JvI=','2025-10-01 21:27:48.9789514','2025-10-01 21:29:48.9787827',NULL,N'::1',N''),
	 (N'1888A796-4894-46CB-8F93-E7E8A57434CD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'y0Ig7Dc27wvns/wdKlH+218Uc0FM+5QN2l/kK8G4QOM=','2025-10-06 19:47:20.0812459','2025-10-06 19:49:20.0598098',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'C52C7014-CBB4-427A-B2B9-E7F3E835CDC7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'AuwX2ug5RSWeL7iqiZwsDCtTcpuYSdLCL7aNlBq3MUM=','2025-10-01 21:50:14.2127882','2025-10-01 21:52:14.2117016',NULL,N'::1',N''),
	 (N'EBD8F4D9-A3E6-4D2E-8559-E859AD2E6C9F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Rrci1Y6VfE2fFtIuv7IxBnL9yGxSdrigWKpbg1woWqk=','2025-09-18 21:59:10.4802431','2025-09-18 22:59:10.4801382',NULL,N'::1',N''),
	 (N'5600CC63-3E24-47F2-80AB-E8B8E7C1E89C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'sVkqQgoO+kRktBQDFTKeFV2kYjOIgXk4sJRigPlPg0s=','2025-10-01 21:20:37.1663711','2025-10-01 21:22:37.1663117',NULL,N'::1',N''),
	 (N'E603AF9F-1FEA-4821-95E1-E8D6BB67CCF1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'CFfnF5ixuQ6syOEgart4Ixr8Ju2v/82KIl/WQEHo16M=','2025-09-18 17:43:36.1700465','2025-09-18 18:43:36.0029084',NULL,N'::1',N''),
	 (N'5A4934FE-D21C-4FDE-B0CF-E8F9B681E236',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'MgOrlSuGHXlowYBqSoUO1i+A70zLNNT0zqpOQ74YjQM=','2025-10-03 20:50:59.3083628','2025-10-03 20:52:59.3083153',NULL,N'::1',N''),
	 (N'D2474B1C-10FF-4EC7-994A-E9A22E4713CB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zMO4A5hv/JcnFAM6x9u0UQr977Sicahm6MA637o0sh0=','2025-09-08 20:34:32.6746175','2025-09-08 21:34:32.6745505',NULL,N'::1',N''),
	 (N'FA89AB9E-34F7-40A6-963F-E9C2F5212712',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'/dU+7+ZsUHvyject2eXPaXOX7aKF74VTnw0BCxHFfPQ=','2025-09-05 22:40:13.6615008','2025-09-05 23:40:13.6606117',NULL,N'::1',N''),
	 (N'E3D32861-860E-4C52-AFCD-E9DD855F74B7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'eisBPtsdjrZ8N9x97zw/jAeodOIP6HpEIBJErjZ5vng=','2025-10-08 20:09:32.0498546','2025-10-08 21:09:32.0495900',NULL,N'::1',N''),
	 (N'70FD93A2-EF4F-4810-A9E5-EA839D049A03',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'GSE1IXWaoaWSk/Kyfav0V9N5ulEuvddUYCH3YC+XLbI=','2025-10-01 22:32:38.8639138','2025-10-01 22:34:38.8637548',NULL,N'::1',N''),
	 (N'769F908B-6DB1-4252-BF62-EA99B527CC01',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IB+epnG7s7Uo8crDSG/1JiL1Ah6qMd4U7zRHAfel1jg=','2025-10-03 20:10:33.3119529','2025-10-03 20:12:33.3119031',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'145B394D-57AF-49CA-8C1F-EAD1D85FA779',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'fv5RQFtmhmXnVZ6CT4OIXn6CLeBHyBGSKO3pgNLlKMY=','2025-10-01 19:49:50.3380124','2025-10-01 19:51:50.3375484',NULL,N'::1',N''),
	 (N'5BD13546-8206-4C3E-A4C4-EB0BDBD97A3D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0H+Uh9I4GStrJhZRPjiOmzyjfp5QFwy/nTfwisXpN/0=','2025-09-30 20:03:06.4103592','2025-09-30 20:05:06.4102767',NULL,N'::1',N''),
	 (N'38DCE597-EA48-4583-9606-EB4389BBD450',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'j+4ooazBY6EjCOR9f8CWJcSQm1Ghv+dygquIbmUUVF0=','2025-09-30 19:21:51.1021166','2025-09-30 19:23:51.1018375',NULL,N'::1',N''),
	 (N'7F6AFB48-123C-49BA-B514-EB7CBD94B5DD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7PJfq8x8vqS5qOVtweW5TFMYopGeAWsdNgz2FxG507c=','2025-09-30 00:06:31.3882495','2025-09-30 01:06:31.3771960',NULL,N'::1',N''),
	 (N'1F276A7A-6BA2-47D5-ACD2-EBEE890628FE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'iO2TFbQbh+q50UBvBvzbwNrI8iH4WwNo6XrJTVIVt4k=','2025-10-03 20:45:36.8049308','2025-10-03 20:47:36.7749296',NULL,N'::1',N''),
	 (N'B5DF2EA0-5C6F-460A-9E12-EC119E3A02EB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IConER1O/6+EHDLGW2H4QV90izNeWUThL4quYmcgzxA=','2025-09-17 21:04:44.9632842','2025-09-17 22:04:44.9621350',NULL,N'::1',N''),
	 (N'1455FE70-5FA9-4469-9964-EC2F9D22B912',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'j0TvaFhNN+gfs53unPZVUgrozOeb4cwDrsxWwwKprsU=','2025-10-01 21:52:37.8396997','2025-10-01 21:54:37.8395677',NULL,N'::1',N''),
	 (N'70D05AF6-0AA3-4466-874C-EC6DCC294556',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7tHgWSO6fQAOXLD+Eml/9LsyCkSoi5JR5IYnxB9K/dk=','2025-10-03 19:39:10.0381435','2025-10-03 19:41:10.0380736',NULL,N'::1',N''),
	 (N'6075B3FB-D994-4D6E-881B-ED4070730710',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Ii0p7e7xfrHR2fFFmqAdS9z4Zgq5C8lN7dz5yp73koo=','2025-09-10 19:43:44.3888621','2025-09-10 20:43:44.3590083',NULL,N'::1',N''),
	 (N'DE1073D2-B925-4E48-AF2A-ED8D92485BBB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'nCd1AfTa2Ilo5snmdNz4PXy8QNXrta2381egVTt2QH0=','2025-09-24 21:49:24.1570743','2025-09-24 22:49:24.1054617',NULL,N'::1',N'PostmanRuntime/7.44.1');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'E86A5521-E41B-4EA4-B0E4-EDB952458564',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'S1bhGNXd6o9nyCc+Zy2rNx3qa0aasVov6BSAMvKiE/g=','2025-10-01 21:28:35.8726373','2025-10-01 21:30:35.8723738',NULL,N'::1',N''),
	 (N'108CAE82-09B2-4F67-A81D-EE142875493F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'w90kyPjzCwt204OAjXx+YlU5j4bpDkKRBvHBc71XX2Y=','2025-10-03 20:28:56.4037428','2025-10-03 20:30:56.4035671',NULL,N'::1',N''),
	 (N'B23A532B-AA1E-43AB-AB04-EE3BA6291368',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'CXfCzNi7yS9Bl7RPw50+88+eqY58l8Sea8XBaPGk/r0=','2025-10-09 18:39:17.6846242','2025-10-09 19:39:17.6832395',NULL,N'::1',N''),
	 (N'0CB43466-09BB-41B7-B850-EE3FC26C23BD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'VgIK2F9u4mY3iglGyX9ZQCBwP1PrP0BalaUkAoudSJU=','2025-10-07 23:41:33.6860516','2025-10-08 00:41:33.6858299',NULL,N'::1',N''),
	 (N'1C5773A6-9A55-4484-A9CE-EE5FCBE55537',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uFdLo/eNjW/sY2z4v7C4QNeTtXycMV3hRn0P94hCL3M=','2025-09-09 00:53:36.0677376','2025-09-09 01:53:36.0604308',NULL,N'::1',N''),
	 (N'3D529A70-EDF2-4F05-8C29-EE6965205656',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/PPYYS0kVm2u6EH9+lAXQuCv2PvyHSZDGVlHY2SvEwI=','2025-10-03 19:42:46.3891923','2025-10-03 19:44:46.3793316',NULL,N'::1',N''),
	 (N'1A570FBC-8B64-469C-92DD-EE718B39E569',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'x6onlK5guAflNw4r2avJK5JYmU//7ZUb41TGLuhVkH0=','2025-10-03 20:51:35.9758075','2025-10-03 20:53:35.9756889',NULL,N'::1',N''),
	 (N'C6FBA0AE-3BEF-4142-872D-EEF570379B01',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'SQl3RjOShsLDygOwShQLGCKLQZueD2CGwonEkux+NXE=','2025-09-09 03:32:04.8103998','2025-09-09 04:32:04.7644497',NULL,N'::1',N''),
	 (N'F1E6A89A-20EA-47B5-A652-EF236807FD1F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'YDPL7eH3H7Bu50AOemqfmLOX35M/q2hF46HhdG8ISIg=','2025-10-03 20:03:45.7947592','2025-10-03 20:05:45.7947062',NULL,N'::1',N''),
	 (N'55A2B1E8-1745-457D-97B1-EF370256F04A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'42abDMINrPeLMJo5bYVfQhK11Bs3flINkHNBWKV5gu0=','2025-09-30 19:54:34.0563858','2025-09-30 19:56:34.0560585',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'B7177737-A2C9-4025-A8F1-EF64A91DA425',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'j4FypwnqMwPGhmiHm+7Ii0n96rzKFAO/og3NwOjFqMI=','2025-10-06 19:35:23.8106632','2025-10-06 19:37:23.7559005',NULL,N'::1',N''),
	 (N'52B5A3B1-3D24-4054-B1EB-EF66DD621161',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'nmRYX9/zDWHmpzpModkqlBNhxAWc7vTOP7jEUw/Gs04=','2025-10-07 19:27:06.2265122','2025-10-07 20:27:06.2147845',NULL,N'::1',N''),
	 (N'CFFF85F4-4F09-4A35-A4F8-EFAB82758D50',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'MYshHLErTQ4b2592dOat63wfXfHYKoqX3lgapUCMvXA=','2025-09-16 19:56:56.7750112','2025-09-16 20:56:56.7595632',NULL,N'::1',N''),
	 (N'01CB9A58-CA6D-430C-9AD2-EFCBAEDCEB43',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GoRitJMJSUdUWnjiASoFURyImi1PgLTw8DmA2Gbf2ZU=','2025-10-01 22:15:11.7264603','2025-10-01 22:17:11.7114480',NULL,N'::1',N''),
	 (N'07C6B91F-98BB-4520-A6C1-EFD22215164F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'SDQbSk17L72pd0cBKctHN94jgEX2dCww8etJ7D30Ez4=','2025-09-22 22:46:17.0732874','2025-09-22 23:46:17.0730266',NULL,N'::1',N''),
	 (N'C6C66777-1642-4F3C-8C42-EFD2B8C351BB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zd1ceunPb5+4vbHmV0sQoJdcsYJ6d4GCosYVzAbokvM=','2025-09-09 17:52:55.2810485','2025-09-09 18:52:55.2809805',NULL,N'::1',N''),
	 (N'CACBDCA2-990C-478F-BB1A-F06E4DB3C6F8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KO9xPTyVxPbfn8eqND4qkd90w/u6sbwOENeHEH5KZGw=','2025-10-01 22:00:54.3279640','2025-10-01 22:02:54.2839369',NULL,N'::1',N''),
	 (N'A3504C03-870F-4666-8F9B-F090726DB27A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'PoLarHelMC4v4tBYh+VZyZViMIniR8LFwzD3exOZrkw=','2025-09-24 23:48:00.3528520','2025-09-25 00:48:00.3414020',NULL,N'::1',N''),
	 (N'9B773F5A-3731-4D07-8D29-F0D88E840690',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'vn1vQNX86E9TfXn65K5Bu3oGmxOfyRFlttEPgZBeCxA=','2025-09-17 19:48:50.8693162','2025-09-17 20:48:50.8539791',NULL,N'::1',N''),
	 (N'64892A7B-A7DC-4E8D-B19A-F0D916014AF7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'H+hbvs2qH01tCfqbJsP6cGNhADkLpg9Mo0ALIb/jHCE=','2025-09-17 01:14:48.1418957','2025-09-17 02:14:48.1404610',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'7BAC90D2-F928-4E03-9FF0-F10CB8AAECEE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ozWGHUFcnF6cEHnj9AtfQz5Md6may+Xuqaw416JdaAg=','2025-09-18 22:01:40.1336565','2025-09-18 23:01:40.1333982',NULL,N'::1',N''),
	 (N'03CA777C-A748-4A51-8ECC-F10D9B90FBC8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'n4C5/lkkGocLDAT8Rv7FfHvkWKoDYys6CGQHF9CRiN8=','2025-10-01 21:48:00.9226128','2025-10-01 21:50:00.9225669',NULL,N'::1',N''),
	 (N'8416B7BE-F89D-4144-9327-F138A02EAF30',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'V0DvcQKW+htI7Pc8jC40p5Zhn09fWi7W1LyW1JDPEAQ=','2025-10-03 19:47:05.8964947','2025-10-03 19:49:05.8962961',NULL,N'::1',N''),
	 (N'DD033020-8B60-403F-A666-F150F5820D29',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9Zfsz/H+z3sIorz9kREsUrnGcTrtVuKSaoB4/pPLRf8=','2025-09-24 21:53:15.9811523','2025-09-24 22:53:15.9809204',NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'9B4745B7-C3B0-4019-8105-F169FE4853DD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'hfMW8sNczrNDzfOdFGVK84FhyECoP5mtO6Hfv6GTJPU=','2025-10-03 20:34:13.3014980','2025-10-03 20:36:13.3013750',NULL,N'::1',N''),
	 (N'7662DC1C-89B2-4A25-9A30-F1B08B1C0088',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'Ur3UnUTOARiftr6CwVnH2BnCyUUJPFdb02LREcvowTc=','2025-09-05 22:46:34.3285363','2025-09-05 23:46:34.3282735',NULL,N'::1',N''),
	 (N'554E4F83-09A8-4282-8FF0-F21E73CFBBF8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'f7/ubvGRWa+s3/AM/aJszoeYx+j4TaoAMCbi03EkFks=','2025-10-01 22:39:43.0092077','2025-10-01 22:41:43.0091228',NULL,N'::1',N''),
	 (N'79937283-E535-4B2A-AB49-F23E042AE971',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'y9YPpAQy+5xzXKKAl817S3mTuOn7CB9xDi+9wfXs+RA=','2025-09-30 20:04:47.9779639','2025-09-30 20:06:47.9779199',NULL,N'::1',N''),
	 (N'2072B1AF-7978-4CBF-9CC0-F2834C8658EC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'sNYX6Fp894v+xsR1ZGSJ9M49ER4dlMSrewW6N9n/R4A=','2025-09-18 23:19:31.8401816','2025-09-19 00:19:31.8391338',NULL,N'::1',N''),
	 (N'B607B835-08F2-424A-9CFA-F283F4A7F690',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'45tXcHorR+fLkxvbg7wIsoimWFa8OtQMyyycM5foeFs=','2025-10-03 21:11:00.2895575','2025-10-03 21:13:00.2812011',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'4B3BDD03-5EBB-48B2-A9C3-F314106BC2F2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ObOH9mFz+b+ZHf8q+MBtF7UGs7BQvswBzSfRHCWPRM0=','2025-09-17 16:39:15.9201531','2025-09-17 17:39:15.9113695',NULL,N'::1',N''),
	 (N'C70E0120-8A7D-402A-8B74-F3E078E0683D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'QyXD8gHZqKXq9u+Hi/NkFB5/smVjyUTGR8TWqrOlI5s=','2025-09-05 22:40:31.9923932','2025-09-05 23:40:26.4990697',NULL,N'::1',N''),
	 (N'56941772-8366-4DB8-868B-F3F4F253EBD7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kEMejNS25tN9lyXEUMIoavpUbO9gdY2oUFVCeO2BoI0=','2025-09-09 17:43:54.1960559','2025-09-09 18:43:54.1959610',NULL,N'::1',N''),
	 (N'30AD1D2A-4E76-40EC-8A51-F423D897309E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'DqvdBK3r4BaXYeq64ANHgfK6l0h1cjWa/xYyefw6G1A=','2025-10-06 19:32:57.7581589','2025-10-06 19:34:57.7563755',NULL,N'::1',N''),
	 (N'8AFA806A-1F2B-4530-91DE-F42DFDC64F30',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/VWTw4EB3XPNPxNyq6ZTFfFM4TWv4T0IgrGgomd5Fp8=','2025-09-29 22:29:28.2899622','2025-09-29 23:29:28.2898847',NULL,N'::1',N''),
	 (N'D91AC811-A160-4DF0-8F8A-F43BC93B1C51',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'gRXf02/cABma0EQiC9xS+m+yyEssPS2Oc+v7u4/n4vY=','2025-09-09 01:44:24.3753581','2025-09-09 02:44:24.3653782',NULL,N'::1',N''),
	 (N'745645FD-74EC-48DE-A1BA-F470EB199D6E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'V6rOzl+wywqKNJtm49K7Nj40+jtGiHzsdXVdqSajgDc=','2025-10-07 18:46:52.7528499','2025-10-07 18:48:52.7527945',NULL,N'::1',N''),
	 (N'C8728106-D791-40C2-8B08-F476DB54C728',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lLSqEup3r0OfhyxpHP80wKGEhGSxDwx8cjpgJaQWPho=','2025-09-22 21:30:48.4274341','2025-09-22 22:30:48.3832816',NULL,N'::1',N''),
	 (N'2936C5EE-E72A-4C64-9AF9-F4E266FEEEE1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ge08L30+pNmCXWwsydUJnO+8lv51/nb+vON+7EpUxpE=','2025-09-09 01:44:24.0899036','2025-09-09 02:44:24.0436238',NULL,N'::1',N''),
	 (N'7B2CD7FA-45B1-4616-9778-F53346A5BE47',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'54Ey/N6H8qVf5w0QgXKWj4JsBwmcEvhFLAERZD71ddo=','2025-09-22 20:14:47.7198318','2025-09-22 21:14:47.7118195',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'B2239A49-E789-48B5-962D-F5E02D89615D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'MdldEoRfpMe0jT4uzxpBtsWMyJSjLswUaRH1Skj1X3I=','2025-10-01 19:46:16.3554519','2025-10-01 19:48:16.3220035',NULL,N'::1',N''),
	 (N'8547636F-4761-4E3D-9ADD-F61D40D6A513',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'IConER1O/6+EHDLGW2H4QV90izNeWUThL4quYmcgzxA=','2025-09-17 21:04:44.6516085','2025-09-17 22:04:44.6370615',NULL,N'::1',N''),
	 (N'00BDB8E7-1D1C-4F9D-B437-F66480DBCE7A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'xuYL/hCtt+MmjSyjhivfjgsbNuEkPCZo8glV6sqbM3U=','2025-10-07 17:37:21.4556228','2025-10-07 18:37:21.4513319',NULL,N'::1',N''),
	 (N'591A637F-B2A1-49D9-B43D-F6787CFAD910',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wyXbA2yFTvy/bUFByYef5qusQMJ6YISKtDi3QizTrDA=','2025-10-08 20:09:32.6707809','2025-10-08 21:09:32.6084461',NULL,N'::1',N''),
	 (N'30BB90B6-6204-4E13-9861-F69904AAFF72',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'8O2WSJALtCdTKxh1We1wEhsBEExLtSbTUdYiKOs2egk=','2025-09-23 21:06:37.2312196','2025-09-23 22:06:37.2171131',NULL,N'::1',N''),
	 (N'927A2702-AD44-4872-BFD3-F6ADD80C1048',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'KzjEoKNiPjYogaTu9K6ckmG979ygdko05omzYRcwIuQ=','2025-10-07 18:20:11.7224509','2025-10-07 19:20:11.5958470',NULL,N'::1',N''),
	 (N'7FD3E736-3CCF-46B4-8BC5-F6B85A9384D4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dIICmJk38ljjuipNbD4eiI94uTW9iEGb5RgsbpI+fXo=','2025-09-17 20:05:35.6937963','2025-09-17 21:05:35.6937229',NULL,N'::1',N''),
	 (N'5F1773F1-892B-4E44-AED6-F71B84B7F271',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'DqvdBK3r4BaXYeq64ANHgfK6l0h1cjWa/xYyefw6G1A=','2025-10-06 19:32:57.1489240','2025-10-06 19:34:56.9604969',NULL,N'::1',N''),
	 (N'766BDB28-7C23-40F9-B255-F75C8EA8AABC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'rkaqlh8jjztK9ml6D7E1mDH4C/JNKQDMETA+vrfgdJY=','2025-09-30 19:38:44.9327788','2025-09-30 19:40:44.9326113',NULL,N'::1',N''),
	 (N'D40616BD-FA66-4964-BC0D-F75EE927D54E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KZ7fWK9LtNmTpSrDlaEOUXZ+11ufFQwH2faVFcccW/Y=','2025-09-17 02:08:36.6334457','2025-09-17 03:08:36.6180708',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'A6D7841E-D178-4B79-82F5-F78D710D2CAC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'XK11PPmzLkXx2PSW3bJVh0dqoqicqe/1P+jEljPAsM4=','2025-10-03 19:45:51.4025339','2025-10-03 19:47:51.4010266',NULL,N'::1',N''),
	 (N'461ED5E2-C5C4-4D63-9FBC-F7BD4B2AFE9E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'RjeaXYbgZCjJWnj1SgtJg+PQiHml7Ef5jPJAun3a3ms=','2025-10-08 18:18:11.6710444','2025-10-08 19:18:11.6527693',NULL,N'::1',N''),
	 (N'88A9C7FD-27BF-47EA-ADE1-F804FBBF4BF0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WBFv4fNYp12yrYGEMfCE3OKbvGJBHgQGvXmpauOBHLA=','2025-10-08 18:18:13.1390512','2025-10-08 19:18:13.0821649',NULL,N'::1',N''),
	 (N'D0FDC19F-905F-44F0-BB1B-F83194EC68AD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kwM3NnoaxFKEw85SQm5/Y6Ab3JQgk8iucfXr+iT1hUo=','2025-10-07 19:13:57.1383113','2025-10-07 19:15:57.1382736',NULL,N'::1',N''),
	 (N'0E640E2E-0148-42C0-90F5-F85E5D87B772',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'NtYOk0LWDb5KkridAYZc5NOAJ1YHjxT834/KHRi+opk=','2025-09-09 00:54:22.0457405','2025-09-09 01:54:22.0350448',NULL,N'::1',N''),
	 (N'DE857D51-30B2-4D5A-AABD-F93807C9256A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'PhhS3IKUeJUhQtNc58QQKz9anbqs2BcbrVIQZtFc+ww=','2025-09-18 22:20:31.5243791','2025-09-18 23:20:31.5123966',NULL,N'::1',N''),
	 (N'ACBE87FC-B4D6-4A04-B3A2-F9CCC85092C6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'c0BwQHA93XuOTlLWE+Q7gPLraOLSJn03Wg3MIkT95ms=','2025-10-01 20:33:03.9702691','2025-10-01 20:35:03.9260147',NULL,N'::1',N''),
	 (N'B1B13723-60BE-4403-B577-F9D2552BC0F2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'etYksMlXeYLryKgcY4M07jdrvpoKcnoiaLt6vcEyYyk=','2025-09-18 21:58:57.3850198','2025-09-18 22:58:57.3780485',NULL,N'::1',N''),
	 (N'5AA9F052-6AF4-45C2-AA62-FA4213F7E7AF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'psuibhZ/HfPm09NedG0KZs1FCIAMDtxmAgGWgukesuI=','2025-09-24 22:21:12.9166526','2025-09-24 23:21:12.9020630',NULL,N'::1',N''),
	 (N'FEF0292F-90DD-4817-A466-FA84C87F7BF4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'enIl9++nmA5frhaZU0Swn4nbZjydDWFAkcMl0XWROyQ=','2025-09-17 17:47:17.9541316','2025-09-17 18:47:17.9401440',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'EA5F906B-7D86-4DAB-A1C0-FAAE84F07B4E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'HAxvYbjVetEozUkVc6yWo0HWxzt/eWbdMBaU1SHRLr8=','2025-09-09 18:03:28.0449820','2025-09-09 19:03:28.0341700',NULL,N'::1',N''),
	 (N'F78FD35E-210D-4A92-AD95-FB2050BCCF78',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'75vfRMJZc2Di2+CIeQ9nwuM8nB9XXyx/mSOdeJ9PGaA=','2025-09-17 01:33:40.8878151','2025-09-17 02:33:40.8864423',NULL,N'::1',N''),
	 (N'D2F9459D-4379-43D2-A3A9-FB7E922FCBA3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nmH5BluqRp58GvwrUdo/FB7PkgT2WRdUdepm+ssIexg=','2025-09-19 00:27:55.5776059','2025-09-19 01:27:55.5675181',NULL,N'::1',N''),
	 (N'EFC566C9-EF4A-44BD-B44B-FBB22BC9FF8E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'QW8gQRoDFIs5I3iWHn3MQOhJ/kq8wwJVu1iWG932jHs=','2025-09-30 19:58:49.6312716','2025-09-30 20:00:49.6311987',NULL,N'::1',N''),
	 (N'88BD8A90-0D9F-4164-9130-FBC19DFB0941',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'TzF9sguSFUJQj2LdN69f4/so8CaOabzPUHiGTvtdGEY=','2025-10-08 20:43:04.5790668','2025-10-08 21:43:04.5650264',NULL,N'::1',N''),
	 (N'C125C4D1-5BEB-4F74-AEA3-FC0B4FFCD014',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'BP4zJLc5tLKR/mBt/1YWEHpdNwa7MACV0PO2mWK7ujU=','2025-10-01 22:18:46.4387014','2025-10-01 22:20:46.4385679',NULL,N'::1',N''),
	 (N'ED5AC371-D37B-4018-8AC8-FD17BD1F8DBD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'IB+epnG7s7Uo8crDSG/1JiL1Ah6qMd4U7zRHAfel1jg=','2025-10-03 20:10:33.2960147','2025-10-03 20:12:33.2958296',NULL,N'::1',N''),
	 (N'26F9FF88-C61A-4AFE-BB59-FD358C1B53F0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'JSe3zgf5j1fA4e4Cm5Z+mWSa1ZDhY3hbFglMEK7+9e0=','2025-10-03 20:43:59.9569255','2025-10-03 20:45:59.9568518',NULL,N'::1',N''),
	 (N'F96E8083-C65D-4188-A691-FD4858B94239',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'mZUQcF2LaIJswDS5Z2My4AvfehmLdUcJoWaFhY7rDG0=','2025-10-03 19:20:37.9152970','2025-10-03 19:22:37.9131867',NULL,N'::1',N''),
	 (N'ABABFDE2-D149-4314-A1BA-FDFB7D269B62',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'G1pxvlumBipMZLLyPD27xyitfLuEt3oixydfCGa9IvA=','2025-09-19 00:27:55.2177983','2025-09-19 01:27:55.1999243',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.AccessTokens (AccessTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,IpAddress,UserAgent) VALUES
	 (N'278DFE62-A794-4A7A-967B-FE22F9BFF752',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'unz0Sehis2K4rrZIzOifEAE+szshRyyFrEAlTF5oGEI=','2025-10-01 22:15:11.7114868','2025-10-01 22:17:11.7114480',NULL,N'::1',N''),
	 (N'CC998E38-7F7D-425A-B89A-FE308019834E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'ZvYrwhi5syvFx1ItMaJCN1mvAni0Y93VBhr9EQx3mIs=','2025-10-03 20:32:49.1039507','2025-10-03 20:34:49.1036773',NULL,N'::1',N''),
	 (N'73F92979-5BCA-4432-9A29-FE9EC3E08448',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ObrH3FL5KLtMKjKyD+zr8JmQ+343xlWLHNH+1rYi/to=','2025-09-30 20:59:13.9889125','2025-09-30 21:01:13.9789607',NULL,N'::1',N''),
	 (N'2AAF3087-2E99-4FC6-A32D-FEE791AD52E5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'qGOcvuecFvlIHqGIylbxkPk5VOA0bO2Q5xgV/rkfZi4=','2025-09-30 20:08:05.4366750','2025-09-30 20:10:05.4366119',NULL,N'::1',N''),
	 (N'BAB8CB21-9DA4-4E6A-8AE7-FEEACB89CE13',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9AqlGEvWt1p0XG9ls1vazF/GmnOCbDky9nz2LogZjF0=','2025-10-01 22:01:30.7629868','2025-10-01 22:03:30.7573252',NULL,N'::1',N''),
	 (N'7E388861-F74B-49A5-A7BA-FF41A6454DAA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymAppFrontend',N'3+/3UwQYhlg+vy/bEjA5naDnchVvkUaKWezCrwyd3iU=','2025-10-01 22:37:52.0119524','2025-10-01 22:39:52.0118408',NULL,N'::1',N''),
	 (N'9033BE9C-5530-4636-930B-FF9882B98FAB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rD1g8Vzu84AWUHxKU0B8S0UghvTjYkV8j53CnCFfY70=','2025-09-30 19:38:47.5831093','2025-09-30 19:40:47.5503154',NULL,N'::1',N'');
 

 
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'72C4AF79-BC9A-4605-AC54-000DE05303B3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6UG43l560vZEHR36wK3ShPgNgZRMiVnQ8ZyyYACzY8M=','2025-09-23 21:12:35.3854341','2025-09-30 21:12:35.3854343',NULL,NULL,N'::1',N''),
	 (N'8BE86533-B90F-41FB-BBDE-00A0AF6D4775',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'AKQiK+djuPxN6HUQ0oJjWsU3EgkTFlkK5EkRS600hXI=','2025-09-30 21:43:47.5639479','2025-10-07 21:43:47.5639481',NULL,NULL,N'::1',N''),
	 (N'631FFEFE-1912-4EA0-8778-0161F5DA01F1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'pjKKBj6UqIJ3M2jz0EFUjAIGF/PiE/oaAjoAYatP9Jc=','2025-10-07 17:11:38.3365963','2025-10-14 17:11:38.3366545',NULL,NULL,N'::1',N''),
	 (N'EAE21244-8B8B-4792-9C29-01B0111D3E4C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KpOHlQGPfuV/HGlWMgfM9YH7A7Jug8RCazuj8bkw1g8=','2025-09-29 22:29:28.2669870','2025-10-06 22:29:28.2669871',NULL,NULL,N'::1',N''),
	 (N'E1D60DEC-2BE9-4A0A-AD06-02C2077D7A17',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9n5Zwkgvi/5I6dTRk67ZVXMBaEYDcGQ3jbHcnver1vY=','2025-09-18 23:55:26.3204998','2025-09-25 23:55:26.3205651',NULL,NULL,N'::1',N''),
	 (N'FB4CD6DE-C2E8-4ADA-A70C-0318C2E40A27',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'JWco9LATRZlwnMxQ5HqnikTUZEyDQFUsIZsj5UXpuiY=','2025-09-30 23:27:24.7518627','2025-10-07 23:27:24.7518629',NULL,NULL,N'::1',N''),
	 (N'2D59C133-3AFE-4775-A8F4-0442417B1514',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5qCOi5VYSiZ29JfMir7bAmDaInxhPn1+Mw7vCduU7NY=','2025-09-24 21:57:46.9067723','2025-10-01 21:57:46.9068449',NULL,NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'26562E63-96EB-4CEF-9A82-054C3C1D9167',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'14BRoXHB7LjBH8GGWWJbw1QB+ETH/fSM5RKO/WlAOgQ=','2025-09-09 00:53:36.0509087','2025-09-16 00:53:36.0509089',NULL,NULL,N'::1',N''),
	 (N'5CC27B9C-0B7D-4892-A9AE-0596B314D342',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'UM1JsAscXh7GEARDJi0MSQaNLvDKi8fXlvbkieJ+49o=','2025-10-01 22:32:32.7661871','2025-10-08 22:32:32.7661874','2025-10-01 22:32:38.9508143',NULL,N'::1',N''),
	 (N'5F9FA3D4-2651-4B1C-B59C-05FE49884AAB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'83IDT8fHrIElUAlXc87ZC7OTQtkDkMnM0du+YcKxKP4=','2025-10-01 21:19:14.4348700','2025-10-08 21:19:14.4348703',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'8FDA4A1E-43B0-4D83-8E97-06641D3F468B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nM6dueT9W0kwoH8hk6TETXtLov4e07g88R8gSzbdFjY=','2025-10-01 21:50:06.2601015','2025-10-08 21:50:06.2601018','2025-10-01 21:50:15.7356248',NULL,N'::1',N''),
	 (N'0F149ADF-131A-40B3-B1D6-06A5D3E036BE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bq0WXUcBegDuTQon/kprR5x4Y+vDCjJ0popmvKgPuBU=','2025-10-01 20:36:32.0418633','2025-10-08 20:36:32.0418638',NULL,NULL,N'::1',N''),
	 (N'E93AECED-9E23-4C6D-8437-0734A3379AA9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2XOksX1nRJJqeLXAXWg1+hlaucfsIs0MmfdD1EAuwyM=','2025-09-05 22:46:34.3431008','2025-09-12 22:46:34.3431009',NULL,NULL,N'::1',N''),
	 (N'2086C219-AC4A-47FB-9F3F-0A3EE40F1C04',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'FJ2Gpe1jqfM9TVuLkKQj9jsVjL1S3Cdq/gyAc/aglAo=','2025-09-19 00:33:11.7484656','2025-09-26 00:33:11.7485285',NULL,NULL,N'::1',N''),
	 (N'4889825D-DF62-42D8-AF6F-0A977C052203',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1hc2eOx3ztRTtR/zOjThoFmhZjnbuf3XB4RSSy+k97Q=','2025-10-01 21:23:49.9922858','2025-10-08 21:23:49.9922862',NULL,NULL,N'::1',N''),
	 (N'C4C23CE0-087B-4C49-BED2-0C3E5447BA6D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zcLMOiTl33y3ukLw5dPPr4ihSPqs/1rYaHiNYE4TELo=','2025-10-03 20:38:25.2031527','2025-10-10 20:38:25.2031528','2025-10-03 20:39:52.0163083',NULL,N'::1',N''),
	 (N'36CED0BF-DE11-4E3C-A9E7-0C631E7F1A8B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'df8yb4upg0GbPlmYqvGY2lbhV65G+ewweogtHEmb0D8=','2025-10-07 18:34:18.5495335','2025-10-14 18:34:18.5495799',NULL,NULL,N'::1',N''),
	 (N'DE27F1D3-8AFC-48CF-8704-0D588F139661',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'P1rnrRFLkqfnbLg6Byw8Cy76KoX/No09Pz1rHJ8AVfM=','2025-09-12 19:27:47.7958139','2025-09-19 19:27:47.7958951',NULL,NULL,N'::1',N''),
	 (N'4ED9C796-51CA-4496-BFE6-0D59BD31DF17',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'tfpBE2cCAlurcKdmLLFQEft9tCF1V3BoELs7HoOPUtE=','2025-10-01 22:15:11.6411875','2025-10-08 22:15:11.6411876',NULL,NULL,N'::1',N''),
	 (N'3918DCA6-A565-4F78-980E-0DF02E8C9A65',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IQFiasuv07Oq/XJfqq65XYviN3D7N5iKtISyUZfZatg=','2025-10-07 19:12:44.5788575','2025-10-14 19:12:44.5788576','2025-10-07 19:13:57.1353363',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'36DAEE9B-F499-4F4F-864E-0E257B22F741',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Mg+npCVD4Po2lPX942pHCx4TpG2zgD6MODNzAU4lylI=','2025-09-18 22:20:31.4583482','2025-09-25 22:20:31.4584549',NULL,NULL,N'::1',N''),
	 (N'88682D78-2BAE-4DC6-879D-0E43F3CC59AB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jIVY8MHVLvstjvA49w4qUBSSt4IAoHjXBuA0FLcGsBY=','2025-09-30 19:51:57.6795190','2025-10-07 19:51:57.6795194',NULL,NULL,N'::1',N''),
	 (N'38CC701E-42BF-4C51-ABE0-0E58C9CA16E9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'4CbbfDTuRsbuZDnogcc7HE1oIGDc/cKPso53WsxwovA=','2025-09-24 23:24:38.0163093','2025-10-01 23:24:38.0164052',NULL,NULL,N'::1',N''),
	 (N'FA50415E-71FA-4BD5-A477-0F95CFCA68E2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+1MqSml/UuHrk43yQrhBRhquPeBPcB0DW7nMwghZJ/s=','2025-10-01 21:53:07.2155206','2025-10-08 21:53:07.2155208','2025-10-01 21:56:55.7635987',NULL,N'::1',N''),
	 (N'8958ADA7-3206-4F06-BCE7-10630FCA6A65',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'r2xTlqtWMtSDAkH5zaUFh0TVEsSbC2+hzNpF/3gaGpo=','2025-09-30 20:24:33.6211906','2025-10-07 20:24:33.6211907',NULL,NULL,N'::1',N''),
	 (N'9E319ECD-537E-49D1-A02C-11BF2527BDBB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'3I3V18+IFgyxe7lye6THhBVu3/dt4HejOn3XgTUi0Oc=','2025-09-05 22:44:12.5093392','2025-09-12 22:44:12.5095006',NULL,NULL,N'::1',N''),
	 (N'F3AF782B-F0D8-4CC7-9684-11FB773DA46B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GdEi0m2WJw6KCywF/7ofdb5v3GWIIJkm5jNJhG99O6g=','2025-10-08 00:54:52.7784427','2025-10-15 00:54:52.7784429',NULL,NULL,N'::1',N''),
	 (N'B3F25980-DDDF-49FE-ABAE-121671DAEA5A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Setafn5VP5YffDDMV+3zLJO870NuqvFnRIRoKcsHVoU=','2025-09-16 20:44:51.2179408','2025-09-23 20:44:51.2180080',NULL,NULL,N'::1',N''),
	 (N'4CB5527C-1015-4DAB-B748-134D54BAAB8F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2tImRBbuH8zpHw9s+V2hx5zA/AjFNB5Ap7BunOKVapM=','2025-10-03 20:16:29.2422195','2025-10-10 20:16:29.2422196',NULL,NULL,N'::1',N''),
	 (N'E7CF9204-483C-4BD8-BEFF-136015912664',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lUT/rhdtWUDxEqbxGfnu+9RlODLCTjDaieQzsX1N+hM=','2025-09-09 01:35:04.3871860','2025-09-16 01:35:04.3872476',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'E6C780C8-C7C7-444A-B042-161C98521D6D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'gXG6IID0TSHsOdCs4FdtPdbYD1RRhOgfVsl+YU1brAo=','2025-10-03 20:28:30.8583130','2025-10-10 20:28:30.8583131','2025-10-03 20:28:56.4580764',NULL,N'::1',N''),
	 (N'39FF4529-3BDB-4D19-B52F-1797C8218A2E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'tDYI+0Nyv6JfULERloUAr19rzAJ3OMKg3X7Lj0X67UU=','2025-09-17 02:08:36.5486753','2025-09-24 02:08:36.5487488',NULL,NULL,N'::1',N''),
	 (N'73912345-ABCC-46CF-AF49-17F535D95019',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6Fbl94WusM9Lys3cOAm0kr1RoKH63bTt8cmAgyIDXUc=','2025-10-01 21:30:51.8710679','2025-10-08 21:30:51.8710681',NULL,NULL,N'::1',N''),
	 (N'93EB93F1-4B1F-4026-88B9-184FD1E2D7F9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'JQ4rWHH03a31AfLp5iUcnlTl/KZS2+pSxMc+O1FxjTA=','2025-09-30 19:27:26.9554825','2025-10-07 19:27:26.9554831',NULL,NULL,N'::1',N''),
	 (N'FCCD1F05-D8DA-487F-9192-18DACED6E85C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uK0o5+a2e0SIfEiS4BTeKA92HhcRdJ88d7/1fln2EIE=','2025-09-24 22:03:38.9161585','2025-10-01 22:03:38.9161586',NULL,NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'5375E228-5681-4F42-A944-1931F82D2154',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'aO/rWsSQ+HZy/IiRHFqpHnOWW3CAGQjlOOF5qQs1x9Y=','2025-10-06 19:50:02.0560991','2025-10-13 19:50:02.0560993',NULL,NULL,N'::1',N''),
	 (N'0721F403-01A3-419A-83BC-1A123E2FBB53',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zIdF4mcwc/aOcET0KnvrS354XsbIP6ahvhJSLcyyTxQ=','2025-10-03 20:06:36.9608391','2025-10-10 20:06:36.9608392',NULL,NULL,N'::1',N''),
	 (N'8E0BB394-4BE2-4177-9D4A-1A794E40C207',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2IZtyf0/g244eVAoyPo4TLOlrPPs7eV6mYrqC7NVzzA=','2025-09-05 22:45:33.9293794','2025-09-12 22:45:33.9293805',NULL,NULL,N'::1',N''),
	 (N'1608849E-FD38-4174-AEEA-1AFFB0D2A383',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kbcKxwGSjKWw5sMvu4vVsgdkY0JBaktddUz9Hmi6kQA=','2025-10-07 23:41:27.2779258','2025-10-14 23:41:27.2779891','2025-10-07 23:41:33.9171874',NULL,N'::1',N''),
	 (N'2AD7CB89-8339-43BA-B77F-1B3596B2C4FB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'h6ympRT9B2BhyNtA+7vnJEa2JpnlkuQW49iAFEi2rUk=','2025-10-01 22:30:49.5756742','2025-10-08 22:30:49.5756743',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'3B7A4977-31EE-4FD2-AC7A-1B587BF430DC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bj1ETc+WuG8tuFIHeUNtez9grZ4PXy1JcEwOgK44xsc=','2025-09-18 23:19:31.7849259','2025-09-25 23:19:31.7850419',NULL,NULL,N'::1',N''),
	 (N'5460888C-5714-43AF-AD7A-1C50D5998CD2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uR4l4I3PwE4vgipvczJPhU8CIKOL6rYrNyQhwyc3WG4=','2025-09-24 21:51:51.7701095','2025-10-01 21:51:51.7701097',NULL,NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'44472FB9-C048-4883-9317-1C62BD488BF4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IzlT3opSLjSS+QtVmjvxWxjaXMCZYWLH/wSGuwR9VYI=','2025-10-01 21:56:55.7498824','2025-10-08 21:56:55.7498825',NULL,NULL,N'::1',N''),
	 (N'18F5B7B9-916B-4F80-8AA5-1FE920DABF62',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kLiavH8iYDc1WflVsxSMKGL1ri6Ip4cRCf8M1akOXHg=','2025-10-07 19:13:57.1312722','2025-10-14 19:13:57.1312722',NULL,NULL,N'::1',N''),
	 (N'4D96DA48-5DF5-44C0-B833-208CCF33E65F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'yeR4/ekfFJyUo2MC0q/25Yt8NN2t8sDWb+qD/ZxDNrg=','2025-09-22 22:46:17.0854708','2025-09-29 22:46:17.0854709',NULL,NULL,N'::1',N''),
	 (N'73C46885-1B17-4EA5-A67E-20B2DEB5C35A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'NDvl3mNXPGgNrb5Fmv2dC8fG3LzKGH+wQciFauc+trY=','2025-09-18 22:32:53.3421848','2025-09-25 22:32:53.3422530',NULL,NULL,N'::1',N''),
	 (N'2AC6D066-6026-4C9F-B072-20C04F21998A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Y0VX8+YPE+VYiAN0q/DwRRzPzzSAdvvzhIAdLgHVtmg=','2025-09-23 23:10:54.7267844','2025-09-30 23:10:54.7268590',NULL,NULL,N'::1',N''),
	 (N'57084A92-7B4F-4C5E-9581-20DF0D569352',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'E7o0GxekMpv+ZPpkz8nUWWtApmk0/499RVNtjYcymr0=','2025-10-08 18:18:12.1338844','2025-10-15 18:18:12.1340379',NULL,NULL,N'::1',N''),
	 (N'7A522076-2A3C-4F0E-A544-21FF70237A47',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'G97OS6SrIXrSv0GFIKVlSW0XPyKaGdsdtHKlR7e1EU8=','2025-10-03 20:03:45.7811296','2025-10-10 20:03:45.7811298',NULL,NULL,N'::1',N''),
	 (N'6600C490-550F-4D23-BF84-2263A8191840',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'd6W5yffWeX9a0EnyhFucRVGDlaCrDdQHBJXX3wBUE+Y=','2025-10-01 21:57:44.6833950','2025-10-08 21:57:44.6833952',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'61AF4858-30AB-4CFF-B731-2340AE76F329',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'l21q5n3Loo7ahTgMvVLPik3roFkXqqZxoMQt0Qmtc4w=','2025-09-29 21:54:35.7765374','2025-10-06 21:54:35.7765376',NULL,NULL,N'::1',N''),
	 (N'871C382A-0934-4970-98DF-239226027B3C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/xMEmlL6shW9cJH+hRWLFRNHrln/cI3tpJyeW1cbvEU=','2025-09-23 21:06:37.5431187','2025-09-30 21:06:37.5431829',NULL,NULL,N'::1',N''),
	 (N'075CA7F8-FA00-41C9-ABC4-2522555494AA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'TbMx6YKhC94yll49Pbuvx3F8moNU5mC/2Sut649oAB4=','2025-10-08 17:53:47.5693262','2025-10-15 17:53:47.5693264',NULL,NULL,N'::1',N''),
	 (N'B45A4C41-602C-4657-BC07-266885A38A61',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cpt5g2vpIv5S4x5nFFiq5ChUMxsPHppZZqyC/dYOYgA=','2025-09-30 20:15:30.8278168','2025-10-07 20:15:30.8278170',NULL,NULL,N'::1',N''),
	 (N'E206D70D-AA5B-484D-8D70-26DC2176F7D9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Fn/l+0171Xt6MbOjievM6XxT5uyzCdK1FIYici6kzEM=','2025-10-07 17:07:13.0718748','2025-10-14 17:07:13.0718749',NULL,NULL,N'::1',N''),
	 (N'E7F86C4F-372F-410D-808B-277E20FAC2A5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'A0ZN/TznvTI79LgD1ZTYTwcYxi3h1tbZKuOW0EkmQvs=','2025-10-06 19:44:22.5239983','2025-10-13 19:44:22.5240786','2025-10-06 19:44:37.3821490',NULL,N'::1',N''),
	 (N'B38CC2AB-D27C-4BCA-A2DC-280C661AC716',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fx0K9sMFEhRPgwi2y8Wfniu0PwqqvWXFQ8G1fhEzhW0=','2025-09-17 01:38:07.2151434','2025-09-24 01:38:07.2151436',NULL,NULL,N'::1',N''),
	 (N'60DD8737-0A53-4351-BEFC-297A8D8D43C3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1iODsbcVc7xbwVExE6G3WI+LnB+2YPErhSyq/lV7WqM=','2025-09-17 20:05:35.6860029','2025-09-24 20:05:35.6860031',NULL,NULL,N'::1',N''),
	 (N'A1F39234-24EC-4B2B-BEB9-2AE97355AB73',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8OUfLfcaZjkzPd8JfvBjk5dYMVR0TZLUbXvatN/L+UM=','2025-09-16 20:24:25.8133383','2025-09-23 20:24:25.8134024',NULL,NULL,N'::1',N''),
	 (N'17221CFC-5CF9-4134-BF17-2B2D46E0F2D8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'z5TKR5pn8sJqo/3aqKxzEf3Eeo9DztmIojneM9g2RY0=','2025-09-16 21:22:22.4921608','2025-09-23 21:22:22.4922382',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'F20F49D2-A68D-4B20-95F6-2C57DF012E57',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7/oanW9JeAQO7PWCbah+e+80HQG69DA7VcG9Rca0qSE=','2025-09-24 21:56:02.2556114','2025-10-01 21:56:02.2556115',NULL,NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'5FF4F5D5-2C7E-4FAA-9E36-2CAB34F610DF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'EtjwcfRHI7DDm7XBfYtB85mW6s7GeHM/DmwP6bSz1Wc=','2025-10-06 19:32:57.6774377','2025-10-13 19:32:57.6775351',NULL,NULL,N'::1',N''),
	 (N'30ADB2F3-5A5E-4A02-AD80-2D17F4FF8088',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'JsGPKE1frGh5+cEQjqzoZZbNiZDNt1MJvYapW+leuAo=','2025-09-17 21:10:40.9472731','2025-09-24 21:10:40.9472732',NULL,NULL,N'::1',N''),
	 (N'218B6103-7914-4041-AFF4-2DCCE1B052B3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9hq7Jc6LmzM9jxleqOmGwuL3XWGDWD8A1JagKg2RbUs=','2025-09-18 21:59:10.4695631','2025-09-25 21:59:10.4695632',NULL,NULL,N'::1',N''),
	 (N'A0C41F13-E92A-4B61-88D6-307635ECEAFA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zWTBaKpjSHBa0psV88qljvO38ZVtWwjy8t9oAfEr1Nc=','2025-09-30 23:01:32.8485856','2025-10-07 23:01:32.8486740',NULL,NULL,N'::1',N''),
	 (N'8084FDCC-C005-4AAB-A8A7-317296FDBDBD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Iq0HUTBAKK35fqgmlKh3a7twP3lh5eRNGryeQdpMlcQ=','2025-10-08 20:09:21.1274374','2025-10-15 20:09:21.1275194','2025-10-08 20:09:32.5886562',NULL,N'::1',N''),
	 (N'79849D1D-FBCF-4ACD-A662-32906A6F4D7E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zY8GSiGndxmFcsRnNJEAYtG1R2oXG3FUQ77E9TMYZ2Y=','2025-10-03 19:38:51.9648694','2025-10-10 19:38:51.9648696','2025-10-03 19:38:53.0419050',NULL,N'::1',N''),
	 (N'9D392200-E4AC-4696-B4DD-329899712103',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'aDttqFgQ5m/xf7UsWsqB0NPg28qCTWc8yFHhFavx1Bw=','2025-09-18 22:01:40.1450793','2025-09-25 22:01:40.1450794',NULL,NULL,N'::1',N''),
	 (N'21E4E403-15FA-4D90-8367-336FC0B22791',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'eKNZa37sjJz+on+HnPh9O49vHRkryCAIoDAgOzeUE8g=','2025-09-05 22:53:36.2250777','2025-09-12 22:53:36.2250779',NULL,NULL,N'::1',N''),
	 (N'0B6A54BE-ADAB-452F-8BB8-3379382945F0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ivaNAQ3KYaiT/HpCBw+XQrSJ8KjGPJvqpDkpWsdyveU=','2025-10-03 20:13:27.1093580','2025-10-10 20:13:27.1093581',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'2A52E2CE-5047-4808-B7BC-3387578477A1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dqNqp7m2qe99X8V67zu9ZSlWuN4lzTla526Aiy48tI4=','2025-09-17 17:01:35.6725703','2025-09-24 17:01:35.6726705',NULL,NULL,N'::1',N''),
	 (N'524FBF55-52E7-4B5C-A838-339F87696DFE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'eY2tYLgBLDRQ9/pHLX0hHi6iabTqK2kIXZX7asUmg+w=','2025-09-30 00:06:31.3048871','2025-10-07 00:06:31.3049538',NULL,NULL,N'::1',N''),
	 (N'B1DBD278-0087-40C5-AFCA-3419DC167605',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'iDHMKzaiR5DLsTszVZwfcpAUKiDlxqOliLFoTJSH2To=','2025-09-24 20:36:44.2542035','2025-10-01 20:36:44.2542039',NULL,NULL,N'::1',N''),
	 (N'AB18D3D4-3AEE-440A-981D-356982C35D83',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fsh0dNRwqNMbkQiu6XlpWpGTcYUPDCM69G7w8Evu5o0=','2025-10-03 19:41:39.0703648','2025-10-10 19:41:39.0703654','2025-10-03 19:42:46.3605939',NULL,N'::1',N''),
	 (N'E38B3904-9142-45F6-9514-356BA50D3F89',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7x9adOOk/gT56Fm4M9cqnop5YYEemwXnAMpo7/yYG6E=','2025-10-08 00:54:51.0978498','2025-10-15 00:54:51.0978500','2025-10-08 00:54:52.8000334',NULL,N'::1',N''),
	 (N'666F8FEA-8E99-4713-BC3E-36D51925179F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Q+tCmfyLgsq8D+/Qoeu+qMM0PGuLqCRKJpLmVUS+uh0=','2025-09-16 19:38:53.2283625','2025-09-23 19:38:53.2284499',NULL,NULL,N'::1',N''),
	 (N'F83B1B39-D37C-4D80-9F5B-36E23A00994F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'UK0EJbpuTfUwTfn9Yny38EjO/cZY/UfKgWMjB2pJ9Ww=','2025-10-03 19:39:10.0307804','2025-10-10 19:39:10.0307806',NULL,NULL,N'::1',N''),
	 (N'AE74382B-8212-444D-9379-394E97DF2C02',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'SnB2VNw3R8OYjKBLeZAbiSXpH6j8FWmPlQk95IXxZVU=','2025-10-07 18:57:19.8810084','2025-10-14 18:57:19.8810085','2025-10-07 18:58:33.5305688',NULL,N'::1',N''),
	 (N'07131745-4C1B-47ED-A50F-3A26F61210CA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'D3BAWeBF2vR493wvoC2bh0V4q6Obgp22cyiMIdODIic=','2025-09-09 18:03:27.9621283','2025-09-16 18:03:27.9625180',NULL,NULL,N'::1',N''),
	 (N'0F0AA136-AF1C-4461-9695-3BB1C073358F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'SEmTMV/PblYAp0VAWBXWN86dXEy69ZG2ORCm9J/cGTc=','2025-09-16 20:11:12.3103688','2025-09-23 20:11:12.3104337',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'1FB11A9E-3DB3-4506-AC30-3BF6F393B516',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1rbPJhnF1eHu313O8C3G/sQ+Xo2iv5GoaUFwjgiSyl4=','2025-09-24 23:48:00.3269097','2025-10-01 23:48:00.3269099',NULL,NULL,N'::1',N''),
	 (N'89FE23EC-B559-4D55-8809-3C7C5B8C1F83',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ODZfv1KFoMYFqv/onHl7gQz7l//wLRlaljg9ahO2bZs=','2025-09-25 00:02:02.3531602','2025-10-02 00:02:02.3532233',NULL,NULL,N'::1',N''),
	 (N'88FAF774-60EE-49F1-8844-3D264DCCC178',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Ni6gBtTC0/Z3Ao+ZkmOUFtOlqhQMGE0O5L+j9K6qjEM=','2025-09-18 21:58:40.7193468','2025-09-25 21:58:40.7194097',NULL,NULL,N'::1',N''),
	 (N'54B510E2-E3D7-4AF2-B100-3D54BFB6E8F7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'BdeTP6VwkojZ73KBZBqK1EHm6HXDZruuiE0zULDFDYM=','2025-09-17 16:32:55.7130030','2025-09-24 16:32:55.7130031',NULL,NULL,N'::1',N''),
	 (N'7DD96F4B-C387-4FC0-8FC2-3EB0DFE73F95',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kU4fcCl0vbnode0FbCgJWOcpkIRjDAe1SJymF2PCCiM=','2025-09-17 17:47:18.2196177','2025-09-24 17:47:18.2196984',NULL,NULL,N'::1',N''),
	 (N'841E94F0-7D98-4C7F-AB4B-3F4F95A2B178',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6H0i1sk156hyZoJ9Lf6ulaZFJMxvMLWMBi4G1Ig1EZ8=','2025-09-05 22:48:43.8659422','2025-09-12 22:48:43.8659424',NULL,NULL,N'::1',N''),
	 (N'81F04D7F-DF9A-4552-B575-3F578699579A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'QcfhpmxsEq9kkj2XbHdSOnTKLh2MZwQEDXJck3YUTWg=','2025-09-10 18:18:46.1586376','2025-09-17 18:18:46.1587259',NULL,NULL,N'::1',N''),
	 (N'0D0B3860-C5A8-4EE8-B25A-3FF47FF12022',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/o5/EbCsKbjoPJ8Bp9VQaJ7sMjpJJ4ioJonmsMQPjI4=','2025-09-22 20:01:48.5125839','2025-09-29 20:01:48.5126730',NULL,NULL,N'::1',N''),
	 (N'745FB88C-7A01-4F0C-9083-402E982149A0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rt+ysmOr8K7MlMe7fztueoNrYV2zLDEmhYDAHvSiEfs=','2025-10-08 18:03:40.8794104','2025-10-15 18:03:40.8794878',NULL,NULL,N'::1',N''),
	 (N'B35C915E-C442-4915-9DCB-40FDA42F7B33',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'odKwEdDZIVjm5TfarsW65AKw4CvaPkhmzvp3PE8RhNk=','2025-10-01 21:28:38.3714552','2025-10-08 21:28:38.3714557',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'39FBC502-1F63-4FB7-B671-41FAB4EC0A95',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'3UImngkhZ9FJ0LP9WuuPFXFH/jlcabQBONJ/ebBU+UE=','2025-09-24 20:33:37.7420021','2025-10-01 20:33:37.7420773',NULL,NULL,N'::1',N''),
	 (N'F46BBA77-26DD-4596-9F2B-423166E27BF2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'VI8oEENNkMc9z62N4E2xA4HFffsCdZHMEh5Sf10Mkgo=','2025-09-23 22:04:25.3616825','2025-09-30 22:04:25.3617871',NULL,NULL,N'::1',N''),
	 (N'BBAE98D8-C0F1-4AB2-9753-4318FF9937D4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+B6wxb0S0vRlUncRlmEtijjkvqnFkTieTs/gNmQ5yEk=','2025-09-16 22:30:59.6810869','2025-09-23 22:30:59.6811525',NULL,NULL,N'::1',N''),
	 (N'B6E33E88-78C1-4FC1-8B9B-44157812DB85',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'eEbHsWY4tMVZP3rn6JZ/gHELUbMGqnf+hiqVy+6w51I=','2025-09-22 18:39:55.1645222','2025-09-29 18:39:55.1645984',NULL,NULL,N'::1',N''),
	 (N'9F62729F-A0C7-4653-8722-44C9BF417B93',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'eITuWqm85SGLPRm/VZj/xeY8XgY3i42CtjjrYV46fjo=','2025-09-05 22:52:55.2865652','2025-09-12 22:52:55.2866162',NULL,NULL,N'::1',N''),
	 (N'7DA67597-F33D-438B-B315-4500B7AB9FAA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'sdWIJpYyvsPZDupBQ0NR0ypTOB78ZWt5GgXP6L8V0DY=','2025-09-17 19:48:51.1971739','2025-09-24 19:48:51.1972388',NULL,NULL,N'::1',N''),
	 (N'4BBE2353-0932-48D9-809C-463D41F8F37E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'tseTtOZR0A4Um84SgGh14vEmGng0cWvrF9a5iVpWFlA=','2025-09-30 20:14:22.8786104','2025-10-07 20:14:22.8786109','2025-09-30 20:15:30.9137371',NULL,N'::1',N''),
	 (N'A4AA576E-C8DE-437D-B3E0-4651BD6210F4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'weW9wYGgGYRd+egwfVjecA3Wjm9SPf9/g56ecADj6OU=','2025-09-17 21:04:44.9084042','2025-09-24 21:04:44.9084693',NULL,NULL,N'::1',N''),
	 (N'66D55C23-50D7-4FD5-8C73-473ECA48B89D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'HSCCEYssU+2wOoyG+64DHfUlDV8ACru3av9abcgDcAs=','2025-09-09 17:43:54.1815514','2025-09-16 17:43:54.1815515',NULL,NULL,N'::1',N''),
	 (N'836D2EC7-8671-4764-B454-476A4B81BEBE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'xap4Wjyj4ru2pgY9dPCY/W/PMFuT4FvhTbRhq5SBEDc=','2025-09-23 23:06:39.6445626','2025-09-30 23:06:39.6446323',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'1C639366-087A-4012-B4FF-47D9E5AF2D97',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'mP3THpWvn4ZE0p+Y3Kbkp/KcAf7jJb/B0SxewOY6w5k=','2025-10-09 17:43:35.0901662','2025-10-16 17:43:35.0901665',NULL,NULL,N'::1',N''),
	 (N'7CCCF7F6-6687-435E-9A4C-48C3A3A84075',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'mV2aLW9Nx7vnDNVSMHYu5IvnbA3FIB9OHAnXiJj0fy8=','2025-10-07 18:58:33.5257948','2025-10-14 18:58:33.5257949','2025-10-07 18:59:42.8070035',NULL,N'::1',N''),
	 (N'542FD4D3-19B6-4226-BBA1-4A31723886E8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'MVqOUfrc3DSTRWwn/8IcCrY669fdkEs53zQrn7MsOnE=','2025-10-07 19:27:06.4894065','2025-10-14 19:27:06.4894702',NULL,NULL,N'::1',N''),
	 (N'098E8F6C-BA7C-4B22-ADA4-4B016DAA1D51',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'b5ysDJz44cNDbQUX5Zb049wTzflMh1JUbBZTpvAz8Kg=','2025-09-30 00:22:12.8535591','2025-10-07 00:22:12.8535593',NULL,NULL,N'::1',N''),
	 (N'EA57F2CD-1099-4D68-A2A8-4B4B4F576E71',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ynQVmthPoLaQ7EjGm/giZ8gM+j1uZzB8vwK5vEQxXF0=','2025-10-07 18:20:34.2529873','2025-10-14 18:20:34.2529874',NULL,NULL,N'::1',N''),
	 (N'CC877234-AE30-4BE5-A904-4C8D3F9A64E5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'A+IGPeE0UzlaYAumtmNw4MlTrGjsIWwbmzLyYnO8iEc=','2025-10-06 19:44:37.3388164','2025-10-13 19:44:37.3388169','2025-10-06 19:45:57.2837963',NULL,N'::1',N''),
	 (N'E78A699E-2DE8-4860-912F-4F12CEFE5792',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1+867RSrF+qRY8bPgzafy1pnW9iGN5YrAb1h1FmYijU=','2025-10-01 22:31:17.2380396','2025-10-08 22:31:17.2380397',NULL,NULL,N'::1',N''),
	 (N'430429AC-EE4B-4F5F-B370-4F2CF3C45057',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Q3iI0cseKo35Ua9z/eweh9fTl6ihCn5CxCdbGa+hGNk=','2025-10-06 19:47:19.9862671','2025-10-13 19:47:19.9862675',NULL,NULL,N'::1',N''),
	 (N'0D958182-CDA3-4F75-9DAE-4F56EC8A4C07',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'TqXe17UYDxpJ9+F86bNIr/5COd4LK1FYONLLtl/GswI=','2025-10-01 20:23:45.5558507','2025-10-08 20:23:45.5558513',NULL,NULL,N'::1',N''),
	 (N'50FE0151-9E8D-410D-B201-4F592699A57E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Y9iWQKRL0GaCPhmzlYWV5Ab0yhzDdKfnmv3i2XrPsmc=','2025-09-05 23:18:16.0320043','2025-09-12 23:18:16.0320046',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'C4125ADB-037E-41FF-806B-4FEF883B3D8E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bCr3B5tHTD4SVbZththGiy6BnzNKQgw3pW0WKQigHt8=','2025-10-01 21:52:37.8517365','2025-10-08 21:52:37.8517366','2025-10-01 21:53:07.2513404',NULL,N'::1',N''),
	 (N'1B98DCA2-E352-4AFA-AFD1-50088A9EB78C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0QP3MU5fGNUJoybqSKk7AX+XPpBCtxoFCCbLeOrvCQk=','2025-09-10 18:58:52.0432365','2025-09-17 18:58:52.0432366',NULL,NULL,N'::1',N''),
	 (N'59FABB5F-2CB7-4411-A127-5091186B4ACB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'QUEsO2YJNYIVZA7dgylOtoZo9nVi584Uka4dRDRKSx0=','2025-09-05 22:56:38.9594925','2025-09-12 22:56:38.9594926',NULL,NULL,N'::1',N''),
	 (N'2442E844-3E49-4639-9E31-50AC96C0D472',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'W0AHMDBo5x+nxsReq58dzgZDRl2eHSK14ZrJZMx0ysc=','2025-09-22 20:14:47.7013273','2025-09-29 20:14:47.7013274',NULL,NULL,N'::1',N''),
	 (N'42E47A85-8491-4EAC-89B2-50FBFF04D054',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vIG5PiSWCkSm3+hrFQp7fcvCiBFW9rEOjFpLrS0gxq8=','2025-10-03 20:45:32.2220712','2025-10-10 20:45:32.2220714',NULL,NULL,N'::1',N''),
	 (N'6EA45FD6-822B-4044-AD09-51417A4A7239',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'w2dSH6T8WjRj51QD3QheeH/hj/7pBor1dmcbtKUuCco=','2025-10-09 16:43:44.7109217','2025-10-16 16:43:44.7109219','2025-10-09 17:43:35.1606090',NULL,N'::1',N''),
	 (N'60A5A271-7226-4203-876B-520B124530BA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bHwHqbcoUB9iJDV9QHSOaiWMM4PoYaEIrg87kF1oVYI=','2025-10-03 21:15:12.0715820','2025-10-10 21:15:12.0716610','2025-10-03 21:16:27.4691373',NULL,N'::1',N''),
	 (N'F10446E0-341B-40FE-A949-52BF90F198B0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IVNnuwMJMdprNJdxoOo7Iz6NSWek5ElK6SG4HMwEg9c=','2025-09-05 23:26:53.9834304','2025-09-12 23:26:53.9834305',NULL,NULL,N'::1',N''),
	 (N'45AACAAE-3EA7-4823-9C02-537089643348',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'VO3/Y01bLxnO14V1Yci80fV+VGc7N8K3me6miW7lUaM=','2025-09-25 23:21:58.9575953','2025-10-02 23:21:58.9576818',NULL,NULL,N'::1',N''),
	 (N'8F0F2E16-6D0B-45C8-A87E-5476DBA3490D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9uxamke+q1WV3ij9E3nbW8IhGx6hjmt36hZtxvuH4Uo=','2025-10-07 17:37:21.4455992','2025-10-14 17:37:21.4455993',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'833DDDAF-AAA9-4450-A389-5483017DD2FB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'xyW+2wlPysngleqlvitYR31lWo9vHOGqV2zjXGHAX48=','2025-10-03 20:32:49.1224132','2025-10-10 20:32:49.1224135','2025-10-03 20:34:13.3470879',NULL,N'::1',N''),
	 (N'67802CC5-4465-44D7-8A45-54B361E4CFC4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+tvkvFKQu3zRIxk97PtjHJoTdPl3WCU1iIfjA4wTl9Q=','2025-10-03 20:27:58.6614841','2025-10-10 20:27:58.6614843','2025-10-03 20:28:30.9010301',NULL,N'::1',N''),
	 (N'33708355-3687-45FF-90F4-55F9A5524570',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'p+WHO7H+8FhMwzMyVaLuJhov43owKpKR4tZPSNTVWW4=','2025-09-18 23:30:42.2506957','2025-09-25 23:30:42.2507760',NULL,NULL,N'::1',N''),
	 (N'2BB01BB6-02FF-4B4B-B084-56843CBAAC7E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IKW2RQfrjizs0e0Yub+cyW9B91l7vSCpDpnqjz4FMI0=','2025-09-23 19:28:39.0429109','2025-09-30 19:28:39.0429846',NULL,NULL,N'::1',N''),
	 (N'420F9FAB-27E2-4C6C-9F75-56D3A1201235',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'VpDhC2ZXMjyFg97I+dJrzGfh6RyiStOG+eH/Bt8b6SI=','2025-10-03 19:47:05.9154982','2025-10-10 19:47:05.9154983',NULL,NULL,N'::1',N''),
	 (N'280A752A-170A-4047-99E4-584340DF3A5C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hMvXSrY9knsbNorVcwVL0nGgeOvg1Au4VjsEVhKfKK8=','2025-10-08 20:43:04.8910382','2025-10-15 20:43:04.8911179',NULL,NULL,N'::1',N''),
	 (N'D8810F6F-D5F0-44B3-9F95-58511C1E607C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zM43C12V7aoynomFirGFZrXeW7r5/fg4zu1AZ6p42hM=','2025-09-16 19:50:50.7663496','2025-09-23 19:50:50.7664529',NULL,NULL,N'::1',N''),
	 (N'950FB5C4-D399-491B-A1B9-59559A9956B2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7h3LRERQvBOHbD1vT3kAci4ud/in7y+dL4L0pVyLZ9E=','2025-10-01 21:48:00.9013013','2025-10-08 21:48:00.9013017',NULL,NULL,N'::1',N''),
	 (N'250E9B05-CDD1-4396-BAF9-5A1509810FA3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'PZdlqrLJiDVhwXvVUuyf420w/BHFYJgMxzqMebxDt7U=','2025-09-23 20:37:22.2081477','2025-09-30 20:37:22.2081478',NULL,NULL,N'::1',N''),
	 (N'F3A18438-1902-4121-89DA-5B4E558E9A74',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KImt/GwdGuncIm5TeAQd064pjZ5v9t/IuyZ4sXqcl60=','2025-10-01 20:33:03.8794839','2025-10-08 20:33:03.8794849',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'1A000D7A-E70A-40CD-99ED-5C27185601FD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wPpmuwnOsicSbXvYWsOcm/nub1QJdlHKGr9PLRdhhxA=','2025-09-08 21:28:24.8857587','2025-09-15 21:28:24.8858226',NULL,NULL,N'::1',N''),
	 (N'BD291733-FF42-441E-9D69-5C39C07988EE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fLDyyhh5cxPFjD4L4YfBt5nIIIHvs2uG6DSPI9wVExI=','2025-09-09 03:22:21.4129110','2025-09-16 03:22:21.4129792',NULL,NULL,N'::1',N''),
	 (N'6EA2EED6-D330-4D1C-AED6-5D1978BC27E2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'yTYq1eJse7tjdRamNLudwTOnHPj5jIxxp3tej34HVcs=','2025-09-16 20:22:16.6577723','2025-09-23 20:22:16.6578362',NULL,NULL,N'::1',N''),
	 (N'188B20F4-0588-4371-BFAC-5D434FD03692',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OZkCI0vfliYDzt16jiaqXLmHhxfQ7cUd7Lt1whMvcQg=','2025-09-16 19:42:53.5730872','2025-09-23 19:42:53.5730873',NULL,NULL,N'::1',N''),
	 (N'A156CF5E-5FD9-47FF-A2CB-5D604D4E3CA5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hmNBsTSzKL6r+zvbhJtzNVmpUouulmAkeKy+LJMZPfw=','2025-10-07 23:41:33.8044175','2025-10-14 23:41:33.8044177',NULL,NULL,N'::1',N''),
	 (N'2A755ACE-A84C-4B68-AC75-5FBA642941B1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OaQlPc+bTTwHTeUo4yxFB7xrxPyfdczVtdG1py8XNGY=','2025-10-08 20:38:41.6706356','2025-10-15 20:38:41.6707002',NULL,NULL,N'::1',N''),
	 (N'5ADFACD9-5FED-4224-BF7D-604722873D34',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'DvUQbY+OySdONKI+4qVBiJvFQsa5Ej3gWaZZkPSCua0=','2025-09-17 20:20:12.5678783','2025-09-24 20:20:12.5679413',NULL,NULL,N'::1',N''),
	 (N'D6CAA0A6-8904-41A5-9E6D-6144112DFAFC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IHi5e5b9AeLO6cB8yspVh29wyRxXmhSpahvb13+XS60=','2025-09-18 23:05:52.0201929','2025-09-25 23:05:52.0202588',NULL,NULL,N'::1',N''),
	 (N'E820DA16-0B7F-4F34-AECD-61D99EA221A4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+PAeBgNof21oK6xQd3zYwvgwrzLJNkJZZ/b2yj874Ys=','2025-09-24 21:55:33.8208453','2025-10-01 21:55:33.8209418',NULL,NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'B01F42E6-6445-468F-9CA4-6230932D3031',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'BrHXSzQaqu2FzAfAsQ1TuSkbGZuHy4m1hFmuJwtiUAI=','2025-10-07 18:20:12.0376753','2025-10-14 18:20:12.0377313',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'72179F8B-0895-4FB3-A317-629C7F526974',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kcN2oeRWEshtLLsVvmYaLcKbhy9F6PtTipvICfy6y+E=','2025-10-07 18:46:52.7488523','2025-10-14 18:46:52.7488524',NULL,NULL,N'::1',N''),
	 (N'E2C9D37C-17D7-4A7C-863E-62C9740A1508',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'oY1l80lTQVmc+UBfmoirc37o1vyaYk0t+nixi4tkk6c=','2025-09-23 19:44:46.1449918','2025-09-30 19:44:46.1451230',NULL,NULL,N'::1',N''),
	 (N'AB1093D1-C3EB-4A28-894D-65E09A413227',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5cTlpkIbKSiNSHBRW2gf7SgvwTrUKzJnBUAXXg4Om3c=','2025-10-07 18:51:41.4481661','2025-10-14 18:51:41.4481662',NULL,NULL,N'::1',N''),
	 (N'CAC60769-81F9-4B44-8D17-668BB329CB83',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fULmjevx9U9olXQVfJVLdFnp/s1uJoTi/r07s1gJZ/E=','2025-09-22 19:01:21.3774199','2025-09-29 19:01:21.3774200',NULL,NULL,N'::1',N''),
	 (N'20F23760-177B-4DA3-8E46-66D7A9199647',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8SvJKVb2iWMNc+bLAUD1zB1GNZBT61dm7G2aj1OX6S0=','2025-09-16 20:01:41.4262773','2025-09-23 20:01:41.4263843',NULL,NULL,N'::1',N''),
	 (N'5CFABA58-EE25-44E9-883C-68EDFD34F76F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uORkBww/pJIzW62ea3Pm09xo7wK2iAqkU2Wh6lqNn0M=','2025-10-03 20:26:38.0584553','2025-10-10 20:26:38.0584554','2025-10-03 20:27:58.6892645',NULL,N'::1',N''),
	 (N'FDF5171E-F9FF-4B0E-97EA-69FBA1761343',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'AxWKei8A2Uz+LMqXpyjWrl5ZpC4Rec6P5bsAT0GdKvU=','2025-10-01 21:20:37.1495518','2025-10-08 21:20:37.1495521',NULL,NULL,N'::1',N''),
	 (N'74F556BE-8E23-428E-BD3C-6AEB2CCF5578',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KezFXiOMEaO+7zSV0g16KQOwVF1xT75179hWcnhlbDY=','2025-10-01 22:39:39.7941370','2025-10-08 22:39:39.7941370','2025-10-01 22:39:42.9744379',NULL,N'::1',N''),
	 (N'0BB6B333-FFFE-4901-86FA-6B70B1C75871',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'BA+2TYCOrka9+WYG3cMQEeKAgmMSXTkCynOAAIG/MZ4=','2025-09-09 16:44:47.5117966','2025-09-16 16:44:47.5118745',NULL,NULL,N'::1',N''),
	 (N'49C57818-CD14-4DC2-81AF-6C030F0CAA06',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'W7AXsSCouDM+o7YZ739vwO5yrC3KpM8mvjzT2ovNFTU=','2025-10-01 21:57:35.8610249','2025-10-08 21:57:35.8610250','2025-10-01 21:57:44.7202730',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'2EF37249-136F-46AA-AD6E-6C5BCDF29317',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'tAi0Th2FGmioWVaCqhM7iFIVJk4ADwlVAHRSl5XkPl8=','2025-09-30 20:09:22.1317484','2025-10-07 20:09:22.1317491',NULL,NULL,N'::1',N''),
	 (N'8953D57F-9F8C-4F87-A2DA-6C775344FD82',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6R6wW5UUimebf088vFTwTVJE069LVziokYztv9wwxzg=','2025-10-06 19:52:45.6146943','2025-10-13 19:52:45.6146945','2025-10-06 19:54:02.1308087',NULL,N'::1',N''),
	 (N'8A121372-0DD9-487D-B6D1-6DA9EEDAE344',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'px/DOIQQ8pvo+BG6Gq66C1IlTvJmbZgxmVXnE3PQ7GM=','2025-10-03 20:50:59.2605709','2025-10-10 20:50:59.2605710',NULL,NULL,N'::1',N''),
	 (N'771A1EC9-9273-4873-A4B3-6E6392C25A98',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'mmtsmACNFpMuVColotN9CnwrezYyCiYDZCjEQ8AWWB0=','2025-09-18 21:58:57.3712533','2025-09-25 21:58:57.3712534',NULL,NULL,N'::1',N''),
	 (N'9DA75D43-A56A-4426-AD01-6EA05F285BE1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'J78eW005C0qwebLFFfRcfssBK4B1DVM2azPX69ZoSjg=','2025-09-05 23:24:39.2708449','2025-09-12 23:24:39.2709172',NULL,NULL,N'::1',N''),
	 (N'DFEDA9E9-4247-4A37-81D5-6FDB34B1BF72',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8UcKPGnrX19XvA7p8R9n8XaQWOVCW/aa2+Z1P3HzZ78=','2025-09-16 19:46:34.1490988','2025-09-23 19:46:34.1491609',NULL,NULL,N'::1',N''),
	 (N'C213FF6F-BAD3-4D40-A901-70CDA6B9C608',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'15M7lL9NU29LqcEb0NpsP5IViCXxWrXSq6d1nCdsIY0=','2025-10-01 19:49:54.1262156','2025-10-08 19:49:54.1262162','2025-10-01 19:51:42.3540883',NULL,N'::1',N''),
	 (N'05102FA0-D348-4EED-9549-720A4D138C0A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8KWXngTFR+WlyUZ73YtQlBYvM/fj3+GwU5F+9HB+yR0=','2025-09-22 19:45:36.9078671','2025-09-29 19:45:36.9078673',NULL,NULL,N'::1',N''),
	 (N'0D5B8284-25F8-435C-9B14-73260E60459B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'XjdAV9TrJdGza+PUDoT9E9fGeBMXWwnP7bMqHevSZ/g=','2025-10-01 19:51:42.2491148','2025-10-08 19:51:42.2491160',NULL,NULL,N'::1',N''),
	 (N'63C6BBE0-EFE9-42BA-8471-737FDE6CF92A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nXeA1nQBdXEYljwtF3RP8+2VAmvTBIm3KyTnAKyrlw0=','2025-09-17 17:55:05.9333004','2025-09-24 17:55:05.9333664',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'37DDA3E4-FA25-4CBA-AE2E-7515736D3996',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'hWmJYBkz9Yzb6gU9QoJPVdHCQtU5Gjj6P/+B0wcEKgM=','2025-09-10 19:43:44.3429056','2025-09-17 19:43:44.3429057',NULL,NULL,N'::1',N''),
	 (N'38642839-0510-42B5-BCD2-7566817FCE3D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'44NneLzn/CZGhL/7b9mNLR1j+MIIGgVGjwpAEa20PyQ=','2025-10-01 22:44:46.1131243','2025-10-08 22:44:46.1131243','2025-10-01 22:46:30.8374171',NULL,N'::1',N''),
	 (N'CB3B4B20-C606-49AD-A9B8-75FFC1ED649A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fOuiFWsgv88egBBj0OcXQwsiOLMmob072eDbmNIwM8M=','2025-09-09 16:40:46.9301281','2025-09-16 16:40:46.9302042',NULL,NULL,N'::1',N''),
	 (N'1BBAECD3-53C9-4B91-8071-77794B852339',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zc80CykyLPfSLQGxtwbNLdhdkRKmJZ0h9i/eh7N6oEU=','2025-10-01 22:43:21.7926392','2025-10-08 22:43:21.7926394',NULL,NULL,N'::1',N''),
	 (N'B0CE255E-69F4-4B0A-9243-78EAB4B45276',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1wrQeyKgzlc5SHV2FQylZfR+HwJfZS05wLfnSfjfIx0=','2025-09-16 18:30:41.7820734','2025-09-23 18:30:41.7821368',NULL,NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'E6A67DEC-3363-44BC-A683-7930F7339BD6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cSg4LBr+1VBm8BUyMEAIaihUoamJgw92CXZw1FQWgKQ=','2025-09-30 19:39:49.8725424','2025-10-07 19:39:49.8725427',NULL,NULL,N'::1',N''),
	 (N'106FC673-868B-4A7A-A8B3-794DA6A93352',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'a5hCHHqqX5GkyaC541PwNzKT1aaG8Xmt6lKLIXvugLc=','2025-10-01 22:39:42.9031514','2025-10-08 22:39:42.9031515','2025-10-01 22:39:48.1899446',NULL,N'::1',N''),
	 (N'46C581BC-C260-4478-97FE-7984D0A8065A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Otsj4s+RfQ1XvpkwUY+YYN6l0EGPHE8iWW7wgOUi0No=','2025-10-06 19:45:57.2483259','2025-10-13 19:45:57.2483261','2025-10-06 19:47:20.0437915',NULL,N'::1',N''),
	 (N'4EE928E9-CF8A-4FC1-8A13-7ABF8BE62427',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OKotf116AbI/KxyKlVlmXUqB813jLjrYUjUXJmmEOx0=','2025-09-30 20:03:06.3978426','2025-10-07 20:03:06.3978428','2025-09-30 20:04:47.9495218',NULL,N'::1',N''),
	 (N'A2BF0AAA-E41E-4B62-BC5A-7B8A058C665F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'FujZYnTRjU458ZwQ08/SL333OoJM7EOzjw7bUt107Ps=','2025-09-16 21:55:26.8409836','2025-09-23 21:55:26.8410452',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'7BA0308C-112F-47D0-8A72-7DABE2084717',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'g0NIUeLu1eRRYsZFCCtaSbQhCnIVbZgNuq+Ly8S4AA0=','2025-10-01 22:01:30.7502632','2025-10-08 22:01:30.7502633',NULL,NULL,N'::1',N''),
	 (N'B1318A7A-512D-4312-A2B4-7E05F7BEBFB8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'LKrMXKXT0tNvcyZ/78Xcc78Dkz7rbDkHCpd6tXBmLYo=','2025-10-01 21:27:27.0652762','2025-10-08 21:27:27.0652769',NULL,NULL,N'::1',N''),
	 (N'6756F6D4-C6ED-430A-B34D-7E14A5DB28F7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'HNC1km0EGiUaCXZxjokrtW+A82ol+gXn/ssyreln7t8=','2025-09-24 21:55:51.3169391','2025-10-01 21:55:51.3169395',NULL,NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'878659D4-E0A7-44BB-9453-7F937D6F2E80',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'va8jAVjZaO1Y/6Ti5zJso9buK0lUgViGVVqoXumHqOA=','2025-09-23 19:11:35.4783415','2025-09-30 19:11:35.4784332',NULL,NULL,N'::1',N''),
	 (N'C328E129-6162-4B42-A425-80A6E76BA217',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/9DfefDfSBOXAjXNdcBehYtcrJcyKmO17ahdFh6Sbg0=','2025-09-30 21:16:55.5325665','2025-10-07 21:16:55.5326308',NULL,NULL,N'::1',N''),
	 (N'7922D667-B14E-47B7-B05F-8192D127251E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'G5kprs/S5mSGDDf2zY/n6hPv8DX79vY+W7pWS6h52Pg=','2025-09-08 21:40:08.1010160','2025-09-15 21:40:08.1010947',NULL,NULL,N'::1',N''),
	 (N'92BFC782-0F81-4700-823B-86AE8C6DECF9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'LweQHxJ6MqWvu2BKEC1nfSRStmnNnopd+bFTRyjCdV4=','2025-10-03 19:20:37.8398864','2025-10-10 19:20:37.8400250','2025-10-03 19:21:59.8204673',NULL,N'::1',N''),
	 (N'2B5CB21D-5FAC-4D6A-BF67-86D8B5311D42',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Ap6FlO9bIZKb7QLg8bcv0h+oYxwot3E/bmqNkxD7b1w=','2025-10-01 19:46:16.2337584','2025-10-08 19:46:16.2339767',NULL,NULL,N'::1',N''),
	 (N'3AB6A3A5-E87A-4E71-85BB-86E0BE7D21D3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wr8mOHmun7o7Pn6gkyXMrTwiACbuaTN2qpQeakl+ZmU=','2025-09-09 03:32:05.0591173','2025-09-16 03:32:05.0591921',NULL,NULL,N'::1',N''),
	 (N'07EB9919-5D5C-4691-B406-86E79882D639',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7Xz8m9oaBRt5qV6TSLTVeyRHCHiHsIX1BSz75VgJv/0=','2025-10-01 22:19:27.3200014','2025-10-08 22:19:27.3200016',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'EB45509D-E5E3-48A4-8B0F-875E870F5BB8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KtWoT8PjMz3pnfL6O9Wz57lZu6pEPSUU3YaL7oczUbA=','2025-09-24 23:44:15.7734321','2025-10-01 23:44:15.7734323',NULL,NULL,N'::1',N''),
	 (N'A1881FC6-0435-4314-9B75-881B0AC2E276',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cfm2cfqqlv9S1bYbG6K2POwMX+/F3iKX9kDURGWfFSs=','2025-10-01 21:30:33.4296426','2025-10-08 21:30:33.4296430','2025-10-01 21:30:43.3585808',NULL,N'::1',N''),
	 (N'AF12BC19-943A-48F1-B930-8876C46D073C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wUcUw8Yp2fiGELcvj4MUEwVGBHd6QbpQIhmDkOU/yik=','2025-10-08 20:35:08.0519220','2025-10-15 20:35:08.0519222',NULL,NULL,N'::1',N''),
	 (N'4394F2A9-E94A-418B-9248-8927CCE78F7C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bw24oleRSFgRwosWOqiooETlA1yfSjIZp624M3cEHrI=','2025-09-17 19:27:46.3868457','2025-09-24 19:27:46.3869221',NULL,NULL,N'::1',N''),
	 (N'1DB8C43E-8AB7-4638-B757-8A13A6EC53A7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'EHI6OoUfc2wUAGMhzkANxH48uTz53YT7NRJTIi7798o=','2025-10-01 19:48:24.1891133','2025-10-08 19:48:24.1891139',NULL,NULL,N'::1',N''),
	 (N'CC22AA90-F3D2-4B69-B0DF-8A8FF3E74084',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GTgGt9xA048lR8g6Ybfgx34lNsswDuPlOkiArvCewgE=','2025-09-10 18:56:46.1090718','2025-09-17 18:56:46.1090720',NULL,NULL,N'::1',N''),
	 (N'3964C479-3AE5-4051-9C08-8B650B4E7242',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GBBfYC31nyppqA1W8BxU61VzHLyDkTsxRu6p42BwZ1k=','2025-09-30 20:12:46.2242317','2025-10-07 20:12:46.2244003',NULL,NULL,N'::1',N''),
	 (N'C4EF92BE-16E3-44CE-9F78-8B96139E5DC8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KrRz/fGQ3Pzgl7OHNOoUgO7qNl2mwXh5I6vYAPF7idQ=','2025-10-03 21:20:15.2057681','2025-10-10 21:20:15.2057684','2025-10-03 21:20:27.0446449',NULL,N'::1',N''),
	 (N'01E7D56E-B741-4F5A-B122-8C9CFF79DC23',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'QQpAHC6xc4k9+gvUALP4jGp2jxHIRQmrc0zAW+xMuSg=','2025-10-01 21:52:37.6431287','2025-10-08 21:52:37.6431289',NULL,NULL,N'::1',N''),
	 (N'08E7A628-DDEE-4448-90B9-8CC05FF7A04B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'mjEOqEJrC/SE6uiFdW8Wknz15xqz3Ni2BUy5ECUYjYQ=','2025-10-01 22:00:54.2460060','2025-10-08 22:00:54.2460063',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'1EFD76D2-A870-47EB-B9C7-918C0326774E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+jFjZPWMT3q5h/rBI2+WoIoLwkmBiP+ZfskrWKZFRak=','2025-10-07 18:51:01.4114214','2025-10-14 18:51:01.4114907',NULL,NULL,N'::1',N''),
	 (N'89BE5385-8D67-4865-B580-92EF9218266F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'988TNFndyyXSyv/1CTfZcaIlShmZkyGF8+1/3oPa38k=','2025-10-03 20:48:58.9289034','2025-10-10 20:48:58.9289034','2025-10-03 20:50:59.2981029',NULL,N'::1',N''),
	 (N'5372BBF3-DEA0-44B4-B3F9-92F07EC32E7F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'I16LIJYm7m3m1MebE1Ok+83x42BcIwOU3znwNcPiu2Q=','2025-09-30 20:59:13.9199353','2025-10-07 20:59:13.9200039',NULL,NULL,N'::1',N''),
	 (N'5F1711F0-01F8-4215-AC2B-9328BFEF54D0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'whSqWH4gQI+2M9QyQIBcBwqPvt356EHB6xbnkC+E+Ng=','2025-10-01 21:59:43.4403418','2025-10-08 21:59:43.4403419',NULL,NULL,N'::1',N''),
	 (N'2A26726E-3F89-4C24-873F-96734302E49D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'og8IxQsZbaOW0dmp2BVwuOpgaX6sbIZ5y7uHKNCLa4k=','2025-09-08 22:14:29.3508411','2025-09-15 22:14:29.3509035',NULL,NULL,N'::1',N''),
	 (N'2B22EAD1-804E-4019-B8AC-971591E67037',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'tlt13CHtOFEgPzrcB75ef5AbB4i9o0y4+Roz0gdH2BQ=','2025-10-01 21:49:34.7917833','2025-10-08 21:49:34.7917837','2025-10-01 21:50:06.3228452',NULL,N'::1',N''),
	 (N'53E28572-7DA3-49DA-835D-97B5303602DE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/VTH5PuV7mvwAKxenbfVVjMgeBXga3V1YmfiMJguonc=','2025-10-07 23:41:33.8064417','2025-10-14 23:41:33.8064419',NULL,NULL,N'::1',N''),
	 (N'EF53C561-27E8-481A-A7AA-98B55B0C900F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kW7FoO52TRIFFPq9Mx0qKITsQs7YfDG42xzfPDnUltg=','2025-09-17 16:27:29.0617130','2025-09-24 16:27:29.0617132',NULL,NULL,N'::1',N''),
	 (N'BF402347-015C-40C5-B249-994F0128027A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5PwYjNBIbqnWUXSvhh/WKbM0CBwydfyYm58coYuaVbg=','2025-09-19 00:09:35.5121357','2025-09-26 00:09:35.5121997',NULL,NULL,N'::1',N''),
	 (N'8ED60E1D-0517-4EBF-91C9-99EEB7CB632E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZwsZ2GpFaI2vcbSqF8Km/La+FXs+9PRZ0J+yr0J4O4M=','2025-10-03 20:15:04.7133068','2025-10-10 20:15:04.7133070','2025-10-03 20:16:29.2605354',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'23F21F65-B127-4096-9F03-9A6D4E6CF614',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uqXrcdY3T7U+5nAMTxwQ0KyySllYSc2TrONAy7buUn8=','2025-10-08 20:09:32.1254100','2025-10-15 20:09:32.1254102',NULL,NULL,N'::1',N''),
	 (N'976CE2A7-48BF-4699-A26D-9B34C5401C02',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OeKxGqJ1MqkhZfcCd+Pz2QF/RPLkAatfqSkMa6wPZC0=','2025-10-03 20:10:08.5557409','2025-10-10 20:10:08.5557413',NULL,NULL,N'::1',N''),
	 (N'D196E0DB-CC55-4BCF-B777-9B8FD61131B9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'94GqZtB2IG4NKweI2A7nUEdNUgjmyxBxW4/yMEgXVwo=','2025-09-17 20:54:12.1029560','2025-09-24 20:54:12.1030434',NULL,NULL,N'::1',N''),
	 (N'E3464ABD-3E18-40F1-A617-9BB25C7AADB0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RrDIuQgGIHEOsNgRNAXGLe8YRnAoQWsbds4qKQ7AOf4=','2025-10-08 18:18:12.8657353','2025-10-15 18:18:12.8657355',NULL,NULL,N'::1',N''),
	 (N'45C32F69-0570-494F-89D7-9BD3CC159DBA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'r2phn+c4Bq/MbuWfodj+5eW8c/hCabt3oIO/wn/ZQvY=','2025-10-03 21:11:28.1443365','2025-10-10 21:11:28.1443366','2025-10-03 21:12:46.1293147',NULL,N'::1',N''),
	 (N'14A4564D-F6BF-43DF-8E1C-9C77D62462A1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jrcDjxizhD/SRL6Sey0UNsK2OWAzDMC8/SxU5qLJzPs=','2025-09-09 19:21:41.7390611','2025-09-16 19:21:41.7391244',NULL,NULL,N'::1',N''),
	 (N'C85265A7-E3CA-45E3-B3C1-9C91FBC496E1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'k/L5IA4Pw6tKlD/LkhgcCaSuzi2RgAwOYgpb5KQjjKs=','2025-09-08 20:34:32.6244251','2025-09-15 20:34:32.6244253',NULL,NULL,N'::1',N''),
	 (N'4D6132A0-E845-494C-8CB4-9D1A506DEB41',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'3+qXfUj44DFo3qCZvsJtznzF/8uVSFF2Mwp3870qvCI=','2025-09-05 21:56:17.3344663','2025-09-12 21:56:17.3345634',NULL,NULL,N'::1',N''),
	 (N'5D99AFDD-C913-4042-995A-9DC80E3D0503',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Jixq7yiSn1lVvezlbP6XcGENpMmQlNgJdDqx3flfAmI=','2025-09-30 23:16:45.1814680','2025-10-07 23:16:45.1815716',NULL,NULL,N'::1',N''),
	 (N'53934DD0-4FEE-49AA-8FD5-9E58D236CEE0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8srx6dFmUxAS2Zq1DM2uz7iZwMV1QeAOnfi+MVz50KM=','2025-10-01 21:51:53.0083491','2025-10-08 21:51:53.0083492','2025-10-01 21:52:37.6623406',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'AC6E1C65-6EF6-4AE0-B514-9EE470710E63',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5LwqpTnbwfigcAKZSCZ+vVh5BenH2h2y6FDmACi4kKc=','2025-09-30 19:15:32.3143340','2025-10-07 19:15:32.3144870',NULL,NULL,N'::1',N''),
	 (N'8B9B9218-4752-4DD4-B77F-9F511E41E7E9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'n8krAJPtdic/Uwz9Z61kXkVUm0WNZvsEy4Gz3S1zJUk=','2025-10-07 18:53:47.2013840','2025-10-14 18:53:47.2013841','2025-10-07 18:55:07.5198039',NULL,N'::1',N''),
	 (N'25F89F8D-C1CC-4982-B605-9FE297D3D84D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IC8oFYKC4h71wDI1eSlbItKGnPjRCCg//ykYzmuc8j4=','2025-10-03 20:28:56.4115511','2025-10-10 20:28:56.4115513','2025-10-03 20:29:28.3616381',NULL,N'::1',N''),
	 (N'2BC8501B-54CA-4F9C-8121-A0B27E124794',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KkqXlyj9tIj3E/CSlkfid569QXLUVqKsabZ2of+xHF4=','2025-10-01 21:50:15.7176497','2025-10-08 21:50:15.7176498',NULL,NULL,N'::1',N''),
	 (N'83EBBD25-F5F4-47D4-B0C9-A175A58B1B76',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'R2Ffj1Msnl93Pfr9rM2EnkhfWA1zcskvS/zfkhJTDto=','2025-10-03 19:38:52.9476031','2025-10-10 19:38:52.9476032',NULL,NULL,N'::1',N''),
	 (N'F74299E3-6607-4E6C-B0D3-A1B61E121721',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'EsMXCGzR0SP/Wv8CvxO8h4s9rMLoQrYCemzvRxEgs8k=','2025-10-03 20:08:42.5456742','2025-10-10 20:08:42.5456743',NULL,NULL,N'::1',N''),
	 (N'53F8A887-A5A6-4C5F-A26E-A31990B06EB9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1/ZgZvsr7sYHFTAHUBBkJz2gXtvAC9Exfck55HdXHPA=','2025-10-06 19:54:01.9881534','2025-10-13 19:54:01.9881537',NULL,NULL,N'::1',N''),
	 (N'CD48DB51-24D7-41DF-8607-A33DA54BCCEC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'HgdrgA13UjQOhtEV3XleVe9K4nq7cv6yDq9l0N1dOmo=','2025-09-17 02:04:21.8543387','2025-09-24 02:04:21.8544001',NULL,NULL,N'::1',N''),
	 (N'AF93BE68-18BC-4C4C-B2EB-A3541F0ACDA4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KWqrjEmw9qIC/dRWtTkpgNMYGORLMntA4AIxu9skWg4=','2025-09-09 00:52:35.6745825','2025-09-16 00:52:35.6746452',NULL,NULL,N'::1',N''),
	 (N'2FE6C95C-D9AD-4098-A939-A3C34DAE668A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'S8FOvO35xXSZS+ofDu4Fzi9q8UqvOwMcOLuUGI4kjdk=','2025-09-16 19:44:02.4543374','2025-09-23 19:44:02.4543375',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'D0E19370-3E6D-4EDA-8C4A-A3D099F0C1EE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'mZolRG2ju5NJAlsqid2eSaNbbKFXXUGEA2htGv87ROc=','2025-09-18 22:26:06.1958564','2025-09-25 22:26:06.1959185',NULL,NULL,N'::1',N''),
	 (N'E6996B90-4226-4B5A-AE3C-A4E6096E8C93',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'yDeytzN59uAsZb36kqr7F1UzLG1Bnn4Jgam6ewM82SE=','2025-09-24 23:41:28.9964515','2025-10-01 23:41:28.9964517',NULL,NULL,N'::1',N''),
	 (N'29222609-85CB-48CC-AE6B-A5029D56EDB2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'yiYTnYosyfr16IGnc8KEBY3kwUVj3fhHjnv7Mo6atY8=','2025-10-03 21:16:27.3730906','2025-10-10 21:16:27.3730910',NULL,NULL,N'::1',N''),
	 (N'BC0C2077-3BA4-4C90-8827-A5156089EA51',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZW4wToHK/7XaD0lvKh1qlaCWKT/ONJq8KPz9iGwWlQE=','2025-10-01 21:01:05.6718103','2025-10-08 21:01:05.6718105',NULL,NULL,N'::1',N''),
	 (N'7B76D686-03C8-4BA3-97EE-A77F652F1A35',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'xOflRcTo2nmCkG3THBI9XT9bBL4SFIXukWaNwksRjQ8=','2025-09-30 19:38:47.5267894','2025-10-07 19:38:47.5267898',NULL,NULL,N'::1',N''),
	 (N'264957BF-12AE-4E31-9746-A79C0760EB28',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6v0rZT1FVzUwWDE6KgaNWuN4oNVVQbHTCk2zKpRHhBg=','2025-09-05 21:59:59.5405255','2025-09-12 21:59:59.5405258',NULL,NULL,N'::1',N''),
	 (N'3D37D1DF-BBC1-4998-930E-A7E3C9693249',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'G1szuHm9RGrKlr+djYWV3vtZM0Qdb522zmdFtzgGSK4=','2025-09-16 20:16:06.1356958','2025-09-23 20:16:06.1357826',NULL,NULL,N'::1',N''),
	 (N'9445A843-CF3E-46D1-BC59-A85BB6AD3825',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'rlWHUE+xGtAjZh13Aar1k77iMdaMtC048q7CO/RVgGs=','2025-10-03 20:29:28.3300228','2025-10-10 20:29:28.3300229',NULL,NULL,N'::1',N''),
	 (N'D6A5DD46-9936-44A0-8FA3-A8B28EE153B9',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KDlr/PgtQn9pXT7rCTFC5A1gFeJJtXVNlCSz8lSLytQ=','2025-09-05 23:24:39.2708392','2025-09-12 23:24:39.2709125',NULL,NULL,N'::1',N''),
	 (N'C0547E4C-D1CA-48B3-B833-A9AE3B562B57',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'4nUWxh5XBHOEGlJDkIuxSj4G6RpLqNwUHSWgpd1IOQM=','2025-09-30 19:54:36.4637822','2025-10-07 19:54:36.4637827',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'F479FBE4-9B5D-4FCB-B903-AA15AA74A22C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IbYotmPMFiGC4WwGkQsax7Ak5DUq/wERjvMnpr0WHgA=','2025-10-03 21:20:26.9390484','2025-10-10 21:20:26.9390489','2025-10-03 21:20:38.7412681',NULL,N'::1',N''),
	 (N'6901DC7A-594B-4368-A70F-AA7F7F97629B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ptSnoJ6YC7U66gW1+T7dXeMAq8OlGfYrNKCDnVCvaF4=','2025-09-24 23:31:13.8248308','2025-10-01 23:31:13.8248310',NULL,NULL,N'::1',N''),
	 (N'87477E60-04C0-4C0B-92DF-AA91D50BF7A3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'23jkVYtfOV4vyapRQgH4ypIdXdhKAU4JN6qRkIa1hvg=','2025-09-09 18:26:05.0403461','2025-09-16 18:26:05.0404136',NULL,NULL,N'::1',N''),
	 (N'78794A61-A739-41EB-B810-AAC2E5EABC52',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RlR7DGCWYwkR4w+22bGoanpX/HhokRQgRWE8ML9HlVs=','2025-09-22 19:48:15.6067250','2025-09-29 19:48:15.6068047',NULL,NULL,N'::1',N''),
	 (N'813A5D9D-B456-4DDA-BA33-AAE056ED38A7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ciS64VVmvPNE22Zbb1OTjyhlyyq5KS977TL/aFz3/qo=','2025-09-17 02:04:23.0272547','2025-09-24 02:04:23.0272549',NULL,NULL,N'::1',N''),
	 (N'CDD89326-D7E4-4FBD-86A6-AAFB71FA630C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZklEKnHCzAfHOWY+aDoLYTtJTADzQp0Lm6MrR6i2LoY=','2025-09-17 17:05:59.9438745','2025-09-24 17:05:59.9438748',NULL,NULL,N'::1',N''),
	 (N'1E97BA76-BA27-47E5-ADAB-AB6677E7F342',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'HJxacH4vhdvRrwJxbhK1bkUVgM9EjcoD+wu/28VGrl8=','2025-09-17 01:27:50.6330637','2025-09-24 01:27:50.6331279',NULL,NULL,N'::1',N''),
	 (N'9077B053-6FCD-49BF-9276-AB6EC4A8F4BA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'SfXBF4ZMDF319niXTIbXpK2JE++6HWDsym+oHya0xXY=','2025-09-29 22:03:20.9894228','2025-10-06 22:03:20.9894877',NULL,NULL,N'::1',N''),
	 (N'6A97A63D-180A-4F96-9142-AE3795C13AD8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Xyi5DpyA8Qxz89B6e4jdKOId9OaMLoak8hoyZUuG+z4=','2025-10-03 19:21:59.7785075','2025-10-10 19:21:59.7785077',NULL,NULL,N'::1',N''),
	 (N'5094295A-3FA6-419F-AC21-AE96B19A8FC5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'zLdC0k57WVTBxe1/mwMf4LEYCiAPrO7pA7ofbt3iVoo=','2025-10-01 22:43:41.6680506','2025-10-08 22:43:41.6680507','2025-10-01 22:44:46.1641257',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'FC52A663-D4F3-45A6-837C-AF44AAC3C746',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'XEk7DH1d6WzX7xStggwoxYBRV3Wyxbd8aJCe2fg0oAU=','2025-09-18 21:59:31.8304858','2025-09-25 21:59:31.8304859',NULL,NULL,N'::1',N''),
	 (N'8D2C88F0-DC75-42F5-97FA-B150F4BB87A1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dgjWnme8U0dEqtMUZzf0uqmdYTYc9i8w/T+ziAVmjO4=','2025-10-01 22:18:46.4456585','2025-10-08 22:18:46.4456586',NULL,NULL,N'::1',N''),
	 (N'52407D6D-8877-4D8A-B838-B15C2C5AFDBE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'25ISNOGuHEwKYr/gh0ks3JNuwMlutVY8N6IhvLVYkFQ=','2025-10-03 20:52:48.7856218','2025-10-10 20:52:48.7856219','2025-10-03 20:53:22.3753538',NULL,N'::1',N''),
	 (N'0F34AA4A-37A8-4385-99DB-B183B9CEAB49',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0nZU1k5bE1O218YinTJX3nwKihO7UWmkBhJOz2WNdCc=','2025-10-03 20:36:07.6178567','2025-10-10 20:36:07.6178569',NULL,NULL,N'::1',N''),
	 (N'50D687B0-D9E7-485B-B741-B198581E6B44',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Ll2DPYWi5DMo30PcnRqFHPDuQ75W4aKC6tLFd/l47RQ=','2025-09-17 16:12:43.1057791','2025-09-24 16:12:43.1058933',NULL,NULL,N'::1',N''),
	 (N'DAA2009D-1E4B-4C09-8200-B240E4F7D672',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kD3AAnPeJQ7Yrlgd9SuMLUnml1MHQIPaWGNAdHn8hyc=','2025-09-18 23:45:47.7395899','2025-09-25 23:45:47.7396662',NULL,NULL,N'::1',N''),
	 (N'8DD7DDB0-5C89-46B0-B44C-B24242557CC2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'e9J0WCgQDIoDGzbyx2n//zLUsGzHWi/pp0VTMCNxcpU=','2025-09-17 01:14:48.0386540','2025-09-24 01:14:48.0387202',NULL,NULL,N'::1',N''),
	 (N'C5174B82-4745-405D-B4D7-B2831AC76970',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+yg7AEwNrQr7+13+Ncv5XEDs1SIWngDNddsj1m7rwuk=','2025-10-03 20:43:45.1145807','2025-10-10 20:43:45.1145809','2025-10-03 20:45:36.7394208',NULL,N'::1',N''),
	 (N'F8DB257C-5A52-4CD3-95ED-B2C7EEDADA25',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'OYkcw/ucAp1rLuUi99sJwXX2KZIg8dU5q0r73oeZsOo=','2025-09-30 19:30:46.1312644','2025-10-07 19:30:46.1312652',NULL,NULL,N'::1',N''),
	 (N'829FDA7E-55BE-49C0-909F-B2FC24A9648F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'uhxyYZEzUo/qet6+NBvkCdkgV/3sxLwTQMqXcbEnMiY=','2025-09-10 18:53:08.0413721','2025-09-17 18:53:08.0413722',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'B5BC1AF0-3BE5-41A1-A546-B4A6D9CF8A3D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'N6Dj4T90AMsWjLCJaNiln7zzvU6L6HwN5v3iAEiTbeg=','2025-09-16 19:44:49.0483008','2025-09-23 19:44:49.0483009',NULL,NULL,N'::1',N''),
	 (N'6FE0A243-A307-4A13-8D0D-B4E7B30E1BE0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'R3Ix7lZX7mp2s5ObSd3OriHN6veMNpYyqgZ1DEyr/DI=','2025-10-03 19:40:18.5914573','2025-10-10 19:40:18.5914576','2025-10-03 19:41:39.1528582',NULL,N'::1',N''),
	 (N'7E9FBF3A-220A-4F71-A13F-B4EE92A8B511',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'8sTfawhPgWeqXT2YbvVpZC2k6QXb26xRJptJWUzRu/8=','2025-09-17 01:33:40.8317936','2025-09-24 01:33:40.8318556',NULL,NULL,N'::1',N''),
	 (N'6E81B337-8052-494F-8751-B66D3A3917DE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'05ETPYvNRn68cZ42XGh5OXeNhd3VI5DHcAG2i8Qr/ls=','2025-10-07 17:08:55.2953345','2025-10-14 17:08:55.2953346',NULL,NULL,N'::1',N''),
	 (N'CA944A13-0528-4D27-B621-B7B36FA24FCC',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'SWdmsGlFa3D65cGq5fryv8L8tAS34yUF74rKTLrR7Sc=','2025-09-17 16:43:02.5933557','2025-09-24 16:43:02.5934325',NULL,NULL,N'::1',N''),
	 (N'EF036A18-B1C4-4A71-89F2-B85C4E07AC97',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kMn/5wRfRx8gSTxVQ7wq1+NcTKmID1Vtr6Uw614aOHw=','2025-09-24 22:21:13.2016959','2025-10-01 22:21:13.2017629',NULL,NULL,N'::1',N''),
	 (N'091F2B41-63D1-4D41-A0F9-B886E626C070',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dKpIwKJ4JJ4XyocaV4Pgp6xITakfwzg5PrZwv2zDsBM=','2025-09-09 17:33:23.3108437','2025-09-16 17:33:23.3109209',NULL,NULL,N'::1',N''),
	 (N'C01F852B-12BE-426C-810B-B91DA595CD7B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cyvtRgkzy5kdNiIzbvM10b4cOi8TPqYu4i4SH9X5xwo=','2025-09-05 22:55:56.5271142','2025-09-12 22:55:56.5271143',NULL,NULL,N'::1',N''),
	 (N'6F07BA51-7258-4D95-8A18-B9F3429DF151',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2P7h6yQzhRccE38bUKhRcEvlQPjvvtDPlZZj1HqqxWw=','2025-09-17 16:39:15.9028231','2025-09-24 16:39:15.9028232',NULL,NULL,N'::1',N''),
	 (N'D9BD2BC9-A7B9-4F6F-9DC0-BA5220F62F86',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'EWe5/XiixLY6WBxFiJ4oyXNubdd4h9ZP8gUN4sCugFw=','2025-09-30 20:45:30.8364049','2025-10-07 20:45:30.8364839',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'D3C8D1A4-D665-4102-8A7E-BB047279A024',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'j2SP6mf5vXnLjkYWLkBnrRonF0oceHA+oLIqoQUavKI=','2025-10-03 21:08:00.2613152','2025-10-10 21:08:00.2613153','2025-10-03 21:09:19.4741719',NULL,N'::1',N''),
	 (N'29DB304C-A16E-42CB-9884-BB60764B43EE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'awuBjJsBxDlvsq2DF0XGQsDtU4VyYAn0IpN73K9apzE=','2025-10-03 20:34:13.3107994','2025-10-10 20:34:13.3107995','2025-10-03 20:36:07.6552090',NULL,N'::1',N''),
	 (N'20192C6C-F73D-4B91-BBAA-BBF41D4EE8B8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'C+vmCyzT/Otl6NuEjTaV+6UmyqajDsZjk7OPkvWUEdU=','2025-09-17 17:58:13.8522872','2025-09-24 17:58:13.8522873',NULL,NULL,N'::1',N''),
	 (N'BDC4A41C-3F1B-42A5-A609-BC0DFBA091BF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7nJ+1fLc9fUcvRx4V1ax0l4X6r+xM6XAePCIxgmpyX4=','2025-09-17 20:11:44.5830510','2025-09-24 20:11:44.5831291',NULL,NULL,N'::1',N''),
	 (N'D9B9708C-6EDA-46D3-A6E4-BC23BB84600F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'v/wDp1to9xPDrAyxlApMiAPMDnPiLx7inuNkH59XQE0=','2025-09-30 22:31:46.5850824','2025-10-07 22:31:46.5850825',NULL,NULL,N'::1',N''),
	 (N'84D4D4A2-EA47-47D9-BA3F-BD0D7CE9E874',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Fj7oLVjpY0t7tjWekEH5dCeQFtbHbaWrol9pXyOG3eY=','2025-09-30 20:04:47.8915122','2025-10-07 20:04:47.8915125',NULL,NULL,N'::1',N''),
	 (N'67345C1B-A5EB-4B5F-ADA9-BD799D311B95',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'I0oTjEzwvuepyqnkNDTCmMbrzM2stoeIljc5IjNIX5g=','2025-10-03 21:11:00.2723361','2025-10-10 21:11:00.2723362',NULL,NULL,N'::1',N''),
	 (N'C40DD883-F58B-404B-B655-BE2A3BADAC94',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jTfdJ8W5jbTTPUMPbjFbSEb0ALMHuIHdzli5VuumxvM=','2025-09-23 22:28:24.9633200','2025-09-30 22:28:24.9633842',NULL,NULL,N'::1',N''),
	 (N'4267A8C2-76AD-4F03-9B4C-BE71890FCB58',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'nyuOF+zPqfIIWINDMby6sW2sh1/Yni9ynomyip+uqWw=','2025-09-30 19:33:52.9676576','2025-10-07 19:33:52.9676579',NULL,NULL,N'::1',N''),
	 (N'C771E1CF-4F17-47C7-8898-BED0F00807F1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vDO8uC3u6n+ZijmlOcHRlxFeneDW/Lg6CByIZTTiShg=','2025-10-06 19:35:23.7459417','2025-10-13 19:35:23.7459418','2025-10-06 19:36:44.9995176',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'0BBB69B0-7933-44FB-8624-BED30A9B1D52',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'FyEIj8Uts2RIpejYCMgP2hCosMNpC9cHQcNV7BqqGOM=','2025-10-08 20:20:19.3474059','2025-10-15 20:20:19.3474061',NULL,NULL,N'::1',N''),
	 (N'6B483A32-084A-4217-A862-BF01CBEFF340',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'BiiFUXlL21C5sbOE0iub7DDnXE4PgGEGotmJKj3/22Y=','2025-10-03 21:09:19.4356110','2025-10-10 21:09:19.4356111',NULL,NULL,N'::1',N''),
	 (N'C35CC362-67BB-4901-AE85-C5612886AA26',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'irYUyRwSLb24KSL3xwEJjNmSW07kTbb9EOqoo5mqI4I=','2025-09-30 20:00:10.0188351','2025-10-07 20:00:10.0188352',NULL,NULL,N'::1',N''),
	 (N'1FF8D8C3-B199-4ACA-931B-C5911AAE6B22',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bTR0jPjZ8FVUR/Px3Lbel4cdpoVNQZx1EYpySMmDUUw=','2025-09-24 21:49:24.5392571','2025-10-01 21:49:24.5393569',NULL,NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'276D3890-4EF4-470C-8413-C5A91AA3E1AD',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'fDrWCIaz3rR4zSs8lCgS9grdagZNmLnxPgUX++t5npc=','2025-10-07 18:20:12.0376848','2025-10-14 18:20:12.0377360','2025-10-07 18:20:16.0555546',NULL,N'::1',N''),
	 (N'AC679507-783F-48DA-BA48-C5F4A7373479',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'FDQQ6RPtpHvO94Cin4JtM5377NZ4URXxl6LZcG+gH28=','2025-10-03 20:39:51.9786266','2025-10-10 20:39:51.9786268','2025-10-03 20:43:59.9034742',NULL,N'::1',N''),
	 (N'2B39331E-4A99-4B45-BCDD-C6A734F92845',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'e3Aeuas/uMlHjFL5Rbbgt9KS9si3nlV1nMJ+L0CBAAg=','2025-10-03 20:51:35.9831597','2025-10-10 20:51:35.9831598','2025-10-03 20:52:48.8294844',NULL,N'::1',N''),
	 (N'5D2AD1FC-CB3B-4A55-ABA9-C6FAC0719E4A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kvw+J8/251uHHqimcrgycT3HBHp8l/BAuX3dIoy48V0=','2025-09-10 18:51:20.0350029','2025-09-17 18:51:20.0350030',NULL,NULL,N'::1',N''),
	 (N'E3FC7A8C-D95C-4C33-8DE0-C792C4410DD0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RIofIAPRfYGuF3B4rdtNbCLw9xytGTdY2N5Hi5h2rgg=','2025-10-03 21:07:25.0590224','2025-10-10 21:07:25.0590888',NULL,NULL,N'::1',N''),
	 (N'428E1D99-A502-4370-B430-C7C0A0E2A44B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wggZqjxq0JeC+OmmlmNUCtqgzyMPgTnMdWudI9Bxs6E=','2025-10-09 18:39:17.6221875','2025-10-16 18:39:17.6222681',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'B8B2507A-0B0C-44EC-8156-C8E910703BF4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'cSeryTY4oCs7vIVEAhn4bB4ssDQbvY7+aLx5qnSPTf8=','2025-09-05 23:17:08.2685522','2025-09-12 23:17:08.2686470',NULL,NULL,N'::1',N''),
	 (N'902AB498-8860-4FEF-879F-C9364494A907',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'aIrjKd75h/83tj1H8siYU4NbRZt1B+J7v8oyyGFyBrw=','2025-10-07 17:07:12.8461399','2025-10-14 17:07:12.8462873',NULL,NULL,N'::1',N''),
	 (N'D6ED1821-5687-4953-8CEB-C9BF3FB7E22B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'w6+5Egidt8oEth6n1XfUFyNXr3NhI8Wjl130uSMVQUE=','2025-09-30 20:08:05.4167211','2025-10-07 20:08:05.4167215','2025-09-30 20:09:22.1912365',NULL,N'::1',N''),
	 (N'FA26D369-84DB-4C78-8816-C9F6440507A6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'B+BqDDhRzNzye4jAo/r1kd4MrKj9q0ZfwTrTORLCHFI=','2025-10-07 18:55:07.5132253','2025-10-14 18:55:07.5132253',NULL,NULL,N'::1',N''),
	 (N'6AE801F4-F89F-43D8-A44D-CA0CDC8BDC48',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ZsUYyqNz7kMUZ2skFZbp31UNffRZH/+k//iG2ASsr2U=','2025-09-23 19:04:07.1908577','2025-09-30 19:04:07.1909427',NULL,NULL,N'::1',N''),
	 (N'57096379-C8E9-4CCC-BFE6-CB594EC41FE7',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Bsk+WlZzspTw33murt0fkp6Mr5p4CT08GN7d33Acs7w=','2025-10-03 20:10:33.3035888','2025-10-10 20:10:33.3035889',NULL,NULL,N'::1',N''),
	 (N'CD38C3F4-B44A-47AD-8962-CDD5BBE6D165',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bwgu765stRO9nH0UEoPvettTx0S+oySSvwwR50B2BWI=','2025-10-03 21:21:05.6162599','2025-10-10 21:21:05.6162603','2025-10-03 21:22:22.3384445',NULL,N'::1',N''),
	 (N'E036FB77-1966-4B3A-809D-CDE62D785227',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1oUJBtotZowv3aXBWasBcp9Di/Q7kiDkNeTyFKuqhqM=','2025-09-05 22:58:46.7302673','2025-09-12 22:58:46.7302675',NULL,NULL,N'::1',N''),
	 (N'79D93B66-E2E7-46AD-B2DD-CEDB68923BD8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'7XtRXmypY1v9Nx7WOYXu+4EiYdp3yh3cZy+fwn13VEE=','2025-09-08 20:31:35.7975735','2025-09-15 20:31:35.7981518',NULL,NULL,N'::1',N''),
	 (N'3E2B089C-FF57-472A-98BF-CF4F5BC388A3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'o5sZvgquRTd4GKC6x2yi4FgrSSTljOK4OJf9vvB+ncc=','2025-09-22 23:05:58.4680778','2025-09-29 23:05:58.4681402',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'0005DFA2-357B-40C4-B750-CF749D6E5D35',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dMYq7bwx5cB4Byups8/hGJ/W2TLOR/+3maabl7Yjf6c=','2025-09-09 00:54:21.9785838','2025-09-16 00:54:21.9785844',NULL,NULL,N'::1',N''),
	 (N'31C4E951-B324-4C51-AD85-D0246B66D807',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ETWFiOusP2gtBhM7ztQkxNNDOzw8lm/q6yl85k9j0js=','2025-10-07 18:59:42.7975035','2025-10-14 18:59:42.7975036',NULL,NULL,N'::1',N''),
	 (N'80640F96-0D51-4A12-AC48-D1ADE9955FC0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0ZX7EpZpBrt7vcoI0g6dH1s+UQUvBE8eecfS/FqI52s=','2025-10-03 21:18:52.6710946','2025-10-10 21:18:52.6710951','2025-10-03 21:20:15.2973840',NULL,N'::1',N''),
	 (N'FEAD1491-F762-42DB-81D8-D1BDCA6323D4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'TT3m6WUm93Qr3B5oM1n5RyoqMyP/zIRjbHlm+O7mwnU=','2025-10-07 17:07:12.8461162','2025-10-14 17:07:12.8462718',NULL,NULL,N'::1',N''),
	 (N'EDE63232-5E4C-4DF6-99A7-D2E63BA2B64E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GlUB6Rq3PbVJeEzDDwU/6x3k5N4G36AcDQ8KxJUsBbo=','2025-09-30 19:44:15.9889698','2025-10-07 19:44:15.9890450',NULL,NULL,N'::1',N''),
	 (N'13876709-C465-4431-A70F-D3D816394091',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'h7Qrta75fO2fuVcd0VWvt7mVuD3gg4vcsPB5RVOEkac=','2025-10-03 21:02:58.3164470','2025-10-10 21:02:58.3164471',NULL,NULL,N'::1',N''),
	 (N'0234B8EF-222C-475D-9D17-D50861D2EA96',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'wxy9YMh3FjRM1Ww6/4JMZSo03Z1hxcRgcpPRXE0DfOk=','2025-09-22 19:06:55.9553310','2025-09-29 19:06:55.9554018',NULL,NULL,N'::1',N''),
	 (N'43F06E8D-F64C-42DC-8689-D5ED92755885',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'QL9SvBuSDyqee5z/uLZpljWtIBjqeQw7oKTC7OO4HFg=','2025-10-08 20:22:50.7509621','2025-10-15 20:22:50.7509623',NULL,NULL,N'::1',N''),
	 (N'C7BF067D-C1B6-436D-8F22-D5FC29032854',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Wtmon5YLo5WyCdE4W3ldmisMWic5vKjSoacNtRiIqac=','2025-09-05 22:40:21.3031051','2025-09-12 22:40:21.3031054',NULL,NULL,N'::1',N''),
	 (N'499A7D58-D772-4312-BF1C-D62211C7ECBE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'lD5LHlHO50nQuWOJWHoksMso4grOTOlVBi9S3gjLAH4=','2025-09-09 01:44:24.3156520','2025-09-16 01:44:24.3157161',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'7AFA7487-8537-4B49-BDE7-D6F46B78A594',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'KlJ09kfcHHZ39wFR8caXxjfEkEzEFS747dwOqmMhE6s=','2025-10-01 21:27:51.3105169','2025-10-08 21:27:51.3105174',NULL,NULL,N'::1',N''),
	 (N'75EE3413-BABE-4FE6-96CE-D7B5C5FA81BE',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'M4uV5hOtzEQhthY657b6RaK/HnDhZWyvnKk8QLbvt+o=','2025-10-07 19:16:06.1675767','2025-10-14 19:16:06.1676215',NULL,NULL,N'::1',N''),
	 (N'978DA4D6-8B4A-4F7C-8D96-D80B2BCF3E08',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0D8hZdOzRJ83KJKrI8hIBg8JVm1bGmpwIX2We/JusNc=','2025-10-08 17:53:23.7159755','2025-10-15 17:53:23.7160522',NULL,NULL,N'::1',N''),
	 (N'FDFAAB06-38D1-413C-AE8E-D8660B71878A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RsUp1tja3puBz+T7v1kHsTKEeKk7kjB/nsdPzOmnyOs=','2025-09-18 17:43:36.5320072','2025-09-25 17:43:36.5321024',NULL,NULL,N'::1',N''),
	 (N'3DBCA60A-93C9-40CF-81CB-D87FCCD5A640',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1f3iofv0lI3wXOw/A4ll5E0tLdPCWjRe56uS/vQTYlA=','2025-10-06 19:36:44.9478681','2025-10-13 19:36:44.9478683',NULL,NULL,N'::1',N''),
	 (N'4872F158-1718-41A0-BCC2-D98253E0224C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vdcz91sK/nlo8wFeO0/r5j+1mL1EuZwUrHtuqZ1VFVM=','2025-10-01 22:46:30.8123128','2025-10-08 22:46:30.8123129',NULL,NULL,N'::1',N''),
	 (N'22D5646F-48F9-4535-915D-D99C034B1BC6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RooD9R8/8fOJ3YhhgooNsZCdt9L5pYNTZ288y3JAbnQ=','2025-10-03 21:12:46.0945864','2025-10-10 21:12:46.0945865',NULL,NULL,N'::1',N''),
	 (N'905DDB56-AA3A-4182-BFDB-DA53A7B574F6',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'IbeUfglbZTHEzAqw+jiguCiEOL1dd9FV+T57GPTLjiQ=','2025-09-22 23:13:32.0218469','2025-09-29 23:13:32.0219089',NULL,NULL,N'::1',N''),
	 (N'6FDE9664-E0A5-4D3F-BA53-DA8EA0563169',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9aAhfFyDBg3MdLT/PXvoneA0JCV0ADmUMagyJcLsiqw=','2025-09-10 18:27:38.4326310','2025-09-17 18:27:38.4326312',NULL,NULL,N'::1',N''),
	 (N'26036D44-092C-4759-AF7C-DABC69305353',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0zh4oF+/+lIJGln/PrK2CDW16fRg74J0aUyzMV62XkU=','2025-09-17 02:08:36.5486707','2025-09-24 02:08:36.5487443',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'EA04C95F-B8D9-4B96-9974-DB235EC600C0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6n5vBJYAsYpwUlcVshwd3ff/kD1S3xIBLZfkLe2L3sg=','2025-10-01 20:22:24.2845650','2025-10-08 20:22:24.2845657',NULL,NULL,N'::1',N''),
	 (N'29FB0DB9-2091-4392-ABA2-DBB712493B95',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'VLZK+Oy/dNsk1FtnJEFOgMsJUVj/tGFrZXBCyUpZU90=','2025-09-18 21:59:57.0464455','2025-09-25 21:59:57.0464456',NULL,NULL,N'::1',N''),
	 (N'5DB321EA-B7CC-4D46-9C58-DC89E055F5F4',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'yb8VyrG2t95A3qaUFJDxGj7MerHLMJ5PaWLNANa1uF0=','2025-10-01 21:28:39.8395423','2025-10-08 21:28:39.8395426',NULL,NULL,N'::1',N''),
	 (N'0A35FBE7-D91C-47F5-84C0-DD1306712A86',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'VWlNa9dvKKza7XiEEH2OEUJwH7GiS/XJB3i4who1/DE=','2025-09-30 19:48:14.7780605','2025-10-07 19:48:14.7780611',NULL,NULL,N'::1',N''),
	 (N'7D2987B7-CEF3-4DB0-829C-DE1F01103FA0',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'PKlMtYyCESSsTzVXVl6wl1nTjbX6t1eQ9rteKfx2dss=','2025-09-19 00:27:55.5095214','2025-09-26 00:27:55.5095860',NULL,NULL,N'::1',N''),
	 (N'E366C614-C7A0-4C42-98FC-E06238D9F195',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'L4o7NhrE7ZhK3qMerwcjrE7TNDf3Dqd0/ydYI8je1GQ=','2025-10-01 21:35:19.7837052','2025-10-08 21:35:19.7837055',NULL,NULL,N'::1',N''),
	 (N'896BB177-1BF5-4CFC-AD1A-E08CB9A6225C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'UYEA6PHZfaAMeElmaySrABdQ5SC0MUVFZW3ysLxbjwY=','2025-09-23 19:57:23.7827165','2025-09-30 19:57:23.7828102',NULL,NULL,N'::1',N''),
	 (N'FE43086B-3450-4CBA-8C4E-E334A9462593',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'3SwCjFpS6vKWY+R5kd4zlFLsCC43AxUnWyuMwsDnUow=','2025-09-16 18:32:02.4659893','2025-09-23 18:32:02.4659894',NULL,NULL,N'::1',N''),
	 (N'8A9ADC82-1977-4FE6-88BC-E33EC1EB6FCA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'kGGvDsqh+XKwIMQ1T1OCsgqLx09cYYO/hqvySblEvMA=','2025-10-01 22:39:47.6010861','2025-10-08 22:39:47.6010866',NULL,NULL,N'::1',N''),
	 (N'27C6076D-30B9-4EC4-9B32-E45D7C43D741',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'2v5FWjZzLheO4gPhbbTLeZocldFmjAiTmkPbwiwdrNQ=','2025-10-01 21:30:43.3255002','2025-10-08 21:30:43.3255004','2025-10-01 21:30:51.8894843',NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'8F6D8DF1-6DBC-474C-AF2A-E533F0179C1C',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'gj7VmARdb88Ysimja0tdcCc7IfTE5SiKNXeRtNGJlGI=','2025-10-09 00:11:55.1469725','2025-10-16 00:11:55.1470572',NULL,NULL,N'::1',N''),
	 (N'894B242E-7A67-4243-9FA0-E5755211F09B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'1rOOvfXOpkeXETX5k5moHxaE5Afr/XEiARrNlgW26rM=','2025-10-01 21:38:01.2985854','2025-10-08 21:38:01.2985857','2025-10-01 21:38:11.0442084',NULL,N'::1',N''),
	 (N'9871049B-0699-4961-8DF8-E5AF4ACCFAF2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jUWgP1+ar3FRtRyDmeX+yfQUWwfkz4jO5RfvrwSF1v4=','2025-09-17 21:10:39.4859593','2025-09-24 21:10:39.4860194',NULL,NULL,N'::1',N''),
	 (N'883236A6-50E1-470E-AA78-E5D4C31D67F2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'sKPiihAc8Z0CK/8J5WigyU35oSAO4nO/BU389SdStHk=','2025-09-24 21:48:17.1684022','2025-10-01 21:48:17.1685049',NULL,NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'45281CC6-ECAE-4507-9491-E76263A88507',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0HDBB8pAvEGLNS7s52f8W85E7pvCh2pE0qSKA1SQo/Q=','2025-10-03 19:45:51.4468582','2025-10-10 19:45:51.4468585','2025-10-03 19:47:05.9548838',NULL,N'::1',N''),
	 (N'B1630D0A-6032-48D3-9772-E7D919B1CE1A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'yjtdX19SbRsIaaniaNmtmIDl6xoNcsM94/1bbG7b3mg=','2025-10-01 22:37:52.0236662','2025-10-08 22:37:52.0236663',NULL,NULL,N'::1',N''),
	 (N'8C0B0ADE-320B-4761-959C-E8700102820B',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'/E2lkjkQ2S914aZhEJQaRXbu87Ty3D0hpz0RPW4DMpA=','2025-09-16 19:56:57.0798564','2025-09-23 19:56:57.0799196',NULL,NULL,N'::1',N''),
	 (N'41AB6AB2-39D6-403D-BCE8-E8CF41051B69',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'+JaLqTT2Umcug0B9+3I9TG3l8NA0zHjBfqIt6icW6Lo=','2025-10-01 22:17:30.0232900','2025-10-08 22:17:30.0232901','2025-10-01 22:18:46.5020383',NULL,N'::1',N''),
	 (N'928A82F0-DC5C-424E-85A3-E949B107682F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'etLRV7VPb2ObTWzVnKQmYqcBgYfAj86c5aaiBKkUltM=','2025-10-09 16:43:38.0779013','2025-10-16 16:43:38.0779788','2025-10-09 16:43:44.7348961',NULL,N'::1',N''),
	 (N'53283D3F-CEA9-4BAB-9FAF-EA1CF8B1A72D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'L0rtJ1g3EJGv2rZjDPq1xC7z2W1iUDl7SP/mBe4NFFc=','2025-09-29 22:15:47.6179861','2025-10-06 22:15:47.6179863',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'69106BA0-65B0-4032-AE42-EA9BA5745107',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'safmQ49dt2jGGDC8+4QSGLmnjUCMo0n8dCEzN0ZNTL0=','2025-09-22 18:55:47.1442203','2025-09-29 18:55:47.1442207',NULL,NULL,N'::1',N''),
	 (N'5334D931-02DC-41D4-9621-EAC940874C6D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'0trSCiDWzDBW3J+v4DlukAepBfQkMH77cJAEfq1gXzs=','2025-10-03 20:11:41.2142944','2025-10-10 20:11:41.2142945',NULL,NULL,N'::1',N''),
	 (N'779F435A-CFB3-4A26-BB68-EACF225A8339',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'o15hwjcXyVqEmh8t6EW7kaBf1y4MBqpB16qhbDU312k=','2025-09-17 01:14:48.0386483','2025-09-24 01:14:48.0387157',NULL,NULL,N'::1',N''),
	 (N'221AE116-47F1-4202-BA75-EAF2DECC51DA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Szhm0/xG4nZSjVKuEaztyRRY1dUjJC2Zj30cw4L+ttI=','2025-10-03 21:20:38.6788302','2025-10-10 21:20:38.6788307',NULL,NULL,N'::1',N''),
	 (N'F4CA9B51-1C0F-46F7-BD17-EAF3817001F8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'6YgYbcps+GjPHZesZr9hTxamkqV4i1rIbHFETifJvok=','2025-10-01 20:11:31.6377192','2025-10-08 20:11:31.6377197',NULL,NULL,N'::1',N''),
	 (N'70B5FD97-975C-40B9-A46C-EB6DC23B0D8E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'WPioqxCKgHxAuBdAtjv/7TBaAtGu4SfzGz5iVNuUeck=','2025-09-22 21:30:48.3305504','2025-09-29 21:30:48.3306148',NULL,NULL,N'::1',N''),
	 (N'DC36DEA9-A271-4C1B-8D34-EBF317A518BA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'n2b7cRApNorwzYkTMNyKIzQx7UWMnEEIl0L9RIwi5e4=','2025-09-09 17:52:55.2648484','2025-09-16 17:52:55.2648485',NULL,NULL,N'::1',N''),
	 (N'1E298B6C-6D7E-4985-BBE6-EBF5B5105E02',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jpZChZ9uJlML26s5mRGvXT12TEFR3Ja7kQNfHAaojh0=','2025-10-06 19:51:32.4014570','2025-10-13 19:51:32.4014573','2025-10-06 19:52:45.6378477',NULL,N'::1',N''),
	 (N'0A82121C-25B9-4DB2-A6A2-EC5BB4BBD80E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'YL0L4r1CB4sB5M0vztkp1xSaPz9jvc6yIaZ+LNP4bXs=','2025-10-03 21:01:26.0614369','2025-10-10 21:01:26.0614370','2025-10-03 21:02:58.3305258',NULL,N'::1',N''),
	 (N'469786A6-2710-462D-9F31-EEA4D4D3426E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'52VoM35tZlUHXLnW76TtOG/JH3SvBr+B029rkKzgAW0=','2025-09-29 21:43:47.1094023','2025-10-06 21:43:47.1094666',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'74158AC1-DE39-4A7B-B9F2-F0C5607C06D1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'NRkYUHTX/RRwPsA/U316sqwEPHFTWGSpWC9T12Thyu4=','2025-09-22 18:47:25.8304286','2025-09-29 18:47:25.8304290',NULL,NULL,N'::1',N''),
	 (N'18DED10A-9703-42D2-9328-F0D4E2583513',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'V7DFg2wizYjiN7lZ7DXYpmrqVI9IAxQRzVM2EzDFsrg=','2025-09-17 19:56:31.1249541','2025-09-24 19:56:31.1250157',NULL,NULL,N'::1',N''),
	 (N'5479B69F-1FB0-4076-A038-F0F4AEC7BC8A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'CxuI981TxyBBSeJQpFTnBYl6y5R1im60coNb4qecJBo=','2025-10-01 21:38:11.0242729','2025-10-08 21:38:11.0242730',NULL,NULL,N'::1',N''),
	 (N'FF45DD0E-22BD-4FBC-AA18-F16569AA4C81',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'bX8aPSlCEGvZRnKeDEuwSAy4E2O+PYZThC0fAvDA/1U=','2025-09-24 21:53:15.9244605','2025-10-01 21:53:15.9244608',NULL,NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'7CFA0C71-B673-4475-A0F4-F2A5E2F461BA',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'gI3kM0MTrCcZA2JTZMPUd60R0ThZf7M/l0ViIqP12x8=','2025-10-03 20:37:06.1648671','2025-10-10 20:37:06.1648672','2025-10-03 20:38:25.2258886',NULL,N'::1',N''),
	 (N'3C480ABE-78D7-4F00-98DF-F2DE7175B663',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'jSp6PmZoLcYuoLaan4+agI3RAri79gwZHqT9Fob4vuM=','2025-09-30 19:58:49.5685716','2025-10-07 19:58:49.5685724','2025-09-30 20:00:10.0609645',NULL,N'::1',N''),
	 (N'DAEED1EA-A418-4947-8B25-F2F6C626EBA2',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'RlSGJsg6aEUFsbgcoJBA+5RcCwHBMI80H1d9o7pOiiQ=','2025-10-01 22:15:06.3855169','2025-10-08 22:15:06.3855171','2025-10-01 22:15:11.6805937',NULL,N'::1',N''),
	 (N'5848E731-0BE0-45C6-898E-F324B909717F',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'x9h6svxaWiKt5BdF0ebH3wdPXprvV6jTltsxNaPQytU=','2025-10-01 22:16:01.8215205','2025-10-08 22:16:01.8215209',NULL,NULL,N'::1',N''),
	 (N'0476C274-C190-4313-92D2-F4400C006C85',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'vqNs0oTGLBR9YsIGGzJato/sQRxAOLKRO3CjXp0oBsk=','2025-10-08 20:09:32.1264350','2025-10-15 20:09:32.1264352',NULL,NULL,N'::1',N''),
	 (N'A260EE99-1896-48FE-98FC-F5261828101E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'9NtLRZ+gTpYXW2tOEViic+qi/5OA7ox8O44qlHclg8E=','2025-09-18 22:00:27.4702898','2025-09-25 22:00:27.4702899',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'3416BE48-CD43-4BA3-B6F8-F7B96479B641',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'DwXWaWT95mqTQAFg0pI3OQJJ5ZAkFDNqkCqwQGe7EMk=','2025-09-22 21:20:15.6232664','2025-09-29 21:20:15.6233294',NULL,NULL,N'::1',N''),
	 (N'D559D6E1-C8B4-47AD-993C-F828AC5C3AB8',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'oAhN2KtDRYNR3m1pwReLkPO12citIHUpdCwdowfdeec=','2025-10-01 20:44:53.4702797','2025-10-08 20:44:53.4702805',NULL,NULL,N'::1',N''),
	 (N'906BB21E-3372-4139-89F9-F83415493FF1',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'JnHaThLAmAoCLwYO62EIwZSAZ9Q4B47LjznS0TiVWE4=','2025-09-24 22:05:23.5363835','2025-10-01 22:05:23.5365088',NULL,NULL,N'::1',N'PostmanRuntime/7.44.1'),
	 (N'FE84E29A-4C41-4E89-A37E-F837DC39AD68',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'JmzyzekPw7OKaYHP4OhKyyMmD0px0w2ZjVEQ84Qp8SE=','2025-10-01 22:00:21.2331777','2025-10-08 22:00:21.2331778',NULL,NULL,N'::1',N''),
	 (N'B19B0BCE-0CE1-4F24-8CA0-F8BD3217F233',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'Fwj76JafDip/r6mTLhU4mSXYeKtx6QzxLGmnrY/v4hY=','2025-10-03 21:17:37.5071390','2025-10-10 21:17:37.5071392','2025-10-03 21:18:52.7558359',NULL,N'::1',N''),
	 (N'AA8B3303-D081-424D-99E9-F9680E51C36A',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'e1FetOCSSDwjVJ2vk3VHgkJH3R6zvsh8b6j7ceoobx8=','2025-10-03 19:42:46.3131997','2025-10-10 19:42:46.3131999',NULL,NULL,N'::1',N''),
	 (N'6CD3F3AE-141E-4F03-832F-F972D1CC1AB5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'dLl12523tWkoaAAjamdqhcA20v/KlWfUoDnrCpXY+aQ=','2025-09-30 19:21:54.0317066','2025-10-07 19:21:54.0317073',NULL,NULL,N'::1',N''),
	 (N'079C33F0-3153-48AB-922B-F9C62CB4C7B5',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'SlYnSzldQqfQO9GFc926lCRhOwpU3HTegoukfR+kHoQ=','2025-10-07 18:20:16.0474648','2025-10-14 18:20:16.0474649',NULL,NULL,N'::1',N''),
	 (N'656A76FE-496E-480D-A574-FB25329FF0DF',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'GR82Xrgjfw+bVQAj1vmMuD3GjANK+RFW5vuFCap8/Jw=','2025-09-09 01:35:59.5401715','2025-09-16 01:35:59.5401718',NULL,NULL,N'::1',N''),
	 (N'86C0B2F7-6863-4190-AFBB-FBF385DD50EB',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'LrBOMBgs/kvru9JAghIXnPtMMMPT/p788PXHBBXCKA0=','2025-10-09 18:44:58.5358885','2025-10-16 18:44:58.5358886',NULL,NULL,N'::1',N'');
INSERT INTO FitnessCenterDB.dbo.RefreshTokens (RefreshTokenId,UserId,ClientId,TokenHash,IssuedAt,ExpiresAt,RevokedAt,ReplacedByTokenId,IpAddress,UserAgent) VALUES
	 (N'310DB449-B3F5-4B49-A1A4-FCE69EDCBB3D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'QYa1x472Cwwz3EIszxtUW1wWvDKTr+QQTPRX/bALOSg=','2025-10-03 20:53:22.3405606','2025-10-10 20:53:22.3405607',NULL,NULL,N'::1',N''),
	 (N'FAC699EE-97B9-4EAA-A260-FDD2AE306C1E',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'HbBiO6A8K60CDBB9ddrYUZl1fbw2MptRiEjDalB36fs=','2025-10-01 22:32:38.9049764','2025-10-08 22:32:38.9049765','2025-10-01 22:37:52.0992923',NULL,N'::1',N''),
	 (N'4E85F07A-37E9-4364-B11F-FE4553F0641D',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'ihKGmomYC5k0gS7jO8mPCspPNMiYlMjMRgYyg9lwthA=','2025-09-29 21:45:52.0493037','2025-10-06 21:45:52.0493040',NULL,NULL,N'::1',N''),
	 (N'C8978F58-F9BC-447C-AA3F-FFDCD39C31C3',N'e47637e0-1971-4e46-99fb-186db0847fac',N'gymwebapp-frontend',N'5BBwxDX/96AjcmK8iIDfrPNrM2fYRWSO5gmVxZRdRBQ=','2025-10-03 21:22:22.2411200','2025-10-10 21:22:22.2411207',NULL,NULL,N'::1',N'');
 


 SET IDENTITY_INSERT dbo.beneficiosDeClase ON;
INSERT INTO FitnessCenterDB.dbo.beneficiosDeClase (idBeneficio,fkClase,beneficio,fechaDeCreacion,fechaDeModificacion,fkIcon,descripcionBeneficio) VALUES
	 (1,5,N'Mejora Cardiovascular','2025-04-16 12:11:32.11','2025-04-16 12:11:32.11',7,N'Aumenta la capacidad aeróbica y anaeróbica'),
	 (2,5,N'Quema de Grasa','2025-04-16 12:11:32.11','2025-04-16 12:11:32.11',8,N'Mayor quema calórica durante y después del ejercicio'),
	 (3,5,N'Eficiencia','2025-04-16 12:11:32.11','2025-04-16 12:11:32.11',9,N'Resultados máximos en tiempo mínimo');
 SET IDENTITY_INSERT dbo.beneficiosDeClase OFF;

SET IDENTITY_INSERT dbo.clasesProgramadas ON;
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (16,5,20,1,'2025-05-20 11:30:54.53','2025-05-20 11:30:54.53',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (17,5,20,1,'2025-05-20 11:30:54.57','2025-05-20 11:30:54.57',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (18,7,20,1,'2025-05-20 11:31:42.0','2025-05-20 11:31:42.0',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (19,8,20,1,'2025-05-20 11:31:42.0','2025-05-20 11:31:42.0',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (20,9,20,1,'2025-05-21 11:09:53.96','2025-05-21 11:09:53.96',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (22,6,10,1,'2025-06-11 14:40:17.907','2025-06-11 14:40:17.907',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (23,6,10,1,'2025-06-11 14:54:26.983','2025-06-11 14:54:26.983',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (24,6,10,1,'2025-06-11 15:46:43.183','2025-06-11 15:46:43.183',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (25,6,7,1,'2025-07-07 16:42:47.02','2025-07-07 16:42:47.02',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (26,7,7,1,'2025-07-07 19:28:39.33','2025-07-07 19:28:39.33',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (27,6,2,1,'2025-07-08 13:36:04.693','2025-07-08 13:36:04.693',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (28,1,1,1,'2025-07-08 13:38:16.137','2025-07-08 13:38:16.137',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (29,7,2,1,'2025-07-08 13:40:11.98','2025-07-08 13:40:11.98',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (30,9,1,1,'2025-07-08 13:52:46.873','2025-07-08 13:52:46.873',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (31,7,3,1,'2025-07-08 13:56:48.87','2025-07-08 13:56:48.87',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (32,5,33,1,'2025-07-08 14:11:29.9','2025-07-08 14:11:29.9',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (33,7,1,1,'2025-07-08 14:29:39.65','2025-07-08 14:29:39.65',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (34,6,22,1,'2025-07-08 14:29:39.65','2025-07-08 14:29:39.65',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (35,6,1,1,'2025-07-08 14:29:39.65','2025-07-08 14:29:39.65',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (36,2,4,3,'2025-07-09 13:37:10.843','2025-07-09 13:37:10.843',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (37,6,7,1,'2025-07-09 15:01:39.247','2025-07-09 15:01:39.247',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (38,7,7,1,'2025-07-09 15:01:39.247','2025-07-09 15:01:39.247',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (39,2,1,1,'2025-07-10 10:44:00.47','2025-07-10 10:44:00.47',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (40,6,7,1,'2025-07-10 10:45:24.97','2025-07-10 10:45:24.97',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (41,7,7,1,'2025-07-10 11:24:48.393','2025-07-10 11:24:48.393',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (42,7,1,1,'2025-07-10 11:27:00.597','2025-07-10 11:27:00.597',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (43,7,7,1,'2025-07-10 11:31:22.597','2025-07-10 11:31:22.597',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (44,7,7,1,'2025-07-10 11:36:12.883','2025-07-10 11:36:12.883',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (45,7,7,1,'2025-07-10 11:45:48.997','2025-07-10 11:45:48.997',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (46,8,7,1,'2025-07-10 13:21:52.68','2025-07-10 13:21:52.68',N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (47,7,7,1,'2025-07-10 13:23:24.867','2025-07-10 13:23:24.867',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (48,10,4,1,'2025-07-10 13:24:12.62','2025-07-10 13:24:12.62',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (49,12,3,1,'2025-07-10 13:25:09.733','2025-07-10 13:25:09.733',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (50,2,10,1,'2025-07-10 13:26:34.337','2025-07-10 13:26:34.337',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (51,1,10,1,'2025-07-10 13:33:29.673','2025-07-10 13:33:29.673',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (52,6,10,1,'2025-07-10 13:34:00.617','2025-07-10 13:34:00.617',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (53,8,10,1,'2025-07-10 13:38:49.397','2025-07-10 13:38:49.397',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (54,10,10,1,'2025-07-10 13:39:33.763','2025-07-10 13:39:33.763',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (55,5,10,1,'2025-07-10 13:40:24.647','2025-07-10 13:40:24.647',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (56,6,12,1,'2025-07-10 13:40:51.503','2025-07-10 13:40:51.503',N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (57,6,20,1,'2025-07-10 13:41:16.937','2025-07-10 13:41:16.937',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (58,10,10,1,'2025-07-10 13:42:03.477','2025-07-10 13:42:03.477',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (59,7,20,1,'2025-07-10 13:42:38.38','2025-07-10 13:42:38.38',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (60,9,50,1,'2025-07-10 13:45:34.707','2025-07-10 13:45:34.707',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (61,6,10,1,'2025-07-10 14:16:15.943','2025-07-10 14:16:15.943',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (62,6,10,1,'2025-07-10 14:17:20.88','2025-07-10 14:17:20.88',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (63,5,10,1,'2025-07-10 14:17:36.53','2025-07-10 14:17:36.53',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (64,2,120,1,'2025-07-10 14:18:00.81','2025-07-10 14:18:00.81',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (65,1,30,1,'2025-07-10 14:18:26.093','2025-07-10 14:18:26.093',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (66,2,20,1,'2025-07-10 14:18:52.41','2025-07-10 14:18:52.41',N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (67,6,20,1,'2025-07-10 14:19:10.71','2025-07-10 14:19:10.71',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (68,5,30,1,'2025-07-10 14:19:27.53','2025-07-10 14:19:27.53',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (69,7,30,1,'2025-07-10 14:19:55.427','2025-07-10 14:19:55.427',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (70,6,10,1,'2025-07-10 14:37:53.393','2025-07-10 14:37:53.393',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (71,5,33,1,'2025-07-11 14:04:15.137','2025-07-11 14:04:15.137',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (72,6,3,1,'2025-07-11 14:05:01.38','2025-07-11 14:05:01.38',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (73,8,7,1,'2025-07-11 14:05:57.25','2025-07-11 14:05:57.25',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (74,9,5,1,'2025-07-11 14:06:37.463','2025-07-11 14:06:37.463',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (75,5,3,1,'2025-07-11 14:07:08.333','2025-07-11 14:07:08.333',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (76,5,10,1,'2025-07-11 14:09:01.943','2025-07-11 14:09:01.943',N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (77,7,7,1,'2025-07-11 14:09:24.05','2025-07-11 14:09:24.05',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (78,6,5,1,'2025-07-11 14:09:57.907','2025-07-11 14:09:57.907',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (79,6,10,1,'2025-07-11 14:10:21.997','2025-07-11 14:10:21.997',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (80,10,14,1,'2025-07-11 14:10:53.583','2025-07-11 14:10:53.583',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (81,8,10,1,'2025-07-11 14:24:54.643','2025-07-11 14:24:54.643',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (82,7,10,1,'2025-07-11 14:28:04.747','2025-07-11 14:28:04.747',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (83,5,3,1,'2025-07-11 14:29:18.907','2025-07-11 14:29:18.907',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (84,10,10,1,'2025-07-11 14:31:36.56','2025-07-11 14:31:36.56',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (85,5,1,1,'2025-07-11 14:31:54.51','2025-07-11 14:31:54.51',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (86,7,10,1,'2025-07-11 14:32:12.993','2025-07-11 14:32:12.993',N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (87,5,1,1,'2025-07-11 14:32:25.847','2025-07-11 14:32:25.847',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (88,7,10,1,'2025-07-11 14:32:40.68','2025-07-11 14:32:40.68',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (89,7,10,1,'2025-07-11 14:32:54.907','2025-07-11 14:32:54.907',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (90,6,3,1,'2025-07-11 14:33:16.97','2025-07-11 14:33:16.97',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (91,12,10,1,'2025-07-11 15:47:17.787','2025-07-11 15:47:17.787',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (92,1,1,1,'2025-07-11 15:47:38.94','2025-07-11 15:47:38.94',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (93,1,1,1,'2025-07-11 15:47:53.883','2025-07-11 15:47:53.883',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (94,6,3,1,'2025-07-11 15:48:15.847','2025-07-11 15:48:15.847',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (95,7,1,1,'2025-07-11 15:48:39.3','2025-07-11 15:48:39.3',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (96,8,1,1,'2025-07-11 15:48:56.61','2025-07-11 15:48:56.61',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (97,9,1,1,'2025-07-11 15:49:11.673','2025-07-11 15:49:11.673',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (98,1,3,1,'2025-07-11 15:49:47.987','2025-07-11 15:49:47.987',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (99,1,3,1,'2025-07-11 15:50:03.243','2025-07-11 15:50:03.243',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (100,8,1,1,'2025-07-11 15:50:31.87','2025-07-11 15:50:31.87',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (101,1,1,1,'2025-07-11 15:53:06.82','2025-07-11 15:53:06.82',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (102,6,3,1,'2025-07-11 15:54:35.843','2025-07-11 15:54:35.843',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (103,5,2,1,'2025-07-11 15:57:32.49','2025-07-11 15:57:32.49',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (104,6,1,1,'2025-07-11 15:58:07.14','2025-07-11 15:58:07.14',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (105,1,1,1,'2025-07-11 15:58:19.903','2025-07-11 15:58:19.903',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (106,1,1,1,'2025-07-11 15:58:31.977','2025-07-11 15:58:31.977',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (107,1,1,1,'2025-07-11 15:58:42.577','2025-07-11 15:58:42.577',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (108,1,1,1,'2025-07-11 15:58:51.167','2025-07-11 15:58:51.167',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (109,1,1,1,'2025-07-11 15:59:04.76','2025-07-11 15:59:04.76',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (110,6,1,1,'2025-07-11 15:59:22.437','2025-07-11 15:59:22.437',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (111,1,1,1,'2025-07-11 15:59:33.01','2025-07-11 15:59:33.01',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (112,1,1,1,'2025-07-11 16:16:21.867','2025-07-11 16:16:21.867',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (113,6,2,1,'2025-07-11 16:16:35.38','2025-07-11 16:16:35.38',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (114,6,1,1,'2025-07-11 16:16:49.233','2025-07-11 16:16:49.233',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (115,1,1,1,'2025-07-11 16:16:58.457','2025-07-11 16:16:58.457',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (116,1,1,1,'2025-07-11 16:17:10.233','2025-07-11 16:17:10.233',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (117,1,1,1,'2025-07-11 16:17:19.103','2025-07-11 16:17:19.103',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (118,1,1,1,'2025-07-11 16:17:26.807','2025-07-11 16:17:26.807',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (119,1,1,1,'2025-07-11 16:17:35.32','2025-07-11 16:17:35.32',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (120,1,1,1,'2025-07-11 16:17:43.907','2025-07-11 16:17:43.907',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (121,1,1,1,'2025-07-11 16:17:57.377','2025-07-11 16:17:57.377',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (122,1,1,1,'2025-07-11 16:21:17.45','2025-07-11 16:21:17.45',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (123,1,1,1,'2025-07-11 16:21:31.4','2025-07-11 16:21:31.4',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (124,1,1,1,'2025-07-11 16:21:45.557','2025-07-11 16:21:45.557',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (125,1,1,1,'2025-07-11 16:22:07.203','2025-07-11 16:22:07.203',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (126,1,1,1,'2025-07-11 16:22:17.71','2025-07-11 16:22:17.71',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (127,1,1,1,'2025-07-11 16:22:25.693','2025-07-11 16:22:25.693',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (128,1,1,1,'2025-07-11 16:22:45.05','2025-07-11 16:22:45.05',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (129,1,1,1,'2025-07-11 16:22:54.13','2025-07-11 16:22:54.13',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (130,1,1,1,'2025-07-11 16:23:02.727','2025-07-11 16:23:02.727',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (131,1,1,1,'2025-07-11 16:23:24.09','2025-07-11 16:23:24.09',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (132,1,1,1,'2025-07-11 16:37:07.333','2025-07-11 16:37:07.333',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (133,1,1,1,'2025-07-11 16:37:07.333','2025-07-11 16:37:07.333',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (134,1,1,1,'2025-07-11 16:37:07.333','2025-07-11 16:37:07.333',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (135,1,1,1,'2025-07-11 16:37:07.333','2025-07-11 16:37:07.333',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (136,1,1,1,'2025-07-11 16:37:07.333','2025-07-11 16:37:07.333',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (137,1,1,1,'2025-07-11 16:37:07.333','2025-07-11 16:37:07.333',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (138,1,1,1,'2025-07-11 16:37:07.333','2025-07-11 16:37:07.333',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (139,1,1,1,'2025-07-11 16:37:07.333','2025-07-11 16:37:07.333',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (140,5,1,1,'2025-07-11 16:37:07.333','2025-07-11 16:37:07.333',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (141,2,1,1,'2025-07-11 16:37:07.333','2025-07-11 16:37:07.333',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (142,6,1,1,'2025-07-13 18:52:11.587','2025-07-13 18:52:11.587',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (143,6,1,1,'2025-07-13 18:54:09.91','2025-07-13 18:54:09.91',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (144,6,1,1,'2025-07-13 18:55:04.24','2025-07-13 18:55:04.24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (145,6,1,1,'2025-07-13 18:56:20.56','2025-07-13 18:56:20.56',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (146,6,1,1,'2025-07-13 19:06:26.22','2025-07-13 19:06:26.22',N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (147,6,1,1,'2025-07-13 19:37:47.243','2025-07-13 19:37:47.243',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (148,6,1,1,'2025-07-13 19:38:36.503','2025-07-13 19:38:36.503',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (149,8,1,1,'2025-07-13 19:39:00.907','2025-07-13 19:39:00.907',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (150,6,1,1,'2025-07-13 19:39:29.14','2025-07-13 19:39:29.14',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (151,7,1,1,'2025-07-13 19:40:06.873','2025-07-13 19:40:06.873',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (152,6,1,1,'2025-07-13 19:41:33.933','2025-07-13 19:41:33.933',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (153,7,1,1,'2025-07-13 19:42:17.117','2025-07-13 19:42:17.117',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (154,6,1,1,'2025-07-13 19:53:55.113','2025-07-13 19:53:55.113',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (155,1,1,1,'2025-07-13 19:54:08.533','2025-07-13 19:54:08.533',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (156,1,1,1,'2025-07-13 19:54:19.627','2025-07-13 19:54:19.627',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (157,1,1,1,'2025-07-13 19:54:34.5','2025-07-13 19:54:34.5',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (158,6,1,1,'2025-07-13 19:55:24.417','2025-07-13 19:55:24.417',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (159,1,1,1,'2025-07-13 19:55:38.607','2025-07-13 19:55:38.607',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (160,6,1,1,'2025-07-13 19:55:51.893','2025-07-13 19:55:51.893',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (161,5,1,1,'2025-07-13 19:57:23.96','2025-07-13 19:57:23.96',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (162,7,1,1,'2025-07-13 19:57:59.82','2025-07-13 19:57:59.82',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (163,7,1,1,'2025-07-13 19:58:33.513','2025-07-13 19:58:33.513',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (164,6,1,1,'2025-07-13 20:01:40.163','2025-07-13 20:01:40.163',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (165,6,1,1,'2025-07-13 20:03:43.897','2025-07-13 20:03:43.897',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (166,1,1,1,'2025-07-13 20:10:13.32','2025-07-13 20:10:13.323',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (167,1,1,1,'2025-07-13 20:10:22.03','2025-07-13 20:10:22.03',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (168,1,1,1,'2025-07-13 20:10:31.927','2025-07-13 20:10:31.927',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (169,6,1,1,'2025-07-13 20:10:43.813','2025-07-13 20:10:43.813',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (170,6,1,1,'2025-07-13 20:10:56.027','2025-07-13 20:10:56.027',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (171,7,1,1,'2025-07-13 20:11:07.23','2025-07-13 20:11:07.23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (172,7,1,1,'2025-07-13 20:11:17.663','2025-07-13 20:11:17.663',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (173,7,1,1,'2025-07-13 20:11:30.92','2025-07-13 20:11:30.92',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (174,8,1,1,'2025-07-13 20:11:41.463','2025-07-13 20:11:41.463',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (175,7,1,1,'2025-07-13 20:11:53.9','2025-07-13 20:11:53.9',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (176,7,1,1,'2025-07-13 20:12:04.737','2025-07-13 20:12:04.737',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (177,8,1,1,'2025-07-13 20:12:44.093','2025-07-13 20:12:44.093',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (178,6,30,1,'2025-07-23 13:15:49.333','2025-07-23 13:15:49.333',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (179,6,10,1,'2025-07-24 19:22:21.527','2025-07-24 19:22:21.527',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (180,6,20,1,'2025-07-25 12:42:01.227','2025-07-25 12:42:01.227',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (181,6,30,1,'2025-07-25 13:59:42.56','2025-07-25 13:59:42.56',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (182,6,15,1,'2025-07-28 12:40:29.397','2025-07-28 12:40:29.397',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (183,6,15,1,'2025-07-29 11:09:05.537','2025-07-29 11:09:05.537',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (184,7,30,1,'2025-07-29 11:45:56.46','2025-07-29 11:45:56.46',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (185,7,30,1,'2025-07-29 12:02:39.04','2025-07-29 12:02:39.04',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (186,7,40,1,'2025-07-29 12:02:39.04','2025-07-29 12:02:39.04',N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (187,7,5,1,'2025-07-30 15:25:07.633','2025-07-30 15:25:07.633',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (188,7,5,1,'2025-07-30 15:25:08.393','2025-07-30 15:25:08.393',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (189,7,5,1,'2025-07-30 15:25:08.393','2025-07-30 15:25:08.393',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (190,7,5,1,'2025-07-31 11:07:42.133','2025-07-31 11:07:42.133',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (191,7,1,1,'2025-07-31 11:20:58.91','2025-07-31 11:20:58.91',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (192,7,1,1,'2025-07-31 11:31:10.423','2025-07-31 11:31:10.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (193,6,2,1,'2025-08-01 11:37:41.61','2025-08-01 11:37:41.61',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (194,6,10,1,'2025-08-01 11:49:27.747','2025-08-01 11:49:27.747',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (195,6,5,1,'2025-08-01 12:02:47.467','2025-08-01 12:02:47.467',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (196,7,10,1,'2025-08-01 14:00:47.48','2025-08-01 14:00:47.48',N'ec4a4f9d-02b8-402a-b274-8924adb46e46');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (197,8,10,1,'2025-08-05 15:39:07.193','2025-08-05 15:39:07.193',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (198,7,20,1,'2025-09-23 14:42:11.637','2025-09-23 14:42:11.637',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (199,7,20,1,'2025-09-23 14:43:20.77','2025-09-23 14:43:20.77',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (200,7,20,1,'2025-09-23 14:43:58.37','2025-09-23 14:43:58.37',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (201,7,20,1,'2025-09-23 14:47:22.277','2025-09-23 14:47:22.277',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (202,7,20,1,'2025-09-23 14:51:02.503','2025-09-23 14:51:02.503',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (203,7,20,1,'2025-09-23 14:51:51.04','2025-09-23 14:51:51.04',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (204,7,20,1,'2025-09-23 15:00:32.753','2025-09-23 15:00:32.753',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (205,7,20,1,'2025-09-23 15:07:19.423','2025-09-23 15:07:19.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (206,7,20,1,'2025-09-23 15:13:20.297','2025-09-23 15:13:20.297',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (207,7,20,1,'2025-09-23 15:15:37.617','2025-09-23 15:15:37.617',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (208,7,20,1,'2025-09-23 15:18:30.603','2025-09-23 15:18:30.603',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (209,8,30,1,'2025-09-23 15:25:26.33','2025-09-23 15:25:26.33',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (210,6,20,1,'2025-09-23 15:26:41.107','2025-09-23 15:26:41.107',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (211,6,10,1,'2025-09-24 14:34:08.373','2025-09-24 14:34:08.373',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (212,6,10,1,'2025-09-24 16:21:43.75','2025-09-24 16:21:43.75',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (213,8,10,1,'2025-09-24 17:51:23.78','2025-09-24 17:51:23.78',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (214,10,10,1,'2025-09-24 17:56:01.407','2025-09-24 17:56:01.407',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (215,6,10,1,'2025-09-24 18:02:37.577','2025-09-24 18:02:37.577',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (216,6,20,1,'2025-10-07 11:12:22.74','2025-10-07 11:12:22.74',N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (217,8,20,1,'2025-10-07 11:15:10.043','2025-10-07 11:15:10.043',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (218,9,20,1,'2025-10-07 12:21:07.47','2025-10-07 12:21:07.47',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (219,9,15,1,'2025-10-08 15:52:47.78','2025-10-08 15:52:47.78',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (220,10,25,1,'2025-10-08 15:52:47.78','2025-10-08 15:52:47.78',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (221,10,25,1,'2025-10-08 15:52:47.78','2025-10-08 15:52:47.78',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (222,10,10,1,'2025-10-08 15:52:47.78','2025-10-08 15:52:47.78',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (223,10,10,1,'2025-10-08 15:52:47.78','2025-10-08 15:52:47.78',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (224,6,15,1,'2025-10-09 10:44:29.347','2025-10-09 10:44:29.347',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (225,7,15,1,'2025-10-09 10:46:35.48','2025-10-09 10:46:35.48',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (226,7,15,1,'2025-10-09 10:56:07.913','2025-10-09 10:56:07.913',N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (227,6,15,1,'2025-10-09 10:57:54.627','2025-10-09 10:57:54.627',N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
 SET IDENTITY_INSERT dbo.clasesProgramadas OFF;



SET IDENTITY_INSERT dbo.consejosParaLasClases ON;
INSERT INTO FitnessCenterDB.dbo.consejosParaLasClases (idConsejo,fkClase,fkEjercicio,introduccionDeConsejo,consejos) VALUES
	 (1,5,NULL,N'Si eres nuevo en el HIIT, estos consejos te ayudarán a sacar el máximo provecho de tus entrenamientos mientras minimizas el riesgo de lesiones:',N'Comienza con versiones modificadas de los ejercicios hasta dominar la técnica correcta, escucha a tu cuerpo y toma descansos adicionales si los necesitas, mantén una buena hidratación antes, durante y después de la clase, prioriza la técnica sobre la velocidad o el número de repeticiones, comienza con 1-2 clases por semana y aumenta gradualmente, informa al instructor sobre cualquier lesión o limitación que tengas.');
 SET IDENTITY_INSERT dbo.consejosParaLasClases OFF;

SET IDENTITY_INSERT dbo.estructuraDeClase ON; 
INSERT INTO FitnessCenterDB.dbo.estructuraDeClase (idBloque,fkClase,numeroConsecutivoDelBloque,duracionMenorEnMinutos,duracionMayorEnMinutos,tituloBloque,descripcionBloque,fechaDeCreacion,fechaDeModificacion) VALUES
	 (1,5,1,5,7,N'Calentamiento',N'Comenzamos con un calentamiento dinámico para preparar el cuerpo para el ejercicio intenso. Incluye movilidad articular, activación muscular y elevación gradual del ritmo cardíaco.','2025-04-16 11:44:58.373','2025-04-16 11:44:58.373'),
	 (2,5,2,30,30,N'Bloques Hiit',N'El núcleo de la clase consiste en 4-6 bloques de ejercicios de alta intensidad. Cada bloque alterna entre 20-40 segundos de trabajo máximo y 10-20 segundos de descanso. Realizamos 3-4 rondas de cada bloque con un minuto de recuperación entre bloques.','2025-04-16 11:44:58.373','2025-04-16 11:44:58.373'),
	 (3,5,3,5,7,N'Enfiramiento',N'Finalizamos con ejercicios de baja intensidad para reducir gradualmente el ritmo cardíaco, seguidos de estiramientos estáticos para mejorar la flexibilidad y acelerar la recuperación. ','2025-04-16 11:44:58.373','2025-04-16 11:44:58.373');
 SET IDENTITY_INSERT dbo.estructuraDeClase OFF; 


SET IDENTITY_INSERT dbo.horariosDeClasesProgramadas ON; 
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (17,16,1,1,'2025-06-03',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (18,17,2,1,'2025-06-03',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (21,20,1,1,'2025-06-12',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (23,22,2,1,'2025-07-22',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (24,23,2,1,'2025-07-22',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (25,24,2,1,'2025-07-22',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (26,25,3,1,'2025-07-22',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (27,26,1,1,'2025-07-22',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (28,27,3,1,'2025-07-22',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (29,28,5,1,'2025-07-22',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (30,29,5,1,'2025-07-22',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (31,30,9,1,'2025-07-22',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (32,31,3,1,'2025-07-22',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (33,32,10,1,'2025-07-22',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (34,33,4,1,'2025-07-22',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (35,34,3,1,'2025-07-22',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (36,35,5,1,'2025-07-22',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (37,36,5,1,'2025-07-22',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (38,37,4,1,'2025-07-22',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (39,38,1,1,'2025-07-22',N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (40,39,1,1,'2025-07-10',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (41,40,2,1,'2025-07-10',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (42,41,3,1,'2025-07-10',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (43,42,6,1,'2025-07-10',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (44,43,4,1,'2025-07-10',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (47,46,5,1,'2025-07-10',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (48,47,7,1,'2025-07-10',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (49,48,9,1,'2025-07-10',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (50,49,10,1,'2025-07-10',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (51,50,8,1,'2025-07-10',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (52,51,1,1,'2025-07-11',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (53,52,5,1,'2025-07-11',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (54,53,2,1,'2025-07-11',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (55,54,10,1,'2025-07-11',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (56,55,3,1,'2025-07-11',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (57,56,4,1,'2025-07-11',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (58,57,6,1,'2025-07-11',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (59,58,7,1,'2025-07-11',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (60,59,8,1,'2025-07-11',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (61,60,9,1,'2025-07-11',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (62,61,1,1,'2025-07-12',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (63,62,2,1,'2025-07-12',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (64,63,5,1,'2025-07-12',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (65,64,3,1,'2025-07-12',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (66,65,4,1,'2025-07-12',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (67,66,6,1,'2025-07-12',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (68,67,7,1,'2025-07-12',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (69,68,8,1,'2025-07-12',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (70,69,9,1,'2025-07-12',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (71,70,10,1,'2025-07-12',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (72,71,1,1,'2025-07-13',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (73,72,6,1,'2025-07-13',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (74,73,4,1,'2025-07-13',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (75,74,8,1,'2025-07-13',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (76,75,5,1,'2025-07-13',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (77,76,7,1,'2025-07-13',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (78,77,3,1,'2025-07-13',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (79,78,2,1,'2025-07-13',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (80,79,10,1,'2025-07-13',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (81,80,9,1,'2025-07-13',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (82,81,3,1,'2025-07-14',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (83,82,4,1,'2025-07-14',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (84,83,5,1,'2025-07-14',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (85,84,6,1,'2025-07-14',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (86,85,1,1,'2025-07-14',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (87,86,8,1,'2025-07-14',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (88,87,7,1,'2025-07-14',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (89,88,2,1,'2025-07-14',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (90,89,10,1,'2025-07-14',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (91,90,9,1,'2025-07-14',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (92,91,5,1,'2025-07-15',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (93,92,1,1,'2025-07-15',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (94,93,2,1,'2025-07-15',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (95,94,3,1,'2025-07-15',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (96,95,4,1,'2025-07-15',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (97,96,6,1,'2025-07-15',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (98,97,7,1,'2025-07-15',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (99,98,8,1,'2025-07-15',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (100,99,9,1,'2025-07-15',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (101,100,10,1,'2025-07-15',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (102,101,4,1,'2025-07-16',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (103,102,3,1,'2025-07-16',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (104,103,7,1,'2025-07-16',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (105,104,4,1,'2025-07-16',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (106,105,5,1,'2025-07-16',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (107,106,6,1,'2025-07-16',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (108,107,1,1,'2025-07-16',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (109,108,2,1,'2025-07-16',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (110,109,8,1,'2025-07-16',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (111,110,9,1,'2025-07-16',N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (112,111,10,1,'2025-07-16',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (113,112,1,1,'2025-07-17',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (114,113,8,1,'2025-07-17',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (115,114,6,1,'2025-07-17',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (116,115,4,1,'2025-07-17',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (117,116,2,1,'2025-07-17',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (118,117,3,1,'2025-07-17',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (119,118,5,1,'2025-07-17',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (120,119,7,1,'2025-07-17',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (121,120,9,1,'2025-07-17',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (122,121,10,1,'2025-07-17',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (123,122,1,1,'2025-07-18',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (124,123,2,1,'2025-07-18',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (125,124,5,1,'2025-07-18',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (126,125,3,1,'2025-07-18',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (127,126,7,1,'2025-07-18',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (128,127,8,1,'2025-07-18',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (129,128,6,1,'2025-07-18',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (130,129,4,1,'2025-07-18',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (131,130,9,1,'2025-07-18',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (132,131,10,1,'2025-07-18',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (133,132,1,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (134,133,1,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (135,134,10,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (136,135,10,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (137,136,8,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (138,137,10,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (139,138,10,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (140,139,10,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (141,140,10,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (142,141,1,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (143,142,1,1,'2025-07-20',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (144,143,10,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (145,144,10,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (146,145,4,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (147,146,1,1,'2025-07-20',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (148,147,4,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (149,148,3,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (150,149,4,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (151,150,5,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (152,151,3,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (153,152,7,1,'2025-07-19',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (154,153,3,1,'2025-07-19',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (155,154,4,1,'2025-07-19',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (156,155,5,1,'2025-07-19',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (157,156,9,1,'2025-07-19',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (158,157,6,1,'2025-07-19',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (159,158,1,1,'2025-07-19',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (160,159,2,1,'2025-07-19',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (161,160,10,1,'2025-07-19',N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (162,161,8,1,'2025-07-19',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (163,162,7,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (164,163,2,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (165,164,9,1,'2025-07-20',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (166,165,6,1,'2025-07-20',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (167,166,1,1,'2025-07-21',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (168,167,4,1,'2025-07-21',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (169,168,5,1,'2025-07-21',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (170,169,6,1,'2025-07-21',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (171,170,7,1,'2025-07-21',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (172,171,1,1,'2025-07-21',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (173,172,8,1,'2025-07-21',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (174,173,1,1,'2025-07-21',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (175,174,3,1,'2025-07-21',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (176,175,9,1,'2025-07-21',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (177,176,10,1,'2025-07-21',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (178,177,2,1,'2025-07-21',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (179,178,3,1,'2025-07-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (180,179,7,1,'2025-07-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (181,180,3,1,'2025-07-25',N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (182,181,4,1,'2025-07-25',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (183,182,2,1,'2025-07-28',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (184,183,1,1,'2025-07-29',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (185,184,6,1,'2025-07-29',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (186,185,8,1,'2025-07-29',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (187,186,7,1,'2025-07-29',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (188,187,9,1,'2025-07-30',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (189,188,8,1,'2025-07-30',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (190,189,7,1,'2025-07-30',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (191,190,3,1,'2025-07-31',N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (192,191,1,1,'2025-07-31',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (193,192,6,1,'2025-07-31',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (194,193,5,1,'2025-08-01',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (195,194,7,1,'2025-08-13',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (196,195,9,1,'2025-08-10',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (197,196,9,1,'2025-08-19',N'ec4a4f9d-02b8-402a-b274-8924adb46e46'),
	 (198,197,5,1,'2025-08-05',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (199,198,5,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (200,199,5,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (201,200,5,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (202,201,5,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (203,202,5,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (204,203,5,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (205,204,5,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (206,205,1,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (207,206,3,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (208,207,6,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (209,208,4,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (210,209,8,1,'2025-09-23',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (211,210,9,1,'2025-09-23',N'ec4a4f9d-02b8-402a-b274-8924adb46e46');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (212,211,2,1,'2025-09-24',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (213,212,1,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (214,213,4,1,'2025-09-24',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (215,214,5,1,'2025-09-24',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (216,215,6,1,'2025-09-24',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (217,216,8,1,'2025-10-08',N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (218,217,5,1,'2025-10-08',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (219,218,3,1,'2025-10-08',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (220,219,4,1,'2025-10-08',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (221,220,1,1,'2025-10-08',N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (222,221,1,1,'2025-10-08',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (223,222,7,1,'2025-10-08',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (224,223,9,1,'2025-10-08',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (225,224,1,1,'2025-10-09',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (226,225,2,1,'2025-10-09',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (227,226,8,1,'2025-10-09',N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (228,227,3,1,'2025-10-09',N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
 SET IDENTITY_INSERT dbo.horariosDeClasesProgramadas OFF; 


SET IDENTITY_INSERT dbo.imagesForClases ON;
INSERT INTO FitnessCenterDB.dbo.imagesForClases (idClassImage,fkClase,urlParaBanner,urlParaParaDescripcionDeClase,urlParaBloqueConsejos,FechaDeCreacion,FechaDeModificacion) VALUES
	 (1,5,N'../img/hiitherosection.jpg',N'../img/hiit2.jpg',N'../img/lesiongym.jpg','2025-04-23 17:26:49.63','2025-04-23 17:26:49.63');
 SET IDENTITY_INSERT dbo.imagesForClases OFF;


SET IDENTITY_INSERT dbo.imagesForExercises ON;
INSERT INTO FitnessCenterDB.dbo.imagesForExercises (idImage,fkEjercicio,nombreParaElFront,urlPrivada,urlPublica) VALUES
	 (1,8,N'burpees',N'../img/burpees.jpg',N'../img/burpees.jpg'),
	 (2,9,N'Mountain climbers',N'../img/mountainclimbers.webp',N'../img/mountainclimbers.webp'),
	 (3,10,N'Jumping jacks',N'../img/jumpingjacks.webp',N'../img/jumpingjacks.webp'),
	 (4,11,N'Sentadillas con salto',N'../img/sentadillaconsalto.jpg',N'../img/sentadillaconsalto.jpg'),
	 (5,12,N'Planchas laterales',N'../img/sentadillalateral.webp',N'../img/sentadillalateral.webp'),
	 (6,13,N'Planchas laterales',N'../img/highknees2.jpg',N'../img/highknees2.jpg');
 SET IDENTITY_INSERT dbo.imagesForExercises OFF;


SET IDENTITY_INSERT dbo.inscripcionesDeClases ON;
INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases (idInscripcion,fkProgramacionClase,fechaDeInscripcion,fkEstadoInscripcion,fkCliente) VALUES
	 (1,19,'2025-05-30 16:31:34.99',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (2,20,'2025-05-30 16:31:34.99',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (3,16,'2025-06-02 18:39:02.14',4,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (4,17,'2025-06-02 18:39:02.157',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (5,18,'2025-06-02 18:40:00.42',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (6,16,'2025-06-11 17:28:38.547',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (7,17,'2025-06-12 13:52:27.89',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (8,17,'2025-06-12 15:01:12.65',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (9,16,'2025-07-25 14:45:41.033',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (11,180,'2025-07-25 16:08:29.84',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5');
INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases (idInscripcion,fkProgramacionClase,fechaDeInscripcion,fkEstadoInscripcion,fkCliente) VALUES
	 (12,182,'2025-07-28 12:41:15.76',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (13,182,'2025-07-28 13:10:13.89',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (14,182,'2025-07-28 13:12:11.103',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (15,182,'2025-07-28 13:15:36.607',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (16,182,'2025-07-28 13:27:10.037',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (17,182,'2025-07-28 13:29:06.74',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (18,182,'2025-07-28 13:34:49.86',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (19,182,'2025-07-28 15:20:55.37',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (20,182,'2025-07-28 15:21:22.457',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (21,184,'2025-07-29 12:02:39.04',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5');
INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases (idInscripcion,fkProgramacionClase,fechaDeInscripcion,fkEstadoInscripcion,fkCliente) VALUES
	 (22,184,'2025-07-29 12:02:39.04',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (23,183,'2025-07-29 14:04:13.2',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (24,183,'2025-07-29 14:04:59.783',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (25,183,'2025-07-29 14:07:00.673',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (26,183,'2025-07-29 14:08:14.52',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (27,183,'2025-07-29 14:12:19.117',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (28,183,'2025-07-29 14:12:47.183',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (29,183,'2025-07-29 14:13:28.86',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (30,183,'2025-07-29 14:17:39.607',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (31,183,'2025-07-29 14:18:25.103',1,N'574820a9-b28b-4b37-a665-029d2f41e272');
INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases (idInscripcion,fkProgramacionClase,fechaDeInscripcion,fkEstadoInscripcion,fkCliente) VALUES
	 (32,183,'2025-07-29 14:51:38.75',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (33,183,'2025-07-29 14:55:48.183',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (34,183,'2025-07-29 14:57:17.557',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (35,183,'2025-07-29 15:10:38.49',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (36,183,'2025-07-29 15:13:51.887',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (37,183,'2025-07-29 15:21:55.167',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (38,183,'2025-07-29 15:22:23.0',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (39,183,'2025-07-29 15:31:55.39',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (40,183,'2025-07-29 15:34:03.57',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (41,183,'2025-07-29 15:34:19.907',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5');
INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases (idInscripcion,fkProgramacionClase,fechaDeInscripcion,fkEstadoInscripcion,fkCliente) VALUES
	 (42,183,'2025-07-29 15:35:38.847',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (43,183,'2025-07-29 15:35:39.12',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (44,183,'2025-07-29 15:36:34.207',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (45,187,'2025-07-30 15:25:08.393',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (46,187,'2025-07-30 15:25:08.393',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (47,187,'2025-07-30 15:25:08.393',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (48,187,'2025-07-30 15:25:08.393',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (49,187,'2025-07-30 15:25:08.393',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (50,190,'2025-07-31 11:16:33.397',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (51,190,'2025-07-31 11:18:33.117',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5');
INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases (idInscripcion,fkProgramacionClase,fechaDeInscripcion,fkEstadoInscripcion,fkCliente) VALUES
	 (52,190,'2025-07-31 11:18:42.23',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (53,190,'2025-07-31 11:18:50.873',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (54,190,'2025-07-31 11:19:14.62',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (55,191,'2025-07-31 11:21:44.59',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (56,192,'2025-07-31 11:48:59.04',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (57,196,'2025-08-01 14:01:58.83',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (58,197,'2025-08-05 15:39:27.6',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (59,197,'2025-08-05 15:40:16.197',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (60,197,'2025-08-05 15:42:03.343',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (61,197,'2025-08-05 15:42:57.357',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5');
INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases (idInscripcion,fkProgramacionClase,fechaDeInscripcion,fkEstadoInscripcion,fkCliente) VALUES
	 (62,197,'2025-08-05 15:43:03.74',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (63,197,'2025-08-05 15:43:09.497',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (64,197,'2025-08-05 15:43:14.95',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (65,197,'2025-08-05 15:43:22.963',1,N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (66,197,'2025-08-05 15:43:28.45',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (67,197,'2025-08-05 15:43:34.307',1,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (68,206,'2025-09-23 17:15:43.41',1,N'574820a9-b28b-4b37-a665-029d2f41e272');
 SET IDENTITY_INSERT dbo.inscripcionesDeClases OFF;

SET IDENTITY_INSERT dbo.ejercicios_parametrosDeMedicion ON;
INSERT INTO FitnessCenterDB.dbo.ejercicios_parametrosDeMedicion (id,fkEjercicio,fkParametro,fechaCreacion,fechaModificacion) VALUES
	 (1,1,4,'2025-02-28 14:10:49.917',NULL),
	 (2,4,4,'2025-02-28 14:10:49.917',NULL);
 SET IDENTITY_INSERT dbo.ejercicios_parametrosDeMedicion OFF;


SET IDENTITY_INSERT dbo.medidas ON;
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (1,'2024-12-28 11:16:23.38',1,23.03,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (2,'2024-12-29 11:16:23.387',1,23.03,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (3,'2024-12-30 11:16:23.39',1,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (4,'2024-12-31 11:16:23.393',1,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (5,'2025-01-01 11:16:23.397',1,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (6,'2025-01-02 11:16:23.4',1,23.03,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (7,'2025-01-03 11:16:23.403',1,23.03,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (8,'2025-01-04 11:16:23.407',1,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (12,'2025-01-05 11:16:23.41',1,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (13,'2025-01-06 11:16:23.413',1,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (14,'2025-01-07 11:16:23.417',1,23.03,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (15,'2025-01-08 11:16:23.42',1,25.82,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (16,'2025-01-09 11:16:23.42',1,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (17,'2025-01-10 11:16:23.423',1,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (18,'2025-01-11 11:16:23.427',1,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (19,'2025-01-12 11:16:23.43',1,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (20,'2025-01-13 11:16:23.433',1,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (21,'2025-01-14 11:16:23.433',1,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (22,'2025-01-15 11:16:23.437',1,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (23,'2025-01-16 11:16:23.44',1,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (24,'2025-01-17 11:16:23.443',1,25.82,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (25,'2025-01-18 11:16:23.447',1,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (26,'2025-01-19 11:16:23.45',1,21.81,NULL,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (27,'2025-01-20 11:16:23.45',1,21.81,NULL,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (28,'2025-01-21 11:16:23.453',1,21.81,NULL,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (29,'2025-01-22 11:16:23.457',1,21.81,NULL,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (56,'2024-12-30 14:49:53.707',2,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (57,'2024-12-30 14:49:53.707',2,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (58,'2024-12-30 14:49:53.707',2,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (59,'2024-12-30 14:49:53.707',2,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (60,'2024-12-30 14:49:53.707',2,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (61,'2024-12-30 14:49:53.707',2,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (62,'2024-12-30 14:49:53.707',2,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (63,'2024-12-30 14:49:53.707',2,23.03,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (64,'2024-12-30 14:49:53.707',2,23.03,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (65,'2024-12-30 14:49:53.707',2,23.03,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (66,'2024-12-30 14:49:53.707',2,23.03,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (67,'2024-12-30 14:49:53.707',2,23.03,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (68,'2024-12-30 14:49:53.707',2,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (69,'2024-12-30 14:49:53.707',2,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (70,'2024-12-30 14:49:53.707',2,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (71,'2024-12-30 14:49:53.707',2,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (72,'2024-12-30 14:49:53.707',2,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (73,'2024-12-30 14:49:53.707',2,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (74,'2024-12-30 14:49:53.707',2,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (75,'2024-12-30 14:49:53.707',2,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (76,'2024-12-30 14:49:53.707',2,25.82,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (77,'2024-12-30 14:49:53.707',2,25.82,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (78,'2024-12-30 14:49:53.707',2,21.81,NULL,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (79,'2024-12-30 14:49:53.707',2,21.81,NULL,N'574820a9-b28b-4b37-a665-029d2f41e272');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (80,'2024-12-30 14:49:53.707',2,21.81,NULL,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (81,'2024-12-30 14:49:53.707',2,21.81,NULL,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (82,'2024-12-30 15:38:13.84',3,24.37,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (83,'2024-12-30 15:38:13.84',3,23.03,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (84,'2024-12-30 15:38:13.84',3,27.41,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed'),
	 (85,'2024-12-30 15:38:13.84',3,25.82,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (86,'2024-12-30 15:38:13.84',3,21.81,NULL,N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (87,'2025-01-02 14:10:16.723',3,177.00,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (88,'2025-01-02 15:10:13.267',3,177.00,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (89,'2025-01-02 15:32:00.6',3,177.00,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (90,'2025-01-02 15:35:43.063',3,177.00,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (91,'2025-01-02 15:36:04.64',3,1.77,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (92,'2025-01-02 16:58:48.89',3,1.77,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (93,'2025-01-02 16:59:39.647',3,177.00,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (94,'2025-01-02 17:02:54.8',3,1.77,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (95,'2025-01-02 17:07:22.743',3,1.77,NULL,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (96,'2025-01-02 17:10:20.733',1,80.50,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (97,'2025-01-07 15:01:40.437',1,60.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (98,'2025-01-07 15:02:11.613',2,20.20,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (99,'2025-01-08 13:15:35.777',4,35.00,4,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (127,'2025-02-07 00:00:00.0',1,110.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (128,'2025-02-14 00:00:00.0',1,106.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (129,'2025-02-21 00:00:00.0',1,103.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (130,'2025-02-28 00:00:00.0',1,101.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (131,'2025-03-07 00:00:00.0',1,101.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (132,'2025-03-14 00:00:00.0',1,99.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (133,'2025-03-21 00:00:00.0',1,98.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (134,'2025-03-28 00:00:00.0',1,97.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (135,'2025-04-07 00:00:00.0',1,97.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (136,'2025-04-14 00:00:00.0',1,95.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (137,'2025-04-21 00:00:00.0',1,93.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (138,'2025-04-28 00:00:00.0',1,92.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (139,'2025-05-07 00:00:00.0',1,95.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (140,'2025-05-14 00:00:00.0',1,94.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (141,'2025-05-21 00:00:00.0',1,93.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (142,'2025-05-28 00:00:00.0',1,92.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (143,'2025-06-07 00:00:00.0',1,92.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (144,'2025-06-14 00:00:00.0',1,90.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (145,'2025-06-21 00:00:00.0',1,89.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (146,'2025-06-28 00:00:00.0',1,88.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (147,'2025-07-07 00:00:00.0',1,88.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (148,'2025-07-14 00:00:00.0',1,86.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (149,'2025-07-21 00:00:00.0',1,84.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (150,'2025-07-28 00:00:00.0',1,83.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (151,'2025-07-07 00:00:00.0',4,30.00,4,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (152,'2025-07-14 00:00:00.0',4,32.00,4,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (153,'2025-07-21 00:00:00.0',4,35.00,4,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (154,'2025-07-28 00:00:00.0',4,40.00,4,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (155,'2025-03-07 00:00:00.0',4,10.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (156,'2025-03-14 00:00:00.0',4,12.00,4,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (157,'2025-03-21 00:00:00.0',4,14.00,4,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (158,'2025-03-28 00:00:00.0',4,18.00,4,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (159,'2025-03-12 00:00:00.0',4,95.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (160,'2025-07-12 00:00:00.0',4,110.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
 SET IDENTITY_INSERT dbo.medidas OFF;


 SET IDENTITY_INSERT dbo.metas ON;
INSERT INTO FitnessCenterDB.dbo.metas (metaId,fkIntencion,fkParametro,fkEjercicio,valorObjetivo,fechaDeInicioDeLaMeta,fechaLimite,fechaDeRegistro,fechaDeModificacionDeRegistro,fkNivelDeLogro,fkUsuario) VALUES
	 (6,1,1,1,75.50,'2024-12-31 12:05:47.31','2025-01-30 12:05:47.31','2024-12-31 12:05:47.31','2024-12-31 12:05:47.31',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (7,2,2,NULL,60.00,'2025-01-30 12:05:47.31','2025-03-01 12:05:47.31','2024-12-31 12:05:47.31','2024-12-31 12:05:47.31',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (14,2,1,NULL,70.00,'2025-01-15 00:00:00.0','2025-02-15 00:00:00.0','2025-01-08 11:49:17.367','2025-01-08 11:49:17.367',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (16,2,2,NULL,26.00,'2025-02-15 00:00:00.0','2025-03-15 00:00:00.0','2025-01-08 11:58:41.24','2025-01-08 11:58:41.24',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (17,2,4,4,15.00,'2025-03-01 00:00:00.0','2025-03-31 00:00:00.0','2025-01-08 13:46:25.607','2025-01-08 13:46:25.607',2,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (106,1,1,NULL,100.00,'2025-02-05 00:00:00.0','2025-03-05 00:00:00.0','2025-01-31 13:20:37.483','2025-01-31 13:20:37.483',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (107,1,1,NULL,97.00,'2025-03-05 00:00:00.0','2025-04-05 00:00:00.0','2025-01-31 13:20:37.483','2025-01-31 13:20:37.483',2,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (108,1,1,NULL,94.00,'2025-04-05 00:00:00.0','2025-05-05 00:00:00.0','2025-01-31 13:20:37.483','2025-01-31 13:20:37.483',3,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (109,1,1,NULL,91.00,'2025-05-05 00:00:00.0','2025-06-05 00:00:00.0','2025-01-31 13:20:37.483','2025-01-31 13:20:37.483',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (110,1,1,NULL,88.00,'2025-06-05 00:00:00.0','2025-07-05 00:00:00.0','2025-01-31 13:20:37.483','2025-01-31 13:20:37.483',2,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.metas (metaId,fkIntencion,fkParametro,fkEjercicio,valorObjetivo,fechaDeInicioDeLaMeta,fechaLimite,fechaDeRegistro,fechaDeModificacionDeRegistro,fkNivelDeLogro,fkUsuario) VALUES
	 (111,1,1,NULL,85.00,'2025-07-05 00:00:00.0','2025-08-05 00:00:00.0','2025-01-31 13:20:37.483','2025-01-31 13:20:37.483',3,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (112,1,1,NULL,82.00,'2025-08-05 00:00:00.0','2025-09-05 00:00:00.0','2025-01-31 13:20:37.483','2025-01-31 13:20:37.483',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (113,1,1,NULL,79.00,'2025-09-05 00:00:00.0','2025-10-05 00:00:00.0','2025-01-31 13:20:37.483','2025-01-31 13:20:37.483',2,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (114,1,1,NULL,76.00,'2025-10-05 00:00:00.0','2025-11-05 00:00:00.0','2025-01-31 13:20:37.483','2025-01-31 13:20:37.483',3,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (115,1,1,NULL,73.00,'2025-11-05 00:00:00.0','2025-12-05 00:00:00.0','2025-01-31 13:20:37.483','2025-01-31 13:20:37.483',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (116,1,1,NULL,70.00,'2025-12-05 00:00:00.0','2026-01-05 00:00:00.0','2025-01-31 13:20:37.483','2025-01-31 13:20:37.483',2,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (117,2,4,4,50.00,'2025-07-01 00:00:00.0','2025-07-31 00:00:00.0','2025-03-04 10:32:12.543','2025-03-04 10:32:12.543',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (118,2,4,NULL,90.00,'2025-03-01 00:00:00.0','2025-03-31 00:00:00.0','2025-03-13 15:47:05.283','2025-03-13 15:47:05.283',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (119,2,4,NULL,109.00,'2025-07-01 00:00:00.0','2025-07-31 00:00:00.0','2025-03-13 15:47:25.34','2025-03-13 15:47:25.34',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
 SET IDENTITY_INSERT dbo.metas OFF;

 SET IDENTITY_INSERT dbo.Rutinas ON;
INSERT INTO FitnessCenterDB.dbo.Rutinas (RutinaID,FechaCreacion,Observaciones,fkClase,fkTipoRutina,EntrenadorId,UserId) VALUES
	 (1,'2024-08-09 16:06:26.063',N'ninguna',NULL,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (2,'2024-08-09 14:30:00.0',N'Sesion de entrenamiento de prueba',NULL,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (3,'2024-08-09 14:30:00.0',N'Sesion de entrenamiento de prueba',NULL,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (4,'2024-08-09 23:16:14.517',N'Rutina 1',NULL,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (5,'2024-08-10 00:25:04.137',N'rutina2',NULL,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (6,'2024-08-10 00:28:11.407',N'rutina 3',NULL,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (7,'2024-08-15 12:28:46.29',N'ninguna',NULL,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (8,'2024-08-15 12:47:07.353',N'rutina prueba x',NULL,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (9,'2024-08-16 21:23:25.84',N'Rutina de incio',NULL,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (10,'2024-08-16 21:35:37.737',N'rutina de inicio 2',NULL,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5');
INSERT INTO FitnessCenterDB.dbo.Rutinas (RutinaID,FechaCreacion,Observaciones,fkClase,fkTipoRutina,EntrenadorId,UserId) VALUES
	 (11,'2024-08-16 21:38:25.983',N'ninguna',NULL,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (12,'2024-08-16 21:40:50.123',N'rutina de matias',NULL,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (13,'2024-08-17 00:20:09.693',N'rutina extra',NULL,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (14,'2024-08-17 00:27:40.063',N'ninguna',NULL,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac',N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (15,'2024-08-17 01:35:33.427',N'estar al pendiente de como hace el ejercicio',NULL,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (16,'2024-08-17 01:46:36.8',N'ninguna',NULL,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (17,'2024-08-17 01:47:36.097',N'ninguna',NULL,NULL,N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'574820a9-b28b-4b37-a665-029d2f41e272'),
	 (18,'2024-08-17 01:50:36.237',N'rutina biceps',NULL,NULL,N'e47637e0-1971-4e46-99fb-186db0847fac',N'44e25915-a3df-4bdb-8520-07dca77ecb69'),
	 (19,'2025-04-16 12:53:32.987',N'hacen falta mancuernas se estan quejando los clientes',5,1,N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'44e25915-a3df-4bdb-8520-07dca77ecb69');
 SET IDENTITY_INSERT dbo.Rutinas OFF;


SET IDENTITY_INSERT dbo.EjercicioEquipos ON;
INSERT INTO FitnessCenterDB.dbo.EjercicioEquipos (EjercicioEquipoID,EjercicioID,EquipoID) VALUES
	 (1,8,4),
	 (2,9,3),
	 (3,9,4),
	 (4,10,4),
	 (5,11,1),
	 (6,11,4),
	 (7,12,3),
	 (8,12,4),
	 (9,13,4);
 SET IDENTITY_INSERT dbo.EjercicioEquipos OFF;
 

 SET IDENTITY_INSERT dbo.RutinaEjercicios ON;
INSERT INTO FitnessCenterDB.dbo.RutinaEjercicios (RutinaEjercicioID,RutinaID,EjercicioID,[Sets],Repeticiones,Peso,Tiempo,MetaRepeticiones) VALUES
	 (1,1,1,2,10,51.00,NULL,3),
	 (2,4,1,7,77,62.00,30,12),
	 (3,1,2,4,12,76.00,30,15),
	 (4,2,1,3,7,0.00,0,2),
	 (5,4,2,1,10,0.00,0,2),
	 (6,2,2,3,5,0.00,0,5),
	 (7,4,1,7,77,62.00,30,12),
	 (8,1,1,2,10,51.00,NULL,3),
	 (9,8,2,2,2,0.00,0,2),
	 (10,11,1,3,3,0.00,0,0);
INSERT INTO FitnessCenterDB.dbo.RutinaEjercicios (RutinaEjercicioID,RutinaID,EjercicioID,[Sets],Repeticiones,Peso,Tiempo,MetaRepeticiones) VALUES
	 (11,11,1,3,3,0.00,0,0),
	 (12,15,1,5,5,0.00,0,2),
	 (13,18,1,5,5,0.00,0,0),
	 (14,19,8,3,12,0.00,40,15),
	 (15,19,9,4,0,0.00,45,20),
	 (16,19,10,3,0,0.00,40,30),
	 (17,19,11,4,15,0.00,0,15),
	 (18,19,12,3,0,0.00,30,30),
	 (19,19,13,4,0,0.00,45,25);
 SET IDENTITY_INSERT dbo.RutinaEjercicios OFF;

COMMIT TRANSACTION;
 END TRY
 BEGIN CATCH
	ROLLBACK TRANSACTION;

    -- Opcional: mostrar error
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR('Ocurrió un error: %s', 16, 1, @ErrorMessage);
 END CATCH