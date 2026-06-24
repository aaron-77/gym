-- ============================================================================
-- FitnessGym - UPDATE: Migrate image URLs from jpg/jpeg/png to webp
-- ============================================================================
-- Date: 2026-06-23
-- Description: Replaces .jpg, .jpeg, .png extensions with .webp in all
--              database columns that store image URLs.
--
-- Safe to run multiple times: uses WHERE to only update rows that still
-- have old extensions. Already-converted .webp URLs are NOT affected.
-- ============================================================================

SET NOCOUNT ON;
BEGIN TRAN;
GO

PRINT '===============================================';
PRINT 'Starting migration: Image URLs jpg/jpeg/png → webp';
PRINT '===============================================';
PRINT '';

-- ============================================================================
-- 1. imagesForClases - 3 columns with class image URLs
-- ============================================================================
PRINT '--- 1. Updating imagesForClases ---';

-- urlParaBanner
UPDATE imagesForClases SET urlParaBanner = REPLACE(urlParaBanner, '.jpg', '.webp')
WHERE urlParaBanner LIKE '%.jpg';
PRINT '  urlParaBanner (.jpg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE imagesForClases SET urlParaBanner = REPLACE(urlParaBanner, '.jpeg', '.webp')
WHERE urlParaBanner LIKE '%.jpeg';
PRINT '  urlParaBanner (.jpeg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE imagesForClases SET urlParaBanner = REPLACE(urlParaBanner, '.png', '.webp')
WHERE urlParaBanner LIKE '%.png';
PRINT '  urlParaBanner (.png) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

-- urlParaParaDescripcionDeClase
UPDATE imagesForClases SET urlParaParaDescripcionDeClase = REPLACE(urlParaParaDescripcionDeClase, '.jpg', '.webp')
WHERE urlParaParaDescripcionDeClase LIKE '%.jpg';
PRINT '  urlParaParaDescripcionDeClase (.jpg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE imagesForClases SET urlParaParaDescripcionDeClase = REPLACE(urlParaParaDescripcionDeClase, '.jpeg', '.webp')
WHERE urlParaParaDescripcionDeClase LIKE '%.jpeg';
PRINT '  urlParaParaDescripcionDeClase (.jpeg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE imagesForClases SET urlParaParaDescripcionDeClase = REPLACE(urlParaParaDescripcionDeClase, '.png', '.webp')
WHERE urlParaParaDescripcionDeClase LIKE '%.png';
PRINT '  urlParaParaDescripcionDeClase (.png) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

-- urlParaBloqueConsejos
UPDATE imagesForClases SET urlParaBloqueConsejos = REPLACE(urlParaBloqueConsejos, '.jpg', '.webp')
WHERE urlParaBloqueConsejos LIKE '%.jpg';
PRINT '  urlParaBloqueConsejos (.jpg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE imagesForClases SET urlParaBloqueConsejos = REPLACE(urlParaBloqueConsejos, '.jpeg', '.webp')
WHERE urlParaBloqueConsejos LIKE '%.jpeg';
PRINT '  urlParaBloqueConsejos (.jpeg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE imagesForClases SET urlParaBloqueConsejos = REPLACE(urlParaBloqueConsejos, '.png', '.webp')
WHERE urlParaBloqueConsejos LIKE '%.png';
PRINT '  urlParaBloqueConsejos (.png) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

PRINT '';

-- ============================================================================
-- 2. imagesForExercises - 2 columns with exercise image URLs
-- ============================================================================
PRINT '--- 2. Updating imagesForExercises ---';

-- urlPrivada
UPDATE imagesForExercises SET urlPrivada = REPLACE(urlPrivada, '.jpg', '.webp')
WHERE urlPrivada LIKE '%.jpg';
PRINT '  urlPrivada (.jpg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE imagesForExercises SET urlPrivada = REPLACE(urlPrivada, '.jpeg', '.webp')
WHERE urlPrivada LIKE '%.jpeg';
PRINT '  urlPrivada (.jpeg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE imagesForExercises SET urlPrivada = REPLACE(urlPrivada, '.png', '.webp')
WHERE urlPrivada LIKE '%.png';
PRINT '  urlPrivada (.png) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

-- urlPublica
UPDATE imagesForExercises SET urlPublica = REPLACE(urlPublica, '.jpg', '.webp')
WHERE urlPublica LIKE '%.jpg';
PRINT '  urlPublica (.jpg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE imagesForExercises SET urlPublica = REPLACE(urlPublica, '.jpeg', '.webp')
WHERE urlPublica LIKE '%.jpeg';
PRINT '  urlPublica (.jpeg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE imagesForExercises SET urlPublica = REPLACE(urlPublica, '.png', '.webp')
WHERE urlPublica LIKE '%.png';
PRINT '  urlPublica (.png) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

PRINT '';

-- ============================================================================
-- 3. iconsForParameters - safety net (should be SVGs, but just in case)
-- ============================================================================
PRINT '--- 3. Updating iconsForParameters (safety net) ---';

-- urlPrivada
UPDATE iconsForParameters SET urlPrivada = REPLACE(urlPrivada, '.jpg', '.webp')
WHERE urlPrivada LIKE '%.jpg';
PRINT '  urlPrivada (.jpg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE iconsForParameters SET urlPrivada = REPLACE(urlPrivada, '.jpeg', '.webp')
WHERE urlPrivada LIKE '%.jpeg';
PRINT '  urlPrivada (.jpeg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE iconsForParameters SET urlPrivada = REPLACE(urlPrivada, '.png', '.webp')
WHERE urlPrivada LIKE '%.png';
PRINT '  urlPrivada (.png) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

-- urlPublica
UPDATE iconsForParameters SET urlPublica = REPLACE(urlPublica, '.jpg', '.webp')
WHERE urlPublica LIKE '%.jpg';
PRINT '  urlPublica (.jpg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE iconsForParameters SET urlPublica = REPLACE(urlPublica, '.jpeg', '.webp')
WHERE urlPublica LIKE '%.jpeg';
PRINT '  urlPublica (.jpeg) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

UPDATE iconsForParameters SET urlPublica = REPLACE(urlPublica, '.png', '.webp')
WHERE urlPublica LIKE '%.png';
PRINT '  urlPublica (.png) updated: ' + CAST(@@ROWCOUNT AS nvarchar(10)) + ' rows';

PRINT '';

-- ============================================================================
-- Verification queries (commented out - uncomment to inspect results)
-- ============================================================================
PRINT '===============================================';
PRINT 'Migration complete!';
PRINT '===============================================';
PRINT '';

-- Uncomment to verify:
-- SELECT 'imagesForClases' AS tabla, idClassImage, fkClase, urlParaBanner, urlParaParaDescripcionDeClase, urlParaBloqueConsejos FROM imagesForClases ORDER BY fkClase;
-- SELECT 'imagesForExercises' AS tabla, idImage, fkEjercicio, urlPrivada, urlPublica FROM imagesForExercises ORDER BY fkEjercicio;
-- SELECT 'iconsForParameters' AS tabla, iconId, nombre, urlPrivada, urlPublica FROM iconsForParameters ORDER BY iconId;

COMMIT TRAN;
GO
