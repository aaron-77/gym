-- =============================================
-- FUNCTION: ya_existe_clase_programada
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- Nota: Simplificado con array para horarios
-- =============================================

CREATE OR REPLACE FUNCTION public.ya_existe_clase_programada(fecha date, horas_laborales integer[])
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    result integer := 0;
BEGIN
    IF EXISTS (
        SELECT 1 FROM public.horarios_de_clases_programadas hcp
        WHERE hcp.fecha_de_la_clase = fecha
        AND hcp.fk_horario_laboral = ANY(horas_laborales)
    ) THEN
        result := 1;
    END IF;
    RETURN result;
END;
$$;