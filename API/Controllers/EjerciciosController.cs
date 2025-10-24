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
        private readonly FitnessCenterDbContext _db;

        public EjerciciosController(JwtTokenGenerator _jwtTokenGenerator, FitnessCenterDbContext db)
        {
            jwtTokenGenerator = _jwtTokenGenerator;
            _db = db;
        }
        [Authorize(Roles = "empleado,cliente")]
        [HttpGet]
        [Route("api/consultarEjercicios")]
        public async Task<IActionResult> obtenerEjercicios()
        {
            var respuesta = new DTOResponse<List<DTO.Dtos.Ejercicio>>();
            try
            {
                var ejercicios = await _db.ejercicioSP.FromSqlInterpolated($@"EXEC sp_consultarEjercicios").ToListAsync();
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
