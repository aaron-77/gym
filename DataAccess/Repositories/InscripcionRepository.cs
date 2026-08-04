using Microsoft.EntityFrameworkCore;

using DataAccess.EntityFramework;
using DataAccess.Infraestructure;
using DTO.Dtos;

namespace DataAccess.Repositories;

public class InscripcionRepository : IInscripcionRepository
{
    private readonly FitnessCenterDbContext _context;
    private readonly IDataAccessExecutor _dbExecutor;

    public InscripcionRepository(FitnessCenterDbContext context, IDataAccessExecutor dbExecutor)
    {
        _context = context;
        _dbExecutor = dbExecutor;
    }

    public async Task<List<DTOInscripcionDelCliente>> ObtenerInscripcionesDelClienteAsync(string idUsuario)
    {
        try
        {
            return await _dbExecutor
                .QueryAsync<DTOInscripcionDelCliente>(
                    $"SELECT f.*, cp.fkClase FROM dbo.fn_obtenerInscripcionesDelCliente({idUsuario}) f INNER JOIN clasesProgramadas cp ON f.idClaseProgramada = cp.idProgramacionClase");
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException(
                $"Error al obtener inscripciones del cliente {idUsuario}.", ex);
        }
    }

    public async Task<InscripcionesDeClase?> ObtenerInscripcionConClaseYHorariosAsync(int idInscripcion)
    {
        try
        {
            return await _context.InscripcionesDeClases
                .Include(i => i.FkProgramacionClaseNavigation)
                    .ThenInclude(cp => cp.HorariosDeClasesProgramada)
                        .ThenInclude(h => h.FkHorarioLaboralNavigation)
                .FirstOrDefaultAsync(i => i.IdInscripcion == idInscripcion);
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException(
                $"Error al obtener la inscripción {idInscripcion}.", ex);
        }
    }

    public async Task<ClasesProgramada?> ObtenerClaseProgramadaConHorariosAsync(int idClaseProgramada)
    {
        try
        {
            return await _context.ClasesProgramadas
                .Include(cp => cp.HorariosDeClasesProgramada)
                    .ThenInclude(h => h.FkHorarioLaboralNavigation)
                .FirstOrDefaultAsync(cp => cp.IdProgramacionClase == idClaseProgramada);
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException(
                $"Error al obtener la clase programada {idClaseProgramada}.", ex);
        }
    }

    public async Task EjecutarCancelacionAsync(int idInscripcion)
    {
        try
        {
            await _dbExecutor.ExecuteAsync(
                $@"EXEC dbo.sp_procesoCompletoCancelacionDeInscripcionAClase @idInscripcion = {idInscripcion}");
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException(
                $"Error al ejecutar cancelación de inscripción {idInscripcion}.", ex);
        }
    }

    public async Task EjecutarReagendacionAsync(int idInscripcion, int idClaseProgramada, string idCliente)
    {
        try
        {
            await _dbExecutor.ExecuteAsync(
                $@"DECLARE @estadoOperacion INT;
                  EXEC dbo.sp_procesoCompletoReagendacionDeInscripcion
                      @idInscripcionCancelada = {idInscripcion},
                      @idClaseProgramadaNueva = {idClaseProgramada},
                      @idCliente = {idCliente},
                      @estadoOperacion = @estadoOperacion OUTPUT;");
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException(
                $"Error al ejecutar reagendación de inscripción {idInscripcion}.", ex);
        }
    }
}
