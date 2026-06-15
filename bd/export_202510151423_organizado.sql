-- =====================================================
-- ARCHIVO DE INSERTS ORGANIZADO POR DEPENDENCIAS
-- Basado en: orden de insercion de datos en FitnessCenterDb de acuerdo a sus dependencias.md
-- Archivo original: export_202510151423.sql
-- =====================================================

-- =====================================================
-- GRUPO 1: TABLAS SIN DEPENDENCIAS
-- =====================================================

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

-- =====================================================
-- GRUPO 2: TABLAS CON DEPENDENCIAS DE GRUPO 1
-- =====================================================

-- parametrosDeMedicion (depende de iconsForParameters)
INSERT INTO FitnessCenterDB.dbo.parametrosDeMedicion (parametroMedicionId,nombre,fechaDeRegistro,fechaModificacionDeRegistro,fkIcon) VALUES
	 (1,N'peso','2024-12-30 15:08:38.46',NULL,NULL),
	 (2,N'imc','2024-12-30 15:08:38.46',NULL,NULL),
	 (3,N'altura','2024-12-30 15:31:14.317',NULL,NULL),
	 (4,N'fuerza','2025-01-08 12:48:35.283',NULL,2);

-- parametros_unidadesDeMedida (depende de parametrosDeMedicion, unidadesDeMedida)
INSERT INTO FitnessCenterDB.dbo.parametros_unidadesDeMedida (fkParametroDeMedicion,fkUnidadDeMedida,fechaDeRegistro) VALUES
	 (1,1,'2025-01-01 12:59:35.08'),
	 (2,2,'2025-01-01 12:59:35.08'),
	 (3,3,'2025-01-01 12:59:35.08'),
	 (4,1,'2025-01-08 14:33:06.443');

-- preReservasDeHorario (depende de horasLaborales)
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

-- =====================================================
-- GRUPO 3: TABLAS CON DEPENDENCIAS DE GRUPO 1 Y/O GRUPO 2
-- =====================================================

-- medidas (depende de parametrosDeMedicion, Ejercicios, AspNetUsers)
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
	 (120,'2025-05-14 00:00:00.0',2,20.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (121,'2025-05-21 00:00:00.0',2,20.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (122,'2025-05-28 00:00:00.0',2,20.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (123,'2025-06-07 00:00:00.0',2,19.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (124,'2025-06-14 00:00:00.0',2,19.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (125,'2025-06-21 00:00:00.0',2,19.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (126,'2025-06-28 00:00:00.0',2,19.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (127,'2025-07-07 00:00:00.0',2,18.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (128,'2025-07-14 00:00:00.0',2,18.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (129,'2025-07-21 00:00:00.0',2,18.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (130,'2025-07-28 00:00:00.0',2,18.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
	 (131,'2025-08-07 00:00:00.0',2,17.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (132,'2025-08-14 00:00:00.0',2,17.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (133,'2025-08-21 00:00:00.0',2,17.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (134,'2025-08-28 00:00:00.0',2,17.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (135,'2025-09-07 00:00:00.0',2,16.75,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (136,'2025-09-14 00:00:00.0',2,16.50,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (137,'2025-09-21 00:00:00.0',2,16.25,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (138,'2025-04-28 00:00:00.0',1,92.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (139,'2025-05-07 00:00:00.0',1,95.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec'),
	 (140,'2025-05-14 00:00:00.0',1,94.00,NULL,N'5696d821-ab0c-40d5-9cd2-123232bc4eec');
INSERT INTO FitnessCenterDB.dbo.medidas (medidaId,fechaDeCreacion,fkParametro,valor,fkEjercicio,fkUsuario) VALUES
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

-- metas (depende de intenciones, parametrosDeMedicion, Ejercicios, nivelesDeLogro, AspNetUsers)
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

-- =====================================================
-- FIN DEL ARCHIVO ORGANIZADO
-- =====================================================
-- NOTA: Se omitió la tabla AccessTokens según solicitud del usuario
-- Este archivo respeta el orden de dependencias establecido en el documento de referencia
-- =====================================================
