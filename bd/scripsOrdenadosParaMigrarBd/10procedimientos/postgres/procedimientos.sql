-- =============================================
-- PROCEDURES: Multiples procedimientos conversionados
-- Convertidos a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

-- sp_consultar_ejercicios
CREATE OR REPLACE PROCEDURE public.sp_consultar_ejercicios()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT ejercicio_id, nombre_ejercicio, tipo_ejercicio, descripcion
    FROM public.ejercicios;
END;
$$;

-- sp_consultar_rutinas_de_usuario
CREATE OR REPLACE PROCEDURE public.sp_consultar_rutinas_de_usuario(user_id varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT r.rutina_id, r.fecha_creacion, r.observaciones, r.fk_clase
    FROM public.rutinas r
    WHERE r.user_id = user_id;
END;
$$;

-- sp_consultar_usuarios
CREATE OR REPLACE PROCEDURE public.sp_consultar_usuarios(estado varchar DEFAULT NULL)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT usuario_id, nombre, apellido, email, telefono, fecha_nacimiento, fecha_registro
    FROM public.usuarios
    WHERE estado = sp_consultar_usuarios.estado OR sp_consultar_usuarios.estado IS NULL;
END;
$$;

-- sp_consultar_usuarios_proximos_a_cita
CREATE OR REPLACE PROCEDURE public.sp_consultar_usuarios_proximos_a_cita()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT DISTINCT u.id, u.nombre_completo, u.email, u.telefono
    FROM public.asp_net_users u
    INNER JOIN public.citas c ON c.user_id = u.id
    WHERE c.fecha_hora >= current_timestamp
    ORDER BY c.fecha_hora;
END;
$$;

-- sp_buscar_clase_programadas
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

-- sp_asignar_ejercicio
CREATE OR REPLACE PROCEDURE public.sp_asignar_ejercicio(
    p_rutina_id integer,
    p_ejercicio_id integer,
    p_sets integer,
    p_repeticiones integer,
    p_peso decimal
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.rutina_ejercicios (rutina_id, ejercicio_id, sets, repeticiones, peso)
    VALUES (p_rutina_id, p_ejercicio_id, p_sets, p_repeticiones, p_peso);
END;
$$;

-- sp_cancelar_inscripcion_a_clase
CREATE OR REPLACE PROCEDURE public.sp_cancelar_inscripcion_a_clase(id_inscripcion integer)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.inscripciones_de_clases
    SET fk_estado_inscripcion = (SELECT id_estado_inscripcion FROM public.estados_inscripciones WHERE nombre_estado_inscripcion = 'Cancelada')
    WHERE id_inscripcion = sp_cancelar_inscripcion_a_clase.id_inscripcion;
END;
$$;

-- sp_eliminar_cita
CREATE OR REPLACE PROCEDURE public.sp_eliminar_cita(cita_id integer)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM public.citas WHERE cita_id = sp_eliminar_cita.cita_id;
END;
$$;

-- sp_modificar_cita
CREATE OR REPLACE PROCEDURE public.sp_modificar_cita(
    cita_id integer,
    nueva_fecha_hora timestamp,
    nueva_fecha_hora_fin timestamp
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.citas
    SET fecha_hora = nueva_fecha_hora, fecha_hora_fin = nueva_fecha_hora_fin
    WHERE cita_id = sp_modificar_cita.cita_id;
END;
$$;

-- sp_obtener_citas_agendadas_por_usuario
CREATE OR REPLACE PROCEDURE public.sp_obtener_citas_agendadas_por_usuario(p_user_id varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT c.cita_id, c.fecha_hora, c.fecha_hora_fin, c.tipo_cita, c.estado
    FROM public.citas c
    WHERE c.user_id = p_user_id AND c.fecha_hora >= current_timestamp
    ORDER BY c.fecha_hora;
END;
$$;

-- sp_obtener_ejercicios_y_parametros_del_cliente
CREATE OR REPLACE PROCEDURE public.sp_obtener_ejercicios_y_parametros_del_cliente(p_user_id varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT DISTINCT e.ejercicio_id, e.nombre_ejercicio, pm.nombre
    FROM public.ejercicios e
    LEFT JOIN public.ejercicios_parametros_de_medicion epm ON e.ejercicio_id = epm.fk_ejercicio
    LEFT JOIN public.parametros_de_medicion pm ON epm.fk_parametro = pm.parametro_medicion_id;
END;
$$;

-- sp_obtener_entrenadores_disponibles
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

-- sp_obtener_horarios_disponibles
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

-- sp_obtener_medidas_de_usuario
CREATE OR REPLACE PROCEDURE public.sp_obtener_medidas_de_usuario(p_user_id varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT m.medida_id, m.fecha_de_creacion, pm.nombre, m.valor
    FROM public.medidas m
    LEFT JOIN public.parametros_de_medicion pm ON m.fk_parametro = pm.parametro_medicion_id
    WHERE m.fk_usuario = p_user_id
    ORDER BY m.fecha_de_creacion DESC;
END;
$$;

-- sp_obtener_metas_de_medidas
CREATE OR REPLACE PROCEDURE public.sp_obtener_metas_de_medidas(p_user_id varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT m.meta_id, m.valor_objetivo, m.fecha_de_inicio_de_la_meta, m.fecha_limite, pm.nombre
    FROM public.metas m
    LEFT JOIN public.parametros_de_medicion pm ON m.fk_parametro = pm.parametro_medicion_id
    WHERE m.fk_usuario = p_user_id
    ORDER BY m.fecha_limite;
END;
$$;

-- sp_eliminar_pre_reservas_caducadas
CREATE OR REPLACE PROCEDURE public.sp_eliminar_pre_reservas_caducadas()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM public.pre_reservas_de_horario
    WHERE current_timestamp > fecha_de_expiracion_de_la_reserva;
END;
$$;

-- sp_registrar_cita
CREATE OR REPLACE PROCEDURE public.sp_registrar_cita(
    p_fecha_hora timestamp,
    p_tipo_cita varchar,
    p_fecha_hora_fin timestamp,
    p_entrenador_id varchar,
    p_user_id varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.citas (fecha_hora, tipo_cita, fecha_hora_fin, entrenador_id, user_id)
    VALUES (p_fecha_hora, p_tipo_cita, p_fecha_hora_fin, p_entrenador_id, p_user_id);
END;
$$;

-- sp_registrar_clase_programada
CREATE OR REPLACE PROCEDURE public.sp_registrar_clase_programada(
    p_fk_clase integer,
    p_cupo_maximo integer,
    p_fecha_de_la_clase date,
    p_fk_entrenador varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.clases_programadas (fk_clase, cupo_maximo, fk_estado_clase_programada, fecha_de_la_clase, fk_entrenador)
    VALUES (p_fk_clase, p_cupo_maximo, 1, p_fecha_de_la_clase, p_fk_entrenador);
END;
$$;

-- sp_registrar_rutina
CREATE OR REPLACE PROCEDURE public.sp_registrar_rutina(
    p_fk_clase integer,
    p_user_id varchar,
    p_observaciones varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.rutinas (fk_clase, user_id, observaciones)
    VALUES (p_fk_clase, p_user_id, p_observaciones);
END;
$$;

-- sp_servicio_limpiar_pre_reservas_caducadas
CREATE OR REPLACE PROCEDURE public.sp_servicio_limpiar_pre_reservas_caducadas()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM public.pre_reservas_de_horario
    WHERE current_timestamp > fecha_de_expiracion_de_la_reserva;
END;
$$;

-- sp_pre_reservar_horario
CREATE OR REPLACE PROCEDURE public.sp_pre_reservar_horario(
    p_fecha_inicio timestamp,
    p_fecha_expiracion timestamp,
    p_fk_hora_laboral integer,
    p_fecha_reservada date,
    p_fecha_de_la_clase date,
    p_id_entrenador varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.pre_reservas_de_horario (
        fecha_inicio_de_la_reserva, fecha_de_expiracion_de_la_reserva,
        fk_hora_laboral, fecha_reservada, fecha_de_la_clase, id_entrenador
    )
    VALUES (
        p_fecha_inicio, p_fecha_expiracion,
        p_fk_hora_laboral, p_fecha_reservada, p_fecha_de_la_clase, p_id_entrenador
    );
END;
$$;

-- sp_registrar_horario_de_clase_programada
CREATE OR REPLACE PROCEDURE public.sp_registrar_horario_de_clase_programada(
    p_fk_clase_programada integer,
    p_fk_horario_laboral integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.horarios_de_clases_programadas (fk_clase_programada, fk_horario_laboral)
    VALUES (p_fk_clase_programada, p_fk_horario_laboral);
END;
$$;

-- sp_registrar_inscripcion_a_clase
CREATE OR REPLACE PROCEDURE public.sp_registrar_inscripcion_a_clase(
    p_fk_programacion_clase integer,
    p_fk_cliente varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.inscripciones_de_clases (fk_programacion_clase, fk_estado_inscripcion, fk_cliente)
    VALUES (p_fk_programacion_clase, 1, p_fk_cliente);
END;
$$;

-- sp_proceso_completo_cancelar_clases_programadas
CREATE OR REPLACE PROCEDURE public.sp_proceso_completo_cancelar_clases_programadas(id_programacion_clase integer)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.clases_programadas
    SET fk_estado_clase_programada = (SELECT id_estado_clase_programada FROM public.estados_clases_programadas WHERE nombre_estado = 'Cancelada')
    WHERE id_programacion_clase = id_programacion_clase;
END;
$$;

-- sp_cancelar_inscripciones_de_clases_canceladas
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

-- sp_obtener_usuarios_con_citas_agendadas
CREATE OR REPLACE PROCEDURE public.sp_obtener_usuarios_con_citas_agendadas()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT DISTINCT u.id, u.nombre_completo, COUNT(c.cita_id) as total_citas
    FROM public.asp_net_users u
    INNER JOIN public.citas c ON c.user_id = u.id
    WHERE c.fecha_hora >= current_timestamp
    GROUP BY u.id, u.nombre_completo;
END;
$$;

-- sp_es_el_mismo_tipo_de_clase
CREATE OR REPLACE PROCEDURE public.sp_es_el_mismo_tipo_de_clase(clase_id1 integer, clase_id2 integer)
LANGUAGE plpgsql
AS $$
DECLARE
    resultado boolean := false;
BEGIN
    IF clase_id1 = clase_id2 THEN
        resultado := true;
    END IF;
    -- Return as result (can be called as function)
END;
$$;

-- sp_renombrar_diagrama (no aplica en PostgreSQL)
CREATE OR REPLACE PROCEDURE public.sp_renombrar_diagrama(nombre_viejo varchar, nombre_nuevo varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    -- PostgreSQL no tiene diagrama de base de datos como SQL Server
    -- Esta operación no es necesaria
END;
$$;

-- sp_registrar_error (logging)
CREATE OR REPLACE PROCEDURE public.sp_registrar_error(
    p_procedimiento varchar,
    p_mensaje varchar,
    p_severidad integer,
    p_estado integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.log_errores (procedimiento, mensaje, severidad, estado)
    VALUES (p_procedimiento, p_mensaje, p_severidad, p_estado);
END;
$$;

-- sp_obtener_medidas_por_mes_individual
CREATE OR REPLACE PROCEDURE public.sp_obtener_medidas_por_mes_individual(
    p_user_id varchar,
    p_mes integer,
    p_anio integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT m.medida_id, m.fecha_de_creacion, pm.nombre, m.valor
    FROM public.medidas m
    LEFT JOIN public.parametros_de_medicion pm ON m.fk_parametro = pm.parametro_medicion_id
    WHERE m.fk_usuario = p_user_id
    AND EXTRACT(MONTH FROM m.fecha_de_creacion) = p_mes
    AND EXTRACT(YEAR FROM m.fecha_de_creacion) = p_anio
    ORDER BY m.fecha_de_creacion;
END;
$$;

-- sp_obtener_medidas_por_rango_de_meses
CREATE OR REPLACE PROCEDURE public.sp_obtener_medidas_por_rango_de_meses(
    p_user_id varchar,
    p_mes_inicio integer,
    p_mes_fin integer,
    p_anio integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT m.medida_id, m.fecha_de_creacion, pm.nombre, m.valor
    FROM public.medidas m
    LEFT JOIN public.parametros_de_medicion pm ON m.fk_parametro = pm.parametro_medicion_id
    WHERE m.fk_usuario = p_user_id
    AND EXTRACT(MONTH FROM m.fecha_de_creacion) BETWEEN p_mes_inicio AND p_mes_fin
    AND EXTRACT(YEAR FROM m.fecha_de_creacion) = p_anio
    ORDER BY m.fecha_de_creacion;
END;
$$;

-- sp_obtener_ultimas_medidas_del_usuario
CREATE OR REPLACE PROCEDURE public.sp_obtener_ultimas_medidas_del_usuario(p_user_id varchar, limite integer DEFAULT 10)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT m.medida_id, m.fecha_de_creacion, pm.nombre, m.valor
    FROM public.medidas m
    LEFT JOIN public.parametros_de_medicion pm ON m.fk_parametro = pm.parametro_medicion_id
    WHERE m.fk_usuario = p_user_id
    ORDER BY m.fecha_de_creacion DESC
    LIMIT limite;
END;
$$;

-- sp_obtener_meta_de_parametro
CREATE OR REPLACE PROCEDURE public.sp_obtener_meta_de_parametro(
    p_user_id varchar,
    p_fk_parametro integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT m.meta_id, m.valor_objetivo, m.fecha_de_inicio_de_la_meta, m.fecha_limite
    FROM public.metas m
    WHERE m.fk_usuario = p_user_id AND m.fk_parametro = p_fk_parametro
    AND m.fecha_limite >= current_timestamp;
END;
$$;

-- sp_obtener_metas_actuales_del_cliente_por_parametro
CREATE OR REPLACE PROCEDURE public.sp_obtener_metas_actuales_del_cliente_por_parametro(
    p_user_id varchar,
    p_parametro integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT meta_id, valor_objetivo, fecha_de_inicio_de_la_meta, fecha_limite
    FROM public.metas
    WHERE fk_usuario = p_user_id AND fk_parametro = p_parametro
    AND current_timestamp BETWEEN fecha_de_inicio_de_la_meta AND fecha_limite;
END;
$$;

-- sp_obtener_medidas_del_usuario_por_tiempo
CREATE OR REPLACE PROCEDURE public.sp_obtener_medidas_del_usuario_por_tiempo(
    p_user_id varchar,
    p_fecha_inicio timestamp,
    p_fecha_fin timestamp
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT medida_id, fecha_de_creacion, valor, fk_parametro
    FROM public.medidas
    WHERE fk_usuario = p_user_id
    AND fecha_de_creacion BETWEEN p_fecha_inicio AND p_fecha_fin
    ORDER BY fecha_de_creacion;
END;
$$;

-- sp_obtener_medidas_por_anios_especificos
CREATE OR REPLACE PROCEDURE public.sp_obtener_medidas_por_anios_especificos(
    p_user_id varchar,
    p_anios integer[]
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT medida_id, fecha_de_creacion, valor, fk_parametro
    FROM public.medidas
    WHERE fk_usuario = p_user_id
    AND EXTRACT(YEAR FROM fecha_de_creacion) = ANY(p_anios)
    ORDER BY fecha_de_creacion;
END;
$$;

-- sp_obtener_medidas_por_meses_especificos
CREATE OR REPLACE PROCEDURE public.sp_obtener_medidas_por_meses_especificos(
    p_user_id varchar,
    p_meses integer[],
    p_anio integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT medida_id, fecha_de_creacion, valor, fk_parametro
    FROM public.medidas
    WHERE fk_usuario = p_user_id
    AND EXTRACT(MONTH FROM fecha_de_creacion) = ANY(p_meses)
    AND EXTRACT(YEAR FROM fecha_de_creacion) = p_anio
    ORDER BY fecha_de_creacion;
END;
$$;

-- sp_transferencia_clase_del_cliente
CREATE OR REPLACE PROCEDURE public.sp_transferencia_clase_del_cliente(
    p_id_inscripcion integer,
    p_nuevo_cliente varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.inscripciones_de_clases
    SET fk_cliente = p_nuevo_cliente
    WHERE id_inscripcion = p_id_inscripcion;
END;
$$;

-- sp_proceso_completo_cancelacion_de_inscripcion_a_clase
CREATE OR REPLACE PROCEDURE public.sp_proceso_completo_cancelacion_de_inscripcion_a_clase(id_inscripcion integer)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.inscripciones_de_clases
    SET fk_estado_inscripcion = (SELECT id_estado_inscripcion FROM public.estados_inscripciones WHERE nombre_estado_inscripcion = 'Cancelada')
    WHERE id_inscripcion = id_inscripcion;
END;
$$;

-- sp_proceso_completo_reagendacion_de_inscripcion
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

-- sp_obtener_equipamiento_recomendado_clase
CREATE OR REPLACE PROCEDURE public.sp_obtener_equipamiento_recomendado_clase(p_id_clase integer)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT DISTINCT e.equipo_id, e.nombre_equipo, e.descripcion
    FROM public.clases c
    INNER JOIN public.rutinas r ON c.clase_id = r.fk_clase
    INNER JOIN public.rutina_ejercicios re ON re.rutina_id = r.rutina_id
    INNER JOIN public.ejercicio_equipos ee ON ee.ejercicio_id = re.ejercicio_id
    INNER JOIN public.equipos e ON e.equipo_id = ee.equipo_id
    WHERE c.clase_id = p_id_clase;
END;
$$;

-- sp_obtener_estructura_clase
CREATE OR REPLACE PROCEDURE public.sp_obtener_estructura_clase(p_id_clase integer)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT es.id_bloque, es.fk_clase, es.numero_consecutivo_del_bloque,
           es.titulo_bloque, es.duracion_menor_en_minutos, es.duracion_mayor_en_minutos,
           es.descripcion_bloque
    FROM public.estructura_de_clase es
    WHERE es.fk_clase = p_id_clase
    ORDER BY es.numero_consecutivo_del_bloque;
END;
$$;

-- sp_obtener_entrenadores_disponibles_v6
CREATE OR REPLACE PROCEDURE public.sp_obtener_entrenadores_disponibles_v6(p_fecha_referencia timestamp)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT DISTINCT
        u.id AS usuario_id,
        u.nombre_completo AS nombre,
        u.apellido,
        u.email,
        u.telefono,
        u.user_name AS nombre_usuario,
        u.fecha_de_nacimiento AS fecha_nacimiento,
        u.fecha_de_registro AS fecha_registro,
        ar.id AS rol_id,
        u.estado
    FROM public.asp_net_users u
    INNER JOIN public.asp_net_user_roles ur ON u.id = ur.user_id
    INNER JOIN public.asp_net_roles ar ON ur.role_id = ar.id
    WHERE ar.name = 'Empleado' AND u.estado = 'Activo'
    AND u.id NOT IN (
        SELECT cp.fk_entrenador
        FROM public.clases_programadas cp
        INNER JOIN public.horarios_de_clases_programadas hcp ON cp.id_programacion_clase = hcp.fk_clase_programada
        WHERE CAST(cp.fecha_de_la_clase AS DATE) = CAST(p_fecha_referencia AS DATE)
    );
END;
$$;

-- sp_cancelar_clases_programadas_v6
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