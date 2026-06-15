-- =============================================
-- FUNCTION: fn_inscripcion_esta_vigente
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_inscripcion_esta_vigente(id_inscripcion integer)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
    estado_inscripcion integer;
    resultado boolean := false;
BEGIN
    -- Obtener el estado de la inscripción
    SELECT ic.fk_estado_inscripcion INTO estado_inscripcion
    FROM public.inscripciones_de_clases ic
    WHERE ic.id_inscripcion = id_inscripcion;

    -- Comparar con el estado vigente
    IF estado_inscripcion = (SELECT id_estado_inscripcion FROM public.estados_inscripciones WHERE nombre_estado_inscripcion = 'Vigente') THEN
        resultado := true;
    END IF;

    RETURN resultado;
END;
$$;