use fitnessCenterDB
-- =============================================
-- PROCEDURE: sp_preReservarHorarioInscripcion
-- Objetivo: Crear pre-reservas para el flujo de inscripciones/reagendaciones.
--           Valida cupo disponible y duplicados por cliente.
-- =============================================

CREATE PROCEDURE [dbo].[sp_preReservarHorarioInscripcion]
    @idUsuarioQueReserva nvarchar(450),
    @fechaTentativa date,
    @idHoraLaboral int,
    @idClase int = NULL,
    @idEntrenador nvarchar(450) = NULL,
    @idClaseProgramada int,
    @idPrereservaOut int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    DECLARE @idsHoraLaborales IdsHorasLaborales;
    INSERT INTO @idsHoraLaborales(fkHoraLaboral) VALUES(@idHoraLaboral);

    BEGIN TRY
        -- Validar que haya cupo disponible en la clase programada
        IF dbo.fn_validarCupoDeClase(@idClaseProgramada) = 0
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('No hay cupo disponible en la clase programada seleccionada',16,1);
            RETURN;
        END

        -- Validar que no exista ya una pre-reserva vigente para el mismo cliente
        IF dbo.fn_yaExistePreReservaDeInscripcion(
            @idClase,
            @idEntrenador,
            @fechaTentativa,
            @idUsuarioQueReserva,
            @idsHoraLaborales
        ) = 1
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('Ya existe una pre-reserva vigente para este cliente en esa combinación (clase, fecha, hora, entrenador)',16,1);
            RETURN;
        END

        -- Insertar pre-reserva
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

        DECLARE 
            @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
            @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
            @ErrorSeverity INT = ERROR_SEVERITY(),
            @ErrorState INT = ERROR_STATE();

        EXEC sp_RegistrarError
            @Procedimiento = @ProcName,
            @Mensaje = @ErrorMessage,
            @Severidad = @ErrorSeverity,
            @Estado = @ErrorState;

        ;THROW;
    END CATCH
END;


