-- =============================================
-- FUNCTION: ObtenerCaracteristicasDeClase
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.ObtenerCaracteristicasDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        c.DuracionEnMinutos,
        ni.NombreNivelDeIntensidad AS NivelDeIntensidad,
        nd.NombreNivelDeDificultad AS NivelDeDificultad,
        c.Descripcion AS DescripcionDeLaClase
    FROM 
        Clases c
        INNER JOIN NivelesDeIntensidadDeClase ni ON c.FkIntensidad = ni.IdNivelDeIntensidad
        INNER JOIN NivelesDeDificultadDeClase nd ON c.FkDificultad = nd.IdNivelDeDificultadDeClase
    WHERE 
        c.claseId = @IdClase
);

GO
