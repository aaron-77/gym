use fitnessCenterDB
-- =============================================
-- Pruebas: dbo.fn_obtenerDiasFestivosVariablesActuales
--
-- Requiere: dbo.DatosDiaFestivoVariable (table type)
--           dbo.fn_obtenerFechasDeDiasFestivosVariables
--           dbo.fn_obtenerNombreTipoDeRecurrencia
--           dbo.diasFestivosVariables con datos
--           dbo.estadosDeActividadLaboral con estado 'activo'
--
-- SIN GO - compatible con DBeaver
-- =============================================

-- =============================================
-- Preparacion: ver que datos existen en la tabla
-- =============================================
SELECT '--- PREPARACION: festivos activos ---' AS info;
select * from FitnessCenterDB.dbo.estadosDeActividadLaboral edal 
select * from FitnessCenterDB.dbo.diasFestivosVariables
SELECT dfv.idDiaFestivoVariable,
       dfv.nombreDiasFestivoVariable,
       dfv.deQueDia,
       dfv.deQueSemana,
       dfv.deQueMes,
       dfv.fkTipoDeRecurrenciaDelFestivo,
       trd.nombreTipoDeRecurrencia,
       eal.nombreEstadoActividadLaboral AS estado
FROM dbo.diasFestivosVariables dfv
LEFT JOIN dbo.tiposDeRecurrenciaDeDiasFestivos trd
    ON dfv.fkTipoDeRecurrenciaDelFestivo = trd.idTipoDeRecurrenciaDeDiaFestivo
INNER JOIN dbo.estadosDeActividadLaboral eal
    ON dfv.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
WHERE eal.nombreEstadoActividadLaboral = 'no se labora'
ORDER BY dfv.idDiaFestivoVariable;

-- =============================================
-- Prueba 1: anio actual
-- =============================================
SELECT '--- PRUEBA 1: anio actual ---' AS info;

SELECT fechaExacta
FROM dbo.fn_obtenerDiasFestivosVariablesActuales(YEAR(GETDATE()))
ORDER BY fechaExacta;

-- =============================================
-- Prueba 2: anio especifico (2024 - bisiesto)
-- =============================================
SELECT '--- PRUEBA 2: anio 2024 (bisiesto) ---' AS info;

SELECT fechaExacta
FROM dbo.fn_obtenerDiasFestivosVariablesActuales(2024)
ORDER BY fechaExacta;

-- =============================================
-- Prueba 3: anio especifico (2025)
-- =============================================
SELECT '--- PRUEBA 3: anio 2025 ---' AS info;

SELECT fechaExacta
FROM dbo.fn_obtenerDiasFestivosVariablesActuales(2025)
ORDER BY fechaExacta;

-- =============================================
-- Prueba 4: contar resultados por año
-- =============================================
SELECT '--- PRUEBA 4: conteo por varios anios ---' AS info;

SELECT 2024 AS anio, COUNT(*) AS cantidad_fechas
FROM dbo.fn_obtenerDiasFestivosVariablesActuales(2024)
UNION ALL
SELECT 2025, COUNT(*)
FROM dbo.fn_obtenerDiasFestivosVariablesActuales(2025)
UNION ALL
SELECT 2026, COUNT(*)
FROM dbo.fn_obtenerDiasFestivosVariablesActuales(2026)
ORDER BY anio;

-- =============================================
-- Prueba 5: verificar que solo trae activos
-- (comparamos total vs activos en la tabla)
-- =============================================
SELECT '--- PRUEBA 5: verificacion de filtro activos ---' AS info;

SELECT 'Festivos activos en tabla' AS descripcion, COUNT(*) AS cantidad
FROM dbo.diasFestivosVariables dfv
INNER JOIN dbo.estadosDeActividadLaboral eal
    ON dfv.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
WHERE eal.nombreEstadoActividadLaboral = 'no se labora'
UNION ALL
SELECT 'Festivos inactivos en tabla', COUNT(*)
FROM dbo.diasFestivosVariables dfv
INNER JOIN dbo.estadosDeActividadLaboral eal
    ON dfv.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
WHERE eal.nombreEstadoActividadLaboral <> 'no se labora'
UNION ALL
SELECT 'Registros cargados en fn_obtenerDiasFestivosVariablesActuales(2026)', COUNT(*)
FROM dbo.fn_obtenerDiasFestivosVariablesActuales(2026);
