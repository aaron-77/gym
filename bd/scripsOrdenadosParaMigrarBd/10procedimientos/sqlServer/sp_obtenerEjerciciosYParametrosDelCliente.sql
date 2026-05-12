-- =============================================
-- PROCEDURE: sp_obtenerEjerciciosYParametrosDelCliente
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_obtenerEjerciciosYParametrosDelCliente]
@idCliente nvarchar(450)
AS
BEGIN
	with ejercicios_del_usuario as(
		select distinct e.EjercicioID ,e.NombreEjercicio,pdm.parametroMedicionId,pdm.nombre as nombreParametro
		from medidas m 
		left join ejercicios_parametrosDeMedicion epdm  on epdm.fkEjercicio  = m.fkEjercicio 
		join Ejercicios e on e.EjercicioID  = epdm.fkEjercicio 
		join parametrosDeMedicion pdm ON epdm.fkParametro  = pdm.parametroMedicionId 
		where m.fkUsuario = @idCliente
	),
	parametros_del_usuario as (
		select distinct null as EjercicioId,null as NombreEjercicio,pdm.parametroMedicionId,pdm.nombre as nombreParametro
		from medidas m 
		join parametrosDeMedicion pdm on pdm.parametroMedicionId = m.fkParametro
		where m.fkUsuario = @idCliente and m.fkEjercicio is null
	)
	select * from ejercicios_del_usuario
	union all
	select * from parametros_del_usuario
END;

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

GO
