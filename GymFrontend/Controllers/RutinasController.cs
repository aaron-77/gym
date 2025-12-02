using BL;
using BL.Utils;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace GymFrontend.Controllers
{
    public class RutinasController:Controller
    {
        private UsersManager manager;
        private RutinasManager rutinasManager;
        private EjerciciosManager ejerciciosManager;
        private JwtTokenGenerator jwtTokenGenerator;

        public RutinasController(UsersManager _manager,
                                RutinasManager _rutinasManager,
                                EjerciciosManager _ejerciciosManager,
                                JwtTokenGenerator _jwtTokenGenerator)
        {
            manager = _manager;
            rutinasManager = _rutinasManager;
            ejerciciosManager = _ejerciciosManager;
            jwtTokenGenerator = _jwtTokenGenerator;
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("gestionRutinas")]
        public async Task<IActionResult> Index()
        {
            string pageToRender = "GestionRutinas";


            var respuestaClientes = await manager.ObtenerUsuariosPorRol("cliente", "activo");
            var respuestaEntrenadores = await manager.ObtenerUsuariosPorRol("empleado", "activo");
            ViewBag.clientes = respuestaClientes.payload;
            ViewBag.entrenadores = respuestaEntrenadores.payload;
            return View("GestionRutinas", new Rutina());

        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("asignarEjercicios")]
        public async Task<IActionResult> asignarEjercicios([FromQuery] string usuarioID = null)
        {


            /*var token = Request.Cookies["AuthToken"];
            var claims = jwtTokenGenerator.ValidateIdToken(token);
            var UsuarioId = claims.FirstOrDefault(c => 
                     c.Key == ClaimTypes.NameIdentifier || c.Key == JwtRegisteredClaimNames.Sub
            ).Value;
            */
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
           
    [HttpPost]
        [Route("gestionRutinas")]
        public async Task<IActionResult> gestionarRutinas(Rutina rutina)
        {
            rutina.FechaCreacion = DateTime.Now;

            var respuestaClientes = await manager.ObtenerUsuariosPorRol("cliente", "activo");
            var respuestaEntrenadores = await manager.ObtenerUsuariosPorRol("empleado", "activo");
            ViewBag.clientes = respuestaClientes.payload;
            ViewBag.entrenadores = respuestaEntrenadores.payload;
            if (!ModelState.IsValid)
            {
                return View("GestionRutinas", rutina);
            }
            
            
            HttpResponseRutina respuesta = rutinasManager.registrarRutina(rutina).Result;
            if (respuesta.ok == false)
            {
                ViewBag.message = respuesta.message;
                return View("GestionRutinas");
            }
            ViewBag.message = respuesta.message;
            return View("GestionRutinas");
        }


        [HttpPost]
        [Route("asignarEjercicios")]
        public async Task<IActionResult> asignarRutina(AsignacionDeEjercicio asignacion)
        {

            var respuestaClientes = await manager.ObtenerUsuariosPorRol("cliente", "activo");
            ViewBag.clientes = respuestaClientes.payload;
            if (!ModelState.IsValid)
            {
                return View("AsignacionEjercicios", asignacion);
            }

            var respuesta = await rutinasManager.asignarEjercicioARutina(asignacion);
            if (respuesta.success == false)
            {
                ViewBag.message = respuesta.message;
                return View("AsignacionEjercicios",asignacion);
            }
            ViewBag.message = respuesta.message;
            return View("AsignacionEjercicios",asignacion);
        }

        // NUEVO: Endpoint para obtener rutinas de cliente
        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("obtenerRutinasDeCliente")]
        public async Task<IActionResult> obtenerRutinasDeCliente([FromQuery] string UsuarioID)
        {
            var respuesta = await rutinasManager.obtenerRutinasDeCliente(UsuarioID);
            if (respuesta != null && respuesta.success)
            {
                return Ok(respuesta);
            }
            respuesta = ResponseManager.BuildResponse<List<Rutina>>(false, 400, "No se pudieron obtener las rutinas del cliente.", null, new List<Rutina>());
            return BadRequest(respuesta);
        }
    }
}
