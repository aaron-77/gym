use fitnessCenterDB
-- =============================================
-- FUNCTION: fn_validarCupoDeClase
-- Spec: 59-spect-fn_validarCupoDeClase
-- =============================================

CREATE FUNCTION dbo.fn_validarCupoDeClase
(
    @idClaseProgramada INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @cupoMaximo INT;
    DECLARE @inscritosActivos INT;
    DECLARE @cupoDisponible INT;

    -- Obtener el cupo máximo de la clase programada
    SELECT @cupoMaximo = cp.cupoMaximo
    FROM clasesProgramadas cp
    WHERE cp.idProgramacionClase = @idClaseProgramada;

    -- Si no existe la clase programada, retornar 0
    IF @cupoMaximo IS NULL
        RETURN 0;

    -- Contar inscripciones activas (excluye canceladas)
    SELECT @inscritosActivos = COUNT(*)
    FROM inscripcionesDeClases ic
    INNER JOIN estadosInscripciones ei ON ic.fkEstadoInscripcion = ei.idEstadoInscripcion
    WHERE ic.fkProgramacionClase = @idClaseProgramada
      AND LOWER(ei.nombreEstadoInscripcion) != 'cancelada';

    -- Calcular cupo disponible
    SET @cupoDisponible = @cupoMaximo - @inscritosActivos;

    -- Retornar 1 si hay cupo, 0 si no hay
    IF @cupoDisponible > 0
        RETURN 1;

    RETURN 0;
END;

GO
