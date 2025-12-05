USE [FitnessCenterDB]
GO

/****** PASO 3 (PARTE 2): PROCEDIMIENTOS CRÍTICOS *******/

-- Asegurar que la tabla preReservasDeHorario contiene las columnas requeridas: idClase, fechaDeLaClase, idEntrenador
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

-- =============================================
-- Procedimiento: sp_registrarClaseProgramada
-- Descripción: Registra nueva clase programada
-- CRÍTICO CAMBIO: 
--   - Inserta fechaDeLaClase en clasesProgramadas
--   - Inserta fkEntrenador en clasesProgramadas
--   - NO inserta en horariosDeClasesProgramadas
-- =============================================
ALTER PROCEDURE [dbo].[sp_registrarClaseProgramada]
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

        PRINT N'2/14 registrando clase programada con fechaDeLaClase';
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

        PRINT N'3/14 clase programada registrada correctamente';
        SET @idClaseProgramada = SCOPE_IDENTITY();

        -- Si hay datos de horarios, registrarlos
        IF @fkHorarioLaboralString IS NOT NULL AND LEN(@fkHorarioLaboralString) > 0
        BEGIN
            PRINT N'4/14 se encontraron horarios laborales';
            DECLARE @horarioId INT;
            DECLARE @posicion INT = 1;
            DECLARE @longitud INT = LEN(@fkHorarioLaboralString);
            DECLARE @valorActual VARCHAR(20);
            
            WHILE @posicion <= @longitud
            BEGIN
                PRINT N'5/14 empieza bucle conversor de horarios laborales';
                
                SET @valorActual = '';
                WHILE @posicion <= @longitud AND SUBSTRING(@fkHorarioLaboralString, @posicion, 1) != ','
                BEGIN
                    SET @valorActual = @valorActual + SUBSTRING(@fkHorarioLaboralString, @posicion, 1);
                    SET @posicion = @posicion + 1;
                END

                SET @posicion = @posicion + 1;
                    
                PRINT N'6/14 determinando validez del horario';

                IF ISNUMERIC(@valorActual) = 1
                BEGIN
                    PRINT N'7/14 id hora laboral correcto';
                    SET @horarioId = CAST(@valorActual AS INT);             
                    
                    PRINT N'8/14 registrando horario';
                    -- No se pasa fkEntrenador al procedimiento de registro de horario
                    EXEC sp_registrarHorarioDeClaseProgramada 
                        @fkClaseProgramada = @idClaseProgramada,
                        @fkHorarioLaboral = @horarioId;

                    PRINT N'9/14 horario registrado correctamente';
                END
            END
        END

        -- Limpiar pre-reserva si existe
        IF @idPreReservaDeHorario IS NOT NULL
        BEGIN
            DELETE FROM preReservasDeHorario 
            WHERE idPreReserva = @idPreReservaDeHorario;
        END

        PRINT N'10/14 transacción completada correctamente';
        COMMIT TRANSACTION;

        SELECT @idClaseProgramada AS IdClaseProgramada;

    END TRY
    BEGIN CATCH
        PRINT N'11/14 excepción capturada';
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
    
        DECLARE 
        @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
        @ErrorNumber INT = ERROR_NUMBER(),
        @ErrorSeverity INT = ERROR_SEVERITY(),
        @ErrorState INT = ERROR_STATE(),
        @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
        @ErrorLine INT = ERROR_LINE(); 

        PRINT N'12/14 registrando log de error';
        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorNumber,
            @ErrorSeverity,
            @ErrorState,
            @ErrorMessage,
            @ErrorLine;

        PRINT N'13/14 error registrado correctamente';
        PRINT N'14/14 relanzando THROW'; 
        THROW;
    END CATCH
END;
GO

-- =============================================
-- Procedimiento: sp_registrarHorarioDeClaseProgramada
-- Descripción: Registra horario de clase programada
-- CAMBIO: 
--   - NO recibe ni inserta fechaDeLaClase
--   - NO recibe ni inserta fkEntrenador
--   - Estos datos ya están en clasesProgramadas
-- =============================================
ALTER PROCEDURE [dbo].[sp_registrarHorarioDeClaseProgramada]
    @fkClaseProgramada INT,
    @fkHorarioLaboral INT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral, fkEstadoHorarioClase)
    VALUES (@fkClaseProgramada, @fkHorarioLaboral, 1);  -- 1 = estado activo por defecto
    
    RETURN SCOPE_IDENTITY();
END;
GO

-- =============================================
-- Procedimiento: sp_preReservarHorario
-- Descripción: Pre-reserva un horario de clase
-- CAMBIO IMPORTANTE:
--   - Ahora inserta idClase, fechaDeLaClase, idEntrenador en preReservasDeHorario
--   - Eliminado bloqueo con hints; se usa índice único para evitar duplicados
--   - Verifica existencia usando funciones yaExisteClaseProgramada y yaExistePreRegistroDeClase
-- =============================================
ALTER PROCEDURE [dbo].[sp_preReservarHorario]
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
    PRINT '1/7 iniciando...'
    
    DECLARE @idsHoraLaborales IdsHorasLaborales;
    INSERT INTO @idsHoraLaborales(fkHoraLaboral) VALUES(@idHoraLaboral);
    PRINT '2/7 ids horas laborales insertados';

    BEGIN TRY
        PRINT '3/7 verificando existencia previa usando funciones';

        IF dbo.yaExisteClaseProgramada(@idClase, @idEntrenador, @fechaTentativa, @idsHoraLaborales) = 1
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS IdPreReserva, 'Ya existe una clase programada para esa combinación (clase, fecha, hora, entrenador)' AS Mensaje;
            RETURN;
        END

        IF dbo.yaExistePreRegistroDeClase(@idClase, @idEntrenador, @fechaTentativa, @idsHoraLaborales) = 1
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS IdPreReserva, 'Ya existe una pre-reserva vigente para esa combinación (clase, fecha, hora, entrenador)' AS Mensaje;
            RETURN;
        END

        PRINT '4/7 registrando preReserva';
        
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
        
        COMMIT TRANSACTION;
        PRINT '5/7 preReserva registrada con éxito'; 
        SELECT @idPrereservaOut = SCOPE_IDENTITY();

    END TRY
    BEGIN CATCH
        PRINT '6/7 error al registrar la pre reserva ROLLBACK!!!';
        ROLLBACK TRANSACTION;
        
        IF ERROR_NUMBER() = 2627 -- Unique constraint violation
        BEGIN
            SELECT 0 AS IdPreReserva, 'Ya existe una pre-reserva duplicada (constraint unique violada).' AS Mensaje;
            RETURN;
        END

        PRINT '7/7 relanzando error original';
        THROW;
    END CATCH
END;
GO

PRINT '========================================='
PRINT 'PROCEDIMIENTOS ALMACENADOS (CRÍTICOS) ACTUALIZADOS'
PRINT '========================================='
GO
