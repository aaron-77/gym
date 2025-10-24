using API.Infraestructure.Auth;
using API.Services;
using BCrypt.Net;
using BL;
using BL.EnPointsLogic;
using BL.Utils;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Twilio;
using Twilio.Clients;
using Twilio.Rest.Verify.V2.Service;
using Twilio.Security;

namespace API.Controllers
{
    public class UsersController : Controller
    {
        public readonly IConfiguration configuration;
        public readonly IHttpContextAccessor _httpAccesor;

        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly JwtTokenGenerator _jwtTokenGenerator;
        private readonly AuthService _authService;
        private readonly JwtSettings _jwtSettings;
        private readonly FitnessCenterDbContext _db;

        public UsersController(
            SignInManager<ApplicationUser> signInManager,
            UserManager<ApplicationUser> userManager,
            JwtTokenGenerator jwtTokenGenerator,
            AuthService authService,
            IOptions<JwtSettings> jwtOptions,
            FitnessCenterDbContext db
        )
        {
            _signInManager = signInManager;
            _userManager = userManager;
            _jwtTokenGenerator = jwtTokenGenerator;
            _authService = authService;
            _jwtSettings = jwtOptions.Value;
            _db = db;
        }

        public IActionResult Index()
        {
            return View();
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("api/obtenerUsuarios")]
        public async Task<IActionResult> getUsuarios()
        {
            var jwt = Request.Cookies["AuthToken"];
            DTOResponse<List<ExistingUser>> respuesta = new DTOResponse<List<ExistingUser>>();

            List<ExistingUser> usuarios = await _userManager.Users
                .Select(u => new ExistingUser()
                {
                    Id = u.Id,
                    NombreCompleto = u.NombreCompleto,
                    Apellido = u.Apellido,
                    FechaDeNacimiento = u.FechaDeNacimiento,
                })
                .ToListAsync();
            respuesta.payload = usuarios;
            return Ok(respuesta);
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("api/obtenerUsuariosPorRol")]
        public async Task<IActionResult> getUsuariosPorRol(
            [FromQuery] string rol,
            [FromQuery] string estado = "activo"
        )
        {
            try
            {
                List<QueryUser> usuarios = await _db
                    .userSP.FromSqlInterpolated(
                        $@"EXEC [FitnessCenterDB].[dbo].sp_consultarUsuarios @tipoUsuario={rol},@estado={estado}"
                    )
                    .ToListAsync();

                var respuesta = BL.Utils.ResponseManager.BuildResponse(
                    success: true,
                    httpCode: 200,
                    message: "Consulta exitosa",
                    errors: null,
                    payload: usuarios
                );

                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                var respuesta = BL.Utils.ResponseManager.BuildResponse(
                    success: false,
                    httpCode: 500,
                    message: "Error al obtener usuarios",
                    errors: new List<ErrorModel>
                    {
                        new ErrorModel { message = ex.Message, propiedad = null },
                    },
                    payload: (List<QueryUser>)null
                );

                return StatusCode(500, respuesta);
            }
        }

        [HttpPost]
        [Route("api/RegistrarUsuario")]
        public async Task<IActionResult> RegistrarUsuario([FromBody] NewUser usuario)
        {
            DTOResponse<DTOCreatedUser> respuesta = new DTOResponse<DTOCreatedUser>();
            if (!ModelState.IsValid)
            {
                List<string> nombresCampos = new List<string>()
                {
                    "nombre",
                    "direccion",
                    "correo",
                    "contrasena",
                    "identificacion",
                    "fecha",
                    "telefono",
                };
                foreach (var item in ModelState.Values)
                {
                    foreach (var item1 in item.Errors)
                    {
                        ErrorModel error = new ErrorModel();
                        string nombreCampo = nombresCampos
                            .Where(c => item1.ErrorMessage.Contains(c))
                            .FirstOrDefault();
                        error.propiedad = nombreCampo;
                        error.message = item1.ErrorMessage;
                        respuesta.errors.Add(error);
                    }
                }
                respuesta = ResponseManager.BuildResponse<DTOCreatedUser>(
                    success: false,
                    httpCode: 400,
                    message: "Los datos proporcionados son inválidos",
                    errors: respuesta.errors,
                    payload: null
                );

                return BadRequest(respuesta);
            }

            if (usuario == null)
            {
                respuesta = ResponseManager.BuildResponse<DTOCreatedUser>(
                    success: false,
                    httpCode: 400,
                    message: "No has proporcionado ningun dato",
                    errors: new List<ErrorModel>
                    {
                        new ErrorModel
                        {
                            message = "no se han enviado datos para el registro",
                            propiedad = "ninguna",
                        },
                    },
                    payload: null
                );
                return BadRequest(respuesta);
            }
            try
            {
                var registerResult = await _authService.RegisterUserWithRoleAsync(
                    usuario,
                    usuario.Rol
                );
                if (registerResult == null)
                {
                    ResponseManager.BuildResponse<DTOCreatedUser>(
                        success: false,
                        httpCode: 500,
                        message: "Hubo un problema al registrar el usuario",
                        errors: new List<ErrorModel>
                        {
                            new ErrorModel
                            {
                                message = "Problema no identificado",
                                propiedad = "No definida",
                            },
                        },
                        payload: null
                    );
                    return StatusCode(500, respuesta);
                }
                respuesta = ResponseManager.BuildResponse<DTOCreatedUser>(
                    success: true,
                    httpCode: 200,
                    message: "Usuario registrado exitosamente",
                    errors: null,
                    payload: registerResult
                );
            }
            catch (Exception ex)
            {
                respuesta = ResponseManager.BuildResponse<DTOCreatedUser>(
                    success: false,
                    httpCode: 500,
                    message: $"Error al registrar el usuario:{ex.Message}",
                    errors: new List<ErrorModel>
                    {
                        new ErrorModel { message = ex.Message, propiedad = "No definida" },
                    },
                    payload: null
                );
                return StatusCode(500, respuesta);
            }
            return Ok(respuesta);
        }

        [Route("api/AgregarRolUsuario")]
        [HttpPost]
        public async Task<IActionResult> AgregarRolUsuario([FromBody] DTOAgregarRol request)
        {
            DTOResponse<string> respuesta = new DTOResponse<string>();

            if (!ModelState.IsValid)
            {
                // Manejo de errores de validación
                var errores = ModelState
                    .Values.SelectMany(v => v.Errors)
                    .Select(e => new ErrorModel
                    {
                        message = e.ErrorMessage,
                        propiedad = "No definida",
                    })
                    .ToList();

                respuesta = ResponseManager.BuildResponse<string>(
                    success: false,
                    httpCode: 400,
                    message: "Datos inválidos",
                    errors: errores,
                    payload: null
                );

                return BadRequest(respuesta);
            }

            try
            {
                await _authService.AddRoleToUserAsync(request.UserId, request.Role);

                respuesta = ResponseManager.BuildResponse<string>(
                    success: true,
                    httpCode: 200,
                    message: $"Rol '{request.Role}' asignado correctamente al usuario",
                    errors: null,
                    payload: null
                );
            }
            catch (Exception ex)
            {
                respuesta = ResponseManager.BuildResponse<string>(
                    success: false,
                    httpCode: 500,
                    message: $"Error al asignar rol: {ex.Message}",
                    errors: new List<ErrorModel>
                    {
                        new ErrorModel { message = ex.Message, propiedad = "No definida" },
                    },
                    payload: null
                );

                return StatusCode(500, respuesta);
            }

            return Ok(respuesta);
        }

        

        [HttpPost]
        [Route("api/autenticar")]
        public async Task<IActionResult> AutenticarUsuario([FromBody] UserCredentials credenciales)
        {
            var loggedUser = await _authService.AuthenticateUser(
                credenciales.correo,
                credenciales.contrasena
            );
            DTOResponse<DTOLoggedUser> response = ResponseManager.BuildResponse<DTOLoggedUser>(
                success: false,
                httpCode: 400,
                message: "Usuario o contraseña incorrectos",
                errors: null,
                payload: null
            );
            if (loggedUser == null)
            {
                return Unauthorized(response);
            }

            response = ResponseManager.BuildResponse<DTOLoggedUser>(
                success: true,
                httpCode: 200,
                message: "Autenticación exitosa",
                errors: null,
                payload: loggedUser
            );
            // Devolver token
            return Ok(response);
        }

        [Authorize(Roles = "empleado,cliente")]
        [HttpPost]
        [Route("api/refresh")]
        public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenRequest request)
        {
            var refreshedUser = await _authService.RefreshAccessToken(request.RefreshToken);
            if (refreshedUser == null)
            {
                return Unauthorized(
                    ResponseManager.BuildResponse<DTOLoggedUser>(
                        success: false,
                        httpCode: 401,
                        message: "Refresh token inválido o expirado",
                        errors: null,
                        payload: refreshedUser
                    )
                );
            }

            var response = ResponseManager.BuildResponse<DTOLoggedUser>(
                success: true,
                httpCode: 200,
                message: "Tokens refrescados exitosamente",
                errors: null,
                payload: refreshedUser
            );
            return Ok(response);
        }

        [Authorize(Roles = "empleado,cliente")]
        [HttpPost]
        [Route("api/logout")]
        public IActionResult Logout([FromBody] LogoutRequest request)
        {
            _authService.RevokeRefreshToken(request.RefreshToken);
            var response = ResponseManager.BuildResponse<object>(
                success: true,
                httpCode: 200,
                message: "Sesión cerrada exitosamente",
                errors: null,
                payload: null
            );
            return Ok(response);
        }

        [HttpPost]
        [Route("api/getOTPCode")]
        public async Task<IActionResult> obtenerCodigoOTP([FromBody] CanalDeEnvioOTP canal)
        {
            HttpResponseGenerateOTP response = new HttpResponseGenerateOTP();

            try
            {
                //AccountId,Token
                TwilioClient.Init(
                    "AC9ecb12865c83eb291ab8a2c520fcee14",
                    "cb8c1ceafb83b80649f064806617eab8"
                );
                var verificacion = await VerificationResource.CreateAsync(
                    channel: "sms",
                    to: canal.cel,
                    //serviceId
                    pathServiceSid: "VA7cfeb5608d0f76ca2bd2960546149332"
                );
                response.data.status = verificacion.Status;
                response.data.channel = verificacion.Channel.ToString();
            }
            catch (Exception ex)
            {
                response.ok = false;
                response.message = "No se pudo crear el codigo de verificacion";
                response.errors.Add(new ErrorModel() { message = ex.Message, propiedad = null });
                response.data = null;
            }

            return Ok(response);
        }

        [HttpPost]
        [Route("api/verificarOTP")]
        public async Task<IActionResult> verificarCodigoOTP(
            [FromBody] OTPCodeVerification userVerification
        )
        {

            /*
            HttpLoginResponse response = new HttpLoginResponse();
            string baseUrl = _jwtSettings.BackendAudiencie;
            try
            {
                TwilioClient.Init(
                    "AC9ecb12865c83eb291ab8a2c520fcee14",
                    "cb8c1ceafb83b80649f064806617eab8"
                );
                var verificacion = await VerificationCheckResource.CreateAsync(
                    to: userVerification.cel,
                    code: userVerification.codigo,
                    pathServiceSid: "VA7cfeb5608d0f76ca2bd2960546149332"
                );

                if (verificacion.Status == "approved")
                {
                    response.ok = true;
                    response.message = "validacion exitosa";
                    response.errors = null;
                    var loggedUser = _db
                        .AspNetUsers.Include(u => u.Roles)
                        .Where(u => u.PhoneNumber == userVerification.cel)
                        .FirstOrDefault();

                    NewUser responseUser = new NewUser(
                        loggedUser.NombreCompleto,
                        loggedUser.FechaDeNacimiento,
                        "",
                        "",
                        loggedUser.Email,
                        loggedUser.PhoneNumber,
                        loggedUser.Apellido,
                        ""
                    );
                    response.ok = true;
                    response.data = responseUser;
                    response.message = "Verificacion exitosa";
                    if (loggedUser.Roles.FirstOrDefault()?.Name == "empleado")
                    {
                        response.urlPageForUser = baseUrl + "/empleados";
                    }
                    else if (loggedUser.Roles.FirstOrDefault()?.Name == "cliente")
                    {
                        response.urlPageForUser = baseUrl + "/clientes";
                    }
                }
                else
                {
                    response.ok = true;
                    response.data = null;
                    response.message = "No se pudo verificar tu identidad";
                    response.urlPageForUser = baseUrl + "/signIn";
                }
            }
            catch (Exception ex)
            {
                response.ok = false;
                response.message = "Error en el proceso de verificacion del codigo";
                response.errors.Add(new ErrorModel() { message = ex.Message, propiedad = null });
                response.data = null;
            }

            return Ok(response);
            */
            return Ok();
        }
    }
}
