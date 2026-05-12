-- =============================================
-- PROCEDURE: sp_obtener_citas_agendadas_por_usuario
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

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