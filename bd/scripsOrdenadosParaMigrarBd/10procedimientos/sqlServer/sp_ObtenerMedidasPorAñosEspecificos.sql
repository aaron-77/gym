-- =============================================
-- PROCEDURE: sp_ObtenerMedidasPorAñosEspecificos
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_ObtenerMedidasPorAñosEspecificos]
    @idCliente nvarchar(450),
    @idParametro INT,
    @idEjercicio INT,
    @años UnidadDeTiempo readonly,
    @conDetalles int
AS
BEGIN
	declare @listadoMeses UnidadDeTiempo;
	insert into @listadoMeses values
	(1),(2),(3),(4),(5),
	(6),(7),(8),(9),(10),
	(11),(12);

	declare @parametrosConcatenados nvarchar(max);  
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
       	'años',(SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años),',',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPOrAñosEspecificos',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;
	-- si la cosulta requiere informacion detallada,es decir todas la medidas encontradas dentro de las fechas establecidas
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
      AND (m.fkEjercicio = @idEjercicio or m.fkEjercicio is null )
      AND MONTH(m.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(m.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by m.fechaDeCreacion ;
	end
	ELSE
	begin
		-- si solo se requieren las ulimas medidas(informacion resumida)
		;WITH RegistrosOrdenadosPorFechaMasRecientePorParametro AS (
        SELECT 
            medidaId,
        	fkUsuario,
            fechaDeCreacion,
            fkParametro,
            valor,
            fkEjercicio,
            ROW_NUMBER() OVER (PARTITION BY fkParametro , 
            								YEAR(m.fechaDeCreacion)
            								ORDER BY fechaDeCreacion DESC
            					) AS rn
        FROM medidas m
        	where m.fkUsuario =@idCliente
        	AND m.fkParametro = @idParametro
        	AND MONTH(m.fechaDeCreacion) in  (select mesOAño from @listadoMeses)
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
      AND (ro.fkEjercicio = @idEjercicio or ro.fkEjercicio is null )
      AND MONTH(ro.fechaDeCreacion) IN (SELECT mesOAño FROM @listadoMeses)
      AND YEAR(ro.fechaDeCreacion) in (SELECT mesOAño FROM @años)	
     order by ro.fechaDeCreacion desc;	
	end
	
	
END;

GO
