-- =============================================
-- FUNCTION: obtener_caracteristicas_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_caracteristicas_de_clase(p_id_clase integer)
RETURNS TABLE (
    duracion_en_minutos integer,
    nivel_de_intensidad text,
    nivel_de_dificultad text,
    descripcion_de_la_clase text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT 
            c.duracion_en_minutos,
            ni.nombre_nivel_de_intensidad AS nivel_de_intensidad,
            nd.nombre_nivel_de_dificultad AS nivel_de_dificultad,
            c.descripcion AS descripcion_de_la_clase
        FROM 
            public.clases c
            INNER JOIN public.niveles_de_intensidad_de_clase ni ON c.fk_intensidad = ni.id_nivel_de_intensidad
            INNER JOIN public.niveles_de_dificultad_de_clase nd ON c.fk_dificultad = nd.id_nivel_de_dificultad_de_clase
        WHERE 
            c.clase_id = p_id_clase
    );
END;
$$;