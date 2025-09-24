using Microsoft.AspNetCore.Mvc;

using Microsoft.AspNetCore.Identity;
using BL;
using BL.Utils;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using System.Collections.Generic;
using System.Threading.Tasks;
using System;

namespace GymFrontend.Controllers
{
    [ApiController]
    public class UsersController : Controller
    {
        private readonly IConfiguration config;
        private UsersManager manager;
        private MedidasManager medidasManager;
        private JwtTokenGenerator _jwtTokenGenerator;
        public UsersController(IConfiguration _config,
        UsersManager _manager,
        MedidasManager _medidasManager,
        JwtTokenGenerator jwtTokenGenerator
        )
        {
            config = _config;
            manager = _manager;
            medidasManager = _medidasManager;
            _jwtTokenGenerator = jwtTokenGenerator;
        }
        [HttpGet]
        [Route("signIn")]
        public IActionResult Index()
        {
            var res = config["ConnectionStrings:DefaultConnection"];
            return View("Login", new UserCredentials());
        }

        [HttpPost]
        [Route("signIn")]
        public async Task<IActionResult> executeSignIn([FromForm] UserCredentials credenciales)
        {
            var res = config["ConnectionStrings:DefaultConnection"];
            if (!ModelState.IsValid)
            {
                return View("Login", credenciales);
            }


            DTOResponse<DTOLoggedUser> respuesta = await manager.login(credenciales);
            if (respuesta.success == false)
            {
                ViewBag.message = "Usuario y/o contraseña incorrectos";
                return View("Login");
            }

            var claims = _jwtTokenGenerator.ValidateIdToken(respuesta.payload.IdToken);
            if (claims == null)
            {
                return View("Login");
            }
            Response.Cookies.Append("AuthToken", respuesta.payload.IdToken, new CookieOptions
            {
                HttpOnly = true,
                Secure = true,
                SameSite = SameSiteMode.Strict
            });
            Response.Cookies.Append("AccessToken", respuesta.payload.AccessToken, new CookieOptions
            {
                HttpOnly = true,
                Secure = true,
                SameSite = SameSiteMode.Strict
            });
            var roles = _jwtTokenGenerator.GetRoles(claims);
            var empleadoPage = config["pages:empleados"];
            var clientePage = config["pages:clientes"];
            if (roles.Contains("empleado"))
            {
                return Redirect(empleadoPage);
            }
            ViewBag.cel = respuesta.payload.Telefono;
            ViewBag.correo = respuesta.payload.Correo;

            return Redirect(clientePage);
        }

        [Authorize(Roles = "empleado,cliente")]
        [HttpPost]
        [Route("CerrarSesion")]
        public async Task<IActionResult> cerrarSesion()
        {
            if (Request.Cookies["AuthToken"] != null)
            {
                Response.Cookies.Delete("AuthToken"); // Elimina la cookie
            }

            return Redirect("signIn");

        }

        [HttpGet("obtenerUsuariosPorRol")]
        public async Task<IActionResult> ObtenerUsuariosPorRol([FromQuery] string rol, [FromQuery] string estado)
        {
            try
            {
                var result = await manager.ObtenerUsuariosPorRol(rol, estado);
                if (result.success)
                {
                    return Ok(result);
                }
                return BadRequest(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ResponseManager.BuildResponse<DTOResponse<List<QueryUser>>>(false, 500, "Error interno del servidor al obtener usuarios por rol.", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null));
            }
        }

        [HttpGet]
        [Route("signUp")]
        public IActionResult crearCuenta()
        {
            return View();
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
                ResponseHttp respuesta = manager.registrarUsuario(usuario).Result;
                ViewBag.message = respuesta.message;
                return View("CrearCuenta");
            }
            catch (Exception ex)
            {
                ViewBag.message = "Ocurrió un error al registrar el usuario: " + ex.Message;
                return View("CrearCuenta", usuario);
            }

        }
        [Authorize(Roles = "cliente")]
        [HttpGet]
        [Route("clientes")]
        public async Task<IActionResult> dirigirACrearPaginaDeClientes([FromQuery] string celular, [FromQuery] int idUser)
        {
            HttpResponseProgresoUsuario responseProgreso = await medidasManager.obtenerProgresoDelUsuario(idUser);


            return View("ClientesMainPage", responseProgreso.data);
        }

        [HttpGet]
        [Route("detallesDeProgreso")]
        public async Task<IActionResult> dirigirADetallesDeProgreso([FromQuery] int idCliente)
        {
            HttpResponseAñosActivo responseAñosActivo = await medidasManager.obtenerAñosActivosDelCliente(idCliente);
            return View("DetallesDeProgreso", responseAñosActivo.data);
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("empleados")]
        public async Task<IActionResult> dirigirACrearPaginaDeEmpelados()
        {

            var respuestaUsuarios = await manager.obtenerUsuarios();
            List<ExistingUser> usuarios = respuestaUsuarios.payload;
            var respuestaParametros = await medidasManager.obtenerParametrosDeMedicion();
            List<DTOUnidadDeMedida> unidadDeMedida = ExtractDataManager.extractMeasurementUnitData(respuestaParametros.payload);
            List<DTOParametroDeMedicion> parametrosDeMedicion = respuestaParametros.payload.DistinctBy(p => p.parametroMedicionId).ToList();
            ViewBag.usuarios = usuarios;
            ViewBag.parametros = parametrosDeMedicion;
            ViewBag.unidades = unidadDeMedida;
            return View("EmpleadosMainPage");
        }


        [HttpGet]
        [Route("validacionOTP")]
        public IActionResult dirigirACrearPaginaValidacionOTP([FromQuery] string celular, [FromQuery] string email)
        {
            celular = celular.Trim();
            email = email.Trim();

            OTPCodeVerification verificacion = new OTPCodeVerification() { cel = "+" + celular, correo = email };
            CanalDeEnvioOTP canal = new CanalDeEnvioOTP() { cel = "+" + celular, correo = email };
            HttpResponseGenerateOTP response = manager.obtenerCodigoOTP(canal).Result;
            return View("ValidacionOTP", verificacion);
        }

        [HttpPost]
        [Route("validacionOTPPost")]
        public IActionResult pedirValidacionDeCodigoOTP(OTPCodeVerification verificacion)
        {

            HttpLoginResponse response = manager.validarCodigoOTP(verificacion).Result;

            return Redirect(response.urlPageForUser);
        }

        


        [HttpGet]
        [Route("AccesoDenegado")]
        public async Task<IActionResult> dirigirAAccesoDenegado([FromQuery] int idCliente)
        {

            return View("AccesoDenegado");
        }
    }
}

