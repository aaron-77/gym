-- =============================================
-- FUNCTION: obtener_ejercicios_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_ejercicios_de_clase(p_id_clase integer)
RETURNS TABLE (
    url_icono text,
    nombre_ejercicio text,
    descripcion_ejercicio text,
    url_imagen text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT 
            i.url_publica AS url_icono,
            e.nombre_ejercicio,
            e.descripcion AS descripcion_ejercicio,
            ife.url_publica AS url_imagen
        FROM 
            public.rutinas r 
            INNER JOIN public.rutina_ejercicios re ON re.rutina_id = r.rutina_id
            INNER JOIN public.ejercicios e ON e.ejercicio_id = re.ejercicio_id
            LEFT JOIN public.icons_for_parameters i ON e.fk_icon = i.icon_id
            LEFT JOIN public.images_for_exercises ife ON ife.fk_ejercicio = e.ejercicio_id 
        WHERE 
            r.fk_clase = p_id_clase
    );
END;
$$;