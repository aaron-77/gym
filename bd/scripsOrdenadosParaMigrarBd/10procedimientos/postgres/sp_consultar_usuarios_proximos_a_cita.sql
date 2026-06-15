-- =============================================
-- PROCEDURE: sp_consultar_usuarios_proximos_a_cita
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_consultar_usuarios_proximos_a_cita()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT DISTINCT u.id, u.nombre_completo, u.email, u.telefono
    FROM public.asp_net_users u
    INNER JOIN public.citas c ON c.user_id = u.id
    WHERE c.fecha_hora >= current_timestamp
    ORDER BY c.fecha_hora;
END;
$$;