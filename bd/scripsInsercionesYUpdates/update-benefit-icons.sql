-- ============================================================================
-- FitnessGym - Update 6 benefit icons with dedicated SVGs
-- ============================================================================

SET NOCOUNT ON;
GO

BEGIN TRAN;
GO

UPDATE iconsForParameters SET urlPrivada = N'../img/densidad-osea.svg',             urlPublica = N'/img/densidad-osea.svg'             WHERE nombre = N'densidad-osea';
UPDATE iconsForParameters SET urlPrivada = N'../img/coordinacion.svg',              urlPublica = N'/img/coordinacion.svg'              WHERE nombre = N'coordinacion';
UPDATE iconsForParameters SET urlPrivada = N'../img/autodefensa.svg',               urlPublica = N'/img/autodefensa.svg'               WHERE nombre = N'autodefensa';
UPDATE iconsForParameters SET urlPrivada = N'../img/vida-diaria.svg',               urlPublica = N'/img/vida-diaria.svg'               WHERE nombre = N'vida-diaria';
UPDATE iconsForParameters SET urlPrivada = N'../img/progresion-personalizada.svg',  urlPublica = N'/img/progresion-personalizada.svg'  WHERE nombre = N'progresion';
UPDATE iconsForParameters SET urlPrivada = N'../img/movilidad.svg',                 urlPublica = N'/img/movilidad.svg'                 WHERE nombre = N'movilidad';

PRINT CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' rows updated';
PRINT '=== DONE ===';

COMMIT TRAN;
GO
