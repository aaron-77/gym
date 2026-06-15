INSERT INTO FitnessCenterDB.dbo.tiposDeRecurrenciaDeDiasFestivos (idTipoDeRecurrenciaDeDiaFestivo,nombreTipoDeRecurrencia,descripcion,fechaCreacion,fechaModificacion) VALUES
	 (1,N'semanal',N'Se repite cada semana, es un o unos dias especificos de la semana, por ejemplo domingo o sabao y domingo','2025-05-14 14:42:43.34',NULL),
	 (2,N'mensual',N'Se repite cada mes en una fecha fija,no es comun pero debe tomarse en cuenta','2025-05-14 14:42:43.34',NULL),
	 (3,N'anual',N'Se repite cada año en una fecha fija, por ejemplo 10 de mayo,2 de noviembre','2025-05-14 14:42:43.34',NULL),
	 (4,N'semanaDia',N'Se repite pero la fecha es variable,por ejemplo dia del padre','2025-05-14 14:42:43.34','2025-05-16 11:46:05.737'),
	 (5,N'diaRelativo',N'pensado para los dias de descanso establecidos de fin de semana, osea un dia de la semana tal cual,sabado,domingo,sin importar el mes,año o semana','2025-05-16 11:49:03.813',NULL),
	 (6,N'diaConsecutivo',N'un dia del año especifico considerando su numero consecutivo en el año,osea 1-365,por ejemplo dia del programador que es el dia 256 del año','2025-05-16 11:51:06.347',NULL);
