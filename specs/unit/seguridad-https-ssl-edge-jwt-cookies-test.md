# Spec: Pruebas unitarias - Seguridad HTTPS SSL-edge JWT y Cookies

## 1. Resumen

Pruebas unitarias que fijan el contrato definido en `79-spect-seguridad-https-ssl-edge-jwt-cookies`:

- Los tokens JWT se generan SIEMPRE con audiencias HTTP (`BackendAudiencie` / `FrontAudiencie`), nunca con las variantes SSL.
- La validación manual de tokens acepta SOLO audiencias HTTP y rechaza las variantes SSL.
- La variable `ASPNETCORE_URLS` ya no influye en la elección de audiencia al generar tokens.
- La cookie de autenticación lleva el flag `Secure` únicamente cuando el request efectivo es HTTPS (`Request.IsHttps`).

Son pruebas unitarias puras: sin base de datos, sin HTTP real, sin contenedores. La única
manipulación de entorno es setear la variable `SECRET_TOKEN_KEY` en el fixture.

## 2. Contexto

- **Capa:** BL (`BL.Utils.JwtTokenGenerator`) y GymFrontend (`CookieService`)
- **Ubicación de las pruebas:** `GymWebApp.Tests/Unit/Seguridad/`

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Clase bajo prueba | `BL/Utils/JwtTokenGenerator.cs` | Generación y validación de tokens JWT (modificada por spec 79) | spect-79 |
| Clase bajo prueba | `GymFrontend/Services/CookieService.cs` | Opciones de cookies de autenticación (sin modificar, se fija su contrato) | spect-79 |
| Configuración | `DTO/Dtos/JwtSettings.cs` | Audiencias, issuer y expiración del JWT | — |
| Configuración | `DTO/Dtos/ClaimsSettings.cs` | Claims por tipo de token (dependencia del ctor, vacía por defecto) | — |
| Entidad | `DataAccess/Identity/ApplicationUser.cs` | Usuario usado como entrada de generación de tokens | — |
| Repositorios | `IAccessTokenRepository`, `IRefreshTokenRepository` | Dependencias del ctor; se mockean | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| xUnit | Framework | Atributos `[Fact]` |
| NSubstitute | Mocking | Mocks de repositorios y `IHttpContextAccessor` |
| FluentAssertions | Aserciones | Aserciones fluidas |
| `Microsoft.Extensions.Options` | Configuración | `Options.Create` para `JwtSettings` y `ClaimsSettings` |
| `JwtSecurityTokenHandler` | JWT | Lectura del claim `aud` de tokens generados |
| `DefaultHttpContext` | HTTP | Contexto en memoria para `CookieService` (permite setear `Request.IsHttps`) |
| Variable de entorno `SECRET_TOKEN_KEY` | Entorno | Clave de firma HS256; se setea en el fixture (mín. 32 bytes) |

## 3. Alcance

Se prueban únicamente los comportamientos del spec 79. No se agregan pruebas derivadas.

| Se prueba | No se prueba |
|-----------|--------------|
| Audiencia de Access Token generado | Refresh tokens, roles, claims extendidos |
| Audiencia de ID Token generado | Validación de refresh token |
| Aceptación de audiencia HTTP en validación | Guard clauses de `CookieService` (response null, key vacía) |
| Rechazo de audiencia SSL en validación | Redirección HTTPS (candidato a integración, fuera de este spec de unidad) |
| No influencia de `ASPNETCORE_URLS` en generación | `GetRoles`, `GetUserName`, `GetClaimValue` (sin cambios en spec 79) |
| Flag `Secure` de la cookie según `Request.IsHttps` | E2E por nginx (fuera de alcance) |

## 4. Pruebas a implementar

### 4.1 `JwtTokenGeneratorTests` — `GymWebApp.Tests/Unit/Seguridad/JwtTokenGeneratorTests.cs`

Instanciación REAL de `JwtTokenGenerator` (no mock del generador) con:

- `Options.Create(new JwtSettings { Issuer, BackendAudiencie, BackendAudienceSsl, FrontAudiencie, FrontendAudienceSsl, ExpiryMinutes, RefreshTokenExpiryDays })`
- `Options.Create(new ClaimsSettings())`
- Mocks NSubstitute para `IAccessTokenRepository`, `IRefreshTokenRepository` y `IHttpContextAccessor`
- `Environment.SetEnvironmentVariable("SECRET_TOKEN_KEY", ...)` en el constructor
- `ApplicationUser` creada directamente con `Id`, `UserName`, `Email`, `NombreCompleto`, `Curp`
- Lectura del claim `aud` con `JwtSecurityTokenHandler().ReadJwtToken(token).Claims`

| # | Prueba | Verifica | Referencia spec 79 |
|---|--------|----------|--------------------|
| 1 | `GenerateAccessToken_ReturnsTokenWithBackendAudiencie` | El claim `aud` del Access Token es `BackendAudiencie` y NO `BackendAudienceSsl` | Contrato 3.2 (generación con audiencia HTTP) |
| 2 | `GenerateIdToken_ReturnsTokenWithFrontAudiencie` | El claim `aud` del ID Token es `FrontAudiencie` y NO `FrontendAudienceSsl` | Contrato 3.2 (generación con audiencia HTTP) |
| 3 | `ValidateAccessToken_AcceptsHttpAudience_ReturnsClaims` | Un token generado con `ssl:false` valida OK con `ValidateAccessToken` (devuelve claims no vacíos) | Contrato 3.2 (validación solo audiencia HTTP) |
| 4 | `ValidateAccessToken_RejectsSslAudience_ReturnsNull` | Un token generado con `ssl:true` (audiencia `BackendAudienceSsl`) NO valida: `ValidateAccessToken` devuelve `null` | Contrato 3.2 (las audiencias SSL quedan fuera) |
| 5 | `ValidateIdToken_AcceptsHttpAudience_ReturnsClaims` | Un token `ssl:false` valida OK con `ValidateIdToken` | Contrato 3.2 |
| 6 | `ValidateIdToken_RejectsSslAudience_ReturnsNull` | Un token `ssl:true` (audiencia `FrontendAudienceSsl`) NO valida: devuelve `null` | Contrato 3.2 |
| 7 | `GenerateAccessToken_AudienceIsHttp_EvenWhenAspnetcoreUrlsIsHttps` | Con `ASPNETCORE_URLS=https://localhost:5001` seteada, el `aud` sigue siendo `BackendAudiencie` | Contrato 3.3 (fuente única, el env var ya no influye — prueba de regresión del branch eliminado) |

### 4.2 `CookieServiceTests` — `GymWebApp.Tests/Unit/Seguridad/CookieServiceTests.cs`

Instanciación real de `CookieService` con `IHttpContextAccessor` apuntando a un `DefaultHttpContext`
(permite setear `Request.IsHttps`). La aserción lee el header `Set-Cookie` del response.

| # | Prueba | Verifica | Referencia spec 79 |
|---|--------|----------|--------------------|
| 8 | `AgregarCookie_WhenRequestIsHttps_SetsSecureFlag` | Con `Request.IsHttps = true`, el header `Set-Cookie` contiene `Secure` | Contrato 3.3 (cookie `Secure` por IsHttps efectivo) |
| 9 | `AgregarCookie_WhenRequestIsHttp_DoesNotSetSecureFlag` | Con `Request.IsHttps = false`, el header `Set-Cookie` NO contiene `Secure` | Contrato 3.3 (desarrollo HTTP local sin Secure) |

## 5. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Unit/Seguridad/JwtTokenGeneratorTests.cs` | 7 pruebas unitarias sobre generación/validación de tokens |
| `GymWebApp.Tests/Unit/Seguridad/CookieServiceTests.cs` | 2 pruebas unitarias sobre el flag `Secure` de la cookie |

## 6. Criterios de aceptación

- [ ] Las 9 pruebas compilan y pasan al ejecutar el filtro `FullyQualifiedName~Seguridad`.
- [ ] Todas las pruebas usan instanciación real de `JwtTokenGenerator` y `CookieService` (no mocks de las clases bajo prueba).
- [ ] Ninguna prueba accede a base de datos, HTTP real ni contenedores.
- [ ] `SECRET_TOKEN_KEY` se setea en el fixture con una clave de 32+ bytes.
- [ ] Las pruebas 1, 2 y 7 verifican el claim `aud` del token generado.
- [ ] Las pruebas 3-6 verifican aceptación/rechazo de audiencias http vs ssl.
- [ ] Las pruebas 8-9 verifican presencia/ausencia de `Secure` en `Set-Cookie`.
- [ ] No existen pruebas derivadas fuera de las 9 definidas en este spec.