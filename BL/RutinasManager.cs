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
    public class RutinasManager
    {

        private IHttpCustomClient httpClient; 
        public RutinasManager(IHttpCustomClient _httpClient ){
            httpClient = _httpClient;
        }
        public async Task<HttpResponseRutina> registrarRutina(DTO.Dtos.Rutina rutina)
        {
           
            JsonContent jsonCon = JsonContent.Create(rutina);
            string categoriasResponse = await httpClient.post("api/registrarRutina", jsonCon);
            HttpResponseRutina usuario = JsonSerializer.Deserialize<HttpResponseRutina>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return usuario;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: registrarRutina - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: registrarRutina | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }
        public async Task<DTOResponse<AsignacionDeEjercicio>> asignarEjercicioARutina(DTO.Dtos.AsignacionDeEjercicio asignacion)
        {
            
            JsonContent jsonCon = JsonContent.Create(asignacion);
            string asignacionResponse = await httpClient.post("api/asignarEjercicio", jsonCon);
            DTOResponse<AsignacionDeEjercicio> usuario = JsonSerializer.Deserialize<DTOResponse<AsignacionDeEjercicio>>(asignacionResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return usuario;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: asignarEjercicioARutina - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: asignarEjercicioARutina | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }

        public async Task<DTOResponse<Rutina>> obtenerRutinasDeUsuario(string UsuarioID)
        {


            string asignacionResponse = await httpClient.get("api/consultarRutinas");
            DTOResponse<Rutina> rutinas = JsonSerializer.Deserialize<DTOResponse<Rutina>>(asignacionResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return rutinas;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerRutinasDeUsuario - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"UsuarioID: {UsuarioID} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerRutinasDeUsuario | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"UsuarioID: {UsuarioID} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }   

        public async Task<DTOResponse<List<Rutina>>> obtenerRutinasDeCliente(string UsuarioID)
        {
            
            try
            {
                string rutinasResponse = await httpClient.get($"api/consultarRutinas?UsuarioID={UsuarioID}");
                DTOResponse<List<Rutina>> rutinas = JsonSerializer.Deserialize<DTOResponse<List<Rutina> >>(rutinasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return rutinas;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerRutinasDeCliente - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"UsuarioID: {UsuarioID} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerRutinasDeCliente | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"UsuarioID: {UsuarioID} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
        }
    }
}
