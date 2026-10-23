## Configuración

- Variables de entorno para secretos — **nunca en archivos versionados ni en código**
- `appsettings.json` y sus variantes de ambiente: solo valores no sensibles; los valores sensibles quedan vacíos con una clave `_Nota` documentando el origen
- JWT settings en la clase `JwtSettings`

### Cadena de conexión a base de datos

- La cadena completa con autenticación SqlPassword viaja por la variable de entorno **`DB_CONNECTION_STRING`**, provista por Infisical (con conceptos por ambiente) y lanzada con el envoltorio `infisical run`
- Consumidores actuales: `API/Program.cs` (variable primero, luego `ConnectionStrings:DefaultConnection`, override `windowsConnection` en Windows, variable otra vez en producción/staging, fallo de arranque si queda vacía) y `GymFrontend/Program.cs` (variable primero, luego `GetConnectionString("DefaultConnection")`, fallo de arranque si queda vacía)
- El nombre `DB_CONNECTION_STRING` es el canónico: también lo esperan las plantillas de despliegue (placeholders de docker-compose)
- `API/Properties/launchSettings.json` está excluido del repositorio (archivo local de ejecución con IDE); no se versiona ni se comparte

### Convención para secretos de opciones tipadas

- Las variables de entorno siguiendo la sección y la clave de la clase de opciones unidas por **doble guion bajo** pisan el valor de esa sección automáticamente (ej: `SendGridSettings__ApiKey` alimenta `IOptions<SendGridSettings>` sin código de mapeo)
- En tests, los valores sensibles viven en el **Secret Manager de .NET** del proyecto `GymWebApp.Tests` (claves con árbol de configuración, ej: `SmtpSettings:Password`); nunca en `appsettings.Testing.json`

Referencias: `specs/93-spect-secretos-appsettings-inyeccion-infisical.md`, `specs/94-spect-secretos-testing-user-secrets.md`, `specs/95-spect-secretos-codigo-csharp-configuracion.md`.
