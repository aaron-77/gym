-- =============================================
-- PROCEDURE: sp_obtener_medidas_por_mes_individual
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_obtener_medidas_por_mes_individual(
    p_user_id varchar,
    p_mes integer,
    p_anio integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT m.medida_id, m.fecha_de_creacion, pm.nombre, m.valor
    FROM public.medidas m
    LEFT JOIN public.parametros_de_medicion pm ON m.fk_parametro = pm.parametro_medicion_id
    WHERE m.fk_usuario = p_user_id
    AND EXTRACT(MONTH FROM m.fecha_de_creacion) = p_mes
    AND EXTRACT(YEAR FROM m.fecha_de_creacion) = p_anio
    ORDER BY m.fecha_de_creacion;
END;
$$;