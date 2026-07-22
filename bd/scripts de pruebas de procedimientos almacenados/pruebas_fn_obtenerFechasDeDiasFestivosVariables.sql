-- =============================================
-- Pruebas: dbo.fn_obtenerFechasDeDiasFestivosVariables
--
-- Requiere: dbo.DatosDiaFestivoVariable (table type)
--           dbo.fn_obtenerNombreTipoDeRecurrencia
--           dbo.tiposDeRecurrenciaDeDiasFestivos con datos:
--             id 2 -> 'mensual'
--             id 5 -> 'diaRelativo'
--             id 6 -> 'diaConsecutivo'
--
-- Resultados esperados calculados para anio 2024 (bisiesto).
-- Ajustar @@DATEFIRST si es distinto a 7 (domingo = 1).
-- =============================================

-- Caso 1: dia + semana + mes
-- "segundo lunes de enero" -> dia=2(lunes), semana=2, mes=1
-- Esperado: 2024-01-08
DECLARE @datos1 DatosDiaFestivoVariable;
INSERT INTO @datos1 VALUES (2, 2, 1, NULL);
SELECT 'Caso 1: segundo lunes de enero' AS prueba, *
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2024, @datos1);
-- Resultado esperado: 1 fila | fecha=2024-01-08

-- Caso 2: dia + semana, tipo diaSemana
-- "dia 2 de la semana 15 del anio"
-- NOTA: requiere un tipoDeRecurrencia con nombre 'diaSemana'
-- Si no existe en tu BD, este caso devuelve 0 filas
DECLARE @datos2 DatosDiaFestivoVariable;
INSERT INTO @datos2 VALUES (2, 15, NULL, 99); -- 99 = id que mapee a 'diaSemana'
SELECT 'Caso 2: dia 2 semana 15 (ajustar id si no existe)' AS prueba, *
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2024, @datos2);
-- Resultado esperado si existe: 1 fila | fecha=2024-04-08

-- Caso 3: dia + semana, tipo mensual
-- "primer martes de cada mes" -> dia=3(martes), semana=1, tipo mensual(id=2)
-- Esperado: 12 fechas (una por cada mes)
DECLARE @datos3 DatosDiaFestivoVariable;
INSERT INTO @datos3 VALUES (3, 1, NULL, 2);
SELECT 'Caso 3: primer martes de cada mes' AS prueba, *
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2024, @datos3)
ORDER BY fechaExacta;
-- Resultado esperado: 12 filas
-- 2024-01-02, 2024-02-06, 2024-03-05, 2024-04-02,
-- 2024-05-07, 2024-06-04, 2024-07-02, 2024-08-06,
-- 2024-09-03, 2024-10-01, 2024-11-05, 2024-12-03

-- Caso 4: solo dia, tipo mensual
-- "dia 15 de cada mes" -> dia=15, tipo mensual(id=2)
-- Esperado: 12 fechas (todos los meses tienen dia 15)
DECLARE @datos4 DatosDiaFestivoVariable;
INSERT INTO @datos4 VALUES (15, NULL, NULL, 2);
SELECT 'Caso 4: dia 15 de cada mes' AS prueba, *
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2024, @datos4)
ORDER BY fechaExacta;
-- Resultado esperado: 12 filas
-- 2024-01-15, 2024-02-15, 2024-03-15, ..., 2024-12-15

-- Caso 4b: dia 31 tipo mensual (borde: meses sin 31)
-- Esperado: 11 fechas (febrero no tiene 31)
DECLARE @datos4b DatosDiaFestivoVariable;
INSERT INTO @datos4b VALUES (31, NULL, NULL, 2);
SELECT 'Caso 4b: dia 31 de cada mes (borde)' AS prueba, COUNT(*) AS cantidad
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2024, @datos4b);
-- Resultado esperado: 11

-- Caso 5: solo dia, tipo diaRelativo
-- "todos los martes" -> dia=3(martes), tipo diaRelativo(id=5)
-- Esperado: ~52 fechas
DECLARE @datos5 DatosDiaFestivoVariable;
INSERT INTO @datos5 VALUES (3, NULL, NULL, 5);
SELECT 'Caso 5: todos los martes' AS prueba, COUNT(*) AS cantidad
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2024, @datos5);
-- Resultado esperado: 52 (2024 empieza lunes, tiene 52 martes)

-- Caso 5b: "todos los sabados" -> dia=7(sabado), tipo diaRelativo(id=5)
-- Ver muestra de 3 fechas
DECLARE @datos5b DatosDiaFestivoVariable;
INSERT INTO @datos5b VALUES (7, NULL, NULL, 5);
SELECT TOP 3 'Caso 5b: muestra sabados' AS prueba, *
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2024, @datos5b)
ORDER BY fechaExacta;
-- Resultado esperado: 2024-01-06, 2024-01-13, 2024-01-20

-- Caso 6: solo dia, tipo diaConsecutivo
-- "dia 100 del anio" -> dia=100, tipo diaConsecutivo(id=6)
-- 2024 es bisiesto -> dia 100 = 2024-04-09
DECLARE @datos6 DatosDiaFestivoVariable;
INSERT INTO @datos6 VALUES (100, NULL, NULL, 6);
SELECT 'Caso 6: dia 100 de 2024 (bisiesto)' AS prueba, *
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2024, @datos6);
-- Resultado esperado: 1 fila | fecha=2024-04-09

-- Caso 6b: dia 366 en bisiesto vs no bisiesto
DECLARE @datos6b DatosDiaFestivoVariable;
INSERT INTO @datos6b VALUES (366, NULL, NULL, 6);
SELECT 'Caso 6b: dia 366 de 2024 (bisiesto, existe)' AS prueba, *
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2024, @datos6b);
-- Resultado esperado: 1 fila | fecha=2024-12-31

SELECT 'Caso 6b: dia 366 de 2025 (no bisiesto, no existe)' AS prueba, *
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2025, @datos6b);
-- Resultado esperado: 0 filas

-- Caso 7: multiples definiciones juntas
DECLARE @datos7 DatosDiaFestivoVariable;
INSERT INTO @datos7 VALUES (2, 2, 1, NULL);    -- seg lunes enero
INSERT INTO @datos7 VALUES (3, 1, NULL, 2);    -- primer martes c/mes
INSERT INTO @datos7 VALUES (15, NULL, NULL, 2); -- dia 15 c/mes
INSERT INTO @datos7 VALUES (7, NULL, NULL, 5);  -- todos los sabados
INSERT INTO @datos7 VALUES (256, NULL, NULL, 6); -- dia del programador
SELECT 'Caso 7: todas juntas' AS prueba, fechaExacta
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2024, @datos7)
ORDER BY fechaExacta;
-- Resultado esperado: muchas filas con distintas definiciones mezcladas

-- Caso 8: tabla vacia -> 0 filas
DECLARE @datos8 DatosDiaFestivoVariable;
SELECT 'Caso 8: tabla vacia' AS prueba, COUNT(*) AS cantidad
FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(2024, @datos8);
-- Resultado esperado: 0
