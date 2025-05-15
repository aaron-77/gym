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
using Microsoft.Data.SqlClient;

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

        /// <summary>
        /// Obtiene las clases según su estado (activo/inactivo)
        /// </summary>
        /// <param name="activa">Filtro de estado: 1=activa, 0=inactiva</param>
        /// <returns>Lista de clases filtradas por estado</returns>
        [HttpGet("obtenerClases")]
        public async Task<ActionResult<DTOResponse<List<DTOClaseSimple>>>> ObtenerClases([FromQuery] bool activa = false)
        {
            try
            {
                var clases = await _context.Clases
                    .Where(c => c.FkEstadoClase == (activa ? 1 : 2)) // Asumiendo 1=Activa, 2=Inactiva
                    .Select(c => new DTOClaseSimple
                    {
                        ClaseID = c.ClaseId,
                        NombreClase = c.NombreClase
                    })
                    .ToListAsync();

                return Ok(
                    ResponseManager.BuildResponse(
                        true,
                        200,
                        $"Clases {(activa ? "activas" : "inactivas")} obtenidas correctamente",
                        null,
                        clases
                    )
                );
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<List<DTOClaseSimple>>(
                        false,
                        500,
                        "Error al obtener las clases",
                        new List<ErrorModel>
                        {
                            new ErrorModel { propiedad = "NONE", message = ex.Message },
                        },
                        null
                    )
                );
            }
        }

        /// <summary>
        /// Obtiene los niveles de dificultad disponibles
        /// </summary>
        [HttpGet("nivelesDeDificultad")]
        public async Task<ActionResult<DTOResponse<List<VNivelesDeDificultad>>>> ObtenerNivelesDeDificultad()
        {
            try
            {
                // Usar la vista v_nivelesDeDificultad definida en el procedimiento almacenado
                var nivelesDificultad = await _context.VNivelesDeDificultads.FromSqlInterpolated($"SELECT * FROM v_nivelesDeDificultad")
                    .ToListAsync();

                return Ok(
                    ResponseManager.BuildResponse(
                        true,
                        200,
                        "Niveles de dificultad obtenidos correctamente",
                        null,
                        nivelesDificultad
                    )
                );
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<List<VNivelesDeDificultad>>(
                        false,
                        500,
                        "Error al obtener niveles de dificultad",
                        new List<ErrorModel>
                        {
                            new ErrorModel { propiedad = "NONE", message = ex.Message },
                        },
                        null
                    )
                );
            }
        }

        /// <summary>
        /// Obtiene los niveles de intensidad disponibles
        /// </summary>
        [HttpGet("nivelesDeIntensidad")]
        public async Task<ActionResult<DTOResponse<List<VNivelesDeIntensidad>>>> ObtenerNivelesDeIntensidad()
        {
            try
            {
                // Usar la vista v_nivelesDeIntensidad definida en el procedimiento almacenado
                var nivelesIntensidad = await _context.VNivelesDeIntensidads.FromSqlInterpolated($@"SELECT * FROM v_nivelesDeIntensidad")
                    .ToListAsync();

                return Ok(
                    ResponseManager.BuildResponse(
                        true,
                        200,
                        "Niveles de intensidad obtenidos correctamente",
                        null,
                        nivelesIntensidad
                    )
                );
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<List<VNivelesDeIntensidad>>(
                        false,
                        500,
                        "Error al obtener niveles de intensidad",
                        new List<ErrorModel>
                        {
                            new ErrorModel { propiedad = "NONE", message = ex.Message },
                        },
                        null
                    )
                );
            }
        }

        /// <summary>
        /// Registra una nueva clase
        /// </summary>
        [HttpPost("registrarClase")]
        public async Task<ActionResult<DTOResponse<int>>> RegistrarClase([FromBody] DTOClase  modelo)
        {
            try
            {
            
                // Ejecutar el procedimiento almacenado fn_obtenerClases
                var resultado = await _context.Clases.Where(c => c.NombreClase == modelo.NombreClase).FirstOrDefaultAsync();

                if (resultado != null)
                {
                    return BadRequest(
                        ResponseManager.BuildResponse<int>(
                            false,
                            400,
                            "Ya existe una clase con ese nombre",
                            new List<ErrorModel>
                            {
                                new ErrorModel { propiedad = "nombreClase", message = "Nombre de clase duplicado" },
                            },
                            0
                        )
                    );
                }

                // Crear el registro de clase
                var nuevaClase = new Clase
                {
                    NombreClase = modelo.NombreClase,
                    InstructorId = modelo.InstructorId,
                    Descripcion = modelo.Descripcion,
                    DuracionEnMinutos = modelo.DuracionEnMinutos,
                    FkIntensidad = modelo.FkIntensidad,
                    FkDificultad = modelo.FkDificultad,
                    TiempoDeDescansoEnMinutos = modelo.TiempoDeDescansoEnMinutos,
                    DuracionEnMinutosConDescansoIncluido = modelo.DuracionEnMinutosConDescansoIncluido,
                    Cupo = modelo.Cupo > 0 ? modelo.Cupo : 20, // Valor por defecto si no se especifica
                    FkEstadoClase = modelo.FkEstadoClase ?? 1 // Activa por defecto
                };

                _context.Clases.Add(nuevaClase);
                await _context.SaveChangesAsync();

                return Ok(
                    ResponseManager.BuildResponse(
                        true,
                        200,
                        "Clase registrada correctamente",
                        null,
                        nuevaClase.ClaseId
                    )
                );
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<int>(
                        false,
                        500,
                        "Error al registrar la clase",
                        new List<ErrorModel>
                        {
                            new ErrorModel { propiedad = "NONE", message = ex.Message },
                        },
                        0
                    )
                );
            }
        }

        /// <summary>
        /// Registra una programación de clase
        /// </summary>
        [HttpPost("registrarClaseProgramada")]
        public async Task<ActionResult<DTOResponse<int>>> RegistrarClaseProgramada([FromBody] DTODatosClaseProgramada modelo)
        {
            try
            {
                // Parámetros para el procedimiento almacenado
                var claseProgramadaParam = new SqlParameter("@datos", System.Data.SqlDbType.Structured);
                claseProgramadaParam.TypeName = "dbo.DatosClaseProgramada";
                claseProgramadaParam.Value = DataTableConverter.ConvertToDataTable<DTODatosClaseProgramada>(modelo);   
                // Ejecutar el procedimiento almacenado
                var idClaseProgramada = await _context.Database
                    .ExecuteSqlRawAsync(
                        "EXEC dbo.sp_registrarClaseProgramada @datos",
                        claseProgramadaParam
                    );

                return Ok(
                    ResponseManager.BuildResponse(
                        true,
                        200,
                        "Clase programada registrada correctamente",
                        null,
                        idClaseProgramada
                    )
                );
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<int>(
                        false,
                        500,
                        "Error al registrar la clase programada",
                        new List<ErrorModel>
                        {
                            new ErrorModel { propiedad = "NONE", message = ex.Message },
                        },
                        0
                    )
                );
            }
        }
    }
}
