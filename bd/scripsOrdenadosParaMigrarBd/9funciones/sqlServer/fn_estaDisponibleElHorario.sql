-- =============================================
-- FUNCTION: fn_estaDisponibleElHorario
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION dbo.fn_estaDisponibleElHorario(
	@fechaReservada date,
	@fksHorasKaborales IdsHorasLaborales READONLY
	)
RETURNS BIT
AS
BEGIN
    DECLARE @estaDisponible BIT = 1;
    
    -- Verificar si la clase programada tiene horarios asignados
   
   
   IF dbo.yaExisteClaseProgramada(@fechaReservada,@fksHorasKaborales) = 1
			
    BEGIN
        SET @estaDisponible = 0;
	END;
	
    -- Verificar si algún horario de la clase está pre-reservado
    
   IF dbo.yaExistePreRegistroDeClase(@fechaReservada,@fksHorasKaborales) = 1
    BEGIN
        SET @estaDisponible = 0;
    END;
   
	   
    RETURN @estaDisponible;
END;

GO
