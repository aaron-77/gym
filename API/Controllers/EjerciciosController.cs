using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    public class EjerciciosController : Controller
    {
        [HttpGet]
        [Route("api/consultarEjercicios")]
        public async Task<IActionResult> obtenerEjercicios()
        {
            FitnessCenterDbContext db = new FitnessCenterDbContext();
            HttpResponseListadoEjercicios respuesta = new HttpResponseListadoEjercicios();
            try
            {
                respuesta.data = await db.ejercicioSP.FromSqlInterpolated($@"EXEC sp_consultarEjercicios").ToListAsync();
                respuesta.ok = true;
                respuesta.errors = null;
                respuesta.message = "Consulta exitosa";
            }
            catch (Exception ex)
            {
                respuesta.ok = false;
                respuesta.data = null;
                respuesta.errors.Add(new ErrorModel() { propiedad = null, message = ex.Message });
                respuesta.message = "Error al consultar los ejericios";

            }
            return Ok(respuesta);
        }

    }
}
