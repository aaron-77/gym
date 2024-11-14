
using Microsoft.AspNetCore.Mvc;
using DTO.Dtos;
using BL;

namespace GymFrontend.Controllers
{
    public class MedidasController : Controller
    {

        private UsersManager usersManager;
        private MedidasManager medidasManager;

        public MedidasController(UsersManager _usersManager,MedidasManager _medidasManager ){
            usersManager = _usersManager;
            medidasManager = _medidasManager;
        }
        [HttpPost]
        [Route("registrar")]
        public async Task<IActionResult> registrarMedida(DTO.Dtos.MedidaCorporal medidaCorporal)
        {

            
            ResponseHttpListadoUsers respuesta = await usersManager.obtenerUsuarios();
            List<ExistingUser> usuarios = respuesta.data;
            ViewBag.usuarios = usuarios;
            if (!ModelState.IsValid)
            {
                return View("../Users/EmpleadosMainPage", medidaCorporal);
            }
            if (medidaCorporal == null) {
                medidaCorporal = new DTO.Dtos.MedidaCorporal();
            }
            
            var response = await medidasManager.registrarMedida(medidaCorporal);
            ViewBag.message = response.message;
            return View("../Users/EmpleadosMainPage",medidaCorporal);
        }
    }
}
