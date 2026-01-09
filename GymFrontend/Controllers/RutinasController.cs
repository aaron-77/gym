using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using BL;
using BL.Utils;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GymFrontend.Controllers
{
    public class RutinasController:Controller
    {
        private UsersManager manager;
        private RutinasManager rutinasManager;
        private EjerciciosManager ejerciciosManager;
        private JwtTokenGenerator jwtTokenGenerator;
        private readonly Microsoft.Extensions.Logging.ILogger<RutinasController> _logger;

        public RutinasController(UsersManager _manager,
                                RutinasManager _rutinasManager,
                                EjerciciosManager _ejerciciosManager,
                                JwtTokenGenerator _jwtTokenGenerator,
                                Microsoft.Extensions.Logging.ILogger<RutinasController> logger)
        {
            manager = _manager;
            rutinasManager = _rutinasManager;
            ejerciciosManager = _ejerciciosManager;
            jwtTokenGenerator = _jwtTokenGenerator;
            _logger = logger;
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("gestionRutinas")]
        public async Task<IActionResult> Index()
        {
            try
            {
                _logger?.LogInformation("Start RutinasController.Index");
                string pageToRender = "GestionRutinas";

                var respuestaClientes = await manager.ObtenerUsuariosPorRol("cliente", "activo");
                var respuestaEntrenadores = await manager.ObtenerUsuariosPorRol("empleado", "activo");
                ViewBag.clientes = respuestaClientes.payload;
                ViewBag.entrenadores = respuestaEntrenadores.payload;
                return View("GestionRutinas", new Rutina());
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: Index (RutinasController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error Index (RutinasController)");
                ViewBag.message = "Error al cargar la página de gestión de rutinas.";
                return View("GestionRutinas", new Rutina());
            }

        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("asignarEjercicios")]
        public async Task<IActionResult> asignarEjercicios([FromQuery] string usuarioID = null)
        {
            try
            {
                _logger?.LogInformation("Start RutinasController.asignarEjercicios usuarioID={UsuarioID}", usuarioID);
                var respuestaClientes = await manager.ObtenerUsuariosPorRol("cliente", "activo");
                ViewBag.clientes = respuestaClientes.payload;
                if (!string.IsNullOrEmpty(usuarioID)) {
                    var respuestaRutinas = await rutinasManager.obtenerRutinasDeUsuario(usuarioID);
                    var respuestaEjercicios = await ejerciciosManager.obtenerEjercicios();
                    ViewBag.rutinas = respuestaRutinas.payload;
                    ViewBag.ejercicios = respuestaEjercicios.payload;
                }
                return View("AsignacionEjercicios");
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: asignarEjercicios | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | UsuarioID: {usuarioID} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error asignarEjercicios (RutinasController) usuarioID={UsuarioID}", usuarioID);
                ViewBag.message = "Error al cargar la página de asignación de ejercicios.";
                return View("AsignacionEjercicios");
            }
        }
           
    [HttpPost]
        [Route("gestionRutinas")]
        public async Task<IActionResult> gestionarRutinas(Rutina rutina)
        {
            try
            {
                _logger?.LogInformation("Start RutinasController.gestionarRutinas UsuarioID={UsuarioId}", rutina?.UsuarioID);
                rutina.FechaCreacion = DateTime.Now;

                var respuestaClientes = await manager.ObtenerUsuariosPorRol("cliente", "activo");
                var respuestaEntrenadores = await manager.ObtenerUsuariosPorRol("empleado", "activo");
                ViewBag.clientes 
    = respuestaClientes.payload;
                ViewBag.entrenadores = respuestaEntrenadores.payload;
                if (!ModelState.IsValid)
                {
                    return View("GestionRutinas", rutina);
                }
                
                
                HttpResponseRutina respuesta = rutinasManager.registrarRutina(rutina).Result;
                if (respuesta == null)
                {
                    ViewBag.message = "Error al registrar la rutina.";
                    return View("GestionRutinas", rutina);
                }
                if (respuesta.ok == false)
                {
                    ViewBag.message = respuesta.message;
                    return View("GestionRutinas");
                }
                ViewBag.message = respuesta.message;
                return View("GestionRutinas");
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: gestionarRutinas | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | UsuarioID: {rutina?.UsuarioID} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error gestionarRutinas (RutinasController)");
                ViewBag.message = "Ocurrió un error al gestionar rutinas.";
                return View("GestionRutinas", rutina);
            }
        }


        [HttpPost]
        [Route("asignarEjercicios")]
        public async Task<IActionResult> asignarRutina(AsignacionDeEjercicio asignacion)
        {
            try
            {
                _logger?.LogInformation("Start RutinasController.asignarRutina ClienteId={ClienteId}", asignacion?.UsuarioID);
                var respuestaClientes = await manager.ObtenerUsuariosPorRol("cliente", "activo");
                ViewBag.clientes = respuestaClientes.payload;
                if (!ModelState.IsValid)
                {
                    return View("AsignacionEjercicios", asignacion);
                }

                var respuesta = await rutinasManager.asignarEjercicioARutina(asignacion);
                if (respuesta == null)
                {
                    ViewBag.message = "Error al asignar ejercicio a la rutina.";
                    return View("AsignacionEjercicios", asignacion);
                }
                if (respuesta.success == false)
                {
                    ViewBag.message = respuesta.message;
                    return View("AsignacionEjercicios",asignacion);
                }
                ViewBag.message = respuesta.message;
                return View("AsignacionEjercicios",asignacion);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: asignarRutina | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | UsuarioID: {asignacion?.UsuarioID} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error asignarRutina (RutinasController)");
                ViewBag.message = "Ocurrió un error al asignar ejercicios a la rutina.";
                return View("AsignacionEjercicios", asignacion);
            }
        }

        // NUEVO: Endpoint para obtener rutinas de cliente
        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("obtenerRutinasDeCliente")]
        public async Task<IActionResult> obtenerRutinasDeCliente([FromQuery] string UsuarioID)
        {
            try
            {
                _logger?.LogInformation("Start RutinasController.obtenerRutinasDeCliente UsuarioID={UsuarioID}", UsuarioID);
                var respuesta = await rutinasManager.obtenerRutinasDeCliente(UsuarioID);
                if (respuesta.success)
                {
                    return Ok(respuesta);
                }
                return BadRequest(respuesta);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerRutinasDeCliente | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | UsuarioID: {UsuarioID} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error obtenerRutinasDeCliente (RutinasController) UsuarioID={UsuarioID}", UsuarioID);
                var errorResp = ResponseManager.BuildResponse<List<Rutina>>(false, 500, "Error interno al obtener rutinas.", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
                return StatusCode(500, errorResp);
            }
        }
    }
}
