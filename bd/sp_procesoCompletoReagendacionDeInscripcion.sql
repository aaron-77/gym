CREATE PROCEDURE dbo.sp_procesoCompletoReagendacionDeInscripcion
    @idInscripcionCancelada INT,
    @idClaseProgramadaNueva INT,
    @idCliente INT,
    @estadoOperacion INT OUTPUT -- Parámetro de salida
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Llamar al procedimiento para cancelar la inscripción
        EXEC dbo.sp_procesoCompletoCancelacionDeInscripcionAClase @idInscripcion = @idInscripcionCancelada;

        -- Validar si es el mismo tipo de clase, si no lo es se arrojará una excepción
        EXEC dbo.sp_esElMismoTipoDeClase @idInscripcionCancelada, @idClaseProgramadaNueva;

        -- Si la validación es exitosa, registrar nueva inscripción en la clase programada
        EXEC dbo.sp_registrarInsrcipcionAClase @idCliente = @idCliente, @fkProgramacionClase = @idClaseProgramadaNueva;

        -- Asignar estado de operación a 1 si se completó sin problemas
        SET @estadoOperacion = 1;
        
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
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

        SET @estadoOperacion = 0;
        PRINT N'3/5 registrando log de error';
        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorNumber,
            @ErrorSeverity,
            @ErrorState,
            @ErrorMessage,
            @ErrorLine;

        PRINT N'4/5 error registrado correctamente';

        -- Opcional: volver a lanzar el error para que el cliente lo reciba
        PRINT N'5/5 relanzando THROW'; 
        THROW;
    END CATCH
END;