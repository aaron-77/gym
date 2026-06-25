-- Script de pruebas para dbo.fn_esDiaFestivoVariableVersionJoin
-- Ajusta los IDs de tipo de recurrencia según tu base de datos

-- 1. Caso: "el segundo lunes de enero del año" (día, semana, mes, tipo de recurrencia)
DECLARE @fecha1 DATE = '2024-01-08'; -- Segundo lunes de enero 2024
SELECT 'Caso 1' AS Caso, dbo.fn_esDiaFestivoVariableVersionJoin(@fecha1, 2, 2, 1, 1) AS EsFestivo;

-- 2. Caso: "día 2 de la semana 15 del año" (día, semana, tipo de recurrencia = 'diaSemana')
DECLARE @fecha2 DATE = DATEADD(DAY, 1, DATEADD(WEEK, 14, DATEFROMPARTS(2024,1,1))); -- Lunes de la semana 15 de 2024
SELECT 'Caso 2' AS Caso, dbo.fn_esDiaFestivoVariableVersionJoin(@fecha2, 2, 15, NULL, 2) AS EsFestivo;

-- 3. Caso: "un día específico de una semana específica de cualquier mes" (día, semana, tipo = 'mensual')
DECLARE @fecha3 DATE = '2024-06-04'; -- Primer martes de junio 2024
SELECT 'Caso 3' AS Caso, dbo.fn_esDiaFestivoVariableVersionJoin(@fecha3, 3, 1, NULL, 3) AS EsFestivo;

-- 4. Caso: "la fecha festiva es mensual un día específico del mes" (día, mes)
DECLARE @fecha4 DATE = '2024-07-15';
SELECT 'Caso 4' AS Caso, dbo.fn_esDiaFestivoVariableVersionJoin(@fecha4, 15, NULL, 7, NULL) AS EsFestivo;

-- 5. Caso: "todos los martes" (solo día, tipo = 'diaRelativo')
DECLARE @fecha5 DATE = '2024-06-11'; -- Un martes cualquiera
SELECT 'Caso 5' AS Caso, dbo.fn_esDiaFestivoVariableVersionJoin(@fecha5, 3, NULL, NULL, 4) AS EsFestivo;

-- 6. Caso: "día 100 del año" (solo día, tipo = 'diaConsecutivo')
DECLARE @fecha6 DATE = DATEADD(DAY, 99, DATEFROMPARTS(2024,1,1)); -- Día 100 del año 2024
SELECT 'Caso 6' AS Caso, dbo.fn_esDiaFestivoVariableVersionJoin(@fecha6, 100, NULL, NULL, 5) AS EsFestivo;

-- Recuerda ajustar los IDs de tipo de recurrencia según tu tabla tiposDeRecurrenciaDeDiasFestivos 