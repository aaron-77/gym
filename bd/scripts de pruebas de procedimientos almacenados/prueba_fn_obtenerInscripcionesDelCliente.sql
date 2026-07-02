-- =============================================
-- Script de prueba para dbo.fn_obtenerInscripcionesDelCliente
-- Descripción: Pruebas de happy path y edge cases para la función
--              que consulta inscripciones de un cliente
-- =============================================

-- =============================================
-- CONFIGURACIÓN INICIAL
-- =============================================
-- NOTA: Antes de ejecutar, reemplaza los GUIDs de ejemplo con IDs reales
-- de tu base de datos. Puedes obtenerlos ejecutando:
-- SELECT Id FROM AspNetUsers;

PRINT '====================================================';
PRINT 'PRUEBAS fn_obtenerInscripcionesDelCliente';
PRINT 'Fecha actual: ' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '====================================================';
PRINT '';

-- =============================================
-- PRUEBA 1: Happy Path - Cliente con inscripciones futuras
-- =============================================
PRINT '--- PRUEBA 1: Happy Path - Cliente con inscripciones futuras ---';
DECLARE @idClienteHappyPath NVARCHAR(450) = 'REEMPLAZAR_CON_GUID_REAL';

SELECT 
    'Prueba 1: Happy Path' AS prueba,
    COUNT(*) AS totalInscripciones,
    MIN(fechaDeLaClase) AS primeraClase,
    MAX(fechaDeLaClase) AS ultimaClase
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteHappyPath);

-- Detalle de inscripciones
SELECT 
    idInscripcion,
    nombreClase,
    fechaDeLaClase,
    CONVERT(VARCHAR, horaInicio, 108) AS horaInicio,
    CONVERT(VARCHAR, horaFin, 108) AS horaFin,
    estadoInscripcion,
    nombreEntrenador
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteHappyPath)
ORDER BY fechaDeLaClase, horaInicio;

PRINT '';

-- =============================================
-- PRUEBA 2: Edge Case - Cliente sin inscripciones
-- =============================================
PRINT '--- PRUEBA 2: Edge Case - Cliente sin inscripciones ---';
DECLARE @idClienteSinInscripciones NVARCHAR(450) = 'GUID_INEXISTENTE_O_SIN_INSCRIPCIONES';

SELECT 
    'Prueba 2: Sin inscripciones' AS prueba,
    COUNT(*) AS totalInscripciones
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteSinInscripciones);

-- Verificar que retorna 0 filas
IF NOT EXISTS (
    SELECT 1 
    FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteSinInscripciones)
)
BEGIN
    PRINT '✓ PASS: La función retorna resultado vacío para cliente sin inscripciones';
END
ELSE
BEGIN
    PRINT '✗ FAIL: La función debería retornar resultado vacío para cliente sin inscripciones';
END

PRINT '';

-- =============================================
-- PRUEBA 3: Edge Case - Parámetro NULL
-- =============================================
PRINT '--- PRUEBA 3: Edge Case - Parámetro NULL ---';

SELECT 
    'Prueba 3: Parámetro NULL' AS prueba,
    COUNT(*) AS totalInscripciones
FROM dbo.fn_obtenerInscripcionesDelCliente(NULL);

IF NOT EXISTS (
    SELECT 1 
    FROM dbo.fn_obtenerInscripcionesDelCliente(NULL)
)
BEGIN
    PRINT '✓ PASS: La función retorna resultado vacío con parámetro NULL';
END
ELSE
BEGIN
    PRINT '✗ FAIL: La función debería retornar resultado vacío con parámetro NULL';
END

PRINT '';

-- =============================================
-- PRUEBA 4: Edge Case - Solo inscripciones pasadas
-- =============================================
PRINT '--- PRUEBA 4: Edge Case - Solo inscripciones pasadas ---';
-- Esta prueba requiere un cliente que SOLO tenga inscripciones a clases pasadas
DECLARE @idClienteSoloPasadas NVARCHAR(450) = 'REEMPLAZAR_CON_GUID_CLIENTE_SOLO_PASADAS';

SELECT 
    'Prueba 4: Solo inscripciones pasadas' AS prueba,
    COUNT(*) AS totalInscripciones
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteSoloPasadas);

IF NOT EXISTS (
    SELECT 1 
    FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteSoloPasadas)
)
BEGIN
    PRINT '✓ PASS: La función no retorna inscripciones pasadas';
END
ELSE
BEGIN
    PRINT '✗ FAIL: La función NO debería retornar inscripciones pasadas';
END

PRINT '';

-- =============================================
-- PRUEBA 5: Verificar filtro de hora del día actual
-- =============================================
PRINT '--- PRUEBA 5: Verificar filtro de hora del día actual ---';
PRINT 'NOTA: Esta prueba debe ejecutarse en horario de clases para ser efectiva';

DECLARE @idClienteHoy NVARCHAR(450) = 'REEMPLAZAR_CON_GUID_CLIENTE_CLASES_HOY';

-- Inscripciones de hoy que deberían aparecer (hora futura)
SELECT 
    'Prueba 5: Clases de hoy con hora futura' AS prueba,
    idInscripcion,
    nombreClase,
    CONVERT(VARCHAR, horaInicio, 108) AS horaInicio,
    CONVERT(VARCHAR, horaFin, 108) AS horaFin,
    CASE 
        WHEN CONVERT(TIME, GETDATE()) < horaInicio THEN '✓ VÁLIDA (hora futura)'
        ELSE '✗ INVÁLIDA (hora pasada)'
    END AS estadoValidacion
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteHoy)
WHERE fechaDeLaClase = CAST(GETDATE() AS DATE);

-- Verificar que no haya clases de hoy con hora pasada
IF NOT EXISTS (
    SELECT 1 
    FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteHoy)
    WHERE fechaDeLaClase = CAST(GETDATE() AS DATE)
      AND horaInicio <= CAST(GETDATE() AS TIME)
)
BEGIN
    PRINT '✓ PASS: No se retornan clases de hoy con hora pasada';
END
ELSE
BEGIN
    PRINT '✗ FAIL: La función está retornando clases de hoy con hora pasada';
END

PRINT '';

-- =============================================
-- PRUEBA 6: Verificar que retorna todos los campos requeridos
-- =============================================
PRINT '--- PRUEBA 6: Verificar estructura de retorno ---';
DECLARE @idClienteEstructura NVARCHAR(450) = 'REEMPLAZAR_CON_GUID_REAL';

SELECT 
    'Prueba 6: Estructura de retorno' AS prueba,
    idInscripcion,
    fechaDeInscripcion,
    estadoInscripcion,
    idClaseProgramada,
    nombreClase,
    fechaDeLaClase,
    horaInicio,
    horaFin,
    cupoMaximo,
    nombreEntrenador
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteEstructura);

PRINT '';

-- =============================================
-- PRUEBA 7: Verificar orden de resultados
-- =============================================
PRINT '--- PRUEBA 7: Verificar orden de resultados ---';

SELECT 
    'Prueba 7: Orden de resultados' AS prueba,
    idInscripcion,
    nombreClase,
    fechaDeLaClase,
    CONVERT(VARCHAR, horaInicio, 108) AS horaInicio
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteHappyPath)
ORDER BY fechaDeLaClase, horaInicio;

PRINT '';

-- =============================================
-- PRUEBA 8: Verificar LEFT JOIN con entrenador
-- =============================================
PRINT '--- PRUEBA 8: Verificar LEFT JOIN con entrenador ---';

SELECT 
    'Prueba 8: Entrenador' AS prueba,
    idInscripcion,
    nombreClase,
    nombreEntrenador,
    CASE 
        WHEN nombreEntrenador IS NULL THEN 'Sin entrenador asignado'
        ELSE 'Entrenador asignado'
    END AS estadoEntrenador
FROM dbo.fn_obtenerInscripcionesDelCliente(@idClienteHappyPath);

PRINT '';

-- =============================================
-- RESUMEN DE PRUEBAS
-- =============================================
PRINT '====================================================';
PRINT 'FIN DE PRUEBAS';
PRINT '====================================================';
PRINT '';
PRINT 'INSTRUCCIONES:';
PRINT '1. Reemplaza los GUIDs de ejemplo con IDs reales de tu BD';
PRINT '2. Ejecuta las pruebas en horario de clases para probar el filtro de hora';
PRINT '3. Verifica que los resultados sean consistentes con los datos de prueba';
PRINT '4. Las pruebas de edge cases deben retornar 0 filas';
PRINT '';
PRINT 'QUERY ÚTIL PARA OBTENER GUIDs:';
PRINT 'SELECT TOP 10 Id, NombreCompleto, Apellido FROM AspNetUsers;';
