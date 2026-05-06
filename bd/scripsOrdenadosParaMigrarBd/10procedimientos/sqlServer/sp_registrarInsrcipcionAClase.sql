-- =============================================
-- PROCEDURE: sp_registrarInsrcipcionAClase
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE       PROCEDURE dbo.sp_registrarInsrcipcionAClase
(
    @idCliente nvarchar(450),
    @fkProgramacionClase INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @idEstatusActivoDeInscripcion INT = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase);
        
        INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases
        (
            fkCliente, 
            fkProgramacionClase, 
            fechaDeInscripcion, 
            fkEstadoInscripcion
        )
        VALUES
        (
            @idCliente, 
            @fkProgramacionClase, 
            GETDATE(), 
            @idEstatusActivoDeInscripcion
        );

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

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

GO
