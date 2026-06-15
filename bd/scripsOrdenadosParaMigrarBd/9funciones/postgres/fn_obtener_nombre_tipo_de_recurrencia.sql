-- =============================================
-- FUNCTION: fn_obtener_nombre_tipo_de_recurrencia
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_obtener_nombre_tipo_de_recurrencia(p_id_tipo_de_recurrencia integer)
RETURNS character varying
LANGUAGE plpgsql
AS $$
DECLARE
    v_nombre_tipo_de_recurrencia character varying;
BEGIN
    SELECT nombre_tipo_de_recurrencia
    INTO v_nombre_tipo_de_recurrencia
    FROM public.tipos_de_recurrencia_de_dias_festivos
    WHERE id_tipo_de_recurrencia_de_dia_festivo = p_id_tipo_de_recurrencia;
    
    RETURN v_nombre_tipo_de_recurrencia;
END;
$$;