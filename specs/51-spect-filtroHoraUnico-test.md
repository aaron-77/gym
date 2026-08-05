# Spec: Filtro de hora único en helpers de tests - Pruebas de Integración

## 1. Resumen

Crear pruebas de integración para el filtro de hora único (`FiltroHora.Mayor`) del
`HorariosHelper`, validando: el ceil de la referencia a la próxima hora completa, la
preservación de la referencia 00:00 con fecha explícita futura, y el guard de fin de
jornada que desplaza la referencia al día siguiente. Son el par de tests del spec 50
(spec de implementación) y verifican el comportamiento del choke point
`ObtenerHorariosDisponiblesFiltrados`.

## 2. Contexto

- **Capa:** Tests (GymWebApp.Tests)
- **Método a probar:** `HorariosHelper.ObtenerHorariosDisponiblesFiltrados`
- **Ubicación tests:** `GymWebApp.Tests/Integration/Features/Horarios/`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Helper | `HorariosHelper` | Consulta de horarios disponibles vía `sp_obtenerHorariosDisponibles`; choke point del filtro único con ceil y guard de fin de jornada | 06 / 50 |
| Enum | `FiltroHora` (BL.Utils.Enums) | Filtro de hora; tras el refactor solo expone `Mayor` y `SinFiltro` | 50 |
| Stored Procedure | `sp_obtenerHorariosDisponibles` | Genera slots disponibles; ya excluye horas vencidas de hoy | 06 |
| Helper | `TestContainerHelper` | Inicialización del contenedor SQL Server y reset de BD por test | — |
| Spec | `50-spect-filtroHoraUnico.md` | Spec de implementación que estas pruebas verifican | 50 |

### 2.2 Dependencias de testing

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `xUnit` | Framework | Framework de testing |
| `FluentAssertions` | Aserciones | Aserciones legibles |
| `Testcontainers` | Infraestructura | BD de pruebas en Docker vía `TestContainerHelper` |
| Patrón condicional runtime del E2E | Patrón | Comparación de la hora actual contra la última hora laboral para decidir el assert esperado (guard de reloj del E2E de reagendar) |

## 3. Pruebas a implementar

| # | Prueba | Tipo | Descripción | Resultado |
|---|--------|------|-------------|-----------|
| 1 | FiltroHoraMayor con hora actual con minutos → ceil a próxima hora | Happy Path | Capturar DateTime.Now; si minutos/segundos > 0 la referencia esperada es hora+1 (si no, hora exacta); assert slots de hoy con horaInicio > referencia esperada | no-vacío, todos los slots con horaInicio > ref |
| 2 | FiltroHoraMayor con fecha explícita futura → referencia 00:00 preservada | Happy Path | Fecha futura explícita (DateOnly), sin ceil ni guard | slots del día solicitado |
| 3 | FiltroHoraMayor fin de jornada → desplaza al día siguiente | Edge Case | Si DateTime.Now.TimeOfDay > maxHora de horasLaborales (patrón condicional tipo E2E), la consulta devuelve slots del día siguiente con horaInicio >= minHora; si no, assert día actual | día siguiente con primer slot >= minHora (o día actual) |
| 4 | FiltroHoraMayor dentro de jornada → permanece día actual | Edge Case | Complemento del test 3: dentro de jornada → día actual no-vacío | día actual no-vacío |

## 4. Patrones de testing

- **Colección de integración:** la clase se adhiere a la colección "IntegrationTests" definida en `IntegrationTestCollections.cs` (desparalelización desactivada), evitando corridas concurrentes contra la misma BD.
- **Testcontainers + BD real:** la BD se levanta en Docker vía `TestContainerHelper`; el reset de la BD se ejecuta en el constructor de la clase (patrón del proyecto).
- **Sin factory Web:** los tests consultan la BD directamente a través del helper (queries directas a BD), sin levantar la API en memoria.
- **Asserts runtime-relativos:** los valores esperados se calculan en tiempo de ejecución (reloj capturado y horas laborales consultadas a la BD) — nunca valores fijos de reloj.
- **AAA Pattern:** Arrange, Act, Assert.
- **FluentAssertions:** aserciones legibles para no-vacío y comparaciones de hora.

## 5. Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Features/Horarios/HorariosHelperFiltroHoraTests.cs` | Tests de integración del filtro de hora único (NUEVO) |

## 6. Criterios de aceptación

- [ ] 4 pruebas implementadas (2 happy paths + 2 edge cases), exactamente las de la tabla del spec
- [ ] Asserts runtime-relativos: la referencia esperada se calcula desde el reloj y la BD, no con valores fijos
- [ ] Sin lógica de helper dentro de la clase de test (se usan helpers existentes o se delega)
- [ ] BD reseteada antes de cada prueba vía `TestContainerHelper`
- [ ] SOLO los escenarios definidos en este spec — sin tests derivados (23:35→24:00, último día del mes + guard, horaRef == maxHora quedan fuera de alcance)
