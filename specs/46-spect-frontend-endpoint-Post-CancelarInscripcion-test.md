# Spec: Frontend - Tests E2E Cancelar Inscripción

## 1. Resumen

Crear tests E2E para el botón Cancelar en la vista de cancelar/reagendar
inscripción, validando que el empleado autenticado pueda cancelar desde la UI
y que los casos de acceso no autorizado redirijan correctamente.

## 2. Contexto

- **Capa:** Tests (E2E)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Vista | `GET /Inscripciones/cancelarReagendar` | Vista con comboCliente, comboInscripcion y botón Cancelar | 49 |
| Endpoint | `POST /inscripciones/cancelar` | Llamado desde JS al hacer click en Cancelar | 45 |
| Helper | `InscripcionEndpointHelper.SeedFreshInscripcionAsync` | Seed de inscripciones en BD para tests | — |
| Test base | `PlaywrightTestBase` | Clase base con browser lifecycle y reset de BD | — |

### 2.2 Relación con otros tests

Los edge cases de validación (idInscripcion=0, inscripción inexistente) no se
testean como E2E porque no pueden dispararse desde la UI del browser. Están
cubiertos por tests de integración:
`Integration/Features/Inscripciones/InscripcionesControllerCancelarTests.cs`

## 3. Tests a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/E2E/Features/InscripcionesCancelarE2ETests.cs` | Tests E2E |

### 3.2 Happy path

| # | Test | Descripción | Verificación UI |
|---|------|-------------|-----------------|
| 1 | `Cancelar_InscripcionValida_RetornaOk` | Cancelar inscripción válida desde la UI | SweetAlert2 con título "Inscripción cancelada exitosamente" e icono de éxito |

### 3.3 Edge cases

| # | Test | Descripción | Verificación UI |
|---|------|-------------|-----------------|
| 2 | `Cancelar_SinAutenticacion_RetornaRedirectToLogin` | Sin autenticación redirige a login | Input `input[name='correo']` visible + URL contiene "signIn" |
| 3 | `Cancelar_UsuarioSinRolEmpleado_RetornaForbidden` | Cliente logueado no puede acceder | URL contiene "AccesoDenegado" |

### 3.4 Flujo del Happy Path

1. Login como empleado vía formulario (`/signIn`)
2. Seed de inscripción fresca en BD via `InscripcionEndpointHelper`
3. Navegar a `/Inscripciones/cancelarReagendar`
4. Seleccionar cliente del `#comboCliente`
5. Esperar que `#comboInscripcion` se habilite (inscripciones cargadas vía JS)
6. Seleccionar inscripción del `#comboInscripcion`
7. Click en `#btnEjecutar`
8. Verificar SweetAlert2: título "Inscripción cancelada exitosamente" + icono `.swal2-success`

### 3.5 Patrones a aplicar

- **xUnit:** Framework de testing
- **Playwright:** Tests E2E con navegador
- **Playwright Expect():** Aserciones sobre elementos visibles
- **Xunit Assert.Contains():** Verificación de URLs de redirect
- **GIVEN/WHEN/THEN:** Estructura de cada test (sigue patrón existente del proyecto)
- **Login inline:** Login vía UI en cada test que lo requiera (sin helpers compartidos)
- **Seed de datos:** Usar `InscripcionEndpointHelper.SeedFreshInscripcionAsync` (reutilizado de Integration)
- **Sin consultas BD en asserts:** Las verificaciones son exclusivamente sobre la UI

## 4. Edge cases NO cubiertos como E2E

| Escenario | Motivo | Cubierto en |
|-----------|--------|-------------|
| idInscripcion=0 retorna bad request | No se puede disparar desde la UI del browser | Integration: InscripcionesControllerCancelarTests |
| Inscripción inexistente retorna not found | No se puede disparar desde la UI del browser | Integration: InscripcionesControllerCancelarTests |

## 5. Criterios de aceptación

- [ ] Test happy path: cancelar inscripción válida desde UI → SweetAlert2 de éxito
- [ ] Test edge case: sin autenticación → redirige a signIn (input correo visible + URL)
- [ ] Test edge case: usuario sin rol empleado → redirige a AccesoDenegado (URL)
- [ ] Tests usan Playwright Expect() para aserciones de UI
- [ ] Tests siguen patrón GIVEN/WHEN/THEN del proyecto
- [ ] Tests NO consultan BD en asserts
- [ ] Tests seedean datos via InscripcionEndpointHelper antes de navegar