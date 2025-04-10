declare @datosDeMedida DatosObtencionMetasDeMedida;

INSERT INTO @datosDeMedida (Mes, Año)
VALUES (7, 2025);


--select * from medidas m 
exec sp_obtenerMetasDeMedidas 
 @idCliente = 16,         -- ID del cliente
   @idParametro = 1,       -- ID del parámetro
   @idEjercicio = null,       -- ID del ejercicio (puede ser NULL)
    @datosDeMedida = @datosDeMedida
