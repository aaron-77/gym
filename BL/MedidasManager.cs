
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
        private HttpCustomClient httpClient;
        public MedidasManager(HttpCustomClient _httpClient)
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
                Console.WriteLine(ex.Message);
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return null;
            }

        }
        public async Task<DTOResponse<List<DTOParametroDeMedicion>>> obtenerParametrosDeMedicion()
        {


            try
            {
                
                string parametrosDeMedicionResponse = await httpClient.get("api/getParametrosDeMedicion");
                DTOResponse<List<DTOParametroDeMedicion>> response = JsonSerializer.Deserialize<DTOResponse<List<DTOParametroDeMedicion>>>(parametrosDeMedicionResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return response;
            }
            catch (ArgumentNullException ex)
            {
                Console.WriteLine(ex.Message);
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return null;
            }

        }

        public async Task<HttpResponseProgresoUsuario> obtenerProgresoDelUsuario(int idUsuario)
        {
            try
            {
                
                string progresoResponse = await httpClient.get($"api/progresoDeUsuario?idUsuario={idUsuario}");
                HttpResponseProgresoUsuario response = JsonSerializer.Deserialize<HttpResponseProgresoUsuario>(progresoResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return response;
            }
            catch (ArgumentNullException ex)
            {
                Console.WriteLine(ex.Message);
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return null;
            }

        }

        public async Task<HttpResponseAñosActivo> obtenerAñosActivosDelCliente(int idUsuario)
        {
            try
            {
                
                string añosMedidasRegistradas = await httpClient.get($"api/obtenerAñosConActividadDelCliente?idCliente={idUsuario}");
                HttpResponseAñosActivo response = JsonSerializer.Deserialize<HttpResponseAñosActivo>(añosMedidasRegistradas, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return response;
            }
            catch (ArgumentNullException ex)
            {
                Console.WriteLine(ex.Message);
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return null;
            }

        }

    }
}
