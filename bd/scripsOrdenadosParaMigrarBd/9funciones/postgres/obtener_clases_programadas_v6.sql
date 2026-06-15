-- =============================================
-- FUNCTION: obtener_clases_programadas_v6
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_clases_programadas_v6(p_id_clase integer)
RETURNS TABLE (
    id_programacion_clase integer,
    nombre_clase varchar,
    dia_de_la_semana text,
    hora_inicio time,
    hora_fin time,
    nombre_entrenador text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        cp.id_programacion_clase,
        c.nombre_clase,
        TO_CHAR(cp.fecha_de_la_clase, 'Day') AS dia_de_la_semana,
        hl.hora_inicio,
        hl.hora_fin,
        CONCAT(u.nombre_completo, ' ', u.apellido) AS nombre_entrenador
    FROM public.clases_programadas cp
        INNER JOIN public.clases c ON cp.fk_clase = c.clase_id
        LEFT JOIN public.asp_net_users u ON cp.fk_entrenador = u.id
        INNER JOIN public.horarios_de_clases_programadas hcp ON cp.id_programacion_clase = hcp.fk_clase_programada
        INNER JOIN public.horas_laborales hl ON hcp.fk_horario_laboral = hl.id_hora
    WHERE cp.fk_clase = p_id_clase
        AND EXTRACT(YEAR FROM cp.fecha_de_la_clase) = EXTRACT(YEAR FROM CURRENT_DATE)
        AND cp.fk_estado_clase_programada = (SELECT id_estado_clase_programada FROM public.estados_clases_programadas WHERE nombre_estado = 'Disponible');
END;
$$;