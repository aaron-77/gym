using System.Security.Claims;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

using API.Infraestructure;
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
                return this.Responder(result);
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
                return this.Responder(result);
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

        /// <summary>
        /// POST api/inscripciones/reagendar
        /// Reagenda una inscripción validando los datos de entrada y llamando al servicio de reagendación.
        /// Solo accesible por usuarios con rol "empleado".
        /// </summary>
        [HttpPost]
        [Authorize(Roles = "empleado")]
        [Route("api/inscripciones/reagendar")]
        public async Task<IActionResult> ReagendarInscripcion([FromBody] ReagendarInscripcionRequest request)
        {
            try
            {
                _logger.LogInformation("Start ReagendarInscripcion");

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

                // Paso 4: Validar que el request body no sea NULL
                if (request is null)
                {
                    return BadRequest(ResponseManager.BuildResponse<object>(
                        success: false,
                        httpCode: 400,
                        message: "Datos inválidos",
                        errors: new List<ErrorModel>
                        {
                            new() { message = "El cuerpo de la solicitud no puede ser nulo.", propiedad = null }
                        },
                        payload: null!));
                }

                // Paso 5: Validar que idInscripcion sea mayor a 0
                if (request.IdInscripcion <= 0)
                {
                    return BadRequest(ResponseManager.BuildResponse<object>(
                        success: false,
                        httpCode: 400,
                        message: "Datos inválidos",
                        errors: new List<ErrorModel>
                        {
                            new() { message = "El ID de inscripción debe ser mayor a 0.", propiedad = "idInscripcion" }
                        },
                        payload: null!));
                }

                // Paso 6: Validar que idClaseProgramada sea mayor a 0
                if (request.IdClaseProgramada <= 0)
                {
                    return BadRequest(ResponseManager.BuildResponse<object>(
                        success: false,
                        httpCode: 400,
                        message: "Datos inválidos",
                        errors: new List<ErrorModel>
                        {
                            new() { message = "El ID de clase programada debe ser mayor a 0.", propiedad = "idClaseProgramada" }
                        },
                        payload: null!));
                }

                // Paso 7: Validar que idCliente no sea NULL, vacío o whitespace
                if (string.IsNullOrWhiteSpace(request.IdCliente))
                {
                    return BadRequest(ResponseManager.BuildResponse<object>(
                        success: false,
                        httpCode: 400,
                        message: "Datos inválidos",
                        errors: new List<ErrorModel>
                        {
                            new() { message = "El ID del cliente no puede estar vacío.", propiedad = "idCliente" }
                        },
                        payload: null!));
                }

                // Paso 8: Llamar al servicio de reagendación
                var result = await _service.ReagendarInscripcionAsync(
                    request.IdInscripcion,
                    request.IdClaseProgramada,
                    request.IdCliente);

                // Paso 9: Retornar respuesta según el código HTTP del DTO
                return this.Responder(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error en ReagendarInscripcion");

                return StatusCode(500, ResponseManager.BuildResponse<object>(
                    success: false,
                    httpCode: 500,
                    message: "Error interno del servidor",
                    errors: new List<ErrorModel>
                    {
                        new() { message = "Ocurrió un error al reagendar la inscripción.", propiedad = null }
                    },
                    payload: null!));
            }
        }
    }
}
