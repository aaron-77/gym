USE [FitnessCenterDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.sp_obtenerHorariosDisponibles_v6
    @Fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @Fecha = ISNULL(@Fecha, CAST(GETDATE() AS DATE));

    WITH FechasDelMes AS (
        SELECT
            DATEADD(DAY, n.number, DATEFROMPARTS(
                YEAR(@Fecha),
                MONTH(@Fecha),
                1)
            ) AS Fecha
        FROM master.dbo.spt_values n
        WHERE n.type = 'P'
            AND n.number BETWEEN 0 
            AND DATEDIFF(DAY,
                DATEFROMPARTS(YEAR(@Fecha), MONTH(@Fecha), 1),
                EOMONTH(@Fecha)
             )
    )
    SELECT
        DATENAME(dw, f.Fecha) AS DiaDeLaSemana,
        f.Fecha AS FechaDisponible,
        hl.horaInicio,
        hl.horaFin,
        hl.idHora,
        CASE WHEN DATENAME(dw, f.Fecha) IN ('Sábado', 'Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
    FROM FechasDelMes f
    CROSS JOIN dbo.horasLaborales hl
    LEFT JOIN dbo.horariosDeClasesProgramadas hcp ON
        hl.idHora = hcp.fkHorarioLaboral AND
        f.Fecha = hcp.fechaDeLaClase
    LEFT JOIN dbo.preReservasDeHorario pr ON
        hl.idHora = pr.fkHoraLaboral AND
        f.Fecha = pr.fechaReservada AND
        CAST(GETDATE() AS DATE) BETWEEN CAST(pr.fechaInicioDeLaReserva AS DATE) AND CAST(pr.fechaDeExpiracionDeLaReserva AS DATE)
    LEFT JOIN dbo.diasFestivosYDescansos dfd ON
        f.Fecha = dfd.fechaFestivaODescanso
    LEFT JOIN dbo.estadosDeActividadLaboral eal ON
        dfd.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
    LEFT JOIN dbo.diasFestivosVariables dfv ON
        dbo.fn_esDiaFestivoVariableVersionJoin(f.Fecha, dfv.deQueDia, dfv.deQueSemana, dfv.deQueMes, dfv.fkTipoDeRecurrenciaDelFestivo) = 1
    LEFT JOIN dbo.estadosDeActividadLaboral eal2 ON
        dfv.fkEstadoActividadLaboral = eal2.idEstadoActividadLaboral
    WHERE
        hcp.idHorarioDeClaseProgramada IS NULL
        AND pr.idPreReserva IS NULL
        AND (dfd.idDiaFestivo IS NULL OR eal.nombreEstadoActividadLaboral <> 'no se labora')
        AND (dfv.idDiaFestivoVariable IS NULL OR eal2.nombreEstadoActividadLaboral <> 'no se labora')
        AND f.Fecha >= CAST(GETDATE() AS DATE)
    ORDER BY
        f.Fecha,
        hl.horaInicio;
END;
GO
