USE [FitnessCenterDB]
GO

/****** SCRIPT DE VALIDACIÓN POSTERIOR A LA MIGRACIÓN ******/
/****** Verifica que todos los cambios se aplicaron correctamente ******/

PRINT '========================================='
PRINT 'INICIANDO VALIDACIÓN DE MIGRACIÓN'
PRINT '========================================='
GO

-- 1. Verificar que preReservasDeHorario tiene las nuevas columnas
PRINT 'VALIDACIÓN 1: Columnas en preReservasDeHorario'
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'preReservasDeHorario' 
    AND COLUMN_NAME IN ('idClase', 'fechaDeLaClase', 'idEntrenador')
)
BEGIN
    PRINT '? Columnas nuevas detectadas en preReservasDeHorario'
END
ELSE
BEGIN
    PRINT '? ERROR: Faltan columnas en preReservasDeHorario'
END
GO

-- 2. Verificar que el índice unique existe
PRINT 'VALIDACIÓN 2: Índice Unique en preReservasDeHorario'
IF EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE name = 'UX_preReservasDeHorario_Unique' 
    AND object_id = OBJECT_ID('preReservasDeHorario')
)
BEGIN
    PRINT '? Índice unique detectado'
END
ELSE
BEGIN
    PRINT '? ERROR: Índice unique no existe'
END
GO

-- 3. Verificar que clasesProgramadas tiene fechaDeLaClase
PRINT 'VALIDACIÓN 3: Columna fechaDeLaClase en clasesProgramadas'
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'clasesProgramadas' 
    AND COLUMN_NAME = 'fechaDeLaClase'
)
BEGIN
    PRINT '? Columna fechaDeLaClase detectada en clasesProgramadas'
END
ELSE
BEGIN
    PRINT '? ERROR: Falta fechaDeLaClase en clasesProgramadas'
END
GO

-- 4. Verificar Foreign Keys
PRINT 'VALIDACIÓN 4: Foreign Keys en preReservasDeHorario'
IF EXISTS (
    SELECT 1 FROM sys.foreign_keys 
    WHERE name IN (
        'FK_preReservasDeHorario_Clases',
        'FK_preReservasDeHorario_AspNetUsers_Entrenador'
    )
)
BEGIN
    PRINT '? Foreign Keys detectadas'
END
ELSE
BEGIN
    PRINT '? ERROR: Faltan Foreign Keys'
END
GO

-- 5. Verificar que NO existen columnas antiguas en horariosDeClasesProgramadas
PRINT 'VALIDACIÓN 5: Verificar que fechaDeLaClase NO está en horariosDeClasesProgramadas'
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'horariosDeClasesProgramadas' 
    AND COLUMN_NAME = 'fechaDeLaClase'
)
BEGIN
    PRINT '? Columna fechaDeLaClase correctamente removida de horariosDeClasesProgramadas'
END
ELSE
BEGIN
    PRINT '? ERROR: fechaDeLaClase aún existe en horariosDeClasesProgramadas'
END
GO

-- 6. Test de la función yaExisteClaseProgramada
PRINT 'VALIDACIÓN 6: Probando función yaExisteClaseProgramada'
BEGIN TRY
    DECLARE @testResult INT
    DECLARE @testTable IdsHorasLaborales
    INSERT INTO @testTable VALUES (1)
    
    SET @testResult = dbo.yaExisteClaseProgramada(GETDATE(), @testTable)
    PRINT '? Función yaExisteClaseProgramada ejecutada correctamente'
END TRY
BEGIN CATCH
    PRINT '? ERROR en función yaExisteClaseProgramada: ' + ERROR_MESSAGE()
END
GO

-- 7. Contar registros para verificar integridad
PRINT 'VALIDACIÓN 7: Conteo de registros'
SELECT 
    'clasesProgramadas' AS Tabla,
    COUNT(*) AS TotalRegistros
FROM clasesProgramadas
UNION ALL
SELECT 
    'horariosDeClasesProgramadas' AS Tabla,
    COUNT(*) AS TotalRegistros
FROM horariosDeClasesProgramadas
UNION ALL
SELECT 
    'preReservasDeHorario' AS Tabla,
    COUNT(*) AS TotalRegistros
FROM preReservasDeHorario
GO

PRINT '========================================='
PRINT 'VALIDACIÓN COMPLETADA'
PRINT '========================================='
GO
