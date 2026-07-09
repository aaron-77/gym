using System.Security.Claims;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

using API.Services;
using BL.Utils;
using BL.Validaciones;
using DataAccess.Identity;
using DTO.Dtos;

namespace API.Controllers
{
    /// <summary>
    /// Controlador para endpoints relacionados con inscripciones.
    /// </summary>
    [ApiController]
    public class InscripcionesController : ControllerBase
    {
        private readonly IInscripcionesService _service;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger<InscripcionesController> _logger;

        public InscripcionesController(
            IInscripcionesService service,
            UserManager<ApplicationUser> userManager,
            ILogger<InscripcionesController> logger)
        {
            _service = service;
            _userManager = userManager;
            _logger = logger;
        }

        /// <summary>
        /// GET api/inscripciones/obtenerInscripcionesDelCliente/{idUsuario}
        /// Obtiene las inscripciones vigentes de un cliente en clases futuras.
        /// Solo accesible por usuarios con rol "empleado".
        /// </summary>
        [HttpGet]
        [Authorize(Roles = "empleado")]
        [Route("api/inscripciones/obtenerInscripcionesDelCliente/{idUsuario?}")]
        public async Task<IActionResult> ObtenerInscripcionesDelCliente(string idUsuario)
        {
            try
            {
                _logger.LogInformation("Start ObtenerInscripcionesDelCliente idUsuario={IdUsuario}", idUsuario);

                // Paso 1 y 2: Validar formato del ID (null, vacío, whitespace, GUID)
                var (esValido, mensajeError) = ValidadorStringId.Validar(idUsuario, "ID de usuario");
                if (!esValido)
                {
                    return BadRequest(ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                        success: false,
                        httpCode: 400,
                        message: "Datos inválidos",
                        errors: new List<ErrorModel>
                        {
                            new() { message = mensajeError, propiedad = "idUsuario" }
                        },
                        payload: null!));
                }

                // Paso 3: Obtener el ID del usuario autenticado desde el token JWT
                var authenticatedUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);

                // Paso 4: Validar que el usuario que hace la petición exista
                if (!string.IsNullOrEmpty(authenticatedUserId))
                {
                    var authenticatedUser = await _userManager.FindByIdAsync(authenticatedUserId);
                    if (authenticatedUser == null)
                    {
                        _logger.LogWarning("Usuario autenticado no encontrado en BD: {UserId}", authenticatedUserId);
                        return NotFound(ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                            success: false,
                            httpCode: 404,
                            message: "Usuario no encontrado",
                            errors: new List<ErrorModel>
                            {
                                new() { message = "El usuario autenticado no existe en el sistema.", propiedad = null }
                            },
                            payload: null!));
                    }
                }

                // Paso 5: Validar que el cliente del que se consulta exista
                var cliente = await _userManager.FindByIdAsync(idUsuario);
                if (cliente == null)
                {
                    return NotFound(ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                        success: false,
                        httpCode: 404,
                        message: "Cliente no encontrado",
                        errors: new List<ErrorModel>
                        {
                            new() { message = "El cliente especificado no existe.", propiedad = "idUsuario" }
                        },
                        payload: null!));
                }

                // Paso 6: Llamar al servicio para obtener las inscripciones
                var result = await _service.ConsultarInscripcionesDeClienteAsync(idUsuario);

                // Paso 7: Retornar la respuesta del servicio
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error en ObtenerInscripcionesDelCliente idUsuario={IdUsuario}", idUsuario);

                return StatusCode(500, ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                    success: false,
                    httpCode: 500,
                    message: "Error interno del servidor",
                    errors: new List<ErrorModel>
                    {
                        new() { message = "Ocurrió un error al consultar las inscripciones.", propiedad = null }
                    },
                    payload: null!));
            }
        }
    }
}
