# Proposal: `CancelarInscripcionEndpoint`

## Intent

Crear un endpoint POST en la API que permita a usuarios con rol `empleado` cancelar una inscripción, validando la identidad del usuario autenticado y delegando la lógica de negocio al servicio `CancelarInscripcionAsync` del `InscripcionesService`.

## Scope

### In Scope
- Endpoint `POST api/inscripciones/cancelar` en `InscripcionesController`
- DTO `CancelarInscripcionRequest` con validación de `IdInscripcion > 0`
- Validación de usuario autenticado (GUID + existencia en BD)
- Llamada al servicio `IInscripcionesService.CancelarInscripcionAsync`

### Out of Scope
- No modifica la lógica de negocio de cancelación (ya existe en el service)
- No crea nuevos servicios ni repositorios
- No modifica la BD ni SPs existentes
- No afecta otros endpoints del controller

## Approach

El endpoint sigue el mismo patrón que los endpoints existentes en `InscripcionesController`:

| Paso | Descripción |
|------|-------------|
| 1 | Extraer ID del usuario autenticado del JWT (`ClaimTypes.NameIdentifier`) |
| 2 | Validar formato GUID del ID de usuario |
| 3 | Validar existencia del usuario en BD via `IValidadorUsuarioExistente` |
| 4 | Recibir `CancelarInscripcionRequest` con `IdInscripcion` (validado por DataAnnotations) |
| 5 | Delegar al service `CancelarInscripcionAsync(idInscripcion)` |
| 6 | Retornar respuesta con `Responder()` helper (mapea DTOResponse HTTP code → IActionResult) |

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `API/Controllers/InscripcionesController.cs` | Modified | Nuevo endpoint `CancelarInscripcion` |
| `DTO/Dtos/CancelarInscripcionRequest.cs` | New | DTO request con validaciones |
| `openspec/changes/CancelarInscripcionEndpoint/` | New | Artifacts SDD |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Usuario autenticado no existe en BD | Low | Validación con `IValidadorUsuarioExistente` antes de procesar |
| Token JWT sin NameIdentifier | Low | `Guid.TryParse` valida formato; si falla, retorna 400 |
| idInscripcion inválido | Low | `[Range(1, int.MaxValue)]` en DTO + validación en service |

## Rollback Plan

Revertir el endpoint en `InscripcionesController.cs` y eliminar `CancelarInscripcionRequest.cs`.

## Dependencies

- `IInscripcionesService.CancelarInscripcionAsync` (ya existe)
- `IValidadorUsuarioExistente` (ya existe)
- `CancelarInscripcionRequest` DTO (crear)

## Success Criteria

- [ ] Endpoint POST con ruta `api/inscripciones/cancelar`
- [ ] Autenticación JWT requerida con rol `empleado`
- [ ] Validación de ID de usuario con GUID format
- [ ] Validación de existencia de usuario en BD
- [ ] Validación de request body e idInscripcion
- [ ] Llamada al servicio `CancelarInscripcionAsync`
- [ ] Respuesta exitosa sin data sensible
- [ ] Manejo de errores con ResponseManager
- [ ] Logging con ILogger
