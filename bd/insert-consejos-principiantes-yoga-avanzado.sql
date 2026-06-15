/*
    Insert: Agregar consejos para principiantes a la clase Yoga Avanzado (ClaseID = 12)
    Basado en: seed-datos-detallados-clases.sql (mismo patrón)
*/

USE [FitnessCenterDB]
GO

SET NOCOUNT ON;
GO

BEGIN TRAN;
GO

PRINT '============================================================';
PRINT 'Insertando consejos para principiantes - Yoga Avanzado (12)';
PRINT '============================================================';
PRINT '';

INSERT INTO consejosParaLasClases (fkClase, fkEjercicio, introduccionDeConsejo, consejos)
SELECT 12, NULL,
    N'Si eres nuevo en Yoga Avanzado, estos consejos te ayudarán a comenzar con seguridad, mejorar tu práctica y aprovechar al máximo cada sesión:',
    N'Llega 5–10 minutos antes para adaptarte mental y físicamente; entrar con prisa afecta tu respiración, enfoque y rendimiento desde el inicio. '
    + N'Prioriza la respiración sobre la postura; si no puedes respirar con control, estás forzando demasiado y la ejecución pierde calidad. '
    + N'No te compares con otros porque cada cuerpo progresa a ritmos distintos; compararte solo genera frustración y te distrae de tu propio avance. '
    + N'Usa bloques, cinturones o apoyos sin vergüenza; te ayudan a mantener una técnica correcta y evitan lesiones por sobreesfuerzo. '
    + N'Mantén control aunque la postura sea menos profunda; una ejecución estable y alineada es más efectiva que forzar el rango de movimiento. '
    + N'Descansa cuando lo necesites sin sentir que fallas; pausar es parte de la práctica y te permite continuar con mejor rendimiento. '
    + N'Aprende a distinguir entre incomodidad y dolor; la incomodidad es normal, pero el dolor es una señal clara de detenerte. '
    + N'No necesitas ser flexible para empezar; la flexibilidad se desarrolla con la práctica constante, no antes. '
    + N'La constancia supera a la intensidad; practicar de forma regular genera más progreso que esfuerzos esporádicos y extremos. '
    + N'Comunica cualquier molestia o condición al instructor; esto permite adaptar la práctica para que sea segura y efectiva.'
WHERE NOT EXISTS (SELECT 1 FROM consejosParaLasClases WHERE fkClase = 12);

PRINT '  Yoga Avanzado (12) tips inserted';
PRINT '';
PRINT '========================================';
PRINT 'Script completed successfully!';
PRINT '========================================';

COMMIT TRAN;
GO
