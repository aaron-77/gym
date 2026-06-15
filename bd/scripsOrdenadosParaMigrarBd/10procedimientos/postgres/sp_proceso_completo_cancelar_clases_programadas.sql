-- =============================================
-- PROCEDURE: sp_proceso_completo_cancelar_clases_programadas
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_proceso_completo_cancelar_clases_programadas(id_programacion_clase integer)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.clases_programadas
    SET fk_estado_clase_programada = (SELECT id_estado_clase_programada FROM public.estados_clases_programadas WHERE nombre_estado = 'Cancelada')
    WHERE id_programacion_clase = id_programacion_clase;
END;
$$;