using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    public class EntrenadoresController : Controller
    {
        [Authorize(Roles = "empleado,cliente")]
        [HttpGet]
        [Route("api/obtenerEntrenadoresDisponibles")]
        public async Task<IActionResult> getUsuariosPorRol([FromQuery] DateTime fechaInicio)
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            HttpResponseListadoQueryUsers respuesta = new HttpResponseListadoQueryUsers();
            List<QueryUser> entrenadores = await db.userSP.FromSqlInterpolated($@"EXEC dbo.sp_obtenerEntrenadoresDisponibles @fechaReferencia={fechaInicio}").ToListAsync();
            respuesta.ok = true;
            respuesta.message = "consulta exitosa";
            respuesta.errors = null;
            respuesta.data = entrenadores;
            return Ok(respuesta);
        }
    }
}
