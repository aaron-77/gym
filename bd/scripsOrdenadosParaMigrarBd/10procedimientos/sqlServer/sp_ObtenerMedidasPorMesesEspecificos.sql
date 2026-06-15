-- =============================================
-- PROCEDURE: sp_ObtenerMedidasPorMesesEspecificos
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_ObtenerMedidasPorMesesEspecificos]
    @idCliente nvarchar(450),
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @listadoDeMeses UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	--Si debe devolver todas las medias asociadas no solo las mas relevantes
	IF @conDetalles = 1
	begin
		-- Consulta principal
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
	        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
	        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
	        m.fkUsuario
	    FROM medidas m
	    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId
	    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
	    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
	    LEFT JOIN ejercicios e ON m.fkEjercicio = e.ejercicioId 
	    WHERE m.fkUsuario = @idCliente
	      AND pm.parametroMedicionId = @idParametro
	      AND ((@idEjercicio IS NULL AND m.fkEjercicio IS NULL) OR (@idEjercicio IS NOT NULL AND m.fkEjercicio = @idEjercicio))
	      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoDeMeses)
	      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
	     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- en este caso deben devolverse solo las medidas mas relevantes (ultima de cada mes o año segun el caso) 
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
        	where m.fkUsuario =@idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoDeMeses)
        	AND YEAR(m.fechaDeCreacion) in (select mesOAño from @años)
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
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = pm.fkIcon) AS urlIconoParametro,
        (SELECT iconsf.urlPublica FROM iconsForParameters iconsf WHERE iconsf.iconId = e.fkIcon) AS urlIconoEjercicio,
        ro.fkUsuario
    FROM RegistrosOrdenadosPorFechaMasRecientePorParametro ro
    INNER JOIN parametrosDeMedicion pm ON ro.fkParametro = pm.parametroMedicionId
    INNER JOIN parametros_unidadesDeMedida pudm  ON  pm.parametroMedicionId = pudm.fkParametroDeMedicion 
    INNER JOIN unidadesDeMedida udm ON udm.unidadDeMedidaId  = pudm.fkUnidadDeMedida 
    LEFT JOIN ejercicios e ON ro.fkEjercicio = e.ejercicioId 
    WHERE 
      ro.fkUsuario = @idCliente
      AND ro.rn =1
      AND pm.parametroMedicionId = @idParametro
      AND ((@idEjercicio IS NULL AND ro.fkEjercicio IS NULL) OR (@idEjercicio IS NOT NULL AND ro.fkEjercicio = @idEjercicio))
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoDeMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
END;

GO
