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

        private HttpCustomClient httpClient; 
        public RutinasManager(HttpCustomClient _httpClient ){
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
                Console.WriteLine(ex.Message);
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return null;
            }

        }
        public async Task<HttpResponseAsignacion> asignarEjercicioARutina(DTO.Dtos.AsignacionDeEjercicio asignacion)
        {
            HttpCustomClient httpClient = new HttpCustomClient();
            JsonContent jsonCon = JsonContent.Create(asignacion);
            string asignacionResponse = await httpClient.post("api/asignarEjercicio", jsonCon);
            HttpResponseAsignacion usuario = JsonSerializer.Deserialize<HttpResponseAsignacion>(asignacionResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
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

        public async Task<HttpResponseListadoRutinas> obtenerRutinasDeUsuario(int UsuarioID)
        {
            HttpCustomClient httpClient = new HttpCustomClient();
            
            string asignacionResponse = await httpClient.get("api/consultarRutinas?UsuarioID="+UsuarioID);
            HttpResponseListadoRutinas rutinas = JsonSerializer.Deserialize<HttpResponseListadoRutinas>(asignacionResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return rutinas;
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
