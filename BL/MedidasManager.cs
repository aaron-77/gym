
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
        public async Task<ResponseParametroDeMedicion> obtenerParametrosDeMedicion()
        {


            try
            {
                HttpCustomClient httpClient = new HttpCustomClient();
                string parametrosDeMedicionResponse = await httpClient.get("api/getParametrosDeMedicion");
                ResponseParametroDeMedicion response = JsonSerializer.Deserialize<ResponseParametroDeMedicion>(parametrosDeMedicionResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
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
