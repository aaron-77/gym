-- =============================================
-- PROCEDURE: sp_obtener_metas_actuales_del_cliente_por_parametro
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_obtener_metas_actuales_del_cliente_por_parametro(
    p_user_id varchar,
    p_parametro integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT meta_id, valor_objetivo, fecha_de_inicio_de_la_meta, fecha_limite
    FROM public.metas
    WHERE fk_usuario = p_user_id AND fk_parametro = p_parametro
    AND current_timestamp BETWEEN fecha_de_inicio_de_la_meta AND fecha_limite;
END;
$$;