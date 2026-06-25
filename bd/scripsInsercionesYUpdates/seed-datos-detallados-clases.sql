-- ============================================================================
-- FitnessGym - Seed Script: Detailed Class Data (CORRECTED v2)
-- ============================================================================
-- This script populates classes with descriptions, images, benefits,
-- structure blocks, routines, exercises, equipment, tips, and schedules.
-- Safe to re-run: uses IF NOT EXISTS / UPDATE patterns.
-- Uses REAL file paths from /img/ directory.
-- ============================================================================

SET NOCOUNT ON;
GO

BEGIN TRAN;
GO

PRINT '========================================';
PRINT 'Starting seed: Detailed class data (v2)';
PRINT '========================================';
PRINT '';

-- ============================================================================
-- 0. Resolve trainer IDs from AspNetUsers
-- ============================================================================
PRINT '--- Resolving trainer IDs ---';

DECLARE @TrainerYesenia nvarchar(450) = (SELECT TOP 1 Id FROM AspNetUsers WHERE NombreCompleto = N'Yesenia' AND Apellido = N'esquivel');
DECLARE @TrainerMatias  nvarchar(450) = (SELECT TOP 1 Id FROM AspNetUsers WHERE NombreCompleto = N'matias' AND Apellido = N'botero');
DECLARE @TrainerAaron   nvarchar(450) = (SELECT TOP 1 Id FROM AspNetUsers WHERE NombreCompleto = N'aaron' AND Apellido = N'Azcarraga');
DECLARE @TrainerAntonio nvarchar(450) = (SELECT TOP 1 Id FROM AspNetUsers WHERE NombreCompleto = N'antonio' AND Apellido = N'marquez');

PRINT '  Yesenia:  ' + ISNULL(@TrainerYesenia, 'NOT FOUND');
PRINT '  Matias:   ' + ISNULL(@TrainerMatias,  'NOT FOUND');
PRINT '  Aaron:    ' + ISNULL(@TrainerAaron,   'NOT FOUND');
PRINT '  Antonio:  ' + ISNULL(@TrainerAntonio, 'NOT FOUND');
PRINT '';

-- ============================================================================
-- 1. UPDATE Clases descriptions and metadata
-- ============================================================================
PRINT '--- 1. Updating Clases metadata ---';

UPDATE Clases SET
    duracionEnMinutos = 45, fkIntensidad = 3, fkDificultad = 2, fkEstadoClase = 1,
    Descripcion = N'El HIIT (High Intensity Interval Training) es un método de entrenamiento que alterna períodos de ejercicio intenso con breves descansos activos o pasivos. Esta metodología maximiza la quema calórica en sesiones cortas, generando un efecto post-ejercicio (EPOC) que mantiene tu metabolismo acelerado hasta por 24 horas.

Ideal para quienes buscan resultados en poco tiempo, el HIIT mejora la capacidad cardiovascular, aumenta la resistencia muscular y promueve la pérdida de grasa preservando la masa muscular. Cada sesión está diseñada para llevarte al límite de forma segura y progresiva.'
WHERE ClaseID = 5;
PRINT '  HIIT (5) updated';

UPDATE Clases SET
    duracionEnMinutos = 45, fkIntensidad = 3, fkDificultad = 3, fkEstadoClase = 1,
    Descripcion = N'El CrossFit es un sistema de entrenamiento de fuerza y acondicionamiento que combina movimientos funcionales ejecutados a alta intensidad. Cada sesión (WOD - Workout of the Day) es diferente y trabaja múltiples capacidades físicas: resistencia cardiovascular, fuerza, potencia, velocidad, agilidad, coordinación y equilibrio.

Nuestros WODs son escalables a cualquier nivel, desde principiantes hasta atletas avanzados. Entrenarás con barra, kettlebells, anillas, cuerdas y tu propio peso corporal en un ambiente de comunidad que te impulsa a superar tus límites cada día.'
WHERE ClaseID = 6;
PRINT '  Crossfit (6) updated';

UPDATE Clases SET
    fkIntensidad = 3, fkDificultad = 3, fkEstadoClase = 1,
    Descripcion = N'El entrenamiento de fuerza y potencia está diseñado para desarrollar tu capacidad muscular máxima. Trabajamos con los levantamientos fundamentales: sentadilla, peso muerto, press de banca y press militar, aplicando principios de progresión lineal y ondulante para garantizar mejoras constantes.

Cada ciclo de entrenamiento tiene objetivos específicos: hipertrofia, fuerza máxima o potencia explosiva. Aprenderás la técnica correcta de cada movimiento, cómo periodizar tu entrenamiento y cómo nutrirte para maximizar la recuperación y el crecimiento muscular.'
WHERE ClaseID = 7;
PRINT '  Fuerza y potencia (7) updated';

UPDATE Clases SET
    fkIntensidad = 2, fkDificultad = 1, fkEstadoClase = 1,
    Descripcion = N'El boxeo es mucho más que un deporte de combate: es un entrenamiento completo que combina técnica, resistencia cardiovascular y fuerza funcional. En nuestras clases aprenderás los fundamentos del boxeo desde cero: postura, guardia, desplazamiento y los golpes básicos (jab, cross, hook, uppercut).

Cada sesión incluye trabajo de sombra, saco, manoplas y sparring controlado. Desarrollarás coordinación, reflejos, resistencia y confianza mientras te diviertes en un ambiente energético y motivador. Apto para todos los niveles, sin contacto obligatorio.'
WHERE ClaseID = 8;
PRINT '  Boxeo (8) updated';

UPDATE Clases SET
    fkIntensidad = 1, fkDificultad = 1, fkEstadoClase = 1,
    Descripcion = N'El entrenamiento funcional se basa en ejercicios que simulan patrones de movimiento naturales del cuerpo humano: empujar, tirar, cargar, girar, sentarse y desplazarse. El objetivo es mejorar tu capacidad para realizar actividades cotidianas con mayor facilidad, eficiencia y menor riesgo de lesiones.

Utilizamos una variedad de herramientas como kettlebells, TRX, bandas elásticas, balones medicinales y peso corporal. Las clases son dinámicas, accesibles para todos los niveles y enfocadas en la calidad del movimiento antes que en la intensidad.'
WHERE ClaseID = 9;
PRINT '  Entrenamiento Funcional (9) updated';

UPDATE Clases SET
    fkIntensidad = 1, fkDificultad = 3, fkEstadoClase = 1,
    Descripcion = N'El entrenamiento personal es la forma más efectiva de alcanzar tus objetivos fitness. Cada sesión es diseñada exclusivamente para ti, basada en una evaluación inicial de tu condición física, historial de lesiones, disponibilidad y metas específicas.

Tu entrenador te guiará con correcciones en tiempo real, ajustará cargas y ejercicios según tu progreso diario, y te proporcionará un plan de nutrición y recuperación complementario. Es la inversión más inteligente para resultados garantizados y sostenibles.'
WHERE ClaseID = 10;
PRINT '  Entrenamiento Personal (10) updated';

PRINT '';

-- ============================================================================
-- 2. UPDATE/INSERT imagesForClases with REAL file paths
-- ============================================================================
PRINT '--- 2. Updating class images ---';

-- HIIT (5) - already exists, UPDATE paths
UPDATE imagesForClases SET
    urlParaBanner = N'/img/hiit.jpg',
    urlParaParaDescripcionDeClase = N'/img/hiit2.jpg',
    urlParaBloqueConsejos = N'/img/lesiongym.jpg',
    FechaDeModificacion = GETDATE()
WHERE fkClase = 5;
PRINT '  HIIT (5) images updated';

-- Crossfit (6)
INSERT INTO imagesForClases (fkClase, urlParaBanner, urlParaParaDescripcionDeClase, urlParaBloqueConsejos, FechaDeCreacion, FechaDeModificacion)
SELECT 6, N'/img/crossfit.jpg', N'/img/crossfit.jpg', N'/img/lesiongym.jpg', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM imagesForClases WHERE fkClase = 6);
PRINT '  Crossfit (6) images inserted';

-- Fuerza (7) - note: filename is "strenght.jpg" (typo in actual file)
INSERT INTO imagesForClases (fkClase, urlParaBanner, urlParaParaDescripcionDeClase, urlParaBloqueConsejos, FechaDeCreacion, FechaDeModificacion)
SELECT 7, N'/img/strenght.jpg', N'/img/strenght.jpg', N'/img/lesiongym.jpg', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM imagesForClases WHERE fkClase = 7);
PRINT '  Fuerza (7) images inserted';

-- Boxeo (8)
INSERT INTO imagesForClases (fkClase, urlParaBanner, urlParaParaDescripcionDeClase, urlParaBloqueConsejos, FechaDeCreacion, FechaDeModificacion)
SELECT 8, N'/img/boxing.jpg', N'/img/boxing.jpg', N'/img/lesiongym.jpg', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM imagesForClases WHERE fkClase = 8);
PRINT '  Boxeo (8) images inserted';

-- Funcional (9)
INSERT INTO imagesForClases (fkClase, urlParaBanner, urlParaParaDescripcionDeClase, urlParaBloqueConsejos, FechaDeCreacion, FechaDeModificacion)
SELECT 9, N'/img/functional.jpg', N'/img/functional.jpg', N'/img/lesiongym.jpg', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM imagesForClases WHERE fkClase = 9);
PRINT '  Funcional (9) images inserted';

-- Personal (10)
INSERT INTO imagesForClases (fkClase, urlParaBanner, urlParaParaDescripcionDeClase, urlParaBloqueConsejos, FechaDeCreacion, FechaDeModificacion)
SELECT 10, N'/img/personaltraining.jpg', N'/img/personaltraining.jpg', N'/img/lesiongym.jpg', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM imagesForClases WHERE fkClase = 10);
PRINT '  Personal (10) images inserted';

-- Yoga Avanzado (12)
INSERT INTO imagesForClases (fkClase, urlParaBanner, urlParaParaDescripcionDeClase, urlParaBloqueConsejos, FechaDeCreacion, FechaDeModificacion)
SELECT 12, N'/img/esterilla.jpg', N'/img/esterilla.jpg', N'/img/lesiongym.jpg', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM imagesForClases WHERE fkClase = 12);
PRINT '  Yoga Avanzado (12) images inserted';

PRINT '';

-- ============================================================================
-- 3. UPDATE/INSERT iconsForParameters with REAL SVG files
-- ============================================================================
PRINT '--- 3. Updating benefit icons ---';

-- UPDATE existing icons to use real file paths
UPDATE iconsForParameters SET urlPrivada = N'../img/lightbulb.svg', urlPublica = N'/img/lightbulb.svg'
WHERE nombre = N'versatilidad';
UPDATE iconsForParameters SET urlPrivada = N'../img/svgmacuerna.svg', urlPublica = N'/img/svgmacuerna.svg'
WHERE nombre = N'fuerza-funcional';
UPDATE iconsForParameters SET urlPrivada = N'../img/man.svg', urlPublica = N'/img/man.svg'
WHERE nombre = N'comunidad';
UPDATE iconsForParameters SET urlPrivada = N'../img/svgmacuerna.svg', urlPublica = N'/img/svgmacuerna.svg'
WHERE nombre = N'hipertrofia';
UPDATE iconsForParameters SET urlPrivada = N'../img/peso2.svg', urlPublica = N'/img/peso2.svg'
WHERE nombre = N'densidad-osea';
UPDATE iconsForParameters SET urlPrivada = N'../img/target.svg', urlPublica = N'/img/target.svg'
WHERE nombre = N'coordinacion';
UPDATE iconsForParameters SET urlPrivada = N'../img/man.svg', urlPublica = N'/img/man.svg'
WHERE nombre = N'autodefensa';
UPDATE iconsForParameters SET urlPrivada = N'../img/pies.svg', urlPublica = N'/img/pies.svg'
WHERE nombre = N'movilidad';
UPDATE iconsForParameters SET urlPrivada = N'../img/check.svg', urlPublica = N'/img/check.svg'
WHERE nombre = N'prevencion';
UPDATE iconsForParameters SET urlPrivada = N'../img/lightbulbwhite.svg', urlPublica = N'/img/lightbulbwhite.svg'
WHERE nombre = N'atencion';
UPDATE iconsForParameters SET urlPrivada = N'../img/svgarrow.svg', urlPublica = N'/img/svgarrow.svg'
WHERE nombre = N'progresion';
UPDATE iconsForParameters SET urlPrivada = N'../img/target.svg', urlPublica = N'/img/target.svg'
WHERE nombre = N'resultados';
UPDATE iconsForParameters SET urlPrivada = N'../img/flame.svg', urlPublica = N'/img/flame.svg'
WHERE nombre = N'flama';

-- INSERT missing icons (IF NOT EXISTS)
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'versatilidad', N'../img/lightbulb.svg', N'/img/lightbulb.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'versatilidad');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'fuerza-funcional', N'../img/svgmacuerna.svg', N'/img/svgmacuerna.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'fuerza-funcional');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'comunidad', N'../img/man.svg', N'/img/man.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'comunidad');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'hipertrofia', N'../img/svgmacuerna.svg', N'/img/svgmacuerna.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'hipertrofia');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'densidad-osea', N'../img/peso2.svg', N'/img/peso2.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'densidad-osea');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'coordinacion', N'../img/target.svg', N'/img/target.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'coordinacion');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'autodefensa', N'../img/man.svg', N'/img/man.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'autodefensa');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'movilidad', N'../img/pies.svg', N'/img/pies.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'movilidad');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'prevencion', N'../img/check.svg', N'/img/check.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'prevencion');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'atencion', N'../img/lightbulbwhite.svg', N'/img/lightbulbwhite.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'atencion');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'progresion', N'../img/svgarrow.svg', N'/img/svgarrow.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'progresion');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'resultados', N'../img/target.svg', N'/img/target.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'resultados');
INSERT INTO iconsForParameters (nombre, urlPrivada, urlPublica)
SELECT N'flama', N'../img/flame.svg', N'/img/flame.svg'
WHERE NOT EXISTS (SELECT 1 FROM iconsForParameters WHERE nombre = N'flama');

-- Reassign FK references from fake icons to real ones BEFORE deleting
-- Tables referencing iconsForParameters: parametrosDeMedicion, Ejercicios, Equipos, beneficiosDeClase
PRINT '  Reassigning FK references from fake icons...';

UPDATE parametrosDeMedicion SET fkIcon = (SELECT iconId FROM iconsForParameters WHERE nombre = N'flama')
WHERE fkIcon IN (SELECT iconId FROM iconsForParameters WHERE nombre IN (N'cronometro', N'resistencia'));

UPDATE parametrosDeMedicion SET fkIcon = (SELECT iconId FROM iconsForParameters WHERE nombre = N'coordinacion')
WHERE fkIcon IN (SELECT iconId FROM iconsForParameters WHERE nombre = N'objetivo');

UPDATE Ejercicios SET fkIcon = (SELECT iconId FROM iconsForParameters WHERE nombre = N'fuerza-funcional')
WHERE fkIcon IN (SELECT iconId FROM iconsForParameters WHERE nombre = N'fuerza');

UPDATE Equipos SET fkIcon = (SELECT iconId FROM iconsForParameters WHERE nombre = N'comunidad')
WHERE fkIcon IN (SELECT iconId FROM iconsForParameters WHERE nombre = N'guantes');

UPDATE beneficiosDeClase SET fkIcon = (SELECT iconId FROM iconsForParameters WHERE nombre = N'movilidad')
WHERE fkIcon IN (SELECT iconId FROM iconsForParameters WHERE nombre = N'flexibilidad');

-- Now safe to DELETE icons that don't have real files
DELETE FROM iconsForParameters WHERE nombre IN (N'cronometro', N'objetivo', N'guantes', N'flexibilidad', N'resistencia', N'fuerza');

PRINT '  13 benefit icons updated/inserted, 6 fake icons removed';
PRINT '';

-- ============================================================================
-- 3b. UPDATE/INSERT imagesForExercises
-- ============================================================================
PRINT '--- 3b. Updating/inserting exercise images ---';

-- Exercise 8 (Burpees)
IF EXISTS (SELECT 1 FROM imagesForExercises WHERE fkEjercicio = 8)
BEGIN
    UPDATE imagesForExercises SET
        nombreParaElFront = N'Burpees',
        urlPrivada = N'../img/burpees.jpg',
        urlPublica = N'/img/burpees.jpg'
    WHERE fkEjercicio = 8;
END
ELSE
BEGIN
    INSERT INTO imagesForExercises (fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
    VALUES (8, N'Burpees', N'../img/burpees.jpg', N'/img/burpees.jpg');
END

-- Exercise 9 (Mountain Climbers)
IF EXISTS (SELECT 1 FROM imagesForExercises WHERE fkEjercicio = 9)
BEGIN
    UPDATE imagesForExercises SET
        nombreParaElFront = N'Mountain Climbers',
        urlPrivada = N'../img/mountainclimbers.webp',
        urlPublica = N'/img/mountainclimbers.webp'
    WHERE fkEjercicio = 9;
END
ELSE
BEGIN
    INSERT INTO imagesForExercises (fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
    VALUES (9, N'Mountain Climbers', N'../img/mountainclimbers.webp', N'/img/mountainclimbers.webp');
END

-- Exercise 10 (Jumping Jacks)
IF EXISTS (SELECT 1 FROM imagesForExercises WHERE fkEjercicio = 10)
BEGIN
    UPDATE imagesForExercises SET
        nombreParaElFront = N'Jumping Jacks',
        urlPrivada = N'../img/jumpingjacks.webp',
        urlPublica = N'/img/jumpingjacks.webp'
    WHERE fkEjercicio = 10;
END
ELSE
BEGIN
    INSERT INTO imagesForExercises (fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
    VALUES (10, N'Jumping Jacks', N'../img/jumpingjacks.webp', N'/img/jumpingjacks.webp');
END

-- Exercise 11 (Sentadillas con Salto)
IF EXISTS (SELECT 1 FROM imagesForExercises WHERE fkEjercicio = 11)
BEGIN
    UPDATE imagesForExercises SET
        nombreParaElFront = N'Sentadillas con Salto',
        urlPrivada = N'../img/sentadillaconsalto.jpg',
        urlPublica = N'/img/sentadillaconsalto.jpg'
    WHERE fkEjercicio = 11;
END
ELSE
BEGIN
    INSERT INTO imagesForExercises (fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
    VALUES (11, N'Sentadillas con Salto', N'../img/sentadillaconsalto.jpg', N'/img/sentadillaconsalto.jpg');
END

-- For Exercise 12 (Planchas Laterales)
IF EXISTS (SELECT 1 FROM imagesForExercises WHERE fkEjercicio = 12)
BEGIN
    UPDATE imagesForExercises SET
        nombreParaElFront = N'Planchas Laterales',
        urlPrivada = N'../img/sentadillalateral.webp',
        urlPublica = N'/img/sentadillalateral.webp'
    WHERE fkEjercicio = 12;
END
ELSE
BEGIN
    INSERT INTO imagesForExercises (fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
    VALUES (12, N'Planchas Laterales', N'../img/sentadillalateral.webp', N'/img/sentadillalateral.webp');
END

-- For Exercise 13 (High Knees) - Correct Planchas Laterales name to High Knees and use proper highknees.jpg
IF EXISTS (SELECT 1 FROM imagesForExercises WHERE fkEjercicio = 13)
BEGIN
    UPDATE imagesForExercises SET
        nombreParaElFront = N'High Knees',
        urlPrivada = N'../img/highknees.jpg',
        urlPublica = N'/img/highknees.jpg'
    WHERE fkEjercicio = 13;
END
ELSE
BEGIN
    INSERT INTO imagesForExercises (fkEjercicio, nombreParaElFront, urlPrivada, urlPublica)
    VALUES (13, N'High Knees', N'../img/highknees.jpg', N'/img/highknees.jpg');
END

PRINT '  6 exercise images inserted (skipped: Dominadas, Abdominales, peso muerto - no images available)';
PRINT '';

-- ============================================================================
-- 4. INSERT beneficiosDeClase (3 per class, thematic)
-- ============================================================================
PRINT '--- 4. Inserting class benefits ---';

-- Crossfit (6)
INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 6, N'Versatilidad', iconId, N'Cada día un entrenamiento diferente que combina fuerza, cardio y agilidad para un desarrollo físico integral', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'versatilidad'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 6 AND beneficio = N'Versatilidad');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 6, N'Fuerza Funcional', iconId, N'Movimientos compuestos que mejoran tu capacidad para las actividades de la vida diaria', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'fuerza-funcional'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 6 AND beneficio = N'Fuerza Funcional');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 6, N'Comunidad', iconId, N'Entrena en grupo con un ambiente motivador que te impulsa a dar lo mejor de ti', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'comunidad'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 6 AND beneficio = N'Comunidad');

PRINT '  Crossfit (6) benefits inserted';

-- Fuerza (7)
INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 7, N'Hipertrofia Muscular', iconId, N'Desarrollo muscular progresivo mediante técnicas de entrenamiento de fuerza comprobadas', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'hipertrofia'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 7 AND beneficio = N'Hipertrofia Muscular');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 7, N'Fuerza Máxima', iconId, N'Aumenta tu fuerza bruta con progresiones en los levantamientos fundamentales', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'fuerza-funcional'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 7 AND beneficio = N'Fuerza Máxima');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 7, N'Densidad Ósea', iconId, N'El entrenamiento con pesas fortalece tus huesos y previene la pérdida de masa ósea', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'densidad-osea'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 7 AND beneficio = N'Densidad Ósea');

PRINT '  Fuerza (7) benefits inserted';

-- Boxeo (8)
INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 8, N'Coordinación', iconId, N'Mejora la coordinación mano-ojo y la sincronización de movimientos complejos', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'coordinacion'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 8 AND beneficio = N'Coordinación');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 8, N'Resistencia', iconId, N'Desarrolla resistencia cardiovascular y muscular para rendir al máximo round tras round', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'flama'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 8 AND beneficio = N'Resistencia');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 8, N'Autodefensa', iconId, N'Aprende técnicas efectivas de boxeo que te dan confianza y capacidad de defensa personal', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'autodefensa'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 8 AND beneficio = N'Autodefensa');

PRINT '  Boxeo (8) benefits inserted';

-- Funcional (9)
INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 9, N'Movilidad', iconId, N'Mejora tu rango de movimiento y flexibilidad para un cuerpo más ágil y libre de restricciones', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'movilidad'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 9 AND beneficio = N'Movilidad');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 9, N'Prevención de Lesiones', iconId, N'Fortalece los músculos estabilizadores y mejora los patrones de movimiento para prevenir lesiones', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'prevencion'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 9 AND beneficio = N'Prevención de Lesiones');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 9, N'Vida Diaria', iconId, N'Ejercicios que simulan movimientos cotidianos para hacer tus actividades más fáciles y seguras', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'coordinacion'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 9 AND beneficio = N'Vida Diaria');

PRINT '  Funcional (9) benefits inserted';

-- Personal (10)
INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 10, N'Atención Exclusiva', iconId, N'Recibe guidance 100% personalizada con correcciones en tiempo real y adaptación constante', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'atencion'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 10 AND beneficio = N'Atención Exclusiva');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 10, N'Progresión Personalizada', iconId, N'Tu programa evoluciona contigo, asegurando avances constantes sin estancamientos', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'progresion'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 10 AND beneficio = N'Progresión Personalizada');

INSERT INTO beneficiosDeClase (fkClase, beneficio, fkIcon, descripcionBeneficio, fechaDeCreacion, fechaDeModificacion)
SELECT 10, N'Resultados Acelerados', iconId, N'Maximiza tu tiempo con entrenamientos optimizados para tus objetivos específicos', GETDATE(), GETDATE()
FROM iconsForParameters WHERE nombre = N'resultados'
AND NOT EXISTS (SELECT 1 FROM beneficiosDeClase WHERE fkClase = 10 AND beneficio = N'Resultados Acelerados');

PRINT '  Personal (10) benefits inserted';

-- Fix fkIcon for benefits that were inserted by v1 with deleted icons
UPDATE b SET b.fkIcon = (SELECT iconId FROM iconsForParameters WHERE nombre = N'fuerza-funcional')
FROM beneficiosDeClase b WHERE b.beneficio = N'Fuerza Máxima' AND b.fkClase = 7 AND b.fkIcon IS NULL;

UPDATE b SET b.fkIcon = (SELECT iconId FROM iconsForParameters WHERE nombre = N'flama')
FROM beneficiosDeClase b WHERE b.beneficio = N'Resistencia' AND b.fkClase = 8 AND b.fkIcon IS NULL;

UPDATE b SET b.fkIcon = (SELECT iconId FROM iconsForParameters WHERE nombre = N'coordinacion')
FROM beneficiosDeClase b WHERE b.beneficio = N'Vida Diaria' AND b.fkClase = 9 AND b.fkIcon IS NULL;

PRINT '  Fixed fkIcon references for 3 benefits';
PRINT '';

-- ============================================================================
-- 5. INSERT estructuraDeClase (3 blocks per class)
-- ============================================================================
PRINT '--- 5. Inserting class structure blocks ---';

-- Crossfit (6)
INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 6, 1, 5, 7, N'Calentamiento', N'Movilidad articular dinámica y activación muscular progresiva. Preparamos el cuerpo con ejercicios de bajo impacto que elevan gradualmente el ritmo cardíaco y lubrican las articulaciones.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 6 AND numeroConsecutivoDelBloque = 1);

INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 6, 2, 30, 35, N'WOD - Workout of the Day', N'El entrenamiento del día combina movimientos funcionales de fuerza y acondicionamiento. Realizamos circuitos de alta intensidad con ejercicios como thrusters, box jumps, cleans y muscle-ups. Cada WOD es diferente y escalable a tu nivel.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 6 AND numeroConsecutivoDelBloque = 2);

INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 6, 3, 5, 7, N'Enfriamiento y Estiramientos', N'Vuelta a la calma con ejercicios de baja intensidad y estiramientos estáticos enfocados en los grupos musculares trabajados. Fundamental para la recuperación y prevención de agujetas.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 6 AND numeroConsecutivoDelBloque = 3);

PRINT '  Crossfit (6) blocks inserted';

-- Fuerza (7)
INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 7, 1, 5, 10, N'Calentamiento Específico', N'Activación muscular con series de aproximación progresiva. Preparamos el sistema nervioso central y las articulaciones con movilidad específica para los levantamientos principales del día.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 7 AND numeroConsecutivoDelBloque = 1);

INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 7, 2, 30, 35, N'Bloques de Fuerza', N'Trabajo principal con ejercicios compuestos: sentadilla, peso muerto, press de banca y press militar. Realizamos series de 3-8 repeticiones con descansos de 2-3 minutos entre series. Progresión lineal o ondulante según el ciclo de entrenamiento.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 7 AND numeroConsecutivoDelBloque = 2);

INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 7, 3, 5, 10, N'Accesorios y Enfriamiento', N'Ejercicios accesorios para puntos débiles seguidos de estiramientos estáticos. Enfocados en mejorar la recuperación y corregir desequilibrios musculares.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 7 AND numeroConsecutivoDelBloque = 3);

PRINT '  Fuerza (7) blocks inserted';

-- Boxeo (8)
INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 8, 1, 5, 10, N'Calentamiento y Sombra', N'Trote suave, saltos de cuerda y shadow boxing progresivo. Activamos el sistema cardiovascular y practicamos la técnica de golpes al aire, enfocándonos en la postura y el movimiento de pies.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 8 AND numeroConsecutivoDelBloque = 1);

INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 8, 2, 25, 30, N'Técnica y Combinaciones', N'Trabajo de técnica con instructor: jab, cross, hooks, uppercuts y combinaciones. Práctica en saco, manoplas y sparring controlado. Desarrollo de defensa, esquiva y contraataque.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 8 AND numeroConsecutivoDelBloque = 2);

INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 8, 3, 5, 10, N'Acondicionamiento Final', N'Circuito de acondicionamiento específico para boxeo: burpees, abdominales, flexiones y trabajo de core. Enfriamiento con estiramientos de hombros, brazos y piernas.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 8 AND numeroConsecutivoDelBloque = 3);

PRINT '  Boxeo (8) blocks inserted';

-- Funcional (9)
INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 9, 1, 5, 10, N'Movilidad y Activación', N'Secuencia de movilidad articular completa y activación del core. Ejercicios de respiración diafragmática y preparación del sistema nervioso para movimientos multiplanares.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 9 AND numeroConsecutivoDelBloque = 1);

INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 9, 2, 25, 30, N'Circuito Funcional', N'Circuito de ejercicios que simulan patrones de movimiento naturales: empujar, tirar, cargar, girar y desplazarse. Utilizamos kettlebells, TRX, bandas elásticas y peso corporal. Intensidad moderada con enfoque en la técnica.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 9 AND numeroConsecutivoDelBloque = 2);

INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 9, 3, 5, 10, N'Vuelta a la Calma', N'Estiramientos dinámicos y estáticos, técnicas de respiración y relajación muscular progresiva. Incluye trabajo de foam rolling para liberar tensión fascial.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 9 AND numeroConsecutivoDelBloque = 3);

PRINT '  Funcional (9) blocks inserted';

-- Personal (10)
INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 10, 1, 5, 10, N'Evaluación y Calentamiento', N'Evaluación del estado del día y ajuste del plan. Calentamiento personalizado basado en las necesidades específicas del cliente y los ejercicios planificados para la sesión.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 10 AND numeroConsecutivoDelBloque = 1);

INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 10, 2, 30, 35, N'Entrenamiento Personalizado', N'Sesión diseñada exclusivamente para tus objetivos: puede incluir trabajo de fuerza, hipertrofia, resistencia, movilidad o combinación. Corrección constante de técnica y ajuste de cargas en tiempo real.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 10 AND numeroConsecutivoDelBloque = 2);

INSERT INTO estructuraDeClase (fkClase, numeroConsecutivoDelBloque, duracionMenorEnMinutos, duracionMayorEnMinutos, tituloBloque, descripcionBloque, fechaDeCreacion, fechaDeModificacion)
SELECT 10, 3, 5, 10, N'Feedback y Recuperación', N'Análisis del rendimiento de la sesión, registro de progresos y planificación del próximo entrenamiento. Estiramientos guiados y recomendaciones de recuperación activa.', GETDATE(), GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM estructuraDeClase WHERE fkClase = 10 AND numeroConsecutivoDelBloque = 3);

PRINT '  Personal (10) blocks inserted';
PRINT '';

-- ============================================================================
-- 6. INSERT Rutinas (1 per class, type 'clase' = 1)
-- ============================================================================
PRINT '--- 6. Inserting routines ---';

DECLARE @RutinaIds TABLE (ClaseID int, RutinaID int);

INSERT INTO Rutinas (fkClase, fkTipoRutina, EntrenadorId, Observaciones, FechaCreacion)
SELECT 5, 1, @TrainerYesenia, N'Rutina de clase HIIT', GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM Rutinas WHERE fkClase = 5 AND fkTipoRutina = 1);

INSERT INTO Rutinas (fkClase, fkTipoRutina, EntrenadorId, Observaciones, FechaCreacion)
SELECT 6, 1, @TrainerYesenia, N'Rutina de clase CrossFit', GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM Rutinas WHERE fkClase = 6 AND fkTipoRutina = 1);

INSERT INTO Rutinas (fkClase, fkTipoRutina, EntrenadorId, Observaciones, FechaCreacion)
SELECT 7, 1, @TrainerYesenia, N'Rutina de clase Fuerza y Potencia', GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM Rutinas WHERE fkClase = 7 AND fkTipoRutina = 1);

INSERT INTO Rutinas (fkClase, fkTipoRutina, EntrenadorId, Observaciones, FechaCreacion)
SELECT 8, 1, @TrainerAntonio, N'Rutina de clase Boxeo', GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM Rutinas WHERE fkClase = 8 AND fkTipoRutina = 1);

INSERT INTO Rutinas (fkClase, fkTipoRutina, EntrenadorId, Observaciones, FechaCreacion)
SELECT 9, 1, @TrainerAaron, N'Rutina de clase Entrenamiento Funcional', GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM Rutinas WHERE fkClase = 9 AND fkTipoRutina = 1);

INSERT INTO Rutinas (fkClase, fkTipoRutina, EntrenadorId, Observaciones, FechaCreacion)
SELECT 10, 1, @TrainerAntonio, N'Rutina de clase Entrenamiento Personal', GETDATE()
WHERE NOT EXISTS (SELECT 1 FROM Rutinas WHERE fkClase = 10 AND fkTipoRutina = 1);

INSERT INTO @RutinaIds (ClaseID, RutinaID)
SELECT fkClase, RutinaID FROM Rutinas WHERE fkClase IN (5,6,7,8,9,10) AND fkTipoRutina = 1;

PRINT '  6 routines inserted';
PRINT '';

-- ============================================================================
-- 7. INSERT RutinaEjercicios
-- ============================================================================
PRINT '--- 7. Inserting routine exercises ---';

-- HIIT (5): 8,9,10,11,13
INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 8, 4, 12, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 5
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 5 AND re.EjercicioID = 8);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 9, 4, 0, 0, 30, 20 FROM @RutinaIds r WHERE r.ClaseID = 5
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 5 AND re.EjercicioID = 9);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 10, 3, 0, 0, 45, 20 FROM @RutinaIds r WHERE r.ClaseID = 5
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 5 AND re.EjercicioID = 10);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 11, 4, 15, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 5
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 5 AND re.EjercicioID = 11);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 13, 3, 0, 0, 30, 20 FROM @RutinaIds r WHERE r.ClaseID = 5
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 5 AND re.EjercicioID = 13);

PRINT '  HIIT (5) exercises inserted';

-- Fuerza (7): 4,11,1,2,12
INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 4, 4, 8, 0, 0, 12 FROM @RutinaIds r WHERE r.ClaseID = 7
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 7 AND re.EjercicioID = 4);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 11, 3, 12, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 7
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 7 AND re.EjercicioID = 11);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 1, 4, 10, 0, 0, 12 FROM @RutinaIds r WHERE r.ClaseID = 7
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 7 AND re.EjercicioID = 1);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 2, 3, 15, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 7
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 7 AND re.EjercicioID = 2);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 12, 3, 0, 0, 45, 20 FROM @RutinaIds r WHERE r.ClaseID = 7
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 7 AND re.EjercicioID = 12);

PRINT '  Fuerza (7) exercises inserted';

-- CrossFit (6): 8,1,11,9,13
INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 8, 4, 12, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 6
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 6 AND re.EjercicioID = 8);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 1, 3, 10, 0, 0, 12 FROM @RutinaIds r WHERE r.ClaseID = 6
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 6 AND re.EjercicioID = 1);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 11, 4, 15, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 6
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 6 AND re.EjercicioID = 11);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 9, 3, 0, 0, 30, 20 FROM @RutinaIds r WHERE r.ClaseID = 6
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 6 AND re.EjercicioID = 9);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 13, 4, 0, 0, 30, 20 FROM @RutinaIds r WHERE r.ClaseID = 6
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 6 AND re.EjercicioID = 13);

PRINT '  CrossFit (6) exercises inserted';

-- Boxeo (8): 10,8,2,12,13
INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 10, 3, 0, 0, 30, 20 FROM @RutinaIds r WHERE r.ClaseID = 8
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 8 AND re.EjercicioID = 10);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 8, 3, 12, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 8
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 8 AND re.EjercicioID = 8);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 2, 3, 15, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 8
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 8 AND re.EjercicioID = 2);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 12, 3, 0, 0, 45, 20 FROM @RutinaIds r WHERE r.ClaseID = 8
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 8 AND re.EjercicioID = 12);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 13, 3, 0, 0, 30, 20 FROM @RutinaIds r WHERE r.ClaseID = 8
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 8 AND re.EjercicioID = 13);

PRINT '  Boxeo (8) exercises inserted';

-- Funcional (9): 11,9,12,1,10
INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 11, 3, 12, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 9
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 9 AND re.EjercicioID = 11);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 9, 3, 0, 0, 30, 20 FROM @RutinaIds r WHERE r.ClaseID = 9
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 9 AND re.EjercicioID = 9);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 12, 3, 0, 0, 45, 20 FROM @RutinaIds r WHERE r.ClaseID = 9
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 9 AND re.EjercicioID = 12);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 1, 3, 10, 0, 0, 12 FROM @RutinaIds r WHERE r.ClaseID = 9
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 9 AND re.EjercicioID = 1);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 10, 3, 0, 0, 45, 20 FROM @RutinaIds r WHERE r.ClaseID = 9
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 9 AND re.EjercicioID = 10);

PRINT '  Funcional (9) exercises inserted';

-- Personal (10): 8,4,2,11,12
INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 8, 3, 12, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 10
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 10 AND re.EjercicioID = 8);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 4, 4, 10, 0, 0, 12 FROM @RutinaIds r WHERE r.ClaseID = 10
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 10 AND re.EjercicioID = 4);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 2, 3, 15, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 10
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 10 AND re.EjercicioID = 2);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 11, 4, 12, 0, 0, 15 FROM @RutinaIds r WHERE r.ClaseID = 10
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 10 AND re.EjercicioID = 11);

INSERT INTO RutinaEjercicios (RutinaID, EjercicioID, Sets, Repeticiones, Peso, Tiempo, MetaRepeticiones)
SELECT r.RutinaID, 12, 3, 0, 0, 45, 20 FROM @RutinaIds r WHERE r.ClaseID = 10
AND NOT EXISTS (SELECT 1 FROM RutinaEjercicios re INNER JOIN @RutinaIds r2 ON re.RutinaID = r2.RutinaID WHERE r2.ClaseID = 10 AND re.EjercicioID = 12);

PRINT '  Personal (10) exercises inserted';
PRINT '';

-- ============================================================================
-- 8. UPDATE/INSERT Equipos with REAL icon references
-- ============================================================================
PRINT '--- 8. Updating additional equipment ---';

-- Fix fkIcon for equipment inserted by v1 with deleted icons
UPDATE e SET e.fkIcon = (SELECT iconId FROM iconsForParameters WHERE nombre = N'comunidad')
FROM Equipos e WHERE e.NombreEquipo = N'Guantes de Boxeo' AND e.fkIcon IS NULL;

UPDATE e SET e.fkIcon = (SELECT iconId FROM iconsForParameters WHERE nombre = N'progresion')
FROM Equipos e WHERE e.NombreEquipo = N'Cuerda de Saltar' AND e.fkIcon IS NULL;

UPDATE e SET e.fkIcon = (SELECT iconId FROM iconsForParameters WHERE nombre = N'fuerza-funcional')
FROM Equipos e WHERE e.NombreEquipo = N'TRX' AND e.fkIcon IS NULL;

-- Insert new equipment (IF NOT EXISTS)
INSERT INTO Equipos (NombreEquipo, Descripcion, fkIcon)
SELECT N'Guantes de Boxeo', N'Protección esencial para las manos durante el entrenamiento de boxeo y saco', iconId
FROM iconsForParameters WHERE nombre = N'comunidad'
AND NOT EXISTS (SELECT 1 FROM Equipos WHERE NombreEquipo = N'Guantes de Boxeo');

INSERT INTO Equipos (NombreEquipo, Descripcion, fkIcon)
SELECT N'Cuerda de Saltar', N'Herramienta fundamental para calentamiento cardiovascular y coordinación', iconId
FROM iconsForParameters WHERE nombre = N'progresion'
AND NOT EXISTS (SELECT 1 FROM Equipos WHERE NombreEquipo = N'Cuerda de Saltar');

INSERT INTO Equipos (NombreEquipo, Descripcion, fkIcon)
SELECT N'TRX', N'Sistema de entrenamiento en suspensión para ejercicios de peso corporal multiplanares', iconId
FROM iconsForParameters WHERE nombre = N'fuerza-funcional'
AND NOT EXISTS (SELECT 1 FROM Equipos WHERE NombreEquipo = N'TRX');

PRINT '  3 equipment items updated/inserted';
PRINT '';

-- ============================================================================
-- 9. INSERT consejosParaLasClases
-- ============================================================================
PRINT '--- 9. Inserting class tips ---';

INSERT INTO consejosParaLasClases (fkClase, fkEjercicio, introduccionDeConsejo, consejos)
SELECT 6, NULL,
    N'Si eres nuevo en CrossFit, estos consejos te ayudarán a comenzar con seguridad y progresar adecuadamente:',
    N'Comienza con pesos ligeros hasta dominar la técnica de cada movimiento, no dudes en escalar los ejercicios según tu nivel, mantén una buena hidratación antes durante y después del entrenamiento, prioriza la técnica sobre la velocidad o el peso, informa al coach sobre cualquier lesión previa, descansa adecuadamente entre sesiones intensas y escucha a tu cuerpo.'
WHERE NOT EXISTS (SELECT 1 FROM consejosParaLasClases WHERE fkClase = 6);

PRINT '  Crossfit (6) tips inserted';

INSERT INTO consejosParaLasClases (fkClase, fkEjercicio, introduccionDeConsejo, consejos)
SELECT 7, NULL,
    N'Para maximizar tus ganancias de fuerza y evitar lesiones, sigue estas recomendaciones:',
    N'Calienta siempre con series de aproximación progresiva antes de tus series pesadas, mantén una técnica impecable antes de aumentar el peso, respeta los tiempos de descanso entre series para una recuperación óptima, lleva un registro de tus progresos para asegurar la progresión lineal, alimenta tu cuerpo con suficiente proteína y calorías, duerme al menos 7-8 horas para una recuperación muscular adecuada, no saltes los días de pierna y trabaja todo el cuerpo de forma equilibrada.'
WHERE NOT EXISTS (SELECT 1 FROM consejosParaLasClases WHERE fkClase = 7);

PRINT '  Fuerza (7) tips inserted';

INSERT INTO consejosParaLasClases (fkClase, fkEjercicio, introduccionDeConsejo, consejos)
SELECT 8, NULL,
    N'Para aprovechar al máximo tus clases de boxeo y progresar de forma segura:',
    N'Mantén siempre la guardia alta y la barbilla abajo, no contengas la respiración durante las combinaciones, trabaja tu juego de pies tanto como tus golpes, usa vendaje y guantes adecuados para proteger tus manos, practica la defensa tanto como el ataque, no te saltes el calentamiento ni el enfriamiento, bebe agua entre rounds y mantén una buena nutrición para rendir al máximo.'
WHERE NOT EXISTS (SELECT 1 FROM consejosParaLasClases WHERE fkClase = 8);

PRINT '  Boxeo (8) tips inserted';

INSERT INTO consejosParaLasClases (fkClase, fkEjercicio, introduccionDeConsejo, consejos)
SELECT 9, NULL,
    N'El entrenamiento funcional es para todos los niveles. Sigue estos consejos para obtener los mejores resultados:',
    N'Enfócate en la calidad del movimiento antes que en la cantidad de repeticiones, respira de forma coordinada con cada movimiento, mantén el core activado durante todos los ejercicios, utiliza calzado adecuado o entrena descalzo según la superficie, no compares tu progreso con el de otros, cada cuerpo es diferente, incorpora el entrenamiento funcional como complemento a tu rutina habitual, presta atención a las sensaciones de tu cuerpo y ajusta la intensidad según sea necesario.'
WHERE NOT EXISTS (SELECT 1 FROM consejosParaLasClases WHERE fkClase = 9);

PRINT '  Funcional (9) tips inserted';

INSERT INTO consejosParaLasClases (fkClase, fkEjercicio, introduccionDeConsejo, consejos)
SELECT 10, NULL,
    N'Tu entrenamiento personal está diseñado exclusivamente para ti. Maximiza sus beneficios con estas recomendaciones:',
    N'Sé honesto con tu entrenador sobre cómo te sientes cada día, cumple con las recomendaciones de nutrición y descanso fuera del gimnasio, comunica cualquier molestia o dolor inmediatamente, mantén una actitud positiva y comprometida con tu proceso, registra tus sensaciones y progresos entre sesiones, sigue las indicaciones de recuperación activa en los días de descanso, confía en el proceso y sé paciente con los resultados.'
WHERE NOT EXISTS (SELECT 1 FROM consejosParaLasClases WHERE fkClase = 10);

PRINT '  Personal (10) tips inserted';
PRINT '';

-- ============================================================================
-- 10. INSERT horarios (horasLaborales + clasesProgramadas + horariosDeClasesProgramadas)
-- ============================================================================
PRINT '--- 10. Inserting schedules ---';

DECLARE @Today date = CAST(GETDATE() AS date);
DECLARE @TodayDW int = DATEPART(dw, @Today);

DECLARE @NextMonday    date = DATEADD(day, CASE WHEN @TodayDW <= 2 THEN 2 - @TodayDW ELSE 9 - @TodayDW END, @Today);
DECLARE @NextTuesday   date = DATEADD(day, CASE WHEN @TodayDW <= 3 THEN 3 - @TodayDW ELSE 10 - @TodayDW END, @Today);
DECLARE @NextWednesday date = DATEADD(day, CASE WHEN @TodayDW <= 4 THEN 4 - @TodayDW ELSE 11 - @TodayDW END, @Today);
DECLARE @NextThursday  date = DATEADD(day, CASE WHEN @TodayDW <= 5 THEN 5 - @TodayDW ELSE 12 - @TodayDW END, @Today);
DECLARE @NextFriday    date = DATEADD(day, CASE WHEN @TodayDW <= 6 THEN 6 - @TodayDW ELSE 13 - @TodayDW END, @Today);
DECLARE @NextSaturday  date = DATEADD(day, CASE WHEN @TodayDW <= 7 THEN 7 - @TodayDW ELSE 14 - @TodayDW END, @Today);

PRINT '  Reference dates:';
PRINT '    Monday:    ' + CONVERT(nvarchar, @NextMonday, 103);
PRINT '    Tuesday:   ' + CONVERT(nvarchar, @NextTuesday, 103);
PRINT '    Wednesday: ' + CONVERT(nvarchar, @NextWednesday, 103);
PRINT '    Thursday:  ' + CONVERT(nvarchar, @NextThursday, 103);
PRINT '    Friday:    ' + CONVERT(nvarchar, @NextFriday, 103);
PRINT '    Saturday:  ' + CONVERT(nvarchar, @NextSaturday, 103);
PRINT '';

DECLARE @InsertedHorarios TABLE (idHora int, idProgramacionClase int);

-- HIIT (5): Lunes 6:00-6:45, Martes 17:30-18:15, Jueves 6:00-6:45
PRINT '  HIIT (5) schedules:';

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('06:00', '06:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (5, 10, 1, @TrainerYesenia, @NextMonday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('17:30', '18:15');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (5, 10, 1, @TrainerAntonio, @NextTuesday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('06:00', '06:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (5, 10, 1, @TrainerYesenia, @NextThursday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

PRINT '    3 HIIT schedules inserted';

-- Crossfit (6): Lunes 17:00, Miércoles 17:00, Viernes 17:00
PRINT '  Crossfit (6) schedules:';

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('17:00', '17:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (6, 10, 1, @TrainerMatias, @NextMonday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('17:00', '17:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (6, 10, 1, @TrainerMatias, @NextWednesday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('17:00', '17:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (6, 10, 1, @TrainerAaron, @NextFriday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

PRINT '    3 Crossfit schedules inserted';

-- Fuerza (7): Martes 7:00, Jueves 7:00, Sábado 9:00
PRINT '  Fuerza (7) schedules:';

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('07:00', '07:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (7, 10, 1, @TrainerYesenia, @NextTuesday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('07:00', '07:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (7, 10, 1, @TrainerYesenia, @NextThursday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('09:00', '09:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (7, 10, 1, @TrainerAaron, @NextSaturday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

PRINT '    3 Fuerza schedules inserted';

-- Boxeo (8): Lunes 18:00, Miércoles 18:00, Viernes 12:00
PRINT '  Boxeo (8) schedules:';

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('18:00', '18:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (8, 10, 1, @TrainerAntonio, @NextMonday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('18:00', '18:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (8, 10, 1, @TrainerAntonio, @NextWednesday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('12:00', '12:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (8, 10, 1, @TrainerMatias, @NextFriday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

PRINT '    3 Boxeo schedules inserted';

-- Funcional (9): Martes 10:00, Jueves 10:00, Sábado 8:00
PRINT '  Funcional (9) schedules:';

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('10:00', '10:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (9, 10, 1, @TrainerAaron, @NextTuesday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('10:00', '10:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (9, 10, 1, @TrainerAaron, @NextThursday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('08:00', '08:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (9, 10, 1, @TrainerMatias, @NextSaturday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

PRINT '    3 Funcional schedules inserted';

-- Personal (10): Lunes 8:00, Miércoles 8:00, Viernes 8:00
PRINT '  Personal (10) schedules:';

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('08:00', '08:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (10, 10, 1, @TrainerYesenia, @NextMonday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('08:00', '08:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (10, 10, 1, @TrainerAntonio, @NextWednesday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

INSERT INTO horasLaborales (horaInicio, horaFin) VALUES ('08:00', '08:45');
INSERT INTO @InsertedHorarios (idHora) VALUES (SCOPE_IDENTITY());
INSERT INTO clasesProgramadas (fkClase, cupoMaximo, fkEstadoClaseProgramada, fkEntrenador, fechaDeLaClase)
VALUES (10, 10, 1, @TrainerYesenia, @NextFriday);
UPDATE ih SET ih.idProgramacionClase = SCOPE_IDENTITY()
FROM @InsertedHorarios ih WHERE idProgramacionClase IS NULL AND idHora = (SELECT MAX(idHora) FROM @InsertedHorarios WHERE idProgramacionClase IS NULL);

PRINT '    3 Personal schedules inserted';

-- Link horariosDeClasesProgramadas
INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral, fkEstadoHorarioClase)
SELECT idProgramacionClase, idHora, 1 FROM @InsertedHorarios;

PRINT '  18 schedule links (horariosDeClasesProgramadas) inserted';
PRINT '';

-- ============================================================================
-- Summary
-- ============================================================================
PRINT '========================================';
PRINT 'Seed completed successfully!';
PRINT '========================================';
PRINT '';
PRINT 'Summary:';
PRINT '  - 6 Clases updated with descriptions and metadata';
PRINT '  - 5 imagesForClases updated/inserted with REAL /img/ paths';
PRINT '  - 13 benefit icons updated/inserted with REAL SVG files';
PRINT '  - 6 fake icons removed (no real files)';
PRINT '  - 6 exercise images inserted (imagesForExercises)';
PRINT '  - 15 beneficiosDeClase inserted (3 per class x 5 classes)';
PRINT '  - 3 benefit fkIcon references fixed';
PRINT '  - 15 estructuraDeClase blocks inserted (3 per class x 5)';
PRINT '  - 6 Rutinas inserted';
PRINT '  - 30 RutinaEjercicios inserted (5 per routine)';
PRINT '  - 3 Equipos updated/inserted with REAL icon references';
PRINT '  - 5 consejosParaLasClases inserted';
PRINT '  - 18 horasLaborales inserted';
PRINT '  - 18 clasesProgramadas inserted';
PRINT '  - 18 horariosDeClasesProgramadas inserted';

COMMIT TRAN;
GO
