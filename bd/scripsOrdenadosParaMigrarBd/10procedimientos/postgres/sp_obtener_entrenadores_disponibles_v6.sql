-- =============================================
-- PROCEDURE: sp_obtener_entrenadores_disponibles_v6
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_obtener_entrenadores_disponibles_v6(p_fecha_referencia timestamp)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT DISTINCT
        u.id AS usuario_id,
        u.nombre_completo AS nombre,
        u.apellido,
        u.email,
        u.telefono,
        u.user_name AS nombre_usuario,
        u.fecha_de_nacimiento AS fecha_nacimiento,
        u.fecha_de_registro AS fecha_registro,
        ar.id AS rol_id,
        u.estado
    FROM public.asp_net_users u
    INNER JOIN public.asp_net_user_roles ur ON u.id = ur.user_id
    INNER JOIN public.asp_net_roles ar ON ur.role_id = ar.id
    WHERE ar.name = 'Empleado' AND u.estado = 'Activo'
    AND u.id NOT IN (
        SELECT cp.fk_entrenador
        FROM public.clases_programadas cp
        INNER JOIN public.horarios_de_clases_programadas hcp ON cp.id_programacion_clase = hcp.fk_clase_programada
        WHERE CAST(cp.fecha_de_la_clase AS DATE) = CAST(p_fecha_referencia AS DATE)
    );
END;
$$;