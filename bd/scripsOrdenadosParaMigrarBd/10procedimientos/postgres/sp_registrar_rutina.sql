-- =============================================
-- PROCEDURE: sp_registrar_rutina
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_registrar_rutina(
    p_fk_clase integer,
    p_user_id varchar,
    p_observaciones varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.rutinas (fk_clase, user_id, observaciones)
    VALUES (p_fk_clase, p_user_id, p_observaciones);
END;
$$;