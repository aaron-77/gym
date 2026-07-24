# Proposal: Refactor Inscripciones — Repository + DIP

## 1. Intent

Aplicar Dependency Inversion Principle al feature de Inscripciones introduciendo un Repository que encapsule TODO el acceso a datos. El Service deja de depender de EF Core (`FitnessCenterDbContext`) y de `IDataAccessExecutor` directamente, y depende únicamente del Repository.

## 2. Alcance

| Archivo | Acción |
|---------|--------|
| `DataAccess/Repositories/IInscripcionRepository.cs` | **Crear** — interface del repository |
| `DataAccess/Repositories/InscripcionRepository.cs` | **Crear** — implementación con EF + IDataAccessExecutor |
| `API/Services/IInscripcionesService.cs` | **Sin cambios** — el contrato público se mantiene |
| `API/Services/InscripcionesService.cs` | **Modificar** — inyectar IInscripcionRepository en vez de DbContext + IDataAccessExecutor |
| `API/Controllers/InscripcionesController.cs` | **Modificar** — reemplazar UserManager directo en el GET con IValidadorUsuarioExistente |
| `API/Program.cs` | **Modificar** — registrar IInscripcionRepository en DI |

### Queda fuera del alcance

- Crear un `UserRepository` — el controller usa `IValidadorUsuarioExistente` que ya abstrae UserManager. Si después queremos migrar eso, es otro cambio.
- Tests — se harán en un cambio aparte.
- Otros servicios/features — solo Inscripciones.

## 3. Approach

### ¿Dónde ubicar el Repository?

En `DataAccess.Repositories` (carpeta nueva en el proyecto DataAccess).

**Razones:**
- DataAccess es la capa de persistencia, es su responsabilidad.
- El Repository no necesita `ResponseManager`, `BL.Utils`, ni validators de API — solo EF Core y DTOs.
- DataAccess ya tiene referencia a DTO, puede devolver DTOs o entidades según convenga.
- API ya referencia DataAccess, puede inyectar el Repository sin problemas.

### ¿Qué métodos debe tener el Repository?

```csharp
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

### Flujo después del refactor

```
Controller
  → IInscripcionesService (inyectado)
    → IInscripcionRepository (inyectado, nuevo)
      → FitnessCenterDbContext (EF) — queries de lectura
      → IDataAccessExecutor — SPs y SQL directo
    → IValidadorFechasInscripcionesYClasesProgramadas — validación de negocio (se queda en Service)
    → IValidadorUsuarioExistente — validación de existencia de usuario (se queda en Service, también en Controller)
```

### Separación de responsabilidades

| Responsabilidad | Dueño |
|----------------|-------|
| Validar formato de ID | Service (hoy usa ValidadorStringId estático) |
| Validar que usuario existe | Service (vía IValidadorUsuarioExistente) |
| Validar que inscripción existe | Service (Repository devuelve null, Service decide qué hacer) |
| Validar fecha/hora de clase | Service (vía IValidadorFechas) |
| Obtener datos de BD | Repository |
| Ejecutar SPs | Repository |
| Construir DTOResponse | Service |

### ¿Entidades del DbContext o DTOs?

El Repository puede devolver **entidades del DbContext** (`InscripcionesDeClase`, `ClasesProgramada`) para las queries complejas (Include/ThenInclude), porque el Service necesita navegar propiedades de navegación para las validaciones de negocio.

Para la consulta de inscripciones del cliente, el Repository devuelve directamente `DTOInscripcionDelCliente` (viene de una función SQL).

### Controller

El GET actual valida el usuario autenticado con:
```csharp
if (!string.IsNullOrEmpty(authenticatedUserId))
{
    var authenticatedUser = await _userManager.FindByIdAsync(authenticatedUserId);
    ...
}
```

Se refactoriza para usar `IValidadorUsuarioExistente` (igual que ya hicimos en el POST). El `UserManager<ApplicationUser>` se elimina del controller si no se necesita para otra cosa.

## 4. Riesgos

- **Rompemos tests existentes**: Los tests de integración de `ServiceCancelarInscripcionTests` prueban directamente `InscripcionesService`. Si cambiamos el constructor, los tests hay que actualizarlos para pasar el nuevo dependency.
- **El Repository en DataAccess no tiene acceso a ResponseManager**: Correcto — el Repository no debe devolver DTOResponse, solo datos crudos o null.
- **Mezcla de EF + SQL**: El Repository oculta esta complejidad, el Service no sabe si la implementación usa EF o SQL directo.

## 5. Criterios de éxito

- [ ] `IInscripcionRepository` creado en `DataAccess.Repositories` con métodos para leer y escribir
- [ ] `InscripcionRepository` implementado usando `FitnessCenterDbContext` + `IDataAccessExecutor`
- [ ] `InscripcionesService` ya no depende de `FitnessCenterDbContext` ni `IDataAccessExecutor`
- [ ] `InscripcionesService` depende de `IInscripcionRepository`
- [ ] Controller usa `IValidadorUsuarioExistente` en lugar de `UserManager.FindByIdAsync` en el GET
- [ ] Build exitoso, 0 errores
- [ ] Todos los tests del service siguen pasando (o se actualizan)
