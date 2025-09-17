using BL;
using DTO.Dtos;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using System;

namespace GymFrontend.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class HorariosController : Controller
    {
        private readonly HorariosManager _horariosManager;

        public HorariosController(HorariosManager horariosManager)
        {
            _horariosManager = horariosManager;
        }

        [HttpGet("obtenerHorariosDisponibles")]
        public async Task<IActionResult> ObtenerHorariosDisponibles([FromQuery] string? fecha = null)
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
                return StatusCode(500, new DTOResponse<List<DTOHorariosDisponibles>> { success = false, message = "Error interno del servidor al obtener horarios disponibles.", errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } } });
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
                return StatusCode(500, new DTOResponse<List<DTOHorarioPreReservado>> { success = false, message = "Error interno del servidor al obtener pre-reservas.", errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } } });
            }
        }

        [HttpPost("preReservarHorario")]
        public async Task<IActionResult> PreReservarHorario([FromBody] DTOPreReservaDeHorario preReserva)
        {
            try
            {
                var result = await _horariosManager.PreReservarHorario(preReserva);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new DTOResponse<string> { success = false, message = "Error interno del servidor al pre-reservar horario.", errors = new List<ErrorModel> { new ErrorModel { message = ex.Message } } });
            }
        }
    }
} 