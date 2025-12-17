USE [FitnessCenterDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Modified (v6) stored procedure: compute available slots using EXCEPT against occupied sets
CREATE OR ALTER PROCEDURE dbo.sp_obtenerHorariosDisponibles_v6
    @Fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @Fecha = ISNULL(@Fecha, CAST(GETDATE() AS DATE));

    -- Build calendar dates for the month
    WITH FechasDelMes AS (
        SELECT
            DATEADD(DAY, n.number, DATEFROMPARTS(YEAR(@Fecha), MONTH(@Fecha), 1)) AS Fecha
        FROM master.dbo.spt_values n
        WHERE n.type = 'P'
          AND n.number BETWEEN 0 AND DATEDIFF(DAY, DATEFROMPARTS(YEAR(@Fecha), MONTH(@Fecha), 1), EOMONTH(@Fecha))
    ),

    -- All possible slots: every date x every work hour
    AllSlots AS (
        SELECT
            f.Fecha,
            hl.idHora,
            hl.horaInicio,
            hl.horaFin,
            CASE WHEN DATENAME(dw, f.Fecha) IN ('Sábado','Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
        FROM FechasDelMes f
        CROSS JOIN dbo.horasLaborales hl
        WHERE f.Fecha >= CAST(GETDATE() AS DATE)
    ),

    -- Slots occupied by scheduled classes (use clasesProgramadas.fechaDeLaClase)
    OccupiedByProgramadas AS (
        SELECT DISTINCT
            cp.fechaDeLaClase AS Fecha,
            hl.idHora,
            hl.horaInicio,
            hl.horaFin,
            CASE WHEN DATENAME(dw, cp.fechaDeLaClase) IN ('Sábado','Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
        FROM dbo.horariosDeClasesProgramadas hcp
        INNER JOIN dbo.clasesProgramadas cp ON hcp.fkClaseProgramada = cp.idProgramacionClase
        INNER JOIN dbo.horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
        WHERE cp.fechaDeLaClase IS NOT NULL AND cp.fechaDeLaClase >= @Fecha
    ),

    -- Slots occupied by active pre-reservations
    OccupiedByPreReservas AS (
        SELECT DISTINCT
            pr.fechaReservada AS Fecha,
            hl.idHora,
            hl.horaInicio,
            hl.horaFin,
            CASE WHEN DATENAME(dw, pr.fechaReservada) IN ('Sábado','Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
        FROM dbo.preReservasDeHorario pr
        INNER JOIN dbo.horasLaborales hl ON pr.fkHoraLaboral = hl.idHora
        WHERE CAST(GETDATE() AS DATE) BETWEEN CAST(pr.fechaInicioDeLaReserva AS DATE) AND CAST(pr.fechaDeExpiracionDeLaReserva AS DATE)
    ),

    -- Slots disabled by fixed holidays / rest days
    OccupiedByFixedHolidays AS (
        SELECT DISTINCT
            dfd.fechaFestivaODescanso AS Fecha,
            hl.idHora,
            hl.horaInicio,
            hl.horaFin,
            CASE WHEN DATENAME(dw, dfd.fechaFestivaODescanso) IN ('Sábado','Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
        FROM dbo.diasFestivosYDescansos dfd
        INNER JOIN dbo.estadosDeActividadLaboral eal ON dfd.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
        CROSS JOIN dbo.horasLaborales hl
        WHERE eal.nombreEstadoActividadLaboral = 'no se labora'
    ),

    -- Slots disabled by variable holidays (evaluated per date)
    OccupiedByVariableHolidays AS (
        SELECT DISTINCT
            f.Fecha AS Fecha,
            hl.idHora,
            hl.horaInicio,
            hl.horaFin,
            CASE WHEN DATENAME(dw, f.Fecha) IN ('Sábado','Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
        FROM FechasDelMes f
        INNER JOIN dbo.diasFestivosVariables dfv ON dbo.fn_esDiaFestivoVariableVersionJoin(f.Fecha, dfv.deQueDia, dfv.deQueSemana, dfv.deQueMes, dfv.fkTipoDeRecurrenciaDelFestivo) = 1
        INNER JOIN dbo.estadosDeActividadLaboral eal2 ON dfv.fkEstadoActividadLaboral = eal2.idEstadoActividadLaboral
        CROSS JOIN dbo.horasLaborales hl
        WHERE eal2.nombreEstadoActividadLaboral = 'no se labora'
    ),

    OccupiedSlots AS (
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM OccupiedByProgramadas
        UNION
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM OccupiedByPreReservas
        UNION
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM OccupiedByFixedHolidays
        UNION
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM OccupiedByVariableHolidays
    )

    -- Return all slots except those occupied
    SELECT
        DATENAME(dw, s.Fecha) AS DiaDeLaSemana,
        s.Fecha AS FechaDisponible,
        s.horaInicio,
        s.horaFin,
        s.idHora,
        s.TipoDeDia
    FROM (
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM AllSlots
        EXCEPT
        SELECT Fecha, idHora, horaInicio, horaFin, TipoDeDia FROM OccupiedSlots
    ) s
    ORDER BY s.Fecha, s.horaInicio;
END;
GO
