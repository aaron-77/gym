-- =============================================
-- PROCEDURE: sp_servicio_limpiar_pre_reservas_caducadas
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_servicio_limpiar_pre_reservas_caducadas()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM public.pre_reservas_de_horario
    WHERE current_timestamp > fecha_de_expiracion_de_la_reserva;
END;
$$;