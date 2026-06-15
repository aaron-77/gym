-- =============================================
-- PROCEDURE: sp_obtener_medidas_del_usuario_por_tiempo
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_obtener_medidas_del_usuario_por_tiempo(
    p_user_id varchar,
    p_fecha_inicio timestamp,
    p_fecha_fin timestamp
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT medida_id, fecha_de_creacion, valor, fk_parametro
    FROM public.medidas
    WHERE fk_usuario = p_user_id
    AND fecha_de_creacion BETWEEN p_fecha_inicio AND p_fecha_fin
    ORDER BY fecha_de_creacion;
END;
$$;