using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;

using System.Threading.Tasks;
using BL.Utils;
using DataAccess.EntityFramework;
using DTO.Dtos;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ClasesController : ControllerBase
    {
        private readonly FitnessCenterDbContext _context;

        public ClasesController(FitnessCenterDbContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Consulta los detalles de una clase específica
        /// </summary>
        /// <param name="idClase">ID de la clase a consultar</param>
        /// <returns>Objeto con los detalles de la clase</returns>
        [HttpGet("detallesDeClase")]
        public async Task<ActionResult<DTOResponse<DetalleDeClase>>> ConsultarDetallesDeClase(
            [FromQuery] int idClase
        )
        {
            try
            {
                // Ejecutar la función SQL para obtener los detalles de la clase
                var detalleRaw = await _context
                    .detalleDeClaseRawSP.FromSqlInterpolated(
                        $"SELECT * FROM dbo.ObtenerDetalleDeClase({idClase})"
                    )
                    .FirstOrDefaultAsync();

                if (detalleRaw == null)
                {
                    ErrorModel error = new ErrorModel();
                    error.propiedad = "idClase";
                    error.message = "Clase no encontrada";
                    List<ErrorModel> errors = new List<ErrorModel>();
                    errors.Add(error);
                    return NotFound(
                        ResponseManager.BuildResponse<DetalleDeClase>(
                            false,
                            404,
                            $"No se encontró la clase con ID {idClase}",
                            errors,
                            null
                        )
                    );
                }
                var deserializeOptions = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                // Mapear los resultados al modelo DetalleDeClase
                    var detalle = new DetalleDeClase
                    {
                        Duracion = detalleRaw.Duracion,
                        NivelDeIntensidad = detalleRaw.NivelDeIntensidad,
                        NivelDeDificultad = detalleRaw.NivelDeDificultad,
                        DescripcionDeLaClase = detalleRaw.DescripcionDeLaClase,
                        BeneficiosDeLaClase = !string.IsNullOrEmpty(detalleRaw.BeneficiosDeLaClase) 
                            ? JsonSerializer.Deserialize<List<DTO.Dtos.DTOBeneficiosDeClase>>(detalleRaw.BeneficiosDeLaClase,deserializeOptions) 
                            : new List<DTO.Dtos.DTOBeneficiosDeClase>(),
                        EstructuraDeLaClase = !string.IsNullOrEmpty(detalleRaw.EstructuraDeLaClase)
                            ? JsonSerializer.Deserialize<List<DTO.Dtos.DTOEstructuraDeClase>>(detalleRaw.EstructuraDeLaClase,deserializeOptions)
                            : new List<DTO.Dtos.DTOEstructuraDeClase>(),
                        EjerciciosDeClase = !string.IsNullOrEmpty(detalleRaw.EjerciciosDeClase)
                            ? JsonSerializer.Deserialize<List<EjercicioPreview>>(detalleRaw.EjerciciosDeClase,deserializeOptions)
                            : new List<EjercicioPreview>(),
                        Consejos = !string.IsNullOrEmpty(detalleRaw.Consejos)
                            ? JsonSerializer.Deserialize<List<DTOConsejoDeClase>>(detalleRaw.Consejos)?.FirstOrDefault()
                            : null,
                        EquipamientoRecomendado = !string.IsNullOrEmpty(detalleRaw.EquipamientoRecomendado)
                            ? JsonSerializer.Deserialize<List<DTO.Dtos.DTOEquipo>>(detalleRaw.EquipamientoRecomendado,deserializeOptions)
                            : new List<DTO.Dtos.DTOEquipo>(),
                        HorariosProgramados = !string.IsNullOrEmpty(detalleRaw.HorariosProgramados)
                            ? JsonSerializer.Deserialize<List<ClaseProgramada>>(detalleRaw.HorariosProgramados,deserializeOptions)
                            : new List<ClaseProgramada>(),
                        imagenesDeClase =  !string.IsNullOrEmpty(detalleRaw.imagenesDeClase)
                            ? JsonSerializer.Deserialize<List<DTOImagenesDeClase>>(detalleRaw.imagenesDeClase,deserializeOptions)?.FirstOrDefault():new DTOImagenesDeClase()
                    };

                // Construir y devolver la respuesta
                return Ok(
                    ResponseManager.BuildResponse(
                        true,
                        200,
                        "Detalles de clase obtenidos correctamente",
                        null,
                        detalle
                    )
                );
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.StackTrace);
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<DetalleDeClase>(
                        false,
                        500,
                        "Error al consultar los detalles de la clase",
                        new List<ErrorModel>
                        {
                            new ErrorModel { propiedad = "NONE", message = ex.Message },
                        },
                        null
                    )
                );
            }
        }
    }
}
