# Exploration: Pre-Reserva de Horario Inscripción — BL Manager + Frontend Endpoint

Change: `prereserva-horario-inscripcion-manager`
Date: 2026-08-19
Mode: hybrid (openspec + engram)

## Current State

El endpoint backend `POST /api/horarios/preReservarHorarioInscripcion` ya existe y está testeado. Este cambio agrega la capa BL (método en `HorariosManager`), sus tests de integración, y el endpoint del frontend MVC que lo consume.

### Backend (existente, no se toca)

- **API action**: `API/Controllers/HorariosController.cs` líneas 153-162 — `[Authorize(Roles = "empleado")]`, `[HttpPost("preReservarHorarioInscripcion")]`, `registrarPreReservaDeInscripcion` delega a `_horariosService.preReservarHorarioInscripcion(preReserva)` y responde vía `this.Responder(result)` (`API/Infraestructure/ResponderHelper.cs`: mapea `httpCode` → status code: 200→Ok, 201→Created, 400→BadRequest, 404→NotFound, resto→StatusCode).
- **Request DTO**: `DTO/Dtos/DTOPreReservaDeHorarioInscripcion.cs` — `idUsuarioQueReserva` (string? GUID 36 chars, Required), `fechaTentativa` (DateOnly, Required + FechaMinimaValida(1890)), `idHoraLaboral` (int, Required, Range≥1), `idClase` (int?, Range≥1), `idEntrenador` (string? GUID 36), `idClaseProgramada` (int, Required, Range≥1).
- **Tests del endpoint**: `GymWebApp.Tests/Integration/Features/Horarios/PreReservarHorarioInscripcionControllerTests.cs` — 1 happy path (`ConTodosLosDatosCorrectos_Devuelve200`, deserializa `DTOResponse<int>`, asserts `payload > 0`, cleanup con `PreReservarHorarioApiTestHelper.LimpiarPreReservasDeHorarioAsync`) + 5 sad paths (todos model-validation 400s: sin idUsuarioQueReserva, idEntrenador vacío, idClase 0, sin idClaseProgramada, sin fechaTentativa; deserializan `DTOResponse<object?>` y asertan `payload == null`, `httpCode == 400`, `errors` contiene la propiedad fallida).

### BL Manager (a modificar)

- **Archivo**: `BL/HorariosManager.cs` (89 líneas). Constructor: `HorariosManager(IHttpCustomClient httpClient)` (inyecta la INTERFAZ).
- **Template más cercano**: `PreReservarHorario(DTOPreReservaDeHorario)` líneas 69-87:
  - `JsonContent jsonCon = JsonContent.Create(preReserva);`
  - `string response = await _httpClient.post("api/Horarios/preReservarHorario", jsonCon);`
  - `JsonSerializer.Deserialize<DTOResponse<int>>(response, new JsonSerializerOptions { PropertyNameCaseInsensitive = true }) ?? new DTOResponse<int> { success = false, message = "Error de deserialización o respuesta vacía." }`
  - `catch (Exception ex)` → log a Console con StackTrace → retorna `new DTOResponse<int> { success = false, message = "Error al pre-reservar horario." }`
- **Paths de endpoints**: strings relativos HARDCODEADOS en el manager (`"api/Horarios/..."`). `EndpointsManager` (`BL/Utils/EndpointsManager.cs`, clase `EndPointsManager` en namespace `BL.EnPointsLogic`) solo resuelve base URLs y NO es referenciado por HorariosManager.
- **HttpCustomClient** (`BL/HttpCustomClient.cs`): `post()` NO lanza por status no-2xx — lee el body y lo devuelve como string SIEMPRE (líneas 35-66; a diferencia de `get()` que devuelve null en status no-éxito). Errores de red → catch → devuelve `null` (el `??` del manager lo cubre con respuesta sintética).

### Frontend (a modificar)

- **Stack REAL**: ASP.NET Core MVC .NET 8 (Razor Views + JS en wwwroot). NO es Blazor ni Node (la mención a "Blazor" en el AGENTS.md raíz es inexacta; `GymFrontend/AGENTS.md` dice MVC correctamente; `GymFrontend/appp/` es un build publicado, no fuente).
- **Controller**: `GymFrontend/Controllers/HorariosController.cs` (144 líneas) — `[Route("[controller]")] [ApiController]`, ctor inyecta `HorariosManager`, `JwtTokenGenerator`, `ILogger<HorariosController>`.
- **Template para el endpoint nuevo**: `PreReservarHorario` (líneas 100-142):
  1. Lee `Request.Cookies["AuthToken"]`, valida con `jwtTokenGenerator.ValidateIdToken(token)`, extrae claim `NameIdentifier`/`Sub` y SOBRESCRIBE `preReserva.idUsuarioQueReserva` (el JS envía `idUsuarioQueReserva: ''`).
  2. `var result = await _horariosManager.PreReservarHorario(preReserva);`
  3. `if (result.success) return Ok(result); return BadRequest(result);`
  4. catch → log → `StatusCode(500, new DTOResponse<string> {...})`.
- **DI** (`GymFrontend/Program.cs`): línea 95 `AddHttpClient<IHttpCustomClient, HttpCustomClient>(client => client.BaseAddress = baseApiUrlForClientHttp).AddHttpMessageHandler<AuthHeaderHandler>()` (AuthHeaderHandler en `BL/AuthHeaderHandler.cs` propaga el JWT de la cookie como Bearer al API); línea 108 `AddScoped<HorariosManager>()`.
- **horariosDelDia.js** (SOLO contexto, OUT OF SCOPE): `GymFrontend/wwwroot/js/horariosDelDia.js` línea 241 llama `realizarPeticionAPI('/Horarios/preReservarHorario', body, undefined, 'POST')`; en fallo consume `response.errors` (fidelidad de errores importa para UX).
- **Patrón alternativo existente**: `InscripcionesController.ReagendarInscripcion` es proxy puro (passthrough `Content(apiResponse, "application/json")`, sin manager) — change archivado `openspec/changes/archive/2026-07-30-frontend-post-reagendar-inscripcion/`. El scope de ESTE cambio exige el patrón manager-based.

### Tests de integración — estado actual

- **GAP CONFIRMADO**: NO existe ningún test en `GymWebApp.Tests` que ejercite una clase Manager de BL contra el API real (grep de `UsersManager|ClasesManager|HorariosManager|...` = 0 matches; los matches de `HttpCustomClient` son todos mocks/fakes).
- **Base existente**: `IntegrationTestBase` (`GymWebApp.Tests/Integration/Common/IntegrationTestBase.cs`) — `IClassFixture<CitasApiWebApplicationFactory<Program>>` + `IAsyncLifetime`; resetea BD en `InitializeAsync`; expone `Factory`, `Client`, `TestContainerHelper`; `[Collection("IntegrationTests")]` (`IntegrationTestCollections.cs`: `ICollectionFixture<TestContainerHelper>`, DisableParallelization).
- **Auth**: `SetAuthHeaderAsync()` → `Factory.AuthenticateAsync(Client)` → POST `/api/autenticar` con TestUser (empleado) de `appsettings.Testing.json` vía `ConfigHelper` → `payload.AccessToken` → `Client.DefaultRequestHeaders.Authorization = Bearer`.
- **Precedente de frontend-level con fake**: `CancelarReagendarApiErrorWebApplicationFactory` (deriva de `GymFrontendWebApplicationFactory<GymFrontend.Program>`) reemplaza `IHttpCustomClient` por `ApiErrorSimulatorClient` — prueba que la interfaz es intercambiable en DI, pero es un fake que lanza, NO un manager contra el API real.
- **Helpers reutilizables** (`GymWebApp.Tests/Integration/Helpers/`): `SlotDisponibleParaClaseProgramadaHelper`, `DatabaseHelper`, `PreReservarHorarioApiTestHelper` (NOTA: `LimpiarPreReservasDeHorarioAsync` está tipado para `DTOPreReservaDeHorario`, no para el DTO nuevo).
- `GymWebApp.Tests.csproj` ya referencia BL (línea 52) — construir el manager en tests no requiere referencias nuevas.

### Verificación empírica del gotcha payload:null (scratch app en /tmp, referenciando el DTO real)

| Target | JSON payload:null (validation 400) | Resultado |
|--------|-----------------------------------|-----------|
| `DTOResponse<int>` | `{"success":false,"httpCode":400,...,"payload":null}` | **THROWS `JsonException`** — "The JSON value could not be converted to System.Int32. Path: $.payload" |
| `DTOResponse<int?>` | idem | OK — success=false, httpCode=400, errors preservados, payload=null |
| `DTOResponse<object?>` | idem | OK — idem |
| `DTOResponse<int>` | payload:42 (éxito) | OK — payload=42 |
| `DTOResponse<object?>` | payload:42 | OK — payload=JsonElement (requiere `GetInt32()`) |

**Consecuencia**: si el método nuevo copia `PreReservarHorario` (`DTOResponse<int>`), TODOS los sad paths de validación (los 5 del endpoint) lanzan JsonException → el catch-all lo traga → retorna `{success=false, message="Error al..."}` GENÉRICO. Los tests replicando sad paths no podrían asertar httpCode=400 ni errors. **Bug latente equivalente ya existe en `PreReservarHorario`** (fuera de scope, pero flag).

**Precedente que sobrevive**: `ClasesManager.RegistrarClaseProgramada` y `ClasesManager.InscribirAClase` (`BL/ClasesManager.cs` líneas 172-210) retornan `Task<DTOResponse<int?>>` con la misma estructura — el patrón nullable-payload YA existe en BL. No hay precedente de `DTOResponse<object?>` en BL (solo en los tests del endpoint).

**Matiz importante**: los 400 de negocio (vía `ResponderHelper`) incluyen `payload = 0` (int default) → `DTOResponse<int>` los deserializa BIEN y preserva errors. Solo los 400 de MODEL VALIDATION (`InvalidModelStateResponseFactory` → `DTOResponse<object>` payload:null) rompen el T no-nullable. El JS del frontend consume `response.errors` en fallos, así que la fidelidad importa.

## Affected Areas

- `BL/HorariosManager.cs` — nuevo método POST a `api/Horarios/preReservarHorarioInscripcion` (~20 líneas, patrón PreReservarHorario/RegistrarClaseProgramada).
- `GymFrontend/Controllers/HorariosController.cs` — nuevo endpoint `registrarPreReservaDeHorarioInscripcion` (patrón `PreReservarHorario`).
- `GymWebApp.Tests/Integration/Features/Horarios/` — nueva clase de tests del manager (happy + 5 sad paths).
- `GymWebApp.Tests/Integration/Helpers/` — POSIBLE helper nuevo/extendido para cleanup del DTO de inscripción (decisión de spec).
- Sin cambios: API, DTO, DataAccess, horariosDelDia.js, vistas.

## Approaches

1. **Manager con `DTOResponse<int?>` (patrón ClasesManager)** — deserializar a nullable payload, retornar `Task<DTOResponse<int?>>`.
   - Pros: sobrevive payload:null (verificado); preserva httpCode/message/errors del API; precedente en `ClasesManager.RegistrarClaseProgramada`/`InscribirAClase`; los sad-path tests pueden replicar las aserciones del endpoint test (success=false, httpCode=400, errors con propiedad).
   - Cons: firma distinta a `PreReservarHorario` (inconsistencia cosmética dentro de HorariosManager); el consumidor frontend debe tratar payload como nullable.
   - Effort: Low.

2. **Manager con `DTOResponse<int>` (patrón exacto de PreReservarHorario)** — copia literal.
   - Pros: consistencia con el método hermano del mismo manager.
   - Cons: VERIFICADO que lanza JsonException en los 5 sad paths → catch-all traga → respuesta genérica sin errors/httpCode; los tests sad-path quedarían débiles (solo success=false); el JS pierde `response.errors`.
   - Effort: Low (pero tests débiles).

3. **Manager con `DTOResponse<object?>`** — como los tests del endpoint.
   - Pros: sobrevive nulls.
   - Cons: en éxito payload es JsonElement → requiere extracción manual a int; más frágil; sin precedente en BL.
   - Effort: Medium.

### Wiring de los tests del manager (transversal a 1-3)

- **Opción A (recomendada)**: heredar `IntegrationTestBase` + `[Collection("IntegrationTests")]`; tras `SetAuthHeaderAsync()`, construir `new HorariosManager(new HttpCustomClient(Client))` — el `Client` de la factory tiene BaseAddress = servidor in-memory, los paths relativos del manager funcionan, y el header Bearer fluye por `client.PostAsync`. Cero fixtures nuevos.
- **Opción B**: boot del frontend con `GymFrontendWebApplicationFactory` y reemplazo de `IHttpCustomClient` apuntando al servidor de `CitasApiWebApplicationFactory` — más fiel al flujo real del frontend pero mucho más wiring (dos hosts encadenados), sin precedente.

## Recommendation

**Approach 1 + wiring Opción A**: método `PreReservarHorarioInscripcion(DTOPreReservaDeHorarioInscripcion)` en `HorariosManager` retornando `Task<DTOResponse<int?>>` (patrón `ClasesManager.RegistrarClaseProgramada`), endpoint frontend `registrarPreReservaDeHorarioInscripcion` clonando `PreReservarHorario` (cookie→claims→override idUsuarioQueReserva→manager→Ok/BadRequest), tests heredando `IntegrationTestBase` con el manager construido sobre `Client`.

Decisiones abiertas para la fase propose:
- ¿`[Authorize(Roles = "empleado")]` en el endpoint frontend? (`PreReservarHorario` no lo tiene — confía en `ValidateIdToken`; `ReagendarInscripcion` sí lo tiene).
- ¿Cleanup del happy path: extender `PreReservarHorarioApiTestHelper` o helper nuevo para `DTOPreReservaDeHorarioInscripcion`?
- Sad paths por DTO tipado: el manager recibe `DTOPreReservaDeHorarioInscripcion`, así que "sin fechaTentativa" (omisión del campo) NO es expresable — default `DateOnly` = 0001-01-01 dispara `FechaMinimaValida(1890)` (error distinto al Required del endpoint test). Los otros 4 sad paths (null user, entrenador vacío, idClase 0, idClaseProgramada 0) sí son replicables con el DTO tipado. El spec debe definir el sad-path de fecha como "fecha inválida (año < 1890)" o aceptar la divergencia.

## Risks

1. **ALTO — payload:null deserialization (verificado empíricamente)**: copiar el patrón `DTOResponse<int>` rompe los 5 sad paths (JsonException tragada → respuesta genérica). Mitigación: `DTOResponse<int?>`.
2. **MEDIO — wiring de manager tests sin precedente**: ningún test existente ejercita un Manager contra el API real; la Opción A funciona con bloques existentes pero es infraestructura NUEVA (riesgo de sorpresas: p.ej. `HttpCustomClient.post` no valida status — aceptable aquí porque el manager solo deserializa el body).
3. **MEDIO — replicación de sad paths con DTO tipado**: el test "SinFechaTentativa" del endpoint no es 1:1 vía manager (ver decisión abierta arriba).
4. **BAJO — cleanup tipado**: `LimpiarPreReservasDeHorarioAsync` espera `DTOPreReservaDeHorario`; requiere helper nuevo/extendido.
5. **BAJO — bug latente en `PreReservarHorario` (BL)**: mismo problema de payload:null; fuera de scope, no tocar, pero documentado.

## Ready for Proposal

Yes. Toda la información necesaria para `sdd-propose` está recolectada: patrones exactos con líneas, verificación empírica del gotcha, gap de tests de manager con receta de wiring, y decisiones abiertas acotadas.
