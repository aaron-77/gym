USE FitnessCenterDB;
GO

-- Script de prueba simple para el procedimiento almacenado sp_obtenerHorariosDisponibles
-- Este script asume que ya existe el procedimiento y hay datos suficientes para probarlo

SET NOCOUNT ON;
PRINT '=== PRUEBA SIMPLE DE sp_obtenerHorariosDisponibles ===';

-- Declaración de variables
DECLARE @fechaActual DATE = GETDATE();
DECLARE @primerDiaMes DATE = DATEFROMPARTS(YEAR(@fechaActual), MONTH(@fechaActual), 1);
DECLARE @primerDiaMesSiguiente DATE = DATEADD(MONTH, 1, @primerDiaMes);

-- 1. Obtener horarios disponibles para la fecha actual
PRINT '1. Horarios disponibles para hoy (' + CONVERT(VARCHAR, @fechaActual, 103) + '):';
EXEC dbo.sp_obtenerHorariosDisponibles @Fecha = @fechaActual;

-- 2. Obtener horarios disponibles para los próximos 7 días (filtrando en el cliente)
PRINT '2. Horarios disponibles para los próximos 7 días:';
-- Creamos una tabla temporal para almacenar los resultados
CREATE TABLE #HorariosProximaSemana (
    FechaDisponible DATETIME,
    idHora INT,
    horaInicio TIME,
    horaFin TIME,
    DiaDeLaSemana NVARCHAR(30),
    TipoDeDia NVARCHAR(20)
);

-- Ejecutamos el procedimiento y guardamos los resultados
INSERT INTO #HorariosProximaSemana
EXEC dbo.sp_obtenerHorariosDisponibles @Fecha = @fechaActual;

-- Filtramos los resultados para los próximos 7 días
SELECT 
    FechaDisponible,
    DATENAME(dw, FechaDisponible) AS DiaSemana,
    horaInicio,
    horaFin,
    TipoDeDia
FROM #HorariosProximaSemana
WHERE FechaDisponible BETWEEN @fechaActual AND DATEADD(DAY, 7, @fechaActual)
ORDER BY FechaDisponible, horaInicio;

-- 3. Contar horarios disponibles por día durante el mes actual
PRINT '3. Conteo de horarios disponibles por día para el mes actual:';
-- Usamos la tabla temporal para almacenar los resultados del mes
CREATE TABLE #HorariosMesActual (
    FechaDisponible DATETIME,
    idHora INT,
    horaInicio TIME,
    horaFin TIME,
    DiaDeLaSemana NVARCHAR(30),
    TipoDeDia NVARCHAR(20)
);

-- Limpiamos la tabla y ejecutamos el procedimiento de nuevo
TRUNCATE TABLE #HorariosProximaSemana;
INSERT INTO #HorariosMesActual
EXEC dbo.sp_obtenerHorariosDisponibles @Fecha = @fechaActual;

-- Contamos los horarios por día
SELECT 
    CAST(FechaDisponible AS DATE) AS Fecha,
    DiaDeLaSemana,
    COUNT(*) AS CantidadHorariosDisponibles,
    TipoDeDia
FROM #HorariosMesActual
GROUP BY CAST(FechaDisponible AS DATE), DiaDeLaSemana, TipoDeDia
ORDER BY Fecha;

-- 4. Obtener horarios disponibles por rango horario específico (8:00 AM - 12:00 PM)
PRINT '4. Horarios disponibles en la mañana (8:00 AM - 12:00 PM) para los próximos 7 días:';
SELECT 
    FechaDisponible,
    DiaDeLaSemana,
    horaInicio,
    horaFin
FROM #HorariosMesActual
WHERE 
    FechaDisponible BETWEEN @fechaActual AND DATEADD(DAY, 7, @fechaActual)
    AND horaInicio >= '08:00:00' AND horaInicio < '12:00:00'
ORDER BY FechaDisponible, horaInicio;

-- 5. Obtener horarios disponibles para el primer día del mes siguiente
PRINT '5. Horarios disponibles para el primer día del mes siguiente (' + CONVERT(VARCHAR, @primerDiaMesSiguiente, 103) + '):';
-- Creamos otra tabla temporal para el mes siguiente
CREATE TABLE #HorariosMesSiguiente (
    FechaDisponible DATETIME,
    idHora INT,
    horaInicio TIME,
    horaFin TIME,
    DiaDeLaSemana NVARCHAR(30),
    TipoDeDia NVARCHAR(20)
);

-- Ejecutamos el procedimiento para el mes siguiente
INSERT INTO #HorariosMesSiguiente
EXEC dbo.sp_obtenerHorariosDisponibles @Fecha = @primerDiaMesSiguiente;

-- Filtramos para el primer día del mes siguiente
SELECT 
    FechaDisponible,
    DiaDeLaSemana,
    horaInicio,
    horaFin,
    TipoDeDia
FROM #HorariosMesSiguiente
WHERE CAST(FechaDisponible AS DATE) = @primerDiaMesSiguiente
ORDER BY horaInicio;

-- Limpiamos las tablas temporales
DROP TABLE #HorariosProximaSemana;
DROP TABLE #HorariosMesActual;
DROP TABLE #HorariosMesSiguiente;

PRINT '=== FIN DE PRUEBA SIMPLE ==='; 