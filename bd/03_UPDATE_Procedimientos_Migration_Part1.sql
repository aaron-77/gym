USE [FitnessCenterDB]
GO

/****** PASO 3: ACTUALIZAR PROCEDIMIENTOS ALMACENADOS ******/
/****** Cambios por migración de fechaDeLaClase a clasesProgramadas ******/

-- =============================================
-- Procedimiento: buscarClaseProgramadas
-- Descripción: Busca clases programadas con filtros
-- Cambio: Usa cp.fechaDeLaClase en lugar de hcp.fechaDeLaClase
-- =============================================
ALTER PROCEDURE [dbo].[buscarClaseProgramadas]
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
        h.horaInicio,
        h.horaFin
    FROM clasesProgramadas cp
    INNER JOIN Clases c ON cp.fkClase = c.ClaseID
    INNER JOIN AspNetUsers u ON cp.fkEntrenador = u.Id
    INNER JOIN horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
    INNER JOIN horasLaborales h ON hcp.fkHorarioLaboral = h.idHora
    WHERE
        (@idClase IS NULL OR cp.fkClase = @idClase) AND
        (@idEntrenador IS NULL OR cp.fkEntrenador = @idEntrenador) AND
        (@idHoraLaboral IS NULL OR hcp.fkHorarioLaboral = @idHoraLaboral) AND
        (@fecha IS NULL OR cp.fechaDeLaClase = @fecha);
END;
GO

-- =============================================
-- Procedimiento: sp_cancelarClasesProgramadas
-- Descripción: Cancela clases programadas según filtros
-- Cambio: Usa cp.fechaDeLaClase en lugar de hcp.fechaDeLaClase
-- =============================================
ALTER PROCEDURE [dbo].[sp_cancelarClasesProgramadas]
    @idClaseProgramada int = null,
    @fechaDeReferencia DATE = null,
    @idEntrenador nvarchar(450) = null,
    @idClase int = null
AS
BEGIN
    SET NOCOUNT ON;
    declare @idsClasesCanceladas ListadoIdsGenericos;
    
    if @fechaDeReferencia is null
        set @fechaDeReferencia = GETDATE();
   
    IF @idClaseProgramada is not null
    BEGIN
        insert into @idsClasesCanceladas(id)
        select idProgramacionClase 
        from clasesProgramadas cp 
        WHERE cp.fkEstadoClaseProgramada = (select idEstadoClaseProgramada from v_idEstadoDisponibleClasesProgramadas)
            and cp.idProgramacionClase = @idClaseProgramada
    END
    ELSE
    BEGIN
        IF @fechaDeReferencia = GETDATE() and @idEntrenador is null and @idClase is null
        BEGIN
            PRINT 'FECHA POR DEFECTO';
            insert into @idsClasesCanceladas
            select idProgramacionClase  
            from clasesProgramadas cp	
            where cp.fechaDeLaClase >= @fechaDeReferencia 
                and cp.fkEstadoClaseProgramada = (select idEstadoClaseProgramada from v_idEstadoDisponibleClasesProgramadas)
        END
        ELSE 
        BEGIN
            PRINT 'FECHA CUSTOM'+CAST(@fechaDeReferencia as nvarchar(20));
            insert into @idsClasesCanceladas
            select idProgramacionClase  
            from clasesProgramadas cp	
            where 
                ((@fechaDeReferencia is null or cp.fechaDeLaClase = @fechaDeReferencia)
                    and (@idEntrenador is null or cp.fkEntrenador = @idEntrenador)
                    and (@idClase is null or cp.fkClase = @idClase))
                and cp.fkEstadoClaseProgramada = (select idEstadoClaseProgramada from v_idEstadoDisponibleClasesProgramadas)
        END
    END
   
    if not exists (select 1 from @idsClasesCanceladas)
    begin
        THROW 51000, 'No se encontraron clases activas para cancelar', 1;
    end
    
    -- Actualizar el estado de las clases programadas a 'Cancelada'
    UPDATE clasesProgramadas
    SET fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM estadosClasesProgramadas WHERE nombresEstado = 'cancelada')
    WHERE idProgramacionClase in (select * from @idsClasesCanceladas);

    select * from @idsClasesCanceladas;
END;
GO

-- =============================================
-- Procedimiento: sp_obtenerEntrenadoresDisponibles
-- Descripción: Obtiene entrenadores disponibles para una fecha
-- Cambio: Usa cp.fechaDeLaClase en lugar de hcp.fechaDeLaClase
-- =============================================
ALTER PROCEDURE [dbo].[sp_obtenerEntrenadoresDisponibles]
(
    @fechaReferencia datetime2
)
AS
BEGIN
    DECLARE @rolEmpleadoId nvarchar(450);
    SELECT @rolEmpleadoId = Id FROM AspNetRoles WHERE Name = 'Empleado';

    SELECT DISTINCT
        u.Id AS UsuarioID,
        u.NombreCompleto AS Nombre,
        u.Apellido AS Apellido,
        u.Email,
        u.PhoneNumber AS Telefono,
        u.UserName AS NombreUsuario,
        u.FechaDeNacimiento as FechaNacimiento,
        u.FechaDeRegistro as FechaRegistro,
        ar.Id AS RolID,
        u.Estado
    FROM AspNetUsers AS u
    INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId
    INNER JOIN AspNetRoles ar ON ur.RoleId = ar.Id
    WHERE ar.Id = @rolEmpleadoId AND u.Estado = 'Activo'
    AND u.Id NOT IN (
        SELECT cp.fkEntrenador
        FROM clasesProgramadas cp
        WHERE CAST(cp.fechaDeLaClase AS DATE) = CAST(@fechaReferencia AS DATE)
    );
END;
GO

-- =============================================
-- Procedimiento: sp_obtenerHorariosDisponibles
-- Descripción: Obtiene horarios disponibles para una fecha
-- Cambio: Usa cp.fechaDeLaClase en lugar de hcp.fechaDeLaClase
-- =============================================
ALTER PROCEDURE [dbo].[sp_obtenerHorariosDisponibles]
    @Fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SET @Fecha = ISNULL(@Fecha, GETDATE());
    print 'fecha del parametro '+ cast(@Fecha as nvarchar(50));
    print 'rango de fechas considerado  '+' 0 '+ 
        cast(DATEDIFF(DAY,DATEFROMPARTS(YEAR(@Fecha), MONTH(@Fecha), 1),EOMONTH(@Fecha)) as nvarchar(100));
    
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
    FROM
        FechasDelMes f
    CROSS JOIN horasLaborales hl
    -- Excluir las horas que están en horarios de clases programadas para esa fecha
    LEFT JOIN clasesProgramadas cp ON f.Fecha = cp.fechaDeLaClase
    LEFT JOIN horariosDeClasesProgramadas hcp ON
        hl.idHora = hcp.fkHorarioLaboral AND cp.idProgramacionClase = hcp.fkClaseProgramada
    -- Excluir las horas que están pre-reservadas para esa fecha
    LEFT JOIN preReservasDeHorario pr ON
        hl.idHora = pr.fkHoraLaboral AND
        f.Fecha = pr.fechaDeLaClase AND
        GETDATE() BETWEEN pr.fechaInicioDeLaReserva AND pr.fechaDeExpiracionDeLaReserva
    -- Excluir los días festivos y descansos fijos
    LEFT JOIN diasFestivosYDescansos dfd ON
        f.Fecha = dfd.fechaFestivaODescanso
    LEFT JOIN estadosDeActividadLaboral eal ON
        dfd.fkEstadoActividadLaboral = eal.idEstadoActividadLaboral
    -- Verificación para días festivos variables
    LEFT JOIN diasFestivosVariables dfv ON
        dbo.fn_esDiaFestivoVariableVersionJoin(f.Fecha, dfv.deQueDia, dfv.deQueSemana, dfv.deQueMes, dfv.fkTipoDeRecurrenciaDelFestivo) = 1
    LEFT JOIN estadosDeActividadLaboral eal2 ON
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
GO

PRINT '========================================='
PRINT 'PROCEDIMIENTOS ALMACENADOS (Parte 1) ACTUALIZADOS'
PRINT '========================================='
GO
