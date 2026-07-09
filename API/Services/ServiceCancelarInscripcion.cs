using Microsoft.EntityFrameworkCore;

using BL.Utils;
using BL.Validaciones;
using DataAccess.EntityFramework;
using DTO.Dtos;

namespace API.Services;

public class ServiceCancelarInscripcion : IServiceCancelarInscripcion
{
    private readonly FitnessCenterDbContext _context;
    private readonly ILogger<ServiceCancelarInscripcion> _logger;
    private readonly IValidadorFechaCancelacionInscripcion _validadorFecha;

    public ServiceCancelarInscripcion(
        FitnessCenterDbContext context,
        ILogger<ServiceCancelarInscripcion> logger,
        IValidadorFechaCancelacionInscripcion validadorFecha)
    {
        _context = context;
        _logger = logger;
        _validadorFecha = validadorFecha;
    }

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
            await _context.Database.ExecuteSqlInterpolatedAsync(
                $@"EXEC dbo.sp_procesoCompletoCancelacionDeInscripcionAClase @idInscripcion = {idInscripcion}");

            return ResponseManager.Ok<bool>("Inscripción cancelada exitosamente", true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "[CancelarInscripcionAsync] Error al cancelar inscripción {IdInscripcion}", idInscripcion);

            return ResponseManager.InternalServerError<bool>("Error interno del servidor");
        }
    }
}
