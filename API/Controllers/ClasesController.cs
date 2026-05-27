using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using System.Threading.Tasks;
using API.Hubs;
using API.Services;
using BL;
using BL.Utils;
using DataAccess.EntityFramework;
using DataAccess.Infraestructure;
using DataAccess.Identity;
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ClasesController : ControllerBase
    {
        private readonly FitnessCenterDbContext _context;
        private readonly IHttpCustomClient _httpCustomClient;
        private readonly UserRoleService _userRoleService;
        private readonly ServicioActualizacionesDeHorariosRealTime _servicioActualizaciones;
        private readonly UserManager<ApplicationUser> _userManager;

        private readonly IClasesService _clasesService;
        private readonly ILogger<ClasesController> _logger;

        public ClasesController(
            FitnessCenterDbContext context,
            IHttpCustomClient httpCustomClient,
            UserRoleService userRoleService,
            ServicioActualizacionesDeHorariosRealTime servicioActualizaciones,
            IClasesService clasesService,
            UserManager<ApplicationUser> userManager,
            ILogger<ClasesController> logger
        )
        {
            _context = context;
            _httpCustomClient = httpCustomClient;
            _userRoleService = userRoleService;
            _servicioActualizaciones = servicioActualizaciones;
            _clasesService = clasesService;
            _userManager = userManager;
            _logger = logger;
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
                _logger?.LogInformation("Start ConsultarDetallesDeClase idClase={Id}", idClase);
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
                var deserializeOptions = new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true,
                };
                // Mapear los resultados al modelo DetalleDeClase
                var detalle = new DetalleDeClase
                {
                    NombreClase = detalleRaw.NombreClase,
                    SubtituloClase = detalleRaw.SubtituloClase,
                    Duracion = detalleRaw.Duracion,
                    NivelDeIntensidad = detalleRaw.NivelDeIntensidad,
                    NivelDeDificultad = detalleRaw.NivelDeDificultad,
                    DescripcionDeLaClase = detalleRaw.DescripcionDeLaClase,
                    BeneficiosDeLaClase = !string.IsNullOrEmpty(detalleRaw.BeneficiosDeLaClase)
                        ? JsonSerializer.Deserialize<List<DTO.Dtos.DTOBeneficiosDeClase>>(
                            detalleRaw.BeneficiosDeLaClase,
                            deserializeOptions
                        )
                        : new List<DTO.Dtos.DTOBeneficiosDeClase>(),
                    EstructuraDeLaClase = !string.IsNullOrEmpty(detalleRaw.EstructuraDeLaClase)
                        ? JsonSerializer.Deserialize<List<DTO.Dtos.DTOEstructuraDeClase>>(
                            detalleRaw.EstructuraDeLaClase,
                            deserializeOptions
                        )
                        : new List<DTO.Dtos.DTOEstructuraDeClase>(),
                    EjerciciosDeClase = !string.IsNullOrEmpty(detalleRaw.EjerciciosDeClase)
                        ? JsonSerializer.Deserialize<List<EjercicioPreview>>(
                            detalleRaw.EjerciciosDeClase,
                            deserializeOptions
                        )
                        : new List<EjercicioPreview>(),
                    Consejos = !string.IsNullOrEmpty(detalleRaw.Consejos)
                        ? JsonSerializer
                            .Deserialize<List<DTOConsejoDeClase>>(detalleRaw.Consejos)
                            ?.FirstOrDefault()
                        : null,
                    EquipamientoRecomendado = !string.IsNullOrEmpty(
                        detalleRaw.EquipamientoRecomendado
                    )
                        ? JsonSerializer.Deserialize<List<DTO.Dtos.DTOEquipo>>(
                            detalleRaw.EquipamientoRecomendado,
                            deserializeOptions
                        )
                        : new List<DTO.Dtos.DTOEquipo>(),
                    HorariosProgramados = !string.IsNullOrEmpty(detalleRaw.HorariosProgramados)
                        ? JsonSerializer.Deserialize<List<ClaseProgramada>>(
                            detalleRaw.HorariosProgramados,
                            deserializeOptions
                        )
                        : new List<ClaseProgramada>(),
                    imagenesDeClase = !string.IsNullOrEmpty(detalleRaw.imagenesDeClase)
                        ? JsonSerializer
                            .Deserialize<List<DTOImagenesDeClase>>(
                                detalleRaw.imagenesDeClase,
                                deserializeOptions
                            )
                            ?.FirstOrDefault()
                        : new DTOImagenesDeClase(),
                };

                // Construir y devolver la respuesta
                _logger?.LogInformation("Finished ConsultarDetallesDeClase idClase={Id}", idClase);
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
                _logger?.LogError(ex, "Error ConsultarDetallesDeClase idClase={Id}", idClase);
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

        [Authorize]
        [HttpGet("obtenerClases")]
        public async Task<ActionResult<DTOResponse<List<DTOClaseSimple>>>> ObtenerClases(
            [FromQuery] bool activa = false
        )
        {
            try
            {
                _logger?.LogInformation("Start ObtenerClases activa={Activa}", activa);
                var clases = await _context
                    .Clases.Where(c => c.FkEstadoClase == (activa ? 1 : 2)) // Asumiendo 1=Activa, 2=Inactiva
                    .Select(c => new DTOClaseSimple
                    {
                        ClaseID = c.ClaseId,
                        NombreClase = c.NombreClase,
                    })
                    .ToListAsync();

                _logger?.LogInformation("Finished ObtenerClases returned {Count}", clases?.Count);

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
                _logger?.LogError(ex, "Error ObtenerClases activa={Activa}", activa);
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
        [Authorize]
        [HttpGet("nivelesDeDificultad")]
        [EnableRateLimiting("PublicPolicy")]
        public async Task<
            ActionResult<DTOResponse<List<DTODificultad>>>
        > ObtenerNivelesDeDificultad()
        {
            try
            {
                var nivelesDificultad = await _clasesService.GetNivelesDeDificultadAsync();

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
                _logger?.LogError(ex, "Error ObtenerNivelesDeDificultad");
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<List<DTODificultad>>(
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
        [EnableRateLimiting("PublicPolicy")]
        public async Task<
            ActionResult<DTOResponse<List<DTOIntensidad>>>
        > ObtenerNivelesDeIntensidad()
        {
            try
            {
                var nivelesIntensidad = await _clasesService.GetNivelesDeIntensidadAsync();

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
                string logMessage = $"[ERROR] Método: ObtenerNivelesDeIntensidad (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                _logger?.LogError(ex, logMessage);
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<List<DTOIntensidad>>(
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
        /// Obtiene los instructores disponibles (empleados)
        /// </summary>
        [HttpGet("instructores")]
        [EnableRateLimiting("PublicPolicy")]
        public async Task<ActionResult<DTOResponse<List<QueryUser>>>> ObtenerInstructores()
        {
            try
            {
                _logger.LogInformation("Start ObtenerInstructores public endpoint");
                var usuarios = await _clasesService.GetInstructoresAsync();

                var respuesta = ResponseManager.BuildResponse(
                    success: true,
                    httpCode: 200,
                    message: "Consulta de instructores exitosa",
                    errors: null,
                    payload: usuarios
                );

                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in ObtenerInstructores");
                var respuesta = ResponseManager.BuildResponse(
                    success: false,
                    httpCode: 500,
                    message: "Error al obtener instructores",
                    errors: new List<ErrorModel>
                    {
                        new ErrorModel { message = ex.Message, propiedad = "NONE" },
                    },
                    payload: (List<QueryUser>)null
                );
                return StatusCode(500, respuesta);
            }
        }

        /// <summary>
        /// Registra una nueva clase
        /// </summary>
        [Authorize(Roles = "empleado")]
        [HttpPost("registrarClase")]
        public async Task<ActionResult<DTOResponse<int>>> RegistrarClase([FromBody] DTOClase modelo)
        {
            try
            {
                _logger?.LogInformation("Start RegistrarClase NombreClase={Nombre}", modelo?.NombreClase);
                // Ejecutar el procedimiento almacenado fn_obtenerClases
                var resultado = await _context
                    .Clases.Where(c => c.NombreClase == modelo.NombreClase)
                    .FirstOrDefaultAsync();

                if (resultado != null)
                {
                    return BadRequest(
                        ResponseManager.BuildResponse<int>(
                            false,
                            400,
                            "Ya existe una clase con ese nombre",
                            new List<ErrorModel>
                            {
                                new ErrorModel
                                {
                                    propiedad = "nombreClase",
                                    message = "Nombre de clase duplicado",
                                },
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
                    DuracionEnMinutosConDescansoIncluido =
                        modelo.DuracionEnMinutosConDescansoIncluido,
                    Cupo = modelo.Cupo > 0 ? modelo.Cupo : 20, // Valor por defecto si no se especifica
                    FkEstadoClase =
                        modelo.FkEstadoClase
                        ?? 1 // Activa por defecto
                    ,
                };

                _context.Clases.Add(nuevaClase);
                await _context.SaveChangesAsync();
                _logger?.LogInformation("RegistrarClase created id={Id}", nuevaClase.ClaseId);
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
                _logger?.LogError(ex, "Error RegistrarClase NombreClase={Nombre}", modelo?.NombreClase);
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
        [Authorize(Roles = "empleado")]
        [HttpPost("registrarClaseProgramada")]
        public async Task<ActionResult<DTOResponse<int>>> RegistrarClaseProgramada(
            [FromBody] DTODatosClaseProgramada modelo
        )
        {
            try
            {
                _logger?.LogInformation("Start RegistrarClaseProgramada fkClase={FkClase} fkEntrenador={FkEntrenador}", modelo?.fkClase, modelo?.fkEntrenador);
                // Validar el modelo usando las validaciones de Data Annotations
                if (!ModelState.IsValid)
                {
                    var errors = ModelState
                        .Values.SelectMany(v => v.Errors)
                        .Select(e => new ErrorModel
                        {
                            propiedad = "NONE",
                            message = e.ErrorMessage,
                        })
                        .ToList();

                    return BadRequest(
                        ResponseManager.BuildResponse<int>(false, 400, "Datos inválidos", errors, 0)
                    );
                }

                // Validar que la clase existe
                var clase = await _context.Clases.FindAsync(modelo.fkClase);
                if (clase == null)
                {
                    _logger?.LogWarning("RegistrarClaseProgramada failed: clase not found fkClase={FkClase}", modelo?.fkClase);
                    return BadRequest(
                        ResponseManager.BuildResponse<int>(
                            false,
                            400,
                            "La clase especificada no existe",
                            new List<ErrorModel>
                            {
                                new ErrorModel
                                {
                                    propiedad = "fkClase",
                                    message = "Clase no encontrada",
                                },
                            },
                            0
                        )
                    );
                }

                // Validar que el entrenador tiene rol de empleado
                var esEmpleado = await _userRoleService.TieneRol(modelo.fkEntrenador, "empleado");
                if (!esEmpleado)
                {
                    _logger?.LogWarning("RegistrarClaseProgramada failed: entrenador no empleado fkEntrenador={FkEntrenador}", modelo?.fkEntrenador);
                    return BadRequest(
                        ResponseManager.BuildResponse<int>(
                            false,
                            400,
                            "El usuario especificado no tiene rol de empleado",
                            new List<ErrorModel>
                            {
                                new ErrorModel
                                {
                                    propiedad = "fkEntrenador",
                                    message = "El usuario debe tener rol de empleado",
                                },
                            },
                            0
                        )
                    );
                }

                var connection = (SqlConnection)_context.Database.GetDbConnection();
                if (connection.State != ConnectionState.Open)
                {
                    await connection.OpenAsync();
                }

                using (connection)
                {
                    using (
                        var command = new SqlCommand("dbo.sp_registrarClaseProgramada", connection)
                    )
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        var datos = DataTableConverter.ConvertToDataTable<DTODatosClaseProgramada>(
                            modelo
                        );
                        command.Parameters.AddWithValue("@datos", datos);
                        int idClaseProgramada = 0;
                        using (var reader = await command.ExecuteReaderAsync())
                        {
                            if (await reader.ReadAsync())
                            {
                                
                                idClaseProgramada = reader.GetInt32(reader.GetOrdinal("idClaseProgramada"));
                            }
                        }

                        await _servicioActualizaciones.enviarClaseProgramadaRegistrada(
                            idClaseProgramada
                        );
                        _logger?.LogInformation("RegistrarClaseProgramada created id={Id}", idClaseProgramada);

                        if (modelo.idPreservaDeHorario.HasValue)
                        {
                            int preReservasEliminadas = await _context.PreReservasDeHorarios
                                .Where(p => p.IdPreReserva == modelo.idPreservaDeHorario)
                                .ExecuteDeleteAsync();

                            if (preReservasEliminadas <= 0)
                            {
                                _logger?.LogWarning("No se pudo eliminar la pre-reserva asociada idPreserva={IdPreserva}", modelo.idPreservaDeHorario);
                            }
                        }

                        await _servicioActualizaciones.enviarPreReservasActualizadas(
                            modelo.idUsuarioQueReserva
                        );
                        await _servicioActualizaciones.enviarHorariosDisponiblesActualizados(
                            modelo.idUsuarioQueReserva
                        );

                        return Ok(
                            ResponseManager.BuildResponse<int?>(
                                true,
                                200,
                                "Clase programada registrada correctamente",
                                null,
                                idClaseProgramada
                            )
                        );
                    }
                }
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: RegistrarClaseProgramada (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Modelo.FkClase: {modelo?.fkClase} | Stack Trace: {ex.StackTrace}";
                _logger?.LogError(ex, logMessage);

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

        /// <summary>
        /// Cancela clases programadas
        /// </summary>
        [Authorize(Roles = "empleado")]
        [HttpPost("cancelarClasesProgramadas")]
        public async Task<ActionResult<DTOResponse<string>>> ClasesProgramadas(
            [FromBody] List<DTOClaseCancelada> solicitudes
        )
        {
            try
            {
                string mensaje = "";

                foreach (var solicitud in solicitudes)
                {
                    // Obtener el usuario por su ID (GUID del empleado)
                    var entrenador = await _userManager.FindByIdAsync(solicitud.claseCancelada.fkEntrenador);

                    if (entrenador == null)
                    {
                        return BadRequest(
                            ResponseManager.BuildResponse<string>(
                                false,
                                400,
                                "Entrenador no encontrado",
                                null,
                                null
                            )
                        );
                    }

                    // Cancelar la clase programada directamente (procedimiento almacenado requiere columnas que no existen en este backup)
                    var cancelResult = await _context.Database.ExecuteSqlRawAsync(
                        @"UPDATE clasesProgramadas 
                          SET fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM estadosClasesProgramadas WHERE nombresEstado = 'cancelada')
                          WHERE idProgramacionClase = {0}",
                        solicitud.claseCancelada.idProgramacionClase
                    );

                    // Si no se affected ninguna fila, la clase no existía o ya estaba cancelada
                    if (cancelResult == 0)
                    {
                        mensaje = $"No se pudo cancelar la clase programada ID {solicitud.claseCancelada.idProgramacionClase}.";
                        return BadRequest(
                            ResponseManager.BuildResponse<string>(
                                false,
                                400,
                                mensaje,
                                null,
                                null
                            )
                        );
                    }

                    mensaje = $"Clase programada ID {solicitud.claseCancelada.idProgramacionClase} cancelada exitosamente.";
                    // Enviar correo de confirmación
                    var emailManager = new EmailManagerMailKit(
                        "smtp.gmail.com",
                        587,
                        "aaronlarabonfil@gmail.com",
                        "kayxfchmpquogjgg"
                    );
                    var message = emailManager.crearEmail(
                        "Fitness Gym",
                        "aaronlarabonfil@gmail.com",
                        $"{entrenador.NombreCompleto}",
                        entrenador.Email,
                        "Clase Cancelada",
                        "La clase ha sido cancelada por el entrenador,en breve se te notificara la fecha de reagendacion de la clase.El entrenador se comunicara contigo para explicarte lso detalles de la cancelación"
                    );
                    emailManager.EnviarEmail(message);

                    // Guard clause: sin petición de reagendación
                    if (solicitud.claseReagendada == null)
                    {
                        mensaje += " | Reagendación: Sin petición de reagendación.";
                        continue;
                    }
                    // Flujo normal: procesar reagendación

                    var content = JsonContent.Create(solicitud.claseReagendada);
                    var response = await _httpCustomClient.post(
                        "api/clases/registrarClaseProgramada",
                        content
                    );

                    // Guard clause: error en reagendación
                    if (string.IsNullOrEmpty(response))
                    {
                        mensaje += $" | Reagendación: Error al reagendar la clase programada ID {solicitud.claseCancelada.idProgramacionClase}.";
                        continue;
                    }
                    mensaje += $" | Reagendación: Exitosa para la clase programada ID {solicitud.claseCancelada.idProgramacionClase}.";

                }

                return Ok(
                    ResponseManager.BuildResponse<object>(
                        true,
                        200,
                        mensaje.Trim(),
                        null,
                        null
                    )
                );
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: CancelarClasesProgramadas (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | SolicitudesCount: {solicitudes?.Count} | Stack Trace: {ex.StackTrace}";
                _logger?.LogError(ex, logMessage);

                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<string>(
                        false,
                        500,
                        "Error al cancelar las clases programadas",
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
        /// Reagenda una insrcipcion a una clase de un cliente
        /// </summary>
        [Authorize(Roles = "empleado")]
        [HttpPost("reagendacionDeInscripcionAClase")]
        public async Task<ActionResult<DTOResponse<string>>> ReagendarInscripcionAClase(
            [FromBody] DTOReagendacionDeInscripcion modelo
        )
        {
            try
            {
                _logger?.LogInformation("Start ReagendarInscripcionAClase IdProgramacionClase={IdProgramacion} IdCliente={IdCliente}", modelo?.idClaseProgramadaNueva, modelo?.idCliente);
                // Validar el modelo
                if (!ModelState.IsValid)
                {
                    return BadRequest(
                        ResponseManager.BuildResponse<string>(
                            false,
                            400,
                            "Datos inválidos",
                            ModelState
                                .Values.SelectMany(v => v.Errors)
                                .Select(e => new ErrorModel
                                {
                                    propiedad = "NONE",
                                    message = e.ErrorMessage,
                                })
                                .ToList(),
                            null
                        )
                    );
                }

                // Preparar los parámetros para el procedimiento almacenado
                var parametros = new SqlParameter[]
                {
                    new SqlParameter("@idInscripcionCancelada", modelo.idInscripcionCancelada),
                    new SqlParameter("@idClaseProgramadaNueva", modelo.idClaseProgramadaNueva),
                    new SqlParameter("@idCliente", modelo.idCliente),
                    new SqlParameter("@estadoOperacion", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output,
                    },
                };

                // Ejecutar el procedimiento almacenado
                await _context.Database.ExecuteSqlRawAsync(
                    "EXEC dbo.sp_procesoCompletoReagendacionDeInscripcion @idInscripcionCancelada, @idClaseProgramadaNueva, @idCliente, @estadoOperacion OUTPUT",
                    parametros
                );

                // Obtener el estado de operación
                int estadoOperacion = (int)parametros.Last().Value;

                if (estadoOperacion == 1)
                {
                    return Ok(
                        ResponseManager.BuildResponse<string>(
                            true,
                            200,
                            "Reagendación de clase completada exitosamente",
                            null,
                            null
                        )
                    );
                }
                else
                {
                    return BadRequest(
                        ResponseManager.BuildResponse<string>(
                            false,
                            400,
                            "Error en la reagendación de la clase",
                            null,
                            null
                        )
                    );
                }
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: ReagendarInscripcionAClase (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | IdInscripcionCancelada: {modelo?.idInscripcionCancelada} | Stack Trace: {ex.StackTrace}";
                _logger?.LogError(ex, logMessage);

                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<string>(
                        false,
                        500,
                        "Error al reagendar la clase",
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
        /// Obtiene todos los estados de clases programadas
        /// </summary>
        /// <returns>Lista de estados de clases programadas</returns>
        [Authorize(Roles = "empleado")]
        [HttpGet("obtenerEstadosDeClasesProgramdas")]
        public async Task<
            ActionResult<DTOResponse<List<DTOEstadoClaseProgramada>>>
        > ObtenerEstadosDeClasesProgramadas()
        {
            try
            {
                // Ejecutar la función SQL para obtener los estados posible de una clase programada
                var estados = await _context
                    .DtoEstadoClaseProgramada.FromSqlInterpolated(
                        $"SELECT * FROM dbo.fn_obtenerEstadosDeClasesProgramdas()"
                    )
                    .ToListAsync();

                return Ok(
                    ResponseManager.BuildResponse(
                        true,
                        200,
                        "Estados de clases programadas obtenidos correctamente",
                        null,
                        estados
                    )
                );
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<List<DTOEstadoClaseProgramada>>(
                        false,
                        500,
                        "Error al obtener los estados de clases programadas",
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
        /// Obtiene las clases programadas por id de clase
        /// </summary>
        [Authorize(Roles = "empleado")]
        [HttpGet("obtenerClasesProgramadasPorId")]
        public async Task<
            ActionResult<DTOResponse<List<DTOClaseProgramadaView>>>
        > obtenerClasesProgramadasPorId([FromQuery][Range(1, int.MaxValue)] int? idClase)
        {
            // Validar el modelo
            if (!ModelState.IsValid)
            {
                return BadRequest(
                    ResponseManager.BuildResponse<List<DTOClaseProgramadaView>>(
                        false,
                        400,
                        "Datos inválidos",
                        ModelState
                            .Values.SelectMany(v => v.Errors)
                            .Select(e => new ErrorModel
                            {
                                propiedad = "NONE",
                                message = e.ErrorMessage,
                            })
                            .ToList(),
                        null
                    )
                );
            }

            try
            {
                var resultado = await _context
                    .DTOClasesProgramadaView.FromSqlInterpolated(
                        $"SELECT * FROM dbo.fn_obtenerClasesProgramadasPorIdClase({idClase})"
                    )
                    .ToListAsync();
                return Ok(
                    ResponseManager.BuildResponse(
                        true,
                        200,
                        "Clases programadas obtenidas correctamente",
                        null,
                        resultado
                    )
                );
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<List<DTOClaseProgramadaView>>(
                        false,
                        500,
                        "Error al obtener las clases programadas",
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
        /// Registra una inscripción a una clase programada
        /// </summary>
        [Authorize(Roles = "empleado")]
        [HttpPost("inscribirAClase")]
        public async Task<ActionResult<DTOResponse<int>>> InscribirAClase(
            [FromBody] DTOInscripcionAClase modelo
        )
        {
            var idInscripcion = 0;
            try
            {
                // Validar el modelo
                if (!ModelState.IsValid)
                {
                    return BadRequest(
                        ResponseManager.BuildResponse<int>(
                            false,
                            400,
                            "Datos inválidos",
                            ModelState
                                .Values.SelectMany(v => v.Errors)
                                .Select(e => new ErrorModel
                                {
                                    propiedad = "NONE",
                                    message = e.ErrorMessage,
                                })
                                .ToList(),
                            0
                        )
                    );
                }

                var resultadoCupos =
                    await DataAccess.Infraestructure.DatabaseExecutor.ExecuteStoredProcedureAsync(
                        _context.Database.GetDbConnection(),
                        "dbo.fn_cupoDisponibleClaseProgramada",
                        new Dictionary<string, object>
                        {
                            {
                                "idProgramacionClase",
                                new DatabaseParameter(
                                    modelo.IdProgramacionClase,
                                    ParameterDirection.Input,
                                    DbType.Int32
                                )
                            },
                            {
                                "cuposDisponibles",
                                new DatabaseParameter(
                                    null,
                                    ParameterDirection.ReturnValue,
                                    DbType.Int32
                                )
                            },
                        }
                    );
                var cupoDisponible = (int)resultadoCupos.OutputParameters["cuposDisponibles"];
                if (cupoDisponible <= 0)
                {
                    return BadRequest(
                        ResponseManager.BuildResponse<int>(
                            false,
                            400,
                            "No hay cupo disponible para la clase",
                            new List<ErrorModel>
                            {
                                new ErrorModel
                                {
                                    propiedad = "NONE",
                                    message = "No hay cupo disponible para la clase",
                                },
                            },
                            0
                        )
                    );
                }
                // Ejecutar el procedimiento almacenado usando ExecuteSqlInterpolatedAsync
                idInscripcion = await _context.Database.ExecuteSqlInterpolatedAsync(
                   $@"EXEC dbo.sp_registrarInsrcipcionAClase 
                        @idCliente={modelo.IdCliente},
                        @fkProgramacionClase={modelo.IdProgramacionClase}"
               );

                // Notificar actualización de cupos
                await _servicioActualizaciones.enviarCuposActualizadosDeClaseProgramada(
                    modelo.IdProgramacionClase
                );
                _logger?.LogInformation("InscribirAClase completed idInscripcion={IdInscripcion}", idInscripcion);

                return Ok(
                    ResponseManager.BuildResponse(
                        true,
                        200,
                        "Inscripción registrada correctamente",
                        null,
                        idInscripcion
                    )
                );
            }
            catch (Exception ex)
            {
                _logger?.LogError(ex, "Error InscribirAClase IdProgramacionClase={IdProgramacion} IdCliente={IdCliente}", modelo?.IdProgramacionClase, modelo?.IdCliente);

                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<int>(
                        false,
                        500,
                        "Error al registrar la inscripción",
                        new List<ErrorModel>
                        {
                            new ErrorModel { propiedad = "NONE", message = ex.Message },
                        },
                        0
                    )
                );
            }
        }

        [Authorize(Roles = "empleado")]
        [HttpPost("eliminarPrereservaDeClaseProgramada")]
        public async Task<ActionResult<DTOResponse<string>>> EliminarPrereservaDeClaseProgramada(
            [FromBody] int idPreReserva
        )
        {
            // Sad Path 2: Range validation for idPreReserva
            if (idPreReserva <= 0)
            {
                return BadRequest(
                    ResponseManager.BuildResponse<int>(
                        false,
                        400,
                        "Datos inválidos",
                        new List<ErrorModel>
                        {
                            new ErrorModel { propiedad = "idPreReserva", message = "El idPreReserva debe ser mayor a 0." },
                        },
                        0
                    )
                );
            }

            int preReservasEliminadas = 0;
            try
            {
                preReservasEliminadas = await _context.PreReservasDeHorarios
                    .Where(p => p.IdPreReserva == idPreReserva)
                    .ExecuteDeleteAsync();
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    ResponseManager.BuildResponse<string>(
                        false,
                        500,
                        "Error al eliminar la pre-reserva",
                        new List<ErrorModel>
                        {
                            new ErrorModel { propiedad = "NONE", message = ex.Message },
                        },
                        null
                    )
                );
            }

            // Sad Path 3: Not found handling
            if (preReservasEliminadas == 0)
            {
                return NotFound(
                    ResponseManager.BuildResponse<int>(
                        false,
                        404,
                        "No se encontró la pre-reserva especificada",
                        new List<ErrorModel>
                        {
                            new ErrorModel { propiedad = "idPreReserva", message = $"No existe una pre-reserva con el ID {idPreReserva}." },
                        },
                        0
                    )
                );
            }

            return Ok(
                ResponseManager.BuildResponse<int>(
                    true,
                    200,
                    "Pre-reserva eliminada correctamente",
                    null,
                    preReservasEliminadas
                )
            );
        }

        /// <summary>
        /// Obtiene las clases activas con sus imágenes de banner para vista previa pública
        /// </summary>
        /// <returns>Lista de previews de clases activas</returns>
        [HttpGet("preview")]
        [EnableCors("public")]
        [EnableRateLimiting("PublicPolicy")]
        public async Task<ActionResult<DTOResponse<List<DTOClasePreview>>>> GetPreview()
        {
            try
            {
                _logger.LogInformation("Start GetPreview public endpoint");
                var previews = await _clasesService.GetPreviewDeClasesAsync();

                var respuesta = ResponseManager.BuildResponse(
                    success: true,
                    httpCode: 200,
                    message: "Previews de clases obtenidos correctamente",
                    errors: null,
                    payload: previews
                );

                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in GetPreview");
                var respuesta = ResponseManager.BuildResponse<List<DTOClasePreview>>(
                    success: false,
                    httpCode: 500,
                    message: "Error al obtener previews de clases",
                    new List<ErrorModel>
                    {
                        new ErrorModel { message = ex.Message, propiedad = "NONE" },
                    },
                    null
                );
                return StatusCode(500, respuesta);
            }
        }
    }
}
