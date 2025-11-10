using BL;
using BL.Utils;
using DTO.Dtos;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt; // Ensure this using directive is present

namespace GymFrontend.Controllers
{
    [Route("[controller]")]
    public class EjerciciosController : Controller
    {
        private EjerciciosManager ejerciciosManager;
        private JwtTokenGenerator jwtTokenGenerator;
        public EjerciciosController(EjerciciosManager _ejerciciosManager, JwtTokenGenerator _jwtTokenGenerator)
        {
            ejerciciosManager = _ejerciciosManager;
            jwtTokenGenerator = _jwtTokenGenerator;
        }

        [Authorize(Roles = "empleado")]
        [HttpGet]
        [Route("obtenerEjercicios")]
        public async Task<IActionResult> obtenerEjercicios()

        {
            
            var respuesta = await ejerciciosManager.obtenerEjercicios();
            if (respuesta.success)
            {
                return Ok(respuesta);
            }
            return BadRequest(respuesta);
        }

       
    }
} 