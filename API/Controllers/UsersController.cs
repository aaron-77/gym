using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using DataAccess.EntityFramework;
using Twilio.Security;
using Twilio.Clients;
using BCrypt.Net;
using Twilio;
using Twilio.Rest.Verify.V2.Service;
using BL;
using BL.EnPointsLogic;

namespace API.Controllers
{
    public class UsersController : Controller
    {
        public readonly IConfiguration configuration;
        public readonly IHttpContextAccessor _httpAccesor;
        public readonly EndPointsManager _emanager;

        public UsersController(EndPointsManager emanager)
        {
            _emanager = emanager;
        }
        public IActionResult Index()
        {
            return View();
        }
        [HttpGet]
        [Route("api/obtenerUsuarios")]
        public async Task<IActionResult> getUsuarios()
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            DTO.Dtos.HttpResponseModelListadoUsers respuesta = new HttpResponseModelListadoUsers();
            List<ExistingUser> usuarios = await db.Usuarios.
                                              Select(
                                                    u => new ExistingUser()
                                                    {
                                                        Id = u.UsuarioId,
                                                        NombreCompleto = u.Nombre,
                                                        Apellido = u.Apellido,
                                                        FechaDeNacimiento = u.FechaNacimiento
                                                    }).ToListAsync();
            respuesta.data = usuarios;
            return Ok(respuesta);
        }

        [HttpGet]
        [Route("api/obtenerUsuariosPorRol")]
        public async Task<IActionResult> getUsuariosPorRol([FromQuery] string rol, [FromQuery] string estado)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            HttpResponseListadoQueryUsers respuesta = new HttpResponseListadoQueryUsers();
            List<QueryUser> usuarios = await db.userSP.FromSqlInterpolated($@"EXEC dbo.sp_consultarUsuarios @tipoUsuario={rol},@estado={estado}").ToListAsync();
            respuesta.ok = true;
            respuesta.errors = null;
            respuesta.message = "consulta exitosa";
            respuesta.data = usuarios;
            return Ok(respuesta);
        }

        /*
        [HttpPost]
        [Route("api/autenticar")]

        public IActionResult RegistrarUsuario([FromBody] UserCredentials credenciales)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            
            if (credenciales == null)
            {

                return null;
            }
            HttpLoginResponse respuesta = new HttpLoginResponse();
            Usuario dbUser = db.Usuarios.FirstOrDefault(u => u.Email == credenciales.correo
                                                            &&
                                                        u.Contrasena == credenciales.contrasena);
            if (dbUser == null)
            {
F                respuesta.ok = false;
                respuesta.data = null;
                return BadRequest(respuesta);
            }
            Role matchedRole = db.Roles.FirstOrDefault(r => r.RolId == dbUser.RolId);

            respuesta.ok = true;
            respuesta.data = new NewUser(dbUser.Nombre, dbUser.FechaNacimiento, "no tiene direccion", "No tiene identificacion", dbUser.Email, dbUser.Telefono, " ");
            if (matchedRole.NombreRol == "cliente")
            {
                respuesta.urlPageForUser = "https://localhost:5262/clientes";

            }
            if (matchedRole.NombreRol == "empleado")
            {
                respuesta.urlPageForUser = "https://localhost:5262/empleados";
            }
            return Ok(respuesta);

        }*/


        [HttpPost]
        [Route("api/RegistrarUsuario")]

        public IActionResult RegistrarUsuario([FromBody] NewUser usuario)
        {
            HttpResponseModel respuesta = new HttpResponseModel();
            if (!ModelState.IsValid)
            {
                List<string> nombresCampos = new List<string>() { "nombre", "direccion", "correo", "contrasena", "identificacion", "fecha", "telefono" };
                foreach (var item in ModelState.Values)
                {
                    foreach (var item1 in item.Errors)
                    {
                        ErrorModel error = new ErrorModel();
                        string nombreCampo = nombresCampos.Where(c => item1.ErrorMessage.Contains(c)).FirstOrDefault();
                        error.propiedad = nombreCampo;
                        error.message = item1.ErrorMessage;
                        respuesta.errors.Add(error);
                    }

                };
                respuesta.ok = false;
                respuesta.message = "Error al registrar tu cuenta";
                return BadRequest(respuesta);
            }

            FitnessCenterDbContext db = new FitnessCenterDbContext();

            if (usuario == null)
            {

                return null;
            }
            Usuario newUserDB = new Usuario()
            {
                Nombre = usuario.NombreCompleto,
                Apellido = usuario.Apellido,
                NombreUsuario = "elusuario" + DateTime.Now.ToString(),
                Email = usuario.Correo,
                FechaNacimiento = usuario.FechaDeNacimiento,
                Contrasena = usuario.Contrasena,
                Telefono = usuario.Telefono,
                Estado = "activo",
                FechaRegistro = null,
                RolId = 1

            };
            try
            {
                db.Add(newUserDB);
                db.SaveChanges();
                respuesta.ok = true;
                respuesta.data = usuario;
                respuesta.errors = null;
                respuesta.message = "Registro exitoso";
            }
            catch (DbUpdateException ex)
            {
                respuesta.ok = false;
                respuesta.data = null;
                ErrorModel error = new ErrorModel();
                if (ex.InnerException.Message.Contains("UNIQUE"))
                {
                    error.message = "correo duplicado";
                    respuesta.message = "Ese correo ya esta registrado";
                }
                else
                {
                    error.message = "Error no definido del servidor";
                    respuesta.message = "No se ha podido registrar tu cuenta";
                }
                respuesta.errors.Add(error);
                return BadRequest(respuesta);


            }
            return Ok(respuesta);
        }

        [HttpPost]
        [Route("api/autenticar")]
        public IActionResult AutenticarUsuario([FromBody] UserCredentials credenciales)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            string baseUrl = _emanager.getBaseUrl("frontend");
            if (credenciales == null)
            {
                return BadRequest("Credenciales no proporcionadas.");
            }

            HttpLoginResponse respuesta = new HttpLoginResponse();
            Usuario dbUser = db.Usuarios.FirstOrDefault(u => u.Email == credenciales.correo);

            if (dbUser == null || !BCrypt.Net.BCrypt.Verify(credenciales.contrasena, dbUser.Contrasena))
            {
                respuesta.ok = false;
                respuesta.data = null;
                respuesta.urlPageForUser = baseUrl+"/SignIn";
                return BadRequest(respuesta);
            }
            Role matchedRole = db.Roles.FirstOrDefault(r => r.RolId == dbUser.RolId);
            respuesta.ok = true;
            respuesta.data = new NewUser(dbUser.Nombre, dbUser.FechaNacimiento, "no tiene direccion", "No tiene identificacion", dbUser.Email, dbUser.Telefono, dbUser.Apellido, "");
            //respuesta.urlPageForUser = baseUrl+"/validacionOTP";
            respuesta.urlPageForUser = baseUrl+$"/clientes?idUser={dbUser.UsuarioId}&celular={dbUser.Telefono}&email={dbUser.Email}";
            if(matchedRole.NombreRol == "empleado")
            {
                respuesta.urlPageForUser = baseUrl+"/empleados";
            }
            


            return Ok(respuesta);
        }

        [HttpPost]
        [Route("api/getOTPCode")]
        public async Task<IActionResult> obtenerCodigoOTP([FromBody] CanalDeEnvioOTP canal)
        {
            HttpResponseGenerateOTP response = new HttpResponseGenerateOTP();

            try
            {
                //AccountId,Token
                TwilioClient.Init("AC9ecb12865c83eb291ab8a2c520fcee14", "cb8c1ceafb83b80649f064806617eab8");
                var verificacion = await VerificationResource.
                    CreateAsync(channel: "sms", to:
                    canal.cel,
                    //serviceId
                    pathServiceSid: "VA7cfeb5608d0f76ca2bd2960546149332");
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
        public async Task<IActionResult> verificarCodigoOTP([FromBody] OTPCodeVerification userVerification)
        {
            HttpLoginResponse response = new HttpLoginResponse();
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            string baseUrl = _emanager.getBaseUrl("frontend");
            try
            {
                
                TwilioClient.Init("AC9ecb12865c83eb291ab8a2c520fcee14", "cb8c1ceafb83b80649f064806617eab8");
                var verificacion = await VerificationCheckResource.
                    CreateAsync(
                    to: userVerification.cel,
                    code: userVerification.codigo,
                    pathServiceSid: "VA7cfeb5608d0f76ca2bd2960546149332");


                if (verificacion.Status == "approved")
                {
                    response.ok = true;
                    response.message = "validacion exitosa";
                    response.errors = null;
                    var loggedUser = db.Usuarios.Include(u => u.Rol).Where(u => u.Telefono == userVerification.cel).FirstOrDefault();


                    NewUser responseUser = new NewUser(loggedUser.Nombre,
                                                       loggedUser.FechaNacimiento,
                                                       "",
                                                       "",
                                                       loggedUser.Email,
                                                       loggedUser.Telefono,
                                                       loggedUser.Apellido,
                                                       "");
                    response.ok = true;
                    response.data = responseUser;
                    response.message = "Verificacion exitosa";
                    if (loggedUser.Rol.NombreRol == "empleado")
                    {
                        response.urlPageForUser = baseUrl+"/empleados";
                    }
                    else if (loggedUser.Rol.NombreRol == "cliente")
                    {
                        response.urlPageForUser = baseUrl+"/clientes";
                    }
                }
                else
                {
                    response.ok = true;
                    response.data = null;
                    response.message = "No se pudo verificar tu identidad";
                    response.urlPageForUser = baseUrl+"/signIn";
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

        }

    }
}
