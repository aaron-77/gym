-- =============================================
-- FUNCTION: fn_obtenerDiasFestivosVariablesActuales
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION dbo.fn_obtenerDiasFestivosVariablesActuales (
    @anio INT
)
RETURNS @fechas TABLE (fechaExacta DATE)
AS
BEGIN
    DECLARE @datos DatosDiaFestivoVariable;

    -- Cargar los días festivos variables activos
    INSERT INTO @datos (diaDeFechaVariable, semanaDeFechaVariable, mesDeFechaVariable, idTipoDeRecurrencia)
    SELECT dfv.deQueDia, dfv.deQueSemana, dfv.deQueMes, dfv.fkTipoDeRecurrenciaDelFestivo
    FROM dbo.diasFestivosVariables dfv
    INNER JOIN dbo.estadosDeActividadLaboral eal
        ON dfv.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
    WHERE eal.nombreEstadoActividadLaboral = 'no se labora';

    -- Calcular las fechas usando la función existente
    INSERT INTO @fechas (fechaExacta)
    SELECT fechaExacta
    FROM dbo.fn_obtenerFechasDeDiasFestivosVariables(@anio, @datos);

    RETURN;
END;
GO
