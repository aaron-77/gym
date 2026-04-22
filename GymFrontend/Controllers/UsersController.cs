using BL;
using BL.Utils;
using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Threading.Tasks;

namespace GymFrontend.Controllers
{
    
    public class UsersController : Controller
    {
        private readonly IConfiguration config;
        private UsersManager manager;
        private MedidasManager medidasManager;
        private JwtTokenGenerator _jwtTokenGenerator;
        private CookieService _cookieService;
        private readonly Microsoft.Extensions.Logging.ILogger<UsersController> _logger;

        public UsersController(
            IConfiguration _config,
            UsersManager _manager,
            MedidasManager _medidasManager,
            JwtTokenGenerator jwtTokenGenerator,
            CookieService cookieService,
            Microsoft.Extensions.Logging.ILogger<UsersController> logger
        )
        {
            config = _config;
            manager = _manager;
            medidasManager = _medidasManager;
            _jwtTokenGenerator = jwtTokenGenerator;
            _cookieService = cookieService;
            _logger = logger;
        }

        [HttpGet]
        [Route("signIn")]
        public IActionResult Index()
        {
            try
            {
                _logger?.LogInformation("Start UsersController.Index (GET signIn)");
                var res = config["ConnectionStrings:DefaultConnection"];
                return View("Login", new UserCredentials());
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: Index (GET signIn) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error Index (UsersController) GET signIn");
                ViewBag.message = "Error al cargar la página de login.";
                return View("Login", new UserCredentials());
            }
        }

        [HttpPost]
        [Route("signIn")]
        public async Task<IActionResult> executeSignIn([FromForm] UserCredentials credenciales)
        {
            try
            {
                _logger?.LogInformation("Start UsersController.executeSignIn");
                var res = config["ConnectionStrings:DefaultConnection"];
                if (!ModelState.IsValid)
                {
                    return View("Login", credenciales);
                }

                DTOResponse<DTOLoggedUser> respuesta = await manager.login(credenciales);
                if (respuesta != null && respuesta.success == false)
                {
                    ViewBag.message = "Usuario y/o contraseña incorrectos";
                    return View("Login");
                }

                var claims = _jwtTokenGenerator.ValidateIdToken(respuesta.payload.IdToken);
                if (claims == null)
                {
                    return View("Login");
                }
                _cookieService.AgregarCookie(Response, "AuthToken", respuesta.payload.IdToken);
                _cookieService.AgregarCookie(Response, "AccessToken", respuesta.payload.AccessToken);
                _cookieService.AgregarCookie(Response, "RefreshToken", respuesta.payload.RefreshToken);
                var roles = _jwtTokenGenerator.GetRoles(claims);
                var empleadoPage = config["pages:empleados"];
                var clientePage = config["pages:clientes"];
                if (roles.Contains("empleado"))
                {
                    _logger?.LogInformation("User redirected to empleado page");
                    return Redirect(empleadoPage);
                }
                ViewBag.cel = respuesta.payload.Telefono;
                ViewBag.correo = respuesta.payload.Correo;
                _logger?.LogInformation("User redirected to cliente page");
                return RedirectToAction("dirigirACrearPaginaDeClientes", new { idUser = respuesta.payload.Id });
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: executeSignIn (POST signIn) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error executeSignIn (UsersController)");
                ViewBag.message = "Ocurrió un error al procesar el inicio de sesión.";
                return View("Login", credenciales);
            }
        }

        [Authorize(Roles = "empleado,cliente")]
        [HttpPost]
        [Route("CerrarSesion")]
        public async Task<IActionResult> cerrarSesion()
        {
            try
            {
                _logger?.LogInformation("Start UsersController.cerrarSesion");
                if (Request.Cookies["AuthToken"] != null)
                {
                    Response.Cookies.Delete("AuthToken");
                    Response.Cookies.Delete("AccessToken"); // Elimina la cookie
                }

                return Redirect("signIn");
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: cerrarSesion | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error cerrarSesion (UsersController)");
                return Redirect("signIn");
            }
        }

        [HttpGet("obtenerUsuariosPorRol")]
        public async Task<IActionResult> ObtenerUsuariosPorRol(
            [FromQuery] string rol,
            [FromQuery] string estado
        )
        {
            try
            {
                _logger?.LogInformation("Start UsersController.ObtenerUsuariosPorRol rol={Rol} estado={Estado}", rol, estado);
                var result = await manager.ObtenerUsuariosPorRol(rol, estado);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerUsuariosPorRol | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error ObtenerUsuariosPorRol (UsersController) rol={Rol} estado={Estado}", rol, estado);
                
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<DTOResponse<List<QueryUser>>>(
                        false,
                        500,
                        "Error interno del servidor al obtener usuarios por rol.",
                        new List<ErrorModel> { new ErrorModel { message = ex.Message } },
                        null
                    )
                );
            }
        }

        [HttpGet]
        [Route("signUp")]
        public IActionResult crearCuenta()
        {
            try
            {
                _logger?.LogInformation("Start UsersController.crearCuenta");
                return View();
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: crearCuenta (GET signUp) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error crearCuenta (UsersController) GET signUp");
                ViewBag.message = "Error al cargar la página de creación de cuenta.";
                return View();
            }
        }

        [HttpPost]
        [Route("signUp")]
        public IActionResult postCrearCuenta([FromForm] User usuario)
        {
            if (!ModelState.IsValid)
            {
                return View("CrearCuenta", usuario);
            }
            try
            {
                _logger?.LogInformation("Start UsersController.postCrearCuenta");
                ResponseHttp respuesta = manager.registrarUsuario(usuario).Result;
                ViewBag.message = respuesta.message;
                return View("CrearCuenta");
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: postCrearCuenta | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error postCrearCuenta (UsersController)");
                ViewBag.message = "Ocurrió un error al registrar el usuario: " + ex.Message;
                return View("CrearCuenta", usuario);
            }
        }

        [Authorize(Roles = "cliente")]
        [HttpGet]
        [Route("clientes")]
        public async Task<IActionResult> dirigirACrearPaginaDeClientes(
            [FromQuery] string idUser
        )
        {

            try {
                _logger?.LogInformation("Start UsersController.dirigirACrearPaginaDeClientes idUser={Id}", idUser);
                // idUser is expected as string (could be numeric id or guid depending on system)
                var response = await medidasManager.obtenerProgresoDelUsuario(idUser);

                if (response == null || !response.success)
                {
                    // Handle error: redirect or show error page
                    Console.WriteLine("No se encontro progreso del usuario: ");
                    ViewBag.message = response?.message ?? "Error al obtener progreso del usuario.";
                    return View("ClientesMainPage", null);
                }

                return View("ClientesMainPage", response.payload);

            }
            catch (Exception ex) {
                string logMessage = $"[ERROR] Método: dirigirACrearPaginaDeClientes | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"IdUsuario: {idUser} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error dirigirACrearPaginaDeClientes (UsersController) idUser={Id}", idUser);
                return View("ClientesMainPage", null);
            }
            
        }

        [HttpGet]
        [Route("detallesDeProgreso")]
        public async Task<IActionResult> dirigirADetallesDeProgreso([FromQuery] int idCliente)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                HttpResponseAñosActivo responseAñosActivo = await medidasManager.obtenerAñosActivosDelCliente(userId);
                ViewBag.anosActivo = responseAñosActivo.data;
                ViewBag.userId = userId;
                return View("DetallesDeProgreso");
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: dirigirADetallesDeProgreso | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                return View("DetallesDeProgreso");
            }
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("empleados")]
        public async Task<IActionResult> dirigirACrearPaginaDeEmpelados()
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                var respuestaUsuarios = await manager.obtenerUsuarios();
                List<ExistingUser> usuarios = respuestaUsuarios.payload;
               var respuestaParametros = await medidasManager.obtenerParametrosDeMedicion(userId);
                List<DTOUnidadDeMedida> unidadDeMedida = ExtractDataManager.extractMeasurementUnitData(
                    respuestaParametros.payload
                );
                List<DTOParametroDeMedicion> parametrosDeMedicion = respuestaParametros
                    .payload.DistinctBy(p => p.parametroMedicionId)
                    .ToList();
                ViewBag.usuarios = usuarios;
                ViewBag.parametros = parametrosDeMedicion;
                ViewBag.unidades = unidadDeMedida;
                
                return View("EmpleadosMainPage");
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: dirigirACrearPaginaDeEmpelados | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                ViewBag.message = "Error al cargar la página de empleados.";
                return View("EmpleadosMainPage");
            }
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("getSessionTimeExpiration")]
        public async Task<DTOResponse<string>> getSessionTimeExpiration()
        {
            try
            {
                var token = Request.Cookies["AuthToken"];
                var claims = _jwtTokenGenerator.ValidateIdToken(token);
                string expirationDate = claims
                    .FirstOrDefault(c =>
                        c.Key == ClaimTypes.Expiration || c.Key == JwtRegisteredClaimNames.Exp
                    )
                    .Value;

                var response = ResponseManager.BuildResponse(
                    true,
                    200,
                    "se obtuvo la expiracion de la sesion",
                    null,
                    expirationDate
                );
                return response;
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: getSessionTimeExpiration | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                return ResponseManager.BuildResponse<string>(false, 500, "Error interno al obtener la expiración.", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
            }
        }

        [Authorize(Roles = "empleado,cliente")]
        [HttpPost]
        [Route("updateIdAndAccessTokens")]
        public async Task<IActionResult> updateTokens()
        {
            try
            {
                var refreshToken = Request.Cookies["RefreshToken"];
                var idUserTokenOwner = _jwtTokenGenerator.ValidateRefreshToken(refreshToken);
                RefreshTokenRequest refreshTokenRequest = new RefreshTokenRequest
                {
                    RefreshToken = refreshToken,
                };
                if (idUserTokenOwner == null)
                {
                    return Redirect(config["pages:logout"]);
                }
                var updateResponse = await manager.updateIdAndAccessToken(refreshTokenRequest);

                if (!updateResponse.success)
                {
                    return Redirect(config["pages:logout"]);
                }

                _cookieService.AgregarCookie(Response, "AuthToken", updateResponse.payload.IdToken);
                _cookieService.AgregarCookie(
                    Response,
                    "AccessToken",
                    updateResponse.payload.AccessToken
                );
                _cookieService.AgregarCookie(
                    Response,
                    "RefreshToken",
                    updateResponse.payload.RefreshToken
                );
                var responseUpdatedTokens = updateResponse;
                
                return Ok(responseUpdatedTokens);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: updateTokens | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                var reponseUpdateTokensFailed = ResponseManager.BuildResponse<string>(
                    false,
                    500,
                    "Error interno del servidor al actualizar los tokens.",
                    null,
                    null
                );
                return StatusCode(500, reponseUpdateTokensFailed);
            }
        }

        [HttpGet]
        [Route("validacionOTP")]
        public IActionResult dirigirACrearPaginaValidacionOTP(
            [FromQuery] string celular,
            [FromQuery] string email
        )
        {
            try
            {
                celular = celular.Trim();
                email = email.Trim();

                OTPCodeVerification verificacion = new OTPCodeVerification()
                {
                    cel = "+" + celular,
                    correo = email,
                };
                CanalDeEnvioOTP canal = new CanalDeEnvioOTP() { cel = "+" + celular, correo = email };
                HttpResponseGenerateOTP response = manager.obtenerCodigoOTP(canal).Result;
                return View("ValidacionOTP", verificacion);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: dirigirACrearPaginaValidacionOTP | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                ViewBag.message = "Error al procesar la solicitud de validación OTP.";
                return View("ValidacionOTP");
            }
        }

        [HttpPost]
        [Route("validacionOTPPost")]
        public IActionResult pedirValidacionDeCodigoOTP(OTPCodeVerification verificacion)
        {
            try
            {
                HttpLoginResponse response = manager.validarCodigoOTP(verificacion).Result;
                return Redirect(response.urlPageForUser);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: pedirValidacionDeCodigoOTP | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                ViewBag.message = "Error al validar el código OTP.";
                return View("ValidacionOTP", verificacion);
            }
        }

        [HttpGet]
        [Route("AccesoDenegado")]
        public async Task<IActionResult> dirigirAAccesoDenegado([FromQuery] int idCliente)
        {
            try
            {
                return View("AccesoDenegado");
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: dirigirAAccesoDenegado | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                return View("AccesoDenegado");
            }
        }
    }
}
