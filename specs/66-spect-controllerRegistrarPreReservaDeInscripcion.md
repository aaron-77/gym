# Spec: registrarPreReservaDeInscripcion - Endpoint en HorariosController

## 1. Resumen

Endpoint HTTP en `HorariosController` que expone la creación de pre-reservas de horario asociadas al flujo de inscripciones y reagendaciones. Recibe un `DTOPreReservaDeHorarioInscripcion`, delega la operación al método `preReservarHorarioInscripcion` de `HorariosService` y utiliza `ResponderHelper` para convertir la respuesta `DTOResponse<int>` del servicio en el código HTTP correspondiente.

## 2. Contexto

- **Capa:** API Controllers

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Service | `preReservarHorarioInscripcion` | Método de `HorariosService` que ejecuta el SP | 64 |
| DTO | DTOPreReservaDeHorarioInscripcion | Payload de entrada con validaciones DataAnnotations | 63 |
| Helper | ResponderHelper | Extiende `ControllerBase` para mapear `DTOResponse<T>` a `IActionResult` | — |
| Endpoint base | `registrarPreReservaDeHorario` | Endpoint existente con patrón similar | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| HorariosService | API Services | Contiene la lógica de creación de la pre-reserva |
| ILogger<HorariosController> | ASP.NET Core | Para logging de inicio y fin de operación |

## 3. registrarPreReservaDeInscripcion a crear

### 3.1 Archivo

| Archivo | Descripción |
|---------|-------------|
| `API/Controllers/HorariosController.cs` | Endpoint a agregar en el controller existente |

### 3.2 Firma

```csharp
[Authorize(Roles = "empleado")]
[HttpPost("preReservarHorarioInscripcion")]
public async Task<ActionResult<DTOResponse<int>>> registrarPreReservaDeInscripcion([FromBody] DTOPreReservaDeHorarioInscripcion preReserva)
```

### 3.3 Parámetros de entrada

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| preReserva | `DTOPreReservaDeHorarioInscripcion` | Datos de la pre-reserva a crear, validados por DataAnnotations gracias a `[ApiController]` |

### 3.4 Retorno

- `ActionResult<DTOResponse<int>>` — Respuesta HTTP cuyo código coincide con el `httpCode` del `DTOResponse<int>` devuelto por el servicio.

### 3.5 Acciones que debe realizar

1. Loggear el inicio de la operación incluyendo el `idUsuarioQueReserva` y la `fechaTentativa` recibidos
2. Invocar `_horariosService.preReservarHorarioInscripcion(preReserva)`
3. Recibir la respuesta `DTOResponse<int>` del servicio
4. Utilizar `this.Responder(result)` para convertir la respuesta del servicio en el `IActionResult` correspondiente
5. No capturar excepciones adicionales, ya que el servicio retorna respuestas de error en lugar de lanzarlas

### 3.6 Patrones a aplicar

- **Autorización por rol:** Restringir el acceso al rol `empleado` mediante `[Authorize(Roles = "empleado")]`
- **Ruta REST:** Usar verbo HTTP `POST` con ruta descriptiva del recurso
- **Model binding:** Recibir el DTO con `[FromBody]` para aprovechar la validación automática de `[ApiController]`
- **Responder pattern:** Usar `ResponderHelper` para mantener sincronizados el `httpCode` interno del DTO con el código HTTP de la respuesta

### 3.7 Manejo de errores

- El servicio es responsable de capturar excepciones y retornar respuestas `DTOResponse<int>` con `httpCode` adecuado
- El controller solo delega y mapea la respuesta mediante `ResponderHelper`
- Errores de validación del modelo (DataAnnotations) son manejados automáticamente por `[ApiController]` antes de llegar al método

## 4. Archivos a modificar

| Archivo | Descripción |
|---------|-------------|
| `API/Controllers/HorariosController.cs` | Agregar endpoint `registrarPreReservaDeInscripcion` |
| `API/Infraestructure/ResponderHelper.cs` | Ya existe; verificar que esté disponible para uso |

## 5. Criterios de aceptación

- [ ] El endpoint está decorado con `[Authorize(Roles = "empleado")]`
- [ ] El endpoint responde a `POST /api/horarios/preReservarHorarioInscripcion`
- [ ] El método se llama `registrarPreReservaDeInscripcion`
- [ ] Recibe `DTOPreReservaDeHorarioInscripcion` desde el body
- [ ] Llama a `_horariosService.preReservarHorarioInscripcion(preReserva)`
- [ ] Retorna el resultado usando `this.Responder(result)`
- [ ] No repite lógica de manejo de errores que ya está en el servicio
- [ ] La respuesta HTTP coincide con el `httpCode` del `DTOResponse<int>`
