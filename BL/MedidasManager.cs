using BL.Utils;
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
    public class MedidasManager
    {
        private IHttpCustomClient httpClient;
        public MedidasManager(IHttpCustomClient _httpClient)
        {
            httpClient = _httpClient;
        }
        public async Task<ResponseHTTPMedida> registrarMedida(DTO.Dtos.DTOMedida medida)
        {

            JsonContent jsonCon = JsonContent.Create(medida);
            string categoriasResponse = await httpClient.post("api/RegistrarMedida", jsonCon);
            ResponseHTTPMedida usuario = JsonSerializer.Deserialize<ResponseHTTPMedida>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return usuario;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: registrarMedida - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: registrarMedida | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }
        public async Task<DTOResponse<List<DTOParametroDeMedicion>>> obtenerParametrosDeMedicion(string idUsuario)
        {


            try
            {
                
                string parametrosDeMedicionResponse = await httpClient.get($"api/getParametrosDeMedicion?idUsuario={idUsuario}");
                DTOResponse<List<DTOParametroDeMedicion>> response = JsonSerializer.Deserialize<DTOResponse<List<DTOParametroDeMedicion>>>(parametrosDeMedicionResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return response;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerParametrosDeMedicion - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerParametrosDeMedicion | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }

        public async Task<DTOResponse<List<DTOItemProgreso>>> obtenerProgresoDelUsuario(string idUser)
        {
            try
            {
                string progresoResponse = await httpClient.get($"api/progresoDeUsuario?idUsuario={idUser}");
                DTOResponse<List<DTOItemProgreso>> response = JsonSerializer.Deserialize<DTOResponse<List<DTOItemProgreso>>>(progresoResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                if (response == null)
                {
                    return ResponseManager.BuildResponse<List<DTOItemProgreso>>(false, 500, "Respuesta inválida del servicio de medidas", null, null);
                }
                return response;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerProgresoDelUsuario - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"IdUser: {idUser} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return ResponseManager.BuildResponse<List<DTOItemProgreso>>(false, 500, ex.Message, new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerProgresoDelUsuario | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"IdUser: {idUser} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return ResponseManager.BuildResponse<List<DTOItemProgreso>>(false, 500, ex.Message, new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
            }

        }

        public async Task<HttpResponseAñosActivo> obtenerAñosActivosDelCliente(string idUsuario)
        {
            try
            {
                
                string añosMedidasRegistradas = await httpClient.get($"api/obtenerAñosConActividadDelCliente?idCliente={idUsuario}");
                HttpResponseAñosActivo response = JsonSerializer.Deserialize<HttpResponseAñosActivo>(añosMedidasRegistradas, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return response;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerAñosActivosDelCliente - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"IdUsuario: {idUsuario} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerAñosActivosDelCliente | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"IdUsuario: {idUsuario} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }

        public async Task<DTOResponse<List<DTO.Dtos.DTOEjerciciosYParametrosDelCliente>>> consultarDetallesDeProgresoDeUsuario(string idCliente)
        {
            try
            {
                string responseString = await httpClient.get($"api/obtenerEjerciciosYParametros?idCliente={idCliente}");
                // The API returns a DTOResponse<List<DTOEjerciciosYParametrosDelCliente>>
                var response = JsonSerializer.Deserialize<DTOResponse<List<DTO.Dtos.DTOEjerciciosYParametrosDelCliente>>>(responseString, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                if (response == null)
                {
                    return ResponseManager.BuildResponse<List<DTO.Dtos.DTOEjerciciosYParametrosDelCliente>>(false, 500, "Respuesta inválida del servicio de medidas", null, null);
                }
                return response;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: consultarDetallesDeProgresoDeUsuario - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"IdCliente: {idCliente} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return ResponseManager.BuildResponse<List<DTO.Dtos.DTOEjerciciosYParametrosDelCliente>>(false, 500, ex.Message, new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: consultarDetallesDeProgresoDeUsuario | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"IdCliente: {idCliente} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return ResponseManager.BuildResponse<List<DTO.Dtos.DTOEjerciciosYParametrosDelCliente>>(false, 500, ex.Message, new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
            }
        }

        public async Task<DTOResponse<MedidasConMetas>> consultarDetallesDeProgreso(string idCliente, int idParametro, int? idEjercicio, string? espaciadoTemporal, string? tipoDeBusqueda, DateTime? fechaDeInicio = null, DateTime? fechaFin = null, bool conDetalle = false, int[]? mesesDeFiltro = null, int[]? añosDeFiltro = null, DateTime? fechaDeCreacion = null)
        {
            try
            {
                var query = System.Web.HttpUtility.ParseQueryString(string.Empty);
                query["idCliente"] = idCliente;
                query["idParametro"] = idParametro.ToString();
                if (idEjercicio.HasValue) query["idEjercicio"] = idEjercicio.Value.ToString();
                if (!string.IsNullOrEmpty(espaciadoTemporal)) query["espaciadoTemporal"] = espaciadoTemporal;
                if (!string.IsNullOrEmpty(tipoDeBusqueda)) query["tipoDeBusqueda"] = tipoDeBusqueda;
                if (fechaDeInicio.HasValue) query["fechaDeInicio"] = fechaDeInicio.Value.ToString("o");
                if (fechaFin.HasValue) query["fechaFin"] = fechaFin.Value.ToString("o");
                query["conDetalle"] = conDetalle.ToString();
                if (mesesDeFiltro != null)
                {
                    foreach (var m in mesesDeFiltro)
                        query.Add("mesesDeFiltro", m.ToString());
                }
                if (añosDeFiltro != null)
                {
                    foreach (var a in añosDeFiltro)
                        query.Add("añosDeFiltro", a.ToString());
                }
                if (fechaDeCreacion.HasValue) query["fechaDeCreacion"] = fechaDeCreacion.Value.ToString("o");

                string url = $"api/obtenerDetallesDeProgreso?{query.ToString()}";
                string responseString = await httpClient.get(url);
                var response = JsonSerializer.Deserialize<DTOResponse<MedidasConMetas>>(responseString, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                if (response == null)
                {
                    return ResponseManager.BuildResponse<MedidasConMetas>(false, 500, "Respuesta inválida del servicio de medidas", null, null);
                }
                return response;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: consultarDetallesDeProgreso | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Parámetros - IdCliente: {idCliente}, IdParametro: {idParametro}, EspaciadoTemporal: {espaciadoTemporal}, TipoDeBusqueda: {tipoDeBusqueda} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return ResponseManager.BuildResponse<MedidasConMetas>(false, 500, ex.Message, new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
            }
        }

    }
}
