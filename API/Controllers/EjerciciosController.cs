using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using BL.Utils;
using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    public class EjerciciosController : Controller
    {
        private JwtTokenGenerator jwtTokenGenerator;
        public EjerciciosController(JwtTokenGenerator _jwtTokenGenerator)
        {
            jwtTokenGenerator = _jwtTokenGenerator;
        }
        [Authorize(Roles = "empleado,cliente")]
        [HttpGet]
        [Route("api/consultarEjercicios")]
        public async Task<IActionResult> obtenerEjercicios()
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            
            var respuesta = new DTOResponse<List<DTO.Dtos.Ejercicio>>();
            try
            {
                var ejercicios = await db.ejercicioSP.FromSqlInterpolated($@"EXEC sp_consultarEjercicios").ToListAsync();
                respuesta = ResponseManager.BuildResponse(true, 200, "Consulta exitosa", null, ejercicios);
            }
            catch (Exception ex)
            {
                respuesta = ResponseManager.BuildResponse<List<DTO.Dtos.Ejercicio>>(false, 500, "Error al consultar los ejercicios", new List<ErrorModel>() { new ErrorModel() { propiedad = null, message = ex.Message } }, null);

            }
            return Ok(respuesta);
        }

    }
}
