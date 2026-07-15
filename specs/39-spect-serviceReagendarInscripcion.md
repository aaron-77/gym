# Spec: ReagendarInscripcionAsync (InscripcionesService)

## 1. Resumen

Método para reagendar inscripciones que valida que la inscripción exista,
que sea de una fecha futura o del día actual con hora posterior, que la clase programada
destino exista, que el tipo de clase coincida, que la fecha destino sea posterior a la original,
y ejecute el procedimiento almacenado de reagendación.
Se implementará como parte de `InscripcionesService`.

## 2. Contexto

- **Capa:** API Services
- **Servicio unificado:** `InscripcionesService` — implementa `IInscripcionesService`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Procedimiento | `dbo.sp_procesoCompletoReagendacionDeInscripcion` | Procedimiento de reagendación | - |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `FitnessCenterDbContext` | DataAccess | Contexto de EF Core para acceder a la BD |
| `IValidadorFechaCancelacionInscripcion` | BL | Validar fecha y hora (reutiliza el mismo validador) |
| `IDataAccessExecutor` | DataAccess | Ejecutar procedimientos almacenados |
| `ILogger<InscripcionesService>` | Logging | Logear errores y eventos |

## 3. Método en el servicio unificado

### 3.1 Contrato

```csharp
Task<DTOResponse<bool>> ReagendarInscripcionAsync(int idInscripcion, int idClaseProgramada, string idCliente);
```

### 3.2 Archivos

| Archivo | Descripción |
|---------|-------------|
| `API/Services/IInscripcionesService.cs` | Interfaz unificada (contendrá este método) |
| `API/Services/InscripcionesService.cs` | Implementación unificada |

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Error |
|------|-----------|--------|-------|
| 1 | ID inscripción es mayor a 0 | Guard clause | 400 |
| 2 | ID clase programada es mayor a 0 | Guard clause | 400 |
| 3 | ID cliente no es NULL, vacío o whitespace | Guard clause | 400 |
| 4 | Inscripción existe en BD (con Include de clase programada + horarios) | `FirstOrDefaultAsync` | 404 |
| 5 | Fecha inscripción >= fecha actual | `IValidadorFechaCancelacionInscripcion.Validar` | 400 |
| 6 | Si es fecha actual, hora clase > hora actual | `IValidadorFechaCancelacionInscripcion.Validar` | 400 |
| 7 | Clase programada destino existe en BD | `FindAsync` | 404 |
| 8 | Tipo de clase (fkClase) de la clase programada original coincide con el de la clase programada destino | Comparación directa | 400 |
| 9 | Fecha de la clase programada destino > fecha de la clase programada original | Comparación directa | 400 |
| 10 | Ejecutar procedimiento almacenado | `IDataAccessExecutor.ExecuteAsync` | 500 |

### 3.4 Acciones que debe realizar

1. Validar que `idInscripcion` sea mayor a 0
2. Validar que `idClaseProgramada` sea mayor a 0
3. Validar que `idCliente` no sea NULL, vacío o whitespace
4. Buscar la inscripción en la BD incluyendo `FkProgramacionClaseNavigation`, sus `HorariosDeClasesProgramadas` y el `FkHorarioLaboralNavigation`
5. Si la inscripción no existe, retornar error 404
6. Obtener la fecha y hora de la clase programada de la inscripción
7. Validar fecha y hora usando `IValidadorFechaCancelacionInscripcion.Validar(fechaClase, horaInicio)`
8. Si la validación de fecha/hora falla, retornar error 400
9. Buscar la clase programada destino en la BD usando `FindAsync`
10. Si la clase programada no existe, retornar error 404
11. Validar que el `fkClase` de la clase programada original (obtenida de la inscripción) sea igual al `fkClase` de la clase programada destino
12. Si no coinciden, retornar error 400 con mensaje "El tipo de clase de la clase programada destino no coincide con el tipo de clase de la inscripción original"
13. Validar que `claseDestino.FechaDeLaClase > claseProgramadaOriginal.FechaDeLaClase`
14. Si la fecha destino es menor o igual, retornar error 400 con mensaje "La fecha de la clase programada destino debe ser posterior a la fecha de la clase original"
15. Ejecutar el procedimiento almacenado `sp_procesoCompletoReagendacionDeInscripcion` via `IDataAccessExecutor.ExecuteAsync`
16. Retornar `true` en el payload

### 3.5 Inyección de dependencias

No requiere registro adicional. Ya está registrado en `Program.cs`:
```csharp
builder.Services.AddScoped<IInscripcionesService, InscripcionesService>();
```

### 3.6 Dependencias adicionales ya registradas

```csharp
builder.Services.AddScoped<IValidadorFechaCancelacionInscripcion, ValidadorFechaCancelacionInscripcion>();
builder.Services.AddScoped<IDataAccessExecutor, DataAccessExecutor>();
```

## 4. Criterios de aceptación

- [ ] Método `ReagendarInscripcionAsync` en `IInscripcionesService` e `InscripcionesService`
- [ ] Validación de idInscripcion > 0
- [ ] Validación de idClaseProgramada > 0
- [ ] Validación de idCliente no vacío
- [ ] Validación de existencia de inscripción con EF Include chain
- [ ] Validación de fecha >= fecha actual con `IValidadorFechaCancelacionInscripcion`
- [ ] Validación de hora > hora actual si es fecha de hoy
- [ ] Validación de existencia de clase programada destino
- [ ] Validación de que el tipo de clase (fkClase) de la clase programada original coincide con el de la clase programada destino
- [ ] Validación de que la fecha de la clase programada destino es posterior a la fecha de la clase programada original
- [ ] Ejecución de procedimiento almacenado con `IDataAccessExecutor.ExecuteAsync`
- [ ] DI existente (no requiere nuevos registros)
- [ ] Manejo de errores con `ResponseManager`
- [ ] Logging de errores con `ILogger`
