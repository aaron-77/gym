-- =============================================
-- PROCEDURE: sp_obtener_estructura_clase
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_obtener_estructura_clase(p_id_clase integer)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT es.id_bloque, es.fk_clase, es.numero_consecutivo_del_bloque,
           es.titulo_bloque, es.duracion_menor_en_minutos, es.duracion_mayor_en_minutos,
           es.descripcion_bloque
    FROM public.estructura_de_clase es
    WHERE es.fk_clase = p_id_clase
    ORDER BY es.numero_consecutivo_del_bloque;
END;
$$;