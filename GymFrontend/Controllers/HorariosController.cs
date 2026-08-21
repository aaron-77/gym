using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Threading.Tasks;
using BL;
using BL.Utils;
using DTO.Dtos;
using Microsoft.AspNetCore.Mvc;

namespace GymFrontend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class HorariosController : Controller
    {
        private readonly HorariosManager _horariosManager;
        private JwtTokenGenerator _jwtTokenGenerator;
        private readonly Microsoft.Extensions.Logging.ILogger<HorariosController> _logger;

        public HorariosController(
            HorariosManager horariosManager,
            JwtTokenGenerator jwtTokenGenerator,
            Microsoft.Extensions.Logging.ILogger<HorariosController> logger
        )
        {
            _horariosManager = horariosManager;
            this._jwtTokenGenerator = jwtTokenGenerator;
            _logger = logger;
        }

        [HttpGet("obtenerHorariosDisponibles")]
        public async Task<IActionResult> ObtenerHorariosDisponibles(
            [FromQuery] string? fecha = null
        )
        {
            try
            {
                var result = await _horariosManager.ObtenerHorariosDisponibles(fecha);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] M�todo: ObtenerHorariosDisponibles | " +
                    $"L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Par�metro - Fecha: {fecha} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return StatusCode(
                    500,
                    new DTOResponse<List<DTOHorariosDisponibles>>
                    {
                        success = false,
                        message = "Error interno del servidor al obtener horarios disponibles.",
                        errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } },
                    }
                );
            }
        }

        [HttpGet("obtenerPreReservas")]
        public async Task<IActionResult> ObtenerPreReservas([FromQuery] string? fecha = null)
        {
            try
            {
                var result = await _horariosManager.ObtenerPreReservas(fecha);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] M�todo: ObtenerPreReservas | " +
                    $"L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Par�metro - Fecha: {fecha} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return StatusCode(
                    500,
                    new DTOResponse<List<DTOHorarioVisualizacion>>
                    {
                        success = false,
                        message = "Error interno del servidor al obtener pre-reservas.",
                        errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } },
                    }
                );
            }
        }

        [HttpPost("preReservarHorario")]
        public async Task<IActionResult> PreReservarHorario(
            [FromBody] DTOPreReservaDeHorario preReserva
        )
        {
            try
            {
                var token = Request.Cookies["AuthToken"];
                var claims = _jwtTokenGenerator.ValidateIdToken(token);
                var UsuarioId = claims
                    .FirstOrDefault(c =>
                        c.Key == ClaimTypes.NameIdentifier || c.Key == JwtRegisteredClaimNames.Sub
                    )
                    .Value;
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                preReserva.idUsuarioQueReserva = UsuarioId;

                var result = await _horariosManager.PreReservarHorario(preReserva);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] M�todo: PreReservarHorario | " +
                    $"L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);

                return StatusCode(
                    500,
                    new DTOResponse<string>
                    {
                        success = false,
                        message = "Error interno del servidor al pre-reservar horario.",
                        errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } },
                    }
                );
            }
        }

        [HttpPost("preReservarHorarioInscripcion")]
        public async Task<IActionResult> registrarPreReservaDeHorarioInscripcion(
            [FromBody] DTOPreReservaDeHorarioInscripcion preReserva
        )
        {
            try
            {
                var token = Request.Cookies["AuthToken"];
                var claims = _jwtTokenGenerator.ValidateIdToken(token);
                var usuarioId = claims
                    .FirstOrDefault(c =>
                        c.Key == ClaimTypes.NameIdentifier || c.Key == JwtRegisteredClaimNames.Sub
                    )
                    .Value;
                preReserva.idUsuarioQueReserva = usuarioId;

                var result = await _horariosManager.PreReservarHorarioInscripcion(preReserva);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] M�todo: registrarPreReservaDeHorarioInscripcion | " +
                    $"L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);

                return StatusCode(
                    500,
                    new DTOResponse<string>
                    {
                        success = false,
                        message = "Error interno del servidor al pre-reservar horario inscripción.",
                        errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } },
                    }
                );
            }
        }
    }
}
