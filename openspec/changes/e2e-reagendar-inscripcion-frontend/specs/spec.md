# E2E Tests — Reagendar Inscripción (Frontend Proxy POST /inscripciones/reagendar)

## 1. Resumen

Especificación de 4 tests E2E que cubren el flujo completo del frontend para reagendar una inscripción
vía el proxy `/inscripciones/reagendar`. Se validan: autenticación, autorización por rol, flujo feliz
con selección de horario, y advertencia cuando no se selecciona horario.

## 2. Contexto

- **Tipo de spec:** Tests E2E (Playwright + Docker)
- **Capa:** GymWebApp.Tests / E2E
- **Clase principal:** `InscripcionesReagendarE2ETests`
- **Ubicación:** `GymWebApp.Tests/E2E/Features/InscripcionesReagendarE2ETests.cs`
- **Collection:** "E2E HappyPaths" con `DisableParallelization = true`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Frontend | `POST /inscripciones/reagendar` | Proxy endpoint que reagenda una inscripción | Spec 47 |
| UI | `Inscripciones/cancelarReagendar` | Página web con el flujo de cancelación/reagendación | Spec 47 |
| Helper | `InscripcionEndpointHelper.SeedFreshInscripcionAsync` | Siembra datos de inscripción + clases para tests | — |
| Helper | `InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync` | Crea una clase de destino válida para reagendar | — |
| Infra | `E2eContainerHelper` | Orquestación del stack Docker (SQL Server + app) | — |
| Base | `PlaywrightTestBase` | Clase base que inicializa Playwright + Docker + DB | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Docker | Infraestructura | Stack completo vía `E2eContainerHelper` |
| Playwright | Browser automation | Navegador Chromium headless |
| SQL Server | Base de datos | Reset mediante `E2eContainerHelper.ResetDatabaseAsync()` |
| SweetAlert2 | Librería JS | Alertas de éxito/advertencia validadas en tests |
| Credenciales de empleado | Config | `E2ETestSettings.TestUserEmail` / `TestUserPassword` |
| Credenciales de cliente | Config | `E2ETestSettings.TestUserClienteEmail` |

## 3. Escenarios de prueba

### 3.1 Seeds comunes

Antes de cada test que requiere datos:
1. `E2eContainerHelper.ResetDatabaseAsync()` se ejecuta en `PlaywrightTestBase.InitializeAsync` (antes de cada test).
2. Para los tests que necesitan inscripción válida (1 y 4), se llama a `InscripcionEndpointHelper.SeedFreshInscripcionAsync()` y a `InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync()` dentro del mismo test.

### 3.2 Tabla de escenarios

| ID | Nombre | Descripción | Prerrequisitos | Pasos | Resultado esperado |
|----|--------|-------------|----------------|-------|-------------------|
| **E2E-REAG-01** | `Reagendar_InscripcionValida_RetornaExito` | Happy path: empleado autenticado reagenda una inscripción seleccionando cliente, inscripción, habilitando reagendar y eligiendo fecha + horario | DB reseteada. Datos de inscripción + clase destino sembrados vía helpers. Sesión de empleado iniciada en `/Inscripciones/cancelarReagendar` | 1. Seleccionar un cliente en `#comboCliente`.<br>2. Esperar que `#comboInscripcion` se cargue y seleccionar una inscripción.<br>3. Tildar `#checkReagendar` — verificar que `#contenedorCalendario` y `#contenedorScheduler` se muestren.<br>4. Hacer clic en una fecha disponible en el calendario.<br>5. Hacer clic en un horario disponible en el scheduler.<br>6. Hacer clic en `#btnEjecutar`.<br>7. Esperar el modal SweetAlert2. | SweetAlert2 muestra título "Inscripción reagendada exitosamente" con ícono `.swal2-success`. La UI se resetea (inputs vuelven a estado inicial). |
| **E2E-REAG-02** | `Reagendar_SinAutenticacion_RetornaRedirectToLogin` | Usuario no autenticado intenta acceder a la página de cancelar/reagendar | DB reseteada. Sin sesión iniciada. Navegación directa a `/Inscripciones/cancelarReagendar` | 1. Ir a `/Inscripciones/cancelarReagendar`.<br>2. Esperar la respuesta del servidor. | El servidor redirige a `/signIn` (login page). La URL final contiene "/signIn". |
| **E2E-REAG-03** | `Reagendar_UsuarioSinRolEmpleado_RetornaForbidden` | Usuario con rol Cliente intenta acceder a la página de cancelar/reagendar | DB reseteada. Sesión de usuario cliente iniciada (login con `TestUserClienteEmail`). Navegación a `/Inscripciones/cancelarReagendar` | 1. Iniciar sesión como cliente.<br>2. Navegar a `/Inscripciones/cancelarReagendar`.<br>3. Esperar la respuesta del servidor. | El servidor redirige a `AccesoDenegado` (página de acceso denegado). |
| **E2E-REAG-04** | `Reagendar_SinHorarioSeleccionado_MuestraAdvertencia` | Empleado autenticado tilda reagendar pero hace clic en btnEjecutar sin seleccionar fecha/horario | DB reseteada. Datos de inscripción sembrados vía helpers. Sesión de empleado iniciada en `/Inscripciones/cancelarReagendar` | 1. Seleccionar un cliente en `#comboCliente`.<br>2. Esperar que `#comboInscripcion` se cargue y seleccionar una inscripción.<br>3. Tildar `#checkReagendar` — verificar que `#contenedorCalendario` y `#contenedorScheduler` se muestren.<br>4. **No** seleccionar fecha ni horario.<br>5. Hacer clic en `#btnEjecutar`.<br>6. Esperar el modal SweetAlert2. | SweetAlert2 muestra título "Seleccione un horario en el calendario" con ícono `.swal2-warning`. |

### 3.3 Detalle de pasos por escenario

#### E2E-REAG-01: Happy Path

```
Dado que:
  - La base de datos tiene una inscripción válida y una clase destino disponible
  - El empleado está autenticado en la página /Inscripciones/cancelarReagendar

Cuando:
  1. Selecciona un cliente en #comboCliente
  2. Espera que #comboInscripcion se cargue con las inscripciones del cliente
  3. Selecciona una inscripción
  4. Marca #checkReagendar
  5. Hace clic en una fecha dentro de #contenedorCalendario
  6. Hace clic en un horario dentro de #contenedorScheduler
  7. Hace clic en #btnEjecutar

Entonces:
  - Aparece un SweetAlert2 con título "Inscripción reagendada exitosamente"
  - El ícono del modal es .swal2-success
  - La UI se resetea (comboCliente, comboInscripcion vuelven a default)
```

#### E2E-REAG-02: Sin Autenticación

```
Dado que:
  - No hay sesión iniciada
  - El usuario navega directamente a /Inscripciones/cancelarReagendar

Cuando:
  - Se completa la navegación

Entonces:
  - El servidor redirige a la página de login (/signIn)
  - La URL actual contiene "/signIn"
```

#### E2E-REAG-03: Rol Incorrecto

```
Dado que:
  - Un usuario con rol Cliente inició sesión
  - Navega a /Inscripciones/cancelarReagendar

Cuando:
  - Se completa la navegación

Entonces:
  - El servidor redirige a AccesoDenegado
  - La URL actual contiene "AccesoDenegado"
```

#### E2E-REAG-04: Sin Horario Seleccionado

```
Dado que:
  - La base de datos tiene una inscripción válida
  - El empleado está autenticado en la página /Inscripciones/cancelarReagendar
  - Seleccionó cliente, inscripción y marcó #checkReagendar
  - NO seleccionó fecha ni horario en el calendario/scheduler

Cuando:
  - Hace clic en #btnEjecutar

Entonces:
  - Aparece un SweetAlert2 con título "Seleccione un horario en el calendario"
  - El ícono del modal es .swal2-warning
  - La página NO se recarga (el usuario puede continuar)
```

### 3.4 Elementos UI referenciados

| Selector | Tipo | Propósito |
|----------|------|-----------|
| `#comboCliente` | `<select>` | Selección del cliente |
| `#comboInscripcion` | `<select>` | Selección de la inscripción |
| `#checkReagendar` | `<input type="checkbox">` | Habilita el modo reagendar (muestra calendario + scheduler) |
| `#contenedorCalendario` | `<div>` | Contenedor del calendario de fechas |
| `#contenedorScheduler` | `<div>` | Contenedor de horarios disponibles |
| `#btnEjecutar` | `<button>` | Botón de acción (Reagendar) |
| `.swal2-title` | Elemento DOM | Título del modal SweetAlert2 |
| `.swal2-success` | Elemento DOM | Ícono de éxito en SweetAlert2 |
| `.swal2-warning` | Elemento DOM | Ícono de advertencia en SweetAlert2 |

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/E2E/Features/InscripcionesReagendarE2ETests.cs` | Clase con los 4 tests E2E |

## 5. Criterios de aceptación

- [ ] E2E-REAG-01 pasa: el flujo completo de reagendar muestra éxito con SweetAlert2
- [ ] E2E-REAG-02 pasa: usuario no autenticado redirige a `/signIn`
- [ ] E2E-REAG-03 pasa: usuario cliente redirige a `AccesoDenegado`
- [ ] E2E-REAG-04 pasa: clic en btnEjecutar sin horario muestra advertencia
- [ ] Los 4 tests pertenecen a la collection "E2E HappyPaths" con `DisableParallelization = true`
- [ ] El bug de JavaScript (envío de `idClaseProgramada` en lugar de `idNuevaClase`) está documentado en el header de la clase de test
- [ ] Los tests siguen el patrón AAA con comentarios `// Arrange`, `// Act`, `// Assert`
