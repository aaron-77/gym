USE [FitnessCenterDB]
GO

/**********************************************
 Consolidated migration script — aplica los cambios
 - Actualiza funciones que validan existencia usando:
   fkClase, fkEntrenador, fechaDeLaClase y fkHora(s)
 - Agrega columnas a preReservasDeHorario si no existen
 - Actualiza procedimientos críticos:
   sp_registrarClaseProgramada, sp_registrarHorarioDeClaseProgramada, sp_preReservarHorario
NOTA: Este script asume que los tipos tabla como `IdsHorasLaborales` y vistas usadas existen.
Ejecuta en entorno de pruebas antes de producción.
**********************************************/
SET NOCOUNT ON;
GO

-- Asegurar columnas nuevas en preReservasDeHorario
IF COL_LENGTH('dbo.preReservasDeHorario','idClase') IS NULL
BEGIN
    ALTER TABLE dbo.preReservasDeHorario ADD idClase INT NULL;
END
GO

IF COL_LENGTH('dbo.preReservasDeHorario','fechaDeLaClase') IS NULL
BEGIN
    ALTER TABLE dbo.preReservasDeHorario ADD fechaDeLaClase DATE NULL;
END
GO

IF COL_LENGTH('dbo.preReservasDeHorario','idEntrenador') IS NULL
BEGIN
    ALTER TABLE dbo.preReservasDeHorario ADD idEntrenador NVARCHAR(450) NULL;
END
GO

--------------------------------------------------------------------------------
-- FUNCIONES
--------------------------------------------------------------------------------

-- yaExisteClaseProgramada: verifica por fkClase, fkEntrenador, fecha y lista de horas
IF OBJECT_ID('dbo.yaExisteClaseProgramada','FN') IS NOT NULL
    DROP FUNCTION dbo.yaExisteClaseProgramada;
GO

CREATE FUNCTION [dbo].[yaExisteClaseProgramada](
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
            AND hcp.fkEstadoHorarioClase = 1
            AND hcp.fkHorarioLaboral IN (SELECT fkHoraLaboral FROM @fksHorasLaborales)
        WHERE cp.fechaDeLaClase = @fecha
          AND cp.fkClase = @fkClase
          AND (@fkEntrenador IS NULL OR cp.fkEntrenador = @fkEntrenador)
          AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas)
    )
    BEGIN
        SET @yaExiste = 1;
    END;

    RETURN @yaExiste;
END;
GO

-- yaExistePreRegistroDeClase: verifica por idClase, idEntrenador, fecha y lista de horas
IF OBJECT_ID('dbo.yaExistePreRegistroDeClase','FN') IS NOT NULL
    DROP FUNCTION dbo.yaExistePreRegistroDeClase;
GO

CREATE FUNCTION [dbo].[yaExistePreRegistroDeClase](
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

-- fn_obtenerClasesProgramadaPorIdProgramacionClase (usa cp.fechaDeLaClase)
IF OBJECT_ID('dbo.fn_obtenerClasesProgramadaPorIdProgramacionClase','TF') IS NOT NULL
    DROP FUNCTION dbo.fn_obtenerClasesProgramadaPorIdProgramacionClase;
GO

CREATE FUNCTION dbo.fn_obtenerClasesProgramadaPorIdProgramacionClase(@idProgramacionClase INT)
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

-- fn_obtenerClasesProgramadasPorIdClase (usa cp.fechaDeLaClase)
IF OBJECT_ID('dbo.fn_obtenerClasesProgramadasPorIdClase','TF') IS NOT NULL
    DROP FUNCTION dbo.fn_obtenerClasesProgramadasPorIdClase;
GO

CREATE FUNCTION dbo.fn_obtenerClasesProgramadasPorIdClase(@idClase INT)
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

-- ObtenerClasesProgramadas (tabla valor)
IF OBJECT_ID('dbo.ObtenerClasesProgramadas','TF') IS NOT NULL
    DROP FUNCTION dbo.ObtenerClasesProgramadas;
GO

CREATE FUNCTION dbo.ObtenerClasesProgramadas(@IdClase int)
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

PRINT 'FUNCIONES ACTUALIZADAS'
GO

--------------------------------------------------------------------------------
-- PROCEDIMIENTOS CRÍTICOS
--------------------------------------------------------------------------------

-- sp_registrarHorarioDeClaseProgramada: no recibe fkEntrenador
IF OBJECT_ID('dbo.sp_registrarHorarioDeClaseProgramada','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_registrarHorarioDeClaseProgramada;
GO

CREATE PROCEDURE [dbo].[sp_registrarHorarioDeClaseProgramada]
    @fkClaseProgramada INT,
    @fkHorarioLaboral INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral, fkEstadoHorarioClase)
    VALUES (@fkClaseProgramada, @fkHorarioLaboral, 1);  -- 1 = activo por defecto
    SELECT SCOPE_IDENTITY() AS idHorarioDeClaseProgramada;
END;
GO

-- sp_registrarClaseProgramada: inserta fechaDeLaClase y fkEntrenador en clasesProgramadas;
-- registra horarios llamando a sp_registrarHorarioDeClaseProgramada (que ya no recibe fkEntrenador).
IF OBJECT_ID('dbo.sp_registrarClaseProgramada','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_registrarClaseProgramada;
GO

CREATE PROCEDURE [dbo].[sp_registrarClaseProgramada]
    @datos dbo.DatosClaseProgramada READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @idClaseProgramada INT;
        DECLARE @fkClase INT, 
                @fkEntrenador NVARCHAR(450),
                @cupoMaximo INT, 
                @fkEstadoClaseProgramada INT,
                @fkHorarioLaboralString NVARCHAR(MAX),
                @idPreReservaDeHorario INT,
                @fechaDeLaClase DATE;

        -- Extraer datos del parámetro tabla
        SELECT TOP 1 
            @fkClase = fkClase,
            @fkEntrenador = fkEntrenador,
            @cupoMaximo = cupoMaximo,
            @fkEstadoClaseProgramada = fkEstadoClaseProgramada,
            @fkHorarioLaboralString = fkHoraLaboral,
            @idPreReservaDeHorario = idPreservaDeHorario,
            @fechaDeLaClase = fechaDeLaClase
        FROM @datos;

        -- Insertar clase programada con fecha y entrenador
        INSERT INTO clasesProgramadas (
            fkClase, 
            fkEntrenador, 
            cupoMaximo, 
            fkEstadoClaseProgramada,
            fechaDeLaClase
        )
        VALUES (
            @fkClase, @fkEntrenador, @cupoMaximo, @fkEstadoClaseProgramada, @fechaDeLaClase
        );

        SET @idClaseProgramada = SCOPE_IDENTITY();

        -- Si hay horarios en string (coma-separado), registrarlos
        IF @fkHorarioLaboralString IS NOT NULL AND LEN(@fkHorarioLaboralString) > 0
        BEGIN
            DECLARE @horarioId INT;
            DECLARE @posicion INT = 1;
            DECLARE @longitud INT = LEN(@fkHorarioLaboralString);
            DECLARE @valorActual VARCHAR(50);

            WHILE @posicion <= @longitud
            BEGIN
                SET @valorActual = '';
                WHILE @posicion <= @longitud AND SUBSTRING(@fkHorarioLaboralString, @posicion, 1) != ','
                BEGIN
                    SET @valorActual = @valorActual + SUBSTRING(@fkHorarioLaboralString, @posicion, 1);
                    SET @posicion = @posicion + 1;
                END

                IF SUBSTRING(@fkHorarioLaboralString, @posicion, 1) = ','
                    SET @posicion = @posicion + 1;

                IF ISNUMERIC(@valorActual) = 1 AND LEN(@valorActual) > 0
                BEGIN
                    SET @horarioId = CAST(@valorActual AS INT);

                    -- Registrar horario (procedimiento ya no requiere fkEntrenador)
                    EXEC sp_registrarHorarioDeClaseProgramada 
                        @fkClaseProgramada = @idClaseProgramada,
                        @fkHorarioLaboral = @horarioId;
                END
            END
        END

        -- Limpiar pre-reserva si existe
        IF @idPreReservaDeHorario IS NOT NULL
        BEGIN
            DELETE FROM preReservasDeHorario 
            WHERE idPreReserva = @idPreReservaDeHorario;
        END

        COMMIT TRANSACTION;
        SELECT @idClaseProgramada AS IdClaseProgramada;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        DECLARE 
            @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
            @ErrorNumber INT = ERROR_NUMBER(),
            @ErrorSeverity INT = ERROR_SEVERITY(),
            @ErrorState INT = ERROR_STATE(),
            @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
            @ErrorLine INT = ERROR_LINE();

        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorNumber,
            @ErrorSeverity,
            @ErrorState,
            @ErrorMessage,
            @ErrorLine;

        THROW;
    END CATCH
END;
GO

-- sp_preReservarHorario: ya no usa bloqueo; valida existencia con funciones y guarda idClase, fechaDeLaClase, idEntrenador
IF OBJECT_ID('dbo.sp_preReservarHorario','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_preReservarHorario;
GO

CREATE PROCEDURE [dbo].[sp_preReservarHorario]
    @idUsuarioQueReserva nvarchar(450),
    @fechaTentativa date,
    @idHoraLaboral int,
    @idClase int = NULL,
    @idEntrenador nvarchar(450) = NULL,
    @idPrereservaOut int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    DECLARE @idsHoraLaborales IdsHorasLaborales;
    INSERT INTO @idsHoraLaborales(fkHoraLaboral) VALUES(@idHoraLaboral);

    BEGIN TRY
        -- Verificar que no exista ya una clase programada para la combinación
        IF dbo.yaExisteClaseProgramada(@idClase, @idEntrenador, @fechaTentativa, @idsHoraLaborales) = 1
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('Ya existe una clase programada para esa combinación (clase, fecha, hora, entrenador)',16,1);
            RETURN;
        END

        -- Verificar que no exista ya una pre-reserva vigente para la combinación
        IF dbo.yaExistePreRegistroDeClase(@idClase, @idEntrenador, @fechaTentativa, @idsHoraLaborales) = 1
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('Ya existe una pre-reserva vigente para esa combinación (clase, fecha, hora, entrenador)',16,1);
            RETURN;
        END

        -- Insertar pre-reserva (incluye idClase, fechaDeLaClase, idEntrenador)
        INSERT INTO preReservasDeHorario (
            fkHoraLaboral,
            idUsuarioQueReserva,
            fechaReservada,
            fechaInicioDeLaReserva,
            fechaDeExpiracionDeLaReserva,
            idClase,
            fechaDeLaClase,
            idEntrenador
        )
        VALUES (
            @idHoraLaboral,
            @idUsuarioQueReserva,
            @fechaTentativa,
            GETDATE(),
            DATEADD(MINUTE, 5, GETDATE()),
            @idClase,
            @fechaTentativa,
            @idEntrenador
        );

        SET @idPrereservaOut = SCOPE_IDENTITY();
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        
       IF ERROR_NUMBER() IN (2627, 2601) -- unique constraint / duplicate key
        BEGIN
            RAISERROR('Ya existe una pre-reserva duplicada (constraint unique violada).',16,1);
            RETURN;
        END
        
        ;THROW 50002, 'Ya existe una pre-reserva vigente para esa combinación (clase, fecha, hora, entrenador)', 1;
       
     
        
    END CATCH
END;
GO

PRINT 'PROCEDIMIENTOS ACTUALIZADOS'
GO

--------------------------------------------------------------------------------
-- FIN
--------------------------------------------------------------------------------

PRINT 'MIGRACION COMPLETA (funciones + procedimientos + DDL columnas añadidas)'
GO
