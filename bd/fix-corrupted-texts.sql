-- ============================================================================
-- FitnessGym - Fix Corrupted Texts (encoding & data bugs)
-- ============================================================================
-- Source de textos correctos: seed-datos-detallados-clases.sql
-- ============================================================================

SET NOCOUNT ON;
BEGIN TRAN;

PRINT 'Fixing corrupted texts...';

-- ============================================================================
-- 1. Clases - Descripcion (encoding corruption + copy-paste bug)
-- ============================================================================
UPDATE Clases SET
    duracionEnMinutos = 45, fkIntensidad = 3, fkDificultad = 2, fkEstadoClase = 1,
    Descripcion = N'El HIIT (High Intensity Interval Training) es un método de entrenamiento que alterna períodos de ejercicio intenso con breves descansos activos o pasivos. Esta metodología maximiza la quema calórica en sesiones cortas, generando un efecto post-ejercicio (EPOC) que mantiene tu metabolismo acelerado hasta por 24 horas.

Ideal para quienes buscan resultados en poco tiempo, el HIIT mejora la capacidad cardiovascular, aumenta la resistencia muscular y promueve la pérdida de grasa preservando la masa muscular. Cada sesión está diseñada para llevarte al límite de forma segura y progresiva.'
WHERE ClaseID = 5;

UPDATE Clases SET
    duracionEnMinutos = 45, fkIntensidad = 3, fkDificultad = 3, fkEstadoClase = 1,
    Descripcion = N'El CrossFit es un sistema de entrenamiento de fuerza y acondicionamiento que combina movimientos funcionales ejecutados a alta intensidad. Cada sesión (WOD - Workout of the Day) es diferente y trabaja múltiples capacidades físicas: resistencia cardiovascular, fuerza, potencia, velocidad, agilidad, coordinación y equilibrio.

Nuestros WODs son escalables a cualquier nivel, desde principiantes hasta atletas avanzados. Entrenarás con barra, kettlebells, anillas, cuerdas y tu propio peso corporal en un ambiente de comunidad que te impulsa a superar tus límites cada día.'
WHERE ClaseID = 6;

UPDATE Clases SET
    fkIntensidad = 3, fkDificultad = 3, fkEstadoClase = 1,
    Descripcion = N'El entrenamiento de fuerza y potencia está diseñado para desarrollar tu capacidad muscular máxima. Trabajamos con los levantamientos fundamentales: sentadilla, peso muerto, press de banca y press militar, aplicando principios de progresión lineal y ondulante para garantizar mejoras constantes.

Cada ciclo de entrenamiento tiene objetivos específicos: hipertrofia, fuerza máxima o potencia explosiva. Aprenderás la técnica correcta de cada movimiento, cómo periodizar tu entrenamiento y cómo nutrirte para maximizar la recuperación y el crecimiento muscular.'
WHERE ClaseID = 7;

UPDATE Clases SET
    fkIntensidad = 2, fkDificultad = 1, fkEstadoClase = 1,
    Descripcion = N'El boxeo es mucho más que un deporte de combate: es un entrenamiento completo que combina técnica, resistencia cardiovascular y fuerza funcional. En nuestras clases aprenderás los fundamentos del boxeo desde cero: postura, guardia, desplazamiento y los golpes básicos (jab, cross, hook, uppercut).

Cada sesión incluye trabajo de sombra, saco, manoplas y sparring controlado. Desarrollarás coordinación, reflejos, resistencia y confianza mientras te diviertes en un ambiente energético y motivador. Apto para todos los niveles, sin contacto obligatorio.'
WHERE ClaseID = 8;

UPDATE Clases SET
    fkIntensidad = 1, fkDificultad = 1, fkEstadoClase = 1,
    Descripcion = N'El entrenamiento funcional se basa en ejercicios que simulan patrones de movimiento naturales del cuerpo humano: empujar, tirar, cargar, girar, sentarse y desplazarse. El objetivo es mejorar tu capacidad para realizar actividades cotidianas con mayor facilidad, eficiencia y menor riesgo de lesiones.

Utilizamos una variedad de herramientas como kettlebells, TRX, bandas elásticas, balones medicinales y peso corporal. Las clases son dinámicas, accesibles para todos los niveles y enfocadas en la calidad del movimiento antes que en la intensidad.'
WHERE ClaseID = 9;

UPDATE Clases SET
    fkIntensidad = 1, fkDificultad = 3, fkEstadoClase = 1,
    Descripcion = N'El entrenamiento personal es la forma más efectiva de alcanzar tus objetivos fitness. Cada sesión es diseñada exclusivamente para ti, basada en una evaluación inicial de tu condición física, historial de lesiones, disponibilidad y metas específicas.

Tu entrenador te guiará con correcciones en tiempo real, ajustará cargas y ejercicios según tu progreso diario, y te proporcionará un plan de nutrición y recuperación complementario. Es la inversión más inteligente para resultados garantizados y sostenibles.'
WHERE ClaseID = 10;

-- ============================================================================
-- 2. iconosForParameters - Fix urlPublica data bug (iconId=6)
-- ============================================================================
UPDATE iconsForParameters SET
    urlPublica = N'../img/aquabottle.svg'
WHERE iconId = 6;

-- ============================================================================
-- 3. tiposDeRecurrenciaDeDiasFestivos - Fix typos
-- ============================================================================
UPDATE tiposDeRecurrenciaDeDiasFestivos SET
    descripcion = N'Se repite cada semana, es un o unos días específicos de la semana, por ejemplo domingo o sábado y domingo'
WHERE idTipoDeRecurrenciaDeDiaFestivo = 1;

UPDATE tiposDeRecurrenciaDeDiasFestivos SET
    descripcion = N'Se repite cada mes en una fecha fija, no es común pero debe tomarse en cuenta'
WHERE idTipoDeRecurrenciaDeDiaFestivo = 2;

UPDATE tiposDeRecurrenciaDeDiasFestivos SET
    descripcion = N'Se repite cada año en una fecha fija, por ejemplo 10 de mayo, 2 de noviembre'
WHERE idTipoDeRecurrenciaDeDiaFestivo = 3;

UPDATE tiposDeRecurrenciaDeDiasFestivos SET
    descripcion = N'Se repite pero la fecha es variable, por ejemplo día del padre'
WHERE idTipoDeRecurrenciaDeDiaFestivo = 4;

-- ============================================================================
-- 4. unidadesDeMedida - Fix leading space
-- ============================================================================
UPDATE unidadesDeMedida SET
    nombre = N'kg/m²'
WHERE unidadDeMedidaId = 2;

PRINT 'Fix script complete. Review before COMMIT or ROLLBACK.';

-- COMMIT;
-- ROLLBACK;
GO
