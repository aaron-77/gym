-- =============================================
-- PROCEDURE: sp_registrar_error
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_registrar_error(
    p_procedimiento varchar,
    p_mensaje varchar,
    p_severidad integer,
    p_estado integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.log_errores (procedimiento, mensaje, severidad, estado)
    VALUES (p_procedimiento, p_mensaje, p_severidad, p_estado);
END;
$$;