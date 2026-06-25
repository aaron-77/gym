-- ============================================================================
-- FitnessGym - Patch: Fix Seed Errors (Missing Flama Icon)
-- ============================================================================
-- Run this script if you already executed the uncorrected seed script.
-- It registers the 'flama' icon (flame.svg) and updates the Boxeo class benefit
-- so it correctly references the new icon instead of leaving it NULL.
-- ============================================================================

SET NOCOUNT ON;
GO

BEGIN TRAN;
GO

PRINT '==================================================';
PRINT 'Starting patch: Registering flama icon & fixing Boxeo benefit';
PRINT '==================================================';
PRINT '';

-- 1. Insert/Update 'flama' icon in iconsForParameters
PRINT '--- 1. Registering flama icon ---';
IF NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'flama')
BEGIN
    INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
    VALUES (N'flama', N'/img/flame.svg', N'/img/flame.svg');
    PRINT '  Icon N''flama'' inserted successfully.';
END
ELSE
BEGIN
    UPDATE iconsForParameters
    SET urlPrivada = N'/img/flame.svg',
        urlPublica = N'/img/flame.svg'
    WHERE nombre = N'flama';
    PRINT '  Icon N''flama'' updated successfully.';
END
PRINT '';

-- 2. Update fkIcon for Boxeo's 'Resistencia' benefit
PRINT '--- 2. Linking benefit to flama icon ---';

DECLARE @FlamaIconId int = (SELECT iconId FROM iconsForParameters WHERE nombre = N'flama');

IF @FlamaIconId IS NOT NULL
BEGIN
    UPDATE beneficiosDeClase
    SET fkIcon = @FlamaIconId,
        fechaDeModificacion = GETDATE()
    WHERE beneficio = N'Resistencia' 
      AND fkClase = 8;
      
    PRINT '  Benefit ''Resistencia'' for Boxeo (Clase 8) updated with flama icon.';
END
ELSE
BEGIN
    PRINT '  ERROR: Could not resolve iconId for N''flama''.';
END
PRINT '';

PRINT '==================================================';
PRINT 'Patch applied successfully!';
PRINT '==================================================';

COMMIT TRAN;
GO
