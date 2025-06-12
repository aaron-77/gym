CREATE PROCEDURE dbo.sp_procesoCompletoCancelacionDeInscripcionAClase
    @idInscripcion INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar que la inscripción tenga estado "vigente"
        IF dbo.fn_inscripcionEstaVigente(@idInscripcion) = 0
        BEGIN
            THROW 51000, 'Esa inscripción no puede ser cancelada, posiblemente ya fue cancelada o es un id equivocado.', 1;
        END

        -- Llamar al procedimiento para cancelar la inscripción
        EXEC dbo.sp_cancelarInscripcionAClase @idInscripcion;

    END TRY
    BEGIN CATCH
        PRINT N'2/5 excepción capturada';

        DECLARE 
        @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
        @ErrorNumber INT = ERROR_NUMBER(),
        @ErrorSeverity INT = ERROR_SEVERITY(),
        @ErrorState INT = ERROR_STATE(),
        @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
        @ErrorLine INT = ERROR_LINE(); 

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