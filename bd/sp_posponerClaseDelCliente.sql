CREATE PROCEDURE sp_posponerClaseDelCliente (
    IN fechaNueva DATE,
    IN idCliente INT,
    IN fkProgramacionClase INT
)
BEGIN
    -- Registrar nueva inscripción en la tabla inscripcionesDeClases
    INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases
     (fkCliente, fkProgramacionClase, fechaDeInscripcion, fkEstadoInscripcion)
    VALUES (idCliente, fkProgramacionClase, GETDATE(), 1);
     -- Asumiendo que 1 es el estado activo
END;