-- =============================================
-- PROCEDURE: sp_obtener_usuarios_con_citas_agendadas
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

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