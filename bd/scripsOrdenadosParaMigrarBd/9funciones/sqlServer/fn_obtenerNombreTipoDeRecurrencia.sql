-- =============================================
-- FUNCTION: fn_obtenerNombreTipoDeRecurrencia
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.fn_obtenerNombreTipoDeRecurrencia (
    @idTipoDeRecurrencia INT
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @nombreTipoDeRecurrencia NVARCHAR(100);
    
    SELECT @nombreTipoDeRecurrencia = nombreTipoDeRecurrencia
    FROM dbo.tiposDeRecurrenciaDeDiasFestivos
    WHERE idTipoDeRecurrenciaDeDiaFestivo = @idTipoDeRecurrencia;
    
    RETURN @nombreTipoDeRecurrencia;
END;

GO
