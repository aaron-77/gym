# Spec: Secrets del proyecto de tests - Secret Manager de .NET

## 1. Resumen

El archivo `appsettings.Testing.json` del proyecto de pruebas porta los secretos reales del banco de pruebas: la contraseña de la instancia SQL Server que levanta Testcontainers, la clave de firma JWT del ambiente de testing y las contraseñas de las entradas tipadas de usuarios de prueba. Además, un archivo de test de correo fabrica a mano las credenciales SMTP con una contraseña real de Gmail. Todo trackeado y publicado.

Esta spec mueve esos valores al Secret Manager de .NET para el proyecto GymWebApp.Tests: un identificador de secretos en el csproj, los valores cargados una única vez por el comando de secretos fuera del repositorio, y una nueva fuente de configuración en el cargador unificado que los consuma al construir la configuración de testing. Los consumidores no cambian: continúan leyendo por las clases tipadas y la fachada que la spec 89 dejó establecidas. El archivo de mensajes de prueba pasa a leer la configuración SMTP del servidor de pruebas en vez de los literales.

Al terminar, `appsettings.Testing.json` conserva estructura y valores no secretos, ningún archivo de test contiene credenciales literales, y el proyecto corre igual en cualquier máquina después de poblar sus secretos de usuario.

## 2. Contexto

- **Capa:** GymWebApp.Tests (configuración de pruebas + archivo de test de correo)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Cargador unificado de configuración | `Integration/Common/ConfigHelper.cs` | Estándar vigente de carga de configuración de pruebas establecido por la spec 89; recibe la nueva fuente | `89-spect-credenciales-test-configuracion-tipada.md` |
| Clase de credenciales tipada | `Integration/Common/TestUsersOptions.cs` | Contenedor vigente con la lista de entradas; archivo fuente pasa del JSON a los secretos sin cambiar la clase | `89-spect-credenciales-test-configuracion-tipada.md` |
| Fachada de tests de interfaz | `E2E/Common/E2ETestSettings.cs` | Fachada conservada por la spec 89; queda intacta, su respaldo cambia de fuente | `89-spect-credenciales-test-configuracion-tipada.md` |
| Patrón de credenciales por configuración | Precedente del frontend | Forma del contenedor tipado y su registro | `88-spect-credenciales-login-configuracion.md` |
| Regla de credenciales de pruebas | `GymWebApp.Tests/AGENTS.md` | Mandata que las credenciales salgan de la configuración de testing; se amplía con la fuente de secretos de usuario | — |
| Sección SMTP mixta de prueba | `GymWebApp.Tests/EmailManagerTests.cs` | Constructor con credenciales literales; se las quita y pasa a obtenerlas del almacén de secretos de usuario, no de la sección SmtpSettings del JSON | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Secret Manager de .NET | Framework | Almacén local por usuario y por proyecto, fuera del repositorio, con comando de consola para dar valores |
| Identificador de secretos | Csproj | Propiedad que vincula el proyecto de pruebas a su almacén local |
| Origen de configuración de secretos de usuario | Framework | Fuente que el cargador unificado agrega al árbol de configuración de testing |

## 3. Secretos a trasladar

### 3.1 Inventario

| Origen | Dato | Destino como secreto |
|--------|------|----------------------|
| `appsettings.Testing.json` | Contraseña SqlServer de la instancia de pruebas | Sección SqlServer, clave Password |
| `appsettings.Testing.json` | Clave de firma JWT de testing | Sección JwtSettings, clave SecretKey |
| `appsettings.Testing.json` | Contraseñas de las entradas de usuarios de prueba (Cliente y Empleado) | Sección TestUsers, contraseña por entrada |
| `appsettings.Testing.json` | Correos personales de las entradas de usuarios de prueba | Sección TestUsers, correo por entrada (dato personal, no secreto estricto, pero viaja por el mismo vehículo) |
| `EmailManagerTests.cs` | Contraseña SMTP de Gmail y su usuario remitente | Almacén de secretos de usuario del proyecto de tests: no usa la sección SmtpSettings del JSON de testing |

### 3.2 Estado final de los archivos

- `appsettings.Testing.json` conserva toda la estructura y los valores no secretos (servidor, puerto, durations, endpoints); las láminas de secretos quedan vacías o desaparecen según el caso, documentado en el propio archivo.
- `EmailManagerTests.cs` pierde el literal de credenciales y obtiene usuario y contraseña SMTP del almacén de secretos de usuario, a través del cargador unificado. La sección SmtpSettings del JSON de testing queda reducida a servidor y puerto: ninguna credencial vive en configuración normal de archivo.

## 4. Acciones que debe realizar

1. Agregar el identificador de secretos de usuario al csproj del proyecto de pruebas.
2. Poblar el almacén local con el comando consola del Secret Manager: una entrada por dato del inventario 3.1 (tarea por máquina de desarrollo, fuera del repositorio).
3. Agregar al cargador unificado `ConfigHelper` la fuente de secretos de usuario del proyecto de pruebas, después del JSON de testing, de modo que el valor de usuario pisa al vacío declarado en el archivo.
4. Endurecer la obtención de cada secreto: si el valor no está poblado, el cargador señala la falta y nombra la entrada a poblar, sin valores de reserva literales.
5. Actualizar `EmailManagerTests` para construir el manejador con los valores que entrega la fuente de secretos de usuario del cargador unificado: el test deja de leer cualquier credencial de la sección SmtpSettings del JSON de testing.
6. Actualizar la regla de credenciales del AGENTS del proyecto de tests: la fuente del valor es la configuración de testing respaldada por secretos de usuario.

## 5. Patrones a aplicar

- **Configuración en capas:** JSON declara forma y valores no secretos; Secret Manager aporta los valores sensibles por máquina; el árbol de configuración los une sin que los consumidores sepan la diferencia.
- **Fallar sin fallback:** faltante de secreto es condición de arranque explícita; nada de contraseñas de reserva.

## 6. Criterios de aceptación

- [ ] Búsqueda textual de la contraseña de SQL Server, de la clave JWT de testing y de las contraseñas de Gmail en el repositorio: cero resultados
- [ ] `dotnet test` completo pasa con el almacén del Secret Manager poblado en la máquina local
- [ ] Arranque de integration tests sin secretos poblados falla con mensaje que nombra la entrada faltante
- [ ] Los consumidores tipados (`TestUsersOptions`, fachada E2E) no sufren cambio de código
- [ ] Agregar un usuario de prueba nuevo sigue siendo una entrada de configuración, no código

## 7. Fuera del alcance de esta spec

- Rotación de la contraseña de Gmail ya comprometida: trámite humano.
- Secretos de appsettings de ambientes no testing: spec 93.
- Secretos con literales en capas de producción: spec 95.
