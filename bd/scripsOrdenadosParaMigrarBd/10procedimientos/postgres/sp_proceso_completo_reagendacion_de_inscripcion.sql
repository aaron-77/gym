-- =============================================
-- PROCEDURE: sp_proceso_completo_reagendacion_de_inscripcion
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_proceso_completo_reagendacion_de_inscripcion(
    p_id_inscripcion integer,
    p_nueva_fecha timestamp
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Requires additional tables for rescheduling history
    UPDATE public.inscripciones_de_clases
    SET fk_estado_inscripcion = (SELECT id_estado_inscripcion FROM public.estados_inscripciones WHERE nombre_estado_inscripcion = 'Vigente')
    WHERE id_inscripcion = p_id_inscripcion;
END;
$$;