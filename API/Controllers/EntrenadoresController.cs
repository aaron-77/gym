using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    public class EntrenadoresController : Controller
    {
        private readonly FitnessCenterDbContext _db;
        private readonly Microsoft.Extensions.Logging.ILogger<EntrenadoresController> _logger;

        public EntrenadoresController(FitnessCenterDbContext db, Microsoft.Extensions.Logging.ILogger<EntrenadoresController> logger)
        {
            _db = db;
            _logger = logger;
        }

        [Authorize(Roles = "empleado,cliente")]
        [HttpGet]
        [Route("api/obtenerEntrenadoresDisponibles")]
        public async Task<IActionResult> ObtenerEntrenadoresDisponibles([FromQuery] string fechaInicio) // Receive string to preserve local time passed from frontend
        {
            // Validación de formato: null, empty o no parseable
            if (string.IsNullOrWhiteSpace(fechaInicio) || !DateTime.TryParse(fechaInicio, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.AssumeLocal, out DateTime parsedFecha))
            {
                var badResponse = BL.Utils.ResponseManager.BuildResponse<List<QueryUser>>(
                    success: false,
                    httpCode: 400,
                    message: "La fecha tiene un formato incorrecto",
                    errors: null,
                    payload: null
                );
                return BadRequest(badResponse);
            }

            // Validación de fecha pasada
            if (parsedFecha.Date < DateTime.Now.Date)
            {
                var badResponse = BL.Utils.ResponseManager.BuildResponse<List<QueryUser>>(
                    success: false,
                    httpCode: 400,
                    message: "La fecha no puede ser anterior a la fecha actual",
                    errors: null,
                    payload: null
                );
                return BadRequest(badResponse);
            }

            DTOResponse<List<QueryUser>> respuesta; // NUEVO: Declarar DTOResponse

            try
            {
                _logger.LogInformation("Start ObtenerEntrenadoresDisponibles fechaInicio={Fecha}", fechaInicio);
                // Call stored procedure with parsed local date
                List<QueryUser> entrenadores = await _db.userSP.FromSqlInterpolated($@"EXEC [FitnessCenterDB].[dbo].sp_obtenerEntrenadoresDisponibles @fechaReferencia={parsedFecha}").ToListAsync();
                _logger.LogInformation("BUSCANDO ENTRENADORES DISPONIBLES EN: {Fecha}", parsedFecha);
                respuesta = BL.Utils.ResponseManager.BuildResponse(
                    success: true,
                    httpCode: 200,
                    message: "Consulta exitosa",
                    errors: null,
                    payload: entrenadores
                ); // MODIFICADO: Usar ResponseManager
                _logger.LogInformation("Finished ObtenerEntrenadoresDisponibles returned {Count} trainers", entrenadores.Count);
                return Ok(respuesta);

            }
            catch (System.Exception ex) // MODIFICADO: Capturar la excepción para registrarla
            {
                string logMessage = $"[ERROR] Método: ObtenerEntrenadoresDisponibles (EntrenadoresController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | FechaInicio: {fechaInicio} | Stack Trace: {ex.StackTrace}";
                _logger.LogError(ex, logMessage);

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
