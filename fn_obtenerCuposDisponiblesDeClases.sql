CREATE FUNCTION dbo.fn_cupoDisponibleClaseProgramada
(
    @idProgramacionClase INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cupoMaximo INT;
    DECLARE @inscritos INT;
    DECLARE @cupoDisponible INT;

    -- Obtener el cupo máximo de la clase programada
    SELECT @cupoMaximo = cupoMaximo
    FROM clasesProgramadas
    WHERE idProgramacionClase = @idProgramacionClase;

    -- Contar la cantidad de inscritos vigentes (no cancelados) a la clase programada
    SELECT @inscritos = COUNT(*)
    FROM inscripcionesDeClases ic
    INNER JOIN estadosInscripciones ei ON ic.fkEstadoInscripcion = ei.idEstadoInscripcion
    WHERE ic.fkProgramacionClase = @idProgramacionClase
      AND LOWER(ei.nombreEstadoInscripcion) = 'vigente';

    -- Calcular cupo disponible
    SET @cupoDisponible = @cupoMaximo - @inscritos;

    RETURN @cupoDisponible;
END