/*
=============================================================
SCRIPT DE MIGRACIÓN - MODIFICACIÓN DE TABLAS
=============================================================
Objetivo:
1. Agregar columna fechaDeLaClase a tabla clasesProgramadas
2. Remover columnas fechaDeLaClase y fkEntrenador de tabla horariosDeClasesProgramadas

Nota: Este script maneja todas las dependencias: índices, llaves foráneas, etc.
=============================================================
*/

USE [FitnessCenterDB]
GO

-- Paso 1: Iniciar transacción
BEGIN TRANSACTION
BEGIN TRY

    -- Paso 2: Remover la llave foránea FK_HorariosDeClasesProgramadas_AspNetUsers_NewFkEntrenador
    -- que hace referencia a fkEntrenador en horariosDeClasesProgramadas
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS 
               WHERE CONSTRAINT_NAME = 'FK_HorariosDeClasesProgramadas_AspNetUsers_NewFkEntrenador')
    BEGIN
        ALTER TABLE [dbo].[horariosDeClasesProgramadas] 
        DROP CONSTRAINT [FK_HorariosDeClasesProgramadas_AspNetUsers_NewFkEntrenador]
        PRINT 'Llave foránea FK_HorariosDeClasesProgramadas_AspNetUsers_NewFkEntrenador removida'
    END
    GO

    -- Paso 3: Remover columna fkEntrenador de horariosDeClasesProgramadas
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'horariosDeClasesProgramadas' AND COLUMN_NAME = 'fkEntrenador')
    BEGIN
        ALTER TABLE [dbo].[horariosDeClasesProgramadas] 
        DROP COLUMN [fkEntrenador]
        PRINT 'Columna fkEntrenador removida de horariosDeClasesProgramadas'
    END
    GO

    -- Paso 4: Remover columna fechaDeLaClase de horariosDeClasesProgramadas
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'horariosDeClasesProgramadas' AND COLUMN_NAME = 'fechaDeLaClase')
    BEGIN
        ALTER TABLE [dbo].[horariosDeClasesProgramadas] 
        DROP COLUMN [fechaDeLaClase]
        PRINT 'Columna fechaDeLaClase removida de horariosDeClasesProgramadas'
    END
    GO

    -- Paso 5: Agregar columna fechaDeLaClase a clasesProgramadas
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_NAME = 'clasesProgramadas' AND COLUMN_NAME = 'fechaDeLaClase')
    BEGIN
        ALTER TABLE [dbo].[clasesProgramadas] 
        ADD [fechaDeLaClase] [date] NULL
        PRINT 'Columna fechaDeLaClase agregada a clasesProgramadas'
    END
    GO

    -- Paso 6: Agregar valor por defecto a la nueva columna (opcional)
    -- Esto es útil para que futuras inserciones tengan un valor por defecto
    ALTER TABLE [dbo].[clasesProgramadas] 
    ADD CONSTRAINT [DF_clasesProgramadas_fechaDeLaClase] 
    DEFAULT (CAST(GETDATE() AS DATE)) FOR [fechaDeLaClase]
    PRINT 'Valor por defecto agregado a fechaDeLaClase'
    GO

    -- Paso 7: Confirmar transacción
    COMMIT TRANSACTION
    PRINT '====== MIGRACIÓN COMPLETADA EXITOSAMENTE ======'
    PRINT 'Cambios realizados:'
    PRINT '  ? Llave foránea FK_HorariosDeClasesProgramadas_AspNetUsers_NewFkEntrenador removida'
    PRINT '  ? Columna fkEntrenador removida de horariosDeClasesProgramadas'
    PRINT '  ? Columna fechaDeLaClase removida de horariosDeClasesProgramadas'
    PRINT '  ? Columna fechaDeLaClase agregada a clasesProgramadas'
    PRINT '  ? Valor por defecto configurado para fechaDeLaClase'

END TRY
BEGIN CATCH
    -- Si ocurre un error, revertir la transacción
    ROLLBACK TRANSACTION
    PRINT 'ERROR: La transacción ha sido revertida'
    PRINT 'Mensaje de error: ' + ERROR_MESSAGE()
    PRINT 'Número de error: ' + CAST(ERROR_NUMBER() AS VARCHAR(10))
END CATCH
GO

-- Paso 8: Verificar la estructura de las tablas después de la migración
PRINT ''
PRINT '====== VERIFICACIÓN DE ESTRUCTURA FINAL ======'
PRINT ''

PRINT 'Columnas de clasesProgramadas:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'clasesProgramadas'
ORDER BY ORDINAL_POSITION
GO

PRINT ''
PRINT 'Columnas de horariosDeClasesProgramadas:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'horariosDeClasesProgramadas'
ORDER BY ORDINAL_POSITION
GO

PRINT ''
PRINT 'Llaves foráneas de horariosDeClasesProgramadas:'
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu 
    ON rc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE kcu.TABLE_NAME = 'horariosDeClasesProgramadas'
GO
