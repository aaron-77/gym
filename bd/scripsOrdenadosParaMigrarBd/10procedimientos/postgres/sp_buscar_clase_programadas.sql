-- =============================================
-- PROCEDURE: sp_buscar_clase_programadas
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_buscar_clase_programadas(fecha date)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT cp.id_programacion_clase, c.nombre_clase, cp.fecha_de_la_clase, cp.cupo_maximo
    FROM public.clases_programadas cp
    INNER JOIN public.clases c ON cp.fk_clase = c.clase_id
    WHERE cp.fecha_de_la_clase = fecha;
END;
$$;