using BL;
using BL.Utils;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace GymFrontend.Controllers
{
    public class MedidasController : Controller
    {
        private readonly UsersManager usersManager;
        private readonly MedidasManager medidasManager;
        private readonly Microsoft.Extensions.Logging.ILogger<MedidasController> _logger;

        public MedidasController(UsersManager _usersManager, MedidasManager _medidasManager, Microsoft.Extensions.Logging.ILogger<MedidasController> logger)
        {
            usersManager = _usersManager;
            medidasManager = _medidasManager;
            _logger = logger;
        }
        [HttpPost]
        [Route("registrar")]
        public async Task<IActionResult> registrarMedida(DTO.Dtos.DTOMedida medidaCorporal)
        {
            try
            {
                _logger?.LogInformation("Start MedidasController.registrarMedida");

                if (!ModelState.IsValid)
                {
                    return Json(new { success = false, message = "Datos inválidos" });
                }

                if (medidaCorporal == null)
                {
                    return Json(new { success = false, message = "Datos de medida inválidos" });
                }

                var response = await medidasManager.registrarMedida(medidaCorporal);
                if (response == null)
                {
                    return Json(new { success = false, message = "Error al registrar la medida" });
                }

                return Json(new { success = true, message = response.message ?? "Medida registrada correctamente" });
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: registrarMedida | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error registrarMedida (MedidasController)");
                return Json(new { success = false, message = "Ocurrió un error al registrar la medida." });
            }
        }

        [Authorize(Roles = "cliente")]
        [HttpGet]
        [Route("obtenerEjerciciosYParametrosDelCliente")]
        public async Task<DTO.Dtos.DTOResponse<List<DTO.Dtos.DTOEjerciciosYParametrosDelCliente>>> ObtenerDetallesDeProgreso([FromQuery] string idCliente)
        {
            try
            {
                _logger?.LogInformation("Start MedidasController.ObtenerDetallesDeProgreso idCliente={Id}", idCliente);
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var result = await medidasManager.consultarDetallesDeProgresoDeUsuario(userId);
                
                return result;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerDetallesDeProgreso (lista) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | IdCliente: {idCliente} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error ObtenerDetallesDeProgreso (MedidasController) idCliente={Id}", idCliente);
                
                return ResponseManager.BuildResponse<List<DTO.Dtos.DTOEjerciciosYParametrosDelCliente>>(
                    false, 
                    500, 
                    "Error al obtener detalles de progreso", 
                    new List<DTO.Dtos.ErrorModel> { new DTO.Dtos.ErrorModel { message = ex.Message } }, 
                    null
                );
            }
        }

        [Authorize(Roles = "cliente")]
        [HttpGet]
        [Route("obtenerDetallesDeProgreso")]
        public async Task<DTO.Dtos.DTOResponse<DTO.Dtos.MedidasConMetas>> ObtenerDetallesDeProgreso(
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
            try
            {
                _logger?.LogInformation("Start MedidasController.ObtenerDetallesDeProgreso idCliente={IdCliente} idParametro={IdParametro}", idCliente, idParametro);
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                // Forward the request to BL manager which will call the API
                var response = await medidasManager.consultarDetallesDeProgreso(
                    userId, 
                    idParametro, 
                    idEjercicio, 
                    espaciadoTemporal, 
                    tipoDeBusqueda, 
                    fechaDeInicio, 
                    fechaFin, 
                    conDetalle, 
                    mesesDeFiltro, 
                    añosDeFiltro, 
                    fechaDeCreacion
                );
                
                if (response == null)
                {
                    return ResponseManager.BuildResponse<DTO.Dtos.MedidasConMetas>(
                        false, 
                        404, 
                        "No se encontraron datos de progreso para los parámetros proporcionados", 
                        null, 
                        null
                    );
                }
                return response;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerDetallesDeProgreso (detalle) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | IdCliente: {idCliente} IdParametro: {idParametro} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error ObtenerDetallesDeProgreso (MedidasController) idCliente={IdCliente} idParametro={IdParametro}", idCliente, idParametro);
                
                return ResponseManager.BuildResponse<DTO.Dtos.MedidasConMetas>(
                    false, 
                    500, 
                    "Error al obtener detalles de progreso", 
                    new List<DTO.Dtos.ErrorModel> { new DTO.Dtos.ErrorModel { message = ex.Message } }, 
                    null
                );
            }
        }
    }
}
