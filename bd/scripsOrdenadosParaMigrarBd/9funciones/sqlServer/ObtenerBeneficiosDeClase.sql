-- =============================================
-- FUNCTION: ObtenerBeneficiosDeClase
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.ObtenerBeneficiosDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        bc.beneficio,
        descripcionBeneficio,
        ifp.urlPublica
    FROM 
        BeneficiosDeClase bc
        left join iconsForParameters ifp on bc.fkIcon = ifp.iconId 
    WHERE 
        bc.FkClase = @IdClase
);

GO
