// File: API/Controllers/HorariosController.cs
using Microsoft.AspNetCore.Mvc;
using API.Services;
using DTO.Dtos;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class HorariosController : ControllerBase
    {
        private readonly HorariosService _horariosService;

        public HorariosController(HorariosService horariosService)
        {
            _horariosService = horariosService;
        }

        [HttpGet("obtenerPreReservas")]
        public async Task<ActionResult<DTOResponse<List<DTOHorarioVisualizacion>>>> ConsultarHorariosPreReservados([FromQuery] DateTime? fecha = null)
        {
            try
            {
                var horarios = await _horariosService.ObtenerPreReservasDeHorario(fecha);

                // Crear el objeto DTOResponse
                var response = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = true,
                    httpCode = 200,
                    message = "Horarios pre reservados obtenidos correctamente",
                    payload = horarios
                };

                return Ok(response); // Devolver la respuesta HTTP
            }
            catch (Exception ex)
            {
                var response = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = false,
                    httpCode = 500,
                    message = "Error al consultar los horarios pre reservados",
                    errors = new List<ErrorModel>
                    {
                        new ErrorModel { propiedad = "NONE", message = ex.Message }
                    },
                    payload = null
                };

                return StatusCode(500, response); // Devolver error 500
            }
        }

        [HttpGet("obtenerHorariosDisponibles")]
        public async Task<ActionResult<DTOResponse<List<DTOHorarioVisualizacion>>>> obtenerHorariosDisponibles([FromQuery] DateTime? fecha = null)
        {
            try
            {
                var horarios = await _horariosService.consultarHorariosDisponibles(fecha);

                // Crear el objeto DTOResponse
                var response = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = true,
                    httpCode = 200,
                    message = "Horarios disponibles obtenidos correctamente",
                    payload = horarios
                };

                return Ok(response); // Devolver la respuesta HTTP
            }
            catch (Exception ex)
            {
                var response = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = false,
                    httpCode = 500,
                    message = "Error al consultar los horarios disponibles",
                    errors = new List<ErrorModel>
                    {
                        new ErrorModel { propiedad = "NONE", message = ex.Message }
                    },
                    payload = null
                };

                return StatusCode(500, response); // Devolver error 500
            }
        }
    }
}