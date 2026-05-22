-- ============================================================================
-- FitnessGym - Fix Image URLs Script
-- ============================================================================
-- Replaces '../img/' prefix with '/img/' in all existing image URLs.
-- Safe to re-run: only affects rows that still have '../img/' prefix.
-- ============================================================================

SET NOCOUNT ON;
GO

BEGIN TRAN;
GO

PRINT '========================================';
PRINT 'Fixing image URLs: ../img/ -> /img/';
PRINT '========================================';
PRINT '';

-- ============================================================================
-- 1. Fix iconsForParameters
-- ============================================================================
PRINT '--- 1. Fixing iconsForParameters ---';

UPDATE iconsForParameters
SET urlPrivada = REPLACE(urlPrivada, '../img/', '/img/'),
    urlPublica = REPLACE(urlPublica, '../img/', '/img/')
WHERE urlPrivada LIKE '../img/%' OR urlPublica LIKE '../img/%';

PRINT '  Rows updated: ' + CAST(@@ROWCOUNT AS varchar(10));
PRINT '';

-- ============================================================================
-- 2. Fix imagesForClases
-- ============================================================================
PRINT '--- 2. Fixing imagesForClases ---';

UPDATE imagesForClases
SET urlParaBanner = REPLACE(urlParaBanner, '../img/', '/img/'),
    urlParaParaDescripcionDeClase = REPLACE(urlParaParaDescripcionDeClase, '../img/', '/img/'),
    urlParaBloqueConsejos = REPLACE(urlParaBloqueConsejos, '../img/', '/img/')
WHERE urlParaBanner LIKE '../img/%'
   OR urlParaParaDescripcionDeClase LIKE '../img/%'
   OR urlParaBloqueConsejos LIKE '../img/%';

PRINT '  Rows updated: ' + CAST(@@ROWCOUNT AS varchar(10));
PRINT '';

-- ============================================================================
-- 3. Fix imagesForExercises
-- ============================================================================
PRINT '--- 3. Fixing imagesForExercises ---';

UPDATE imagesForExercises
SET urlPrivada = REPLACE(urlPrivada, '../img/', '/img/'),
    urlPublica = REPLACE(urlPublica, '../img/', '/img/')
WHERE urlPrivada LIKE '../img/%' OR urlPublica LIKE '../img/%';

PRINT '  Rows updated: ' + CAST(@@ROWCOUNT AS varchar(10));
PRINT '';

-- ============================================================================
-- 4. Verify results
-- ============================================================================
PRINT '--- Verification ---';

DECLARE @RemainingBadUrls int = 0;

SELECT @RemainingBadUrls = COUNT(*) FROM iconsForParameters
WHERE urlPrivada LIKE '../img/%' OR urlPublica LIKE '../img/%';

SELECT @RemainingBadUrls = @RemainingBadUrls + COUNT(*) FROM imagesForClases
WHERE urlParaBanner LIKE '../img/%'
   OR urlParaParaDescripcionDeClase LIKE '../img/%'
   OR urlParaBloqueConsejos LIKE '../img/%';

SELECT @RemainingBadUrls = @RemainingBadUrls + COUNT(*) FROM imagesForExercises
WHERE urlPrivada LIKE '../img/%' OR urlPublica LIKE '../img/%';

IF @RemainingBadUrls = 0
    PRINT '  SUCCESS: All image URLs now start with /img/';
ELSE
    PRINT '  WARNING: ' + CAST(@RemainingBadUrls AS varchar(10)) + ' URLs still have ../img/ prefix';

PRINT '';
PRINT '========================================';
PRINT 'Done';
PRINT '========================================';

COMMIT TRAN;
GO
