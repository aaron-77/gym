-- =============================================
-- FUNCTION: obtener_detalle_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_detalle_de_clase(p_id_clase integer)
RETURNS TABLE (
    clase_id integer,
    nombre_clase text,
    subtitulo_clase text,
    duracion integer,
    nivel_de_intensidad text,
    nivel_de_dificultad text,
    descripcion_de_la_clase text,
    imagenes_de_clase jsonb,
    beneficios_de_la_clase jsonb,
    estructura_de_la_clase jsonb,
    ejercicios_de_clase jsonb,
    consejos jsonb,
    equipamiento_recomendado jsonb,
    horarios_programados jsonb
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT 
            c.clase_id,
            c.nombre_clase,
            c.subtitulo_clase,
            c.duracion_en_minutos AS duracion,
            ni.nombre_nivel_de_intensidad AS nivel_de_intensidad,
            nd.nombre_nivel_de_dificultad AS nivel_de_dificultad,
            c.descripcion AS descripcion_de_la_clase,
            (SELECT COALESCE(json_agg(json_build_object(
                'url_para_banner', ic.url_para_banner,
                'url_para_descripcion_de_clase', ic.url_para_descripcion_de_clase,
                'url_para_bloque_consejos', ic.url_para_bloque_consejos
           )), '[]'::jsonb) FROM public.obtener_imagenes_de_la_clase(p_id_clase) ic) AS imagenes_de_clase,
            (SELECT COALESCE(json_agg(json_build_object(
                'beneficio', bc.beneficio,
                'descripcion_beneficio', bc.descripcion_beneficio,
                'url_publica', bc.url_publica
            )), '[]'::jsonb) FROM public.obtener_beneficios_de_clase(p_id_clase) bc) AS beneficios_de_la_clase,
            (SELECT COALESCE(json_agg(ec.*), '[]'::jsonb) FROM public.obtener_estructura_de_clase(p_id_clase) ec) AS estructura_de_la_clase,
            (SELECT COALESCE(json_agg(ejc.*), '[]'::jsonb) FROM public.obtener_ejercicios_de_clase(p_id_clase) ejc) AS ejercicios_de_clase,
            (SELECT COALESCE(json_agg(cc.*), '[]'::jsonb) FROM public.obtener_consejos_de_clase(p_id_clase) cc) AS consejos,
            (SELECT COALESCE(json_agg(er.*), '[]'::jsonb) FROM public.obtener_equipamiento_recomendado(p_id_clase) er) AS equipamiento_recomendado,
            (SELECT COALESCE(json_agg(hp.*), '[]'::jsonb) FROM public.obtener_clases_programadas(p_id_clase) hp) AS horarios_programados
        FROM 
            public.clases c
            INNER JOIN public.niveles_de_intensidad_de_clase ni ON c.fk_intensidad = ni.id_nivel_de_intensidad
            INNER JOIN public.niveles_de_dificultad_de_clase nd ON c.fk_dificultad = nd.id_nivel_de_dificultad_de_clase
        WHERE 
            c.clase_id = p_id_clase
    );
END;
$$;