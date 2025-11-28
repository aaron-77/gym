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
        private JwtTokenGenerator jwtTokenGenerator;

        public HorariosController(
            HorariosManager horariosManager,
            JwtTokenGenerator jwtTokenGenerator
        )
        {
            _horariosManager = horariosManager;
            this.jwtTokenGenerator = jwtTokenGenerator;
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
                string logMessage = $"[ERROR] Método: ObtenerHorariosDisponibles | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetro - Fecha: {fecha} | " +
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
                string logMessage = $"[ERROR] Método: ObtenerPreReservas | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetro - Fecha: {fecha} | " +
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
                var claims = jwtTokenGenerator.ValidateIdToken(token);
                var UsuarioId = claims
                    .FirstOrDefault(c =>
                        c.Key == ClaimTypes.NameIdentifier || c.Key == JwtRegisteredClaimNames.Sub
                    )
                    .Value;
                    
                var result = await _horariosManager.PreReservarHorario(preReserva);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: PreReservarHorario | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
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
    }
}
