CREATE PROCEDURE [dbo].[sp_consultarRutinasDeUsuario]
(
    @usuarioID NVARCHAR(450) -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
)
AS
BEGIN
    SELECT
        RutinaID,
        UserId,       -- MODIFICADO: UsuarioID a UserId
        EntrenadorId, -- MODIFICADO: EntrenadorID a EntrenadorId
        FechaCreacion,
        Observaciones
    FROM FitnessCenterDB.dbo.Rutinas -- MODIFICADO: Añadido esquema
    WHERE UserId = @usuarioID;      -- MODIFICADO: UsuarioID a UserId
END; 