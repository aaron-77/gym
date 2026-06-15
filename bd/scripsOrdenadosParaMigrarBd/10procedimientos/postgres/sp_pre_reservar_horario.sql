-- =============================================
-- PROCEDURE: sp_pre_reservar_horario
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_pre_reservar_horario(
    p_fecha_inicio timestamp,
    p_fecha_expiracion timestamp,
    p_fk_hora_laboral integer,
    p_fecha_reservada date,
    p_fecha_de_la_clase date,
    p_id_entrenador varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.pre_reservas_de_horario (
        fecha_inicio_de_la_reserva, fecha_de_expiracion_de_la_reserva,
        fk_hora_laboral, fecha_reservada, fecha_de_la_clase, id_entrenador
    )
    VALUES (
        p_fecha_inicio, p_fecha_expiracion,
        p_fk_hora_laboral, p_fecha_reservada, p_fecha_de_la_clase, p_id_entrenador
    );
END;
$$;