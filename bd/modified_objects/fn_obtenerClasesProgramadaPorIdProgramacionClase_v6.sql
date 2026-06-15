USE [FitnessCenterDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Modified function adapted to schema V6
CREATE OR ALTER FUNCTION dbo.fn_obtenerClasesProgramadaPorIdProgramacionClase_v6(@idProgramacionClase INT)
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
        CONCAT(CONVERT(varchar(5), hl.horaInicio, 108), ' - ', CONVERT(varchar(5), hl.horaFin, 108)) AS labelHorario,
        cp.fkEntrenador,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreEntrenador
    FROM dbo.clasesProgramadas cp
    INNER JOIN dbo.horariosDeClasesProgramadas hcp 
        ON cp.idProgramacionClase = hcp.fkClaseProgramada
    INNER JOIN dbo.horasLaborales hl 
        ON hcp.fkHorarioLaboral = hl.idHora
    LEFT JOIN dbo.AspNetUsers u 
        ON cp.fkEntrenador = u.Id
    WHERE cp.idProgramacionClase = @idProgramacionClase
);
GO
