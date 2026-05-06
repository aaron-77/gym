-- =============================================
-- PROCEDURE: sp_es_el_mismo_tipo_de_clase
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_es_el_mismo_tipo_de_clase(clase_id1 integer, clase_id2 integer)
LANGUAGE plpgsql
AS $$
DECLARE
    resultado boolean := false;
BEGIN
    IF clase_id1 = clase_id2 THEN
        resultado := true;
    END IF;
    -- Return as result (can be called as function)
END;
$$;