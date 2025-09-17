// File: API/Controllers/HorariosController.cs
using Microsoft.AspNetCore.Mvc;
using API.Services;
using DTO.Dtos;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class HorariosController : ControllerBase
    {
        private readonly HorariosService _horariosService;
        private readonly ServicioActualizacionesDeHorariosRealTime _servicioActualizaciones;

        public HorariosController(HorariosService horariosService, ServicioActualizacionesDeHorariosRealTime servicioActualizaciones)
        {
            _horariosService = horariosService;
            _servicioActualizaciones = servicioActualizaciones;
        }

        [Authorize(Roles = "empleado")]
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

        [Authorize(Roles = "empleado")]
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

        [Authorize(Roles = "empleado")]
        [HttpPost("preReservarHorario")]
        public async Task<ActionResult<DTOResponse<int>>> registrarPreReservaDeHorario([FromBody] DTOPreReservaDeHorario preReserva)
        {
            try
            {
                // Llamar al método del servicio que ejecuta el procedimiento almacenado
                var resultado = await _horariosService.RegistrarPreReservaDeHorario(preReserva);
                // Notificar al frontend vía SignalR
                await _servicioActualizaciones.enviarPreReservasActualizadas(preReserva.idUsuarioQueReserva);

                var response = new DTOResponse<int>
                {
                    success = true,
                    httpCode = 200,
                    message = "Pre-reserva de horario registrada correctamente",
                    payload = resultado
                };
                return Ok(response);
            }
            catch (Exception ex)
            {
                var response = new DTOResponse<int>
                {
                    success = false,
                    httpCode = 500,
                    message = "Error al registrar la pre-reserva de horario",
                    errors = new List<ErrorModel>
                    {
                        new ErrorModel { propiedad = "NONE", message = ex.Message }
                    },
                    payload = 0
                };
                return StatusCode(500, response);
            }
        }
    }
}