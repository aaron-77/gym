# Design: Integration Tests for POST api/inscripciones/reagendar

## Technical Approach

6 tests de integración en `Integration/Features/Inscripciones/InscripcionesReagendarTests.cs` siguiendo el patrón de `InscripcionesControllerCancelarTests.cs` pero CORRIGIENDO los asserts de validación: la API YA retorna `DTOResponse<object>` para errores de modelo (via `InvalidModelStateResponseFactory` en Program.cs), por lo que los tests de validación deserializan como `DTOResponse<object>` en vez de verificar solo substring.

Infraestructura existente: `IntegrationTestBase`, `CitasApiWebApplicationFactory<Program>`, `TestContainerHelper`, `InscripcionTestHelper`, `FluentAssertions`.

## Architecture Decisions

### Decision: File Location

| Option | Tradeoff | Decision |
|--------|----------|----------|
| `IntegrationTests/` | No existe, inconsistente | ❌ Rechazado |
| `Integration/Features/Inscripciones/` | Sigue convención de `CancelarTests` | ✅ Elegido |

### Decision: Happy Path Seeding

| Opción | Tradeoff |
|--------|----------|
| `InscripcionTestHelper.SeedSingleInscripcionConFechaPosteriorAsync(connString)` + `CreateValidDestinationClassForReagendarAsync(connString, idInscripcion)` | Ambos existen, retornan null si no hay slots. El primero devuelve `(ClienteId, IdInscripcion)?` — la inscripción es **futura** (requisito del servicio). |
| Inline SQL directo | Duplica lógica, viola "NO HELPERS EN TESTS" |

**Choice**: Usar los helpers existentes con null-check + fallback `SeedFallbackAsync()`.

**Flujo completo del happy path**:
1. `InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(connectionString)` → crea inscripción con **fecha de hoy + hora futura**, devuelve `(clienteId, idInscripcion)?`
   - Internamente usa `SeedSingleInscripcionConHoraFuturaAsync` con `FiltroFecha.Igual, FiltroHora.Mayor` — garantiza que pasa la validación de `_validadorFecha.Validar`
2. Si es null → `SeedFallbackAsync(connectionString, year)` + reintento
3. `CreateValidDestinationClassForReagendarAsync(connectionString, idInscripcion)` → crea clase destino con **misma fkClase** y **fecha posterior** (usa `FiltroFecha.Mayor, FiltroHora.Mayor`), devuelve `int?`
4. `new ReagendarInscripcionRequest { IdInscripcion, IdClaseProgramada = idClaseDestino, IdCliente = clienteId }`

**Por qué FUTURA (fecha y hora)**: El servicio (`InscripcionesService.ReagendarInscripcionAsync`) valida que:
- La clase original tenga fecha/hora futura (paso 9 — via `_validadorFecha.Validar(fecha, hora)`)
- La clase destino tenga fecha MAYOR a la original (paso 10)
- La clase destino también sea futura (paso 11)
- Ambas compartan el mismo `fkClase` (paso 8)

### Decision: Response Type for Happy Path

**Choice**: Deserializar como `DTOResponse<bool>`.
**Rationale**: El servicio retorna `DTOResponse<bool>` con `payload = true` en éxito (verificado en `ServiceReagendarInscripcionTests.cs`). El controller envuelve en `Ok(result)`.

### Decision: Validation Error Assertions (UPDATED)

| Antes (diseño original) | Ahora (correcto) |
|-------------------------|-------------------|
| Asumía `ValidationProblemDetails` → assert solo status + substring | Deserializar como `DTOResponse<object>` y verificar `success=false`, `httpCode=400`, `errors[0].propiedad` |

**Rationale**: `API/Program.cs` (líneas 191-213) ya configura `InvalidModelStateResponseFactory` para retornar `DTOResponse<object>` usando `ResponseManager.BuildResponse<object>()`. No existe `ValidationProblemDetails`. Este es el comportamiento REAL de la API. El test de cancelación existente tiene el mismo error conceptual en sus comentarios (líneas 78-79), pero los asserts funcionan porque el texto del error existe igual en `errors[0].message`.

## API Configuration Change

**No requiere cambios.** `API/Program.cs` ya tiene desde su creación:

```
builder.Services.Configure<ApiBehaviorOptions>(options =>
{
    options.InvalidModelStateResponseFactory = context =>
    {
        var errors = context.ModelState
            .Where(e => e.Value?.Errors.Count > 0)
            .SelectMany(kvp => kvp.Value!.Errors.Select(e => new ErrorModel
            {
                message = e.ErrorMessage,
                propiedad = kvp.Key
            }))
            .ToList();

        var response = ResponseManager.BuildResponse<object>(
            success: false, httpCode: 400,
            message: "Error de validación",
            errors: errors, payload: null);

        return new BadRequestObjectResult(response);
    };
});
```

Esto retorna `DTOResponse<object>` con status 400 para toda validación fallida de DataAnnotations (`[Range]`, `[Required]`, etc.). No tocar.

## Data Flow

```
Test Class (xUnit Fact)
  │
  ├─ Arrange: Seed BD via helpers → Build ReagendarInscripcionRequest
  ├─ Act:     POST /api/inscripciones/reagendar → HttpClient
  └─ Assert:  StatusCode + DTOResponse<bool> | DTOResponse<object>
                    │
                    ▼
         InscripcionesController.ReagendarInscripcion()
              │
              ├─ [Authorize(Roles = "empleado")] → 401
              ├─ Guard: GUID válido → 400
              ├─ Guard: usuario existe → 404
              ├─ Guard: request != null → 400
              ├─ Guard: IdInscripcion > 0 → 400
              ├─ Guard: IdClaseProgramada > 0 → 400
              ├─ Guard: IdCliente not empty → 400
              └─ Service.ReagendarInscripcionAsync() → DTOResponse<bool>
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `GymWebApp.Tests/Integration/Features/Inscripciones/InscripcionesReagendarTests.cs` | Create | 6 tests siguiendo patrón de CancelarTests pero con asserts correctos de DTOResponse |

## Test Design — Detailed

### Test 1: `Reagendar_InscripcionValida_RetornaOk`

**Arrange**:
1. `await SetAuthHeaderAsync()`
2. `var seedResult = await InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(TestContainerHelper.ConnectionString)`
   - Crea inscripción con **hoy + hora futura**, devuelve `(string ClienteId, int IdInscripcion)?`
   - Garantiza que pasa `_validadorFecha.Validar(fecha, hora)` del servicio
   - Si null → `SeedFallbackAsync(connectionString, añoActual)` + reintento
3. `(clienteId, idInscripcion) = seedResult!.Value`
4. `var idClaseDestino = await InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync(TestContainerHelper.ConnectionString, idInscripcion)`
   - Crea clase destino con **misma fkClase** + **fecha posterior** (futura en fecha y hora)
5. Construir `new ReagendarInscripcionRequest { IdInscripcion = idInscripcion, IdClaseProgramada = idClaseDestino!.Value, IdCliente = clienteId }`

**Act**: `await Client.PostAsJsonAsync("/api/inscripciones/reagendar", request)`

**Assert**:
1. `response.StatusCode.Should().Be(HttpStatusCode.OK)`
2. `var result = await response.Content.ReadFromJsonAsync<DTOResponse<bool>>()`
3. `result!.success.Should().BeTrue()`
4. `result.httpCode.Should().Be(200)`
5. `result.payload.Should().BeTrue()`

### Test 2: `Reagendar_IdInscripcionCero_RetornaBadRequest` (UPDATED assert)

**Arrange**: `await SetAuthHeaderAsync()`

**Act**:
```csharp
var response = await Client.PostAsJsonAsync("/api/inscripciones/reagendar",
    new ReagendarInscripcionRequest { IdInscripcion = 0, IdClaseProgramada = 1, IdCliente = "valid-id" });
```

**Assert**:
1. `response.StatusCode.Should().Be(HttpStatusCode.BadRequest)`
2. `var result = await response.Content.ReadFromJsonAsync<DTOResponse<object>>()`
3. `result.Should().NotBeNull()`
4. `result!.success.Should().BeFalse()`
5. `result.httpCode.Should().Be(400)`
6. `result.errors.Should().Contain(e => e.propiedad == "IdInscripcion" && e.message.Contains("ID de inscripci"))`

### Test 3: `Reagendar_IdClaseProgramadaCero_RetornaBadRequest` (UPDATED assert)

**Act**:
```csharp
var response = await Client.PostAsJsonAsync("/api/inscripciones/reagendar",
    new ReagendarInscripcionRequest { IdInscripcion = 1, IdClaseProgramada = 0, IdCliente = "valid-id" });
```

**Assert**:
1. `response.StatusCode.Should().Be(HttpStatusCode.BadRequest)`
2. `var result = await response.Content.ReadFromJsonAsync<DTOResponse<object>>()`
3. `result!.success.Should().BeFalse()`
4. `result.httpCode.Should().Be(400)`
5. `result.errors.Should().Contain(e => e.propiedad == "IdClaseProgramada" && e.message.Contains("ID de clase programada"))`

### Test 4: `Reagendar_IdClienteVacio_RetornaBadRequest` (UPDATED assert)

**Act**:
```csharp
var response = await Client.PostAsJsonAsync("/api/inscripciones/reagendar",
    new ReagendarInscripcionRequest { IdInscripcion = 1, IdClaseProgramada = 1, IdCliente = "" });
```

**Assert**:
1. `response.StatusCode.Should().Be(HttpStatusCode.BadRequest)`
2. `var result = await response.Content.ReadFromJsonAsync<DTOResponse<object>>()`
3. `result!.success.Should().BeFalse()`
4. `result.httpCode.Should().Be(400)`
5. `result.errors.Should().Contain(e => e.propiedad == "IdCliente" && e.message.Contains("ID del cliente"))`

### Test 5: `Reagendar_InscripcionNoExiste_RetornaNotFound` (unchanged)

**Act**: `IdInscripcion = 999999`

**Assert**:
1. `response.StatusCode.Should().Be(HttpStatusCode.NotFound)`
2. `var result = await response.Content.ReadFromJsonAsync<DTOResponse<bool>>()`
3. `result!.success.Should().BeFalse()`
4. `result.httpCode.Should().Be(404)`

### Test 6: `Reagendar_SinAutenticacion_RetornaUnauthorized` (unchanged)

**Arrange**: `ClearAuthHeader()`

**Assert**: Solo status 401.

## Request/Response Examples

### Happy Path — Response (200)
```json
{
  "success": true,
  "httpCode": 200,
  "message": "Inscripción reagendada exitosamente",
  "errors": [],
  "payload": true
}
```

### Validation Error — Response (400, via DTOResponse — UPDATED)
```json
{
  "success": false,
  "httpCode": 400,
  "message": "Error de validación",
  "errors": [
    { "message": "El ID de inscripción debe ser mayor a 0", "propiedad": "IdInscripcion" }
  ],
  "payload": null
}
```

### Not Found — Response (404, via DTOResponse)
```json
{
  "success": false,
  "httpCode": 404,
  "message": "Inscripción no encontrada",
  "errors": [{"message": "La inscripción no existe.", "propiedad": null}],
  "payload": false
}
```

### Unauthorized — Response (401)
```
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Bearer
```

## Dependencies

| Test | Helpers | Auth |
|------|---------|------|
| InscripcionValida | `SeedFreshInscripcionAndReturnIdAsync`, `CreateValidDestinationClassForReagendarAsync`, `SeedFallbackAsync` | `SetAuthHeaderAsync` |
| IdInscripcionCero | Ninguno | `SetAuthHeaderAsync` |
| IdClaseProgramadaCero | Ninguno | `SetAuthHeaderAsync` |
| IdClienteVacio | Ninguno | `SetAuthHeaderAsync` |
| InscripcionNoExiste | Ninguno | `SetAuthHeaderAsync` |
| SinAutenticacion | Ninguno | `ClearAuthHeader` |

## Edge Cases / Gotchas

1. **Seed puede retornar null** — sin horarios disponibles para hoy. Usar fallback `SeedFallbackAsync`.
2. **CreateValidDestinationClassForReagendarAsync puede retornar null** — sin slots con fecha > hoy. Fallback + reintento.
3. **~~ValidationProblemDetails vs DTOResponse~~ → DTOResponse SIEMPRE** — la API ya retorna `DTOResponse<object>` para validación de modelo via `InvalidModelStateResponseFactory`. Todos los tests (incluyendo validación) deben deserializar como `DTOResponse<T>`. El test de cancelación existente (`CancelarTests`) tiene asserts débiles que funcionan de casualidad y comentarios incorrectos — NO replicar ese error.
4. **No existe ReagendarInscripcionRequestFactory** — `ReagendacionInscripcionFactory` crea `DTOReagendacionDeInscripcion` para el endpoint OLD. Crear request inline.
5. **Helper correcto**: Usar `SeedFreshInscripcionAndReturnIdAsync` (alias de `SeedSingleInscripcionConHoraFuturaAsync`) que valida FECHA **Y** HORA futura (`FiltroFecha.Igual, FiltroHora.Mayor`). NO usar `InscripcionEndpointHelper.SeedFreshInscripcionAsync` (devuelve solo `string clienteId`, no tiene el `idInscripcion` que necesitamos).

## Testing Strategy

| Layer | What | Approach |
|-------|------|----------|
| Integration | POST api/inscripciones/reagendar | 6 tests via HTTP real, BD real en Docker |
| Unit | (cubierto por spec 40) | Ya existen `ServiceReagendarInscripcionTests` |

## Open Questions

- [x] **File location**: `Integration/Features/Inscripciones/`
- [x] **API configuration**: Ya existe en Program.cs líneas 191-213, no requiere cambios
- [ ] **Mensaje exacto del happy path**: Verificar en `InscripcionesService.ReagendarInscripcionAsync` el texto de `message`. Provisionalmente `result.message.Should().Contain("exitosamente")`
