CREATE   PROCEDURE dbo.sp_obtenerHorariosDisponibles
    @Fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Si no se proporciona fecha, usar la fecha actual
    SET @Fecha = ISNULL(@Fecha, GETDATE());
    print 'fecha del parametro '+ cast(@Fecha as nvarchar(50));
   print 'rango de fechas considerado  '+' 0 '+ 
   cast(DATEDIFF(DAY,DATEFROMPARTS(YEAR(@Fecha), MONTH(@Fecha), 1),EOMONTH(@Fecha)) as nvarchar(100));
    -- Generar todas las fechas del mes
    WITH FechasDelMes AS (
        SELECT
            DATEADD(DAY, n.number, DATEFROMPARTS(
                YEAR(@Fecha),
                MONTH(@Fecha),
                1)
            ) AS Fecha
        FROM
            master.dbo.spt_values n
        WHERE
            n.type = 'P'
            AND n.number BETWEEN 0 
            AND DATEDIFF(DAY,
                DATEFROMPARTS(YEAR(@Fecha), MONTH(@Fecha), 1),
                EOMONTH(@Fecha
             )
            )
    )
    SELECT
        DATENAME(dw, f.Fecha) AS DiaDeLaSemana,
        f.Fecha AS FechaDisponible,
        hl.horaInicio,
        hl.horaFin,
        hl.idHora,
        CASE WHEN DATENAME(dw, f.Fecha) IN ('Sábado', 'Domingo') THEN 'Fin de Semana' ELSE 'Día Laboral' END AS TipoDeDia
    FROM
        FechasDelMes f
    CROSS JOIN dbo.horasLaborales hl
    -- Excluir las horas que están en horarios de clases programadas para esa fecha
    LEFT JOIN dbo.horariosDeClasesProgramadas hcp ON
        hl.idHora = hcp.fkHorarioLaboral AND
        f.Fecha = hcp.fechaDeLaClase
    -- Excluir las horas que están pre-reservadas para esa fecha
    LEFT JOIN dbo.preReservasDeHorario pr ON
        hl.idHora = pr.fkHoraLaboral AND
        f.Fecha = pr.fechaReservada AND
        GETDATE() BETWEEN pr.fechaInicioDeLaReserva AND pr.fechaDeExpiracionDeLaReserva
    -- Excluir los días festivos y descansos fijos
    LEFT JOIN dbo.diasFestivosYDescansos dfd ON
        f.Fecha = dfd.fechaFestivaODescanso
    LEFT JOIN dbo.estadosDeActividadLaboral eal ON
        dfd.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
    -- Verificación para días festivos variables usando la función fn_esDiaFestivoVariable
    LEFT JOIN dbo.diasFestivosVariables dfv ON
        dbo.fn_esDiaFestivoVariableVersionJoin(f.Fecha, dfv.deQueDia, dfv.deQueSemana, dfv.deQueMes, dfv.fkTipoDeRecurrenciaDelFestivo) = 1
    LEFT JOIN dbo.estadosDeActividadLaboral eal2 ON
        dfv.fkEstadoActividadLaboral = eal2.idEstadoActividadLaboral
    WHERE
        -- No existe en horariosDeClasesProgramadas
        hcp.idHorarioDeClaseProgramada IS NULL
        -- No existe en preReservasDeHorario vigentes
        AND pr.idPreReserva IS NULL
        -- No es día festivo o de descanso fijo con estado "no se labora"
        AND (dfd.idDiaFestivo IS NULL OR eal.nombreEstadoActividadLaboral <> 'no se labora')
        -- No es día festivo variable con estado "no se labora"
        AND (dfv.idDiaFestivoVariable IS NULL OR eal2.nombreEstadoActividadLaboral <> 'no se labora')
        -- La fecha no es anterior a la fecha actual
        AND f.Fecha >= CAST(GETDATE() AS DATE)
    ORDER BY
        f.Fecha,
        hl.horaInicio;
END;
