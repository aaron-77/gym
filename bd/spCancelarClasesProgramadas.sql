CREATE PROCEDURE dbo.sp_cancelarClasesProgramadas
    @fechaDeReferencia DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    declare @idsClasesCanceladas ListadoIdsGenericos; 
    -- Si la fechaDeReferencia es NULL, se establece como la fecha actual
    IF @fechaDeReferencia IS NULL
    BEGIN
        SET @fechaDeReferencia = GETDATE();
    END

    -- Actualizar el estado de las clases programadas a 'Cancelada' para la fecha especificada
    UPDATE FitnessCenterDB.dbo.clasesProgramadas
    OUTPUT inserted.idProgramacionClase into @idsClasesCanceladas
    SET fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM FitnessCenterDB.dbo.estadosClasesProgramadas WHERE nombresEstado = 'cancelada')
    WHERE fechaDeLaClase = @fechaDeReferencia;

    -- También cancelar todas las clases programadas a partir de la fecha actual si la fechaDeReferencia es NULL
    IF @fechaDeReferencia = GETDATE()
    BEGIN
        UPDATE FitnessCenterDB.dbo.clasesProgramadas
        OUTPUT inserted.idProgramacionClase into @idsClasesCanceladas
        SET fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM FitnessCenterDB.dbo.estadosClasesProgramadas WHERE nombresEstado = 'cancelada')
        WHERE fechaDeLaClase >= GETDATE();
    END
    select * from @idsClasesCanceladas;
END;