-- =============================================
-- PROCEDURE: sp_modificarCita
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_modificarCita]
(
@citaId int,
@entrenadorID nvarchar(450),
@fechaInicio datetime,
@estado nvarchar(50),
@fechaHoraFin datetime
	
)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

	update Citas set 
	EntrenadorID= @entrenadorID,
	FechaHora=@fechaInicio,
	FechaHoraFin=@fechaHoraFin,
	Estado=@estado
	where CitaID = @citaId
END;

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

GO
