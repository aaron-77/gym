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
                Console.WriteLine(ex.Message);
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
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
