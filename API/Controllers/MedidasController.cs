using API.Services;
using BL.Utils;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.CustomValidations;
using DTO.Dtos;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;
using System.Text.Json;
using Microsoft.Extensions.Logging;


namespace API.Controllers
{
    public class MedidasController : Controller
    {


        private readonly FitnessCenterDbContext _db;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger<MedidasController> _logger;
        public MedidasController(FitnessCenterDbContext context
            , UserManager<ApplicationUser> userManager
            , ILogger<MedidasController> logger
            )
        {
            _db = context;
            _userManager = userManager;
            _logger = logger;
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
        public async Task<IActionResult> getParametrosDeMedicion([FromQuery][ValidGuid] string idUsuario)
        {
            DTOResponse<List<DTOParametroDeMedicion>> respuesta = new DTOResponse<List<DTOParametroDeMedicion>>();

            if (!ModelState.IsValid)
            {
                return BadRequest(ResponseManager.BuildResponse<List<DTOParametroDeMedicion>>(
                    false, 400, "Datos inválidos",
                    ModelState.SelectMany(x => x.Value.Errors)
                        .Select(x => new ErrorModel { message = x.ErrorMessage }).ToList(),
                    null));
            }

            // Agregar validación de GUID
                if (string.IsNullOrWhiteSpace(idUsuario) || !Guid.TryParse(idUsuario, out _))
                {
                    return BadRequest(ResponseManager.BuildResponse<List<DTOParametroDeMedicion>>(
                        false, 400, "El idUsuario debe tener formato GUID válido",
                        new List<ErrorModel> { new ErrorModel { propiedad = "idUsuario", message = "El idUsuario debe tener formato GUID válido" } },
                        null));
                }

                try
                {
                var listadoParametrosDeMedicion = await _db.parametrosDeMedicionSP.FromSqlInterpolated($@"EXEC sp_obtenerParametrosDeMedicionConUnidad").ToListAsync();
                respuesta = ResponseManager.BuildResponse(true, 200, "consulta exitosa", null,listadoParametrosDeMedicion);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in getParametrosDeMedicion idUsuario={IdUsuario}", idUsuario);
                respuesta = ResponseManager.BuildResponse<List<DTOParametroDeMedicion>>(false, 500, "Error al consultar los parametros de medicion", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
            }
            return Ok(respuesta);
        }

        [Authorize(Roles = "cliente")]
        [HttpGet]
        [Route("api/progresoDeUsuario")]
        public async Task<IActionResult> getProgresoDelCliente([FromQuery][ValidGuid] string idUsuario)
        {
            DTOResponse<List<DTOItemProgreso>> respuesta = new DTOResponse<List<DTOItemProgreso>>();

            if (!ModelState.IsValid)
            {
                return BadRequest(ResponseManager.BuildResponse<List<DTOItemProgreso>>(
                    false, 400, "Datos inválidos",
                    ModelState.SelectMany(x => x.Value.Errors)
                        .Select(x => new ErrorModel { message = x.ErrorMessage }).ToList(),
                    null));
            }

            // Agregar validación de GUID
            if (string.IsNullOrWhiteSpace(idUsuario) || !Guid.TryParse(idUsuario, out _))
            {
                return BadRequest(ResponseManager.BuildResponse<List<DTOItemProgreso>>(
                    false, 400, "El idUsuario debe tener formato GUID válido",
                    new List<ErrorModel> { new ErrorModel { propiedad = "idUsuario", message = "El idUsuario debe tener formato GUID válido" } },
                    null));
            }

            try
            {
                // Llamar al stored procedure para obtener ultimas medidas
                var ultimasMedidas = await _db.ultimasMedidasDeParametroSP.FromSqlInterpolated($@"EXEC sp_obtenerUltimasMedidasDelUsuario @idUsuario={idUsuario}").ToListAsync();

                // Llamar al stored procedure para obtener ultimas metas
                var ultimasMetas = await _db.ultimasMetasDeParametroSP.FromSqlInterpolated($@"EXEC sp_obtenerMetasActualesDelClientePorParametro @idUsuario={idUsuario}").ToListAsync();

                // Ensamblar items de progreso (usar ObjectAssembler existente si aplica)
                var itemsProgreso = BL.Utils.ObjectAssembler.ensamblarItemsProgreso(ultimasMedidas, ultimasMetas);
                _logger.LogInformation("ItemsProgreso: {Items}", JsonSerializer.Serialize(itemsProgreso, new JsonSerializerOptions { WriteIndented = true }));
                
                respuesta = ResponseManager.BuildResponse(true, 200, "Consulta exitosa", null, itemsProgreso);
                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener progreso del cliente idUsuario={IdUsuario}", idUsuario);
                respuesta = ResponseManager.BuildResponse<List<DTOItemProgreso>>(false, 500, "Error al obtener progreso del cliente", new List<ErrorModel> { new ErrorModel { message = ex.Message, propiedad = null } }, null);
                return StatusCode(500, respuesta);
            }
        }

        [Authorize(Roles = "empleado,cliente")]
        [HttpGet]
        [Route("api/obtenerAñosConActividadDelCliente")]
        public async Task<IActionResult> getAñosActivo([FromQuery][ValidGuid] string idCliente)
        {
            
            HttpResponseAñosActivo respuesta = new HttpResponseAñosActivo();
            List<int> añosActivo = new List<int>();

            if (!ModelState.IsValid)
            {
                return BadRequest(ResponseManager.BuildResponse<List<int>>(
                    false, 400, "Datos inválidos",
                    ModelState.SelectMany(x => x.Value.Errors)
                        .Select(x => new ErrorModel { message = x.ErrorMessage }).ToList(),
                    null));
            }

            // Agregar validación de GUID
            if (string.IsNullOrWhiteSpace(idCliente) || !Guid.TryParse(idCliente, out _))
            {
                return BadRequest(ResponseManager.BuildResponse<List<int>>(
                    false, 400, "El idCliente debe tener formato GUID válido",
                    new List<ErrorModel> { new ErrorModel { propiedad = "idCliente", message = "El idCliente debe tener formato GUID válido" } },
                    null));
            }

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
                _logger.LogError(ex, "Error in getAñosActivo idCliente={IdCliente}", idCliente);
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
            [FromQuery][ValidGuid] string idCliente,
            [FromQuery] int idParametro,
            [FromQuery] int? idEjercicio,
            [FromQuery][ValidEspaciadoTemporal] string? espaciadoTemporal,
            [FromQuery][ValidTipoDeBusqueda] string? tipoDeBusqueda,
            [FromQuery] DateTime? fechaDeInicio = null,
            [FromQuery] DateTime? fechaFin = null,
            [FromQuery] bool conDetalle = false,
            [FromQuery] int[]? mesesDeFiltro = null,
            [FromQuery] int[]? añosDeFiltro = null,
            [FromQuery] DateTime? fechaDeCreacion = null
        )
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ResponseManager.BuildResponse<MedidasConMetas>(
                    false, 400, "Datos inválidos",
                    ModelState.SelectMany(x => x.Value.Errors)
                        .Select(x => new ErrorModel { message = x.ErrorMessage }).ToList(),
                    null));
            }

            try
            {
                // Validaciones de parámetros
                if (string.IsNullOrWhiteSpace(idCliente) || !Guid.TryParse(idCliente, out _))
                {
                    return BadRequest(ResponseManager.BuildResponse<MedidasConMetas>(
                        false, 400, "El idCliente debe tener formato GUID válido",
                        new List<ErrorModel> { new ErrorModel { propiedad = "idCliente", message = "El idCliente debe tener formato GUID válido" } },
                        null));
                }

                if (idParametro < 0)
                {
                    return BadRequest(ResponseManager.BuildResponse<MedidasConMetas>(
                        false, 400, "El idParametro no puede ser negativo",
                        new List<ErrorModel> { new ErrorModel { propiedad = "idParametro", message = "El idParametro no puede ser negativo" } },
                        null));
                }

                if (!string.IsNullOrEmpty(espaciadoTemporal) && 
                    !new[] { "individual", "promedio" }.Contains(espaciadoTemporal.ToLower()))
                {
                    return BadRequest(ResponseManager.BuildResponse<MedidasConMetas>(
                        false, 400, "El espaciadoTemporal debe ser 'individual' o 'promedio'",
                        new List<ErrorModel> { new ErrorModel { propiedad = "espaciadoTemporal", message = "El espaciadoTemporal debe ser 'individual' o 'promedio'" } },
                        null));
                }

                if (!string.IsNullOrEmpty(tipoDeBusqueda) && 
                    !new[] { "MES", "AÑO" }.Contains(tipoDeBusqueda.ToUpper()))
                {
                    return BadRequest(ResponseManager.BuildResponse<MedidasConMetas>(
                        false, 400, "El tipoDeBusqueda debe ser 'MES' o 'AÑO'",
                        new List<ErrorModel> { new ErrorModel { propiedad = "tipoDeBusqueda", message = "El tipoDeBusqueda debe ser 'MES' o 'AÑO'" } },
                        null));
                }

                if (idParametro == 0) {
                    idParametro = _db.ParametrosDeMedicions.FirstOrDefault(param => param.Nombre == "peso").ParametroMedicionId;
                }
                 // Prepare datatables for structured parameters - ensure they have correct structure
                DataTable mesesPorDefecto = new DataTable();
                mesesPorDefecto.Columns.Add("mesOAño", typeof(int));
                DataTable añosPorDefecto = new DataTable();
                añosPorDefecto.Columns.Add("mesOAño", typeof(int));
                DataTable datosDeMedida = new DataTable();
                
                List<DatosMetaDeMedida> datosMetaDeMedida = ObjectAssembler.ensamblarDatosMetaDeMedida(mesesDeFiltro, añosDeFiltro);

                if (mesesDeFiltro != null && mesesDeFiltro.Length > 0)
                {
                    mesesPorDefecto = DataTableConverter.ConvertToDataTable(mesesDeFiltro);
                }
                else
                {
                    // Add a dummy row to ensure the structured parameter is not empty
                    var row = mesesPorDefecto.NewRow();
                    row["mesOAño"] = 0;
                    mesesPorDefecto.Rows.Add(row);
                }
                
                if (añosDeFiltro != null && añosDeFiltro.Length > 0)
                {
                    añosPorDefecto = DataTableConverter.ConvertToDataTable(añosDeFiltro);
                }
                else
                {
                    // Add a dummy row to ensure the structured parameter is not empty
                    var row = añosPorDefecto.NewRow();
                    row["mesOAño"] = 0;
                    añosPorDefecto.Rows.Add(row);
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
                _logger.LogError(ex, "Error in ObtenerDetallesDeProgresoApi idCliente={IdCliente} idParametro={IdParametro}", idCliente, idParametro);
                return StatusCode(500, ResponseManager.BuildResponse<MedidasConMetas>(false, 500, "Error al ejecutar el procedimiento almacenado", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null));
            }
        }
    }
}