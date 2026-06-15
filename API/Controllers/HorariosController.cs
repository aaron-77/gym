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
        private readonly Microsoft.Extensions.Logging.ILogger<HorariosController> _logger;

        public HorariosController(HorariosService horariosService, ServicioActualizacionesDeHorariosRealTime servicioActualizaciones, Microsoft.Extensions.Logging.ILogger<HorariosController> logger)
        {
            _horariosService = horariosService;
            _servicioActualizaciones = servicioActualizaciones;
            _logger = logger;
        }

        [Authorize(Roles = "empleado")]
        [HttpGet("obtenerPreReservas")]
        public async Task<ActionResult<DTOResponse<List<DTOHorarioVisualizacion>>>> ConsultarHorariosPreReservados([FromQuery] DateTime? fecha = null)
        {
            try
            {
                _logger.LogInformation("Start ConsultarHorariosPreReservados fecha={Fecha}", fecha);
                var horarios = await _horariosService.ObtenerPreReservasDeHorario(fecha);

                // Crear el objeto DTOResponse
                var response = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = true,
                    httpCode = 200,
                    message = "Horarios pre reservados obtenidos correctamente",
                    payload = horarios
                };

                _logger.LogInformation("Finished ConsultarHorariosPreReservados returned {Count} slots", horarios?.Count);
                return Ok(response); // Devolver la respuesta HTTP
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ConsultarHorariosPreReservados (HorariosController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Fecha: {fecha} | Stack Trace: {ex.StackTrace}";
                _logger.LogError(ex, logMessage);

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
                _logger.LogInformation("Start obtenerHorariosDisponibles fecha={Fecha}", fecha);
                var horarios = await _horariosService.consultarHorariosDisponibles(fecha);

                // Crear el objeto DTOResponse
                var response = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = true,
                    httpCode = 200,
                    message = "Horarios disponibles obtenidos correctamente",
                    payload = horarios
                };

                _logger.LogInformation("Finished obtenerHorariosDisponibles returned {Count} slots", horarios?.Count);
                return Ok(response); // Devolver la respuesta HTTP
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerHorariosDisponibles (HorariosController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Fecha: {fecha} | Stack Trace: {ex.StackTrace}";
                _logger.LogError(ex, logMessage);

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
                _logger.LogInformation("Start registrarPreReservaDeHorario userId={UserId} fecha={Fecha}", preReserva?.idUsuarioQueReserva, preReserva?.fechaTentativa);
                // Llamar al método del servicio que ejecuta el procedimiento almacenado
                var idPreReservaCreada = await _horariosService.RegistrarPreReservaDeHorario(preReserva);
                // Notificar al frontend vía SignalR
                await _servicioActualizaciones.enviarPreReservasActualizadas(preReserva.idUsuarioQueReserva);

                var response = new DTOResponse<int>
                {
                    success = true,
                    httpCode = 200,
                    message = "Pre-reserva de horario registrada correctamente",
                    payload = idPreReservaCreada
                };
                _logger.LogInformation("Finished registrarPreReservaDeHorario createdId={Id}", idPreReservaCreada);
                return Ok(response);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: registrarPreReservaDeHorario (HorariosController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | PreReserva.UserId: {preReserva?.idUsuarioQueReserva} | Stack Trace: {ex.StackTrace}";
                _logger.LogError(ex, logMessage);

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