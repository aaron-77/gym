-- =============================================
-- FUNCTION: ya_existe_clase_programada_v6
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.ya_existe_clase_programada_v6(
    p_fk_clase integer,
    p_fk_entrenador varchar,
    p_fecha date,
    p_fks_horas_laborales integer[]
)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
    v_ya_existe boolean := false;
    v_id_estado_disponible integer;
BEGIN
    -- Obtener ID del estado disponible
    SELECT id_estado_clase_programada INTO v_id_estado_disponible
    FROM public.estados_clases_programadas
    WHERE nombre_estado = 'Disponible';

    IF EXISTS (
        SELECT 1
        FROM public.clases_programadas cp
        INNER JOIN public.horarios_de_clases_programadas hcp
            ON cp.id_programacion_clase = hcp.fk_clase_programada
            AND hcp.fk_estado_horario_clase = 1
            AND hcp.fk_horario_laboral = ANY(p_fks_horas_laborales)
        WHERE cp.fecha_de_la_clase = p_fecha
          AND cp.fk_clase = p_fk_clase
          AND (p_fk_entrenador IS NULL OR cp.fk_entrenador = p_fk_entrenador)
          AND cp.fk_estado_clase_programada = v_id_estado_disponible
    ) THEN
        v_ya_existe := true;
    END IF;

    RETURN v_ya_existe;
END;
$$;