using System;
using System.Collections.Generic;
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
using DTO.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ClasesController : ControllerBase
    {
        private readonly FitnessCenterDbContext _context;
        private readonly HttpCustomClient _httpCustomClient;
        private readonly UserRoleService _userRoleService;
        private readonly ServicioActualizacionesDeHorariosRealTime _servicioActualizaciones;

        private readonly ClasesService _clasesService;

        public ClasesController(
            FitnessCenterDbContext context,
            HttpCustomClient httpCustomClient,
            UserRoleService userRoleService,
            ServicioActualizacionesDeHorariosRealTime servicioActualizaciones,
            ClasesService clasesService
        )
        {
            _context = context;
            _httpCustomClient = httpCustomClient;
            _userRoleService = userRoleService;
            _servicioActualizaciones = servicioActualizaciones;
            _clasesService = clasesService;
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
                var deserializeOptions = new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true,
                };
                // Mapear los resultados al modelo DetalleDeClase
                var detalle = new DetalleDeClase
                {
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
                string logMessage = $"[ERROR] Método: ConsultarDetallesDeClase (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | IdClase: {idClase} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
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
        public async Task<ActionResult<DTOResponse<List<DTOClaseSimple>>>> ObtenerClases(
            [FromQuery] bool activa = false
        )
        {
            try
            {
                var clases = await _context
                    .Clases.Where(c => c.FkEstadoClase == (activa ? 1 : 2)) // Asumiendo 1=Activa, 2=Inactiva
                    .Select(c => new DTOClaseSimple
                    {
                        ClaseID = c.ClaseId,
                        NombreClase = c.NombreClase,
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
                string logMessage = $"[ERROR] Método: ObtenerClases (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Activa: {activa} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
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
        public async Task<
            ActionResult<DTOResponse<List<VNivelesDeDificultad>>>
        > ObtenerNivelesDeDificultad()
        {
            try
            {
                // Usar la vista v_nivelesDeDificultad definida en el procedimiento almacenado
                var nivelesDificultad = await _context
                    .VNivelesDeDificultads.FromSqlInterpolated(
                        $"SELECT * FROM v_nivelesDeDificultad"
                    )
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
                string logMessage = $"[ERROR] Método: ObtenerNivelesDeDificultad (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
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
        public async Task<
            ActionResult<DTOResponse<List<VNivelesDeIntensidad>>>
        > ObtenerNivelesDeIntensidad()
        {
            try
            {
                // Usar la vista v_nivelesDeIntensidad definida en el procedimiento almacenado
                var nivelesIntensidad = await _context
                    .VNivelesDeIntensidads.FromSqlInterpolated(
                        $@"SELECT * FROM v_nivelesDeIntensidad"
                    )
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
                string logMessage = $"[ERROR] Método: ObtenerNivelesDeIntensidad (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);
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
        [Authorize(Roles = "empleado")]
        [HttpPost("registrarClase")]
        public async Task<ActionResult<DTOResponse<int>>> RegistrarClase([FromBody] DTOClase modelo)
        {
            try
            {
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
                string logMessage = $"[ERROR] Método: RegistrarClase (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Modelo.NombreClase: {modelo?.NombreClase} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);

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
                        var idClaseProgramada = Convert.ToInt32(await command.ExecuteScalarAsync());

                        await _servicioActualizaciones.enviarClaseProgramadaRegistrada(
                            idClaseProgramada
                        );

                        if (modelo.idPreservaDeHorario.HasValue)
                        {
                            int preReservasEliminadas =
                                await _clasesService.eliminarPreReservaDeClaseProgramada(
                                    modelo.idPreservaDeHorario
                                );
                            if (preReservasEliminadas <= 0)
                            {
                                Console.WriteLine("NO SE PUDO ELIMINAR LA PRE-RESERVA ASOCIADA");
                            }
                        }

                        await _servicioActualizaciones.enviarPreReservasActualizadas(
                            modelo.idUsuarioQueReserva
                        );
                        await _servicioActualizaciones.enviarHorariosDisponiblesActualizados(
                            modelo.idUsuarioQue Reserva
                        );

                        return Ok(
                            ResponseManager.BuildResponse<int?>(
                                true,
                                200,
                                "Clase programada registrada correctamente",
                                null,
                                1
                            )
                        );
                    }
                }
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: RegistrarClaseProgramada (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Modelo.FkClase: {modelo?.fkClase} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);

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
        public async Task<ActionResult<DTOResponse<string>>> CancelarClasesProgramadas(
            [FromBody] List<DTOClaseCancelada> solicitudes
        )
        {
            try
            {
                foreach (var solicitud in solicitudes)
                {
                    // Obtener el correo del entrenador
                    var entrenador = await _context.Usuarios.FindAsync(
                        solicitud.claseCancelada.fkEntrenador
                    );

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

                    // Llamar al procedimiento almacenado para cancelar la clase programada
                    var parametros = new SqlParameter[]
                    {
                        new SqlParameter(
                            "@idClaseProgramada",
                            solicitud.claseCancelada.idProgramacionClase
                        ),
                        new SqlParameter("@fechaParaCancelar", DateTime.Now), // O la fecha que desees usar
                        new SqlParameter("@idEntrenador", solicitud.claseCancelada.fkEntrenador),
                        new SqlParameter("@idClase", solicitud.claseCancelada.fkClase),
                        new SqlParameter("@estadoDeOperaciones", SqlDbType.Int)
                        {
                            Direction = ParameterDirection.Output,
                        },
                    };

                    var resultado = await _context.Database.ExecuteSqlRawAsync(
                        $"EXEC dbo.sp_procesoCompletoCancelarClasesProgramadas @idClaseProgramada, @fechaParaCancelar, @idEntrenador, @idClase, @estadoDeOperaciones OUTPUT",
                        parametros
                    );
                    int exitoCancelacion = (int)parametros[parametros.Length - 1].Value;
                    if (exitoCancelacion > 0) // Si la cancelación fue exitosa
                    {
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
                            $"{entrenador.Nombre} {entrenador.Apellido}",
                            entrenador.Email,
                            "Clase Cancelada",
                            "La clase ha sido cancelada por el entrenador,en breve se te notificara la fecha de reagendacion de la clase.El entrenador se comunicara contigo para explicarte lso detalles de la cancelación"
                        );
                        emailManager.EnviarEmail(message);

                        // Si hay una clase reagendada, registrar la nueva clase programada
                        if (solicitud.claseReagendada != null)
                        {
                            var content = JsonContent.Create(solicitud.claseReagendada);
                            var response = await _httpCustomClient.post(
                                "api/clases/registrarClaseProgramada",
                                content
                            );

                            if (string.IsNullOrEmpty(response))
                            {
                                return BadRequest(
                                    ResponseManager.BuildResponse<string>(
                                        false,
                                        400,
                                        "Error al reagendar la clase",
                                        null,
                                        null
                                    )
                                );
                            }
                        }
                    }
                    else
                    {
                        return BadRequest(
                            ResponseManager.BuildResponse<string>(
                                false,
                                400,
                                "No se pudo cancelar la clase programada",
                                null,
                                null
                            )
                        );
                    }
                }

                return Ok(
                    ResponseManager.BuildResponse(
                        true,
                        200,
                        "Clases programadas canceladas exitosamente",
                        null,
                        "Cancelación exitosa"
                    )
                );
            }
            catch (Exception ex)
            {
                string logMessage = $"[ERROR] Método: CancelarClasesProgramadas (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | SolicitudesCount: {solicitudes?.Count} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);

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
        /// Reagenda una clase
        /// </summary>
        [Authorize(Roles = "empleado")]
        [HttpPost("reagendacionDeInscripcionAClase")]
        public async Task<ActionResult<DTOResponse<string>>> ReagendarClase(
            [FromBody] DTOReagendacionDeInscripcion modelo
        )
        {
            try
            {
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
                string logMessage = $"[ERROR] Método: ReagendarClase (ClasesController) | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | IdInscripcionCancelada: {modelo?.idInscripcionCancelada} | Stack Trace: {ex.StackTrace}";
                Console.WriteLine(logMessage);

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
                // Ejecutar la función SQL para obtener los estados usando el DTO registrado
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
        > obtenerClasesProgramadasPorId([FromQuery] int idClase)
        {
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
                var idInscripcion = await _context.Database.ExecuteSqlInterpolatedAsync(
                    $@"EXEC dbo.sp_registrarInsrcipcionAClase 
                        @idCliente={modelo.IdCliente},
                        @fkProgramacionClase={modelo.IdProgramacionClase}"
                );

                // Notificar actualización de cupos
                await _servicioActualizaciones.enviarCuposActualizadosDeClaseProgramada(
                    modelo.IdProgramacionClase
                );

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
            int preReservasEliminadas = 0;
            try
            {
                preReservasEliminadas = await _clasesService.eliminarPreReservaDeClaseProgramada(
                    idPreReserva
                );
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
    }
}
