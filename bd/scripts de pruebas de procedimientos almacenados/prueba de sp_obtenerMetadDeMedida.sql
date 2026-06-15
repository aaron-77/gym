declare @datosDeMedida DatosObtencionMetasDeMedida;

INSERT INTO @datosDeMedida (Mes, Año)
VALUES (7, 2025);

select * from Usuarios u 
--select * from medidas m 
exec sp_obtenerMetasDeMedidas 
 @idCliente = 16,         -- ID del cliente
   @idParametro = 1,       -- ID del parámetro
   @idEjercicio = null,       -- ID del ejercicio (puede ser NULL)
    @datosDeMedida = @datosDeMedida
    
    exec showtables 'clases'
    select * from Clases c 
    select * from Usuarios u 
    update Usuarios set RolId = 2 where UsuarioID =22
    select * from estadosClasesProgramadas ecp 
