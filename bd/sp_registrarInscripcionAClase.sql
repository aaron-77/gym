CREATE PROCEDURE dbo.sp_registrarInsrcipcionAClase(
    @idCliente INT,
    @fkProgramacionClase INT
)
AS
BEGIN
	
	declare @idEstatusActivoDeInscripcion int = (select idEstadoInscripcion from v_idEstadoVigenteInscripcionAClase);
    -- Registrar nueva inscripción en la tabla inscripcionesDeClases
    INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases
     (fkCliente, fkProgramacionClase, fechaDeInscripcion, fkEstadoInscripcion)
    VALUES (@idCliente, @fkProgramacionClase, GETDATE(), @idEstatusActivoDeInscripcion);
END;