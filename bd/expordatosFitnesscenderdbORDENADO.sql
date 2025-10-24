-- Export ordenado de datos FitnessCenterDB (Grupo 1 en orden a partir de __EFMigrationsHistory)

-- __EFMigrationsHistory
SET IDENTITY_INSERT FitnessCenterDB.dbo.[__EFMigrationsHistory] ON;
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
SET IDENTITY_INSERT FitnessCenterDB.dbo.[__EFMigrationsHistory] OFF;

-- AspNetRoles
SET IDENTITY_INSERT FitnessCenterDB.dbo.AspNetRoles ON;
INSERT INTO FitnessCenterDB.dbo.AspNetRoles (Id,Name,NormalizedName,ConcurrencyStamp) VALUES
	 (N'1',N'empleado',N'EMPLEADO',NULL),
	 (N'2',N'cliente',N'CLIENTE',NULL);
SET IDENTITY_INSERT FitnessCenterDB.dbo.AspNetRoles OFF;

-- AspNetUsers
SET IDENTITY_INSERT FitnessCenterDB.dbo.AspNetUsers ON;
INSERT INTO FitnessCenterDB.dbo.AspNetUsers (Id,NombreCompleto,UserName,NormalizedUserName,Email,NormalizedEmail,EmailConfirmed,PasswordHash,SecurityStamp,ConcurrencyStamp,PhoneNumber,PhoneNumberConfirmed,TwoFactorEnabled,LockoutEnd,LockoutEnabled,AccessFailedCount,NumeroDeIdentificacion,Direccion,FechaDeNacimiento,Apellido,Estado,FechaDeRegistro,IdAntiguo) VALUES
	 (N'44e25915-a3df-4bdb-8520-07dca77ecb69',N'Rebeca',N'rebeca@gmail.com',N'REBECA@GMAIL.COM',N'rebeca@gmail.com',N'REBECA@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEAlR4VRZOCaRSFVeGIQDPEnLXDCuI9qdt+9MhRfdw2vCGy+WV9pFwMKhF+0x4pg1jQ==',N'V2FZC6Q32QDD7AL5ECPAXIWAAOXZR273',N'7224b2ec-2edd-49d0-89a5-9b9d0f9a32e7',N'9999999',0,0,NULL,1,0,N'ROROA3334',N'aslalalsa','2024-08-17 00:00:00.0000000',N'delgado',N'activo','0001-01-01 00:00:00.0000000',17),
	 (N'5696d821-ab0c-40d5-9cd2-123232bc4eec',N'matias',N'matias@gmail.com',N'MATIAS@GMAIL.COM',N'matias@gmail.com',N'MATIAS@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEFEPyneTGhticpIqlRp0ScT1ycIa05W+SuOgM45yKkIaQhtTZDXeHNVb0TqLDRMk4w==',N'ECU5XD2BC3FCLC7OSVCITFHDZJUVZ5CK',N'aa24b10e-e8e6-4064-8e1a-33bf6ce2f3bc',N'9999999',0,0,NULL,1,0,N'RORA12350',N'aslalalsa','2024-08-06 00:00:00.0000000',N'botero',N'activo','0001-01-01 00:00:00.0000000',16),
	 (N'574820a9-b28b-4b37-a665-029d2f41e272',N'Valeria',N'valeriag@gmail.com',N'VALERIAG@GMAIL.COM',N'valeriag@gmail.com',N'VALERIAG@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEBu6np9P4Qo0qwjSt7I1E2utQXI34GXD4D+ASchriTMkzpw7k6UTxclxC2ewrEnDyw==',N'CCGYZQ4XVQR6AISH5SA3GW7VOY3RAKRT',N'550a096c-69c9-4489-b318-9f42eaa1cd92',N'9999999',0,0,NULL,1,0,N'ROROA3334',N'aslalalsa','1998-10-06 00:00:00.0000000',N'Gomez',N'activo','0001-01-01 00:00:00.0000000',19),
	 (N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'Yesenia',N'yesyes@gmail.com',N'YESYES@GMAIL.COM',N'yesyes@gmail.com',N'YESYES@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEGFV7o2rnKEDIcs3F/c8G4UVZOn0MsY2lUn8iJtL0xw6rhRzB/ueP5TrOI/upqRQPA==',N'PAVNRX6B7H3OILFOEDBBJM2ZLLKXZ2N2',N'f00ddca9-192b-4a88-aec7-cb5139354919',N'9999999',0,0,NULL,1,0,N'RORA12350',N'aslalalsa','0001-11-15 00:00:00.0000000',N'esquivel',N'activo','0001-01-01 00:00:00.0000000',15),
	 (N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5',N'Juan',N'aaronhl1313@gmail.com',N'AARONHL1313@GMAIL.COM',N'aaronhl1313@gmail.com',N'AARONHL1313@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEIdeJlW2345fcSJLtEqSGyqmUV+l9kqkpGI1lvxfSvcxQzd4onsxsL1Gp8oa47nOTQ==',N'E6OO45X37OYE5ZSTBR42ZDCYASXJIF5I',N'dd0b6615-1ee2-441c-83b6-792d30f0f07c',N'9999999',0,0,NULL,1,0,N'RORO12350',N'aslalalsa','2024-01-15 00:00:00.0000000',N'Martinez',N'activo','0001-01-01 00:00:00.0000000',3),
	 (N'e47637e0-1971-4e46-99fb-186db0847fac',N'aaron',N'uno@gmail.com',N'UNO@GMAIL.COM',N'uno@gmail.com',N'UNO@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEL3XDmXzqqKV8bEy/ZCfViYt6Nl+QxhL5R239sV3Oliu7Y+3+j2ZjviDRXli+4h0Bg==',N'HPTR4SJOAVCGNCXHJPXQXD4COT55K2TP',N'56be8c9f-7b09-409f-b920-42971f19ef95',N'+522263647876',0,0,NULL,1,0,N'V777AA6777',N'123 Calle Principal, ciudad de mexico, Mexico','1959-05-15 00:00:00.0000000',N'Azcarraga',N'activo','2025-09-11 12:39:17.3200000',13),
	 (N'ec4a4f9d-02b8-402a-b274-8924adb46e46',N'antonio',N'antoniom@gmail.com',N'ANTONIOM@GMAIL.COM',N'antoniom@gmail.com',N'ANTONIOM@GMAIL.COM',1,N'AQAAAAIAAYagAAAAEPVSSb1GEl6j2K5kbJ/EaE/2nUUIB4hFJKAuK6YYe/Wp5WBxPT1/UZr62t0lYSpwvw==',N'SBFEQMKV5F63Y6XB3NUK3HZQTALELKHD',N'c33ab3eb-ca17-420a-a741-f6d13275d6f4',N'9999999',0,0,NULL,1,0,N'ROROA3334',N'aslalalsa','2025-04-16 00:00:00.0000000',N'marquez',N'activo','0001-01-01 00:00:00.0000000',22);
SET IDENTITY_INSERT FitnessCenterDB.dbo.AspNetUsers OFF;

-- Descuentos (vacío)

-- Roles
SET IDENTITY_INSERT FitnessCenterDB.dbo.Roles ON;
INSERT INTO FitnessCenterDB.dbo.Roles (RolID,NombreRol) VALUES
	 (1,N'cliente'),
	 (2,N'empleado');
SET IDENTITY_INSERT FitnessCenterDB.dbo.Roles OFF;

-- Servicios (vacío)

-- TipoRutina
SET IDENTITY_INSERT FitnessCenterDB.dbo.TipoRutina ON;
INSERT INTO FitnessCenterDB.dbo.TipoRutina (idTipoRutina,nombreTipoRutina,fechaDeCreacion,fechaDeModificacion) VALUES
	 (1,N'clase','2025-04-16 12:44:46.527','2025-04-16 12:44:46.527'),
	 (2,N'personal','2025-04-16 12:44:46.527','2025-04-16 12:44:46.527');
SET IDENTITY_INSERT FitnessCenterDB.dbo.TipoRutina OFF;

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
	 (1,N'Activa',N'La clase está activa y disponible para inscripciones','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47'),
	 (2,N'Inactiva',N'La clase está temporalmente suspendida','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47'),
	 (3,N'Cancelada',N'La clase ha sido cancelada permanentemente','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47'),
	 (4,N'Completa',N'La clase ha alcanzado su cupo máximo','2025-05-04 16:59:52.47','2025-05-04 16:59:52.47');
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
	 (3,N'anual',N'Se repite cada año en una fecha fija, por ejemplo 10 de mayo,2 de noviembre','2025-05-14 14:42:43.34',NULL),
	 (4,N'semanaDia',N'Se repite pero la fecha es variable,por ejemplo dia del padre','2025-05-14 14:42:43.34','2025-05-16 11:46:05.737'),
	 (5,N'diaRelativo',N'pensado para los dias de descanso establecidos de fin de semana, osea un dia de la semana tal cual,sabado,domingo,sin importar el mes,año o semana','2025-05-16 11:49:03.813',NULL),
	 (6,N'diaConsecutivo',N'un dia del año especifico considerando su numero consecutivo en el año,osea 1-365,por ejemplo dia del programador que es el dia 256 del año','2025-05-16 11:51:06.347',NULL);
SET IDENTITY_INSERT FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos OFF;

-- unidadesDeMedida
SET IDENTITY_INSERT FitnessCenterDB.dbo.unidadesDeMedida ON;
INSERT INTO FitnessCenterDB.dbo.unidadesDeMedida (unidadDeMedidaId,nombre,fechaDeRegistro,fechaModificacionDeRegistro) VALUES
	 (1,N'kg','2024-12-30 14:54:34.76',NULL),
	 (2,N' kg/m²','2024-12-30 14:54:34.76',NULL),
	 (3,N'm','2024-12-30 15:30:49.63',NULL);
SET IDENTITY_INSERT FitnessCenterDB.dbo.unidadesDeMedida OFF;

-- =============================
-- Grupo 2: Tablas con dependencias de Grupo 1
-- =============================

-- AccessTokens (GRAN VOLUMEN): se añadirá en la siguiente parte

-- AspNetRoleClaims (vacío)

-- AspNetUserClaims (vacío)

-- AspNetUserLogins (vacío)

-- AspNetUserRoles
SET IDENTITY_INSERT FitnessCenterDB.dbo.AspNetUserRoles ON;
INSERT INTO FitnessCenterDB.dbo.AspNetUserRoles (UserId,RoleId) VALUES
	 (N'5696d821-ab0c-40d5-9cd2-123232bc4eec',N'1'),
	 (N'8094a747-55d9-4782-9b31-b6602a79b7ed',N'1'),
	 (N'e47637e0-1971-4e46-99fb-186db0847fac',N'1'),
	 (N'ec4a4f9d-02b8-402a-b274-8924adb46e46',N'1'),
	 (N'44e25915-a3df-4bdb-8520-07dca77ecb69',N'2'),
	 (N'574820a9-b28b-4b37-a665-029d2f41e272',N'2'),
	 (N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5',N'2'),
	 (N'e47637e0-1971-4e46-99fb-186db0847fac',N'2');
SET IDENTITY_INSERT FitnessCenterDB.dbo.AspNetUserRoles OFF;

-- AspNetUserTokens (vacío)

-- Citas
SET IDENTITY_INSERT FitnessCenterDB.dbo.Citas ON;
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
SET IDENTITY_INSERT FitnessCenterDB.dbo.Citas OFF;

-- Clases
SET IDENTITY_INSERT FitnessCenterDB.dbo.Clases ON;
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
SET IDENTITY_INSERT FitnessCenterDB.dbo.Clases OFF;

-- Cupones (vacío)

-- Ejercicios
SET IDENTITY_INSERT FitnessCenterDB.dbo.Ejercicios ON;
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
SET IDENTITY_INSERT FitnessCenterDB.dbo.Ejercicios OFF;

-- Equipos
SET IDENTITY_INSERT FitnessCenterDB.dbo.Equipos ON;
INSERT INTO FitnessCenterDB.dbo.Equipos (EquipoID,NombreEquipo,Descripcion,fkIcon) VALUES
	 (1,N'Mancuernas Ligeras',N'Para añadir resistencia a ejercicios como sentadillas o press de hombros.',3),
	 (2,N'Kettlebells',N'Ideales para ejercicios balísticos como swings o clean and press.',4),
	 (3,N'Esterilla',N'Para mayor comodidad en ejercicios de suelo como planchas o abdominales.',5),
	 (4,N'Botella de Agua',N'Fundamental para mantenerte hidratado durante el entrenamiento intenso.',6);
SET IDENTITY_INSERT FitnessCenterDB.dbo.Equipos OFF;

-- Pagos (vacío)

-- RefreshTokens (GRAN VOLUMEN): se añadirá en la siguiente parte

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

-- diasFestivosVariables (pendiente, no leído aún)
-- diasFestivosYDescansos (pendiente, no leído aún)

-- parametrosDeMedicion
SET IDENTITY_INSERT FitnessCenterDB.dbo.parametrosDeMedicion ON;
INSERT INTO FitnessCenterDB.dbo.parametrosDeMedicion (parametroMedicionId,nombre,fechaDeRegistro,fechaModificacionDeRegistro,fkIcon) VALUES
	 (1,N'peso','2024-12-30 15:08:38.46',NULL,NULL),
	 (2,N'imc','2024-12-30 15:08:38.46',NULL,NULL),
	 (3,N'altura','2024-12-30 15:31:14.317',NULL,NULL),
	 (4,N'fuerza','2025-01-08 12:48:35.283',NULL,2);
SET IDENTITY_INSERT FitnessCenterDB.dbo.parametrosDeMedicion OFF;

-- preReservasDeHorario
SET IDENTITY_INSERT FitnessCenterDB.dbo.preReservasDeHorario ON;
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
SET IDENTITY_INSERT FitnessCenterDB.dbo.preReservasDeHorario OFF;

-- =====================================================
-- GRUPO 3: TABLAS CON DEPENDENCIAS DE GRUPO 1 Y/O GRUPO 2
-- =====================================================

-- beneficiosDeClase
SET IDENTITY_INSERT FitnessCenterDB.dbo.beneficiosDeClase ON;
INSERT INTO FitnessCenterDB.dbo.beneficiosDeClase (idBeneficio,fkClase,beneficio,fechaDeCreacion,fechaDeModificacion,fkIcon,descripcionBeneficio) VALUES
	 (1,1,N'aumentar masa muscular','2025-05-04 17:01:21.077',NULL,1,N'Beneficios enfocados a ganar masa muscular en el pecho');
SET IDENTITY_INSERT FitnessCenterDB.dbo.beneficiosDeClase OFF;

-- clasesProgramadas
SET IDENTITY_INSERT FitnessCenterDB.dbo.clasesProgramadas ON;
INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (idProgramacionClase,fkClase,cupoMaximo,fkEstadoClaseProgramada,fechaCreacion,fechaModificacion,fkEntrenador) VALUES
	 (1,1,10,1,'2025-05-07 15:02:18.423',NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (2,1,10,1,'2025-05-07 15:02:18.423',NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (3,2,10,1,'2025-05-07 15:02:18.423',NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (4,2,10,1,'2025-05-07 15:02:18.423',NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (5,5,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (6,5,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (7,6,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (8,6,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (9,7,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (10,7,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (11,8,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (12,8,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (13,9,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (14,9,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (15,10,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (16,10,10,1,'2025-05-07 15:02:18.423','2025-05-07 15:02:18.423',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (17,12,20,1,'2025-05-07 15:02:18.423',NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (18,12,20,1,'2025-05-07 15:02:18.423',NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (19,1,10,1,'2025-09-24 16:21:05.157',NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (20,1,10,1,'2025-09-24 16:21:05.157',NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (21,1,10,1,'2025-09-24 16:21:05.157',NULL,N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (22,1,10,1,'2025-09-24 16:21:05.157',NULL,N'e47637e0-1971-4e46-99fb-186db0847fac');
SET IDENTITY_INSERT FitnessCenterDB.dbo.clasesProgramadas OFF;

-- consejosParaLasClases
SET IDENTITY_INSERT FitnessCenterDB.dbo.consejosParaLasClases ON;
INSERT INTO FitnessCenterDB.dbo.consejosParaLasClases (idConsejo,fkClase,fkEjercicio,introduccionDeConsejo,consejos) VALUES
	 (1,1,NULL,N'calentamiento',N'Calienta con 10-15 minutos de cardio ligero y estiramientos dinámicos.');
SET IDENTITY_INSERT FitnessCenterDB.dbo.consejosParaLasClases OFF;

-- estructuraDeClase
SET IDENTITY_INSERT FitnessCenterDB.dbo.estructuraDeClase ON;
INSERT INTO FitnessCenterDB.dbo.estructuraDeClase (idBloque,fkClase,numeroConsecutivoDelBloque,duracionMenorEnMinutos,duracionMayorEnMinutos,tituloBloque,descripcionBloque,fechaDeCreacion,fechaDeModificacion) VALUES
	 (1,1,1,10,15,N'Calentamiento',N'Calentamiento de 10-15 minutos con ejercicios de movilidad y cardio ligero','2025-05-04 17:00:54.673','2025-05-04 17:00:54.673');
SET IDENTITY_INSERT FitnessCenterDB.dbo.estructuraDeClase OFF;

-- horariosDeClasesProgramadas
SET IDENTITY_INSERT FitnessCenterDB.dbo.horariosDeClasesProgramadas ON;
INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas (idHorarioDeClaseProgramada,fkClaseProgramada,fkHorarioLaboral,fkEstadoHorarioClase,fechaDeLaClase,fkEntrenador) VALUES
	 (1,1,1,1,'2025-05-07',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (2,1,2,1,'2025-05-07',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (3,2,3,1,'2025-05-07',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (4,2,4,1,'2025-05-07',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (5,3,5,1,'2025-05-07',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (6,3,6,1,'2025-05-07',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (7,4,7,1,'2025-05-07',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (8,4,8,1,'2025-05-07',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (9,5,9,1,'2025-05-07',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (10,5,10,1,'2025-05-07',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (11,19,1,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (12,19,3,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (13,19,5,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (14,19,8,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (15,19,4,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (16,19,3,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (17,19,6,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (18,19,2,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (19,20,1,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (20,20,5,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac'),
	 (21,20,4,1,'2025-09-24',N'e47637e0-1971-4e46-99fb-186db0847fac');
SET IDENTITY_INSERT FitnessCenterDB.dbo.horariosDeClasesProgramadas OFF;

-- imagesForClases
SET IDENTITY_INSERT FitnessCenterDB.dbo.imagesForClases ON;
INSERT INTO FitnessCenterDB.dbo.imagesForClases (idClassImage,fkClase,urlParaBanner,urlParaParaDescripcionDeClase,urlParaBloqueConsejos,FechaDeCreacion,FechaDeModificacion) VALUES
	 (1,1,N'/content/banner-clase-pecho.png',N'/content/descripcion-clase-pecho.png',N'/content/consejos-clase-pecho.png','2025-05-04 17:02:08.57',NULL);
SET IDENTITY_INSERT FitnessCenterDB.dbo.imagesForClases OFF;

-- imagesForExercises
SET IDENTITY_INSERT FitnessCenterDB.dbo.imagesForExercises ON;
INSERT INTO FitnessCenterDB.dbo.imagesForExercises (idImage,fkEjercicio,nombreParaElFront,urlPrivada,urlPublica) VALUES
	 (1,1,N'Dominadas Vista Frontal',N'/content/ejercicios/dominadas_frontal.png',N'/content/ejercicios/dominadas_frontal.png');
SET IDENTITY_INSERT FitnessCenterDB.dbo.imagesForExercises OFF;

-- inscripcionesDeClases
SET IDENTITY_INSERT FitnessCenterDB.dbo.inscripcionesDeClases ON;
INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases (idInscripcion,fkProgramacionClase,fechaDeInscripcion,fkEstadoInscripcion,fkCliente) VALUES
	 (1,1,'2025-05-30 14:20:18.667',1,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (2,1,'2025-05-30 14:20:18.667',2,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (3,1,'2025-05-30 14:20:18.667',3,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (4,1,'2025-05-30 14:20:18.667',4,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (5,1,'2025-05-30 14:20:18.667',5,N'c7f8eb66-cbd8-43cf-8812-1b369fc84ca5'),
	 (6,19,'2025-09-24 16:32:05.157',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (7,20,'2025-09-24 16:32:05.157',1,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
SET IDENTITY_INSERT FitnessCenterDB.dbo.inscripcionesDeClases OFF;

-- ejercicios_parametrosDeMedicion
SET IDENTITY_INSERT FitnessCenterDB.dbo.ejercicios_parametrosDeMedicion ON;
INSERT INTO FitnessCenterDB.dbo.ejercicios_parametrosDeMedicion (id,fkEjercicio,fkParametro,fechaCreacion,fechaModificacion) VALUES
	 (1,1,1,'2025-01-08 13:00:00.0',NULL);
SET IDENTITY_INSERT FitnessCenterDB.dbo.ejercicios_parametrosDeMedicion OFF;

-- medidas
SET IDENTITY_INSERT FitnessCenterDB.dbo.medidas ON;
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (1,'2025-01-01 00:00:00.0',1,100.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (2,'2025-01-07 00:00:00.0',1,99.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (3,'2025-01-14 00:00:00.0',1,98.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (4,'2025-01-21 00:00:00.0',1,97.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (5,'2025-01-28 00:00:00.0',1,96.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (6,'2025-02-07 00:00:00.0',1,95.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (7,'2025-02-14 00:00:00.0',1,94.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (8,'2025-02-21 00:00:00.0',1,93.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (9,'2025-02-28 00:00:00.0',1,92.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (10,'2025-03-07 00:00:00.0',1,91.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (11,'2025-03-14 00:00:00.0',1,90.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (12,'2025-03-21 00:00:00.0',1,89.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (13,'2025-03-28 00:00:00.0',1,88.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (14,'2025-04-07 00:00:00.0',1,87.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (15,'2025-04-14 00:00:00.0',1,86.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (16,'2025-04-21 00:00:00.0',1,85.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (17,'2025-04-28 00:00:00.0',1,84.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (18,'2025-05-07 00:00:00.0',1,83.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (19,'2025-05-14 00:00:00.0',1,82.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (20,'2025-05-21 00:00:00.0',1,81.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (21,'2025-05-28 00:00:00.0',1,80.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (22,'2025-06-07 00:00:00.0',1,79.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (23,'2025-06-14 00:00:00.0',1,78.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (24,'2025-06-21 00:00:00.0',1,77.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (25,'2025-06-28 00:00:00.0',1,76.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (26,'2025-07-07 00:00:00.0',1,75.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (27,'2025-07-14 00:00:00.0',1,74.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (28,'2025-07-21 00:00:00.0',1,73.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (29,'2025-07-28 00:00:00.0',1,72.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (30,'2025-08-07 00:00:00.0',1,71.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (31,'2025-08-14 00:00:00.0',1,70.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (32,'2025-08-21 00:00:00.0',1,69.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (33,'2025-08-28 00:00:00.0',1,68.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (34,'2025-09-07 00:00:00.0',1,67.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (35,'2025-09-14 00:00:00.0',1,66.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (36,'2025-09-21 00:00:00.0',1,65.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (37,'2025-09-28 00:00:00.0',1,64.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (38,'2025-10-07 00:00:00.0',1,63.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (39,'2025-10-14 00:00:00.0',1,62.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (40,'2025-10-21 00:00:00.0',1,61.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (41,'2025-10-28 00:00:00.0',1,60.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (42,'2025-11-07 00:00:00.0',1,59.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (43,'2025-11-14 00:00:00.0',1,58.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (44,'2025-11-21 00:00:00.0',1,57.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (45,'2025-11-28 00:00:00.0',1,56.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (46,'2025-12-07 00:00:00.0',1,55.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (47,'2025-12-14 00:00:00.0',1,54.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (48,'2025-12-21 00:00:00.0',1,53.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (49,'2025-12-28 00:00:00.0',1,52.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (50,'2026-01-07 00:00:00.0',1,51.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (51,'2026-01-14 00:00:00.0',1,50.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (52,'2026-01-21 00:00:00.0',1,49.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (53,'2026-01-28 00:00:00.0',1,48.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (54,'2026-02-07 00:00:00.0',1,47.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (55,'2026-02-14 00:00:00.0',1,46.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (56,'2026-02-21 00:00:00.0',1,45.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (57,'2026-02-28 00:00:00.0',1,44.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (58,'2026-03-07 00:00:00.0',1,43.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (59,'2026-03-14 00:00:00.0',1,42.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (60,'2026-03-21 00:00:00.0',1,41.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (61,'2026-03-28 00:00:00.0',1,40.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (62,'2026-04-07 00:00:00.0',1,39.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (63,'2026-04-14 00:00:00.0',1,38.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (64,'2026-04-21 00:00:00.0',1,37.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (65,'2026-04-28 00:00:00.0',1,36.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (66,'2026-05-07 00:00:00.0',1,35.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (67,'2026-05-14 00:00:00.0',1,34.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (68,'2026-05-21 00:00:00.0',1,33.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (69,'2026-05-28 00:00:00.0',1,32.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (70,'2026-06-07 00:00:00.0',1,31.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (71,'2026-06-14 00:00:00.0',1,30.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (72,'2026-06-21 00:00:00.0',1,29.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (73,'2026-06-28 00:00:00.0',1,28.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (74,'2026-07-07 00:00:00.0',1,27.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (75,'2026-07-14 00:00:00.0',1,26.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (76,'2026-07-21 00:00:00.0',1,25.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (77,'2026-07-28 00:00:00.0',1,24.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (78,'2026-08-07 00:00:00.0',1,23.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (79,'2026-08-14 00:00:00.0',1,22.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (80,'2026-08-21 00:00:00.0',1,21.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (81,'2026-08-28 00:00:00.0',1,20.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (82,'2026-09-07 00:00:00.0',1,19.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (83,'2026-09-14 00:00:00.0',1,18.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (84,'2026-09-21 00:00:00.0',1,17.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (85,'2026-09-28 00:00:00.0',1,16.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (86,'2026-10-07 00:00:00.0',1,15.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (87,'2026-10-14 00:00:00.0',1,14.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (88,'2026-10-21 00:00:00.0',1,13.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (89,'2026-10-28 00:00:00.0',1,12.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (90,'2026-11-07 00:00:00.0',1,11.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (91,'2026-11-14 00:00:00.0',1,10.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (92,'2026-11-21 00:00:00.0',1,9.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (93,'2026-11-28 00:00:00.0',1,8.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (94,'2026-12-07 00:00:00.0',1,7.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (95,'2026-12-14 00:00:00.0',1,6.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (96,'2026-12-21 00:00:00.0',1,5.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (97,'2026-12-28 00:00:00.0',1,4.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (98,'2027-01-07 00:00:00.0',1,3.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (99,'2027-01-14 00:00:00.0',1,2.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (100,'2027-01-21 00:00:00.0',1,1.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (101,'2027-01-28 00:00:00.0',1,0.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (102,'2025-01-01 00:00:00.0',2,25.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (103,'2025-01-07 00:00:00.0',2,24.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (104,'2025-01-14 00:00:00.0',2,24.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (105,'2025-01-21 00:00:00.0',2,24.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (106,'2025-01-28 00:00:00.0',2,24.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (107,'2025-02-07 00:00:00.0',2,23.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (108,'2025-02-14 00:00:00.0',2,23.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (109,'2025-02-21 00:00:00.0',2,23.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (110,'2025-02-28 00:00:00.0',2,23.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (111,'2025-03-07 00:00:00.0',2,22.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (112,'2025-03-14 00:00:00.0',2,22.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (113,'2025-03-21 00:00:00.0',2,22.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (114,'2025-03-28 00:00:00.0',2,22.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (115,'2025-04-07 00:00:00.0',2,21.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (116,'2025-04-14 00:00:00.0',2,21.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (117,'2025-04-21 00:00:00.0',2,21.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (118,'2025-04-28 00:00:00.0',2,21.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (119,'2025-05-07 00:00:00.0',2,20.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (120,'2025-05-14 00:00:00.0',2,20.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (121,'2025-05-21 00:00:00.0',2,20.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (122,'2025-05-28 00:00:00.0',2,20.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (123,'2025-06-07 00:00:00.0',2,19.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (124,'2025-06-14 00:00:00.0',2,19.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (125,'2025-06-21 00:00:00.0',2,19.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (126,'2025-06-28 00:00:00.0',2,19.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (127,'2025-07-07 00:00:00.0',2,18.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (128,'2025-07-14 00:00:00.0',2,18.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (129,'2025-07-21 00:00:00.0',2,18.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (130,'2025-07-28 00:00:00.0',2,18.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (131,'2025-08-07 00:00:00.0',2,17.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (132,'2025-08-14 00:00:00.0',2,17.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (133,'2025-08-21 00:00:00.0',2,17.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (134,'2025-08-28 00:00:00.0',2,17.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (135,'2025-09-07 00:00:00.0',2,16.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (136,'2025-09-14 00:00:00.0',2,16.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (137,'2025-09-21 00:00:00.0',2,16.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (138,'2025-09-28 00:00:00.0',2,16.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (139,'2025-10-07 00:00:00.0',2,15.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (140,'2025-10-14 00:00:00.0',2,15.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (141,'2025-10-21 00:00:00.0',2,15.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (142,'2025-10-28 00:00:00.0',2,15.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (143,'2025-11-07 00:00:00.0',2,14.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (144,'2025-11-14 00:00:00.0',2,14.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (145,'2025-11-21 00:00:00.0',2,14.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (146,'2025-11-28 00:00:00.0',2,14.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (147,'2025-12-07 00:00:00.0',2,13.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (148,'2025-12-14 00:00:00.0',2,13.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (149,'2025-12-21 00:00:00.0',2,13.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (150,'2025-12-28 00:00:00.0',2,13.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (151,'2026-01-07 00:00:00.0',2,12.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (152,'2026-01-14 00:00:00.0',2,12.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (153,'2026-01-21 00:00:00.0',2,12.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (154,'2026-01-28 00:00:00.0',2,12.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (155,'2025-03-07 00:00:00.0',4,10.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (156,'2025-03-14 00:00:00.0',4,12.00,4,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (157,'2025-03-21 00:00:00.0',4,14.00,4,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (158,'2025-03-28 00:00:00.0',4,18.00,4,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (159,'2025-03-12 00:00:00.0',4,95.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (160,'2025-07-12 00:00:00.0',4,110.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');

-- metas
SET IDENTITY_INSERT FitnessCenterDB.dbo.metas ON;
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

-- Rutinas
SET IDENTITY_INSERT FitnessCenterDB.dbo.Rutinas ON;
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

-- EjercicioEquipos
SET IDENTITY_INSERT FitnessCenterDB.dbo.EjercicioEquipos ON;
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

-- =====================================================
-- GRUPO 4: TABLAS CON DEPENDENCIAS DE GRUPO 3
-- =====================================================

-- RutinaEjercicios
SET IDENTITY_INSERT FitnessCenterDB.dbo.RutinaEjercicios ON;
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
SET IDENTITY_INSERT FitnessCenterDB.dbo.RutinaEjercicios OFF;

-- =====================================================
-- GRUPO 5: TABLAS CON DEPENDENCIAS DE GRUPO 4
-- =====================================================

-- DetalleEntrenamiento (vacío - no hay datos en el archivo original)
-- RegistrosEntrenamiento (vacío - no hay datos en el archivo original)