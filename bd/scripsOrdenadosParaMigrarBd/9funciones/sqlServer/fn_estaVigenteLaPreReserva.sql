-- =============================================
-- FUNCTION: fn_estaVigenteLaPreReserva
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION dbo.fn_estaVigenteLaPreReserva(@idPreReserva int)
RETURNS BIT
AS 
BEGIN
	declare @estaVigente bit = 1;

	if not exists (
		select 1 
		from preReservasDeHorario prdh 
		where idPreReserva = @idPreReserva 
		and GETDATE() BETWEEN prdh.fechaInicioDeLaReserva and prdh.fechaDeExpiracionDeLaReserva
	)
	BEGIN 
		set @estaVigente = 0;
	END
	return @estaVigente;
END;

CREATE FUNCTION fn_inscripcionEstaVigente(@idInscripcion INT)
RETURNS BIT
AS
BEGIN
    DECLARE @estadoInscripcion INT;
    DECLARE @resultado BIT; -- Nueva variable para almacenar el resultado

    -- Obtener el estado de la inscripción
    SELECT @estadoInscripcion = fkEstadoInscripcion
    FROM FitnessCenterDB.dbo.inscripcionesDeClases
    WHERE idInscripcion = @idInscripcion;

    -- Comparar con el estado vigente y almacenar el resultado
    IF @estadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase)
    BEGIN
        SET @resultado = 1; -- true
    END
    ELSE
    BEGIN
        SET @resultado = 0; -- false
    END

    RETURN @resultado; -- Devolver el resultado
END;

CREATE FUNCTION fn_obtenerClases()
RETURNS TABLE
AS
RETURN (
    SELECT ClaseID, NombreClase
    FROM FitnessCenterDB.dbo.Clases
    where fkEstadoClase = (select idEstadoClase from v_estadoActivoClases)
);

GO
