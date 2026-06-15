-- =============================================
-- PROCEDURE: buscarClaseProgramadas
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   PROCEDURE dbo.buscarClaseProgramadas
    @idClase INT = NULL,
    @idEntrenador NVARCHAR(450) = NULL,
    @idHoraLaboral INT = NULL,
    @fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        cp.idProgramacionClase,
        c.NombreClase AS nombreDeLaClase,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreCompletoDelEntrenador,
        cp.fechaDeLaClase,
        hl.horaInicio,
        hl.horaFin,
        h.idHorarioDeClaseProgramada
    FROM dbo.clasesProgramadas cp
    INNER JOIN dbo.Clases c ON cp.fkClase = c.ClaseID
    LEFT JOIN dbo.AspNetUsers u ON cp.fkEntrenador = u.Id
    INNER JOIN dbo.horariosDeClasesProgramadas h ON cp.idProgramacionClase = h.fkClaseProgramada
    INNER JOIN dbo.horasLaborales hl ON h.fkHorarioLaboral = hl.idHora
    WHERE
        (@idClase IS NULL OR cp.fkClase = @idClase)
        AND (@idEntrenador IS NULL OR cp.fkEntrenador = @idEntrenador)
        AND (@idHoraLaboral IS NULL OR h.fkHorarioLaboral = @idHoraLaboral)
        AND (@fecha IS NULL OR cp.fechaDeLaClase = @fecha);
END;

GO
