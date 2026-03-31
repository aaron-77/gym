USE [FitnessCenterDB]
GO
/****** Object:  StoredProcedure [dbo].[sp_procesoCompletoCancelarClasesProgramadas]    Script Date: 13/01/2026 10:36:10 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_procesoCompletoCancelarClasesProgramadas]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_procesoCompletoCancelarClasesProgramadas] AS' 
END
GO
ALTER PROCEDURE [dbo].[sp_procesoCompletoCancelarClasesProgramadas]
    @idClaseProgramada int = null,
	@fechaParaCancelar date = null,
    @idEntrenador nvarchar(450) = null,
    @idClase int = null,
    @estadoDeOperaciones int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			declare @idsClasesCanceladas ListadoIdsGenericos;
			
			INSERT INTO @idsClasesCanceladas 
				EXEC 
				sp_cancelarClasesProgramadas @idClaseProgramada,@fechaParaCancelar,@idEntrenador,@idClase
			
			IF NOT EXISTS (SELECT 1 FROM @idsClasesCanceladas)
			BEGIN
				THROW 51000, '1/5 No hay clases por cancelar en esa fecha', 1;
			END
			
			EXEC sp_cancelarInscripcionesDeClasesCanceladas @idsClasesCanceladas
			
			set @estadoDeOperaciones = 1;
			
       	COMMIT TRANSACTION;
       --EL 1 INDICA QUE LA CANCELACION SE REALIZO CORRECTAMENTE
       return 1;
    END TRY
    BEGIN CATCH
        PRINT N'2/5 excepción capturada';
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

GO
