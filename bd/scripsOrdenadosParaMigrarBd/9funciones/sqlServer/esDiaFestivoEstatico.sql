-- =============================================
-- FUNCTION: esDiaFestivoEstatico
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION dbo.esDiaFestivoEstatico(@fechaAnalizada DATE)
RETURNS INT
AS 
BEGIN
	DECLARE @estaDiaFestivoEstatico BIT = 0;

	IF (
	select 1 
	FROM diasFestivosYDescansos dfy 
	JOIN estadosDeActividadLaboral edal 
	ON dfy.fkEstadoActividadLaboral = edal.idEstadoActividadLaboral
	WHERE fechaFestivaODescanso = @fechaAnalizada 
		AND edal.nombreEstadoActividadLaboral = 'no se labora'
	) = 1
	BEGIN 
		SET @estaDiaFestivoEstatico = 1;
	END
	RETURN @estaDiaFestivoEstatico;
    
END;

GO
