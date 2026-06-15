-- =============================================
-- PROCEDURE: sp_obtener_metas_de_medidas
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_obtener_metas_de_medidas(p_user_id varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT m.meta_id, m.valor_objetivo, m.fecha_de_inicio_de_la_meta, m.fecha_limite, pm.nombre
    FROM public.metas m
    LEFT JOIN public.parametros_de_medicion pm ON m.fk_parametro = pm.parametro_medicion_id
    WHERE m.fk_usuario = p_user_id
    ORDER BY m.fecha_limite;
END;
$$;