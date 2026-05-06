-- =============================================
-- PROCEDURE: sp_obtener_medidas_por_meses_especificos
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_obtener_medidas_por_meses_especificos(
    p_user_id varchar,
    p_meses integer[],
    p_anio integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT medida_id, fecha_de_creacion, valor, fk_parametro
    FROM public.medidas
    WHERE fk_usuario = p_user_id
    AND EXTRACT(MONTH FROM fecha_de_creacion) = ANY(p_meses)
    AND EXTRACT(YEAR FROM fecha_de_creacion) = p_anio
    ORDER BY fecha_de_creacion;
END;
$$;