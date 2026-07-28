# Proposal: Integration Tests for POST Reagendar Inscripcion

## Intent

Implementar 6 tests de integración para el endpoint `POST api/inscripciones/reagendar` (spec 44), cubriendo happy path, edge cases de validación y autorización. El endpoint ya fue implementado (spec 43); los tests del servicio ya existen (spec 40).

## Scope

### In Scope
- Happy path: `Reagendar_InscripcionValida_RetornaOk`
- Edge: `Reagendar_IdInscripcionCero_RetornaBadRequest`
- Edge: `Reagendar_IdClaseProgramadaCero_RetornaBadRequest`
- Edge: `Reagendar_IdClienteVacio_RetornaBadRequest`
- Edge: `Reagendar_InscripcionNoExiste_RetornaNotFound`
- Edge: `Reagendar_SinAutenticacion_RetornaUnauthorized`

### Out of Scope
- Tests unitarios (cubiertos por spec 40)
- Tests E2E (no aplican para un endpoint)
- Implementación del endpoint (spec 43, ya existe)
- Tests de autorización por rol (403) — no están en spec 44

## Capabilities

### New Capabilities
None

### Modified Capabilities
None (pure test addition)

## Approach

Nuevo archivo `GymWebApp.Tests/Integration/Features/Inscripciones/InscripcionesReagendarTests.cs` siguiendo EXACTAMENTE el patrón de `InscripcionesControllerCancelarTests.cs`:

1. **Heredar** de `IntegrationTestBase` con collection `IntegrationTests`
2. **Happy path**: `InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync()` + `InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync()` → POST con `ReagendarInscripcionRequest` → assert 200 + DTOResponse success
3. **IdInscripcionCero**: POST con `IdInscripcion = 0` → assert 400 + mensaje error
4. **IdClaseProgramadaCero**: POST con `IdClaseProgramada = 0` → assert 400 + mensaje error
5. **IdClienteVacio**: POST con `IdCliente = ""` → assert 400 + mensaje error
6. **InscripcionNoExiste**: POST con `IdInscripcion = 999999` → assert 404 + DTOResponse success=false
7. **SinAutenticacion**: POST sin auth header → assert 401

Datos de prueba generados via helpers existentes (InscripcionTestHelper, DatabaseHelper). Autenticación via `SetAuthHeaderAsync()`/`ClearAuthHeader()` de la clase base.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `GymWebApp.Tests/Integration/Features/Inscripciones/InscripcionesReagendarTests.cs` | New | Archivo con 6 tests de integración |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Helper `CreateValidDestinationClassForReagendarAsync` retorna null sin horarios | Low | Fallback con seed manual inline si no hay slot disponible |

## Rollback Plan

`rm GymWebApp.Tests/Integration/Features/Inscripciones/InscripcionesReagendarTests.cs`

## Success Criteria

- [ ] 6 tests creados, todos pasan con `dotnet test --filter Reagendar`
- [ ] Tests siguen patrón AAA + FluentAssertions + xUnit
- [ ] Sin lógica helper inline — todo via helpers existentes
