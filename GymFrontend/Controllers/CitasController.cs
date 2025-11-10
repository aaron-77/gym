using BL;
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
            var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
            ViewBag.clientes = respuestaClientes.payload;
            // NUEVO: Obtener entrenadores disponibles al cargar la página de registro de cita
            //var respuestaEntrenadores = await managerUsers.ObtenerUsuariosPorRol("empleado", "activo");
            //ViewBag.entrenadores = respuestaEntrenadores.payload;
            return View("RegistrarCita", new Cita());

        }

        [HttpPost]
        [Route("registrarCita")]
        public async Task<IActionResult> registrarCita(Cita cita)
        {

            var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
            ViewBag.clientes = respuestaClientes.payload;
            cita.estado = "Agendada";
            if (!ModelState.IsValid)
            {
                return View("RegistrarCita", cita);
            }


            DTOResponse<Cita> respuesta = await citasManager.registrarCita(cita); // MODIFICADO: Usar DTOResponse y await
            if (respuesta.success == false) // MODIFICADO: Usar success
            {
                ViewBag.message = respuesta.message;
                return View("RegistrarCita", cita);
            }
            ViewBag.message = respuesta.message;
            return View("RegistrarCita", cita);
        }



        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("modificarCita")]
        public async Task<IActionResult> modificarCita()
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

        [HttpPost]
        [Route("modificarCita")]
        public async Task<IActionResult> modificarCitaPost(CitaEdit cita)
        {

            var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
            ViewBag.clientes = respuestaClientes.payload;
            if (!ModelState.IsValid)
            {
                return View("ModificarCita", cita);
            }



            var respuestaCita = await citasManager.modificarCita(cita); // MODIFICADO: Usar await

            if (respuestaCita.success == false) // MODIFICADO: Usar success
            {
                ViewBag.message = respuestaClientes.message;
                return View("ModificarCita", cita);
            }
            ViewBag.message = respuestaCita.message;
            return View("ModificarCita", cita);
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("duracionCitasMedicionPage")]
        public async Task<IActionResult> renderVistaDuracion(DuracionCitasMedicion duracion) // MODIFICADO: async Task
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


        [HttpPost]
        [Route("duracionCitasMedicionPage")]
        public async Task<IActionResult> gestionarDuracionCitasMedicion(DuracionCitasMedicion duracionParam) // MODIFICADO: async Task
        {

            DTOResponse<DuracionCitasMedicion> responsePost = await citasManager.registrarDuracionCitasMedicion(duracionParam); // MODIFICADO: Usar DTOResponse y await
            DTOResponse<DuracionCitasMedicion> response = await citasManager.obtenerDuracionCitasMedicion(); // MODIFICADO: Usar DTOResponse y await
            DuracionCitasMedicion duracionExistente = response.payload; // MODIFICADO: Usar payload
            ViewBag.duracion = duracionExistente;
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

        // NUEVO: Endpoint para obtener la duración de la cita (int)
        [HttpGet]
        [Route("getDuracionCita")] // MODIFICADO: Quitar prefijo "api/"
        public async Task<IActionResult> GetDuracionCita()
        {
            var respuesta = await citasManager.obtenerDuracionCita();
            if (respuesta.success)
            {
                return Ok(respuesta);
            }
            return BadRequest(respuesta);
        }

        // NUEVO: Endpoint para obtener entrenadores disponibles
        [HttpGet]
        [Route("obtenerEntrenadoresDisponibles")] // MODIFICADO: Quitar prefijo "api/"
        public async Task<IActionResult> ObtenerEntrenadoresDisponibles([FromQuery] DateTime fechaReferencia)
        {
            var respuesta = await managerUsers.ObtenerEntrenadoresDisponibles(fechaReferencia);
            if (respuesta.success)
            {
                return Ok(respuesta);
            }
            return BadRequest(respuesta);
        }

        [HttpGet]
        [Route("obtenerCitasAgendadasDelCliente")] // MODIFICADO: Quitar prefijo "api/"
        public async Task<IActionResult> ObtenerCitasAgendadasDelCliente([FromQuery] string idUsuario)
        {
            var respuesta = await citasManager.obtenerCitasAgendadas(idUsuario);
            if (respuesta.success)
            {
                return Ok(respuesta);
            }
            return BadRequest(respuesta);
        }

        
    }
}
