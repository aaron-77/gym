-- =============================================
-- PROCEDURE: sp_consultar_ejercicios
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_consultar_ejercicios()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT ejercicio_id, nombre_ejercicio, tipo_ejercicio, descripcion
    FROM public.ejercicios;
END;
$$;