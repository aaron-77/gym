-- =============================================
-- FUNCTION: es_dia_festivo
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.es_dia_festivo(fecha_analizada date)
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    esta_dia_festivo integer := 0;
BEGIN
    IF public.es_dia_festivo_estatico(fecha_analizada) = 1 THEN 
        esta_dia_festivo := 1;
    END IF;
    
    IF public.fn_es_dia_festivo_variable_version_normal(fecha_analizada) = 1 THEN 
        esta_dia_festivo := 1;
    END IF;
    
    RETURN esta_dia_festivo;
END;
$$;