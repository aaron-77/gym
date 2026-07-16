using Microsoft.EntityFrameworkCore;

using API.Services.Validaciones;
using BL.Utils;
using BL.Validaciones;
using DataAccess.EntityFramework;
using DataAccess.Infraestructure;
using DTO.Dtos;

namespace API.Services;

public class InscripcionesService : IInscripcionesService
{
    private readonly FitnessCenterDbContext _context;
    private readonly ILogger<InscripcionesService> _logger;
    private readonly IValidadorFechaCancelacionInscripcion _validadorFecha;
    private readonly IValidadorUsuarioExistente _validadorUsuario;
    private readonly IDataAccessExecutor _dbExecutor;

    public InscripcionesService(
        FitnessCenterDbContext context,
        ILogger<InscripcionesService> logger,
        IValidadorFechaCancelacionInscripcion validadorFecha,
        IValidadorUsuarioExistente validadorUsuario,
        IDataAccessExecutor dbExecutor)
    {
        _context = context;
        _logger = logger;
        _validadorFecha = validadorFecha;
        _validadorUsuario = validadorUsuario;
        _dbExecutor = dbExecutor;
    }

    // ──────────────────────────────────────────────
    //  ConsultarInscripcionesDeClienteAsync
    //  Migrado desde ServiceConsultarInscripcionesDeCliente
    // ──────────────────────────────────────────────

    public async Task<DTOResponse<List<DTOInscripcionDelCliente>>> ConsultarInscripcionesDeClienteAsync(string idUsuario)
    {
        try
        {
            // Paso 1: Validar formato del ID usando validador estático
            var (esValido, mensajeError) = ValidadorStringId.Validar(idUsuario, "ID de usuario");
            if (!esValido)
            {
                return ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                    success: false,
                    httpCode: 400,
                    message: "Datos inválidos",
                    errors: new List<ErrorModel>
                    {
                        new() { message = mensajeError, propiedad = "idUsuario" }
                    },
                    payload: null!);
            }

            // Paso 2: Validar que el usuario exista en BD
            var (existe, _) = await _validadorUsuario.ValidarAsync(idUsuario);
            if (!existe)
            {
                return ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                    success: false,
                    httpCode: 404,
                    message: "Usuario no encontrado",
                    errors: new List<ErrorModel>
                    {
                        new() { message = "El usuario especificado no existe.", propiedad = "idUsuario" }
                    },
                    payload: null!);
            }

            // Paso 3: Ejecutar función SQL para obtener inscripciones
            var inscripciones = await _dbExecutor
                .QueryAsync<DTOInscripcionDelCliente>(
                    $"SELECT * FROM dbo.fn_obtenerInscripcionesDelCliente({idUsuario})");

            // Paso 4: Retornar respuesta exitosa
            return ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                success: true,
                httpCode: 200,
                message: "Consulta exitosa",
                errors: null,
                payload: inscripciones);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al consultar inscripciones del cliente {IdUsuario}", idUsuario);

            return ResponseManager.BuildResponse<List<DTOInscripcionDelCliente>>(
                success: false,
                httpCode: 500,
                message: "Error interno del servidor",
                errors: new List<ErrorModel>
                {
                    new() { message = "Ocurrió un error al consultar las inscripciones.", propiedad = null }
                },
                payload: null!);
        }
    }

    // ──────────────────────────────────────────────
    //  CancelarInscripcionAsync
    //  Migrado desde ServiceCancelarInscripcion
    // ──────────────────────────────────────────────

    public async Task<DTOResponse<bool>> CancelarInscripcionAsync(int idInscripcion)
    {
        try
        {
            // Paso 1: Guard clause — ID debe ser mayor a 0
            if (idInscripcion <= 0)
            {
                return ResponseManager.BadRequest<bool>(
                    "Datos inválidos",
                    "idInscripcion|El ID de inscripción debe ser mayor a 0.");
            }

            // Paso 2: Buscar inscripción con su clase programada y horarios
            var inscripcion = await _context.InscripcionesDeClases
                .Include(i => i.FkProgramacionClaseNavigation)
                    .ThenInclude(cp => cp.HorariosDeClasesProgramada)
                        .ThenInclude(h => h.FkHorarioLaboralNavigation)
                .FirstOrDefaultAsync(i => i.IdInscripcion == idInscripcion);

            // Paso 3: Validar que la inscripción exista
            if (inscripcion is null)
            {
                return ResponseManager.NotFound<bool>(
                    "Inscripción no encontrada",
                    "idInscripcion|La inscripción especificada no existe.");
            }

            var claseProgramada = inscripcion.FkProgramacionClaseNavigation;

            if (!claseProgramada.FechaDeLaClase.HasValue)
            {
                _logger.LogError("[CancelarInscripcionAsync] La clase programada {IdProgramacionClase} no tiene fecha asignada", claseProgramada.IdProgramacionClase);
                return ResponseManager.InternalServerError<bool>("Error interno del servidor");
            }

            var fechaClase = claseProgramada.FechaDeLaClase.Value;

            // Paso 4: Validar fecha y hora de la clase usando el validador
            var horaInicio = claseProgramada.HorariosDeClasesProgramada
                .Select(h => h.FkHorarioLaboralNavigation.HoraInicio)
                .DefaultIfEmpty()
                .First();

            var (esValido, mensajeError) = _validadorFecha.Validar(fechaClase, horaInicio);

            if (!esValido)
            {
                return ResponseManager.BadRequest<bool>(mensajeError, $"idInscripcion|{mensajeError}");
            }

            // Paso 5: Ejecutar el procedimiento almacenado de cancelación
            await _dbExecutor.ExecuteAsync(
                $@"EXEC dbo.sp_procesoCompletoCancelacionDeInscripcionAClase @idInscripcion = {idInscripcion}");

            return ResponseManager.Ok<bool>("Inscripción cancelada exitosamente", true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "[CancelarInscripcionAsync] Error al cancelar inscripción {IdInscripcion}", idInscripcion);

            return ResponseManager.InternalServerError<bool>("Error interno del servidor");
        }
    }

    // ──────────────────────────────────────────────
    //  ReagendarInscripcionAsync
    //  Spec 39
    // ──────────────────────────────────────────────

    public async Task<DTOResponse<bool>> ReagendarInscripcionAsync(int idInscripcion, int idClaseProgramada, string idCliente)
    {
        try
        {
            // Paso 1: Guard clause — idInscripcion debe ser mayor a 0
            if (idInscripcion <= 0)
            {
                return ResponseManager.BadRequest<bool>(
                    "Datos inválidos",
                    "idInscripcion|El ID de inscripción debe ser mayor a 0.");
            }

            // Paso 2: Guard clause — idClaseProgramada debe ser mayor a 0
            if (idClaseProgramada <= 0)
            {
                return ResponseManager.BadRequest<bool>(
                    "Datos inválidos",
                    "idClaseProgramada|El ID de clase programada debe ser mayor a 0.");
            }

            // Paso 3: Guard clause — idCliente no debe ser NULL, vacío o whitespace
            if (string.IsNullOrWhiteSpace(idCliente))
            {
                return ResponseManager.BadRequest<bool>(
                    "Datos inválidos",
                    "idCliente|El ID del cliente no puede estar vacío.");
            }

            // Paso 4: Buscar la inscripción con Include de clase programada + horarios
            var inscripcion = await _context.InscripcionesDeClases
                .Include(i => i.FkProgramacionClaseNavigation)
                    .ThenInclude(cp => cp.HorariosDeClasesProgramada)
                        .ThenInclude(h => h.FkHorarioLaboralNavigation)
                .FirstOrDefaultAsync(i => i.IdInscripcion == idInscripcion);

            // Paso 5: Si la inscripción no existe, retornar error 404
            if (inscripcion is null)
            {
                return ResponseManager.NotFound<bool>(
                    "Inscripción no encontrada",
                    "idInscripcion|La inscripción especificada no existe.");
            }

            var claseProgramada = inscripcion.FkProgramacionClaseNavigation;

            if (!claseProgramada.FechaDeLaClase.HasValue)
            {
                _logger.LogError("[ReagendarInscripcionAsync] La clase programada {IdProgramacionClase} no tiene fecha asignada", claseProgramada.IdProgramacionClase);
                return ResponseManager.InternalServerError<bool>("Error interno del servidor");
            }

            var fechaClase = claseProgramada.FechaDeLaClase.Value;

            // Paso 6: Obtener la hora de inicio de la clase programada
            var horaInicio = claseProgramada.HorariosDeClasesProgramada
                .Select(h => h.FkHorarioLaboralNavigation.HoraInicio)
                .DefaultIfEmpty()
                .First();

            // Paso 7: Validar fecha y hora usando IValidadorFechaCancelacionInscripcion
            var (esValido, mensajeError) = _validadorFecha.Validar(fechaClase, horaInicio);

            // Paso 8: Si la validación de fecha/hora falla, retornar error 400
            if (!esValido)
            {
                return ResponseManager.BadRequest<bool>(mensajeError, $"idInscripcion|{mensajeError}");
            }

            // Paso 9: Buscar la clase programada destino en la BD usando FindAsync
            var claseDestino = await _context.ClasesProgramadas.FindAsync(idClaseProgramada);

            // Paso 10: Si la clase programada destino no existe, retornar error 404
            if (claseDestino is null)
            {
                return ResponseManager.NotFound<bool>(
                    "Clase programada no encontrada",
                    "idClaseProgramada|La clase programada destino especificada no existe.");
            }

            // Paso 11: Validar que el tipo de clase (fkClase) de la clase programada destino
            //          coincida con el de la clase programada original
            if (claseProgramada.FkClase != claseDestino.FkClase)
            {
                return ResponseManager.BadRequest<bool>(
                    "Datos inválidos",
                    "idClaseProgramada|El tipo de clase de la clase programada destino no coincide con el tipo de clase de la inscripción original.");
            }

            // Paso 12: Validar que la fecha de la clase programada destino
            //          sea estrictamente posterior a la fecha de la clase original
            if (claseDestino.FechaDeLaClase > claseProgramada.FechaDeLaClase)
            {
                return ResponseManager.BadRequest<bool>(
                    "Datos inválidos",
                    "idClaseProgramada|La fecha de la clase programada destino debe ser posterior a la fecha de la clase original.");
            }

            // Paso 13: Ejecutar el procedimiento almacenado de reagendación
            await _dbExecutor.ExecuteAsync(
                $@"DECLARE @estadoOperacion INT;
                  EXEC dbo.sp_procesoCompletoReagendacionDeInscripcion @idInscripcionCancelada = {idInscripcion}, @idClaseProgramadaNueva = {idClaseProgramada}, @idCliente = {idCliente}, @estadoOperacion = @estadoOperacion OUTPUT;");

            // Paso 14: Retornar true en el payload
            return ResponseManager.Ok<bool>("Inscripción reagendada exitosamente", true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "[ReagendarInscripcionAsync] Error al reagendar inscripción {IdInscripcion}", idInscripcion);

            return ResponseManager.InternalServerError<bool>("Error interno del servidor");
        }
    }
}