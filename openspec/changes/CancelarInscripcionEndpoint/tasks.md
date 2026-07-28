# Tasks: `CancelarInscripcionEndpoint`

## Review Workload Forecast

- **Estimated changed lines**: ~60 (2 files: controller + DTO)
- **400-line budget risk**: Low
- **Chained PRs recommended**: No
- **Decision needed before apply**: No

## Task List

### Phase 1: DTO

- [x] **1.1** Crear `CancelarInscripcionRequest` en `DTO/Dtos/`:
  - Propiedad `IdInscripcion` con `[Required]` y `[Range(1, int.MaxValue)]`
  - Usar DataAnnotations para validación automática

### Phase 2: Controller Endpoint

- [x] **2.1** Agregar endpoint `CancelarInscripcion` en `InscripcionesController.cs`:
  - Ruta: `POST api/inscripciones/cancelar`
  - Atributo: `[Authorize(Roles = "empleado")]`
  - Parámetro: `[FromBody] CancelarInscripcionRequest request`
  - Validación de GUID del usuario autenticado
  - Validación de existencia del usuario en BD
  - Llamada a `_service.CancelarInscripcionAsync(request.IdInscripcion)`
  - Respuesta via `Responder(result)` helper
  - Try/catch con logging

### Phase 3: Build Verification

- [ ] **3.1** Compilar solución para verificar que no hay errores
- [ ] **3.2** Ejecutar tests existentes para asegurar que no se rompió nada

## Dependencies

- `IInscripcionesService` con método `CancelarInscripcionAsync` (ya existe)
- `IValidadorUsuarioExistente` (ya existe)
- `CancelarInscripcionRequest` DTO (creado)
