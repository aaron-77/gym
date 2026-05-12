-- =============================================
-- FUNCTION: fn_inscripcionEstaVigente
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION fn_inscripcionEstaVigente(@idInscripcion INT)
RETURNS BIT
AS
BEGIN
    DECLARE @estadoInscripcion INT;
    DECLARE @resultado BIT; -- Nueva variable para almacenar el resultado

    -- Obtener el estado de la inscripción
    SELECT @estadoInscripcion = fkEstadoInscripcion
    FROM FitnessCenterDB.dbo.inscripcionesDeClases
    WHERE idInscripcion = @idInscripcion;

    -- Comparar con el estado vigente y almacenar el resultado
    IF @estadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase)
    BEGIN
        SET @resultado = 1; -- true
    END
    ELSE
    BEGIN
        SET @resultado = 0; -- false
    END

    RETURN @resultado; -- Devolver el resultado
END;

GO