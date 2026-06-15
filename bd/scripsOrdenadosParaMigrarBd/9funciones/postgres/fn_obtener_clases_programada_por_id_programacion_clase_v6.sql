-- =============================================
-- FUNCTION: fn_obtener_clases_programada_por_id_programacion_clase_v6
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_obtener_clases_programada_por_id_programacion_clase_v6(p_id_programacion_clase integer)
RETURNS TABLE (
    id_clase_programada integer,
    fk_clase integer,
    cupo_maximo integer,
    cupo_disponible integer,
    fecha_de_la_clase date,
    id_hora integer,
    hora_inicio time,
    hora_fin time,
    label_horario text,
    fk_entrenador varchar,
    nombre_entrenador text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        cp.id_programacion_clase AS id_clase_programada,
        cp.fk_clase,
        cp.cupo_maximo,
        public.fn_cupo_disponible_clase_programada(cp.id_programacion_clase) AS cupo_disponible,
        cp.fecha_de_la_clase,
        hl.id_hora,
        hl.hora_inicio,
        hl.hora_fin,
        CONCAT(TO_CHAR(hl.hora_inicio, 'HH24:MI'), ' - ', TO_CHAR(hl.hora_fin, 'HH24:MI')) AS label_horario,
        cp.fk_entrenador,
        CONCAT(u.nombre_completo, ' ', u.apellido) AS nombre_entrenador
    FROM public.clases_programadas cp
    INNER JOIN public.horarios_de_clases_programadas hcp
        ON cp.id_programacion_clase = hcp.fk_clase_programada
    INNER JOIN public.horas_laborales hl
        ON hcp.fk_horario_laboral = hl.id_hora
    LEFT JOIN public.asp_net_users u
        ON cp.fk_entrenador = u.id
    WHERE cp.id_programacion_clase = p_id_programacion_clase;
END;
$$;