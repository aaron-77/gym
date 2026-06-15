/*
    Insert: Vincular ejercicios de yoga (22-29) con Esterilla (3) y Botella de Agua (4)
    Tabla: EjercicioEquipos
    Formato: Single INSERT con múltiples VALUES (row-value constructor), sin GO
*/

USE [FitnessCenterDB];

BEGIN TRAN;

PRINT '============================================================';
PRINT 'Vinculando ejercicios 22-29 con Esterilla y Botella de Agua';
PRINT '============================================================';

INSERT INTO [dbo].[EjercicioEquipos] ([EjercicioID], [EquipoID])
VALUES
    -- Adho Mukha Svanasana (22) con Esterilla y Botella de Agua
    (22, 3), (22, 4),
    -- Virabhadrasana I (23) con Esterilla y Botella de Agua
    (23, 3), (23, 4),
    -- Virabhadrasana II (24) con Esterilla y Botella de Agua
    (24, 3), (24, 4),
    -- Vrksasana (25) con Esterilla y Botella de Agua
    (25, 3), (25, 4),
    -- Trikonasana (26) con Esterilla y Botella de Agua
    (26, 3), (26, 4),
    -- Bhujangasana (27) con Esterilla y Botella de Agua
    (27, 3), (27, 4),
    -- Balasana (28) con Esterilla y Botella de Agua
    (28, 3), (28, 4),
    -- Savasana (29) con Esterilla y Botella de Agua
    (29, 3), (29, 4);

PRINT '  16 registros insertados en EjercicioEquipos (8 ejercicios x 2 equipos)';
PRINT '========================================';
PRINT 'Script completed successfully!';
PRINT '========================================';

COMMIT TRAN;
