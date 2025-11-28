using DTO.Dtos;
using System.Collections.Generic;
using System.Net.Http.Json;
using System.Text.Json;
using System.Threading.Tasks;
using System;

namespace BL
{
    public class HorariosManager
    {
        private readonly HttpCustomClient _httpClient;

        public HorariosManager(HttpCustomClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<DTOResponse<List<DTOHorariosDisponibles>>> ObtenerHorariosDisponibles(string? fecha = null)
        {
            try
            {
                string endpoint = "api/Horarios/obtenerHorariosDisponibles";
                if (fecha != null)
                {
                    endpoint += $"?fecha={fecha}";
                }
                string response = await _httpClient.get(endpoint);
                return JsonSerializer.Deserialize<DTOResponse<List<DTOHorariosDisponibles>>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<List<DTOHorariosDisponibles>> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerHorariosDisponibles | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetro - Fecha: {fecha} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return new DTOResponse<List<DTOHorariosDisponibles>> { success = false, message = "Error al obtener horarios disponibles." };
            }
        }

        public async Task<DTOResponse<List<DTOHorarioVisualizacion>>> ObtenerPreReservas(string? fecha = null)
        {
            try
            {
                string endpoint = "api/Horarios/obtenerPreReservas";
                if (fecha != null)
                {
                    endpoint += $"?fecha={fecha}";
                }
                string response = await _httpClient.get(endpoint);
                return JsonSerializer.Deserialize<DTOResponse<List<DTOHorarioVisualizacion>>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<List<DTOHorarioVisualizacion>> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerPreReservas | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetro - Fecha: {fecha} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return new DTOResponse<List<DTOHorarioVisualizacion>> { success = false, message = "Error al obtener pre-reservas." };
            }
        }

        public async Task<DTOResponse<int>> PreReservarHorario(DTOPreReservaDeHorario preReserva)
        {
            try
            {
                JsonContent jsonCon = JsonContent.Create(preReserva);
                string response = await _httpClient.post("api/Horarios/preReservarHorario", jsonCon);
                return JsonSerializer.Deserialize<DTOResponse<int>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<int> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: PreReservarHorario | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return new DTOResponse<int> { success = false, message = "Error al pre-reservar horario." };
            }
        }
    }
}