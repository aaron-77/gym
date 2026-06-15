-- =============================================
-- PROCEDURE: sp_consultarUsuariosProximosAcita
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   PROCEDURE [dbo].[sp_consultarUsuariosProximosAcita]
	
AS
BEGIN
	declare @fechaActual datetime;
	set @fechaActual = GETDATE();
	select u.Email,c.FechaHora from aspnetusers u
	join Citas c on c.UserID = u.Id and c.FechaHora > GETDATE() and DATEDIFF(DAY,@fechaActual,c.FechaHora) = 15 ;		
END;

GO
