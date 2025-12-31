using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using BL.Utils;
using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace API.Controllers
{
    public class EjerciciosController : Controller
    {
        private JwtTokenGenerator jwtTokenGenerator;
        private readonly FitnessCenterDbContext _db;
        private readonly ILogger<EjerciciosController> _logger;

        public EjerciciosController(JwtTokenGenerator _jwtTokenGenerator, FitnessCenterDbContext db, ILogger<EjerciciosController> logger)
        {
            jwtTokenGenerator = _jwtTokenGenerator;
            _db = db;
            _logger = logger;
        }
        [Authorize(Roles = "empleado,cliente")]
        [HttpGet]
        [Route("api/consultarEjercicios")]
        public async Task<IActionResult> obtenerEjercicios()
        {
            var respuesta = new DTOResponse<List<DTO.Dtos.Ejercicio>>();
            try
            {
                _logger.LogInformation("Start obtenerEjercicios");
                var ejercicios = await _db.ejercicioSP.FromSqlInterpolated($@"EXEC sp_consultarEjercicios").ToListAsync();
                respuesta = ResponseManager.BuildResponse(true, 200, "Consulta exitosa", null, ejercicios);
                _logger.LogInformation("Finished obtenerEjercicios returned {Count}", ejercicios?.Count);
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: obtenerEjercicios (EjerciciosController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                _logger.LogError(ex, logMessage);

                respuesta = ResponseManager.BuildResponse<List<DTO.Dtos.Ejercicio>>(false, 500, "Error al consultar los ejercicios", new List<ErrorModel>() { new ErrorModel() { propiedad = null, message = ex.Message } }, null);

            }
            return Ok(respuesta);
        }

    }
}
