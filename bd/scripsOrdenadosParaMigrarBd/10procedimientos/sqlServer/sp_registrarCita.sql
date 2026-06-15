-- =============================================
-- PROCEDURE: sp_registrarCita
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE         PROCEDURE [dbo].[sp_registrarCita]
( 
@usuarioID nvarchar(450),
@entrenadorID nvarchar(450),
@fechaInicio datetime,
@tipoCita nvarchar(50),
@estado nvarchar(50),
@fechaHoraFin datetime
	
)
	-- Add the parameters for the stored procedure here
	
	
AS
BEGIN
	BEGIN TRY
		PRINT N'fecha inicio'+  CAST(@fechaInicio AS NVARCHAR(50));
		PRINT N'fecha fin'+  CAST(@fechaHoraFin AS NVARCHAR(50));
	insert into Citas(UserId,
							 EntrenadorID,
							 FechaHora,
							 TipoCita,
							 Estado,
							 FechaHoraFin)
						values(
							@usuarioID,
							@entrenadorID,
							@fechaInicio,
							@tipoCita,
							@estado,
							@fechaHoraFin
						)
	
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
        @LoginOriginal SYSNAME = ORIGINAL_LOGIN(),
        @Host NVARCHAR(128) = HOST_NAME(),
        @App  NVARCHAR(128) = APP_NAME(),
        @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
        @ErrorLine INT = ERROR_LINE(),
        @CompleteMessage nvarchar(max) = '';
        SET @CompleteMessage = @ErrorMessage + CAST(@ErrorLine AS NVARCHAR(10))+ N'  ' + CAST(@fechaInicio AS NVARCHAR(50)) + N' ' + CAST(@fechaHoraFin AS NVARCHAR(50));

        PRINT N'12/14 registrando log de error';
        EXEC sp_RegistrarError 
            @ProcName,
            @CompleteMessage,
            @ErrorSeverity,
            @ErrorState,
            @LoginOriginal,
            @Host,
        	@App;

        PRINT N'13/14 error registrado correctamente';

        -- Opcional: volver a lanzar el error para que el cliente lo reciba
        PRINT N'14/14 relanzando THROW'; 
        THROW;
	END CATCH
		
END;

GO
