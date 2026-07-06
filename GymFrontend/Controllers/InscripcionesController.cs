using System.Security.Claims;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using DTO.Dtos;

namespace GymFrontend.Controllers
{
    public class InscripcionesController : Controller
    {
        private readonly BL.IHttpCustomClient _httpClient;
        private readonly ILogger<InscripcionesController> _logger;

        public InscripcionesController(
            BL.IHttpCustomClient httpClient,
            ILogger<InscripcionesController> logger)
        {
            _httpClient = httpClient;
            _logger = logger;
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("inscripciones/cancelarReagendar")]
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
    }
}
