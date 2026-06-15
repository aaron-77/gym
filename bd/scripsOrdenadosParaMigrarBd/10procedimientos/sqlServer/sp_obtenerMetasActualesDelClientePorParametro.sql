-- =============================================
-- PROCEDURE: sp_obtenerMetasActualesDelClientePorParametro
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_obtenerMetasActualesDelClientePorParametro]
( 
@idUsuario nvarchar(450)
)
AS 
BEGIN
	;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            metaId,
        	fkIntencion,
            fkParametro,
            fkEjercicio,
            valorObjetivo,
            fkNivelDeLogro,            
            fechaDeInicioDeLaMeta,
            fechaLimite,
            fkUsuario,
            ROW_NUMBER() OVER (PARTITION BY fkParametro ORDER BY fechaDeInicioDeLaMeta DESC) AS rn
        FROM metas
        	where fkUsuario =@idUsuario
    )
    
    SELECT ro.metaId,i.nombre as intencion,
    pm.nombre  as nombreParametro,
    ro.fkEjercicio,
    e.NombreEjercicio ,
    ro.valorObjetivo,
    ndl.nombre ,
    ro.fechaDeInicioDeLaMeta,
    ro.fechaLimite,
    ro.fkUsuario,
    ro.fkParametro,
    ndl.nombre as nombreNivelDeLogro
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro as ro
    join intenciones i  on i.intencionId = ro.fkIntencion
    join parametrosDeMedicion pm on pm.parametroMedicionId = ro.fkParametro
    left join Ejercicios e  on e.EjercicioID  = ro.fkEjercicio 
    join nivelesDeLogro ndl on  ndl.idNivelDeLogro = ro.fkNivelDeLogro
    WHERE ro.rn = 1;  
   
END;

GO
