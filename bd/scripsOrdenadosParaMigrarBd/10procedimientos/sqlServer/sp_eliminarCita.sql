-- =============================================
-- PROCEDURE: sp_eliminarCita
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_eliminarCita]
( 
@citaId int	
)
	-- Add the parameters for the stored procedure here
	
	
AS
BEGIN
		delete from Citas where CitaID = @citaId;
END;

GO
