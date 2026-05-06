-- =============================================
-- FUNCTION: ObtenerEstructuraDeClase
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.ObtenerEstructuraDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ec.IdBloque,
        c.NombreClase AS NombreDeLaClase,
        ec.NumeroConsecutivoDelBloque,
        ec.DuracionMenorEnMinutos,
        ec.DuracionMayorEnMinutos,
        ec.TituloBloque,
        ec.DescripcionBloque
    FROM 
        EstructuraDeClase ec
        INNER JOIN Clases c ON ec.FkClase = c.claseId
    WHERE 
        ec.FkClase = @IdClase
    
);

GO
