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
            try
            {
                var respuesta = await ejerciciosManager.obtenerEjercicios();
                if (respuesta != null && respuesta.success)
                {
                    return Ok(respuesta);
                }
                return BadRequest(respuesta);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerEjercicios | " +
                    $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                    $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                    $"Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
                
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<List<Ejercicio>>(
                        false,
                        500,
                        "Error interno del servidor al obtener ejercicios.",
                        new List<ErrorModel> { new ErrorModel { message = ex.Message } },
                        null
                    )
                );
            }
        }

       
    }
} 