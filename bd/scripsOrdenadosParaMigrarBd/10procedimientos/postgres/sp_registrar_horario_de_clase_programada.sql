-- =============================================
-- PROCEDURE: sp_registrar_horario_de_clase_programada
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_registrar_horario_de_clase_programada(
    p_fk_clase_programada integer,
    p_fk_horario_laboral integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.horarios_de_clases_programadas (fk_clase_programada, fk_horario_laboral)
    VALUES (p_fk_clase_programada, p_fk_horario_laboral);
END;
$$;