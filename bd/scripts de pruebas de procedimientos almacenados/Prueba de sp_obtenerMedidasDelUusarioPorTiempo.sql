select * from parametrosDeMedicion pdm 
select * from LogErrores le  order by id desc
declare 
@listadoMeses UnidadDeTiempo,
	@listadoAños UnidadDeTiempo,
	@fechaInicial datetime = CONVERT(DATETIME, '2025-03-17', 120) ,
	@fechaFinal datetime = CONVERT(DATETIME, '2025-04-30', 120),
	@espaciadoTemporal nvarchar(10) = 'rango',
	@tipoDeBusqueda nvarchar(10) = 'mes',
	@datosDeMedida DatosObtencionMetasDeMedida;
insert into @listadoMeses values(7),(3)--,(1),(4)--(1),(2),(4),(4),(5),(6),(7),(8),(8),(10),(11),(12);
insert into @listadoAños values(2024)

--select * from medidas m  where m.fkUsuario = 16 and fkParametro  = 4 
--update medidas set fkEjercicio = 4 where medidaId = 151


    --select * from parametrosDeMedicion pdm 
--select * from medidas where fkUsuario = 16  and MONTH (fechaDeCreacion) in (3,7)   and fkParametro = 4 and fkParametro  = 4
    exec sp_obtenerMedidasDelUsuarioPorTiempo 
	@idCliente = 16 ,
	@idParametro = 1, 
	@idEjercicio = null,
	@años = @listadoAños,
	@meses = @listadoMeses,
	@espaciadoTemporal = 'individual',
	@tipoDeBusqueda = 'año',
	@fechaDeInicio = @fechaInicial,
	@fechaFin = @fechaFinal,
	@conDetalles = 1;
