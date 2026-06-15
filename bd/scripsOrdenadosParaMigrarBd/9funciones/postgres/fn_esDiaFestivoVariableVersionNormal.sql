-- =============================================
-- FUNCTION: fn_es_dia_festivo_variable_version_normal
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_es_dia_festivo_variable_version_normal(fecha_analizada date)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
    es_dia_festivo boolean := false;
BEGIN
    -- Consultar si existe algún día festivo variable que coincida con la fecha analizada
    IF EXISTS (
        SELECT 1
        FROM public.dias_festivos_variables dfv
        WHERE public.fn_es_dia_festivo_variable_version_join(
            fecha_analizada, 
            dfv.de_que_dia, 
            dfv.de_que_semana, 
            dfv.de_que_mes, 
            dfv.fk_tipo_de_recurrencia_del_festivo
        ) = true
    ) THEN
        es_dia_festivo := true;
    END IF;
    
    RETURN es_dia_festivo;
END;
$$;