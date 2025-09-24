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
        public async Task<IActionResult> ObtenerEntrenadoresDisponibles([FromQuery] DateTime fechaInicio) // MODIFICADO: Renombrado el método y tipo de retorno para usar DTOResponse
        {
            DTOResponse<List<QueryUser>> respuesta; // NUEVO: Declarar DTOResponse

            try
            {
                FitnessCenterDbContext db = new FitnessCenterDbContext();
                // HttpResponseListadoQueryUsers respuesta = new HttpResponseListadoQueryUsers(); // ELIMINADO
                List<QueryUser> entrenadores = await db.userSP.FromSqlInterpolated($@"EXEC [FitnessCenterDB].[dbo].sp_obtenerEntrenadoresDisponibles @fechaReferencia={fechaInicio}").ToListAsync();
                
                respuesta = BL.Utils.ResponseManager.BuildResponse(
                    success: true,
                    httpCode: 200,
                    message: "Consulta exitosa",
                    errors: null,
                    payload: entrenadores
                ); // MODIFICADO: Usar ResponseManager
                return Ok(respuesta);

            }
            catch (System.Exception ex) // MODIFICADO: Capturar la excepción para registrarla
            {
                respuesta = BL.Utils.ResponseManager.BuildResponse<List<QueryUser>>(
                    success: false,
                    httpCode: 500,
                    message: "Error al obtener entrenadores disponibles",
                    errors: new List<ErrorModel> { new ErrorModel { propiedad = null, message = ex.Message } },
                    payload: null
                ); // MODIFICADO: Usar ResponseManager para el error
                return StatusCode(500, respuesta); // NUEVO: Devolver StatusCode 500 para errores del servidor
            }

        }
    }
}
