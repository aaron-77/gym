# Spec: Filtro de hora único en helpers de tests - Infraestructura de Tests

## 1. Resumen

Estabilizar el E2E `Reagendar_InscripcionValida_RetornaExito` (spec 10) eliminando la carrera temporal en los seeds de horarios. Hoy `HorariosHelper` filtra la hora con precisión de HORA (referencia truncada hacia abajo), mientras el validador de negocio compara con precisión completa contra el reloj real de la API. El resultado es que los seeds eligen slots con margen de 1-2 minutos y el flujo del test a veces sobrepasa la hora seedeada → "no se puede reagendar una clase que ya empezó".

La solución es en infraestructura de tests (sin tocar producción): un único filtro de hora válido (`Mayor`) con referencia redondeada hacia arriba (ceil) a la próxima hora completa y un guard de fin de jornada que salta al día siguiente.

## 2. Contexto

- **Capa:** Tests (GymWebApp.Tests) + enum en BL.Utils.Enums (solo limpieza de contrato, sin cambio de lógica de producción).

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Helper | `HorariosHelper` | Consulta de horarios disponibles vía `sp_obtenerHorariosDisponibles` y filtros de fecha/hora | 06 |
| Helper | `InscripcionTestHelper` | Seeds de inscripciones y clase destino para reagendar | 10 |
| Helper | `ClasesProgramadasHelper` | Registro de clases programadas en tests | 12 |
| Enum | `FiltroHora` (BL.Utils.Enums) | Filtro de hora para consultas de horarios disponibles | 06 |
| Stored Procedure | `sp_obtenerHorariosDisponibles` | Genera slots disponibles; ya excluye horas vencidas de hoy (línea 37) | 06 |

> **Spec de tests: 51** — Las pruebas de integración del filtro de hora único se especifican en `51-spect-filtroHoraUnico-test.md` (par de tests de este spec). Este spec 50 NO las cubre.

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `horasLaborales` | DataAccess | Tabla con los horarios laborales (MIN/MAX horaInicio) |
| `GetMaxHoraInicioAsync` | Tests | Patrón existente de query a horas laborales en `InscripcionTestHelper` |
| `SeedFallbackAsync` | Tests | Manejo de null cuando no hay slots disponibles |

## 3. Cambios a realizar

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `BL/Utils/Enums/FiltroHorarioEnums.cs` | Eliminar `Igual` y `MayorIgual` del enum `FiltroHora`; solo quedan `Mayor` y `SinFiltro` |
| `GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs` | Quitar cases `Igual`/`MayorIgual` del switch; ceil a próxima hora completa; guard de fin de jornada |
| `GymWebApp.Tests/SharedHelpers/ClasesProgramadasHelper.cs` | Migrar el caller de `Igual` (método `RegistrarClaseProgramadaActual`) a `Mayor` sin renombrar |

### 3.2 Contrato del enum

El enum `FiltroHora` debe exponer únicamente `Mayor` y `SinFiltro`. Los valores `Igual` y `MayorIgual` NO deben existir (enforcement en compile-time: cualquier uso rompe la compilación).

### 3.3 Referencia horaria (ceil)

La referencia de hora para `FiltroHora.Mayor` debe redondearse hacia arriba a la próxima hora completa cuando la hora actual tenga minutos o segundos. Con minutos y segundos en cero, la referencia queda en la hora exacta (sin ceil). Con una fecha explícita (hora 0), la referencia queda en 00:00 y se preserva el comportamiento existente.

### 3.4 Guard de fin de jornada

`HorariosHelper` debe consultar el MAX y MIN de `horaInicio` de `horasLaborales`. El filtro de hora acepta slots con `horaInicio >= referencia` (igualar la última hora laboral es válido). Solo cuando la referencia SUPERA la última hora laboral, la referencia pasa a la primera hora laboral del día siguiente (la fecha de referencia también se desplaza al día siguiente).

### 3.5 Patrones a aplicar

- **Choke point único:** el ceil y el guard se implementan en `ObtenerHorariosDisponiblesFiltrados` para que todos los seeds (`ObtenerUnHorarioDisponible` → `ObtenerHorariosDisponiblesFiltrados`) hereden el margen.
- **Enforcement compile-time:** borrar los valores del enum para que el compilador falle ante cualquier uso de `Igual`/`MayorIgual`.
- **Preservación de fecha explícita:** el ceil solo aplica cuando la referencia deriva de la hora actual (fecha null); con fecha futura explícita (hora 0) no se modifica nada.

### 3.6 Detección y corrección de callers y tests afectados

**Cómo detectar:** buscar usos de `FiltroHora.Igual` y `FiltroHora.MayorIgual` en todo el código (tests y producción). Tras eliminar los valores del enum, cualquier uso restante rompe la compilación: el compilador actúa como enforcement. El listado siguiente es el inventario completo verificado al momento de escribir este spec.

**Callers a corregir:**

| Archivo | Línea | Uso | Corrección |
|---------|-------|-----|------------|
| `GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs` | 78 | case `FiltroHora.Igual` en el switch | Eliminar el case |
| `GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs` | 86 | case `FiltroHora.MayorIgual` en el switch | Eliminar el case |
| `GymWebApp.Tests/SharedHelpers/ClasesProgramadasHelper.cs` | 317 | caller `FiltroHora.Igual` en `RegistrarClaseProgramadaActual` | Migrar a `FiltroHora.Mayor` (sin rename — "Actual" refiere a la fecha, no a la hora) |

**Sin callers de `FiltroHora.MayorIgual`:** verificado por búsqueda — no existe ningún caller externo que use `FiltroHora.MayorIgual`. El único uso en el repo es el case interno del switch en `HorariosHelper.cs:86`, que se elimina al colapsar el switch al filtro único `Mayor`. Por lo tanto NO hay callers de `MayorIgual` que migrar. Los `MayorIgual` visibles en `InscripcionTestHelper` (387, 621, 625, 629, 940, 954, 1071) son `FiltroFecha.MayorIgual` (filtro de FECHA, enum distinto) — fuera de alcance, no se tocan.

**Callers verificados (regresión, sin cambios):** ya usan `Mayor` o `SinFiltro`; solo corren como regresión, no se modifican.

| Archivo | Líneas | Uso | Estado |
|---------|--------|-----|--------|
| `InscripcionTestHelper.cs` | 401, 599, 1071 | `FiltroHora.Mayor` | Sin cambios |
| `InscripcionTestHelper.cs` | 501, 629, 955 | `FiltroHora.SinFiltro` | Sin cambios |
| `InscripcionTestHelper.cs` | 659 | `FiltroFecha.Igual` + `FiltroHora.SinFiltro` | Sin cambios — el `Igual` es filtro de fecha, no de hora; NO afectado |
| `InscripcionEndpointHelper.cs` | 77 | `FiltroHora.SinFiltro` | Sin cambios |
| `HorariosHelper.cs` | 72, 82 | check `SinFiltro` y case `Mayor` (permanece) | Sin cambios |
| `ServiceReagendarInscripcionTests.cs` | 76, 198 | `FiltroHora.SinFiltro` | Sin cambios |
| `InscripcionesReagendarTests.cs` | 48 | `FiltroHora.SinFiltro` | Sin cambios |
| `ObtenerClasesProgramadasPorIdApiTests.cs` | 47 | `FiltroHora.SinFiltro` | Sin cambios |
| `InscripcionesReagendarE2ETests.cs` | 187 | `FiltroHora.SinFiltro` | Sin cambios |

**Método a NO tocar:** `GetMaxHoraInicioAsync` (en `InscripcionTestHelper`) — no usa `FiltroHora`; lo consumen `ServiceReagendarInscripcionTests.cs:186`, `InscripcionesReagendarTests.cs:38`, `ObtenerClasesProgramadasPorIdApiTests.cs:37` e `InscripcionesReagendarE2ETests.cs:178`. Fuera de alcance de este cambio.

## 4. Criterios de aceptación

> Las pruebas de integración que verifican este comportamiento se especifican en el spec 51 (par de tests). Este spec describe únicamente el comportamiento de implementación.

- [ ] El enum `FiltroHora` expone solo `Mayor` y `SinFiltro` (compile-time)
- [ ] El switch de `HorariosHelper` no contiene cases `Igual`/`MayorIgual`
- [ ] `RegistrarClaseProgramadaActual` usa `FiltroHora.Mayor` (sin rename — "Actual" refiere a la fecha, no a la hora)
- [ ] Con hora actual 16:35, la referencia de `Mayor` es 17:00 y solo devuelve slots con horaInicio >= 17:00
- [ ] Con hora actual 16:00:00 exacta, la referencia es 16:00 (sin ceil)
- [ ] Con fecha explícita (hora 0), la referencia es 00:00 (comportamiento preservado)
- [ ] Con última hora laboral 21:00 y hora actual 22:10, la referencia pasa al primer slot del día siguiente
- [ ] Con última hora laboral 18:00 y referencia ceil 18:00 (hora actual 17:29), se devuelve el slot de las 18:00 del día actual (igualar maxHora es válido)
- [ ] Con hora actual dentro de la jornada, la referencia permanece en el día actual
- [ ] El slot elegido por los seeds con `Mayor` tiene al menos ~1 hora de margen respecto a la hora actual
- [ ] E2E `Reagendar_InscripcionValida_RetornaExito` pasa en corridas repetidas
- [ ] El validador de negocio (`ValidadorFechasInscripcionesYClasesProgramadas.cs`) no se modifica
- [ ] Tests existentes con `Mayor`/`SinFiltro` siguen verdes

## 5. Fuera de alcance

- Pruebas de integración del filtro de hora único — las cubre el spec 51 (`51-spect-filtroHoraUnico-test.md`), no este spec
- `BL/Validaciones/ValidadorFechasInscripcionesYClasesProgramadas.cs` — correcto, no se toca
- Lógica de negocio de producción (API/BL services)
- `sp_obtenerHorariosDisponibles.sql` — ya excluye horas vencidas de hoy (spec 06, Req. 13)
- Enum `FiltroFecha` — fuera de alcance
- Forzar fechas futuras en tests que ejercitan la fecha actual intencionalmente
- Fallback E2E existente (`InscripcionesReagendarE2ETests.cs:177-202`)
