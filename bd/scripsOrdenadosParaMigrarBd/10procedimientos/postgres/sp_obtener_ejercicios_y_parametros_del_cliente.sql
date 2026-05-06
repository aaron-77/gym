-- =============================================
-- PROCEDURE: sp_obtener_ejercicios_y_parametros_del_cliente
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

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