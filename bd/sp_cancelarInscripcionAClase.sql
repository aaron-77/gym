CREATE PROCEDURE dbo.sp_cancelarInscripcionAClase
    @idInscripcion int = null
AS
BEGIN
    SET NOCOUNT ON;
   BEGIN TRY 
   		if @idInscripcion is null
		begin
		  THROW 51000, '1/5 debe suministrarse una insrcipcion para cancelar', 1;
		end
	  
	   update inscripcionesDeClases 
	   set fkEstadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoCanceladoInscripcionAClase) -- Comparar directamente con la vista
	   where idInscripcion = @idInscripcion
	   if @@ROWCOUNT = 0
	   BEGIN 
	   	THROW 51000, 'no existe una insrcipcion con ese id', 1;
	   END
	   
   END TRY
   BEGIN CATCH
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
   END CATCH 
END;