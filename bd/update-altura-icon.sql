-- ============================================================================
-- Update altura icon URL to new cleaner SVG
-- ============================================================================

-- Si YA existe, actualizalo:
UPDATE iconsForParameters SET
    urlPrivada = N'../img/altura.svg',
    urlPublica = N'/img/altura.svg'
WHERE nombre = N'altura';

-- Si no existe, INSERTALO:
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'altura', N'../img/altura.svg', N'/img/altura.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'altura');
