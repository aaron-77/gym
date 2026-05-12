-- =============================================
-- PROCEDURE: sp_obtenerMedidasPorMesIndividual
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_obtenerMedidasPorMesIndividual]
    @idUsuario nvarchar(450),
    @idParametro INT,
    @idEjercicio INT = NULL,
    @listadoDeMeses UnidadDeTiempo readonly
AS
BEGIN
    SELECT 
    m.medidaId,
    pm.parametroMedicionId as fkParametro ,
    pm.nombre as nombreParametro,
    m.valor,
    m.fechaDeCreacion,
    udm.unidadDeMedidaId,
    udm.nombre  as nombreUnidadDeMedida,
    m.fkEjercicio,
    e.NombreEjercicio,
    (select iconsf.urlPublica from iconsForParameters iconsf where iconsf.iconId = pm.fkIcon) as urlIconoParametro ,
    (select iconsf.urlPublica from iconsForParameters iconsf where iconsf.iconId = e.fkIcon) as urlIconoEjercicio,
    m.fkUsuario 
    FROM medidas as m
    join parametrosDeMedicion pm on pm.parametroMedicionId = m.fkParametro 
    join parametros_unidadesDeMedida pum on pum.fkParametroDeMedicion = pm.parametroMedicionId
    join unidadesDeMedida udm on pum.fkUnidadDeMedida  = udm.unidadDeMedidaId
    left join Ejercicios e  on e.EjercicioID  = m.fkEjercicio
    WHERE     m.fkUsuario  = @idUsuario 
    	  and m.fkParametro  = @idParametro
    	  and (@idEjercicio IS NULL OR m.fkEjercicio = @idEjercicio)
    	  and DATEPART(MONTH,m.fechaDeCreacion) in (select * from @listadoDeMeses)
    	  order by m.fechaDeCreacion
END;

GO
