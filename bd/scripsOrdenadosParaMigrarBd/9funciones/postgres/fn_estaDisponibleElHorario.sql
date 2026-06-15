-- =============================================
-- FUNCTION: fn_esta_disponible_el_horario
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- Nota: Simplificado - requiere tabla de horas como array
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_esta_disponible_el_horario(
    fecha_reservada date,
    fks_horas_laborales integer[]
)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
    esta_disponible boolean := true;
BEGIN
    -- Verificar si la clase programada tiene horarios asignados
    IF public.ya_existe_clase_programada(fecha_reservada, fks_horas_laborales) = 1 THEN
        esta_disponible := false;
    END IF;
    
    -- Verificar si algún horario de la clase está pre-reservado
    IF public.ya_existe_pre_registro_de_clase(fecha_reservada, fks_horas_laborales) = 1 THEN
        esta_disponible := false;
    END IF;
    
    RETURN esta_disponible;
END;
$$;