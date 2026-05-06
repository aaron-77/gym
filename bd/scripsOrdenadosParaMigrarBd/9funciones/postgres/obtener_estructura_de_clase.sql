-- =============================================
-- FUNCTION: obtener_estructura_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_estructura_de_clase(p_id_clase integer)
RETURNS TABLE (
    id_bloque integer,
    nombre_de_la_clase text,
    numero_consecutivo_del_bloque integer,
    duracion_menor_en_minutos integer,
    duracion_mayor_en_minutos integer,
    titulo_bloque text,
    descripcion_bloque text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT 
            ec.id_bloque,
            c.nombre_clase AS nombre_de_la_clase,
            ec.numero_consecutivo_del_bloque,
            ec.duracion_menor_en_minutos,
            ec.duracion_mayor_en_minutos,
            ec.titulo_bloque,
            ec.descripcion_bloque
        FROM 
            public.estructura_de_clase ec
            INNER JOIN public.clases c ON ec.fk_clase = c.clase_id
        WHERE 
            ec.fk_clase = p_id_clase
    );
END;
$$;