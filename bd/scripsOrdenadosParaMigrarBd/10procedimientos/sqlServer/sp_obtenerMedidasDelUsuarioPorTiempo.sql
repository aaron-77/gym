-- =============================================
-- PROCEDURE: sp_obtenerMedidasDelUsuarioPorTiempo
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_obtenerMedidasDelUsuarioPorTiempo]
    @idCliente nvarchar(450),
    @idParametro INT,
    @idEjercicio INT = NULL,
    @espaciadoTemporal NVARCHAR(30),
    @tipoDeBusqueda NVARCHAR(10),
    @meses UnidadDeTiempo readonly,
    @años UnidadDeTiempo readonly, -- Tabla de enteros para meses o años
    @fechaDeInicio DATETIME = NULL,
    @fechaFin DATETIME = NULL,
    @conDetalles int
AS
BEGIN
     SET NOCOUNT ON;
    
declare @parametrosConcatenados nvarchar(max);
   SET @parametrosConcatenados = CONCAT(
        'idCliente: ', @idCliente, ', ',
        'idParametro: ', @idParametro ,', ',
        'idEjercicio: ', COALESCE(CAST(@idEjercicio AS NVARCHAR), 'NULL'), ', ',
        'Espaciado Temporal: ', @espaciadoTemporal, ', ',
        'Tipo de Búsqueda: ', @tipoDeBusqueda, ', ',
        'Meses: ', (SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @meses), ', ',
        'Años: ', (SELECT STRING_AGG(CAST(mesOAño AS NVARCHAR), ',') FROM @años), ', ',
        'Fecha de Inicio: ', COALESCE(CAST(@fechaDeInicio AS NVARCHAR), 'NULL'), ', ',
        'Fecha Fin: ', COALESCE(CAST(@fechaFin AS NVARCHAR), 'NULL'), ', ',
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
	IF @espaciadoTemporal = 'rango'
    BEGIN
        -- Llamar a sp_obtenerMedidasPorRangoDeMeses
        EXEC sp_obtenerMedidasPorRangoDeMeses 
            @idCliente = @idCliente,
            @idParametro = @idParametro,
            @idEjercicio = @idEjercicio,
            @fechaInicial = @fechaDeInicio,
            @fechaFinal = @fechaFin,
            @conDetalles = @conDetalles
           ;
    END
    ELSE
	BEGIN
		-- Se verifica si @espaciadoTemporal es 'individual' y @tipoDeBusqueda es 'MES'
		    IF @espaciadoTemporal = 'individual' AND @tipoDeBusqueda = 'MES'
		    BEGIN
		        -- Llamar a sp_ObtenerMedidasPorMesesEspecificos
		        EXEC sp_ObtenerMedidasPorMesesEspecificos 
		            @idCliente = @idCliente,
		            @idParametro = @idParametro,
		            @idEjercicio = @idEjercicio,
		            @años =@años,
		            @listadoDeMeses = @meses,
		            @conDetalles = @conDetalles;	
		    END
		    ELSE
			    BEGIN
			   		 -- Se verifica si @espaciadoTemporal es 'individual' y @tipoDeBusqueda es 'AÑO'
				    IF @espaciadoTemporal = 'individual' AND @tipoDeBusqueda = 'AÑO'
					    BEGIN
					        -- Llamar a sp_ObtenerMedidasPorAñosEspecificos
					        EXEC sp_ObtenerMedidasPorAñosEspecificos 
					            @idCliente = @idCliente,
					            @idParametro = @idParametro,
					            @idEjercicio = @idEjercicio,
					            @años = @años,
					            @conDetalles = @conDetalles;
					    END 	
			    END
	END
END;

--obtiene los parametros de las medidas de los cliente de los ejercicio que ya realizo el cliente, 
-- no se devuelve ningun nombre de parametro de ejercicios que el cliente no ha hecho

GO
