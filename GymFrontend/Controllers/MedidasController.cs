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

        private UsersManager usersManager;
        private MedidasManager medidasManager;

        public MedidasController(UsersManager _usersManager, MedidasManager _medidasManager)
        {
            usersManager = _usersManager;
            medidasManager = _medidasManager;
        }
        [HttpPost]
        [Route("registrar")]
        public async Task<IActionResult> registrarMedida(DTO.Dtos.DTOMedida medidaCorporal)
        {


            var respuesta = await usersManager.obtenerUsuarios();

            List<ExistingUser> usuarios = respuesta.payload;
            if (usuarios == null) { 
                usuarios = new List<ExistingUser>();
            }
            ViewBag.usuarios = usuarios;
            if (!ModelState.IsValid)
            {   
                return Redirect("empleados");
            }
            if (medidaCorporal == null)
            {
                medidaCorporal = new DTOMedida();
            }
            

            var response = await medidasManager.registrarMedida(medidaCorporal);
            ViewBag.message = response.message;
            return Redirect("empleados");
        }

        [Authorize(Roles = "cliente")]
        [HttpGet]
        [Route("obtenerEjerciciosYParametrosDelCliente")]
        public async Task<DTO.Dtos.DTOResponse<List<DTO.Dtos.DTOEjerciciosYParametrosDelCliente>>> ObtenerDetallesDeProgreso([FromQuery] string idCliente)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var result = await medidasManager.consultarDetallesDeProgresoDeUsuario(userId);
                
                return result;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerDetallesDeProgreso (obtenerEjerciciosYParametrosDelCliente) | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"IdCliente: {idCliente} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
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
                string logMessage = $"[ERROR] Método: ObtenerDetallesDeProgreso (obtenerDetallesDeProgreso) | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetros - IdCliente: {idCliente}, IdParametro: {idParametro}, IdEjercicio: {idEjercicio}, EspaciadoTemporal: {espaciadoTemporal}, TipoDeBusqueda: {tipoDeBusqueda} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
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
