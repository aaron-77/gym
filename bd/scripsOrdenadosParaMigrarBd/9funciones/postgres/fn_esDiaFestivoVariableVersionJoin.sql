-- =============================================
-- FUNCTION: fn_es_dia_festivo_variable_version_join
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- Nota: Función simplificada para compatibilidad
-- =============================================

CREATE OR REPLACE FUNCTION public.fn_es_dia_festivo_variable_version_join(
    fecha_analizada date,
    dia_de_fecha_variable integer,
    semana_de_fecha_variable integer DEFAULT NULL,
    mes_de_fecha_variable integer DEFAULT NULL,
    id_tipo_de_recurrencia integer DEFAULT NULL
)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
    resultado boolean := false;
    anio_actual integer;
    nombre_tipo_de_recurrencia varchar(50);
BEGIN
    anio_actual := EXTRACT(YEAR FROM fecha_analizada)::integer;
    
    -- Obtener tipo de recurrencia
    IF id_tipo_de_recurrencia IS NOT NULL THEN
        SELECT nombre_tipo_de_recurrencia INTO nombre_tipo_de_recurrencia
        FROM public.tipos_de_recurrencia_de_dias_festivos
        WHERE id_tipo_de_recurrencia_de_dia_festivo = id_tipo_de_recurrencia;
    END IF;
    
    -- CASO 1: día festivo anual con fecha variable (ej: "el segundo lunes de enero del año")
    IF dia_de_fecha_variable IS NOT NULL 
       AND semana_de_fecha_variable IS NOT NULL 
       AND mes_de_fecha_variable IS NOT NULL THEN
        IF EXTRACT(MONTH FROM fecha_analizada) = mes_de_fecha_variable THEN
            DECLARE
                primer_dia_mes date := make_date(anio_actual, mes_de_fecha_variable, 1);
                dia_festivo date;
            BEGIN
                -- Encontrar el primer día de la semana en el mes
                WHILE EXTRACT(DOW FROM primer_dia_mes) + 1 != dia_de_fecha_variable LOOP
                    primer_dia_mes := primer_dia_mes + 1;
                END LOOP;
                
                dia_festivo := primer_dia_mes + ((semana_de_fecha_variable - 1) || ' weeks')::interval;
                
                IF EXTRACT(MONTH FROM dia_festivo) = mes_de_fecha_variable 
                   AND fecha_analizada = dia_festivo THEN
                    resultado := true;
                END IF;
            END;
        END IF;
    END IF;
    
    -- CASO 2: día de la semana relativo (ej: "todos los martes")
    IF dia_de_fecha_variable IS NOT NULL 
       AND semana_de_fecha_variable IS NULL
       AND mes_de_fecha_variable IS NULL
       AND nombre_tipo_de_recurrencia = 'diaRelativo' THEN
        IF EXTRACT(DOW FROM fecha_analizada) + 1 = dia_de_fecha_variable THEN
            resultado := true;
        END IF;
    END IF;
    
    RETURN resultado;
END;
$$;