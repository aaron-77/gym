using Microsoft.AspNetCore.Mvc;
using DTO.Dtos;
using BL.Utils;
using DataAccess.EntityFramework;
using Microsoft.EntityFrameworkCore;
using System.Data;
using Microsoft.Data.SqlClient;
using EllipticCurve.Utils;
using API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using DataAccess.Identity;


namespace API.Controllers
{
    public class MedidasController : Controller
    {


        private readonly FitnessCenterDbContext _db;
        private readonly UserManager<ApplicationUser> _userManager;
        public MedidasController(FitnessCenterDbContext context
            , UserManager<ApplicationUser> userManager
            )
        {
            _db = context;
            _userManager = userManager;
        }

        [Authorize(Roles = "empleado")]
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
                _db.Add(newUserDB);
                _db.SaveChanges();
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


            [Authorize(Roles = "empleado,cliente")]
            [HttpGet]
            [Route("api/getParametrosDeMedicion")]
            public async Task<IActionResult> getParametrosDeMedicion([FromQuery] int idUsuario)
        {
            
            DTOResponse<List<DTOParametroDeMedicion>> respuesta = new DTOResponse<List<DTOParametroDeMedicion>>();

            try
            {
                var listadoParametrosDeMedicion = await _db.parametrosDeMedicionSP.FromSqlInterpolated($@"EXEC sp_obtenerParametrosDeMedicionConUnidad").ToListAsync();
                respuesta = ResponseManager.BuildResponse(true, 200, "consulta exitosa", null,listadoParametrosDeMedicion);
            }
            catch (Exception ex)
            {
                respuesta = ResponseManager.BuildResponse<List<DTOParametroDeMedicion>>(false, 500, "Error al consultar los parametros de medicion", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
            }
            return Ok(respuesta);
        }

        [Authorize(Roles = "cliente")]
        [HttpGet]
        [Route("api/progresoDeUsuario")]
        public async Task<IActionResult> getProgresoDelCliente([FromQuery] string idUsuario)
        {
            DTOResponse<List<DTOItemProgreso>> respuesta = new DTOResponse<List<DTOItemProgreso>>();
            try
            {
                // Llamar al stored procedure para obtener ultimas medidas
                var ultimasMedidas = await _db.ultimasMedidasDeParametroSP.FromSqlInterpolated($@"EXEC sp_obtenerUltimasMedidasDelUsuario @idUsuario={idUsuario}").ToListAsync();

                // Llamar al stored procedure para obtener ultimas metas
                var ultimasMetas = await _db.ultimasMetasDeParametroSP.FromSqlInterpolated($@"EXEC sp_obtenerMetasActualesDelClientePorParametro @idUsuario={idUsuario}").ToListAsync();

                // Ensamblar items de progreso (usar ObjectAssembler existente si aplica)
                var itemsProgreso = BL.Utils.ObjectAssembler.ensamblarItemsProgreso(ultimasMedidas, ultimasMetas);

                respuesta = ResponseManager.BuildResponse(true, 200, "Consulta exitosa", null, itemsProgreso);
                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al ontener el progreso el usuario {ex.Message}\n {ex.StackTrace}");
                respuesta = ResponseManager.BuildResponse<List<DTOItemProgreso>>(false, 500, "Error al obtener progreso del cliente", new List<ErrorModel> { new ErrorModel { message = ex.Message, propiedad = null } }, null);
                return StatusCode(500, respuesta);
            }
        }

        [Authorize(Roles = "empleado,cliente")]
        [HttpGet]
        [Route("api/obtenerAñosConActividadDelCliente")]
        public async Task<IActionResult> getAñosActivo([FromQuery] string idCliente)
        {
            
            HttpResponseAñosActivo respuesta = new HttpResponseAñosActivo();
            List<int> añosActivo = new List<int>();
            try
            {
                añosActivo = await _db.Medidas.Where(m => m.FkUsuario == idCliente).Select(m => m.FechaDeCreacion.Value.Year).Distinct().ToListAsync();
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


        
        [Authorize(Roles = "empleado,cliente")]
        [HttpGet("api/obtenerEjerciciosYParametros")]
        public async Task<ActionResult<DTOResponse<List<DTOEjerciciosYParametrosDelCliente>>>> ObtenerDetallesDeProgreso([FromQuery] string idCliente)
        {
            try
            {
                var existingClient = await _userManager.FindByIdAsync(idCliente);
                if (existingClient == null)
                {
                    return BadRequest(ResponseManager.BuildResponse<List<DTOEjerciciosYParametrosDelCliente>>(false, 400, "El cliente no existe", new List<ErrorModel> { new ErrorModel { propiedad = "idCliente", message = "Cliente no encontrado" } }, null));
                }

                var ejercicioYParametros = await _db.ejerciciosYParametrosDelClienteSP.FromSqlInterpolated($@"EXEC sp_obtenerEjerciciosYParametrosDelCliente @idCliente={idCliente}").ToListAsync();

                var respuesta = ResponseManager.BuildResponse(true, 200, "Consulta exitosa", null, ejercicioYParametros);

                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ResponseManager.BuildResponse<List<DTOEjerciciosYParametrosDelCliente>>(false, 500, $"Error al ejecutar el procedimiento almacenado: {ex.Message}", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null));
            }
        }

        [Authorize(Roles = "cliente,empleado")]
        [HttpGet("api/obtenerDetallesDeProgreso")]
        public async Task<ActionResult<DTOResponse<MedidasConMetas>>> ObtenerDetallesDeProgresoApi(
            [FromQuery] string idCliente,
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
            try
            {
                if (idParametro == 0) {
                    idParametro = _db.ParametrosDeMedicions.FirstOrDefault(param => param.Nombre == "peso").ParametroMedicionId;
                }
                // Prepare datatables for structured parameters
                DataTable mesesPorDefecto = new DataTable();
                DataTable añosPorDefecto = new DataTable();
                DataTable datosDeMedida = new DataTable();
                
                List<DatosMetaDeMedida> datosMetaDeMedida = ObjectAssembler.ensamblarDatosMetaDeMedida(mesesDeFiltro, añosDeFiltro);

                if (mesesDeFiltro != null && mesesDeFiltro.Length > 0)
                {
                    mesesPorDefecto = DataTableConverter.ConvertToDataTable(mesesDeFiltro);
                }
                if (añosDeFiltro != null && añosDeFiltro.Length > 0)
                {
                    añosPorDefecto = DataTableConverter.ConvertToDataTable(añosDeFiltro);
                }

                using var connection = (SqlConnection)_db.Database.GetDbConnection();
                if (connection.State == ConnectionState.Closed)
                {
                    await connection.OpenAsync();
                }

                var command = SqlCommandHelper.CreateSqlCommand(connection, "sp_obtenerMedidasDelUsuarioPorTiempo", CommandType.StoredProcedure, null);
                Dictionary<string, (SqlDbType DbType, object Value, int? lengthType)> parametersToSP = new Dictionary<string, (SqlDbType, object, int?)>
                {
                    { "@idCliente", (SqlDbType.NVarChar, idCliente, null) },
                    { "@idParametro", (SqlDbType.Int, idParametro, null) },
                    { "@idEjercicio", (SqlDbType.Int, idEjercicio, null) },
                    { "@espaciadoTemporal", (SqlDbType.NVarChar, espaciadoTemporal, 30) },
                    { "@tipoDeBusqueda", (SqlDbType.NVarChar, tipoDeBusqueda, 10) },
                    { "@meses", (SqlDbType.Structured, mesesPorDefecto, null) },
                    { "@años", (SqlDbType.Structured, añosPorDefecto, null) },
                    { "@fechaDeInicio", (SqlDbType.DateTime, (object)fechaDeInicio ?? DBNull.Value, null) },
                    { "@fechaFin", (SqlDbType.DateTime, (object)fechaFin ?? DBNull.Value, null) },
                    { "@conDetalles", (SqlDbType.Int, conDetalle ? 1 : 0, null) }
                };


                datosDeMedida = DataTableConverter.ConvertToDataTable<DatosMetaDeMedida>(datosMetaDeMedida);
                var parametersToSP2 = new Dictionary<string, (SqlDbType, object, int?)>
                {
                    { "@idCliente", (SqlDbType.NVarChar, idCliente, null) },
                    { "@idParametro", (SqlDbType.Int, idParametro, null) },
                    { "@idEjercicio", (SqlDbType.Int, idEjercicio == 0 ? DBNull.Value : (object)idEjercicio, null) },
                    { "@datosDeMedida", (SqlDbType.Structured, datosDeMedida, null) }
                };

                SqlCommandHelper.AddParameters(command, parametersToSP);
                var reader = await SqlCommandHelper.ExecuteCommandAsync(command);
                List<DTOUltimaMedidaDeParametro> medidas = SqlCommandHelper.MapToList<DTOUltimaMedidaDeParametro>(reader);

                var commandObtenerMetas = SqlCommandHelper.CreateSqlCommand(connection, "sp_obtenerMetasDeMedidas", CommandType.StoredProcedure, null);
                SqlCommandHelper.AddParameters(commandObtenerMetas, parametersToSP2);
                reader.Close();
                var reader2 = await SqlCommandHelper.ExecuteCommandAsync(commandObtenerMetas);
                List<DTOUltimaMetaDeParametro> metas = SqlCommandHelper.MapToList<DTOUltimaMetaDeParametro>(reader2);

                var payload = new MedidasConMetas();
                payload.medidas = medidas;
                payload.metasDeMedida = metas;

                var respuesta = ResponseManager.BuildResponse(true, 200, "Consulta exitosa", null, payload);
                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ResponseManager.BuildResponse<MedidasConMetas>(false, 500, "Error al ejecutar el procedimiento almacenado", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null));
            }
        }
    }
}