using BL;
using BL.Utils;
using DTO.Dtos;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization; // Añadido para [Authorize]
using System.Security.Claims; // Añadido para Claims

namespace GymFrontend.Controllers
{
    public class CitasController : Controller
    {
        private readonly UsersManager managerUsers;
        private readonly CitasManager citasManager;
        private readonly Microsoft.Extensions.Logging.ILogger<CitasController> _logger;

        public CitasController(UsersManager _managerUsers, CitasManager _citasManager, Microsoft.Extensions.Logging.ILogger<CitasController> logger)
        {
            managerUsers = _managerUsers;
            citasManager = _citasManager;
            _logger = logger;
        }
        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("registrarCita")]
        public async Task<IActionResult> Index()
        {
            try
            {
                _logger?.LogInformation("Start CitasController.Index");
                var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
                ViewBag.clientes = respuestaClientes.payload;
                return View("RegistrarCita", new Cita());
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: Index (CitasController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error Index (CitasController)");
                ViewBag.message = "Error al cargar la página de registro de cita.";
                return View("RegistrarCita", new Cita());
            }

        }

        [HttpPost]
        [Route("registrarCita")]
        public async Task<IActionResult> registrarCita(Cita cita)
        {
            try
            {
                _logger?.LogInformation("Start CitasController.registrarCita");
                var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
                ViewBag.clientes = respuestaClientes.payload;
                cita.estado = "Agendada";
if (!ModelState.IsValid)
                {
                    return Json(new { success = false, message = "Datos inválidos. Por favor verifica los campos." });
                }

                DTOResponse<Cita> respuesta = await citasManager.registrarCita(cita);
                if (respuesta == null)
                {
                    return Json(new { success = false, message = "Error al registrar la cita." });
                }
                if (respuesta.success == false)
                {
                    return Json(new { success = false, message = respuesta.message });
                }
                return Json(new { success = true, message = respuesta.message });
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: registrarCita (CitasController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error registrarCita (CitasController)");
                return Json(new { success = false, message = "Ocurrió un error al registrar la cita." });
            }
        }


        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("modificarCita")]
        public async Task<IActionResult> modificarCita()
        {
            try
            {
                _logger?.LogInformation("Start CitasController.modificarCita (GET)");
                var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
                ViewBag.clientes = respuestaClientes.payload;
                ViewBag.message = "";
                if (respuestaClientes.success == false)
                {
                    ViewBag.message = respuestaClientes.message;
                }

                return View("ModificarCita");
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: modificarCita (GET) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error modificarCita (CitasController) GET");
                ViewBag.message = "Error al cargar la vista de modificación de cita.";
                return View("ModificarCita");
            }
        }

        [HttpPost]
        [Route("modificarCita")]
        public async Task<IActionResult> modificarCitaPost(CitaEdit cita)
        {
            try
            {
                _logger?.LogInformation("Start CitasController.modificarCitaPost");
                var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
                ViewBag.clientes = respuestaClientes.payload;
                if (!ModelState.IsValid)
                {
                    return Json(new { success = false, message = "Datos inválidos. Por favor verifica los campos." });
                }

                var respuestaCita = await citasManager.modificarCita(cita);

                if (respuestaCita == null)
                {
                    return BadRequest(ResponseManager.BuildResponse<CitaEdit>(false, 400, "Error al modificar la cita.", null, null));
                }

                if (respuestaCita.success == false)
                {
                    return BadRequest(respuestaCita);
                }
                return Ok(respuestaCita);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: modificarCitaPost (POST) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error modificarCitaPost (CitasController) POST");
                return Json(new { success = false, message = "Ocurrió un error al modificar la cita." });
            }
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("duracionCitasMedicionPage")]
        public async Task<IActionResult> renderVistaDuracion(DuracionCitasMedicion duracion) // MODIFICADO: async Task
        {
            try
            {
                _logger?.LogInformation("Start CitasController.renderVistaDuracion");
                DTOResponse<DuracionCitasMedicion> response = await citasManager.obtenerDuracionCitasMedicion(); // MODIFICADO: Usar DTOResponse y await
                DuracionCitasMedicion duracionExistente = response.payload; // MODIFICADO: Usar payload
                ViewBag.duracion = duracionExistente;
                if (duracionExistente == null)
                {
                    ViewBag.message = "No tienes configuracion de duracion de citas de medicion aun, registra una ";
                    return View("DuracionCitasMedicion", new DuracionCitasMedicion());
                }

                ViewBag.message = "";
                return View("DuracionCitasMedicion", new DuracionCitasMedicion() { Id = duracionExistente.Id, duracion = duracionExistente.duracion, frecuenciaNotificaciones = duracionExistente.frecuenciaNotificaciones });
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: renderVistaDuracion | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error renderVistaDuracion (CitasController)");
                ViewBag.message = "Error al obtener la configuración de duración de citas.";
                return View("DuracionCitasMedicion", new DuracionCitasMedicion());
            }
        }

        [HttpPost]
        [Route("duracionCitasMedicionPage")]
        public async Task<IActionResult> gestionarDuracionCitasMedicion(DuracionCitasMedicion duracionParam)
        {
            try
            {
                _logger?.LogInformation("Start CitasController.gestionarDuracionCitasMedicion");
                if (!ModelState.IsValid)
                {
                    return BadRequest(ResponseManager.BuildResponse<object>(false, 400, "Datos inválidos. Por favor verifica los campos.", null, null));
                }
                DTOResponse<DuracionCitasMedicion> responsePost = await citasManager.registrarDuracionCitasMedicion(duracionParam);
                DTOResponse<DuracionCitasMedicion> response = await citasManager.obtenerDuracionCitasMedicion();
                DuracionCitasMedicion duracionExistente = response.payload;
                ViewBag.duracion = duracionExistente;
                if (responsePost == null) {
                    return BadRequest(ResponseManager.BuildResponse<object>(false, 400, "Error al registrar la duracion de la cita", null, null));
                }
                if (duracionExistente == null)
                {
                    return BadRequest(ResponseManager.BuildResponse<object>(false, 400, "No tienes configuracion de duracion de citas de medicion aun, registra una", null, null));
                }
                duracionParam.Id = duracionExistente.Id;
                duracionParam.duracion = duracionExistente.duracion;
                duracionParam.frecuenciaNotificaciones = duracionExistente.frecuenciaNotificaciones;
                return Ok(ResponseManager.BuildResponse<DuracionCitasMedicion>(true, 200, responsePost.message, null, duracionExistente));
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: gestionarDuracionCitasMedicion | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error gestionarDuracionCitasMedicion (CitasController)");
                return BadRequest(ResponseManager.BuildResponse<object>(false, 500, "Ocurrió un error al guardar la duración de las citas.", null, null));
            }
        }

        // NUEVO: Endpoint para obtener la duración de la cita (int)
        [HttpGet]
        [Route("getDuracionCita")] // MODIFICADO: Quitar prefijo "api/"
        public async Task<IActionResult> GetDuracionCita()
        {
            try
            {
                _logger?.LogInformation("Start CitasController.GetDuracionCita");
                var respuesta = await citasManager.obtenerDuracionCita();
                if (respuesta.success)
                {
                    return Ok(respuesta);
                }
                return BadRequest(respuesta);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: GetDuracionCita | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error GetDuracionCita (CitasController)");
                var errorResp = ResponseManager.BuildResponse<int>(false, 500, "Error interno al obtener la duración.", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, 0);
                return StatusCode(500, errorResp);
            }
        }

        // NUEVO: Endpoint para obtener entrenadores disponibles
        [HttpGet]
        [Route("obtenerEntrenadoresDisponibles")] // MODIFICADO: Quitar prefijo "api/"
        public async Task<IActionResult> ObtenerEntrenadoresDisponibles([FromQuery] string fechaReferencia)
        {
            try
            {
                _logger?.LogInformation("Start CitasController.ObtenerEntrenadoresDisponibles fechaReferencia={Fecha}", fechaReferencia);
                // Parse incoming date string preserving local time
                DateTime parsedFecha;
                if (!DateTime.TryParse(fechaReferencia, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.AssumeLocal, out parsedFecha))
                {
                    parsedFecha = DateTime.Parse(fechaReferencia, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.AssumeLocal);
                }
                _logger?.LogInformation("ObtenerEntrenadoresDisponibles [Frontend] FECHA BUSCADA: {Fecha}", parsedFecha);
                var respuesta = await managerUsers.ObtenerEntrenadoresDisponibles(parsedFecha);
                if (respuesta.success)
                {
                    return Ok(respuesta);
                }
                return BadRequest(respuesta);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerEntrenadoresDisponibles | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | FechaReferencia: {fechaReferencia} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error ObtenerEntrenadoresDisponibles (CitasController) fechaReferencia={Fecha}", fechaReferencia);
                var errorResp = ResponseManager.BuildResponse<List<QueryUser>>(false, 500, "Error interno al obtener entrenadores.", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
                return StatusCode(500, errorResp);
            }
        }

        [HttpGet]
        [Route("obtenerCitasAgendadasDelCliente")] // MODIFICADO: Quitar prefijo "api/"
        public async Task<IActionResult> ObtenerCitasAgendadasDelCliente([FromQuery] string idUsuario)
        {
            try
            {
                _logger?.LogInformation("Start CitasController.ObtenerCitasAgendadasDelCliente idUsuario={Id}", idUsuario);
                var respuesta = await citasManager.obtenerCitasAgendadas(idUsuario);
                if (respuesta.success)
                {
                    return Ok(respuesta);
                }
                return BadRequest(respuesta);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ObtenerCitasAgendadasDelCliente | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | IdUsuario: {idUsuario} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                _logger?.LogError(ex, "Error ObtenerCitasAgendadasDelCliente (CitasController) IdUsuario={Id}", idUsuario);
                var errorResp = ResponseManager.BuildResponse<List<Cita>>(false, 500, "Error interno al obtener citas agendadas.", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
                return StatusCode(500, errorResp);
            }
        }

        
    }
}
