-- =============================================
-- PROCEDURE: sp_consultar_rutinas_de_usuario
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_consultar_rutinas_de_usuario(user_id varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT r.rutina_id, r.fecha_creacion, r.observaciones, r.fk_clase
    FROM public.rutinas r
    WHERE r.user_id = user_id;
END;
$$;