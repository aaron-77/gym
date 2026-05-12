-- =============================================
-- PROCEDURE: sp_eliminar_cita
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_eliminar_cita(cita_id integer)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM public.citas WHERE cita_id = sp_eliminar_cita.cita_id;
END;
$$;