-- Script para probar el procedimiento almacenado sp_procesoCompletoReagendacionDeInscripcion

DECLARE @estadoOperacion INT; -- Variable para el parámetro de salida

-- Sustituye los valores de los parámetros por aquellos que existan en tu base de datos
DECLARE @idInscripcionCancelada INT = 1; -- Cambia 1 por un ID de inscripción cancelada existente
DECLARE @idClaseProgramadaNueva INT = 2; -- Cambia 2 por un ID de clase programada nueva existente
DECLARE @idCliente INT = 1; -- Cambia 1 por un ID de cliente existente

-- Llamar al procedimiento almacenado
EXEC dbo.sp_procesoCompletoReagendacionDeInscripcion 
    @idInscripcionCancelada = @idInscripcionCancelada,
    @idClaseProgramadaNueva = @idClaseProgramadaNueva,
    @idCliente = @idCliente,
    @estadoOperacion = @estadoOperacion OUTPUT; -- Pasar la variable como parámetro de salida

-- Verificar el resultado
IF @estadoOperacion = 1
BEGIN
    PRINT 'La re-agendación de la inscripción se completó exitosamente.';
END
ELSE
BEGIN
    PRINT 'Error al re-agendar la inscripción.';
END;