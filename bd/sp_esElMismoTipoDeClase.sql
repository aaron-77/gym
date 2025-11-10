CREATE PROCEDURE dbo.sp_esElMismoTipoDeClase
(
    @idInscripcionCancelada INT,
    @idClaseProgramadaNueva INT
)
AS
BEGIN
    SET NOCOUNT ON;

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
        RETURN; -- Si son iguales, simplemente retorna
    END
    ELSE
    BEGIN
        -- Lanzar excepción si no son iguales
        RAISERROR('Estás intentando reagendar una clase diferente a la original.', 16, 1);
    END
END; 