-- ============================================================================
-- FitnessGym - Insert icons and benefits for Yoga class
-- Also fixes HIIT (Clase 5) benefit icons that may be NULL after the seed
-- ============================================================================
-- This script:
-- 1. INSERT 3 missing icons into iconsForParameters (if not exist)
-- 2. INSERT 3 benefits for Yoga (ClaseID=12) linking to those icons
-- 3. UPDATE HIIT (ClaseID=5) benefits to point to same icons if currently NULL
-- Safe to re-run: uses IF NOT EXISTS / WHERE IS NULL patterns
-- ============================================================================

SET NOCOUNT ON;
GO

BEGIN TRAN;
GO

PRINT '============================================';
PRINT 'Yoga benefits + fix HIIT benefit icons';
PRINT '============================================';
PRINT '';

-- ============================================================================
-- 1. Ensure the 3 icons exist in iconsForParameters
-- ============================================================================
PRINT '--- 1. Inserting missing icons ---';

DECLARE @IconCorazonId int, @IconFlamaId int, @IconEficienciaId int;

INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'mejora-cardiovascular', N'../img/heart.svg', N'/img/heart.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'mejora-cardiovascular');

SET @IconCorazonId = ISNULL(
    (SELECT iconId FROM iconsForParameters WHERE nombre = N'mejora-cardiovascular'),
    SCOPE_IDENTITY()
);

INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'quema-de-grasa', N'../img/flame.svg', N'/img/flame.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'quema-de-grasa');

SET @IconFlamaId = ISNULL(
    (SELECT iconId FROM iconsForParameters WHERE nombre = N'quema-de-grasa'),
    SCOPE_IDENTITY()
);

INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'eficiencia', N'../img/svgacceso24black.svg', N'/img/svgacceso24black.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'eficiencia');

SET @IconEficienciaId = ISNULL(
    (SELECT iconId FROM iconsForParameters WHERE nombre = N'eficiencia'),
    SCOPE_IDENTITY()
);

PRINT '  mejora-cardiovascular → /img/heart.svg (iconId: ' + CAST(@IconCorazonId AS NVARCHAR) + ')';
PRINT '  quema-de-grasa → /img/flame.svg (iconId: ' + CAST(@IconFlamaId AS NVARCHAR) + ')';
PRINT '  eficiencia → /img/svgacceso24black.svg (iconId: ' + CAST(@IconEficienciaId AS NVARCHAR) + ')';
PRINT '';

-- ============================================================================
-- 2. INSERT beneficiosDeClase for Yoga (ClaseID=12)
-- ============================================================================
PRINT '--- 2. Inserting Yoga (Clase 12) benefits ---';

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 12, N'Mejora Cardiovascular', @IconCorazonId,
    N'Aumenta la capacidad aeróbica y anaeróbica mejorando tu resistencia general',
    GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 12 AND beneficio = N'Mejora Cardiovascular');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 12, N'Quema de Grasa', @IconFlamaId,
    N'Mayor quema calórica durante y después de la práctica, acelerando tu metabolismo',
    GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 12 AND beneficio = N'Quema de Grasa');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 12, N'Eficiencia', @IconEficienciaId,
    N'Resultados máximos en el menor tiempo, optimizando cada sesión de entrenamiento',
    GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 12 AND beneficio = N'Eficiencia');

PRINT '  Yoga benefits inserted (or already existed)';
PRINT '';

-- ============================================================================
-- 3. UPDATE HIIT (ClaseID=5) benefits that have NULL fkIcon
-- ============================================================================
PRINT '--- 3. Fixing HIIT (Clase 5) benefit icons ---';

UPDATE beneficiosDeClase SET fkIcon = @IconCorazonId
WHERE fkClase = 5 AND beneficio = N'Mejora Cardiovascular' AND fkIcon IS NULL;

UPDATE beneficiosDeClase SET fkIcon = @IconFlamaId
WHERE fkClase = 5 AND beneficio = N'Quema de Grasa' AND fkIcon IS NULL;

UPDATE beneficiosDeClase SET fkIcon = @IconEficienciaId
WHERE fkClase = 5 AND beneficio = N'Eficiencia' AND fkIcon IS NULL;

PRINT '  HIIT benefits fixed (if any were NULL)';
PRINT '';

-- ============================================================================
-- 4. Verify
-- ============================================================================
PRINT '--- 4. Verification ---';

SELECT 'iconsForParameters' AS tabla, COUNT(*) AS total FROM iconsForParameters
UNION ALL
SELECT 'beneficiosDeClase', COUNT(*) FROM beneficiosDeClase;

PRINT '';
PRINT '=== DONE ===';

COMMIT TRAN;
GO
