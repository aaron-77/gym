declare @parametrosConcatenados nvarchar(max);
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL') ', ',
        'Espaciado Temporal: ', @espaciadoTemporal, ', ',
        'Tipo de Búsqueda: ', @tipoDeBusqueda, ', ',
        'Meses: ', (select concat(cast(mesOAño as nvarchar),'') from @meses ) ', ',
        'Años: ', (select concat(cast(mesOAño as nvarchar),'') from @años) ', ',
        'Fecha de Inicio: ', COALESCE(CAST(@fechaDeInicio AS NVARCHAR), 'NULL') ', ',
        'Fecha Fin: ', COALESCE(CAST(@fechaFin AS NVARCHAR), 'NULL') ', ',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPorTiempo',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;




    declare @parametrosConcatenados nvarchar(max);  
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro, ', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
       	'años',(SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años),',',
        'Con Detalles: ', @conDetalles
    );
	-- Verificar si @espaciadoTemporal es 'rango'
    exec sp_RegistrarError @Procedimiento = 'sp_obtenerMedidasDelUsuarioPorTiempo',
    @Mensaje = @parametrosConcatenados ,
    @Severidad = 1,
    @Estado = 1,
    @Usuario  = null, -- Obtiene el usuario actual por defecto
    @Host  = null, -- Obtiene el nombre del host por defecto
    @Aplicacion = null;