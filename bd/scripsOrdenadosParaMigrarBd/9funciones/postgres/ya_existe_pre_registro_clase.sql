-- =============================================
-- FUNCTION: ya_existe_pre_registro_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.ya_existe_pre_registro_clase(
    p_id_clase integer,
    p_id_entrendador character varying,
    p_fecha_reservada date,
    p_fks_horas_laborales integer[]
)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
    v_ya_existe boolean := false;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM public.pre_reservas_de_horario pr
        WHERE pr.fecha_de_la_clase = p_fecha_reservada
            AND pr.fk_hora_laboral = ANY(p_fks_horas_laborales)
            AND (p_id_clase IS NULL OR pr.id_clase = p_id_clase)
            AND (p_id_entrendador IS NULL OR pr.id_entrendador = p_id_entrendador)
            AND current_timestamp BETWEEN pr.fecha_inicio_de_la_reserva AND pr.fecha_de_expiracion_de_la_reserva
    ) INTO v_ya_existe;

    RETURN v_ya_existe;
END;
$$;