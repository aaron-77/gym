-- ============================================================================
-- FitnessGym - Fix Image URLs Script
-- ============================================================================
-- Replaces '../img/' prefix with '/img/' ONLY in urlPublica columns.
-- urlPrivada columns keep '../img/' prefix (server-side relative paths).
-- Safe to re-run: only affects rows that still have '../img/' in urlPublica.
-- ============================================================================

SET NOCOUNT ON;
GO

BEGIN TRAN;
GO

PRINT '========================================';
PRINT 'Fixing image URLs: urlPublica ../img/ -> /img/';
PRINT '========================================';
PRINT '';

-- ============================================================================
-- 1. Fix iconsForParameters (only urlPublica)
-- ============================================================================
PRINT '--- 1. Fixing iconsForParameters urlPublica ---';

UPDATE iconsForParameters
SET urlPublica = REPLACE(urlPublica, '../img/', '/img/')
WHERE urlPublica LIKE '../img/%';

PRINT '  Rows updated: ' + CAST(@@ROWCOUNT AS varchar(10));
PRINT '';

-- ============================================================================
-- 2. Fix imagesForClases (all columns are public URLs)
-- ============================================================================
PRINT '--- 2. Fixing imagesForClases URLs ---';

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
-- 3. Fix imagesForExercises (only urlPublica)
-- ============================================================================
PRINT '--- 3. Fixing imagesForExercises urlPublica ---';

UPDATE imagesForExercises
SET urlPublica = REPLACE(urlPublica, '../img/', '/img/')
WHERE urlPublica LIKE '../img/%';

PRINT '  Rows updated: ' + CAST(@@ROWCOUNT AS varchar(10));
PRINT '';

-- ============================================================================
-- 4. Verify results
-- ============================================================================
PRINT '--- Verification ---';

DECLARE @RemainingBadUrls int = 0;

SELECT @RemainingBadUrls = COUNT(*) FROM iconsForParameters
WHERE urlPublica LIKE '../img/%';

SELECT @RemainingBadUrls = @RemainingBadUrls + COUNT(*) FROM imagesForClases
WHERE urlParaBanner LIKE '../img/%'
   OR urlParaParaDescripcionDeClase LIKE '../img/%'
   OR urlParaBloqueConsejos LIKE '../img/%';

SELECT @RemainingBadUrls = @RemainingBadUrls + COUNT(*) FROM imagesForExercises
WHERE urlPublica LIKE '../img/%';

IF @RemainingBadUrls = 0
    PRINT '  SUCCESS: All public image URLs now start with /img/';
ELSE
    PRINT '  WARNING: ' + CAST(@RemainingBadUrls AS varchar(10)) + ' public URLs still have ../img/ prefix';

PRINT '';
PRINT '========================================';
PRINT 'Done';
PRINT '========================================';

COMMIT TRAN;
GO
