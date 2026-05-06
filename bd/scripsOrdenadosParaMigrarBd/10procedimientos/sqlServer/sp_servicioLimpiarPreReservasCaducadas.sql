-- =============================================
-- PROCEDURE: sp_servicioLimpiarPreReservasCaducadas
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE dbo.sp_servicioLimpiarPreReservasCaducadas
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Declarar una variable tipo tabla para almacenar los IDs de pre-reservas caducadas
        DECLARE @idsPreReservasCaducadas dbo.ListadoIdsGenericos;

        -- Insertar los IDs encontrados por la función en la variable tipo tabla
        INSERT INTO @idsPreReservasCaducadas (id)
        SELECT idPreReserva
        FROM dbo.fn_encontrarPreReservasCaducadas();

        -- Llamar al procedimiento que elimina las pre-reservas caducadas
        EXEC dbo.sp_eliminarPreReservasCaducadas @idsPreReservasCaducadas = @idsPreReservasCaducadas;

        -- Devolver los IDs eliminados como resultado
        SELECT id AS IdPreReservaEliminada FROM @idsPreReservasCaducadas;

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

        -- Registrar el error en la tabla de logs
        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorMessage,
            @ErrorSeverity,
            @ErrorState,
            NULL, -- Usuario
            NULL, -- Host
            NULL; -- Aplicación

        -- Relanzar el error para que sea visible en la aplicación
        THROW;
    END CATCH
END;

GO
