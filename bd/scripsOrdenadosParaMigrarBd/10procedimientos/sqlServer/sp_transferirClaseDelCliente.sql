-- =============================================
-- PROCEDURE: sp_transferirClaseDelCliente
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_transferirClaseDelCliente]
    @idCliente nvarchar(450),
    @fkProgramacionClase INT
AS
BEGIN
    -- Comenzar una transacción
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Declarar una variable para almacenar el id del estado "vigente"
        DECLARE @idEstadoInscripcion INT;

        -- Obtener el id del estado "vigente"
        SELECT @idEstadoInscripcion = idEstadoInscripcion
        FROM FitnessCenterDB.dbo.estadosInscripciones
        WHERE nombreEstadoInscripcion = 'vigente';

        -- Insertar una nueva inscripción en la tabla inscripcionesDeClases
        INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases (fkCliente, fkProgramacionClase, fkEstadoInscripcion)
        VALUES (@idCliente, @fkProgramacionClase, @idEstadoInscripcion);

        -- Confirmar la transacción
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si hay un error, revertir la transacción
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        -- Manejo de errores
        DECLARE 
            @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
            @ErrorNumber INT = ERROR_NUMBER(),
            @ErrorSeverity INT = ERROR_SEVERITY(),
            @ErrorState INT = ERROR_STATE(),
            @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
            @ErrorLine INT = ERROR_LINE(); 

        -- Registrar el error
        EXEC FitnessCenterDB.dbo.sp_RegistrarError 
            @ProcName,
            @ErrorNumber,
            @ErrorSeverity,
            @ErrorState,
            @ErrorMessage,
            @ErrorLine;

        -- Opcional: volver a lanzar el error para que el cliente lo reciba
        THROW;
    END CATCH
END;

GO
