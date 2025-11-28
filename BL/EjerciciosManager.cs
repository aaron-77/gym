using DTO.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace BL
{
    public class EjerciciosManager
    {
        private HttpCustomClient httpClient; 
        public EjerciciosManager(HttpCustomClient _httpClient ){
            httpClient = _httpClient;
        }
        public async Task<DTOResponse<List<Ejercicio>>> obtenerEjercicios()
        {
            

            string ejerciciosResponse = await httpClient.get("api/consultarEjercicios");
            DTOResponse<List<Ejercicio>> ejercicios = JsonSerializer.Deserialize<DTOResponse<List<Ejercicio>>>(ejerciciosResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return ejercicios;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerEjercicios - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerEjercicios | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }

        // NUEVO: Método para obtener ejercicios de un cliente específico
        public async Task<DTOResponse<Ejercicio>> obtenerEjerciciosDeCliente()
        {
            string ejerciciosResponse = await httpClient.get($"api/consultarEjercicios");
            DTOResponse<Ejercicio> ejercicios = JsonSerializer.Deserialize<DTOResponse<Ejercicio>>(ejerciciosResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return ejercicios;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerEjerciciosDeCliente - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerEjerciciosDeCliente | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
        }
    }
}
