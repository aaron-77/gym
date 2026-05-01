using Microsoft.AspNetCore.SignalR;
using API.Services;
using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.Extensions.Logging;

namespace API.Hubs
{
    public class ReservacionesHub : Hub
    {
        
        private readonly HorariosService _horariosService;
        private readonly ILogger<ReservacionesHub> _logger;
        
        public ReservacionesHub(HorariosService horariosService, ILogger<ReservacionesHub> logger){
            this._horariosService = horariosService;
            this._logger = logger;
        } 

        public async Task enviarPreReservasActualizadas(string userId)
        {
            _logger.LogInformation("Iniciando envio de pre-reservas actualizadas para userId={UserId}", userId);
            
            try
            {
                var preReservasDeHorario = await _horariosService.ObtenerPreReservasDeHorario();
                DTOResponse<List<DTOHorarioVisualizacion>> respuesta = new DTOResponse<List<DTOHorarioVisualizacion>>{
                success=(preReservasDeHorario.Count() > 0)?true:false,
                httpCode= (preReservasDeHorario.Count() > 0)?200:400,
                errors = null,
                message = (preReservasDeHorario.Count() > 0)?"horarios pre reservados obtenidos con exito":"no se encontraron horarios",
                payload = preReservasDeHorario
                };
                await Clients.All.SendAsync("actualizarPreReservasDeHorario",  respuesta);    
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al actualizar pre-reservas para userId={UserId}", userId);
                DTOResponse<List<DTOHorarioVisualizacion>> respuesta = new DTOResponse<List<DTOHorarioVisualizacion>>{
                success=false,
                httpCode= 500,
                errors = new List<ErrorModel>{
                    new ErrorModel{propiedad="NONE",message=ex.Message}
                },
                message = "Error al actualizar los horarios pre reservados",
                payload = null
                };
                await Clients.All.SendAsync("actualizarHorariosDisponibles", respuesta);
            }
            
        }
        
        public async Task enviarHorariosDisponiblesActualizados(string userId)
        {
            _logger.LogInformation("Iniciando envio de horarios disponibles para userId={UserId}", userId);
            
            try
            {
                // Llamar al método consultarHorariosDisponibles del servicio
                var horariosDisponibles = await _horariosService.consultarHorariosDisponibles();

                // Crear el objeto DTOResponse
                DTOResponse<List<DTOHorarioVisualizacion>> respuesta = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = (horariosDisponibles.Count() > 0) ? true : false,
                    httpCode = (horariosDisponibles.Count() > 0) ? 200 : 400,
                    errors = null,
                    message = (horariosDisponibles.Count() > 0) ? "Horarios disponibles obtenidos con éxito" : "No se encontraron horarios disponibles",
                    payload = horariosDisponibles
                };

                // Enviar la respuesta a todos los clientes conectados
                await Clients.All.SendAsync("actualizarHorariosDisponibles", respuesta);
                _logger.LogInformation("Horarios disponibles enviados exitosamente, count={Count}", horariosDisponibles.Count);
            }
            catch (Exception ex)
            {
                // Manejo de excepciones
                _logger.LogError(ex, "Error al enviar horarios disponibles para userId={UserId}", userId);
                DTOResponse<List<DTOHorarioVisualizacion>> respuesta = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = false,
                    httpCode = 500,
                    errors = new List<ErrorModel>
                    {
                        new ErrorModel { propiedad = "NONE", message = ex.Message }
                    },
                    message = "Error al actualizar los horarios disponibles",
                    payload = null
                };

                // Enviar la respuesta de error
                await Clients.All.SendAsync("actualizarHorariosDisponibles", respuesta);
            }
        }

        public override async Task OnConnectedAsync()
        {
            _logger.LogInformation("Cliente conectado al Hub de Reservaciones: {ConnectionId}", Context.ConnectionId);
            await base.OnConnectedAsync();
        }

        public override async Task OnDisconnectedAsync(Exception? exception)
        {
            if (exception != null)
            {
                _logger.LogWarning(exception, "Cliente desconectado del Hub de Reservaciones con excepción: {ConnectionId}", Context.ConnectionId);
            }
            else
            {
                _logger.LogInformation("Cliente desconectado del Hub de Reservaciones: {ConnectionId}", Context.ConnectionId);
            }
            await base.OnDisconnectedAsync(exception);
        }
    }
}