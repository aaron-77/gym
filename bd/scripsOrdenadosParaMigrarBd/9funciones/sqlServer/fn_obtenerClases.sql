-- =============================================
-- FUNCTION: fn_obtenerClases
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION fn_obtenerClases()
RETURNS TABLE
AS
RETURN (
    SELECT ClaseID, NombreClase
    FROM FitnessCenterDB.dbo.Clases
    where fkEstadoClase = (select idEstadoClase from v_estadoActivoClases)
);

GO