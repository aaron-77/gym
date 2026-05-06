-- =============================================
-- PROCEDURE: sp_modificar_cita
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_modificar_cita(
    cita_id integer,
    nueva_fecha_hora timestamp,
    nueva_fecha_hora_fin timestamp
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.citas
    SET fecha_hora = nueva_fecha_hora, fecha_hora_fin = nueva_fecha_hora_fin
    WHERE cita_id = sp_modificar_cita.cita_id;
END;
$$;