-- ============================================================================
-- FitnessGym - Fix Exercise Image URLs Script
-- ============================================================================
-- Corrects imagesForExercises URLs:
--   urlPublica: replaces '../img/' with '/img/'
--   urlPrivada: keeps '../img/' prefix (server-side relative path)
-- Also fixes incorrect exercise name for fkEjercicio 13.
-- Safe to re-run: only affects rows that still have wrong urlPublica.
-- ============================================================================

SET NOCOUNT ON;
GO

BEGIN TRAN;
GO

PRINT '========================================';
PRINT 'Fixing exercise image URLs';
PRINT '========================================';
PRINT '';

-- ============================================================================
-- 1. Fix urlPublica: replace '../img/' with '/img/'
-- ============================================================================
PRINT '--- 1. Fixing urlPublica prefix ---';

UPDATE imagesForExercises
SET urlPublica = REPLACE(urlPublica, '../img/', '/img/')
WHERE urlPublica LIKE '../img/%';

PRINT '  Rows updated: ' + CAST(@@ROWCOUNT AS varchar(10));
PRINT '';

-- ============================================================================
-- 2. Fix incorrect exercise name for fkEjercicio 13
-- ============================================================================
PRINT '--- 2. Fixing exercise name for fkEjercicio 13 ---';

UPDATE imagesForExercises
SET nombreParaElFront = N'High Knees'
WHERE fkEjercicio = 13 AND nombreParaElFront != N'High Knees';

PRINT '  Rows updated: ' + CAST(@@ROWCOUNT AS varchar(10));
PRINT '';

-- ============================================================================
-- 3. Verify results
-- ============================================================================
PRINT '--- 3. Verification ---';

SELECT idImage, fkEjercicio, nombreParaElFront, urlPrivada, urlPublica
FROM imagesForExercises
ORDER BY idImage;

DECLARE @RemainingBadPublicUrls int = 0;
SELECT @RemainingBadPublicUrls = COUNT(*) FROM imagesForExercises
WHERE urlPublica LIKE '../img/%';

IF @RemainingBadPublicUrls = 0
    PRINT '  SUCCESS: All urlPublica now start with /img/';
ELSE
    PRINT '  WARNING: ' + CAST(@RemainingBadPublicUrls AS varchar(10)) + ' urlPublica still have ../img/ prefix';

PRINT '';
PRINT '========================================';
PRINT 'Done';
PRINT '========================================';

COMMIT TRAN;
GO
