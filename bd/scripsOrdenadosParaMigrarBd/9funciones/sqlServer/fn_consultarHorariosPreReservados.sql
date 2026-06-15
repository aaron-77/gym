-- =============================================
-- FUNCTION: fn_consultarHorariosPreReservados
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.fn_consultarHorariosPreReservados(@fechaTentativa DATE)
RETURNS TABLE
AS
RETURN (
    
	
	SELECT 
    pr.idPreReserva,
    pr.fechaReservada,
    hl.idHora,
    hl.horaInicio,
    hl.horaFin,
    idUsuarioQueReserva,
    pr.fechaDeExpiracionDeLaReserva
    FROM FitnessCenterDB.dbo.preReservasDeHorario pr
    LEFT JOIN dbo.horasLaborales hl
        ON pr.fkHoraLaboral = hl.idHora
    WHERE (
pr.fechaReservada >= @fechaTentativa 
and pr.fechaReservada >= DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),DAY(GETDATE()))
and (GETDATE() BETWEEN pr.fechaInicioDeLaReserva AND pr.fechaDeExpiracionDeLaReserva)
 )   
);

GO
