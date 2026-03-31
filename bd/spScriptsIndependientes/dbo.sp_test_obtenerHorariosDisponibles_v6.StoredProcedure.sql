USE [FitnessCenterDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Test procedure for sp_obtenerHorariosDisponibles_v6
-- Executes the v6 procedure and returns a summary and sample rows
CREATE OR ALTER PROCEDURE dbo.sp_test_obtenerHorariosDisponibles_v6
(
    @Fecha DATE = NULL,
    @Top INT = 50
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Temp table matching the columns returned by sp_obtenerHorariosDisponibles_v6
    CREATE TABLE #Horarios(
        DiaDeLaSemana NVARCHAR(50),
        FechaDisponible DATE,
        horaInicio TIME(7),
        horaFin TIME(7),
        idHora INT,
        TipoDeDia NVARCHAR(50)
    );

    -- Insert results from the v6 procedure
    INSERT INTO #Horarios(DiaDeLaSemana, FechaDisponible, horaInicio, horaFin, idHora, TipoDeDia)
    EXEC dbo.sp_obtenerHorariosDisponibles_v6 @Fecha = @Fecha;

    -- Return summary
    SELECT COUNT(1) AS TotalAvailableSlots FROM #Horarios;

    -- Return sample rows
    SELECT TOP(@Top) *
    FROM #Horarios
    ORDER BY FechaDisponible, horaInicio;

    DROP TABLE #Horarios;
END;
GO
