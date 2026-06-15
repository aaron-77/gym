-- =============================================
-- PROCEDURE: sp_registrar_cita
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_registrar_cita(
    p_fecha_hora timestamp,
    p_tipo_cita varchar,
    p_fecha_hora_fin timestamp,
    p_entrenador_id varchar,
    p_user_id varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.citas (fecha_hora, tipo_cita, fecha_hora_fin, entrenador_id, user_id)
    VALUES (p_fecha_hora, p_tipo_cita, p_fecha_hora_fin, p_entrenador_id, p_user_id);
END;
$$;