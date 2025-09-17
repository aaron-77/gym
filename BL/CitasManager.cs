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
        
        private HttpCustomClient httpClient; 
        public CitasManager(HttpCustomClient _httpClient ){
            httpClient = _httpClient;
        }
        public async Task<HttpResponseCita> registrarCita(DTO.Dtos.Cita cita)
        {
           
            JsonContent jsonCon = JsonContent.Create(cita);
            string categoriasResponse = await httpClient.post("api/registrarCita", jsonCon);
            HttpResponseCita usuario = JsonSerializer.Deserialize<HttpResponseCita>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
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

        public async Task<HttpResponseDuracionCitasMedicion> registrarDuracionCitasMedicion(DTO.Dtos.DuracionCitasMedicion duracion)
        {
            
            JsonContent jsonCon = JsonContent.Create(duracion);
            string categoriasResponse = await httpClient.post("api/registrarDuracion", jsonCon);
            HttpResponseDuracionCitasMedicion usuario = JsonSerializer.Deserialize<HttpResponseDuracionCitasMedicion>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
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


        public async Task<HttpResponseCitaEdit> modificarCita(DTO.Dtos.CitaEdit cita)
        {
            
            JsonContent jsonCon = JsonContent.Create(cita);
            string categoriasResponse = await httpClient.put("api/registrarCita", jsonCon);
            HttpResponseCitaEdit responseCita = JsonSerializer.Deserialize<HttpResponseCitaEdit>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return responseCita;
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
        public async Task<HttpResponseListadoCitas> obtenerCitasAgendadas(int idUsuario)
        {
            
            string categoriasResponse = await httpClient.get("api/getCitasAgendadas?idUsuario="+ idUsuario);
            HttpResponseListadoCitas responseListadoCitas = JsonSerializer.Deserialize<HttpResponseListadoCitas>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return responseListadoCitas;
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

        public async Task<HttpResponseDuracionCitasMedicion> obtenerDuracionCitasMedicion()
        {
            

            string categoriasResponse = await httpClient.get("api/getDuracionCitasMedicion");
            HttpResponseDuracionCitasMedicion responseListadoCitas = JsonSerializer.Deserialize<HttpResponseDuracionCitasMedicion>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return responseListadoCitas;
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
