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
                return ResponseManager.BuildResponse<bool>(
                    success: false,
                    httpCode: 400,
                    message: "Datos inválidos",
                    errors: new List<ErrorModel>
                    {
                        new() { propiedad = "idInscripcion", message = "El ID de inscripción debe ser mayor a 0." }
                    },
                    payload: false);
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
                return ResponseManager.BuildResponse<bool>(
                    success: false,
                    httpCode: 404,
                    message: "Inscripción no encontrada",
                    errors: new List<ErrorModel>
                    {
                        new() { propiedad = "idInscripcion", message = "La inscripción especificada no existe." }
                    },
                    payload: false);
            }

            var claseProgramada = inscripcion.FkProgramacionClaseNavigation;

            if (!claseProgramada.FechaDeLaClase.HasValue)
            {
                _logger.LogError("[CancelarInscripcionAsync] La clase programada {IdProgramacionClase} no tiene fecha asignada", claseProgramada.IdProgramacionClase);
                return ResponseManager.BuildResponse<bool>(
                    success: false,
                    httpCode: 500,
                    message: "Error interno del servidor",
                    errors: new List<ErrorModel>
                    {
                        new() { message = "La clase programada no tiene una fecha asignada.", propiedad = null }
                    },
                    payload: false);
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
                return ResponseManager.BuildResponse<bool>(
                    success: false,
                    httpCode: 400,
                    message: mensajeError,
                    errors: new List<ErrorModel>
                    {
                        new() { propiedad = "idInscripcion", message = mensajeError }
                    },
                    payload: false);
            }

            // Paso 5: Ejecutar el procedimiento almacenado de cancelación
            await _context.Database.ExecuteSqlInterpolatedAsync(
                $@"EXEC dbo.sp_procesoCompletoCancelacionDeInscripcionAClase @idInscripcion = {idInscripcion}");

            return ResponseManager.BuildResponse<bool>(
                success: true,
                httpCode: 200,
                message: "Inscripción cancelada exitosamente",
                errors: null,
                payload: true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "[CancelarInscripcionAsync] Error al cancelar inscripción {IdInscripcion}", idInscripcion);

            return ResponseManager.BuildResponse<bool>(
                success: false,
                httpCode: 500,
                message: "Error interno del servidor",
                errors: new List<ErrorModel>
                {
                    new() { message = "Ocurrió un error al cancelar la inscripción.", propiedad = null }
                },
                payload: false);
        }
    }
}
