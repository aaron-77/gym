-- ============================================================================
-- FitnessGym - Fix iconsForParameters Public URLs
-- ============================================================================
-- Replaces '~/img/' prefix with '/img/' in urlPublica.
-- The '~' prefix is a Razor placeholder that doesn't resolve as a direct URL.
-- Safe to re-run: only affects rows that still have '~/img/' prefix.
-- ============================================================================

SET NOCOUNT ON;
GO

BEGIN TRAN;
GO

PRINT '============================================';
PRINT 'Fixing iconsForParameters urlPublica prefix';
PRINT '============================================';
PRINT '';

-- ============================================================================
-- 1. Fix urlPublica: replace '~/img/' with '/img/'
-- ============================================================================
PRINT '--- Updating urlPublica ---';

UPDATE iconsForParameters
SET urlPublica = REPLACE(urlPublica, '~/img/', '/img/')
WHERE urlPublica LIKE '~/img/%';

PRINT '  Rows updated: ' + CAST(@@ROWCOUNT AS varchar(10));
PRINT '';

-- ============================================================================
-- 2. Verify results
-- ============================================================================
PRINT '--- Verification ---';

DECLARE @RemainingBadUrls int = 0;
SELECT @RemainingBadUrls = COUNT(*) FROM iconsForParameters
WHERE urlPublica LIKE '~/img/%';

IF @RemainingBadUrls = 0
    PRINT '  SUCCESS: All urlPublica now start with /img/';
ELSE
    PRINT '  WARNING: ' + CAST(@RemainingBadUrls AS varchar(10)) + ' urlPublica still have ~/img/ prefix';

PRINT '';
PRINT '============================================';
PRINT 'Done';
PRINT '============================================';

COMMIT TRAN;
GO
