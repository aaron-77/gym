-- =============================================
-- FUNCTION: obtener_imagenes_de_la_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_imagenes_de_la_clase(p_id_clase integer)
RETURNS TABLE (
    url_para_banner text,
    url_para_descripcion_de_clase text,
    url_para_bloque_consejos text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT 
            i.url_para_banner,
            i.url_para_descripcion_de_clase,
            i.url_para_bloque_consejos 
        FROM public.images_for_clases i
        WHERE i.fk_clase = p_id_clase
    );
END;
$$;