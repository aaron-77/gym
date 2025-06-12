CREATE PROCEDURE dbo.sp_eliminarPreReservasCaducadas
    @idsPreReservasCaducadas dbo.ListadoIdsGenericos READONLY
AS
BEGIN
    SET NOCOUNT ON;

    -- Eliminar las pre reservas de horario con los IDs contenidos en idsPreReservasCaducadas
    DELETE FROM FitnessCenterDB.dbo.preReservasDeHorario
    WHERE idPreReserva IN (SELECT id FROM @idsPreReservasCaducadas);
END; 