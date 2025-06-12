-- Probar el procedimiento almacenado sp_procesoCompletoCancelacionDeInscripcionAClase

DECLARE @resultado INT;

-- Sustituye el valor de @idInscripcion por un ID que exista en tu base de datos
EXEC @resultado = dbo.sp_procesoCompletoCancelacionDeInscripcionAClase @idInscripcion = 1; -- Cambia 1 por un ID válido

-- Verificar el resultado
IF @resultado IS NULL
BEGIN
    PRINT 'La inscripción fue cancelada exitosamente.';
END
ELSE
BEGIN
    PRINT 'Error al cancelar la inscripción.';
END;