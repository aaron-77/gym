USE [FitnessCenterDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW dbo.vw_HorariosOcupados_v6
WITH SCHEMABINDING
AS
SELECT 
    cp.fkClase,
    cp.fechaDeLaClase,
    h.fkHorarioLaboral,
    au.IdSecundario,
    h.idHorarioDeClaseProgramada
FROM dbo.clasesProgramadas cp
INNER JOIN dbo.horariosDeClasesProgramadas h 
    ON cp.idProgramacionClase = h.fkClaseProgramada
INNER JOIN dbo.AspNetUsers au on au.Id = cp.fkEntrenador
WHERE cp.fkEstadoClaseProgramada = 1;
GO
