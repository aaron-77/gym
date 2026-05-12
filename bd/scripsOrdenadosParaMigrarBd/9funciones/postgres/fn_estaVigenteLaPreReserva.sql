-- =============================================
-- FUNCTION: fn_esta_vigente_la_pre_reserva
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_esta_vigente_la_pre_reserva(id_pre_reserva integer)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
    esta_vigente boolean := true;
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM public.pre_reservas_de_horario prdh 
        WHERE prdh.id_pre_reserva = id_pre_reserva 
        AND current_timestamp BETWEEN prdh.fecha_inicio_de_la_reserva AND prdh.fecha_de_expiracion_de_la_reserva
    ) THEN 
        esta_vigente := false;
    END IF;
    RETURN esta_vigente;
END;
$$;