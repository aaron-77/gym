# Spec: Secretos con literales en código C# - movimiento a configuración inyectada por Infisical

## 1. Resumen

Tres grupos de credenciales viven escritas a mano adentro del código de producción: la clave de la API de SendGrid en el manejador de correo de la capa BL, la tríada de credenciales de Twilio fabricada inline en un controlador, y la contraseña SMTP de Gmail repetida en las llamadas al manejador de MailKit desde otros dos controladores. Todo trackeado y publicado en GitHub.

Esta spec mueve cada credencial a su sección de configuración correspondiente en la capa que le toca por las reglas de arquitectura, con clases de opciones tipadas validadas. Los manejadores y servicios pasan a recibir su configuración por constructor vía inyección de dependencias, y los controladores dejan de fabricar los manejadores en el cuerpo de las acciones. Los valores llegan por variables de entorno provistas por Infisical, con el mismo flujo de ejecución y el vehículo de inyección definidos por la spec 93.

Al terminar, el código de producción no porta ninguna credencial literal, las tres integraciones se configuran en un único lugar por ambiente, y un valor faltante detiene el arranque con diagnóstico claro en lugar de fallar en el camino del negocio.

## 2. Contexto

- **Capa:** BL (manejadores de correo y settings de SendGrid y SMTP), API Services (settings de Twilio), API Controllers (consumidores)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Vehículo de inyección | Flujo envoltorio Infisical con variable por proceso | Definido por la spec 93; esta spec reutiliza el mismo punto de provisión | `93-spect-secretos-appsettings-inyeccion-infisical.md` |
| Sección SmtpSettings existente | `appsettings.*.json` de la API | Ya declarada con valores de reserva ficticios para servidor, puerto, usuario y contraseña; esta spec la toma como asiento de la configuración SMTP real | — |
| Patrón de opciones tipadas | Framework | Vínculo de secciones de configuración a clases con validación | — |
| Registro de dependencias | `API/Program.cs`, BL | Extensión de registro por paquete funcional, según la convención de DI del repo | — |
| Precedente de inyección de manejadores | Manejadores de correo vigentes | La clase de email del BL ya se consume desde handlers; la diferencia es de quién viene su configuración | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Variables de entorno por Infisical | Infraestructura | Provisión de los seis valores nuevos en los tres conceptos de entorno |
| Clases de opciones tipadas | Framework | Lectura, vinculación y validación de secciones con falla de arranque por valor faltante |
| Contenedor de dependencias | Framework | Registro de las clases de opciones y de los manejadores que las consumen por constructor |

## 3. Componentes a modificar

### 3.1 Archivos

| Archivo | Cambio |
|---------|--------|
| `BL/EmailManager.cs` | Pierde la clave de SendGrid literal; recibe su configuración por constructor; además su dirección emisora se corrige: pasa de la cuenta institucional en desuso a `aaronhl1313@gmail.com` |
| `API/Controllers/UsersController.cs` | Pierde la tríada de Twilio fabricada inline; la delega a la pieza de mensajería que la recibe configurada |
| `API/Controllers/CitasController.cs` | Pierde la contraseña SMTP literal en la construcción del manejador de MailKit |
| `API/Controllers/ClasesController.cs` | Ídem |
| `API/Program.cs` | Registra las clases de opciones tipadas y valida su presencia al arrancar |
| `extraContext/code-style/configuration.md` | Documenta las seis variables nuevas y su sección por clase |

### 3.2 Inventario de variables

Los nombres siguen la convención estándar de variables de entorno de ASP.NET (sección y clave unidas por doble guion bajo): así el enlace de la variable de entorno sobre la sección de configuración es automático y no requiere código de mapeo.

| Variable | Alimenta | Sección de configuración |
|----------|----------|--------------------------|
| `SendGridSettings__ApiKey` | Manejador de correo SendGrid del BL | Clase de opciones con clave única de API |
| `SmtpSettings__Username` | Manejador de correo MailKit usado por citas y clases | Sección SmtpSettings vigente (valor real deja de ser ficticio) |
| `SmtpSettings__Password` | Ídem | Sección SmtpSettings vigente |
| `TwilioSettings__AccountSid` | Pieza de mensajería de verificación de usuarios | Clase de opciones de Twilio, campo de cuenta |
| `TwilioSettings__AuthToken` | Ídem | Clase de opciones de Twilio, campo de token |
| `TwilioSettings__ServiceSid` | Ídem | Clase de opciones de Twilio, campo de servicio de verificación |

### 3.3 Planos por credencial - dónde se guarda, por dónde viaja, por dónde se lee

Especificación explícita de cada plano. El almacén de **dotnet user-secrets queda exclusivo del proyecto de tests (spec 94)**: en este spec, para producción y staging el único origen de los valores es Infisical, inyectado como variables de entorno al lanzar el proceso, incluso para desarrollo local (entorno Devel del proyecto Infisical).

| Credencial | Guardado | Viaja al proceso | Se lee en el código | Estado del appsettings |
|------------|----------|------------------|---------------------|------------------------|
| API key de SendGrid | Infisical (3 conceptos de entorno) | Variable de entorno `SendGridSettings__ApiKey` | `IOptions<SendGridSettings>` | Sección nueva `SendGridSettings` declarada con clave vacía |
| SMTP: usuario y contraseña | Infisical (3 conceptos de entorno) | Variables `SmtpSettings__Username` y `SmtpSettings__Password` | `IOptions<SmtpSettings>` | Sección existente: `Server` y `Port` con valores reales (no son secretos), `Username` y `Password` vacíos |
| Twilio: cuenta, token y servicio | Infisical (3 conceptos de entorno) | Variables `TwilioSettings__AccountSid`, `TwilioSettings__AuthToken`, `TwilioSettings__ServiceSid` | `IOptions<TwilioSettings>` | Sin sección en ningún appsettings: las tres variables son solo de entorno |

El código consumidor es agnóstico del almacén: quien decide el origen es el proceso que lanza la aplicación y las fuentes de configuración que ensambla (variables de entorno inyectadas por Infisical en este spec; árbol con JSON y secretos de usuario en la spec 94).

### 3.4 Contrato

Cada clase de opciones tipada nace con los tres compromisos siguientes:

| Compromiso | Descripción |
|-----------|-------------|
| Sin valores de reserva | Ninguna clase porta literal por defecto; la ausencia del valor detiene el arranque con mensaje que nombra la variable faltante |
| Validación de forma | La clase valida su forma (por ejemplo, prefijos esperados de SID y de clave de API) al vincular la configuración, siguiendo la regla de validaciones sin consulta a la base |
| Constructor por inyección | El manejador o servicio que usa la credencial la recibe por constructor; ningún controlador fabrica credenciales en el cuerpo de una acción |

## 4. Acciones que debe realizar

1. Crear las clases de opciones tipadas en la capa correspondiente: opciones de SendGrid y de SMTP en BL, opciones de Twilio en API Services, con su validación de forma.
2. Convertir `EmailManager` y el manejador MailKit para recibir sus opciones por constructor, manteniendo intactos sus métodos públicos.
3. Actualizar la dirección emisora del correo SendGrid en `EmailManager` de la cuenta institucional a `aaronhl1313@gmail.com` (identificador público, corrección de dato, no de secreto).
4. Extraer la pieza inline de Twilio del controlador de usuarios hacia la pieza de mensajería de verificación que ya posee ese dominio, consumiendo las opciones de Twilio por constructor.
5. Actualizar los dos controladores que fabrican el manejador MailKit con credenciales para recibirlo por inyección.
6. Registrar en el arranque de la API las opciones tipadas con validación de presencia y forma.
7. Ajustar los appsettings a la forma declarada en 3.3: sección SendGridSettings nueva con clave vacía, SmtpSettings vaciando solo Username y Password, Twilio sin sección.
8. Documentar las seis variables en la referencia de configuración con la sección que alimenta cada una.

## 5. Patrones a aplicar

- **Credenciales viven en configuración:** los secretos parten del nodo opciones correspondiente; nunca pasan firmes por parámetros dentro del código de la lógica.
- **Tres planos separados:** guardado (Infisical), viaje (variables de entorno inyectadas al lanzar) y lectura (opciones tipadas) son planos distintos; el código no conoce el almacén.
- **Validación temprana:** el arranque valida forma y presencia de todas las credenciales; las piezas de la integración no descubren su ausencia recién en el camino del negocio.
- **Consumo por inyección:** ningún controlador construye integradores de terceros con valores locales.

## 6. Criterios de aceptación

- [ ] Búsqueda textual de la clave de SendGrid, del SID de Twilio, del token de Twilio y de la contraseña de Gmail en el repo: cero resultados en archivos de producción
- [ ] La dirección emisora de SendGrid quedó en `aaronhl1313@gmail.com` y ningún correo sale de la cuenta institucional antigua
- [ ] Los appsettings reflejan la forma del plano 3.3: SendGridSettings con clave vacía, SmtpSettings solo con Server y Port, Twilio ausente
- [ ] La API arranca con las seis variables pobladas y falla con diagnóstico claro si falta cualquiera
- [ ] Los caminos de negocio vigentes - verificación por SMS, envíos de SendGrid, correos de citas y clases - operan igual que antes en estado observable
- [ ] Ningún controlador realiza construcciones de manejadores de correo o de mensajería con credenciales inline
- [ ] Secciones y variables quedan documentadas en la referencia de configuración

## 7. Fuera del alcance de esta spec

- Tests con credenciales (`EmailManagerTests`): pertenece a la spec 94.
- Rotación de las claves ya comprometidas: trámite humano obligatorio.
- Fallback de clave JWT del arranque: decisión de diseño aparte.
