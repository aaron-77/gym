-- =============================================
-- PROCEDURE: sp_obtenerMetaDeParametro
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_obtenerMetaDeParametro]
    @idUsuario nvarchar(450),
    @idParametro INT,
    @idEjercicio INT = NULL,
    @fechaDeReferencia DATETIME = NULL
AS
BEGIN
    -- Asignar la fecha actual si no se proporciona un valor para @fechaDeReferencia
    IF @fechaDeReferencia IS NULL
        SET @fechaDeReferencia = GETDATE();

    SELECT 
        m.metaId,
        m.fkUsuario,
        m.fechaDeInicioDeLaMeta ,
        m.fechaLimite,
        m.fkParametro AS fkParametro,
        pm.nombre AS nombreParametro,
        m.fkEjercicio,
        e.NombreEjercicio,
        m.valorObjetivo 
    FROM 
        metas AS m
    INNER JOIN 
        parametrosDeMedicion AS pm ON m.fkParametro = pm.parametroMedicionId
    LEFT JOIN 
        ejercicios AS e ON m.fkEjercicio = e.EjercicioID 
    WHERE 
        m.fkUsuario = @idUsuario
        AND m.fkParametro = @idParametro
        AND (@idEjercicio IS NULL OR m.fkEjercicio = @idEjercicio)
        AND m.fechaDeInicioDeLaMeta <= @fechaDeReferencia
        AND m.fechaLimite >= @fechaDeReferencia;
END;

GO
