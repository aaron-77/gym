USE [FitnessCenterDB]
GO

/****** PASO 2: ACTUALIZAR FUNCIONES ******/
/****** Cambios por migración de fechaDeLaClase a clasesProgramadas ******/

-- =============================================
-- Función: yaExisteClaseProgramada
-- Descripción: Verifica si existe clase programada en una fecha/hora específica
-- Cambio: Ahora usa fkClase, fkEntrenador, fechaDeLaClase y fkHorario(s)
-- =============================================
ALTER FUNCTION [dbo].[yaExisteClaseProgramada](
    @fkClase INT,
    @fkEntrenador NVARCHAR(450),
    @fecha DATE,
    @fksHorasLaborales IdsHorasLaborales READONLY
)
RETURNS BIT
AS
BEGIN
    DECLARE @yaExiste BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM clasesProgramadas cp
        INNER JOIN horariosDeClasesProgramadas hcp 
            ON cp.idProgramacionClase = hcp.fkClaseProgramada
            AND hcp.fkEstadoHorarioClase = 1  -- estado activo
            AND hcp.fkHorarioLaboral IN (SELECT fkHoraLaboral FROM @fksHorasLaborales)
        WHERE cp.fechaDeLaClase = @fecha
          AND cp.fkClase = @fkClase
          AND ( cp.fkEntrenador = @fkEntrenador )
          AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas)
    )
    BEGIN
        SET @yaExiste = 1;
    END;

    RETURN @yaExiste;
END;
GO

-- =============================================
-- Función: yaExistePreRegistroDeClase
-- Descripción: Verifica si existe pre-registro en una fecha/hora específica
-- Cambio: Ahora usa idClase, idEntrenador, fechaDeLaClase y fkHorario(s)
-- =============================================
ALTER FUNCTION [dbo].[yaExistePreRegistroDeClase](
    @idClase INT,
    @idEntrenador NVARCHAR(450),
    @fechaReservada DATE,
    @fksHorasLaborales IdsHorasLaborales READONLY
)
RETURNS BIT
AS
BEGIN
    DECLARE @yaExiste BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM preReservasDeHorario pr
        WHERE pr.fechaDeLaClase = @fechaReservada
            AND pr.fkHoraLaboral IN (SELECT fkHoraLaboral FROM @fksHorasLaborales)
            AND (@idClase IS NULL OR pr.idClase = @idClase)
            AND (@idEntrenador IS NULL OR pr.idEntrenador = @idEntrenador)
            AND GETDATE() BETWEEN pr.fechaInicioDeLaReserva AND pr.fechaDeExpiracionDeLaReserva
    )
    BEGIN
        SET @yaExiste = 1;
    END;

    RETURN @yaExiste;
END;
GO

-- =============================================
-- Función: fn_obtenerClasesProgramadaPorIdProgramacionClase
-- Descripción: Obtiene detalles de clase programada
-- Cambio: Usa cp.fechaDeLaClase en lugar de hcp.fechaDeLaClase
-- =============================================
ALTER FUNCTION [dbo].[fn_obtenerClasesProgramadaPorIdProgramacionClase](@idProgramacionClase INT)
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
    FROM clasesProgramadas cp
    INNER JOIN horariosDeClasesProgramadas hcp 
        ON cp.idProgramacionClase = hcp.fkClaseProgramada
    INNER JOIN horasLaborales hl 
        ON hcp.fkHorarioLaboral = hl.idHora
    LEFT JOIN AspNetUsers u 
        ON cp.fkEntrenador = u.Id
    WHERE cp.idProgramacionClase = @idProgramacionClase
);
GO

-- =============================================
-- Función: fn_obtenerClasesProgramadasPorIdClase
-- Descripción: Obtiene clases programadas de una clase específica
-- Cambio: Usa cp.fechaDeLaClase en lugar de hcp.fechaDeLaClase
-- =============================================
ALTER FUNCTION [dbo].[fn_obtenerClasesProgramadasPorIdClase](@idClase INT)
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
);
GO

-- =============================================
-- Función: ObtenerClasesProgramadas
-- Descripción: Obtiene clases programadas de una clase específica con filtro de año
-- Cambio: Usa cp.fechaDeLaClase en lugar de hcp.fechaDeLaClase
-- =============================================
ALTER FUNCTION [dbo].[ObtenerClasesProgramadas](@IdClase int)
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
GO

PRINT '========================================='
PRINT 'FUNCIONES ACTUALIZADAS EXITOSAMENTE'
PRINT '========================================='
GO
