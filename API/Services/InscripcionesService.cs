using API.Services.Validaciones;
using BL.Utils;
using BL.Validaciones;
using DataAccess.Repositories;
using DTO.Dtos;

namespace API.Services;

public class InscripcionesService : IInscripcionesService
{
    private readonly IInscripcionRepository _repository;
    private readonly ILogger<InscripcionesService> _logger;
    private readonly IValidadorFechasInscripcionesYClasesProgramadas _validadorFecha;
    private readonly IValidadorUsuarioExistente _validadorUsuario;

    public InscripcionesService(
        IInscripcionRepository repository,
        ILogger<InscripcionesService> logger,
        IValidadorFechasInscripcionesYClasesProgramadas validadorFecha,
        IValidadorUsuarioExistente validadorUsuario)
    {
        _repository = repository;
        _logger = logger;
        _validadorFecha = validadorFecha;
        _validadorUsuario = validadorUsuario;
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

            // Paso 3: Obtener inscripciones vía repository
            var inscripciones = await _repository.ObtenerInscripcionesDelClienteAsync(idUsuario);

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
            // Paso 1: Buscar inscripción con su clase programada y horarios vía repository
            var inscripcion = await _repository.ObtenerInscripcionConClaseYHorariosAsync(idInscripcion);

            // Paso 2: Validar que la inscripción exista
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

            // Paso 3: Validar fecha y hora de la clase usando el validador
            var horaInicio = claseProgramada.HorariosDeClasesProgramada
                .Select(h => h.FkHorarioLaboralNavigation.HoraInicio)
                .DefaultIfEmpty()
                .First();

            var (esValido, mensajeError) = _validadorFecha.Validar(fechaClase, horaInicio);

            if (!esValido)
            {
                return ResponseManager.BadRequest<bool>(mensajeError, $"idInscripcion|{mensajeError}");
            }

            // Paso 4: Ejecutar el procedimiento almacenado de cancelación vía repository
            await _repository.EjecutarCancelacionAsync(idInscripcion);

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

            // Paso 4: Buscar la inscripción vía repository
            var inscripcion = await _repository.ObtenerInscripcionConClaseYHorariosAsync(idInscripcion);

            // Paso 5: Si la inscripción no existe, retornar error 404
            if (inscripcion is null)
            {
                return ResponseManager.NotFound<bool>(
                    "Inscripción no encontrada",
                    "idInscripcion|La inscripción especificada no existe.");
            }

            // Paso 6: Buscar la clase programada destino vía repository
            var claseDestino = await _repository.ObtenerClaseProgramadaConHorariosAsync(idClaseProgramada);

            // Paso 7: Si la clase programada destino no existe, retornar error 404
            if (claseDestino is null)
            {
                return ResponseManager.NotFound<bool>(
                    "Clase programada no encontrada",
                    "idClaseProgramada|La clase programada destino especificada no existe.");
            }

            // Paso 8: Validar que el tipo de clase (fkClase) de la clase programada destino
            //          coincida con el de la clase programada original
            if (inscripcion.FkProgramacionClaseNavigation.FkClase != claseDestino.FkClase)
            {
                return ResponseManager.BadRequest<bool>(
                    "Datos inválidos",
                    "idClaseProgramada|El tipo de clase de la clase programada destino no coincide con el tipo de clase de la inscripción original.");
            }

            // Paso 9: Validar fecha y hora de la clase programada ORIGINAL
            var claseOriginal = inscripcion.FkProgramacionClaseNavigation;

            if (!claseOriginal.FechaDeLaClase.HasValue)
            {
                _logger.LogError("[ReagendarInscripcionAsync] La clase programada original {IdProgramacionClase} no tiene fecha asignada", claseOriginal.IdProgramacionClase);
                return ResponseManager.InternalServerError<bool>("Error interno del servidor");
            }

            var horaInicioOriginal = claseOriginal.HorariosDeClasesProgramada
                .Select(h => h.FkHorarioLaboralNavigation.HoraInicio)
                .DefaultIfEmpty()
                .First();

            var (validoOrig, errorOrig) = _validadorFecha.Validar(claseOriginal.FechaDeLaClase.Value, horaInicioOriginal);

            if (!validoOrig)
            {
                return ResponseManager.BadRequest<bool>(errorOrig, $"idInscripcion|{errorOrig}");
            }

            // Paso 10: Validar que la fecha de la clase original sea menor a la de la clase destino
            if (!claseDestino.FechaDeLaClase.HasValue)
            {
                _logger.LogError("[ReagendarInscripcionAsync] La clase programada destino {IdProgramacionClase} no tiene fecha asignada", claseDestino.IdProgramacionClase);
                return ResponseManager.InternalServerError<bool>("Error interno del servidor");
            }

            if (claseOriginal.FechaDeLaClase.Value > claseDestino.FechaDeLaClase.Value)
            {
                return ResponseManager.BadRequest<bool>(
                    "Datos inválidos",
                    "idClaseProgramada|La fecha de la clase programada original debe ser menor a la fecha de la clase programada destino.");
            }

            // Paso 11: Validar fecha y hora de la clase programada DESTINO
            var horaInicioDestino = claseDestino.HorariosDeClasesProgramada
                .Select(h => h.FkHorarioLaboralNavigation.HoraInicio)
                .DefaultIfEmpty()
                .First();

            var (esValido, mensajeError) = _validadorFecha.Validar(claseDestino.FechaDeLaClase.Value, horaInicioDestino);

            if (!esValido)
            {
                return ResponseManager.BadRequest<bool>(mensajeError, $"idClaseProgramada|{mensajeError}");
            }

            // Paso 12: Ejecutar el procedimiento almacenado de reagendación vía repository
            await _repository.EjecutarReagendacionAsync(idInscripcion, idClaseProgramada, idCliente);

            // Paso 13: Retornar true en el payload
            return ResponseManager.Ok<bool>("Inscripción reagendada exitosamente", true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "[ReagendarInscripcionAsync] Error al reagendar inscripción {IdInscripcion}", idInscripcion);

            return ResponseManager.InternalServerError<bool>("Error interno del servidor");
        }
    }

    // ──────────────────────────────────────────────
    //  LimpiarPreReservasEspecificasAsync
    //  Spec 82: Limpieza de pre-reservas tras inscripción exitosa
    // ──────────────────────────────────────────────

    public async Task<DTOResponse<bool>> LimpiarPreReservasEspecificasAsync(int fkHoraLaboral, DateOnly fechaReservada, int idClase, string idEntrenador)
    {
        try
        {
            // Paso 1: Buscar las pre-reservas que coinciden con los datos de la clase programada
            var preReservas = await _repository.EncontrarPreReservasAsync(
                fkHoraLaboral, fechaReservada, idClase, idEntrenador);

            // Paso 2: Si no hay pre-reservas, no hay nada que limpiar
            if (preReservas.Count == 0)
            {
                _logger.LogInformation(
                    "[LimpiarPreReservasEspecificasAsync] No hay pre-reservas para limpiar fkHoraLaboral={FkHoraLaboral} fechaReservada={FechaReservada} idClase={IdClase} idEntrenador={IdEntrenador}",
                    fkHoraLaboral, fechaReservada, idClase, idEntrenador);
                return ResponseManager.Ok<bool>("No hay pre-reservas para limpiar", true);
            }

            // Paso 3: Logear las pre-reservas encontradas que van a procesarse
            var idsEncontrados = preReservas.Select(p => p.IdPreReserva).ToList();
            _logger.LogInformation(
                "[LimpiarPreReservasEspecificasAsync] Se encontraron {Cantidad} pre-reservas para limpiar: {Ids}",
                idsEncontrados.Count, string.Join(", ", idsEncontrados));

            // Paso 4: Regla de negocio — las pre-reservas con IdEntrenador null son un error
            //         de negocio: se ignoran (no se eliminan) y se loguean como no-procesables
            var idsNoProcesables = preReservas
                .Where(p => p.IdEntrenador is null)
                .Select(p => p.IdPreReserva)
                .ToList();

            if (idsNoProcesables.Count > 0)
            {
                _logger.LogError(
                    "[LimpiarPreReservasEspecificasAsync] Pre-reservas con IdEntrenador null (error de negocio, no-procesables, NO se eliminan): {Ids}",
                    string.Join(", ", idsNoProcesables));
            }

            var idsValidos = preReservas
                .Where(p => p.IdEntrenador is not null)
                .Select(p => p.IdPreReserva)
                .ToList();

            if (idsValidos.Count == 0)
            {
                _logger.LogWarning(
                    "[LimpiarPreReservasEspecificasAsync] No hay pre-reservas válidas para eliminar (todas tienen IdEntrenador null) fkHoraLaboral={FkHoraLaboral} idClase={IdClase}",
                    fkHoraLaboral, idClase);
                return ResponseManager.Ok<bool>("No hay pre-reservas válidas para limpiar", true);
            }

            // Paso 5: Eliminar las pre-reservas válidas vía repository
            int eliminadas = await _repository.EliminarPreReservasEspecificasAsync(idsValidos);

            // Paso 6: Si se eliminaron todas las esperadas → éxito
            if (eliminadas == idsValidos.Count)
            {
                _logger.LogInformation(
                    "[LimpiarPreReservasEspecificasAsync] Pre-reservas eliminadas correctamente: {Ids}",
                    string.Join(", ", idsValidos));
                return ResponseManager.Ok<bool>("Pre-reservas limpiadas correctamente", true);
            }

            // Paso 7: Si alguna no se eliminó → loguear ids no eliminados y retornar false
            _logger.LogError(
                "[LimpiarPreReservasEspecificasAsync] No se pudieron eliminar todas las pre-reservas. Esperadas={Esperadas} Eliminadas={Eliminadas}. Pre-reservas pendientes de revisión: {Ids}",
                idsValidos.Count, eliminadas, string.Join(", ", idsValidos));
            return ResponseManager.Ok<bool>("No se pudieron eliminar todas las pre-reservas", false);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex,
                "[LimpiarPreReservasEspecificasAsync] Error al limpiar pre-reservas fkHoraLaboral={FkHoraLaboral} fechaReservada={FechaReservada} idClase={IdClase} idEntrenador={IdEntrenador}",
                fkHoraLaboral, fechaReservada, idClase, idEntrenador);

            return ResponseManager.InternalServerError<bool>("Error interno del servidor");
        }
    }
}