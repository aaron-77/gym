-- ============================================================================
-- FitnessGym - Patch: Fix Image and Preview Mismatches
-- ============================================================================
-- Run this script to fix the incorrect display names and image paths
-- in the populated database.
-- ============================================================================

SET NOCOUNT ON;
GO

BEGIN TRAN;
GO

PRINT '==================================================';
PRINT 'Starting patch: Fixing image and preview mismatches';
PRINT '==================================================';
PRINT '';

-- 1. Correct Exercise 13 (High Knees) display name and path
PRINT '--- 1. Correcting Exercise 13 (High Knees) ---';
IF EXISTS (SELECT 1 FROM imagesForExercises WHERE fkEjercicio = 13)
BEGIN
    UPDATE imagesForExercises
    SET nombreParaElFront = N'High Knees',
        urlPrivada = N'/img/highknees.jpg',
        urlPublica = N'/img/highknees.jpg'
    WHERE fkEjercicio = 13;
    PRINT '  Exercise 13 (High Knees) updated successfully.';
END
ELSE
BEGIN
    INSERT INTO imagesForExercises (fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
    VALUES (13, N'High Knees', N'/img/highknees.jpg', N'/img/highknees.jpg');
    PRINT '  Exercise 13 (High Knees) inserted successfully.';
END
PRINT '';

-- 2. Correct Exercise 12 (Planchas Laterales) display name and path
PRINT '--- 2. Correcting Exercise 12 (Planchas Laterales) ---';
IF EXISTS (SELECT 1 FROM imagesForExercises WHERE fkEjercicio = 12)
BEGIN
    UPDATE imagesForExercises
    SET nombreParaElFront = N'Planchas Laterales',
        urlPrivada = N'/img/sentadillalateral.webp',
        urlPublica = N'/img/sentadillalateral.webp'
    WHERE fkEjercicio = 12;
    PRINT '  Exercise 12 (Planchas Laterales) updated successfully.';
END
ELSE
BEGIN
    INSERT INTO imagesForExercises (fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
    VALUES (12, N'Planchas Laterales', N'/img/sentadillalateral.webp', N'/img/sentadillalateral.webp');
    PRINT '  Exercise 12 (Planchas Laterales) inserted successfully.';
END
PRINT '';

-- 3. Register missing preview images for Yoga Avanzado (Class 12)
PRINT '--- 3. Registering Class 12 (Yoga Avanzado) preview images ---';
IF EXISTS (SELECT 1 FROM imagesForClases WHERE fkClase = 12)
BEGIN
    UPDATE imagesForClases
    SET urlParaBanner = N'/img/esterilla.jpg',
        urlParaParaDescripcionDeClase = N'/img/esterilla.jpg',
        urlParaBloqueConsejos = N'/img/lesiongym.jpg',
        FechaDeModificacion = GETDATE()
    WHERE fkClase = 12;
    PRINT '  Class 12 (Yoga Avanzado) preview images updated successfully.';
END
ELSE
BEGIN
    INSERT INTO imagesForClases (fkClase, urlParaBanner, urlParaParaDescripcionDeClase, urlParaBloqueConsejos, FechaDeCreacion, FechaDeModificacion)
    VALUES (12, N'/img/esterilla.jpg', N'/img/esterilla.jpg', N'/img/lesiongym.jpg', GETDATE(), GETDATE());
    PRINT '  Class 12 (Yoga Avanzado) preview images inserted successfully.';
END
PRINT '';

-- 4. Clean up any leftover relative paths (../img/ -> /img/)
PRINT '--- 4. Cleaning up leftover relative paths ---';
UPDATE iconsForParameters
SET urlPrivada = REPLACE(urlPrivada, '../img/', '/img/'),
    urlPublica = REPLACE(urlPublica, '../img/', '/img/')
WHERE urlPrivada LIKE '../img/%' OR urlPublica LIKE '../img/%';

UPDATE imagesForClases
SET urlParaBanner = REPLACE(urlParaBanner, '../img/', '/img/'),
    urlParaParaDescripcionDeClase = REPLACE(urlParaParaDescripcionDeClase, '../img/', '/img/'),
    urlParaBloqueConsejos = REPLACE(urlParaBloqueConsejos, '../img/', '/img/')
WHERE urlParaBanner LIKE '../img/%'
   OR urlParaParaDescripcionDeClase LIKE '../img/%'
   OR urlParaBloqueConsejos LIKE '../img/%';

UPDATE imagesForExercises
SET urlPrivada = REPLACE(urlPrivada, '../img/', '/img/'),
    urlPublica = REPLACE(urlPublica, '../img/', '/img/')
WHERE urlPrivada LIKE '../img/%' OR urlPublica LIKE '../img/%';
PRINT '  Relative paths cleaned up successfully.';
PRINT '';

PRINT '==================================================';
PRINT 'Patch applied successfully!';
PRINT '==================================================';

COMMIT TRAN;
GO
