USE fitnessCenterDB;
-- =============================================
-- FUNCTION: fn_yaEstaInscritoElCliente
-- Spec: 75-spect-fn-yaEstaInscritoElCliente
-- Retorna 1 si el cliente ya tiene una inscripción vigente para la combinación
-- de idHora + fechaDeClase. Un solo JOIN chain con 4 tablas.
-- =============================================

CREATE FUNCTION dbo.fn_yaEstaInscritoElCliente
(
    @idCliente    NVARCHAR(450),
    @idHora       INT,
    @fechaDeClase DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @resultado BIT = 0;

    SELECT @resultado = 1
    FROM dbo.inscripcionesDeClases i
    INNER JOIN dbo.clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
    INNER JOIN dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
    WHERE i.fkCliente = @idCliente
      AND hcp.fkHorarioLaboral = @idHora
      AND cp.fechaDeLaClase = @fechaDeClase
      AND i.fkEstadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase);

    RETURN @resultado;
END;

