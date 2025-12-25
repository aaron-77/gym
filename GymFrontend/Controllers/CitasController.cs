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

        private UsersManager managerUsers;
        private CitasManager citasManager;

        public CitasController(UsersManager _managerUsers, CitasManager _citasManager)
        {
            managerUsers = _managerUsers;
            citasManager = _citasManager;
        }
        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("registrarCita")]
        public async Task<IActionResult> Index()
        {
            try
            {
                var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
                ViewBag.clientes = respuestaClientes.payload;
                return View("RegistrarCita", new Cita());
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: Index (CitasController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
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
                var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
                ViewBag.clientes = respuestaClientes.payload;
                cita.estado = "Agendada";
                if (!ModelState.IsValid)
                {
                    return View("RegistrarCita", cita);
                }

                DTOResponse<Cita> respuesta = await citasManager.registrarCita(cita); // MODIFICADO: Usar DTOResponse y await
                if (respuesta == null)
                {
                    ViewBag.message = "Error al registrar la cita.";
                    return View("RegistrarCita", cita);
                }
                if (respuesta.success == false) // MODIFICADO: Usar success
                {
                    ViewBag.message = respuesta.message;
                    return View("RegistrarCita", cita);
                }
                ViewBag.message = respuesta.message;
                return View("RegistrarCita", cita);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: registrarCita (CitasController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                ViewBag.message = "Ocurrió un error al registrar la cita.";
                return View("RegistrarCita", cita);
            }
        }



        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("modificarCita")]
        public async Task<IActionResult> modificarCita()
        {
            try
            {
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
                var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
                ViewBag.clientes = respuestaClientes.payload;
                if (!ModelState.IsValid)
                {
                    return View("ModificarCita", cita);
                }

                var respuestaCita = await citasManager.modificarCita(cita); // MODIFICADO: Usar await

                if (respuestaCita == null)
                {
                    ViewBag.message = "Error al modificar la cita.";
                    return View("ModificarCita", cita);
                }

                if (respuestaCita.success == false) // MODIFICADO: Usar success
                {
                    ViewBag.message = respuestaClientes.message;
                    return View("ModificarCita", cita);
                }
                ViewBag.message = respuestaCita.message;
                return View("ModificarCita", cita);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: modificarCitaPost (POST) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                ViewBag.message = "Ocurrió un error al modificar la cita.";
                return View("ModificarCita", cita);
            }
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("duracionCitasMedicionPage")]
        public async Task<IActionResult> renderVistaDuracion(DuracionCitasMedicion duracion) // MODIFICADO: async Task
        {
            try
            {
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
                ViewBag.message = "Error al obtener la configuración de duración de citas.";
                return View("DuracionCitasMedicion", new DuracionCitasMedicion());
            }
        }

        [HttpPost]
        [Route("duracionCitasMedicionPage")]
        public async Task<IActionResult> gestionarDuracionCitasMedicion(DuracionCitasMedicion duracionParam) // MODIFICADO: async Task
        {
            try
            {
                DTOResponse<DuracionCitasMedicion> responsePost = await citasManager.registrarDuracionCitasMedicion(duracionParam); // MODIFICADO: Usar DTOResponse y await
                DTOResponse<DuracionCitasMedicion> response = await citasManager.obtenerDuracionCitasMedicion(); // MODIFICADO: Usar DTOResponse y await
                DuracionCitasMedicion duracionExistente = response.payload; // MODIFICADO: Usar payload
                ViewBag.duracion = duracionExistente;
                if (responsePost == null) {
                    ViewBag.message = "Error al registrar la duracion de la cita";
                    return View("DuracionCitasMedicion", duracionParam);
                }
                if (duracionExistente == null)
                {
                    ViewBag.message = "No tienes configuracion de duracion de citas de medicion aun, registra una ";
                    return View("DuracionCitasMedicion", duracionParam);
                }
                duracionParam.Id = duracionExistente.Id;
                duracionParam.duracion = duracionExistente.duracion;
                duracionParam.frecuenciaNotificaciones = duracionExistente.frecuenciaNotificaciones;
                ViewBag.message = responsePost.message;
                return View("DuracionCitasMedicion", duracionParam);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: gestionarDuracionCitasMedicion | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                ViewBag.message = "Ocurrió un error al guardar la duración de las citas.";
                return View("DuracionCitasMedicion", duracionParam);
            }
        }

        // NUEVO: Endpoint para obtener la duración de la cita (int)
        [HttpGet]
        [Route("getDuracionCita")] // MODIFICADO: Quitar prefijo "api/"
        public async Task<IActionResult> GetDuracionCita()
        {
            try
            {
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
                var errorResp = ResponseManager.BuildResponse<int>(false, 500, "Error interno al obtener la duración.", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, 0);
                return StatusCode(500, errorResp);
            }
        }

        // NUEVO: Endpoint para obtener entrenadores disponibles
        [HttpGet]
        [Route("obtenerEntrenadoresDisponibles")] // MODIFICADO: Quitar prefijo "api/"
        public async Task<IActionResult> ObtenerEntrenadoresDisponibles([FromQuery] DateTime fechaReferencia)
        {
            try
            {
                Console.WriteLine($"ObtenerEntrenadoresDisponibles [Frontend] (CitasController) FECHA BUSCADA: {fechaReferencia}");
                var respuesta = await managerUsers.ObtenerEntrenadoresDisponibles(fechaReferencia);
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
                var errorResp = ResponseManager.BuildResponse<List<Cita>>(false, 500, "Error interno al obtener citas agendadas.", new List<ErrorModel> { new ErrorModel { message = ex.Message } }, null);
                return StatusCode(500, errorResp);
            }
        }

        
    }
}
