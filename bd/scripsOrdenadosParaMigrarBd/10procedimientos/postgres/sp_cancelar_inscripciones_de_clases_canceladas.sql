-- =============================================
-- PROCEDURE: sp_cancelar_inscripciones_de_clases_canceladas
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_cancelar_inscripciones_de_clases_canceladas()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.inscripciones_de_clases ic
    SET fk_estado_inscripcion = (SELECT id_estado_inscripcion FROM public.estados_inscripciones WHERE nombre_estado_inscripcion = 'Cancelada')
    FROM public.clases_programadas cp
    WHERE ic.fk_programacion_clase = cp.id_programacion_clase
    AND cp.fk_estado_clase_programada = (SELECT id_estado_clase_programada FROM public.estados_clases_programadas WHERE nombre_estado = 'Cancelada');
END;
$$;