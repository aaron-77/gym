-- =============================================
-- PROCEDURE: sp_transferencia_clase_del_cliente
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_transferencia_clase_del_cliente(
    p_id_inscripcion integer,
    p_nuevo_cliente varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.inscripciones_de_clases
    SET fk_cliente = p_nuevo_cliente
    WHERE id_inscripcion = p_id_inscripcion;
END;
$$;