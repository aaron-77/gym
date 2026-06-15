-- =============================================
-- FUNCTION: fn_encontrar_pre_reservas_caducadas
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_encontrar_pre_reservas_caducadas()
RETURNS TABLE (id_pre_reserva integer)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT pr.id_pre_reserva 
        FROM public.pre_reservas_de_horario pr
        WHERE current_timestamp NOT BETWEEN pr.fecha_inicio_de_la_reserva AND pr.fecha_de_expiracion_de_la_reserva
    );
END;
$$;