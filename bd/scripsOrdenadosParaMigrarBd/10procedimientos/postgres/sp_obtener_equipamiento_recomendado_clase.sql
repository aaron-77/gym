-- =============================================
-- PROCEDURE: sp_obtener_equipamiento_recomendado_clase
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

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