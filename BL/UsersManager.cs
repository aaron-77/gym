

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
    public class UsersManager
    {
        private HttpCustomClient httpClient; 
        public UsersManager(HttpCustomClient _httpClient ){
            httpClient = null;
            httpClient = _httpClient;
        }
        public async Task<DTOResponse<DTOLoggedUser>> login(UserCredentials credenciales)
        {
            
            JsonContent jsonCon = JsonContent.Create(credenciales);
            string categoriasResponse = await httpClient.post("api/autenticar", jsonCon);
            DTOResponse<DTOLoggedUser> usuario = null;

            try
            {
                usuario = JsonSerializer.Deserialize<DTOResponse<DTOLoggedUser>>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
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

        public async Task<ResponseHttp> registrarUsuario(User newUser)
        {
            // Encriptar la contraseña antes de enviar la solicitud
            newUser.Contrasena = HashPassword(newUser.Contrasena);
            newUser.ContrasenaConfirmacion = newUser.Contrasena; // Asegurarse de que la confirmación de la contraseña coincida
            NewUser userForBody = new NewUser(newUser.NombreCompleto,
                                                       newUser.FechaDeNacimiento,
                                                       newUser.Direccion,
                                                       newUser.NumeroDeIdentificacion,
                                                       newUser.Correo,
                                                       newUser.Telefono,
                                                       newUser.Apellido,
                                                       newUser.Contrasena);
            HttpCustomClient httpClient = new HttpCustomClient();
            JsonContent jsonCon = JsonContent.Create(userForBody);
            string categoriasResponse = await httpClient.post("api/RegistrarUsuario", jsonCon);
            ResponseHttp usuario = JsonSerializer.Deserialize<ResponseHttp>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

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


        private string HashPassword(string password)
        {
            return BCrypt.Net.BCrypt.HashPassword(password);
        }

        public bool VerifyPassword(string enteredPassword, string hashedPassword)
        {
            return BCrypt.Net.BCrypt.Verify(enteredPassword, hashedPassword);
        }
        public async Task<ResponseHttpListadoUsers> obtenerUsuarios()
        {

            HttpCustomClient httpClient = new HttpCustomClient();

            string categoriasResponse = await httpClient.get("api/obtenerUsuarios");
            ResponseHttpListadoUsers respuestaHttp = JsonSerializer.Deserialize<ResponseHttpListadoUsers>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return respuestaHttp;
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

        public async Task<HttpResponseListadoQueryUsers> obtenerUsuariosPorRol(string rol, string estado)
        {

            HttpCustomClient httpClient = new HttpCustomClient();

            string categoriasResponse = await httpClient.get($"api/obtenerUsuariosPorRol?rol={rol}&estado={estado}");
            HttpResponseListadoQueryUsers respuestaHttp = JsonSerializer.Deserialize<HttpResponseListadoQueryUsers>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return respuestaHttp;
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

        public async Task<HttpResponseGenerateOTP> obtenerCodigoOTP(CanalDeEnvioOTP canalDeEnvio)
        {
            HttpCustomClient httpClient = new HttpCustomClient();
            JsonContent jsonCon = JsonContent.Create(canalDeEnvio);
            string categoriasResponse = await httpClient.post("api/getOTPCode", jsonCon);
            HttpResponseGenerateOTP responseOTPGeneration = JsonSerializer.Deserialize<HttpResponseGenerateOTP>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return responseOTPGeneration;
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

        public async Task<HttpLoginResponse> validarCodigoOTP(OTPCodeVerification verificacion)
        {   
            HttpCustomClient httpClient = new HttpCustomClient();
            JsonContent jsonCon = JsonContent.Create(verificacion);
            string categoriasResponse = await httpClient.post("api/verificarOTP", jsonCon);
            HttpLoginResponse finalLoginResponse = JsonSerializer.Deserialize<HttpLoginResponse>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return finalLoginResponse;
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
		