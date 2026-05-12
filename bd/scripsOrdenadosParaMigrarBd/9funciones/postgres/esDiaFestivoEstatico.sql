-- =============================================
-- FUNCTION: es_dia_festivo_estatico
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.es_dia_festivo_estatico(fecha_analizada date)
RETURNS integer
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM dias_festivos_y_descansos dfy 
        JOIN estados_de_actividad_laboral edal 
        ON dfy.fk_estado_actividad_laboral = edal.id_estado_actividad_laboral
        WHERE fecha_festiva_o_descanso = fecha_analizada 
            AND edal.nombre_estado_actividad_laboral = 'no se labora'
    ) THEN
        RETURN 1;
    END IF;
    RETURN 0;
END;
$$;