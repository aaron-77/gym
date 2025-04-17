using Microsoft.AspNetCore.Mvc;
using DTO.Dtos;
using BL.Utils;
using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;
using System.Data;
using Microsoft.Data.SqlClient;
using EllipticCurve.Utils;


namespace FitnessGymApi.Controllers
{
    public class MedidasController : Controller
    {
        [HttpPost]
        [Route("api/RegistrarMedida")]
        public IActionResult Index([FromBody] DTO.Dtos.DTOMedida medida)
        {
            HTTPResponseModelMedida respuesta = new HTTPResponseModelMedida();
            if (!ModelState.IsValid)
            {
                List<string> nombresCampos = new List<string>() { "peso", "altura", "edad", "imc", "genero" };
                foreach (var item in ModelState.Values)
                {
                    foreach (var item1 in item.Errors)
                    {
                        ErrorModel error = new ErrorModel();
                        string nombreCampo = nombresCampos.Where(c => item1.ErrorMessage.Contains(c)).FirstOrDefault();
                        error.propiedad = nombreCampo;
                        error.message = item1.ErrorMessage;
                        respuesta.errors.Add(error);
                    }

                }
                ;
                respuesta.ok = false;
                respuesta.message = "Error al registrar las medidas";
                return BadRequest(respuesta);
            }

            FitnessCenterDbContext db = new FitnessCenterDbContext();

            if (medida == null)
            {

                return null;
            }
            Medida newUserDB = new Medida()
            {

                FkUsuario = medida.fkUsuario,
                FkParametro = medida.fkParametro,
                Valor = medida.valor
            };
            try
            {
                db.Add(newUserDB);
                db.SaveChanges();
                respuesta.ok = true;
                respuesta.data = medida;
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.data = null;
                ErrorModel error = new ErrorModel();
                error.message = ex.Message;
                respuesta.message = "No se han podido registrar las medidas";
                respuesta.errors.Add(error);
                return BadRequest(respuesta);
            }
            return Ok(respuesta);
        }


        [HttpGet]
        [Route("api/getParametrosDeMedicion")]
        public async Task<IActionResult> getParametrosDeMedicion([FromQuery] int idUsuario)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            ResponseParametroDeMedicion respuesta = new ResponseParametroDeMedicion();
            try
            {
                var listadoParametrosDeMedicion = await db.parametrosDeMedicionSP.FromSqlInterpolated($@"EXEC sp_obtenerParametrosDeMedicionConUnidad").ToListAsync();
                respuesta.ok = true;
                respuesta.message = "consulta exitosa";
                respuesta.errors = null;
                respuesta.data = listadoParametrosDeMedicion;
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.message = "Error al consultar los parametros de medicion";
                respuesta.errors = null;
                respuesta.data = null;
            }
            return Ok(respuesta);
        }

        [HttpGet]
        [Route("api/progresoDeUsuario")]
        public async Task<IActionResult> getProgresoDelCliente([FromQuery] int idUsuario)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            HttpResponseProgresoUsuario respuesta = new HttpResponseProgresoUsuario();
            List<DTOItemProgreso> itemsProgreso = null;
            try
            {
                var ultimasMedidas = await db.ultimasMedidasDeParametroSP.FromSqlInterpolated($@"EXEC sp_obtenerUltimasMedidasDelUsuario @idUsuario={idUsuario}").ToListAsync();
                var ultimasMetas = await db.ultimasMetasDeParametroSP.FromSqlInterpolated($@"EXEC sp_obtenerMetasActualesDelClientePorParametro @idUsuario={idUsuario}").ToListAsync();
                itemsProgreso = ObjectAssembler.ensamblarItemsProgreso(ultimasMedidas, ultimasMetas);
                respuesta.ok = true;
                respuesta.message = "consulta exitosa";
                respuesta.errors = null;
                respuesta.data = itemsProgreso;
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.message = "Error al consultar los parametros de medicion";
                respuesta.errors = null;
                respuesta.data = itemsProgreso;
            }
            return Ok(respuesta);
        }

        [HttpGet]
        [Route("api/obtenerAñosConActividadDelCliente")]
        public async Task<IActionResult> getAñosActivo([FromQuery] int idCliente)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            HttpResponseAñosActivo respuesta = new HttpResponseAñosActivo();
            List<int> añosActivo = new List<int>();
            try
            {
                añosActivo = await db.Medidas.Where(m => m.FkUsuario == idCliente).Select(m => m.FechaDeCreacion.Value.Year).Distinct().ToListAsync();
                respuesta.ok = true;
                respuesta.message = "consulta exitosa";
                respuesta.errors = null;
                respuesta.data = añosActivo;
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.message = "Error al consultar los parametros de medicion";
                respuesta.errors = null;
                respuesta.data = añosActivo;
            }
            return Ok(respuesta);
        }


        [HttpGet("obtenerDetallesDeProgreso")]
        public async Task<ActionResult<List<DTOUltimaMedidaDeParametro>>> ObtenerDetallesDeProgreso(
    [FromQuery] int idCliente,
    [FromQuery] int idParametro,
    [FromQuery] int? idEjercicio,
    [FromQuery] string? espaciadoTemporal,
    [FromQuery] string? tipoDeBusqueda,
    [FromQuery] DateTime? fechaDeInicio = null,
    [FromQuery] DateTime? fechaFin = null,
    [FromQuery] bool conDetalle = false,
    [FromQuery] int[]? mesesDeFiltro = null,
    [FromQuery] int[]? añosDeFiltro = null,
    [FromQuery] DateTime? fechaDeCreacion = null
    )
        {
            HTTPResponseDetallesDeProgreso finalResponse = new HTTPResponseDetallesDeProgreso();
            try
            {
                FitnessCenterDbContext db = new FitnessCenterDbContext();
                DataTable mesesPorDefecto = new DataTable();       // Mes por defecto        
                DataTable añosPorDefecto = new DataTable();        // Año por defecto          
                DataTable datosDeMedida = new DataTable();          // Datos de medida
                List<DatosMetaDeMedida> datosMetaDeMedida = ObjectAssembler.ensamblarDatosMetaDeMedida(mesesDeFiltro, añosDeFiltro);
                if (mesesDeFiltro != null && mesesDeFiltro.Length > 0)
                {
                    mesesPorDefecto = DataTableConverter.ConvertToDataTable(mesesDeFiltro);//(new List<Dictionary<string, int>> { new Dictionary<string, int> { { "mes", mesActual.Value } } });       // Mes por defecto        
                }
                if (añosDeFiltro != null && añosDeFiltro.Length > 0)
                {
                    añosPorDefecto = DataTableConverter.ConvertToDataTable(añosDeFiltro);//(new List<Dictionary<string, int>> { new Dictionary<string, int> { { "año", añoActual.Value } } });        // Año por defecto
                }
                
                // Crear la conexión ADO.NET
                using var connection = (SqlConnection)db.Database.GetDbConnection();
                if (connection.State == ConnectionState.Closed)
                {
                    await connection.OpenAsync();
                }
                var command = SqlCommandHelper.CreateSqlCommand(connection, "sp_obtenerMedidasDelUsuarioPorTiempo", CommandType.StoredProcedure, null);
                Dictionary<string, (SqlDbType DbType, object Value, int? lengthType)> parametersToSP = new Dictionary<string, (SqlDbType DbType, object Value, int? lengthType)>{
                            {"@idCliente",(SqlDbType.Int, idCliente,null)},
                            {"@idParametro",(SqlDbType.Int, idParametro,null)},
                            {"@idEjercicio",(SqlDbType.Int, idEjercicio,null)},
                            {"@espaciadoTemporal",(SqlDbType.NVarChar, espaciadoTemporal,30)},
                            {"@tipoDeBusqueda",(SqlDbType.NVarChar, tipoDeBusqueda,10)},
                            {"@meses",(SqlDbType.Structured, mesesPorDefecto,null)},
                            {"@años",(SqlDbType.Structured, añosPorDefecto,null)},
                            {"@fechaDeInicio",(SqlDbType.DateTime, (object)fechaDeInicio ?? DBNull.Value,null)},
                            {"@fechaFin",(SqlDbType.DateTime, (object)fechaFin ?? DBNull.Value,null)},
                            {"@conDetalles",(SqlDbType.Int, conDetalle,null)}
                        };
                        
                        datosDeMedida = DataTableConverter.ConvertToDataTable(datosMetaDeMedida);
                        Dictionary<string, (SqlDbType DbType, 
                                    object Value,
                                    int? lengthType)> 
                        parametersToSP2 = new Dictionary<string, (SqlDbType DbType, object Value, int? lengthType)>{
                            {"@idCliente",(SqlDbType.Int, idCliente,null)},
                            {"@idParametro",(SqlDbType.Int, idParametro,null)},
                            {"@idEjercicio",(SqlDbType.Int, idEjercicio == 0 ? DBNull.Value : idEjercicio,null)},
                            {"@datosDeMedida",(SqlDbType.Structured, datosDeMedida,null)}
                        };

                SqlCommandHelper.AddParameters(command, parametersToSP);
                var reader = await SqlCommandHelper.ExecuteCommandAsync(command);
                List<DTOUltimaMedidaDeParametro> resultados = SqlCommandHelper.MapToList<DTOUltimaMedidaDeParametro>(reader);
                finalResponse.data.medidas = resultados;
                var commandObtenerMetas = SqlCommandHelper.CreateSqlCommand(connection, "sp_obtenerMetasDeMedidas", CommandType.StoredProcedure, null);
                
                
                SqlCommandHelper.AddParameters(commandObtenerMetas, parametersToSP2);
                reader.Close();
                var reader2 = await SqlCommandHelper.ExecuteCommandAsync(commandObtenerMetas);
                List<DTOUltimaMetaDeParametro> resultados2 = SqlCommandHelper.MapToList<DTOUltimaMetaDeParametro>(reader2);
                finalResponse.data.metasDeMedida = resultados2;
                finalResponse.ok = true;
                finalResponse.message = "Consulta exitosa";
                return Ok(finalResponse);
            }
            catch (Exception ex)
            {
                finalResponse.ok = false;
                finalResponse.message = "Error al ejecutar el procedimiento almacenado";
                finalResponse.errors.Add(new ErrorModel { message = ex.Message });
                return StatusCode(500, finalResponse);
            }   
            return null;
        }

        [HttpGet("api/obtenerEjerciciosYParametros")]
        public async Task<ActionResult<List<DTOEjerciciosYParametrosDelCliente>>> ObtenerDetallesDeProgreso
        ([FromQuery] int idCliente)
        {
            try
            {
                FitnessCenterDbContext db = new FitnessCenterDbContext();
                HttpResponseEjerciciosYParametrosDelCliente responseForFrontend = new HttpResponseEjerciciosYParametrosDelCliente();
                var existingClient = db.Usuarios.Find(idCliente);
                if( existingClient == null){
                    return BadRequest("El cliente no existe");
                }
                var ejercicioYParametros = await db.ejerciciosYParametrosDelClienteSP.FromSqlInterpolated($@"EXEC sp_obtenerEjerciciosYParametrosDelCliente @idCliente={idCliente}").ToListAsync();
                responseForFrontend.ok = true;
                responseForFrontend.message = "Consulta exitosa";
                responseForFrontend.errors = null;  
                responseForFrontend.data = ejercicioYParametros;
                return Ok(responseForFrontend);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al ejecutar el procedimiento almacenado: {ex.Message}");
            }
            return null;
        }
    }
}