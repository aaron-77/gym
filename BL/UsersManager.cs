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
        private readonly HttpCustomClient httpClient;
        public UsersManager(HttpCustomClient _httpClient ){
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
                string logMessage = $"[ERROR] Método: login - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: login | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
        }

        public async Task<DTOResponse<DTOLoggedUser>> updateIdAndAccessToken(RefreshTokenRequest refreshTokenRequest)
        {
            
            JsonContent jsonCon = JsonContent.Create(refreshTokenRequest);
            string updateIdAndAccessTokenRequest = await httpClient.post("api/refresh", jsonCon);
            DTOResponse<DTOLoggedUser> usuario = null;

            try
            {
                usuario = JsonSerializer.Deserialize<DTOResponse<DTOLoggedUser>>(updateIdAndAccessTokenRequest, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return usuario;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: updateIdAndAccessToken - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: updateIdAndAccessToken | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
        }

        public async Task<ResponseHttp> registrarUsuario(User newUser)
        {
            // Encriptar la contraseña antes de enviar la solicitud
            newUser.Contrasena = HashPassword(newUser.Contrasena);
            newUser.ContrasenaConfirmacion = newUser.Contrasena; // Asegurarse de que la confirmación de la contraseña coincida
            NewUser userForBody = new NewUser(newUser.Nombre,
                                                       newUser.FechaDeNacimiento,
                                                       newUser.Direccion,
                                                       newUser.NumeroDeIdentificacion,
                                                       newUser.Correo,
                                                       newUser.Telefono,
                                                       newUser.Apellido,
                                                       newUser.Contrasena);

            JsonContent jsonCon = JsonContent.Create(userForBody);
            string categoriasResponse = await httpClient.post("api/RegistrarUsuario", jsonCon);
            ResponseHttp usuario = JsonSerializer.Deserialize<ResponseHttp>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

            try
            {
                return usuario;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: registrarUsuario - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: registrarUsuario | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
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
        public async Task<DTOResponse<List<ExistingUser>>> obtenerUsuarios()
        {

            
            
            
            try
            {
                string response = await httpClient.get("api/obtenerUsuarios");
                DTOResponse<List<ExistingUser>> respuestaHttp = JsonSerializer.Deserialize<DTOResponse<List<ExistingUser>>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return respuestaHttp;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerUsuarios - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerUsuarios | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }

        }

        public async Task<DTOResponse<List<QueryUser>>> ObtenerUsuariosPorRol(string rol, string estado)
        {
            try
            {
                string endpoint = $"api/obtenerUsuariosPorRol?rol={rol}&estado={estado}";
                string response = await httpClient.get(endpoint);
                return JsonSerializer.Deserialize<DTOResponse<List<QueryUser>>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<List<QueryUser>> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerUsuariosPorRol - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Rol: {rol}, Estado: {estado} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return new DTOResponse<List<QueryUser>> { success = false, message = "Error de deserialización o respuesta vacía." };
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerUsuariosPorRol | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Rol: {rol}, Estado: {estado} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return new DTOResponse<List<QueryUser>> { success = false, message = "Error al obtener usuarios por rol." };
            }
        }

        public async Task<DTOResponse<List<QueryUser>>> ObtenerEntrenadoresDisponibles(DateTime fechaReferencia)
        {
            
            try
            {
                Console.WriteLine($"ObtenerEntrenadoresDisponibles [Frontend] (UsersManager) FECHA BUSCADA: {fechaReferencia}");
                string entrenadoresResponse = await httpClient.get($"api/obtenerEntrenadoresDisponibles?fechaReferencia={fechaReferencia}");
                DTOResponse<List<QueryUser>> entrenadores = JsonSerializer.Deserialize<DTOResponse<List<QueryUser>>>(entrenadoresResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return entrenadores;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerEntrenadoresDisponibles - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"FechaReferencia: {fechaReferencia} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerEntrenadoresDisponibles | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"FechaReferencia: {fechaReferencia} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
        }

        public async Task<HttpResponseGenerateOTP> obtenerCodigoOTP(CanalDeEnvioOTP canalDeEnvio)
        {
            
            JsonContent jsonCon = JsonContent.Create(canalDeEnvio);
            string categoriasResponse = await httpClient.post("api/getOTPCode", jsonCon);
            HttpResponseGenerateOTP responseOTPGeneration = JsonSerializer.Deserialize<HttpResponseGenerateOTP>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return responseOTPGeneration;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: obtenerCodigoOTP - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerCodigoOTP | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
        }

        public async Task<HttpLoginResponse> validarCodigoOTP(OTPCodeVerification verificacion)
        {   
            
            JsonContent jsonCon = JsonContent.Create(verificacion);
            string categoriasResponse = await httpClient.post("api/verificarOTP", jsonCon);
            HttpLoginResponse finalLoginResponse = JsonSerializer.Deserialize<HttpLoginResponse>(categoriasResponse, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            try
            {
                return finalLoginResponse;
            }
            catch (ArgumentNullException ex)
            {
                string logMessage = $"[ERROR] Método: validarCodigoOTP - ArgumentNullException | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: validarCodigoOTP | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return null;
            }
        }
    }
}