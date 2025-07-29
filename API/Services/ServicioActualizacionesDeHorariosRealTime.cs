using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.SignalR;
using DataAccess.EntityFramework;
using DTO.Dtos;
using API.Hubs;
using Microsoft.EntityFrameworkCore;

namespace API.Services
{
    public class ServicioActualizacionesDeHorariosRealTime
    {
        private readonly FitnessCenterDbContext _context;
        private readonly IHubContext<ReservacionesHub> _hubContext;
        private readonly HorariosService _horariosService;

        public ServicioActualizacionesDeHorariosRealTime(FitnessCenterDbContext context, IHubContext<ReservacionesHub> hubContext, HorariosService horariosService)
        {
            _context = context;
            _hubContext = hubContext;
            _horariosService = horariosService;
        }

        public async Task enviarPreReservasActualizadas(int userId)
        {
            try
            {
                var preReservasDeHorario = await _horariosService.ObtenerPreReservasDeHorario();
                DTOResponse<List<DTOHorarioVisualizacion>> respuesta = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = (preReservasDeHorario.Count > 0),
                    httpCode = (preReservasDeHorario.Count > 0) ? 200 : 400,
                    errors = null,
                    message = (preReservasDeHorario.Count > 0) ? "horarios pre reservados obtenidos con exito" : "no se encontraron horarios",
                    payload = preReservasDeHorario
                };
                await _hubContext.Clients.All.SendAsync("actualizarPreReservasDeHorario", respuesta);
            }
            catch (System.Exception ex)
            {
                DTOResponse<List<DTOHorarioVisualizacion>> respuesta = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = false,
                    httpCode = 500,
                    errors = new List<ErrorModel> { new ErrorModel { propiedad = "NONE", message = ex.Message } },
                    message = "Error al actualizar los horarios pre reservados",
                    payload = null
                };
                await _hubContext.Clients.All.SendAsync("actualizarHorariosDisponibles", respuesta);
            }
        }

        public async Task enviarHorariosDisponiblesActualizados(int userId)
        {
            try
            {
                var horariosDisponibles = await _horariosService.consultarHorariosDisponibles();
                DTOResponse<List<DTOHorarioVisualizacion>> respuesta = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = (horariosDisponibles.Count > 0),
                    httpCode = (horariosDisponibles.Count > 0) ? 200 : 400,
                    errors = null,
                    message = (horariosDisponibles.Count > 0) ? "Horarios disponibles obtenidos con éxito" : "No se encontraron horarios disponibles",
                    payload = horariosDisponibles
                };
                await _hubContext.Clients.All.SendAsync("actualizarHorariosDisponibles", respuesta);
            }
            catch (System.Exception ex)
            {
                DTOResponse<List<DTOHorarioVisualizacion>> respuesta = new DTOResponse<List<DTOHorarioVisualizacion>>
                {
                    success = false,
                    httpCode = 500,
                    errors = new List<ErrorModel> { new ErrorModel { propiedad = "NONE", message = ex.Message } },
                    message = "Error al actualizar los horarios disponibles",
                    payload = null
                };
                await _hubContext.Clients.All.SendAsync("actualizarHorariosDisponibles", respuesta);
            }
        }

        public async Task enviarCuposActualizadosDeClaseProgramada(int idProgramacionClase)
        {
            try
            {
                var claseProgramada = await _horariosService.obtenerClaseProgramadaConNuevoCupo(idProgramacionClase);
                
                DTOResponse<List<DTOClaseProgramadaView>> respuesta = new DTOResponse<List<DTOClaseProgramadaView>>
                {
                    success = (claseProgramada != null && claseProgramada.Any()),
                    httpCode = (claseProgramada != null && claseProgramada.Any()) ? 200 : 400,
                    errors = null,
                    message = (claseProgramada != null && claseProgramada.Any()) 
                        ? "Cupos de clase actualizados con éxito" 
                        : "No se encontró la clase programada",
                    payload = claseProgramada
                };

                await _hubContext.Clients.All.SendAsync("actualizarCuposDeClases", respuesta);
            }
            catch (System.Exception ex)
            {
                DTOResponse<List<DTOClaseProgramadaView>> respuesta = new DTOResponse<List<DTOClaseProgramadaView>>
                {
                    success = false,
                    httpCode = 500,
                    errors = new List<ErrorModel> { new ErrorModel { propiedad = "NONE", message = ex.Message } },
                    message = "Error al actualizar los cupos de la clase",
                    payload = null
                };
                
                await _hubContext.Clients.All.SendAsync("actualizarCuposDeClases", respuesta);
            }
        }

        public async Task enviarClaseProgramadaRegistrada(int idClase)
        {
            try
            {
                var claseProgramada = await _horariosService.obtenerClaseProgramadaConNuevoCupo(idClase);
                
                DTOResponse<List<DTOClaseProgramadaView>> respuesta = new DTOResponse<List<DTOClaseProgramadaView>>
                {
                    success = (claseProgramada != null && claseProgramada.Any()),
                    httpCode = (claseProgramada != null && claseProgramada.Any()) ? 200 : 404,
                    errors = null,
                    message = (claseProgramada != null && claseProgramada.Any()) 
                        ? "Clase programada registrada con éxito" 
                        : "No se encontró la clase programada",
                    payload = claseProgramada
                };

                await _hubContext.Clients.All.SendAsync("actualizarClasesProgramadas", respuesta);
            }
            catch (System.Exception ex)
            {
                DTOResponse<List<DTOClaseProgramadaView>> respuesta = new DTOResponse<List<DTOClaseProgramadaView>>
                {
                    success = false,
                    httpCode = 500,
                    errors = new List<ErrorModel> { new ErrorModel { propiedad = "NONE", message = ex.Message } },
                    message = "Error al obtener la clase programada registrada",
                    payload = null
                };
                
                await _hubContext.Clients.All.SendAsync("actualizarClasesProgramadas", respuesta);
            }
        }

    }
}