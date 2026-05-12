-- =============================================
-- FUNCTION: fn_esDiaFestivoVariableVersionNormal
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.fn_esDiaFestivoVariableVersionNormal (
    @fechaAnalizada DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @esDiaFestivo BIT = 0;
    
    -- Consultar si existe algún día festivo variable que coincida con la fecha analizada
    -- utilizando la función fn_esDiaFestivoVariable para cada registro en diasFestivosVariables
    IF EXISTS (
        SELECT 1
        FROM dbo.diasFestivosVariables dfv
        WHERE dbo.fn_esDiaFestivoVariableVersionJoin(
            @fechaAnalizada, 
            dfv.deQueDia, 
            dfv.deQueSemana, 
            dfv.deQueMes, 
            dfv.fkTipoDeRecurrenciaDelFestivo
        ) = 1
    )
    BEGIN
        SET @esDiaFestivo = 1;
    END
    
    RETURN @esDiaFestivo;
END;

GO
