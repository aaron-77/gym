# Spec: ServiceReagendarInscripcion

## 1. Resumen

Crear un servicio para reagendar inscripciones que valide que la inscripción exista,
que sea de una fecha futura o del día actual con hora posterior, que la clase programada
exista, y ejecute el procedimiento almacenado de reagendación.

## 2. Contexto

- **Capa:** API Services

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Procedimiento | `dbo.sp_procesoCompletoReagendacionDeInscripcion` | Procedimiento de reagendación | - |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `FitnessCenterDbContext` | DataAccess | Contexto de EF Core para acceder a la BD |
| `ILogger` | Logging | Logear errores y eventos |

## 3. Servicio a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Services/IServiceReagendarInscripcion.cs` | Interfaz |
| `API/Services/ServiceReagendarInscripcion.cs` | Implementación |

### 3.2 Contrato

El servicio debe exponer un método asíncrono que reciba `int idInscripcion, int idClaseProgramada, string idCliente` y devuelva `Task<DTOResponse<bool>>`.

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | ID inscripción es mayor a 0 | Guard clause | 400 |
| 2 | ID clase programada es mayor a 0 | Guard clause | 400 |
| 3 | ID cliente no es NULL, vacío o whitespace | Guard clause | 400 |
| 4 | Inscripción existe en BD | `FindAsync` | 404 |
| 5 | Fecha inscripción >= fecha actual | Comparación de fechas | 400 |
| 6 | Si es fecha actual, hora clase > hora actual | Comparación de horas | 400 |
| 7 | Clase programada existe en BD | `FindAsync` | 404 |
| 8 | Ejecutar procedimiento almacenado | `ExecuteSqlInterpolatedAsync` | 500 |

### 3.4 Acciones que debe realizar

1. Validar que `idInscripcion` sea mayor a 0
2. Validar que `idClaseProgramada` sea mayor a 0
3. Validar que `idCliente` no sea NULL, vacío o whitespace
4. Buscar la inscripción en la BD usando `FindAsync`
5. Si la inscripción no existe, retornar error 404
6. Obtener la fecha y hora de la clase programada de la inscripción
7. Validar que la fecha de la inscripción sea mayor o igual a la fecha actual
8. Si es la misma fecha, validar que la hora de la clase programada sea mayor a la hora actual
9. Si la validación de fecha/hora falla, retornar error 400
10. Buscar la clase programada destino en la BD usando `FindAsync`
11. Si la clase programada no existe, retornar error 404
12. Ejecutar el procedimiento almacenado `sp_procesoCompletoReagendacionDeInscripcion`
13. Guardar la respuesta del procedimiento
14. Retornar la respuesta del procedimiento

### 3.5 Patrones a aplicar

- **Guard clauses:** Validaciones tempranas al inicio del método
- **ResponseManager:** Usar `ResponseManager.BuildResponse<T>()` para construir respuestas
- **ErrorModel:** Crear lista de `ErrorModel` con propiedad y mensaje descriptivo
- **Logging:** Usar `ILogger` con `LogError` en catch, incluir `idInscripcion` en el log
- **Async/Await:** Todo el método debe ser async
- **Try/Catch:** Envolver la lógica principal en try/catch

### 3.6 Inyección de dependencias

Registrar en `Program.cs`:
```csharp
services.AddScoped<IServiceReagendarInscripcion, ServiceReagendarInscripcion>();
```

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `API/Services/IServiceReagendarInscripcion.cs` | Interfaz del servicio |
| `API/Services/ServiceReagendarInscripcion.cs` | Implementación del servicio |
| `API/Program.cs` | Modificar para registrar DI |

## 5. Criterios de aceptación

- [ ] Servicio con interfaz e implementación
- [ ] Validación de idInscripcion > 0
- [ ] Validación de idClaseProgramada > 0
- [ ] Validación de idCliente no vacío
- [ ] Validación de existencia de inscripción
- [ ] Validación de fecha >= fecha actual
- [ ] Validación de hora > hora actual si es fecha de hoy
- [ ] Validación de existencia de clase programada destino
- [ ] Ejecución de procedimiento almacenado
- [ ] Respuesta del procedimiento devuelta
- [ ] DI registrada en Program.cs
- [ ] Manejo de errores con ResponseManager
- [ ] Logging de errores con ILogger
