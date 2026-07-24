# Spec: Refactor Inscripciones — Repository + DIP

## 1. Resumen

Aplicar Dependency Inversion al feature de Inscripciones: el Service delega todo el acceso a datos en un Repository, el Controller interpreta el resultado del Service para devolver HTTP codes correctos.

## 2. Contratos

### 2.1 IInscripcionRepository (nuevo — `DataAccess/Repositories/`)

```csharp
namespace DataAccess.Repositories;

public interface IInscripcionRepository
{
    // Consultas
    Task<List<DTOInscripcionDelCliente>> ObtenerInscripcionesDelClienteAsync(string idUsuario);
    Task<InscripcionesDeClase?> ObtenerInscripcionConClaseYHorariosAsync(int idInscripcion);
    Task<ClasesProgramada?> ObtenerClaseProgramadaConHorariosAsync(int idClaseProgramada);

    // Comandos
    Task EjecutarCancelacionAsync(int idInscripcion);
    Task EjecutarReagendacionAsync(int idInscripcion, int idClaseProgramada, string idCliente);
}
```

| Método | Recibe | Retorna | Qué hace | Excepciones |
|--------|--------|---------|----------|-------------|
| `ObtenerInscripcionesDelClienteAsync` | `string idUsuario` | `List<DTOInscripcionDelCliente>` | Ejecuta `fn_obtenerInscripcionesDelCliente` vía IDataAccessExecutor | `InvalidOperationException` |
| `ObtenerInscripcionConClaseYHorariosAsync` | `int idInscripcion` | `InscripcionesDeClase?` | EF query con Include de clase programada, horarios y horas laborales | `InvalidOperationException` |
| `ObtenerClaseProgramadaConHorariosAsync` | `int idClaseProgramada` | `ClasesProgramada?` | EF query con Include de horarios y horas laborales | `InvalidOperationException` |
| `EjecutarCancelacionAsync` | `int idInscripcion` | `void` | Ejecuta `sp_procesoCompletoCancelacionDeInscripcionAClase` vía IDataAccessExecutor | `InvalidOperationException` |
| `EjecutarReagendacionAsync` | `int idInscripcion, int idClaseProgramada, string idCliente` | `void` | Ejecuta `sp_procesoCompletoReagendacionDeInscripcion` vía IDataAccessExecutor | `InvalidOperationException` |

**Reglas del Repository:**
- NO devuelve `DTOResponse<T>` — devuelve datos crudos o null
- NO recibe `ILogger` — las excepciones se propagan, el Service loggea
- Sigue el patrón de `ClasesRepository`: catch + `throw InvalidOperationException`
- Usa `FitnessCenterDbContext` (EF) e `IDataAccessExecutor` inyectados

### 2.2 InscripcionesService (modificado — `API/Services/`)

**Dependencias nuevas:** `IInscripcionRepository`

**Dependencias que se eliminan:** `FitnessCenterDbContext`, `IDataAccessExecutor`

**Dependencias que se mantienen:** `ILogger<InscripcionesService>`, `IValidadorFechasInscripcionesYClasesProgramadas`, `IValidadorUsuarioExistente`

**Interface** `IInscripcionesService`: **SIN CAMBIOS** — el contrato público es el mismo.

**Comportamiento de cada método:**

| Método | Validaciones (Service) | Acceso a datos (Repository) | Errores |
|--------|----------------------|----------------------------|---------|
| `ConsultarInscripcionesDeClienteAsync` | ValidadorStringId + IValidadorUsuarioExistente | `_repository.ObtenerInscripcionesDelClienteAsync()` | 400, 404, 500 |
| `CancelarInscripcionAsync` | Guard clause idInscripcion + null check + IValidadorFechas | `_repository.ObtenerInscripcionConClaseYHorariosAsync()` + `_repository.EjecutarCancelacionAsync()` | 400, 404, 500 |
| `ReagendarInscripcionAsync` | Guard clauses + null checks + IValidadorFechas + regla de tipo de clase + regla fecha original < fecha destino | `_repository.ObtenerInscripcionConClaseYHorariosAsync()` + `_repository.ObtenerClaseProgramadaConHorariosAsync()` + `_repository.EjecutarReagendacionAsync()` | 400, 404, 500 |

### 2.3 InscripcionesController (modificado — `API/Controllers/`)

**Dependencias que se eliminan:** `UserManager<ApplicationUser>`

**Dependencias que se mantienen:** `IInscripcionesService`, `IValidadorUsuarioExistente`, `ILogger`

**Nuevo helper:**
```csharp
private IActionResult Responder<T>(DTOResponse<T> result) =>
    result.success ? Ok(result) : StatusCode(result.httpCode, result);
```

**GET ObtenerInscripcionesDelCliente:**
- Reemplazar validación de usuario autenticado con `IValidadorUsuarioExistente`
- Usar `Responder()` en lugar de `Ok()` directo

**POST CancelarInscripcion:**
- Ya usa `IValidadorUsuarioExistente` (refactorizado previamente)
- Usar `Responder()` en lugar de `Ok()` directo

## 3. Dependencias entre capas

```
Controller (API/Controllers)
  → IInscripcionesService (API/Services)     — inyectado
    → IInscripcionRepository (DataAccess/Repositories)  — inyectado (NUEVO)
      → FitnessCenterDbContext (EF)
      → IDataAccessExecutor
    → IValidadorFechasInscripcionesYClasesProgramadas (API/Services/Validaciones)
    → IValidadorUsuarioExistente (API/Services/Validaciones)
  → IValidadorUsuarioExistente (API/Services/Validaciones)  — inyectado (para validar user autenticado)
```

## 4. Registro en DI

En `DataAccessServiceCollectionExtensions.cs`:
```csharp
services.AddScoped<IInscripcionRepository, InscripcionRepository>();
```

## 5. Manejo de errores

| Capa | Cómo maneja errores |
|------|--------------------|
| Repository | Catch + `throw InvalidOperationException`. NO loggea. |
| Service | Catch de `InvalidOperationException` del repository + catch de `Exception` general. Loggea con `_logger.LogError`. Retorna `DTOResponse<T>` con código 500. |
| Controller | Usa `Responder()` — interpreta `result.success` + `result.httpCode` del Service para devolver el HTTP status correcto. |

## 6. Archivos a crear/modificar

| Archivo | Acción |
|---------|--------|
| `DataAccess/Repositories/IInscripcionRepository.cs` | Crear |
| `DataAccess/Repositories/InscripcionRepository.cs` | Crear |
| `DataAccess/DataAccessServiceCollectionExtensions.cs` | Modificar — agregar registro |
| `API/Services/InscripcionesService.cs` | Modificar — cambiar dependencias |
| `API/Controllers/InscripcionesController.cs` | Modificar — refactor user validation GET + responder pattern |

## 7. Criterios de aceptación

- [ ] `IInscripcionRepository` existe en `DataAccess.Repositories` con los 5 métodos especificados
- [ ] `InscripcionRepository` implementa los 5 métodos usando `FitnessCenterDbContext` + `IDataAccessExecutor`
- [ ] El repository NO devuelve `DTOResponse<T>`, solo datos crudos
- [ ] El repository captura excepciones y relanza `InvalidOperationException`
- [ ] `InscripcionesService` ya NO depende de `FitnessCenterDbContext` ni `IDataAccessExecutor`
- [ ] `InscripcionesService` depende de `IInscripcionRepository`
- [ ] `IInscripcionesService` no cambia su interface
- [ ] `InscripcionesController` ya NO depende de `UserManager<ApplicationUser>`
- [ ] `InscripcionesController` usa `IValidadorUsuarioExistente` en el GET (reemplazando UserManager directo)
- [ ] `InscripcionesController` usa `Responder()` en ambos endpoints para HTTP codes correctos
- [ ] `IInscripcionRepository` registrado en DI en `DataAccessServiceCollectionExtensions.cs`
- [ ] Build exitoso, 0 errores
