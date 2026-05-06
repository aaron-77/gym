-- =============================================
-- PROCEDURE: sp_obtener_meta_de_parametro
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_obtener_meta_de_parametro(
    p_user_id varchar,
    p_fk_parametro integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT m.meta_id, m.valor_objetivo, m.fecha_de_inicio_de_la_meta, m.fecha_limite
    FROM public.metas m
    WHERE m.fk_usuario = p_user_id AND m.fk_parametro = p_fk_parametro
    AND m.fecha_limite >= current_timestamp;
END;
$$;