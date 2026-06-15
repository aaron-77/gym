-- =============================================
-- FUNCTION: fn_obtenerEstadosDeClasesProgramadas
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION fn_obtenerEstadosDeClasesProgramdas()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        idEstadoClaseProgramada,
        nombresEstado,
        fechaCreacion,
        fechaModificacion
    FROM estadosClasesProgramadas
);

GO