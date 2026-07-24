# Tasks: Refactor Inscripciones — Repository + DIP

## Review Workload Forecast

- **Estimated changed lines**: ~250 (120 nuevo repository + 80 service refactor + 50 controller refactor)
- **400-line budget risk**: Low
- **Chained PRs recommended**: No
- **Decision needed before apply**: No

## Tasks

### T1: Crear IInscripcionRepository (DataAccess/Repositories/)
- Archivo: `DataAccess/Repositories/IInscripcionRepository.cs`
- 5 métodos definidos en el design
- Namespace `DataAccess.Repositories`
- Usar `DTO.Dtos` para `DTOInscripcionDelCliente` y `DataAccess.EntityFramework` para las entidades

### T2: Crear InscripcionRepository (DataAccess/Repositories/)
- Archivo: `DataAccess/Repositories/InscripcionRepository.cs`
- Implementar los 5 métodos
- Inyectar `FitnessCenterDbContext` + `IDataAccessExecutor`
- Cada método: try/catch → `throw new InvalidOperationException`
- Namespace `DataAccess.Repositories`

### T3: Registrar IInscripcionRepository en DI
- Archivo: `DataAccess/DataAccessServiceCollectionExtensions.cs`
- Agregar: `services.AddScoped<IInscripcionRepository, InscripcionRepository>();`

### T4: Refactorizar InscripcionesService
- Archivo: `API/Services/InscripcionesService.cs`
- Sacar del constructor: `FitnessCenterDbContext`, `IDataAccessExecutor`
- Agregar al constructor: `IInscripcionRepository`
- Actualizar los 3 métodos para usar `_repository` en vez de `_context` y `_dbExecutor`

### T5: Refactorizar InscripcionesController
- Archivo: `API/Controllers/InscripcionesController.cs`
- Sacar `UserManager<ApplicationUser>` del constructor y del archivo
- Agregar `IValidadorUsuarioExistente` al constructor (ya se agregó para el POST, verificar que el GET también lo use)
- Implementar helper `Responder<T>()`
- GET: reemplazar `UserManager.FindByIdAsync` con `_validadorUsuario.ValidarAsync`, cambiar `return Ok(result)` por `return Responder(result)`
- POST: cambiar `return Ok(result)` por `return Responder(result)`

### T6: Build y verificación
- `dotnet build` sin errores
- Verificar que no hay referencias residuales a `UserManager` en el controller
- Verificar que no hay referencias a `FitnessCenterDbContext` o `IDataAccessExecutor` en el service

## Orden de ejecución

```
T1 → T2 → T3 → T4 → T5 → T6
```

Cada tarea depende de la anterior (T3 necesita T1+T2, T4 necesita T3, etc.).
