# Proposal: Reagendar Inscripción - Endpoint API

## Intent

Crear un endpoint POST en el API Controller existente que permita reagendar una inscripción, siguiendo el spec 43 ya definido. La lógica de negocio (ServiceReagendarInscripcion) ya existe y está testeada.

## Scope

### In Scope
- Endpoint POST `api/inscripciones/reagendar` en `InscripcionesController.cs`
- Request DTO `ReagendarInscripcionRequest`
- Validaciones: GUID usuario, existencia usuario BD, request body, idInscripcion > 0, idClaseProgramada > 0, idCliente no vacío
- Llamada a `_service.ReagendarInscripcionAsync`
- Respuesta exitosa sin data

### Out of Scope
- Implementación del servicio (spec 39, ya existe)
- Tests del servicio (spec 40, ya existen)
- Frontend
- Otros endpoints o modificaciones

## Capabilities

### New Capabilities
None

### Modified Capabilities
None (implementation-only change per spec 43)

## Approach

Agregar método `ReagendarInscripcion` al `InscripcionesController` siguiendo EXACTAMENTE el patrón de `CancelarInscripcion`:
1. Obtener ID usuario autenticado del JWT
2. Validar GUID con `Guid.TryParse`
3. Validar existencia en BD con `IValidadorUsuarioExistente`
4. Validar request body y campos individuales
5. Llamar a `_service.ReagendarInscripcionAsync`
6. Retornar respuesta con `this.Responder()`

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `API/Controllers/InscripcionesController.cs` | Modify | Add new endpoint method |
| `DTO/Dtos/ReagendarInscripcionRequest.cs` | Create | Request DTO |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Seguir patrón existente incorrectamente | Low | CancelarInscripcion es idéntico en estructura |
| Request DTO duplicado | Low | Verificar que no exista ya un DTO similar |

## Rollback Plan

Revert el cambio en el controller vía `git revert`.

## Success Criteria

- [ ] Endpoint responde 200 con éxito para datos válidos
- [ ] Endpoint rechaza request sin auth (401)
- [ ] Endpoint rechaza request sin rol empleado (403)
- [ ] Endpoint rechaza idInscripcion <= 0 (400)
- [ ] Endpoint rechaza idClaseProgramada <= 0 (400)
- [ ] Endpoint rechaza idCliente vacío (400)
- [ ] Endpoint rechaza usuario sin GUID válido (400)
- [ ] Endpoint rechaza usuario inexistente en BD (404)
