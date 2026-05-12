-- =============================================
-- FUNCTION: fn_cupo_disponible_clase_programada
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_cupo_disponible_clase_programada(id_programacion_clase integer)
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    cupo_maximo integer;
    inscritos integer;
    cupo_disponible integer;
BEGIN
    -- Obtener el cupo máximo de la clase programada
    SELECT cp.cupo_maximo INTO cupo_maximo
    FROM public.clases_programadas cp
    WHERE cp.id_programacion_clase = id_programacion_clase;

    -- Contar la cantidad de inscritos vigentes (no cancelados) a la clase programada
    SELECT COUNT(*) INTO inscritos
    FROM public.inscripciones_de_clases ic
    INNER JOIN public.estados_inscripciones ei ON ic.fk_estado_inscripcion = ei.id_estado_inscripcion
    WHERE ic.fk_programacion_clase = id_programacion_clase
      AND LOWER(ei.nombre_estado_inscripcion) = 'vigente';

    -- Calcular cupo disponible
    cupo_disponible := coalesce(cupo_maximo, 0) - coalesce(inscritos, 0);

    RETURN cupo_disponible;
END;
$$;