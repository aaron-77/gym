-- =============================================
-- FUNCTION: ObtenerClasesProgramadas_v6
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.ObtenerClasesProgramadas_v6(@IdClase int)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        cp.idProgramacionClase,
        c.NombreClase,
        DATENAME(WEEKDAY, cp.fechaDeLaClase) AS DiaDeLaSemana,
        hl.horaInicio AS HoraInicio,
        hl.horaFin AS HoraFin,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS NombreEntrenador
    FROM dbo.clasesProgramadas cp
        INNER JOIN dbo.Clases c ON cp.fkClase = c.ClaseID
        LEFT JOIN dbo.AspNetUsers u ON cp.fkEntrenador = u.Id
        INNER JOIN dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
        INNER JOIN dbo.horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
    WHERE cp.fkClase = @IdClase
        AND YEAR(cp.fechaDeLaClase) = YEAR(GETDATE())
        AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM dbo.v_idEstadoDisponibleClasesProgramadas)
);

GO
