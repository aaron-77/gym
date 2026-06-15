-- Script para probar el procedimiento almacenado sp_transferirClaseDelCliente

DECLARE @idCliente INT = 1; -- Cambia este valor por un idCliente válido
DECLARE @fkProgramacionClase INT = 1; -- Cambia este valor por un fkProgramacionClase válido

BEGIN TRY
    -- Llamar al procedimiento almacenado
    EXEC FitnessCenterDB.dbo.sp_transferirClaseDelCliente 
        @idCliente = @idCliente, 
        @fkProgramacionClase = @fkProgramacionClase;

    PRINT 'Inscripción registrada correctamente.';
END TRY
BEGIN CATCH
    -- Manejo de errores
    DECLARE 
        @ErrorMessage NVARCHAR(MAX),
        @ErrorSeverity INT,
        @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    PRINT 'Error al registrar la inscripción: ' + @ErrorMessage;
    PRINT 'Severidad: ' + CAST(@ErrorSeverity AS NVARCHAR(10));
    PRINT 'Estado: ' + CAST(@ErrorState AS NVARCHAR(10));
END CATCH;