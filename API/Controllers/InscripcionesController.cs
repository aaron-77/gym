using System.Security.Claims;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

using API.Services;
using API.Services.Validaciones;
using BL.Utils;
using BL.Validaciones;
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
        private readonly IValidadorUsuarioExistente _validadorUsuario;
        private readonly ILogger<InscripcionesController> _logger;

        public InscripcionesController(
            IInscripcionesService service,
            IValidadorUsuarioExistente validadorUsuario,
            ILogger<InscripcionesController> logger)
        {
            _service = service;
            _validadorUsuario = validadorUsuario;
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
        public async Task<IActionResult> ObtenerInscripcionesDelCliente(string? idUsuario)
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
                    var (existe, _) = await _validadorUsuario.ValidarAsync(authenticatedUserId);
                    if (!existe)
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

                // Paso 5: Llamar al servicio para obtener las inscripciones
                //         (el servicio valida internamente que el cliente exista)
                var result = await _service.ConsultarInscripcionesDeClienteAsync(idUsuario);

                // Paso 6: Retornar la respuesta según el código HTTP del DTO
                return Responder(result);
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

        /// <summary>
        /// POST api/inscripciones/cancelar
        /// Cancela una inscripción validando que exista y que la clase no haya finalizado.
        /// Solo accesible por usuarios con rol "empleado".
        /// </summary>
        [HttpPost]
        [Authorize(Roles = "empleado")]
        [Route("api/inscripciones/cancelar")]
        public async Task<IActionResult> CancelarInscripcion([FromBody] CancelarInscripcionRequest request)
        {
            try
            {
                _logger.LogInformation("Start CancelarInscripcion");

                // Paso 1: Obtener el ID del usuario autenticado desde el token JWT
                var authenticatedUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);

                // Paso 2: Validar que el ID del usuario tenga formato GUID válido
                if (!Guid.TryParse(authenticatedUserId, out _))
                {
                    return BadRequest(ResponseManager.BuildResponse<object>(
                        success: false,
                        httpCode: 400,
                        message: "Datos inválidos",
                        errors: new List<ErrorModel>
                        {
                            new() { message = "El ID del usuario autenticado no tiene un formato GUID válido.", propiedad = null }
                        },
                        payload: null!));
                }

                // Paso 3: Validar que el usuario autenticado exista en BD
                var (existe, _) = await _validadorUsuario.ValidarAsync(authenticatedUserId);
                if (!existe)
                {
                    _logger.LogWarning("Usuario autenticado no encontrado en BD: {UserId}", authenticatedUserId);
                    return NotFound(ResponseManager.BuildResponse<object>(
                        success: false,
                        httpCode: 404,
                        message: "Usuario no encontrado",
                        errors: new List<ErrorModel>
                        {
                            new() { message = "El usuario autenticado no existe en el sistema.", propiedad = null }
                        },
                        payload: null!));
                }

                // Paso 4: Llamar al servicio de cancelación
                var result = await _service.CancelarInscripcionAsync(request.IdInscripcion);

                // Paso 5: Retornar respuesta según el código HTTP del DTO
                return Responder(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error en CancelarInscripcion");

                return StatusCode(500, ResponseManager.BuildResponse<object>(
                    success: false,
                    httpCode: 500,
                    message: "Error interno del servidor",
                    errors: new List<ErrorModel>
                    {
                        new() { message = "Ocurrió un error al cancelar la inscripción.", propiedad = null }
                    },
                    payload: null!));
            }
        }
        // ──────────────────────────────────────────────
        //  Helpers
        // ──────────────────────────────────────────────

        /// <summary>
        /// Convierte un DTOResponse&lt;T&gt; en el IActionResult correspondiente
        /// según su código HTTP, para mantener sincronizados el status code
        /// de la respuesta HTTP con el httpCode del DTO.
        /// </summary>
        private IActionResult Responder<T>(DTOResponse<T> response)
        {
            return response.httpCode switch
            {
                200 => Ok(response),
                201 => Created(string.Empty, response),
                400 => BadRequest(response),
                404 => NotFound(response),
                _ => StatusCode(response.httpCode, response)
            };
        }
    }
}
