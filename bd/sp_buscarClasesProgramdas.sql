-- bd/buscarClaseProgramadas.sql

CREATE PROCEDURE buscarClaseProgramadas
    @idClase INT = NULL,
    @idEntrenador INT = NULL,
    @idHoraLaboral INT = NULL,
    @fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        cp.idProgramacionClase,
        c.NombreClase AS nombreDeLaClase,
        CONCAT(u.Nombre, ' ', u.Apellido) AS nombreCompletoDelEntrenador,
        hcp.fechaDeLaClase,
        h.horaInicio,
        h.horaFin
    FROM 
        FitnessCenterDB.dbo.clasesProgramadas cp
    INNER JOIN 
        FitnessCenterDB.dbo.Clases c ON cp.fkClase = c.ClaseID
    INNER JOIN 
        FitnessCenterDB.dbo.Usuarios u ON cp.fkEntrenador = u.UsuarioID
    INNER JOIN 
        FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
    INNER JOIN 
        FitnessCenterDB.dbo.horasLaborales h ON hcp.fkHorarioLaboral = h.idHora
    WHERE 
        (@idClase IS NULL OR cp.fkClase = @idClase) AND
        (@idEntrenador IS NULL OR cp.fkEntrenador = @idEntrenador) AND
        (@idHoraLaboral IS NULL OR hcp.fkHorarioLaboral = @idHoraLaboral) AND
        (@fecha IS NULL OR hcp.fechaDeLaClase = @fecha);
END