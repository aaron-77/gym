-- =============================================
-- PROCEDURE: sp_consultar_clientes
-- Convertido a PostgreSQL 18.3.2 desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_consultar_clientes(estado varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT 
        u.nombre,
        u.apellido,
        u.email,
        u.telefono,
        u.fecha_nacimiento,
        u.fecha_registro
    FROM public.usuarios u 
    WHERE u.estado = estado;
END;
$$;