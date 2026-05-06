-- =============================================
-- PROCEDURE: sp_preReservarHorario
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

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
