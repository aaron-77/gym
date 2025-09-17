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
        private readonly HttpCustomClient _httpClient;

        public ClasesManager(HttpCustomClient httpClient)
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
                Console.WriteLine($"Error en ObtenerClases: {ex.Message}");
                return new DTOResponse<List<DTOClaseSimple>> { success = false, message = "Error al obtener clases." };
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
                Console.WriteLine($"Error en ObtenerClasesProgramadasPorId: {ex.Message}");
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
                Console.WriteLine($"Error en ObtenerEstadosDeClasesProgramdas: {ex.Message}");
                return new DTOResponse<List<DTOEstadoClaseProgramada>> { success = false, message = "Error al obtener estados de clases programadas." };
            }
        }

        public async Task<DTOResponse<string>> RegistrarClaseProgramada(DTODatosClaseProgramada claseProgramadaRegistro)
        {
            try
            {
                JsonContent jsonCon = JsonContent.Create(claseProgramadaRegistro);
                string response = await _httpClient.post("api/clases/registrarClaseProgramada", jsonCon);
                return JsonSerializer.Deserialize<DTOResponse<string>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<string> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error en RegistrarClaseProgramada: {ex.Message}");
                return new DTOResponse<string> { success = false, message = "Error al registrar clase programada." };
            }
        }
    }
} 