-- =============================================
-- PROCEDURE: sp_cancelar_inscripcion_a_clase
-- Convertido a PostgreSQL desde SQL Server
-- Esquema: public
-- =============================================

CREATE OR REPLACE PROCEDURE public.sp_cancelar_inscripcion_a_clase(id_inscripcion integer)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.inscripciones_de_clases
    SET fk_estado_inscripcion = (SELECT id_estado_inscripcion FROM public.estados_inscripciones WHERE nombre_estado_inscripcion = 'Cancelada')
    WHERE id_inscripcion = sp_cancelar_inscripcion_a_clase.id_inscripcion;
END;
$$;