-- =============================================
-- PROCEDURE: sp_registrar_clase_programada
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_registrar_clase_programada(
    p_fk_clase integer,
    p_cupo_maximo integer,
    p_fecha_de_la_clase date,
    p_fk_entrenador varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.clases_programadas (fk_clase, cupo_maximo, fk_estado_clase_programada, fecha_de_la_clase, fk_entrenador)
    VALUES (p_fk_clase, p_cupo_maximo, 1, p_fecha_de_la_clase, p_fk_entrenador);
END;
$$;