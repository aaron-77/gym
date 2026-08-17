-- ============================================================
-- Script de prueba: registro rápido de clases programadas
-- ============================================================
-- Uso: ajustar las variables de la sección CONFIGURACIÓN y ejecutar.
-- Crea N clases programadas con un horario laboral cada una.
-- Resuelve automáticamente clase, entrenador y hora si se dejan NULL.

USE FitnessCenterDB;
GO

SET NOCOUNT ON;

-- ============================================================
-- CONFIGURACIÓN
-- ============================================================
DECLARE @CantidadClases INT = 5;                              -- Cuántas clases crear
DECLARE @FechaInicio DATE = DATEADD(day, 1, CAST(GETDATE() AS DATE)); -- Fecha de la primera clase (mañana por defecto)
DECLARE @IntervaloDias INT = 1;                               -- 1 = diario, 7 = semanal
DECLARE @fkClase INT = NULL;                                  -- NULL = primera clase activa
DECLARE @fkEntrenador NVARCHAR(450) = NULL;                   -- NULL = primer empleado/entrenador activo
DECLARE @fkEstadoClaseProgramada INT = 1;                     -- 1 = disponible
DECLARE @cupoMaximo INT = 20;                                 -- Cupo máximo por clase
DECLARE @fkHoraLaboral INT = NULL;                            -- NULL = primera hora laboral

-- ============================================================
-- VALIDACIÓN DE PARÁMETROS
-- ============================================================
IF @CantidadClases <= 0
BEGIN
    PRINT 'Error: @CantidadClases debe ser mayor a 0';
    RETURN;
END

-- ============================================================
-- RESOLUCIÓN AUTOMÁTICA DE IDS
-- ============================================================

-- Clase
IF @fkClase IS NULL
BEGIN
    SELECT TOP 1 @fkClase = ClaseID
    FROM FitnessCenterDB.dbo.Clases
    WHERE fkEstadoClase = 1;

    IF @fkClase IS NULL
    BEGIN
        PRINT 'Error: No se encontró ninguna clase activa (fkEstadoClase = 1)';
        RETURN;
    END

    PRINT 'Clase resuelta automáticamente: ' + CAST(@fkClase AS VARCHAR(20));
END

-- Entrenador (primero empleado, fallback entrenador)
IF @fkEntrenador IS NULL
BEGIN
    SELECT TOP 1 @fkEntrenador = u.Id
    FROM FitnessCenterDB.dbo.AspNetUsers u
        INNER JOIN FitnessCenterDB.dbo.AspNetUserRoles ur ON u.Id = ur.UserId
        INNER JOIN FitnessCenterDB.dbo.AspNetRoles r ON ur.RoleId = r.Id
    WHERE r.Name = 'empleado'
      AND u.Estado = 'Activo';

    IF @fkEntrenador IS NULL
    BEGIN
        SELECT TOP 1 @fkEntrenador = u.Id
        FROM FitnessCenterDB.dbo.AspNetUsers u
            INNER JOIN FitnessCenterDB.dbo.AspNetUserRoles ur ON u.Id = ur.UserId
            INNER JOIN FitnessCenterDB.dbo.AspNetRoles r ON ur.RoleId = r.Id
        WHERE r.Name = 'entrenador'
          AND u.Estado = 'Activo';
    END

    IF @fkEntrenador IS NULL
    BEGIN
        PRINT 'Error: No se encontró ningún empleado/entrenador activo';
        RETURN;
    END

    PRINT 'Entrenador resuelto automáticamente: ' + @fkEntrenador;
END

-- Hora laboral
IF @fkHoraLaboral IS NULL
BEGIN
    SELECT TOP 1 @fkHoraLaboral = idHora
    FROM FitnessCenterDB.dbo.horasLaborales
    ORDER BY idHora;

    IF @fkHoraLaboral IS NULL
    BEGIN
        PRINT 'Error: No se encontró ninguna hora laboral';
        RETURN;
    END

    PRINT 'Hora laboral resuelta automáticamente: ' + CAST(@fkHoraLaboral AS VARCHAR(20));
END

-- ============================================================
-- INSERCIÓN EN BUCLE
-- ============================================================
DECLARE @i INT = 1;
DECLARE @fechaClase DATE;
DECLARE @idProgramacionClase INT;
DECLARE @idPrimeraClaseCreada INT = NULL;

BEGIN TRY
    BEGIN TRANSACTION;

    WHILE @i <= @CantidadClases
    BEGIN
        SET @fechaClase = DATEADD(day, (@i - 1) * @IntervaloDias, @FechaInicio);

        INSERT INTO FitnessCenterDB.dbo.clasesProgramadas
        (
            fkClase,
            fkEntrenador,
            cupoMaximo,
            fkEstadoClaseProgramada,
            fechaDeLaClase
        )
        VALUES
        (
            @fkClase,
            @fkEntrenador,
            @cupoMaximo,
            @fkEstadoClaseProgramada,
            @fechaClase
        );

        SET @idProgramacionClase = SCOPE_IDENTITY();

        IF @idPrimeraClaseCreada IS NULL
            SET @idPrimeraClaseCreada = @idProgramacionClase;

        INSERT INTO FitnessCenterDB.dbo.horariosDeClasesProgramadas
        (
            fkClaseProgramada,
            fkHorarioLaboral
        )
        VALUES
        (
            @idProgramacionClase,
            @fkHoraLaboral
        );

        PRINT 'Creada clase programada ID ' + CAST(@idProgramacionClase AS VARCHAR(20)) 
            + ' para fecha ' + CONVERT(VARCHAR(10), @fechaClase, 120);

        SET @i = @i + 1;
    END

    COMMIT TRANSACTION;

    PRINT '------------------------------------------------';
    PRINT CAST(@CantidadClases AS VARCHAR(20)) + ' clases programadas creadas correctamente.';
    PRINT 'Rango de IDs: ' + CAST(@idPrimeraClaseCreada AS VARCHAR(20)) + ' - ' + CAST(@idProgramacionClase AS VARCHAR(20));
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT 'Error al crear clases programadas:';
    PRINT ERROR_MESSAGE();
    THROW;
END CATCH;

-- ============================================================
-- VERIFICACIÓN
-- ============================================================
SELECT
    cp.idProgramacionClase,
    cp.fkClase,
    cp.fkEntrenador,
    cp.cupoMaximo,
    cp.fkEstadoClaseProgramada,
    cp.fechaDeLaClase,
    hcp.fkHorarioLaboral,
    hl.horaInicio,
    hl.horaFin
FROM FitnessCenterDB.dbo.clasesProgramadas cp
    INNER JOIN FitnessCenterDB.dbo.horariosDeClasesProgramadas hcp
        ON cp.idProgramacionClase = hcp.fkClaseProgramada
    INNER JOIN FitnessCenterDB.dbo.horasLaborales hl
        ON hcp.fkHorarioLaboral = hl.idHora
WHERE cp.idProgramacionClase BETWEEN @idPrimeraClaseCreada AND @idProgramacionClase
ORDER BY cp.idProgramacionClase;
