using BL;
using DTO.Dtos;
using Microsoft.AspNetCore.Mvc;

namespace GymFrontend.Controllers
{
    public class CitasController : Controller
    {   
        private UsersManager managerUsers;
        private CitasManager citasManager;

        public CitasController(UsersManager _managerUsers,CitasManager _citasManager ){
            managerUsers = _managerUsers;
            citasManager = _citasManager;
        }
        [HttpGet]
        [Route("registrarCita")]
        public async Task<IActionResult> Index()
        {
            var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
            ViewBag.clientes = respuestaClientes.payload;
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
            
            
            HttpResponseCita respuesta = citasManager.registrarCita(cita).Result;
                        if (respuesta.ok == false)
            {
                ViewBag.message = respuesta.message;
                return View("RegistrarCita",cita);
            }
            ViewBag.message = respuesta.message;
            return View("RegistrarCita",cita);
        }


        [HttpGet]
        [Route("modificarCita")]
        public async Task<IActionResult> modificarCita(CitaEdit cita)
        {

            var respuestaClientes = await managerUsers.ObtenerUsuariosPorRol("cliente", "activo");
            ViewBag.clientes = respuestaClientes.payload;
            if (respuestaClientes.success == false)
            {
            ViewBag.message = respuestaClientes.message;
            return View("ModificarCita", cita);
            }
            ViewBag.message = "";
            return View("ModificarCita", new CitaEdit());
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

            
            
            var respuestaCita = citasManager.modificarCita(cita).Result;
            
            if (respuestaCita.ok == false)
            {
                ViewBag.message = respuestaClientes.message;
                return View("ModificarCita", cita);
            }
            ViewBag.message = respuestaCita.message;
            return View("ModificarCita", cita);
        }

        [HttpGet]
        [Route("duracionCitasMedicionPage")]
        public IActionResult renderVistaDuracion(DuracionCitasMedicion duracion)
        {
            
            HttpResponseDuracionCitasMedicion response = citasManager.obtenerDuracionCitasMedicion().Result;
            DuracionCitasMedicion duracionExistente = response.data;
            ViewBag.duracion = duracionExistente;
            if (duracionExistente == null) {
                ViewBag.message = "No tienes configuracion de duracion de citas de medicion aun, registra una ";
                return View("DuracionCitasMedicion", new DuracionCitasMedicion());
            }
           
            ViewBag.message = "";
            return View("DuracionCitasMedicion", new DuracionCitasMedicion() {Id= duracionExistente.Id,duracion=duracionExistente.duracion,frecuenciaNotificaciones = duracionExistente.frecuenciaNotificaciones });
        }


        [HttpPost]
        [Route("duracionCitasMedicionPage")]
        public IActionResult gestionarDuracionCitasMedicion(DuracionCitasMedicion duracionParam)
        {
            
            HttpResponseDuracionCitasMedicion responsePost = citasManager.registrarDuracionCitasMedicion(duracionParam).Result;
            HttpResponseDuracionCitasMedicion response = citasManager.obtenerDuracionCitasMedicion().Result;
            DuracionCitasMedicion duracionExistente = response.data;
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
    }
}
