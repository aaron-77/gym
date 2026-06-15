-- =============================================
-- FUNCTION: esDiaFestivo
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION dbo.esDiaFestivo(@fechaAnalizada date)
RETURNS INT
AS 
BEGIN
	DECLARE @estaDiaFestivo BIT = 0;

	IF dbo.esDiaFestivoEstatico(@fechaAnalizada) = 1
	BEGIN 
		SET @estaDiaFestivo = 1;
	END
	
	IF dbo.fn_esDiaFestivoVariableVersionNormal(@fechaAnalizada) = 1
	BEGIN 
		SET @estaDiaFestivo = 1;
	END
	
	RETURN @estaDiaFestivo;
    
END;

GO
