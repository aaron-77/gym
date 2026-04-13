using DTO.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace BL
{
    public class CitasManager
    {

        private IHttpCustomClient httpClient;
        public CitasManager(IHttpCustomClient _httpClient)
        {
            httpClient = _httpClient;
        }
        public async Task<DTOResponse<DTO.Dtos.Cita>> registrarCita(DTO.Dtos.Cita cita)
        {

            JsonContent jsonCon = JsonContent.Create(cita);
            string categoriasResponse = await httpClient.post("api/registrarCita", jsonCon);
            DTOResponse<DTO.Dtos.Cita> respuesta = JsonSerializer.Deserialize<DTOResponse<DTO.Dtos.Cita>>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return respuesta;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: registrarCita - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: registrarCita | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }

        public async Task<DTOResponse<DTO.Dtos.DuracionCitasMedicion>> registrarDuracionCitasMedicion(DTO.Dtos.DuracionCitasMedicion duracion)
        {

            JsonContent jsonCon = JsonContent.Create(duracion);
            string categoriasResponse = await httpClient.post("api/registrarDuracion", jsonCon);
            DTOResponse<DTO.Dtos.DuracionCitasMedicion> respuesta = JsonSerializer.Deserialize<DTOResponse<DTO.Dtos.DuracionCitasMedicion>>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return respuesta;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: registrarDuracionCitasMedicion - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: registrarDuracionCitasMedicion | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }


        public async Task<DTOResponse<DTO.Dtos.CitaEdit>> modificarCita(DTO.Dtos.CitaEdit cita)
        {

            JsonContent jsonCon = JsonContent.Create(cita);
            string categoriasResponse = await httpClient.put("api/registrarCita", jsonCon);
            DTOResponse<DTO.Dtos.CitaEdit> respuesta = JsonSerializer.Deserialize<DTOResponse<DTO.Dtos.CitaEdit>>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return respuesta;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: modificarCita - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: modificarCita | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }
        public async Task<DTOResponse<List<DTO.Dtos.Cita>>> obtenerCitasAgendadas(string idUsuario)
        {

            string categoriasResponse = await httpClient.get("api/getCitasAgendadas?idUsuario=" + idUsuario);
            DTOResponse<List<DTO.Dtos.Cita>> respuesta = JsonSerializer.Deserialize<DTOResponse<List<DTO.Dtos.Cita>>>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return respuesta;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerCitasAgendadas - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"IdUsuario: {idUsuario} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerCitasAgendadas | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"IdUsuario: {idUsuario} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }

        public async Task<DTOResponse<DTO.Dtos.DuracionCitasMedicion>> obtenerDuracionCitasMedicion()
        {


            string categoriasResponse = await httpClient.get("api/getDuracionCitasMedicion");
            DTOResponse<DTO.Dtos.DuracionCitasMedicion> respuesta = JsonSerializer.Deserialize<DTOResponse<DTO.Dtos.DuracionCitasMedicion>>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return respuesta;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerDuracionCitasMedicion - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerDuracionCitasMedicion | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }

        // NUEVO: Método para obtener la duración de la cita (int)
        public async Task<DTOResponse<int>> obtenerDuracionCita()
        {
            string duracionResponse = await httpClient.get("api/getDuracionCita");
            DTOResponse<int> respuesta = JsonSerializer.Deserialize<DTOResponse<int>>(duracionResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return respuesta;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerDuracionCita - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerDuracionCita | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
        }

        
        public async Task<DTOResponse<DTO.Dtos.Cita>> obtenerAgendadasCitasDelCliente()
        {
            string citasAgendadasResponse = await httpClient.get("api/getCitasAgendadas");
            DTOResponse<DTO.Dtos.Cita> respuesta = JsonSerializer.Deserialize<DTOResponse<DTO.Dtos.Cita>>(citasAgendadasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return respuesta;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerAgendadasCitasDelCliente - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerAgendadasCitasDelCliente | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
        }
    }
}
