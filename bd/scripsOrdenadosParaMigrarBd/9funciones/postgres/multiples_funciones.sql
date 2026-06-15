-- =============================================
-- FUNCTION: fn_obtener_estados_de_clases_programadas
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_obtener_estados_de_clases_programadas()
RETURNS TABLE (id_estado_clase_programada integer, nombre_estado text)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT ecp.id_estado_clase_programada, ecp.nombre_estado
        FROM public.estados_clases_programadas ecp
    );
END;
$$;

-- =============================================
-- FUNCTION: fn_obtener_nombre_tipo_de_recurrencia
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_obtener_nombre_tipo_de_recurrencia(id_tipo integer)
RETURNS varchar
LANGUAGE plpgsql
AS $$
DECLARE
    nombre varchar;
BEGIN
    SELECT nombre_tipo_de_recurrencia INTO nombre
    FROM public.tipos_de_recurrencia_de_dias_festivos
    WHERE id_tipo_de_recurrencia_de_dia_festivo = id_tipo;
    RETURN nombre;
END;
$$;

-- =============================================
-- FUNCTION: fn_obtener_clases_programada_por_id_programacion_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_obtener_clases_programada_por_id_programacion_clase(id_programacion integer)
RETURNS TABLE (id_programacion_clase integer, fk_clase integer,cupo_maximo integer,fk_entrenador varchar,fecha_de_la_clase date)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT cp.id_programacion_clase, cp.fk_clase, cp.cupo_maximo, cp.fk_entrenador, cp.fecha_de_la_clase
        FROM public.clases_programadas cp
        WHERE cp.id_programacion_clase = id_programacion
    );
END;
$$;

-- =============================================
-- FUNCTION: fn_obtener_clases_programadas_por_id_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_obtener_clases_programadas_por_id_clase(id_clase integer)
RETURNS TABLE (id_programacion_clase integer, fecha_de_la_clase date,cupo_maximo integer)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT cp.id_programacion_clase, cp.fecha_de_la_clase, cp.cupo_maximo
        FROM public.clases_programadas cp
        WHERE cp.fk_clase = id_clase
        ORDER BY cp.fecha_de_la_clase
    );
END;
$$;

-- =============================================
-- FUNCTION: obtener_beneficios_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_beneficios_de_clase(id_clase integer)
RETURNS TABLE (id_beneficio integer, beneficio varchar, descripcion_beneficio text)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT bc.id_beneficio, bc.beneficio, bc.descripcion_beneficio
        FROM public.beneficios_de_clase bc
        WHERE bc.fk_clase = id_clase
    );
END;
$$;

-- =============================================
-- FUNCTION: obtener_caracteristicas_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_caracteristicas_de_clase(id_clase integer)
RETURNS TABLE (id_bloque integer, titulo_bloque varchar, descripcion_bloque text)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT ec.id_bloque, ec.titulo_bloque, ec.descripcion_bloque
        FROM public.estructura_de_clase ec
        WHERE ec.fk_clase = id_clase
        ORDER BY ec.numero_consecutivo_del_bloque
    );
END;
$$;

-- =============================================
-- FUNCTION: obtener_estructura_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_estructura_de_clase(id_clase integer)
RETURNS TABLE (id_bloque integer, titulo_bloque varchar, descripcion_bloque text,numero_consecutivo integer)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT ec.id_bloque, ec.titulo_bloque, ec.descripcion_bloque, ec.numero_consecutivo_del_bloque
        FROM public.estructura_de_clase ec
        WHERE ec.fk_clase = id_clase
        ORDER BY ec.numero_consecutivo_del_bloque
    );
END;
$$;

-- =============================================
-- FUNCTION: obtener_imagenes_de_la_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_imagenes_de_la_clase(id_clase integer)
RETURNS TABLE (id_class_image integer, url_para_banner text, url_para_descripcion_de_clase text)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT ifc.id_class_image, ifc.url_para_banner, ifc.url_para_descripcion_de_clase
        FROM public.images_for_clases ifc
        WHERE ifc.fk_clase = id_clase
    );
END;
$$;

-- =============================================
-- FUNCTION: obtener_ejercicios_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_ejercicios_de_clase(id_clase integer)
RETURNS TABLE (ejercicio_id integer, nombre_ejercicio varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        -- Esta función requeriría una tabla de relación clases-ejercicios
        SELECT e.ejercicio_id, e.nombre_ejercicio
        FROM public.ejercicios e
        WHERE 1=0 -- Placeholder - necesita tabla de relación
    );
END;
$$;

-- =============================================
-- FUNCTION: obtener_consejos_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_consejos_de_clase(id_clase integer)
RETURNS TABLE (id_consejo integer, introduccion_de_consejo text, consejos text)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT clc.id_consejo, clc.introduccion_de_consejo, clc.consejos
        FROM public.consejos_para_las_clases clc
        WHERE clc.fk_clase = id_clase
    );
END;
$$;

-- =============================================
-- FUNCTION: obtener_detalle_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_detalle_de_clase(id_clase integer)
RETURNS TABLE (clase_id integer, nombre_clase varchar, descripcion text,cupo integer)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT c.clase_id, c.nombre_clase, c.descripcion, c.cupo
        FROM public.clases c
        WHERE c.clase_id = id_clase
    );
END;
$$;

-- =============================================
-- FUNCTION: obtener_equipamiento_recomendado
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.obtener_equipamiento_recomendado(id_ejercicio integer)
RETURNS TABLE (equipo_id integer, nombre_equipo varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY(
        SELECT ee.equipo_id, eq.nombre_equipo
        FROM public.ejercicio_equipos ee
        JOIN public.equipos eq ON ee.equipo_id = eq.equipo_id
        WHERE ee.ejercicio_id = id_ejercicio
    );
END;
$$;

-- =============================================
-- FUNCTION: ya_existe_pre_registro_de_clase
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.ya_existe_pre_registro_de_clase(fecha date, horas_laborales integer[])
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    result integer := 0;
BEGIN
    IF EXISTS (
        SELECT 1 FROM public.pre_reservas_de_horario pr
        WHERE pr.fecha_de_la_clase = fecha
        AND pr.fk_hora_laboral = ANY(horas_laborales)
        AND current_timestamp BETWEEN pr.fecha_inicio_de_la_reserva AND pr.fecha_de_expiracion_de_la_reserva
    ) THEN
        result := 1;
    END IF;
    RETURN result;
END;
$$;