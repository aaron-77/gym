CREATE FUNCTION dbo.fn_esElMismoTipoDeClase
(
    @idInscripcionCancelada INT,
    @idClaseProgramadaNueva INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @idClaseInscripcion INT;
    DECLARE @idClaseNueva INT;

    -- Obtener el idClase de la inscripción cancelada
    SELECT @idClaseInscripcion = c.fkClase
    FROM FitnessCenterDB.dbo.inscripcionesDeClases i
    JOIN FitnessCenterDB.dbo.clasesProgramadas c ON i.fkProgramacionClase = c.idProgramacionClase
    WHERE i.idInscripcion = @idInscripcionCancelada;

    -- Obtener el idClase de la nueva clase programada
    SELECT @idClaseNueva = fkClase
    FROM FitnessCenterDB.dbo.clasesProgramadas
    WHERE idProgramacionClase = @idClaseProgramadaNueva;

    -- Comparar los idClase
    IF @idClaseInscripcion = @idClaseNueva
    BEGIN
        RETURN 1; -- true
    END
    ELSE
    BEGIN
        -- Lanzar excepción si no son iguales
        RAISERROR('Estás intentando reagendar una clase diferente a la original.', 16, 1);
        RETURN 0; -- Este retorno no se alcanzará debido a la excepción
    END
END;