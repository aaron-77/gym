-- =============================================
-- FUNCTION: fn_obtener_clases
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_obtener_clases()
RETURNS TABLE (clase_id integer, nombre_clase varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT c.clase_id, c.nombre_clase
        FROM public.clases c
        WHERE c.fk_estado_clase = (SELECT id_estado_clase FROM public.estados_de_clases WHERE nombre_estado = 'Activo')
    );
END;
$$;