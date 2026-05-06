-- =============================================
-- PROCEDURE: sp_obtener_ultimas_medidas_del_usuario
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_obtener_ultimas_medidas_del_usuario(p_user_id varchar, limite integer DEFAULT 10)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT m.medida_id, m.fecha_de_creacion, pm.nombre, m.valor
    FROM public.medidas m
    LEFT JOIN public.parametros_de_medicion pm ON m.fk_parametro = pm.parametro_medicion_id
    WHERE m.fk_usuario = p_user_id
    ORDER BY m.fecha_de_creacion DESC
    LIMIT limite;
END;
$$;