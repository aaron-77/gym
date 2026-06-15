-- =============================================
-- PROCEDURE: sp_obtener_horarios_disponibles
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_obtener_horarios_disponibles(fecha date)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT hl.id_hora, hl.hora_inicio, hl.hora_fin
    FROM public.horas_laborales hl
    WHERE NOT EXISTS (
        SELECT 1 FROM public.horarios_de_clases_programadas hcp
        INNER JOIN public.clases_programadas cp ON hcp.fk_clase_programada = cp.id_programacion_clase
        WHERE cp.fecha_de_la_clase = fecha AND hcp.fk_horario_laboral = hl.id_hora
    );
END;
$$;