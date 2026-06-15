-- =============================================
-- FUNCTION: fn_obtener_estados_clases_programadas
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_obtener_estados_clases_programadas()
RETURNS TABLE (
    id_estado_clase_programada integer,
    nombres_estado text,
    fecha_creacion timestamp,
    fecha_modificacion timestamp
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT 
            ecp.id_estado_clase_programada,
            ecp.nombres_estado,
            ecp.fecha_creacion,
            ecp.fecha_modificacion
        FROM public.estados_clases_programadas ecp
    );
END;
$$;