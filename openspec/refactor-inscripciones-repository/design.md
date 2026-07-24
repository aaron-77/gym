# Design: Refactor Inscripciones — Repository + DIP

## 1. Arquitectura

### 1.1 Diagrama de dependencias (antes)

```
InscripcionesController
  → IInscripcionesService → InscripcionesService
      → FitnessCenterDbContext (EF)
      → IDataAccessExecutor
      → IValidadorFechas...
      → IValidadorUsuarioExistente
      → ILogger
  → UserManager<ApplicationUser>   ← usado directo en GET y POST
  → ILogger
```

### 1.2 Diagrama de dependencias (después)

```
InscripcionesController
  → IInscripcionesService → InscripcionesService
      → IInscripcionRepository → InscripcionRepository (NUEVO)
          → FitnessCenterDbContext (EF)
          → IDataAccessExecutor
      → IValidadorFechas...
      → IValidadorUsuarioExistente
      → ILogger
  → IValidadorUsuarioExistente   ← reemplaza UserManager directo
  → ILogger
```

## 2. InscripcionRepository

### 2.1 Interface

```csharp
namespace DataAccess.Repositories;

public interface IInscripcionRepository
{
    Task<List<DTOInscripcionDelCliente>> ObtenerInscripcionesDelClienteAsync(string idUsuario);
    Task<InscripcionesDeClase?> ObtenerInscripcionConClaseYHorariosAsync(int idInscripcion);
    Task<ClasesProgramada?> ObtenerClaseProgramadaConHorariosAsync(int idClaseProgramada);
    Task EjecutarCancelacionAsync(int idInscripcion);
    Task EjecutarReagendacionAsync(int idInscripcion, int idClaseProgramada, string idCliente);
}
```

### 2.2 Implementación

```csharp
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
                    $"SELECT * FROM dbo.fn_obtenerInscripcionesDelCliente({idUsuario})");
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
```

## 3. InscripcionesService (refactorizado)

### 3.1 Constructor y dependencias

```csharp
public class InscripcionesService : IInscripcionesService
{
    private readonly IInscripcionRepository _repository;      // NUEVO — reemplaza DbContext + DataAccessExecutor
    private readonly ILogger<InscripcionesService> _logger;    // se mantiene
    private readonly IValidadorFechasInscripcionesYClasesProgramadas _validadorFecha; // se mantiene
    private readonly IValidadorUsuarioExistente _validadorUsuario; // se mantiene

    public InscripcionesService(
        IInscripcionRepository repository,                    // NUEVO
        ILogger<InscripcionesService> logger,                  // se mantiene
        IValidadorFechasInscripcionesYClasesProgramadas validadorFecha,  // se mantiene
        IValidadorUsuarioExistente validadorUsuario)          // se mantiene
    {
        _repository = repository;
        _logger = logger;
        _validadorFecha = validadorFecha;
        _validadorUsuario = validadorUsuario;
    }
}
```

### 3.2 Método: ConsultarInscripcionesDeClienteAsync

```
1. Validar formato ID (ValidadorStringId)
2. Validar que usuario existe (IValidadorUsuarioExistente)
3. Llamar a _repository.ObtenerInscripcionesDelClienteAsync(idUsuario)
4. Retornar DTOResponse con lista
+
5. Catch InvalidOperationException → log + 500
6. Catch Exception → log + 500
```

### 3.3 Método: CancelarInscripcionAsync

```
1. Guard clause: idInscripcion <= 0 → 400
2. Llamar a _repository.ObtenerInscripcionConClaseYHorariosAsync(idInscripcion)
3. Si null → 404
4. Validar que FechaDeLaClase tenga valor
5. Obtener horaInicio de horarios
6. Validar fecha + hora con IValidadorFechas
7. Llamar a _repository.EjecutarCancelacionAsync(idInscripcion)
8. Retornar Ok(true)
+
9. Catch InvalidOperationException → log + 500
10. Catch Exception → log + 500
```

### 3.4 Método: ReagendarInscripcionAsync

```
1. Guard clauses: idInscripcion, idClaseProgramada, idCliente
2. Llamar a _repository.ObtenerInscripcionConClaseYHorariosAsync(idInscripcion)
3. Si null → 404
4. Llamar a _repository.ObtenerClaseProgramadaConHorariosAsync(idClaseProgramada)
5. Si null → 404
6. Validar que fkClase coincida entre original y destino
7. Validar fecha + hora original con IValidadorFechas
8. Validar que fecha original < fecha destino
9. Validar fecha + hora destino con IValidadorFechas
10. Llamar a _repository.EjecutarReagendacionAsync(...)
11. Retornar Ok(true)
+
12. Catch InvalidOperationException → log + 500
13. Catch Exception → log + 500
```

## 4. InscripcionesController (refactorizado)

### 4.1 Constructor y dependencias

```csharp
public class InscripcionesController : ControllerBase
{
    private readonly IInscripcionesService _service;            // se mantiene
    private readonly IValidadorUsuarioExistente _validadorUsuario;  // NUEVO (se agregó al POST, ahora también al GET)
    private readonly ILogger<InscripcionesController> _logger;     // se mantiene

    public InscripcionesController(
        IInscripcionesService service,
        IValidadorUsuarioExistente validadorUsuario,
        ILogger<InscripcionesController> logger)
    {
        _service = service;
        _validadorUsuario = validadorUsuario;
        _logger = logger;
    }
}
```

**Se elimina:** `UserManager<ApplicationUser>` — ya no es necesario porque:
- La validación de usuario autenticado se hace con `IValidadorUsuarioExistente` (tanto en GET como POST)
- La validación del cliente en el GET se delega al Service, que usa `IValidadorUsuarioExistente`

### 4.2 Helper Responder (nuevo)

```csharp
private IActionResult Responder<T>(DTOResponse<T> result) =>
    result.success ? Ok(result) : StatusCode(result.httpCode, result);
```

### 4.3 GET ObtenerInscripcionesDelCliente

```
1. try/log
2. Validar formato ID con ValidadorStringId
3. Obtener authenticatedUserId del JWT
4. Validar usuario autenticado con _validadorUsuario.ValidarAsync
   (reemplaza UserManager.FindByIdAsync directo)
5. Llamar a _service.ConsultarInscripcionesDeClienteAsync
6. Retornar Responder(resultado)  
   (reemplaza Ok(resultado))
7. catch → 500
```

**Nota:** la validación del cliente (idUsuario) la hace el Service internamente. El controller ya no necesita `UserManager`.

### 4.4 POST CancelarInscripcion

```
1. try/log
2. Validar GUID de authenticatedUserId
3. Validar usuario autenticado con _validadorUsuario.ValidarAsync
4. Llamar a _service.CancelarInscripcionAsync
5. Retornar Responder(resultado)
   (reemplaza Ok(resultado))
6. catch → 500
```

## 5. DI Registration

En `DataAccess/DataAccessServiceCollectionExtensions.cs`:

```csharp
services.AddScoped<IInscripcionRepository, InscripcionRepository>();
```

## 6. Archivos resultantes

### Creados:
- `DataAccess/Repositories/IInscripcionRepository.cs`
- `DataAccess/Repositories/InscripcionRepository.cs`

### Modificados:
- `API/Services/InscripcionesService.cs` — constructor + delegar a repository
- `API/Controllers/InscripcionesController.cs` — sacar UserManager, agregar IValidadorUsuarioExistente en GET, usar Responder()
- `DataAccess/DataAccessServiceCollectionExtensions.cs` — registro DI

### Sin cambios:
- `API/Services/IInscripcionesService.cs` — interface pública intacta
