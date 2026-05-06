-- =============================================
-- FUNCTION: obtener_consejos_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_consejos_de_clase(p_id_clase integer)
RETURNS TABLE (
    fk_clase integer,
    introduccion_de_consejo text,
    consejos jsonb
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT DISTINCT 
            c.fk_clase,
            c.introduccion_de_consejo, 
            (
                SELECT json_agg(json_build_object('consejo', elem))
                FROM jsonb_array_elements_text(
                    jsonb_build_array(
                        string_to_array(c.consejos, ',')
                    )
                ) AS elem
            ) AS consejos
        FROM 
            public.consejos_para_las_clases c
        WHERE 
            c.fk_clase = p_id_clase
    );
END;
$$;