-- =============================================
-- FUNCTION: fn_encontrarPreReservasCaducadas
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.fn_encontrarPreReservasCaducadas()
RETURNS table
AS 
return
(
	select idPreReserva 
	from preReservasDeHorario 
	where GETDATE() NOT BETWEEN fechaInicioDeLaReserva and fechaDeExpiracionDeLaReserva
);

GO
