# Spec: InscripcionesService.ReagendarInscripcionAsync — Pruebas

## 1. Resumen

Crear pruebas unitarias y de integración para el método `ReagendarInscripcionAsync` de
`InscripcionesService`.

Las pruebas se dividen en dos categorías:
- **Unitarias**: validan guard clauses que no requieren BD.
- **Integración**: validan flujo completo contra BD real (incluyendo happy path).

## 2. Contexto

- **Método a probar:** `InscripcionesService.ReagendarInscripcionAsync`
- **Servicio unificado:** `InscripcionesService` (implementa `IInscripcionesService`)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Servicio | `InscripcionesService` | Servicio unificado de inscripciones | 39 |

---

## 3. Pruebas Unitarias (no requieren BD)

Validan únicamente las guard clauses del método. No ejecutan ninguna consulta EF ni SP.
Se inyectan dependencias mockeadas con NSubstitute.

### 3.1 Dependencias

| Dependencia | Tipo | Propósito |
|-------------|------|-----------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `NSubstitute` | Mocking | Crear substitutes de dependencias |
| `InscripcionesService` | SUT | Servicio a probar (resuelto vía DI mockeada) |

### 3.2 Casos

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 2 | ID inscripción inválido (0 o negativo) | Pasar idInscripcion <= 0 | 400 |
| 3 | ID clase programada inválido (0 o negativo) | Pasar idClaseProgramada <= 0 | 400 |
| 4 | ID cliente vacío | Pasar string vacío | 400 |

### 3.3 Patrones

- Crear SUT con dependencias substitutas
- No es necesario configurar ningún mock de `_context`, `_validadorFecha`, etc. porque las guard clauses retornan antes de llegar a EF
- Usar FluentAssertions para aserciones
- Ubicación: `GymWebApp.Tests/Unit/Inscripciones/`

---

## 4. Pruebas de Integración (requieren BD real)

Validan el flujo completo del servicio contra BD real (TestContainers + Respawn).

### 4.1 Dependencias

| Dependencia | Tipo | Propósito |
|-------------|------|-----------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `TestContainerHelper` | Helper | Levantar SQL Server en Docker |
| `IntegrationTestBase` | Base | Clase base con WebApplicationFactory |
| `InscripcionTestHelper` | Helper | Seeding de datos de inscripciones |
| `DatabaseHelper` | Helper | Consultas y comandos SQL directos |

### 4.2 Happy Path

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 1 | Reagendar inscripción válida futura | Inscripción con fecha futura y clase programada destino existente (mismo tipo, fecha posterior) | 200 + true |

### 4.3 Edge Cases

| # | Prueba | Descripción | Resultado |
|---|--------|-------------|-----------|
| 5 | Inscripción inexistente | ID válido pero inscripción no existe en BD | 404 |
| 6 | Inscripción con fecha pasada | Inscripción de clase que ya pasó | 400 |
| 7 | Inscripción de hoy con hora pasada | Inscripción de hoy con horaInicio < hora actual | 400 |
| 8 | Clase programada destino inexistente | ID válido pero clase destino no existe | 404 |
| 9 | Tipo de clase destino diferente al original | Inscripción a HIIT reagendada a clase de distinto tipo (ej: Yoga) | 400 |
| 10 | Fecha destino <= fecha original | Reagendar a una clase con fecha anterior o igual a la original | 400 |

### 4.4 Patrones de testing

- **AAA Pattern:** Arrange, Act, Assert
- **IntegrationTestBase:** Heredar de la clase base que implementa `IClassFixture<CitasApiWebApplicationFactory<Program>>`
- **FluentAssertions:** Aserciones legibles
- **TestContainerHelper:** Para inicializar y resetear BD
- **InscripcionTestHelper:** Para seeding de inscripciones con datos controlados
- **DatabaseHelper:** Para modificar datos existentes en edge cases
- Ubicación: `GymWebApp.Tests/Integration/Features/Inscripciones/`

---

## 5. Archivos

| Archivo | Tipo | Descripción |
|---------|------|-------------|
| `GymWebApp.Tests/Unit/Inscripciones/ServiceReagendarInscripcionGuardClauseTests.cs` | Unit | Tests de guard clauses (2, 3, 4) |
| `GymWebApp.Tests/Integration/Features/Inscripciones/ServiceReagendarInscripcionTests.cs` | Integration | Tests de integración (1, 5, 6, 7, 8, 9, 10) |

## 6. Criterios de aceptación

- [ ] 3 pruebas unitarias implementadas (tests 2, 3, 4)
- [ ] 7 pruebas de integración implementadas (tests 1, 5, 6, 7, 8, 9, 10)
- [ ] Cada prueba tiene comentarios explicativos
- [ ] Se usa AAA Pattern
- [ ] Se usan aserciones con FluentAssertions
- [ ] Tests unitarios: NSubstitute para mocks
- [ ] Tests integración: se resetea la BD antes de cada prueba via `TestContainerHelper.ResetDatabaseAsync()`
