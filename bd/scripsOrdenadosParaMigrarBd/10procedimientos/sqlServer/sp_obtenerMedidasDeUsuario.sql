-- =============================================
-- PROCEDURE: sp_obtenerMedidasDeUsuario
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_obtenerMedidasDeUsuario]
( 
@idUsuario nvarchar(450)
)	
AS
BEGIN
	select parametroMedicionId,nombre as nombreParametro 
	from parametrosDeMedicion pdm 
	where parametroMedicionId 
		in(select DISTINCT fkParametro from medidas where fkUsuario = @idUsuario );
END;

GO
