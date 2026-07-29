using System.Net.Http.Json;
using System.Security.Claims;
using System.Text.Json;
using BL;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace GymFrontend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class InscripcionesController : Controller
    {
        private readonly IHttpCustomClient _httpClient;
        private readonly ILogger<InscripcionesController> _logger;

        public InscripcionesController(
            IHttpCustomClient httpClient,
            ILogger<InscripcionesController> logger)
        {
            _httpClient = httpClient;
            _logger = logger;
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("cancelarReagendar")]
        
        public async Task<IActionResult> CancelarReagendarInscripcion()
        {
            try
            {
                _logger.LogInformation("Start InscripcionesController.CancelarReagendarInscripcion (GET)");

                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

                if (string.IsNullOrWhiteSpace(userId) || !Guid.TryParse(userId, out _))
                {
                    _logger.LogWarning("ID de usuario invalido: {UserId}", userId);
                    return RedirectToAction("dirigirAAccesoDenegado", "Users");
                }

                var response = await _httpClient.get("api/obtenerUsuariosPorRol?rol=cliente&estado=activo");

                List<QueryUser>? clientes = null;
                if (response != null)
                {
                    var apiResponse = JsonSerializer.Deserialize<DTOResponse<List<QueryUser>>>(
                        response,
                        new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                    clientes = apiResponse?.payload;
                }

                return View("CancelarReagendarInscripcion", clientes ?? new List<QueryUser>());
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error CancelarReagendarInscripcion (InscripcionesController)");
                ViewBag.ErrorMessage = "Ocurrió un error al cargar los datos.";
                return View("CancelarReagendarInscripcion", new List<QueryUser>());
            }
        }

        [Authorize(Roles = "empleado")]
        [HttpPost]
        [Route("cancelar")]
        public async Task<IActionResult> CancelarInscripcion([FromBody] JsonElement body)
        {
            try
            {
                _logger.LogInformation("Start InscripcionesController.CancelarInscripcion (POST)");

                var idInscripcion = body.GetProperty("idInscripcion").GetInt32();

                var apiRequest = new CancelarInscripcionRequest
                {
                    IdInscripcion = idInscripcion
                };

                var jsonContent = JsonContent.Create(apiRequest);
                var apiResponse = await _httpClient.post("api/inscripciones/cancelar", jsonContent);

                return Content(apiResponse ?? "{}", "application/json");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error CancelarInscripcion (InscripcionesController)");
                return StatusCode(500, new { success = false, message = "Error al cancelar inscripción" });
            }
        }
    }
}
