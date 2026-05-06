-- =============================================
-- PROCEDURE: sp_consultar_usuarios
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_consultar_usuarios(estado varchar DEFAULT NULL)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT usuario_id, nombre, apellido, email, telefono, fecha_nacimiento, fecha_registro
    FROM public.usuarios
    WHERE estado = sp_consultar_usuarios.estado OR sp_consultar_usuarios.estado IS NULL;
END;
$$;