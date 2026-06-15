-- =============================================
-- PROCEDURE: sp_obtenerMedidasPorRangoDeMeses
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_obtenerMedidasPorRangoDeMeses]
    @idCliente nvarchar(450),
    @idParametro INT,
    @idEjercicio INT,
    @fechaInicial DATETIME,
    @fechaFinal DATETIME,
    @conDetalles int
AS
BEGIN
	IF @conDetalles = 1
	BEGIN
		SELECT 
        m.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        m.valor,
        m.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        m.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica 
         FROM iconsForParameters iconsf 
         WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica 
         FROM iconsForParameters iconsf 
         WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        m.fkUsuario
    FROM medidas m
    INNER JOIN parametrosDeMedicion pm 
        ON m.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  
    	ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion
    INNER JOIN unidadesDeMedida udm 
        ON pudm.fkUnidadDeMedida = udm.unidadDeMedidaId
    LEFT JOIN ejercicios e 
        ON m.fkEjercicio = e.ejercicioId
    WHERE 
      m.fkUsuario = @idCliente
      AND pm.parametroMedicionId = @idParametro
      AND (@idEjercicio IS NULL OR m.fkEjercicio = @idEjercicio)
      AND m.fechaDeCreacion BETWEEN @fechaInicial AND @fechaFinal;	
	END
	ELSE
	BEGIN
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
		        SELECT 
		            medidaId,
		        	fkUsuario,
		            fechaDeCreacion,
		            fkParametro,
		            valor,
		            fkEjercicio,
		            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
		            								YEAR(m.fechaDeCreacion), 
		                							MONTH(m.fechaDeCreacion) 
		            								ORDER BY fechaDeCreacion DESC
		            					) AS rn
		        FROM medidas m
		        	where fkUsuario =@idCliente
		        	AND m.fkParametro = @idParametro
		      		AND m.fechaDeCreacion BETWEEN @fechaInicial AND @fechaFinal
		 )
		 
		 SELECT 
        ro.medidaId,
        pm.parametroMedicionId AS fkParametro,
        pm.nombre AS nombreParametro,
        ro.valor,
        ro.fechaDeCreacion,
        udm.unidadDeMedidaId,
        udm.nombre AS nombreUnidadDeMedida,
        ro.fkEjercicio,
        e.nombreEjercicio,
        (SELECT iconsf.urlPublica 
         FROM iconsForParameters iconsf 
         WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica 
         FROM iconsForParameters iconsf 
         WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm 
        ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  
    	ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion
    INNER JOIN unidadesDeMedida udm 
        ON pudm.fkUnidadDeMedida = udm.unidadDeMedidaId
    LEFT JOIN ejercicios e 
        ON ro.fkEjercicio = e.ejercicioId
    WHERE 
      ro.rn =1
      AND (@idEjercicio IS NULL OR ro.fkEjercicio = @idEjercicio)
	END
	
	
    
END;

GO
