# Spec: Helper calcularSiguienteFechaDisponible - Helper de Test

## 1. Resumen

Se agrega un nuevo método helper estático a la clase `HorariosHelper` del proyecto de pruebas. Este método recibe una fecha base y devuelve la **fecha mínima única** en la que existe al menos un horario disponible estrictamente posterior a la fecha base, sin filtrar por hora. Su propósito es simplificar la consulta "¿cuál es el próximo día disponible?" en tests de integración, ignorando por completo la componente horaria.

## 2. Contexto

- **Capa:** GymWebApp.Tests (proyecto de pruebas de integración)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Helper | `HorariosHelper` | Clase helper estática existente que centraliza consultas de horarios disponibles | [spect-filtroHoraUnico](50-spect-filtroHoraUnico.md) |
| Helper | `ObtenerHorariosDisponiblesFiltrados` | Método existente que consulta el SP y aplica filtros de fecha y hora | [50-spect-filtroHoraUnico.md](50-spect-filtroHoraUnico.md) |
| Enum | `FiltroFecha` | Enum con valores Igual, Mayor, MayorIgual | BL.Utils.Enums |
| Enum | `FiltroHora` | Enum con valores Mayor, SinFiltro | BL.Utils.Enums |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `ObtenerHorariosDisponiblesFiltrados` | Helper propio | Método del que se obtienen los horarios crudos con filtro de fecha y hora |
| `BL.Utils.Enums` | Proyecto | Contiene los enums `FiltroFecha` y `FiltroHora` usados en la firma del método filtrado |
| `DateOnly` / `DateTime` | BCL de .NET | Tipos para fecha; `DateOnly` como entrada/salida y `DateTime` como conversión interna para la llamada al método filtrado |

## 3. Método helper a agregar

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs` | Se agrega el método `calcularSiguienteFechaDisponible` a la clase existente |

### 3.2 Contrato

- **Firma (comportamiento):** método estático público que recibe una fecha de tipo `DateOnly` como parámetro y devuelve un valor de tipo `DateOnly?` (nullable).
- **Retorno:** la **fecha mínima única** en la que existe al menos un horario disponible estrictamente posterior a la fecha base. Si no hay ningún horario, devuelve `null`.
- **Nombre:** `calcularSiguienteFechaDisponible` (nombre corregido del typo original "Siguente").

**Semántica de retorno:**

| Caso | Comportamiento |
|------|----------------|
| Existen horarios con fecha > base | Devuelve la menor fecha (día) del conjunto, ignorando la hora |
| No existen horarios con fecha > base | Devuelve `null` |

### 3.3 Flujo de la lógica

Pasos que el método debe ejecutar, sin código:

1. **enviar**  la fecha tal cual al metodo obtenerHorariosDisponiblesFiltrados ya que se hace una conversion explicta y no  es necesaria la hora e este caso.
2. **Llamar** a `ObtenerHorariosDisponiblesFiltrados` con:
   - Filtro de fecha en modo **mayor** (estrictamente posterior a la fecha base).
   - Filtro de hora en modo **sin filtro**.
   - La fecha base convertida como referencia.
3. **Agrupar** los resultados de vuelta por día de la `FechaDisponible`, quedando con los días únicos que tienen al menos un horario disponible.
4. **Ordenar** los días resultantes de menor a mayor.
5. **Devolver** el **primer** día de ese conjunto ordenado.
6. **Retornar `null`** si no hay días resultantes (el conjunto ordenado queda vacío).

### 3.4 Patrones a aplicar

- **Helper estático sin estado:** el método no guarda estado; es una función pura que delega la consulta al helper existente.
- **Single-flight a la BD:** se realiza una única llamada a `ObtenerHorariosDisponiblesFiltrados` y toda la deduplicación/ordenamiento se hace en memoria sobre el resultado devuelto.
- **Nullable para ausencia:** se usa tipo de retorno nullable para representar el caso "no hay próxima fecha disponible" en lugar de lanzar una excepción.

## 4. Archivos a modificar

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Helpers/HorariosHelper.cs` | Se agrega el método `calcularSiguienteFechaDisponible` a la clase estática `HorariosHelper` |

## 5. Criterios de aceptación

- [ ] Existe un método estático público `calcularSiguienteFechaDisponible` en `HorariosHelper`.
- [ ] El método recibe una fecha de tipo `DateOnly`.
- [ ] Internamente delega la consulta a `ObtenerHorariosDisponiblesFiltrados` con filtro de fecha **Mayor** y filtro de hora **SinFiltro**.
- [ ] Devuelve la **fecha mínima única** (día) del conjunto de horarios disponibles posteriores a la fecha base.
- [ ] Si no hay horarios disponibles posteriores a la fecha base, devuelve `null`.
- [ ] No se agregan tests nuevos para este método (según indicación explícita).
