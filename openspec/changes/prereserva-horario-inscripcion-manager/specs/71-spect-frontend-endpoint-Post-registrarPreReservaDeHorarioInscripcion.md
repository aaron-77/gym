# Spec: Endpoint Frontend POST registrarPreReservaDeHorarioInscripcion - Implementación

## 1. Resumen

Endpoint MVC POST en `HorariosController` del frontend que expone la creación de pre-reservas de horario del flujo de inscripción/reagendación hacia la UI JavaScript. Recibe un `DTOPreReservaDeHorarioInscripcion`, sobrescribe `idUsuarioQueReserva` con el claim del token JWT leído desde la cookie `AuthToken`, delega la operación al método `preReservarHorarioInscripcion` de `HorariosManager` (BL) y mapea la respuesta a `Ok`/`BadRequest`. Replica exactamente el patrón de autenticación del endpoint `PreReservarHorario` existente en el mismo controller. Sin tests de controller (los tests del manager cubren la cadena BL→API).

## 2. Contexto

- **Capa:** GymFrontend Controllers

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Manager BL | `HorariosManager.preReservarHorarioInscripcion` | Método BL que POSTea al API | 72 |
| DTO | `DTOPreReservaDeHorarioInscripcion` | Payload con validaciones DataAnnotations | 63 |
| Endpoint backend | `registrarPreReservaDeInscripcion` | Endpoint API de referencia (`POST /api/horarios/preReservarHorarioInscripcion`) | 66 |
| Endpoint base | `PreReservarHorario` | Endpoint frontend existente cuyo patrón de auth se clona | — |
| Util | `JwtTokenGenerator.ValidateIdToken` | Valida el token y devuelve los claims | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `HorariosManager` | BL | Inyectado vía DI; ya registrado como scoped en Program.cs |
| `JwtTokenGenerator` | BL.Utils | Inyectado en el constructor del controller (campo existente) |
| `ILogger<HorariosController>` | Logging | Logger del controller (campo existente) |

## 3. Endpoint a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/Controllers/HorariosController.cs` | Agregar endpoint al controller existente |

### 3.2 Contrato

- **Verbo HTTP:** POST
- **Ruta:** segmento `preReservarHorarioInscripcion` (resultado: `/Horarios/preReservarHorarioInscripcion`, siguiendo el atributo `[Route("[controller]")]` ya presente). El segmento coincide con la ruta del endpoint backend para mantener consistencia.
- **Nombre del método:** `registrarPreReservaDeHorarioInscripcion`
- **Modificador:** `async`, retorna `Task<IActionResult>`
- **Parámetro:** `DTOPreReservaDeHorarioInscripcion preReserva` con `[FromBody]`
- **Autorización:** Sin atributo `[Authorize]` (sigue el patrón del endpoint `PreReservarHorario` base, que no lo usa; la autenticación se resuelve vía cookie + claims manualmente)

### 3.3 Flujo de autenticación

| Paso | Acción | Detalle |
|------|--------|---------|
| 1 | Leer cookie | `Request.Cookies["AuthToken"]` obtiene el JWT del usuario |
| 2 | Validar token | `jwtTokenGenerator.ValidateIdToken(token)` devuelve la colección de claims |
| 3 | Extraer claim | Buscar el claim cuya key sea `ClaimTypes.NameIdentifier` o `JwtRegisteredClaimNames.Sub`; tomar `.Value` |
| 4 | Sobrescribir | Asignar ese valor a `preReserva.idUsuarioQueReserva` (sobrescribe cualquier valor que venga del body) |

> El paso 4 garantiza que el servidor decida el usuario que reserva a partir del token, no del body de la petición. El frontend JavaScript no puede suplantar el `idUsuarioQueReserva`.

### 3.4 Acciones que debe realizar

1. Leer la cookie `AuthToken` de la petición
2. Validar el token con `jwtTokenGenerator.ValidateIdToken` y obtener los claims
3. Extraer el valor del claim `NameIdentifier` o `Sub`
4. Sobrescribir `preReserva.idUsuarioQueReserva` con el valor del claim
5. Invocar `_horariosManager.preReservarHorarioInscripcion(preReserva)` y esperar la respuesta `DTOResponse<object?>`
6. Si `result.success` es true, retornar `Ok(result)`
7. Si `result.success` es false, retornar `BadRequest(result)`
8. En el bloque `catch (Exception ex)`: logear a `Console.WriteLine` con el nombre del método, la línea (vía `StackTrace`), la causa (`ex.GetType().Name - ex.Message`) y el stack trace; retornar `StatusCode(500, ...)` con un `DTOResponse<string>` sintético de `success = false`, `message = "Error interno del servidor al pre-reservar horario inscripción."` y `errors` con un `ErrorModel` cuyo `message` sea `ex.Message`

### 3.5 Patrones a aplicar

- **Auth cookie → claims → override:** Clonado exacto del endpoint `PreReservarHorario` (mismo orden de pasos, mismas APIs, mismas variables).
- **Delegación al Manager:** El controller NO llama al API directamente; delega en `HorariosManager` (capa BL).
- **Response passthrough:** `Ok(result)`/`BadRequest(result)` devuelven el `DTOResponse<object?>` del manager sin transformación.
- **Error handling uniforme:** `try/catch` con log a `Console` y `StatusCode(500, DTOResponse<string>)` sintético, idéntico al resto de endpoints del controller.

### 3.6 Inyección de dependencias

Sin cambios en DI. `HorariosManager`, `JwtTokenGenerator` y `ILogger<HorariosController>` ya están inyectados en el constructor del controller existente. El nuevo método reutiliza los campos privados `_horariosManager`, `jwtTokenGenerator` y `_logger`.

## 4. Archivos a modificar

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/Controllers/HorariosController.cs` | Agregar método `registrarPreReservaDeHorarioInscripcion` |

## 5. Criterios de aceptación

- [ ] El endpoint responde a `POST /Horarios/preReservarHorarioInscripcion`
- [ ] El método se llama `registrarPreReservaDeHorarioInscripcion` y es `async Task<IActionResult>`
- [ ] Recibe `DTOPreReservaDeHorarioInscripcion` desde el body con `[FromBody]`
- [ ] Lee la cookie `AuthToken` y valida el token con `jwtTokenGenerator.ValidateIdToken`
- [ ] Extrae el claim `NameIdentifier` o `Sub` y sobrescribe `idUsuarioQueReserva`
- [ ] Llama a `_horariosManager.preReservarHorarioInscripcion(preReserva)`
- [ ] Retorna `Ok(result)` cuando `success = true` y `BadRequest(result)` cuando `success = false`
- [ ] El `catch` logea a `Console` con método, línea, causa y stack trace
- [ ] El `catch` retorna `StatusCode(500, DTOResponse<string>)` con `success = false`
- [ ] Sin atributo `[Authorize]` (consistente con `PreReservarHorario`)
- [ ] No hay tests de controller (cubiertos por los tests del manager, spec 73)
