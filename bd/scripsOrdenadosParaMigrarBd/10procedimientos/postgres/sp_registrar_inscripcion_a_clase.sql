-- =============================================
-- PROCEDURE: sp_registrar_inscripcion_a_clase
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_registrar_inscripcion_a_clase(
    p_fk_programacion_clase integer,
    p_fk_cliente varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.inscripciones_de_clases (fk_programacion_clase, fk_estado_inscripcion, fk_cliente)
    VALUES (p_fk_programacion_clase, 1, p_fk_cliente);
END;
$$;