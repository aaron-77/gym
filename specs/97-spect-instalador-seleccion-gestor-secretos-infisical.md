# Spec: Instalador - selección de gestor de secretos con soporte inicial de Infisical - script de instalación Bash

## 1. Resumen

El instalador de FitnessGym (`install-fitnessgym.sh`) configura el despliegue exclusivamente mediante un archivo `.env` generado a partir de `.env.example`, con secretos autogenerados en el momento de la instalación. Esta spec incorpora la elección del origen de configuración al inicio de la instalación: archivo `.env` (opción por defecto) o gestor de secretos. En esta etapa el único gestor disponible es Infisical, que ya es la fuente de verdad de secretos de la aplicación según la spec 93.

Con Infisical seleccionado, el instalador autentica la sesión mediante un token de acceso universal-auth (reutilizando `INFISICAL_TOKEN` si ya existe, o generándolo a partir de client id y client secret suministrados por el operador), solicita el ID de proyecto de Infisical de cada uno de los tres proyectos (fitnessgymapp, fitnessgymbd, fitnessgymnginx), y ejecuta el despliegue de cada archivo Compose envuelto por el comando de ejecución de Infisical con el entorno elegido. Con `.env` seleccionado, el flujo existente queda intacto.

Al terminar, el operador elige dónde viven los secretos del despliegue y el instalador ejecuta la secuencia de Compose correspondiente a cada origen sin duplicar lógica.

## 2. Contexto

- **Capa:** Script de instalación (`install-fitnessgym.sh`, Bash) más configuración persistente de la sesión del operador (`.bashrc`).

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Patrón de inyección por Infisical | `93-spect-secretos-appsettings-inyeccion-infisical.md` | Establece `DB_CONNECTION_STRING` como variable canónica y `infisical run` como envoltorio de ejecución | 93 |
| Precedente de externalización | `91-nginx-envsubst-docker.md` | Archivo trackeado sin secretos resuelto al arrancar; precedente del patrón | 91 |
| Archivos Compose del instalador | `docker-compose.app.installer.dev.yml`, `bd/docker-compose.installer.dev.yml`, compose de Nginx del repositorio del proxy | Declaran las variables obligatorias que hoy provee `.env` y que en modo gestor proveerá Infisical | — |
| Plantilla de entorno | `.env.example` | Base del modo `.env`; no se modifica | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| CLI de Infisical | Infraestructura | Binario `infisical` disponible en PATH; requisito condicional solo si se elige el gestor |
| Docker Compose v2 | Infraestructura | Requisito ya verificado por el instalador |
| Credenciales universal-auth | Humana | Client id y client secret de la identidad de máquina en Infisical, suministrados por el operador si no existe token |
| `.bashrc` del operador | Configuración | Destino de la exportación persistente del token cuando deba generarse |

## 3. Instalador a modificar

### 3.1 Archivos

| Archivo | Modificación |
|---------|-------------|
| `install-fitnessgym.sh` | Incorporación del bloque de selección de origen de configuración, autenticación con Infisical, solicitud de IDs de proyecto y ejecución condicional de Compose |

### 3.2 Contrato

Nuevas variables de sesión internas del script (sin valores por defecto en archivos trackeados):

| Variable interna | Contenido | Ciclo de vida |
|------------------|-----------|---------------|
| Bandera de origen de configuración | `.env` o `infisical`, decidida por el operador al inicio | Sesión del instalador |
| Entorno de Infisical elegido | Uno de: dev, staging, prod | Sesión del instalador |
| Token de Infisical | Variable de entorno `INFISICAL_TOKEN`; existente o generada | Sesión actual; persistida al final de `.bashrc` solo si se generó |
| ID de proyecto de fitnessgymapp | Suministrado por el operador | Sesión del instalador |
| ID de proyecto de fitnessgymbd | Suministrado por el operador | Sesión del instalador |
| ID de proyecto de fitnessgymnginx | Suministrado por el operador | Sesión del instalador |

Comportamiento observable esperado:

1. La primera interacción del instalador (luego de los chequeos previos de Docker, curl y conectividad) pregunta el origen de configuración, con `.env` como opción por defecto al responder vacío.
2. Si se elige gestor de secretos, se listan los gestores disponibles y solo aparece Infisical.
3. Todo lo propio del modo Infisical ocurre solo si se lo eligió; el modo `.env` no ejecuta ningún paso de Infisical.
4. El resto del flujo (creación de red, impresión de URL final) es común a ambos modos.

### 3.3 Flujo de decisión y validación

| Paso | Decisión o validación | Comportamiento | Error |
|------|----------------------|----------------|-------|
| 1 | Origen de configuración | Pregunta con `.env` por defecto; opción explícita de gestor de secretos | — |
| 2 | Listado de gestores | Muestra solo Infisical; se selecciona por número | — |
| 3 | CLI de Infisical instalado (solo modo Infisical) | Verifica que el binario exista en PATH | Detiene la instalación indicando que no puede continuar porque el CLI no está instalado y solicitando al operador que lo instale; sin instrucciones de instalación |
| 4 | Entorno de Infisical (solo modo Infisical) | Menú de opciones múltiples: dev, staging, prod | — |
| 5 | `INFISICAL_TOKEN` definido (solo modo Infisical) | Si está definido, continúa en el paso 7 | — |
| 6 | Generación de token (solo si el paso 5 no lo encontró) | Solicita client id y client secret (el secreto sin eco en pantalla); ejecuta el login de Infisical por método universal-auth en modo no interactivo y de salida en claro, de forma que el CLI imprima únicamente el token de acceso; captura el token; lo exporta en la sesión en curso (el CLI de Infisical resuelve `infisical run` desde esa variable); actualiza `.bashrc`: si ya existe una línea de exportación del token la reemplaza, y si no existe la agrega al final del archivo | Si el login falla, detiene la instalación con el mensaje de error del CLI |
| 7 | IDs de proyecto (solo modo Infisical) | Pide el ID de Infisical uno por uno, indicando en cada prompt el proyecto al que corresponde: primero fitnessgymapp, luego fitnessgymbd, luego fitnessgymnginx | Detiene la instalación si algún ID queda vacío |
| 8 | Origen `.env` | Continúa con el flujo existente sin modificaciones: descarga de plantilla, generación de secretos, cadena de conexión, renegociación de puerto | — |
| 9 | Ejecución de Compose (modo Infisical) | Ejecuta cada proyecto por separado, en orden: base de datos, aplicación, proxy Nginx. Cada ejecución envuelve el levantamiento en modo desprendido (`up -d`) del comando de Compose de ese proyecto con el archivo Compose correspondiente, el modificador de entorno con el valor elegido en el paso 4 y el modificador de ID de proyecto con el ID recogido en el paso 7 | Detiene la instalación si alguna ejecución falla |
| 10 | Ejecución de Compose (modo `.env`) | Validación de configuración y levantamiento combinado de los tres archivos, tal como hoy | Igual que hoy |

Notas de diseño:

- En modo Infisical, la generación de secretos locales y el armado de la cadena de conexión quedan fuera del camino: no se genera ningún secreto en ningún punto del modo; los valores obligatorios que declaran los archivos Compose (entre ellos `DB_CONNECTION_STRING` y `SECRET_TOKEN_KEY`) son inyectados por el comando de ejecución de Infisical al lanzar cada Compose, que ya declara esas variables. En consecuencia, la verificación previa de las herramientas de generación de secretos aplica únicamente al modo `.env`.
- En modo Infisical, el manejo del archivo `.env` (copia de plantilla, fusión de claves, generación de secretos, renegociación de `HOST_HTTP_PORT`) no se ejecuta: la configuración pasa a ser responsabilidad del contenido de Infisical, y son los archivos Compose quienes declaran las variables y sus valores por defecto. El puerto de Nginx se lee del secreto `HOST_HTTP_PORT` del proyecto de Infisical del proxy, con salida en claro, solo para armar la URL final. Si esa variable no está definida en Infisical, la instalación NO se interrumpe: se emite un aviso aclarando que no se encontró definida y que se espera que el Compose correspondiente provea un valor por defecto. Un puerto ocupado se informa como advertencia sin reescribir configuración. En general, ninguna variable de configuración faltante en modo Infisical detiene la instalación; los únicos fallos que interrumpen son los de ejecución (login, Compose) y los datos obligatorios suministrados por el operador (credenciales e IDs de proyecto).
- La persistencia del token en `.bashrc` es idempotente: si ya existe una línea de exportación del token se reemplaza su valor, y si no existe se agrega al final del archivo; nunca se acumulan líneas duplicadas.

### 3.4 Acciones que debe realizar

1. Luego de los chequeos previos existentes, preguntar el origen de configuración: `.env` (por defecto, también al responder vacío) o gestor de secretos.
2. Si eligió gestor de secretos: listar los gestores disponibles (solo Infisical en esta etapa) y permitir elegirlo por número.
3. Solo en modo Infisical: verificar la presencia del binario `infisical` en PATH; si falta, detener indicando que no puede continuar porque el CLI no está instalado y solicitando al operador que lo instale.
4. Solo en modo Infisical: presentar el menú de entorno con las opciones dev, staging y prod, y guardar la elección.
5. Solo en modo Infisical: comprobar si `INFISICAL_TOKEN` está definida en el entorno de la sesión.
6. Solo si el token no existe: solicitar client id y client secret (sin eco para el secreto), ejecutar el login de Infisical por método universal-auth en modo no interactivo y de salida en claro, capturar el token que imprime, exportarlo para la sesión en curso y actualizar `.bashrc`: reemplazar la línea de exportación si ya existe, o agregarla al final del archivo si no.
7. Solo en modo Infisical: solicitar el ID de proyecto de Infisical de fitnessgymapp, después el de fitnessgymbd y después el de fitnessgymnginx, nombrando en cada prompt el proyecto correspondiente.
8. Continuar con las descargas de archivos Compose y `create-login.sql` tal como existen hoy.
9. Solo en modo `.env`: ejecutar el bloque existente de preparación de `.env` (copia o fusión de plantilla, generación de secretos con la mecánica actual, armado de la cadena de conexión, verificación y renegociación del puerto de Nginx).
10. Crear la red de Docker común a ambos modos, como hoy.
11. Ejecutar el despliegue según el modo: con `.env`, la secuencia combinada actual de validación y levantamiento; con Infisical, tres ejecuciones separadas en orden base de datos, aplicación y proxy, cada una envuelta por el comando de ejecución de Infisical con el entorno elegido y el ID de proyecto correspondiente, usando el archivo Compose propio de cada proyecto y en modo desprendido.
12. Mantener el cierre actual: impresión de la URL final con el puerto correspondiente y apertura del navegador cuando esté disponible.

### 3.5 Patrones a aplicar

- **Configuración externa (spec 93):** los archivos trackeados declaran forma; el origen elegido (`.env` o Infisical) provee valores al momento de ejecución.
- **Una sola fuente de verdad por modo:** ningún modo mezcla orígenes; el modo Infisical no genera ni consulta el `.env`, y el modo `.env` no invoca el CLI de Infisical.
- **Fail fast con mensajes accionables:** cada validación nueva detiene la instalación nombrando la causa y la remediación, igual que los chequeos previos existentes.
- **Reporte íntegro de errores de Infisical:** toda falla de un comando de Infisical (login, lectura de secretos, ejecución de Compose) se reporta con el mensaje del instalador, el código de salida del comando y la salida de error íntegra del CLI como detalle, en lugar de descartarla o dejarla mezclada sin jerarquía. La salida capturada en una ejecución exitosa también se muestra, de modo que no se oculta información al operador.
- **Persistencia idempotente:** la escritura en `.bashrc` verifica existencia previa para no acumular líneas duplicadas en reinstalaciones.

## 4. Archivos a crear y modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `install-fitnessgym.sh` | Modificar | Selección de origen de configuración, ramas de autenticación y ejecución condicional de Compose |
| `.bashrc` del operador | Modificar (condicional) | Agregado al final de la línea de exportación de `INFISICAL_TOKEN`, solo si se generó token y la línea no existe |

## 5. Criterios de aceptación

- [ ] Al iniciar, el instalador pregunta el origen de configuración y `.env` es la opción por defecto (incluye responder vacío)
- [ ] Al elegir gestor de secretos, se lista Infisical como único gestor disponible
- [ ] En modo `.env` el instalador se comporta exactamente como antes de esta spec y no invoca el CLI de Infisical
- [ ] En modo Infisical, la ausencia del binario `infisical` detiene la instalación indicando que no puede continuar porque no está instalado y solicitando instalarlo
- [ ] El menú de entorno solo ofrece dev, staging y prod, y la elección se usa en las ejecuciones de despliegue
- [ ] Con `INFISICAL_TOKEN` definida no se solicitan credenciales ni se modifica `.bashrc`
- [ ] Sin `INFISICAL_TOKEN`, el instalador pide client id y client secret, ejecuta el login por método universal-auth, exporta el token en la sesión y agrega la exportación al final de `.bashrc` sin duplicar líneas en reinstalaciones
- [ ] Los tres IDs de proyecto se piden uno por uno y cada prompt nombra el proyecto (fitnessgymapp, fitnessgymbd, fitnessgymnginx)
- [ ] En modo Infisical, cada proyecto se despliega con su propio archivo Compose envuelto por el comando de ejecución de Infisical con el entorno y el ID de proyecto correspondientes, en orden base de datos, aplicación y proxy
- [ ] En modo Infisical no se genera ni modifica el archivo `.env` y no se ejecuta la generación local de secretos
- [ ] En modo Infisical, si `HOST_HTTP_PORT` no está definida en Infisical, la instalación continúa con un aviso y el mensaje final indica que el puerto lo define el Compose, sin interrumpir
- [ ] En modo Infisical, ninguna variable de configuración faltante interrumpe la instalación; solo se registran avisos
- [ ] Un fallo de Compose o de Infisical en cualquier proyecto detiene la instalación con mensaje claro que incluye el código de salida y la salida de error íntegra del CLI como detalle
- [ ] La URL final se imprime cuando el puerto es conocido (ambos modos con `HOST_HTTP_PORT` resuelto)

## 6. Fuera del alcance de esta spec

- El instalador de Windows (`install-fitnessgym.ps1`): la persistencia pedida es sobre `.bashrc`, propia de shells Bash; su paridad en PowerShell queda para una spec propia.
- Soporte de gestores de secretos adicionales (Vault, AWS Secrets Manager, etc.): la arquitectura de listado queda preparada, pero no se implementa ninguno más en esta etapa.
- Modificación de los archivos Compose: declaran las mismas variables que ya consumen; nada cambia en ellos.
- Alta de los secretos dentro de Infisical y creación de las identidades universal-auth: tarea humana fuera del repositorio.
- Migración automática de un `.env` existente hacia Infisical.
