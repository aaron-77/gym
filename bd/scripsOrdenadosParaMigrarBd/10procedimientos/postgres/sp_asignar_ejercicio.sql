-- =============================================
-- PROCEDURE: sp_asignar_ejercicio
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_asignar_ejercicio(
    p_rutina_id integer,
    p_ejercicio_id integer,
    p_sets integer,
    p_repeticiones integer,
    p_peso decimal
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.rutina_ejercicios (rutina_id, ejercicio_id, sets, repeticiones, peso)
    VALUES (p_rutina_id, p_ejercicio_id, p_sets, p_repeticiones, p_peso);
END;
$$;