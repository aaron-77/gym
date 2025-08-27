using Microsoft.AspNetCore.Mvc;

using Microsoft.AspNetCore.Identity;
using BL;
using BL.Utils;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
namespace GymFrontend.Controllers
{
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
        public IActionResult executeSignIn(UserCredentials credenciales)
        {
            var res = config["ConnectionStrings:DefaultConnection"];
            if (!ModelState.IsValid)
            {
                return View("Login", credenciales);
            }


            DTOResponse<DTOLoggedUser> respuesta = manager.login(credenciales).Result;
            if (respuesta.success == false)
            {
                ViewBag.message = "Usuario y/o contraseña incorrectos";
                return View("Login");
            }

            var claims = _jwtTokenGenerator.ValidateToken(respuesta.payload.Token);
            if (claims == null)
            {
                return View("Login");
            }
            Response.Cookies.Append("AuthToken", respuesta.payload.Token, new CookieOptions
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

        [HttpGet]
        [Route("signUp")]
        public IActionResult crearCuenta()
        {
            return View();
        }

        [HttpPost]
        [Route("signUp")]
        public IActionResult postCrearCuenta(User usuario)
        {
            if (!ModelState.IsValid)
            {
                return View("CrearCuenta", usuario);
            }

            ResponseHttp respuesta = manager.registrarUsuario(usuario).Result;
            ViewBag.message = respuesta.message;
            return View("CrearCuenta");
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

            List<ExistingUser> usuarios = manager.obtenerUsuarios().Result.data;
            ResponseParametroDeMedicion respuestaParametros = await medidasManager.obtenerParametrosDeMedicion();
            List<DTOUnidadDeMedida> unidadDeMedida = ExtractDataManager.extractMeasurementUnitData(respuestaParametros.data);
            List<DTOParametroDeMedicion> parametrosDeMedicion = respuestaParametros.data.DistinctBy(p => p.parametroMedicionId).ToList();
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
        public  async Task<IActionResult> dirigirAAccesoDenegado([FromQuery] int idCliente)
        {
            
            return View("AccesoDenegado");
        }
    }
}

