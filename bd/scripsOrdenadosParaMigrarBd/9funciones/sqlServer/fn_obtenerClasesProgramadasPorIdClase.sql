-- =============================================
-- FUNCTION: fn_obtenerClasesProgramadasPorIdClase
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION dbo.fn_obtenerClasesProgramadasPorIdClase(@idClase INT, @fechaReferencia DATE = NULL)
RETURNS TABLE
AS
RETURN
(
    SELECT
        cp.idProgramacionClase AS idClaseProgramada,
        cp.fkClase,
        cp.cupoMaximo,
        (SELECT dbo.fn_cupoDisponibleClaseProgramada(cp.idProgramacionClase)) as cupoDisponible,
        cp.fechaDeLaClase,
        hl.idHora,
        hl.horaInicio,
        hl.horaFin,
        CONCAT(CONVERT(varchar(10), hl.horaInicio, 108), ' - ', CONVERT(varchar(10), hl.horaFin, 108)) AS labelHorario,
        cp.fkEntrenador,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreEntrenador
    FROM clasesProgramadas cp
        INNER JOIN horariosDeClasesProgramadas hcp 
            ON cp.idProgramacionClase = hcp.fkClaseProgramada
        INNER JOIN horasLaborales hl 
            ON hcp.fkHorarioLaboral = hl.idHora
        LEFT JOIN AspNetUsers u 
            ON cp.fkEntrenador = u.Id
    WHERE cp.fkClase = @idClase
        AND cp.fechaDeLaClase >= COALESCE(@fechaReferencia, CAST(GETDATE() AS DATE))
);

-- Modified function adapted to schema V6

GO
