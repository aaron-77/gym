CREATE PROCEDURE [dbo].[sp_obtenerCitasAgendadasPorUsuario]
(
    @idUsuario NVARCHAR(450) -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
)
AS
BEGIN
    SELECT
        CitaID,
        UserId,       -- MODIFICADO: UsuarioID a UserId
        EntrenadorId, -- MODIFICADO: EntrenadorID a EntrenadorId
        FechaHora,
        FechaHoraFin,
        TipoCita,
        Estado
    FROM FitnessCenterDB.dbo.Citas  -- MODIFICADO: Añadido esquema
    WHERE UserId = @idUsuario AND Estado IN ('agendada','Agendada'); -- MODIFICADO: UsuarioID a UserId
END; 