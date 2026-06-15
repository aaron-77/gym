-- =============================================
-- FUNCTION: obtener_equipamiento_recomendado
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_equipamiento_recomendado(p_id_clase integer)
RETURNS TABLE (
    equipo_id integer,
    nombre_equipo text,
    descripcion text,
    url_icono text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT DISTINCT
            e.equipo_id,
            e.nombre_equipo,
            e.descripcion,
            i.url_publica AS url_icono
        FROM 
            public.rutinas r
            INNER JOIN public.rutina_ejercicios re ON r.rutina_id = re.rutina_id
            INNER JOIN public.ejercicios ej ON re.ejercicio_id = ej.ejercicio_id
            INNER JOIN public.ejercicio_equipos ee ON ee.ejercicio_id = ej.ejercicio_id
            INNER JOIN public.equipos e ON ee.equipo_id = e.equipo_id
            LEFT JOIN public.icons_for_parameters i ON e.fk_icon = i.icon_id
        WHERE 
            r.fk_clase = p_id_clase
    );
END;
$$;