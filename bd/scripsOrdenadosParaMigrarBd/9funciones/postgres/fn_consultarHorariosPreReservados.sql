-- =============================================
-- FUNCTION: fn_consultar_horarios_pre_reservados
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_consultar_horarios_pre_reservados(fecha_tentativa date)
RETURNS TABLE (
    id_pre_reserva integer,
    fecha_reservada date,
    id_hora integer,
    hora_inicio time,
    hora_fin time,
    id_usuario_que_reserva varchar,
    fecha_de_expiracion_de_la_reserva timestamp
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT 
            pr.id_pre_reserva,
            pr.fecha_reservada,
            hl.id_hora,
            hl.hora_inicio,
            hl.hora_fin,
            pr.id_usuario_que_reserva,
            pr.fecha_de_expiracion_de_la_reserva
        FROM public.pre_reservas_de_horario pr
        LEFT JOIN public.horas_laborales hl
            ON pr.fk_hora_laboral = hl.id_hora
        WHERE (
            pr.fecha_reservada >= fecha_tentativa 
            AND pr.fecha_reservada >= current_date
            AND current_timestamp BETWEEN pr.fecha_inicio_de_la_reserva AND pr.fecha_de_expiracion_de_la_reserva
        )   
    );
END;
$$;