using BL;
using DTO.Dtos;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GymFrontend.Controllers
{
    public class RutinasController:Controller
    {
        private UsersManager manager;
        private RutinasManager rutinasManager;
        private EjerciciosManager ejerciciosManager;

        public RutinasController(UsersManager _manager,
                                RutinasManager _rutinasManager,
                                EjerciciosManager _ejerciciosManager  )
        {
            manager = _manager;
            rutinasManager = _rutinasManager;
            ejerciciosManager = _ejerciciosManager;
        }
        [HttpGet]
        [Route("gestionRutinas")]
        public IActionResult Index()
        {
            string pageToRender = "GestionRutinas";
           
            
            HttpResponseListadoQueryUsers respuestaClientes = manager.obtenerUsuariosPorRol("cliente", "activo").Result;
            HttpResponseListadoQueryUsers respuestaEntrenadores = manager.obtenerUsuariosPorRol("empleado", "activo").Result;
            ViewBag.clientes = respuestaClientes.data;
            ViewBag.entrenadores = respuestaEntrenadores.data;
            return View("GestionRutinas", new   Rutina());
            
        }
        [HttpGet]
        [Route("asignarEjercicios")]
        public IActionResult asignarEjercicios([FromQuery] int UsuarioId)
        {
            
            HttpResponseListadoQueryUsers respuestaClientes = manager.obtenerUsuariosPorRol("cliente", "activo").Result; ;
            ViewBag.clientes = respuestaClientes.data;
            if (UsuarioId > 0) {
                HttpResponseListadoRutinas respuestaRutinas = rutinasManager.obtenerRutinasDeUsuario(UsuarioId).Result;
                HttpResponseListadoEjercicios respuestaEjercicios = ejerciciosManager.obtenerEjercicios().Result;
                ViewBag.rutinas = respuestaRutinas.data;
                ViewBag.ejercicios = respuestaEjercicios.data;
            }
            return View("AsignacionEjercicios.cshtml");
        }
           
    [HttpPost]
        [Route("gestionRutinas")]
        public IActionResult gestionarRutinas(Rutina rutina)
        {
            rutina.FechaCreacion = DateTime.Now;
            
            HttpResponseListadoQueryUsers respuestaClientes = manager.obtenerUsuariosPorRol("cliente", "activo").Result;
            HttpResponseListadoQueryUsers respuestaEntrenadores = manager.obtenerUsuariosPorRol("empleado", "activo").Result;
            ViewBag.clientes = respuestaClientes.data;
            ViewBag.entrenadores = respuestaEntrenadores.data;
            if (!ModelState.IsValid)
            {
                return View("GestionRutinas", rutina);
            }
            
            
            HttpResponseRutina respuesta = rutinasManager.registrarRutina(rutina).Result;
            if (respuesta.ok == false)
            {
                ViewBag.message = respuesta.message;
                return View("GestionRutinas.cshtml");
            }
            ViewBag.message = respuesta.message;
            return View("GestionRutinas.cshtml");
        }


        [HttpPost]
        [Route("asignarEjercicios")]
        public IActionResult asignarRutina(AsignacionDeEjercicio asignacion)
        {
            
            HttpResponseListadoQueryUsers respuestaClientes = manager.obtenerUsuariosPorRol("cliente", "activo").Result;
            ViewBag.clientes = respuestaClientes.data;
            if (!ModelState.IsValid)
            {
                return View("AsignacionEjercicios", asignacion);
            }
            
            HttpResponseAsignacion respuesta = rutinasManager.asignarEjercicioARutina(asignacion).Result;
            if (respuesta.ok == false)
            {
                ViewBag.message = respuesta.message;
                return View("AsignacionEjercicios",asignacion);
            }
            ViewBag.message = respuesta.message;
            return View("AsignacionEjercicios",asignacion);
        }
    }
}
