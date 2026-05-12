-- =============================================
-- PROCEDURE: sp_obtenerUltimasMedidasDelUsuario
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   PROCEDURE dbo.sp_obtenerUltimasMedidasDelUsuario
( 
@idUsuario nvarchar(450)
)
AS 
BEGIN
	;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro ORDER BY fechaDeCreacion DESC) AS rn
        FROM medidas
        	where fkUsuario =@idUsuario
    )
    SELECT ro.medidaId,pm.parametroMedicionId as fkParametro ,pm.nombre as nombreParametro,ro.valor,ro.fechaDeCreacion,udm.unidadDeMedidaId,
    udm.nombre  as nombreUnidadDeMedida,ro.fkEjercicio,e.NombreEjercicio,(select iconsf.urlPublica from iconsForParameters iconsf where iconsf.iconId = pm.fkIcon) as urlIconoParametro ,(select iconsf.urlPublica from iconsForParameters iconsf where iconsf.iconId = e.fkIcon) as urlIconoEjercicio,ro.fkUsuario 
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro as ro
    join parametrosDeMedicion pm on pm.parametroMedicionId = ro.fkParametro 
    join parametros_unidadesDeMedida pum on pum.fkParametroDeMedicion = pm.parametroMedicionId
    join unidadesDeMedida udm on pum.fkUnidadDeMedida  = udm.unidadDeMedidaId
    left join Ejercicios e  on e.EjercicioID  = ro.fkEjercicio
    WHERE ro.rn = 1;  
   
END;

GO
