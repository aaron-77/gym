-- =============================================
-- PROCEDURE: sp_obtener_entrenadores_disponibles
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_obtener_entrenadores_disponibles(fecha date)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT DISTINCT u.id, u.nombre_completo, u.email
    FROM public.asp_net_users u
    INNER JOIN public.clases_programadas cp ON cp.fk_entrenador = u.id
    WHERE cp.fecha_de_la_clase = fecha;
END;
$$;