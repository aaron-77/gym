using Microsoft.AspNetCore.SignalR;
using API.Services;
using DataAccess.EntityFramework;
using DTO.Dtos;
namespace API.Hubs
{
    public class ReservacionesHub : Hub
    {
        
        private readonly HorariosService _horariosService;
        /* public async Task enviarHorariosDisponiblesActualizados(string userId)
        {
            return await Task.CompletedTask;
            //await Clients.All.SendAsync("actualizarHorariosDisponibles",  horariosDisponibles);
        } */
        public ReservacionesHub(HorariosService horariosService){
            this._horariosService = horariosService;
        } 

        public async Task enviarPreReservasActualizadas(int userId)
        {
            
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
        
        public async Task enviarHorariosDisponiblesActualizados(int userId)
        {
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
            }
            catch (Exception ex)
            {
                // Manejo de excepciones
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
    }
}