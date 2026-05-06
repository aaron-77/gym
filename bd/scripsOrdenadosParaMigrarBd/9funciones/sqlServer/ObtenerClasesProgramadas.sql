-- =============================================
-- FUNCTION: ObtenerClasesProgramadas
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION dbo.ObtenerClasesProgramadas(@IdClase int)
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
    FROM clasesProgramadas cp
        INNER JOIN Clases c ON cp.fkClase = c.ClaseID
        LEFT JOIN AspNetUsers u ON cp.fkEntrenador = u.Id
        INNER JOIN horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
        INNER JOIN horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
    WHERE cp.fkClase = @IdClase
        AND YEAR(cp.fechaDeLaClase) = YEAR(GETDATE())
        AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas)
);

-- Modified function adapted to schema V6

GO
