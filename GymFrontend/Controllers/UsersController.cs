using Microsoft.AspNetCore.Mvc;

using Microsoft.AspNetCore.Identity;
using BL;
using BL.Utils;
using DTO.Dtos;
namespace GymFrontend.Controllers
{
    public class UsersController : Controller
    {



        private readonly IConfiguration config; 
        private UsersManager manager;
        private MedidasManager medidasManager;
        public UsersController(IConfiguration _config,UsersManager _manager,MedidasManager _medidasManager){
            config = _config;
            manager = _manager;
            medidasManager = _medidasManager;
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
            if (!ModelState.IsValid) { 
                return View("Login",credenciales);
            }

            
            HttpLoginResponse respuesta =  manager.login(credenciales).Result;
            if (respuesta.ok == false) {
                ViewBag.message = "Usuario y/o contraseña incorrectos";
                return View("Login");
            }
			ViewBag.message = "";
            ViewBag.cel = respuesta.data.Telefono;
            ViewBag.correo = respuesta.data.Correo;
            //return Redirect("https://localhost:7275/empleados");
            return Redirect(respuesta.urlPageForUser);
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
				return View("CrearCuenta",usuario);
			}
			
			ResponseHttp respuesta = manager.registrarUsuario(usuario).Result;
			ViewBag.message = respuesta.message;
            return View("CrearCuenta");
		}

		[HttpGet]
        [Route("clientes")]
        public  async Task<IActionResult> dirigirACrearPaginaDeClientes([FromQuery] string celular,[FromQuery] int idUser)
        {
            HttpResponseProgresoUsuario responseProgreso = await medidasManager.obtenerProgresoDelUsuario(idUser);
            

            return View("ClientesMainPage",responseProgreso.data);
        }

        [HttpGet]
        [Route("empleados")]
        public async Task<IActionResult> dirigirACrearPaginaDeEmpelados()
        {
            
            List<ExistingUser> usuarios = manager.obtenerUsuarios().Result.data;
            ResponseParametroDeMedicion respuestaParametros = await medidasManager.obtenerParametrosDeMedicion();
            List<DTOUnidadDeMedida> unidadDeMedida = ExtractDataManager.extractMeasurementUnitData(respuestaParametros.data);
            List<DTOParametroDeMedicion> parametrosDeMedicion =respuestaParametros.data.DistinctBy(p =>p.parametroMedicionId).ToList();
            ViewBag.usuarios = usuarios;
            ViewBag.parametros = parametrosDeMedicion;
            ViewBag.unidades = unidadDeMedida;
            return View("EmpleadosMainPage");
        }


        [HttpGet]
        [Route("validacionOTP")]
        public IActionResult dirigirACrearPaginaValidacionOTP([FromQuery]string celular, [FromQuery] string email)
        {
            celular = celular.Trim();
            email = email.Trim();
            
            OTPCodeVerification verificacion = new OTPCodeVerification() { cel = "+"+celular, correo = email };
            CanalDeEnvioOTP canal = new CanalDeEnvioOTP() {cel = "+"+celular,correo=email };
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
    }
}

