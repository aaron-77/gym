-- =============================================
-- FUNCTION: ObtenerConsejosDeClase
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.ObtenerConsejosDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT 
        c.FkClase,
        c.IntroduccionDeConsejo, 
       JSON_QUERY(
        '["' + 
        REPLACE(
            c.consejos,
            ',', 
            '","'
        ) + 
        '"]'
    ) AS consejos
    FROM 
        consejosParaLasClases c
    WHERE 
        c.FkClase = @IdClase
);

GO
