# Spec 83: Backend — LimpiarPreReservas tras Inscripción — Pruebas

## 1. Resumen

Crear pruebas unitarias y de integración para la limpieza automática de pre-reservas tras la inscripción a clase (Spec 82). Cubren el repository (`EncontrarPreReservasAsync`, `EliminarPreReservasEspecificasAsync`), el service wrapper (`LimpiarPreReservasEspecificasAsync`) y el flujo del controller (`InscribirAClase`).

Las pruebas se dividen en dos categorías:
- **Unitarias**: validan lógica del wrapper y guard clauses sin BD.
- **Integración**: validan el flujo completo contra BD real (TestContainers + Respawn), incluyendo happy path y edge cases.

## 2. Contexto

- **Métodos a probar:**
  - `InscripcionRepository.EncontrarPreReservasAsync`
  - `InscripcionRepository.EliminarPreReservasEspecificasAsync`
  - `InscripcionesService.LimpiarPreReservasEspecificasAsync`
  - `ClasesController.InscribirAClase` (integración del flujo de limpieza)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Spec | Implementación de limpieza de pre-reservas | Describe los métodos y el flujo | 82 |

### 2.2 Nomenclatura de los tests

Cada test se identifica con un **prefijo de letra** según el componente/tipo de prueba que cubre, seguido de un número correlativo:

| Prefijo | Significa | Grupo de tests | ¿Toca BD? |
|---------|-----------|----------------|-----------|
| **U** | Unitario | U1–U6 | ❌ No (repo mockeado) |
| **R** | Repository (`EncontrarPreReservasAsync`, `EliminarPreReservasEspecificasAsync`) | R1–R6 | ✅ Sí |
| **S** | Service (`LimpiarPreReservasEspecificasAsync`) | S1–S2 | ✅ Sí |
| **C** | Controller (`InscribirAClase`) | C1–C2 | ✅ Sí |

Esta nomenclatura es parte de la convención de este spec y se usa en las secciones de casos, archivos y criterios de aceptación.

---

## 3. Pruebas Unitarias — NO consultan BD

> **IMPORTANTE:** Estas pruebas **NO ejecutan ninguna consulta a BD**. El `IInscripcionRepository` se reemplaza por un **mock de NSubstitute**, por lo que no hay SQL real ni acceso a la tabla `PreReservasDeHorarios`. Validan **únicamente la lógica de orquestación del service** (qué decide eliminar, qué loguea, qué valor de retorno produce) a partir de la lista ficticia que el mock devuelve.

### 3.1 Dependencias

| Dependencia | Tipo | Propósito |
|-------------|------|-----------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `NSubstitute` | Mocking | Substitutes de `IInscripcionRepository` y `ILogger` |
| `InscripcionesService` | SUT | Servicio a probar (recibe el repo mockeado por constructor) |

### 3.1.b Mecánica (cómo se arman)

1. Se instancia `InscripcionesService` con un `IInscripcionRepository` substituto (mock) y un `ILogger` substitute.
2. Se configura el mock: `repository.EncontrarPreReservasAsync(Arg.Any<int>(), Arg.Any<DateOnly>(), Arg.Any<int>(), Arg.Any<string>())` devuelve una lista de `PreReservasDeHorario` **armada a mano en el test**.
3. Se llama al service; el service trabaja sobre esa lista ficticia (filtra `IdEntrenador` null, arma ids, decide si elimina).
4. Se verifica con `Received()` qué llamó a `EliminarPreReservasEspecificasAsync` y con qué ids.
5. Se verifican los logs con el `ILogger` substitute y el valor de retorno.

> **Por qué esto es válido:** prueba la lógica pura del wrapper (qué elimina, qué loguea, qué devuelve) sin depender de infraestructura. La persistencia real se cubre en los tests de integración.

### 3.2 Casos

| # | Prueba | Descripción | Resultado esperado |
|---|--------|-------------|--------------------|
| U1 | Sin pre-reservas encontradas | `EncontrarPreReservasAsync` devuelve lista vacía | `true` (nada que limpiar) |
| U2 | Todas las pre-reservas se eliminan | `EliminarPreReservasEspecificasAsync` elimina todas las esperadas | `true` |
| U3 | Una pre-reserva no se elimina | Se devuelven menos registros eliminados de los esperados | `false` |
| U4 | Pre-reserva con `IdEntrenador` null | Una pre-reserva encontrada tiene `IdEntrenador` null → se ignora (no se elimina) | `false` (o se loguea como no-procesable) |
| U5 | Excepción en repository | `EncontrarPreReservasAsync` o `EliminarPreReservasEspecificasAsync` lanza excepción | `false` (o manejo de error 500) |
| U6 | Logs correctos | Verifica que se llame a `LogInformation` con ids eliminados y a `LogError` con ids no eliminados | Se emiten los logs esperados |

### 3.3 Patrones

- Crear SUT con `IInscripcionRepository` y `ILogger` substitutos.
- Configurar el substitute de `EncontrarPreReservasAsync` para devolver listas controladas.
- Verificar que `EliminarPreReservasEspecificasAsync` reciba la lista correcta de ids.
- Verificar los logs mediante `Received()` sobre el `ILogger` substitute.
- Ubicación: `GymWebApp.Tests/Unit/PreReservas/`

---

## 4. Pruebas de Integración (requieren BD real)

Validan el flujo completo contra BD real (TestContainers + Respawn).

### 4.1 Dependencias

| Dependencia | Tipo | Propósito |
|-------------|------|-----------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `TestContainerHelper` | Helper | Levantar SQL Server en Docker |
| `IntegrationTestBase` | Base | Clase base con WebApplicationFactory |
| `InscripcionTestHelper` | Helper | Seeding de inscripciones |
| `PreReservaTestHelper` | Helper | Seeding de pre-reservas con datos controlados |
| `DatabaseHelper` | Helper | Consultas y comandos SQL directos |

### 4.2 Repository — `EncontrarPreReservasAsync`

| # | Prueba | Descripción | Resultado esperado |
|---|--------|-------------|--------------------|
| R1 | Encuentra pre-reserva con los 4 coincidencias | Seed de pre-reserva con `fkHoraLaboral`, `fechaReservada`, `idClase`, `idEntrenador` exactos | Devuelve la pre-reserva |
| R2 | Devuelve todas las coincidencias (múltiples) | Seed de varias pre-reservas con los mismos datos | Devuelve todas |
| R3 | No encuentra por filtro erróneo | Seed con datos distintos | Devuelve lista vacía |
| R4 | Ignora pre-reserva con `IdEntrenador` null | Seed de pre-reserva con `IdEntrenador` null | No la incluye en el resultado (o se maneja como error de negocio) |

### 4.3 Repository — `EliminarPreReservasEspecificasAsync`

> **Nota de terminología:** "pre-reservas pasadas como parámetro" = las **que se pasan por parámetro** al método (los `IdPreReserva` que recibe la colección). **NO** se refiere a pre-reservas caducadas por tiempo.

| # | Prueba | Descripción | Resultado esperado |
|---|--------|-------------|--------------------|
| R5 | Elimina todas las pre-reservas cuyo id se pasa como parámetro | Seed de 2 pre-reservas en BD y llamar al método pasándole ambos `IdPreReserva` | Devuelve el conteo correcto y ambas desaparecen de BD |
| R6 | Solo elimina las pre-reservas cuyo id se pasa, deja intactas las demás | Seed de 3 pre-reservas, pasar solo 2 de sus `IdPreReserva` | Solo se eliminan las 2 pasadas; la tercera permanece en BD |

### 4.4 Service — `LimpiarPreReservasEspecificasAsync`

| # | Prueba | Descripción | Resultado esperado |
|---|--------|-------------|--------------------|
| S1 | Happy path: limpia pre-reservas existentes | Seed de pre-reservas con los 4 datos; llamar al wrapper | `true` y las pre-reservas desaparecen |
| S2 | Sin pre-reservas | No hay pre-reservas con esos datos | `true` (nada que limpiar) |

### 4.5 Controller — `InscribirAClase` (integración del flujo)

| # | Prueba | Descripción | Resultado esperado |
|---|--------|-------------|--------------------|
| C1 | Inscripción exitosa limpia la pre-reserva | Seed de pre-reserva + inscripción exitosa; verificar BD | 200 y la pre-reserva desaparece tras el POST |
| C2 | Inscripción sin pre-reserva previa | No hay pre-reserva; inscripción normal | 200 y flujo sin cambios (compatibilidad) |

### 4.6 Patrones de testing

- **AAA Pattern:** Arrange, Act, Assert.
- **IntegrationTestBase:** Heredar de la clase base con `IClassFixture<CitasApiWebApplicationFactory<Program>>`.
- **FluentAssertions:** Aserciones legibles.
- **TestContainerHelper:** Inicializar y resetear BD.
- **PreReservaTestHelper / InscripcionTestHelper:** Seeding con datos controlados.
- **DatabaseHelper:** Modificar/verificar datos en edge cases.
- Ubicación: `GymWebApp.Tests/Integration/Features/PreReservas/`

---

## 5. Archivos

Los nombres de archivo siguen la convención del repo: `[ComponenteBajoPrueba]Tests.cs`.

| Archivo | Tipo | Descripción |
|---------|------|-------------|
| `GymWebApp.Tests/Unit/PreReservas/LimpiarPreReservasEspecificasServiceTests.cs` | Unit | Tests U1–U6 |
| `GymWebApp.Tests/Integration/Features/PreReservas/InscripcionRepositoryEncontrarPreReservasTests.cs` | Integration | Tests R1–R4 |
| `GymWebApp.Tests/Integration/Features/PreReservas/InscripcionRepositoryEliminarPreReservasTests.cs` | Integration | Tests R5–R6 |
| `GymWebApp.Tests/Integration/Features/PreReservas/LimpiarPreReservasEspecificasServiceTests.cs` | Integration | Tests S1–S2 |
| `GymWebApp.Tests/Integration/Features/PreReservas/ClasesControllerInscribirAClaseLimpiezaTests.cs` | Integration | Tests C1–C2 |

---

## 6. Criterios de aceptación

- [ ] 6 pruebas unitarias implementadas (U1–U6)
- [ ] 4 pruebas de integración del repository `EncontrarPreReservasAsync` (R1–R4)
- [ ] 2 pruebas de integración del repository `EliminarPreReservasEspecificasAsync` (R5–R6)
- [ ] 2 pruebas de integración del service `LimpiarPreReservasEspecificasAsync` (S1–S2)
- [ ] 2 pruebas de integración del controller `InscribirAClase` (C1–C2)
- [ ] Cada prueba tiene comentarios explicativos
- [ ] Se usa AAA Pattern
- [ ] Se usan aserciones con FluentAssertions
- [ ] Tests unitarios: NSubstitute para mocks
- [ ] Tests integración: se resetea la BD antes de cada prueba via `TestContainerHelper.ResetDatabaseAsync()`
- [ ] Se verifica el log de ids eliminados y no eliminados
- [ ] Se verifica el tratamiento de pre-reservas con `IdEntrenador` null
