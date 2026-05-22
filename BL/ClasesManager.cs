using DTO.Dtos;
using System.Collections.Generic;
using System.Net.Http.Json;
using System.Text.Json;
using System.Threading.Tasks;
using System;

namespace BL
{
    public class ClasesManager
    {
        private readonly IHttpCustomClient _httpClient;

        public ClasesManager(IHttpCustomClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<DTOResponse<List<DTOClaseSimple>>> ObtenerClases(bool? activa = null)
        {
            try
            {
                string endpoint = "api/clases/obtenerClases";
                if (activa.HasValue)
                {
                    endpoint += $"?activa={activa.Value}";
                }
                string response = await _httpClient.get(endpoint);
                return JsonSerializer.Deserialize<DTOResponse<List<DTOClaseSimple>>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<List<DTOClaseSimple>> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerClases | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetro - Activa: {activa} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return new DTOResponse<List<DTOClaseSimple>> { success = false, message = "Error al obtener clases." };
            }
        }

        public async Task<DTOResponse<List<DTODificultad>>> ObtenerNivelesDeDificultad()
        {
            try
            {
                string endpoint = "api/clases/nivelesDeDificultad";
                string response = await _httpClient.get(endpoint);
                return JsonSerializer.Deserialize<DTOResponse<List<DTODificultad>>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<List<DTODificultad>> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerNivelesDeDificultad | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                return new DTOResponse<List<DTODificultad>> { success = false, message = "Error al obtener niveles de dificultad." };
            }
        }

        public async Task<DTOResponse<List<DTOIntensidad>>> ObtenerNivelesDeIntensidad()
        {
            try
            {
                string endpoint = "api/clases/nivelesDeIntensidad";
                string response = await _httpClient.get(endpoint);
                return JsonSerializer.Deserialize<DTOResponse<List<DTOIntensidad>>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<List<DTOIntensidad>> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerNivelesDeIntensidad | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                return new DTOResponse<List<DTOIntensidad>> { success = false, message = "Error al obtener niveles de intensidad." };
            }
        }

        public async Task<DTOResponse<List<QueryUser>>> ObtenerInstructores()
        {
            try
            {
                string endpoint = "api/clases/instructores";
                string response = await _httpClient.get(endpoint);
                return JsonSerializer.Deserialize<DTOResponse<List<QueryUser>>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<List<QueryUser>> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerInstructores | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                return new DTOResponse<List<QueryUser>> { success = false, message = "Error al obtener instructores." };
            }
        }

        public async Task<DTOResponse<List<DTOClasePreview>>> ObtenerPreviewDeClases()
        {
            try
            {
                string endpoint = "api/clases/preview";
                string response = await _httpClient.get(endpoint);
                return JsonSerializer.Deserialize<DTOResponse<List<DTOClasePreview>>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<List<DTOClasePreview>> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerPreviewDeClases | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return new DTOResponse<List<DTOClasePreview>> { success = false, message = "Error al obtener previews de clases." };
            }
        }

        public async Task<DTOResponse<List<DTOClaseProgramadaView>>> ObtenerClasesProgramadasPorId(int? idClase = null)
        {
            try
            {
                string endpoint = "api/clases/obtenerClasesProgramadasPorId";
                if (idClase.HasValue)
                {
                    endpoint += "?idClase=" + idClase.Value;
                }
                string response = await _httpClient.get(endpoint);
                return JsonSerializer.Deserialize<DTOResponse<List<DTOClaseProgramadaView>>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<List<DTOClaseProgramadaView>> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerClasesProgramadasPorId | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetro - IdClase: {idClase} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return new DTOResponse<List<DTOClaseProgramadaView>> { success = false, message = "Error al obtener clases programadas por ID." };
            }
        }

        public async Task<DTOResponse<List<DTOEstadoClaseProgramada>>> ObtenerEstadosDeClasesProgramdas()
        {
            try
            {
                string endpoint = "api/clases/obtenerEstadosDeClasesProgramdas";
                string response = await _httpClient.get(endpoint);
                return JsonSerializer.Deserialize<DTOResponse<List<DTOEstadoClaseProgramada>>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<List<DTOEstadoClaseProgramada>> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerEstadosDeClasesProgramdas | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return new DTOResponse<List<DTOEstadoClaseProgramada>> { success = false, message = "Error al obtener estados de clases programadas." };
            }
        }

        public async Task<DTOResponse<int?>> RegistrarClaseProgramada(DTODatosClaseProgramada claseProgramadaRegistro)
        {
            try
            {
                JsonContent jsonCon = JsonContent.Create(claseProgramadaRegistro);
                string response = await _httpClient.post("api/clases/registrarClaseProgramada", jsonCon);
                return JsonSerializer.Deserialize<DTOResponse<int?>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<int?> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: RegistrarClaseProgramada | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return new DTOResponse<int?> { success = false, message = "Error al registrar clase programada." };
            }
        }

        public async Task<DTOResponse<int?>> InscribirAClase(DTOInscripcionAClase inscripcionAClase)
        {
            try
            {
                JsonContent jsonCon = JsonContent.Create(inscripcionAClase);
                string response = await _httpClient.post("api/clases/inscribirAClase", jsonCon);
                return JsonSerializer.Deserialize<DTOResponse<int?>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<int?> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: InscribirAClase | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return new DTOResponse<int?> { success = false, message = "Error al hacer la inscripcion" };
            }
        }
    }
}