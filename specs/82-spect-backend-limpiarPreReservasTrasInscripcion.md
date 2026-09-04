# Spec 82: Backend — Limpieza automática de pre-reservas tras inscripción a clase

## 1. Resumen

Después de una **inscripción exitosa a una clase programada** (`InscribirAClase`), limpiar automáticamente las **pre-reservas de horario** asociadas a esa clase programada. La limpieza se hace consultando las pre-reservas que coinciden con los datos de la clase programada (hora laboral, fecha reservada, clase, entrenador) y eliminándolas, siguiendo el patrón N-layer del proyecto y usando los helpers de BD (`IDataAccessExecutor`).

## 2. Contexto

- **Capa:** DataAccess (repositorio) + API Services + API Controllers
- **Flujo afectado:** `ClasesController.InscribirAClase` (inscripción a clase)
- **Enfoque:** Limpieza post-registro en el controller (Approach A), mismo patrón que `RegistrarClaseProgramada`.

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Endpoint | `POST /api/clases/inscribirAClase` | Endpoint donde se registra la inscripción | 75 |
| Flujo frontend | Pre-reserva en inscripción a clases | Envía `idPreReserva` en el body | 76 |
| Helper | `IDataAccessExecutor` | Abstracción para consultas/ejecución SQL | — |
| Entidad | `PreReservasDeHorario` | Entidad de pre-reservas de horario | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `FitnessCenterDbContext` | DataAccess | Contexto EF Core para acceder a BD |
| `IDataAccessExecutor` | DataAccess | Ejecutar queries SQL (`.QueryAsync<T>`) |
| `ILogger<InscripcionesService>` | Logging | Logear eventos y errores |
| `IInscripcionesService` | API | Servicio donde vive el wrapper de limpieza |

---

## 3. Cambios a realizar

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `DataAccess/Repositories/IInscripcionRepository.cs` | Agregar firmas de `EncontrarPreReservasAsync` + `EliminarPreReservasEspecificasAsync` |
| `DataAccess/Repositories/InscripcionRepository.cs` | Implementar ambos métodos usando `IDataAccessExecutor` |
| `API/Services/IInscripcionesService.cs` | Agregar firma de `LimpiarPreReservasEspecificasAsync` |
| `API/Services/InscripcionesService.cs` | Implementar wrapper `LimpiarPreReservasEspecificasAsync` (consulta + elimina + logs) |
| `API/Controllers/ClasesController.cs` | Ampliar `claseProgramadaInfo` y llamar al wrapper tras inscripción exitosa |

### 3.2 Contrato — Capa DataAccess (Repositorio)

Métodos a agregar en `IInscripcionRepository`:

| Método | Parámetros | Retorno |
|--------|-----------|---------|
| `EncontrarPreReservasAsync` | `int fkHoraLaboral, DateOnly fechaReservada, int idClase, string idEntrenador` | `Task<List<PreReservasDeHorario>>` |
| `EliminarPreReservasEspecificasAsync` | Colección de `IdPreReserva` | `Task<int>` (registros eliminados) |

### 3.3 Contrato — Capa API (Service)

Método a agregar en `IInscripcionesService`:

| Método | Parámetros | Retorno |
|--------|-----------|---------|
| `LimpiarPreReservasEspecificasAsync` | `int fkHoraLaboral, DateOnly fechaReservada, int idClase, string idEntrenador` | `Task<DTOResponse<bool>>` |

El wrapper **orquesta** dos llamadas al repositorio `EncontrarPreReservasAsync` y `EliminarPreReservasEspecificasAsync`, gestiona los logs y devuelve `true`/`false` según el resultado de la eliminación.

---

## 4. Acciones que debe realizar

### 4.1 `InscripcionRepository.EncontrarPreReservasAsync`

1. Construir la consulta SQL sobre la tabla `dbo.preReservasDeHorario` (nombre **singular**, físicamente en SQL) filtrando por los 4 datos: `fkHoraLaboral`, `fechaReservada`, `idClase`, `idEntrenador`.
2. Ejecutar la consulta usando `_dbExecutor.QueryAsync<PreReservasDeHorario>(FormattableString)`.
3. Devolver **todas** las pre-reservas que coincidan (pueden ser varias).
4. Envolver en `try/catch` y relanzar como `InvalidOperationException` con mensaje descriptivo (patrón existente del repositorio).

> **Nota técnica:** la tabla física en SQL es `dbo.preReservasDeHorario` (singular), aunque el `DbSet` de EF Core en `FitnessCenterDbContext` se llama `PreReservasDeHorarios` (plural). `QueryAsync<T>` usa `FromSqlInterpolated` sobre el `DbSet`, por lo que la query debe referenciar el **nombre físico real de la tabla** (`dbo.preReservasDeHorario`), no el nombre del `DbSet`.

### 4.2 `InscripcionRepository.EliminarPreReservasEspecificasAsync`

1. Recibir los `IdPreReserva` a eliminar.
2. Ejecutar la eliminación (mismo patrón que `ExecutarCancelacionAsync` / `EjecutarReagendacionAsync`), eliminando solo los registros con los ids proporcionados.
3. Devolver la cantidad de registros eliminados.
4. Envolver en `try/catch` y relanzar como `InvalidOperationException` con mensaje descriptivo.

### 4.3 `InscripcionesService.LimpiarPreReservasEspecificasAsync`

1. Llamar a `_repository.EncontrarPreReservasAsync(fkHoraLaboral, fechaReservada, idClase, idEntrenador)`.
2. Si no se encuentra ninguna pre-reserva, retornar `true` (no hay nada que limpiar).
3. Si se encuentran pre-reservas:
   - **Logear** (`LogInformation`) los `IdPreReserva` que van a eliminarse.
   - Identificar las pre-reservas cuyo `IdEntrenador` es `null` (error de negocio: toda clase programada debe tener entrenador definido) y **excluirlas** de la eliminación.
   - Llamar a `_repository.EliminarPreReservasEspecificasAsync` con las pre-reservas válidas.
4. Si la eliminación fue exitosa (se pudieron eliminar todas las esperadas):
   - **Logear** (`LogInformation`) los ids eliminados.
   - Retornar `true`.
5. Si alguna pre-reserva **no pudo eliminarse**:
   - **Logear** (`LogError`/`LogWarning`) los ids no eliminados.
   - Retornar `false`.
6. Envolver en `try/catch`, logear errores y retornar `false` (o error `500`) ante excepciones.

> **Regla de negocio:** toda clase programada debe tener un `FkEntrenador` definido. Si en la tabla de pre-reservas `IdEntrenador` es `null`, ese registro se considera un error de negocio, se **ignora** (no se elimina) y se loguea como no-procesable.

### 4.4 `ClasesController.InscribirAClase` (ampliar)

1. **Ampliar** la consulta `claseProgramadaInfo` (existe en líneas ~1012-1021) para traer también `fkClase` y `fkEntrenador` de la clase programada, además de `FechaDeLaClase` y el horario (`HorariosDeClasesProgramada[].FkHorarioLaboral`).
2. **Después** de la ejecución exitosa del SP `sp_registrarInsrcipcionAClase` (línea ~1114) y antes de retornar `Ok`, llamar a:
   ```
   service.LimpiarPreReservasEspecificasAsync(fkHoraLaboral, fechaDeLaClase → fechaReservada, fkClase, fkEntrenador)
   ```
3. Usar `ClasesProgramadas.FechaDeLaClase` como `fechaReservada` (decisión confirmada).
4. Mantener el flujo original intacto si no hay pre-reservas (compatibilidad hacia atrás).

---

## 5. Mapeo de datos de entrada

La pre-reserva se encuentra a partir de los datos de la **clase programada** y sus **horarios**:

| Campo pre-reserva (`PreReservasDeHorario`) | Fuente (clase programada) |
|--------------------------------------------|---------------------------|
| `FkHoraLaboral` | `ClasesProgramadas.HorariosDeClasesProgramada[].FkHorarioLaboral` |
| `FechaReservada` | `ClasesProgramadas.FechaDeLaClase` |
| `IdClase` | `ClasesProgramadas.FkClase` |
| `IdEntrenador` | `ClasesProgramadas.FkEntrenador` |

---

## 6. Inyección de dependencias

No requiere registros nuevos. Ya está registrado:

```csharp
builder.Services.AddScoped<IInscripcionesService, InscripcionesService>();
builder.Services.AddScoped<IInscripcionRepository, InscripcionRepository>();
builder.Services.AddScoped<IDataAccessExecutor, DataAccessExecutor>();
```

---

## 7. Criterios de aceptación

- [ ] `EncontrarPreReservasAsync` en `IInscripcionRepository` e `InscripcionRepository` usando `IDataAccessExecutor.QueryAsync`
- [ ] `EliminarPreReservasEspecificasAsync` en `IInscripcionRepository` e `InscripcionRepository` siguiendo el patrón de los métodos existentes
- [ ] `LimpiarPreReservasEspecificasAsync` en `IInscripcionesService` e `InscripcionesService` (wrapper que consulta → elimina → loguea → devuelve `bool`)
- [ ] El wrapper devuelve `true` cuando la eliminación es exitosa
- [ ] El wrapper devuelve `false` cuando alguna pre-reserva no pudo eliminarse
- [ ] Se loguean los `IdPreReserva` eliminados (`LogInformation`)
- [ ] Se loguean los `IdPreReserva` no eliminados (`LogError`/`LogWarning`)
- [ ] Las pre-reservas con `IdEntrenador` null se ignoran (error de negocio) y se loguean como no-procesables
- [ ] Se amplía `claseProgramadaInfo` en `InscribirAClase` para obtener `fkClase` y `fkEntrenador`
- [ ] La limpieza se llama tras la inscripción exitosa (`sp_registrarInsrcipcionAClase`) en `InscribirAClase`
- [ ] Se usa `ClasesProgramadas.FechaDeLaClase` como `fechaReservada`
- [ ] El flujo de inscripción funciona igual si no hay pre-reservas (compatibilidad hacia atrás)
- [ ] Se aplica el patrón N-layer y los helpers de BD (`IDataAccessExecutor`)
