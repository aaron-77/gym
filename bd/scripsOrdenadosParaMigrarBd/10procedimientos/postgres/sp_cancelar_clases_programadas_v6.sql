-- =============================================
-- PROCEDURE: sp_cancelar_clases_programadas_v6
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_cancelar_clases_programadas_v6(
    p_id_clase_programada integer DEFAULT NULL,
    p_fecha_de_referencia date DEFAULT NULL,
    p_id_entrenador varchar DEFAULT NULL,
    p_id_clase integer DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_fecha_ref date;
    v_ids_clases_canceladas integer[];
    v_id_estado_disponible integer;
    v_id_estado_cancelada integer;
BEGIN
    -- Obtener IDs de estados
    SELECT id_estado_clase_programada INTO v_id_estado_disponible
    FROM public.estados_clases_programadas WHERE nombre_estado = 'Disponible';

    SELECT id_estado_clase_programada INTO v_id_estado_cancelada
    FROM public.estados_clases_programadas WHERE nombre_estado = 'Cancelada';

    -- Si no se proporciona fecha, usar hoy
    IF p_fecha_de_referencia IS NULL THEN
        v_fecha_ref := CURRENT_DATE;
    ELSE
        v_fecha_ref := p_fecha_de_referencia;
    END IF;

    -- Obtener clases a cancelar
    IF p_id_clase_programada IS NOT NULL THEN
        SELECT array_agg(id_programacion_clase) INTO v_ids_clases_canceladas
        FROM public.clases_programadas cp
        WHERE cp.fk_estado_clase_programada = v_id_estado_disponible
          AND cp.id_programacion_clase = p_id_clase_programada;
    ELSE
        IF v_fecha_ref = CURRENT_DATE AND p_id_entrenador IS NULL AND p_id_clase IS NULL THEN
            SELECT array_agg(cp.id_programacion_clase) INTO v_ids_clases_canceladas
            FROM public.clases_programadas cp
            INNER JOIN public.horarios_de_clases_programadas hdcp ON cp.id_programacion_clase = hdcp.fk_clase_programada
            WHERE cp.fecha_de_la_clase >= v_fecha_ref
              AND cp.fk_estado_clase_programada = v_id_estado_disponible;
        ELSE
            SELECT array_agg(cp.id_programacion_clase) INTO v_ids_clases_canceladas
            FROM public.clases_programadas cp
            INNER JOIN public.horarios_de_clases_programadas hdcp ON cp.id_programacion_clase = hdcp.fk_clase_programada
            WHERE ((p_fecha_de_referencia IS NULL OR cp.fecha_de_la_clase = p_fecha_de_referencia)
                AND (p_id_entrenador IS NULL OR cp.fk_entrenador = p_id_entrenador)
                AND (p_id_clase IS NULL OR cp.fk_clase = p_id_clase))
              AND cp.fk_estado_clase_programada = v_id_estado_disponible;
        END IF;
    END IF;

    -- Verificar si hay clases para cancelar
    IF v_ids_clases_canceladas IS NULL OR array_length(v_ids_clases_canceladas, 1) IS NULL THEN
        RAISE EXCEPTION 'No se encontraron clases activas para cancelar';
    END IF;

    -- Cancelar clases
    UPDATE public.clases_programadas
    SET fk_estado_clase_programada = v_id_estado_cancelada
    WHERE id_programacion_clase = ANY(v_ids_clases_canceladas);

    -- Retornar IDs cancelados
    SELECT unnest(v_ids_clases_canceladas) AS id_clase_cancelada;
END;
$$;