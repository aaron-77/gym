CREATE PROCEDURE [dbo].[sp_registrarCita]
(
    @usuarioID NVARCHAR(450),    -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
    @entrenadorID NVARCHAR(450), -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
    @fechaInicio datetime,
    @tipoCita nvarchar(50),
    @estado nvarchar(50),
    @fechaHoraFin datetime
)
AS
BEGIN
    INSERT INTO FitnessCenterDB.dbo.Citas(UserId,               -- MODIFICADO: UsuarioID a UserId
                                      EntrenadorId,           -- MODIFICADO: EntrenadorID a EntrenadorId
                                      FechaHora,
                                      TipoCita,
                                      Estado,
                                      FechaHoraFin)
    VALUES(@usuarioID,
           @entrenadorID,
           FORMAT(@fechaInicio, 'yyyy-MM-dd HH:mm:ss'),
           @tipoCita,
           @estado,
           FORMAT(@fechaHoraFin, 'yyyy-MM-dd HH:mm:ss'))
END; 