# FitnessGym

FitnessGym es un sistema de administración de gimnasios que permite a los clientes visualizar su progreso mediante un dashboard, mientras que los empleados pueden administrar las citas y rutinas de ejercicios de los clientes.

Los empleados también pueden gestionar los horarios de las clases para los instructores y administrar las inscripciones de los clientes en tiempo real. El sistema permite reagendar las inscripciones a las clases y envía notificaciones por correo electrónico relacionadas con las citas de los clientes.

**Stack tecnológico:** .NET 8, SignalR, SQL, SQL Server 2022, procedimientos almacenados, Razor, JavaScript, CSS, Bootstrap 5.3, Nginx 1.28, Docker 20.10 y 29, ASP.NET Core Identity, Azure VM ,S3, EC2 y RDS y SSL.

## Instalación

En esta sección se muestran dos formas de instalar FitnessGym. La **instalación manual** (más abajo) sigue los pasos por defecto para instalar la aplicación en tu computadora local, en un entorno de desarrollo (dev). El **instalador** te da, además, la opción de hacer una instalación en producción.

**Requisitos:** Docker con Compose v2 y conexión a Internet. En Linux/macOS también Bash y `curl`; en Windows, PowerShell.

### Con instalador (recomendado)

**Linux o macOS**

```bash
curl -fL https://raw.githubusercontent.com/aaron-77/gym/main/install-fitnessgym.sh -o install-fitnessgym.sh
chmod +x install-fitnessgym.sh
./install-fitnessgym.sh
```

**Windows (PowerShell)**

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/aaron-77/gym/main/install-fitnessgym.ps1 -OutFile .\install-fitnessgym.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-fitnessgym.ps1
```

El instalador descarga los Compose y las imágenes publicadas (API, frontend, SQL Server y Nginx), genera los secretos en un `.env` local, crea la red `fitnessgym-net` y levanta el stack. Si el puerto 80 está ocupado, te permite elegir otro.

Al terminar muestra la URL, por defecto `http://localhost`. Tambien descarga y guarda en disco un archivo .env con las configuraciones por defecto, si necesitas modificar algun dato de confguracion puedes hacerlo aho. Los datos de la base se guardan en volúmenes Docker.

### Desinstalación

```bash
curl -fL https://raw.githubusercontent.com/aaron-77/gym/main/uninstall-fitnessgym.sh -o uninstall-fitnessgym.sh
chmod +x uninstall-fitnessgym.sh
./uninstall-fitnessgym.sh
```

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/aaron-77/gym/main/uninstall-fitnessgym.ps1 -OutFile .\uninstall-fitnessgym.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\uninstall-fitnessgym.ps1
```

Elimina los contenedores y volúmenes del stack, por lo que **borra permanentemente los datos de la base de datos**. Después pregunta si también quieres borrar las imágenes y los archivos descargados.

# Instalación manual con Docker Compose

> ⚠️ **Advertencia importante:** completa **absolutamente todos los pasos, del 1 al 6**, en este orden, antes de intentar probar el sistema. Si te saltas alguno o los haces en otro orden, la aplicación no funcionará correctamente:
>
> 1. Descargar los archivos.
> 2. Configurar el `.env`.
> 3. Crear la red y levantar el contenedor de la base de datos.
> 4. Restaurar la base de datos.
> 5. Crear el login de la aplicación.
> 6. Levantar los demás contenedores.
>
> El paso 7 (probar el sistema) solo debe hacerse cuando los pasos 1 al 6 estén terminados sin errores.

Elige los comandos de tu sistema: **Linux/macOS** (Bash) o **Windows** (PowerShell).

Cada paso tiene el mismo número en Linux/macOS y en Windows. Las instrucciones de cada sistema se identifican como, por ejemplo, **Paso 3 en Linux / macOS** y **Paso 3 en Windows**.

Cada paso con varios comandos tiene dos partes:
- **Comandos de instalación manual:** los pegas de una sola vez.
- **Mismos comandos anteriores pero paso a paso con explicación:** cada comando por separado.

## Requisitos

- Docker con Docker Compose
- `sqlcmd` instalado (se usa desde tu máquina, no dentro del contenedor)
  - Windows: `winget install sqlcmd`
  - macOS: `brew install sqlcmd`
  - Linux: descarga el binario desde [go-sqlcmd/releases](https://github.com/microsoft/go-sqlcmd/releases) y agrégalo al `PATH`

Comprueba que funciona con `sqlcmd -?`. En Windows, si no lo encuentra, abre una terminal nueva.

## Paso 1. Descargar los archivos

Todo se descarga en una misma carpeta, así que no la cambies entre pasos. Si copias los comandos uno por uno, hazlo en orden y en la misma terminal, porque los últimos dependen de la carpeta a la que entró el primero.

### Paso 1 en Linux / macOS

**Comandos de instalación manual**

```bash
mkdir -p "$HOME/fitnessgym-install" && cd "$HOME/fitnessgym-install"
curl -fL "https://raw.githubusercontent.com/aaron-77/gym/main/docker-compose.app.installer.dev.yml" -o docker-compose.app.installer.dev.yml
curl -fL "https://raw.githubusercontent.com/aaron-77/gym/main/bd/docker-compose.installer.dev.yml" -o docker-compose.bd.installer.dev.yml
curl -fL "https://raw.githubusercontent.com/aaron-77/gym/main/bd/create-login.sql" -o create-login.sql
curl -fL "https://raw.githubusercontent.com/aaron-77/gym/main/bd/restore.sql" -o restore.sql
curl -fL "https://raw.githubusercontent.com/aaron-77/fitnessgymreverseproxy/main/docker-compose.nginx.installer.dev.yml" -o docker-compose.nginx.installer.dev.yml
curl -fL "https://raw.githubusercontent.com/aaron-77/gym/main/.env.example" -o .env.example
cp .env.example .env
```

**Mismos comandos anteriores pero paso a paso con explicación**

Crea la carpeta de instalación y entra en ella:

```bash
mkdir -p "$HOME/fitnessgym-install" && cd "$HOME/fitnessgym-install"
```

Descarga el Compose de la aplicación:

```bash
curl -fL "https://raw.githubusercontent.com/aaron-77/gym/main/docker-compose.app.installer.dev.yml" -o docker-compose.app.installer.dev.yml
```

Descarga el Compose de la base de datos:

```bash
curl -fL "https://raw.githubusercontent.com/aaron-77/gym/main/bd/docker-compose.installer.dev.yml" -o docker-compose.bd.installer.dev.yml
```

Descarga el script que crea el login de la aplicación:

```bash
curl -fL "https://raw.githubusercontent.com/aaron-77/gym/main/bd/create-login.sql" -o create-login.sql
```

Descarga el script que restaura la base de datos:

```bash
curl -fL "https://raw.githubusercontent.com/aaron-77/gym/main/bd/restore.sql" -o restore.sql
```

Descarga el Compose de Nginx:

```bash
curl -fL "https://raw.githubusercontent.com/aaron-77/fitnessgymreverseproxy/main/docker-compose.nginx.installer.dev.yml" -o docker-compose.nginx.installer.dev.yml
```

Descarga el archivo de ejemplo de variables:

```bash
curl -fL "https://raw.githubusercontent.com/aaron-77/gym/main/.env.example" -o .env.example
```

Crea tu `.env` a partir del ejemplo:

```bash
cp .env.example .env
```

### Paso 1 en Windows

**Comandos de instalación manual**

```powershell
New-Item -ItemType Directory -Force -Path "$HOME\fitnessgym-install" | Out-Null
Set-Location "$HOME\fitnessgym-install"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/gym/main/docker-compose.app.installer.dev.yml" -OutFile "docker-compose.app.installer.dev.yml"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/gym/main/bd/docker-compose.installer.dev.yml" -OutFile "docker-compose.bd.installer.dev.yml"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/gym/main/bd/create-login.sql" -OutFile "create-login.sql"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/gym/main/bd/restore.sql" -OutFile "restore.sql"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/fitnessgymreverseproxy/main/docker-compose.nginx.installer.dev.yml" -OutFile "docker-compose.nginx.installer.dev.yml"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/gym/main/.env.example" -OutFile ".env.example"
Copy-Item .env.example .env
```

**Mismos comandos anteriores pero paso a paso con explicación**

Crea la carpeta de instalación:

```powershell
New-Item -ItemType Directory -Force -Path "$HOME\fitnessgym-install" | Out-Null
```

Entra en la carpeta:

```powershell
Set-Location "$HOME\fitnessgym-install"
```

Descarga el Compose de la aplicación:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/gym/main/docker-compose.app.installer.dev.yml" -OutFile "docker-compose.app.installer.dev.yml"
```

Descarga el Compose de la base de datos:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/gym/main/bd/docker-compose.installer.dev.yml" -OutFile "docker-compose.bd.installer.dev.yml"
```

Descarga el script que crea el login de la aplicación:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/gym/main/bd/create-login.sql" -OutFile "create-login.sql"
```

Descarga el script que restaura la base de datos:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/gym/main/bd/restore.sql" -OutFile "restore.sql"
```

Descarga el Compose de Nginx:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/fitnessgymreverseproxy/main/docker-compose.nginx.installer.dev.yml" -OutFile "docker-compose.nginx.installer.dev.yml"
```

Descarga el archivo de ejemplo de variables:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaron-77/gym/main/.env.example" -OutFile ".env.example"
```

Crea tu `.env` a partir del ejemplo:

```powershell
Copy-Item .env.example .env
```

## Paso 2. Configurar el `.env`

### Paso 2 en Linux / macOS

Abre el archivo con:

```bash
nano .env
```

### Paso 2 en Windows

Abre el archivo con:

```powershell
notepad .env
```

### Paso 2: valores a reemplazar (Linux/macOS y Windows)

Una vez abierto el `.env`, reemplaza los valores de:

- `SECRET_TOKEN_KEY`
- `MSSQL_SA_PASSWORD`
- `MSSQL_APP_LOGIN_PASSWORD`
- `DB_CONNECTION_STRING`

La contraseña dentro de `DB_CONNECTION_STRING` debe ser la misma que `MSSQL_APP_LOGIN_PASSWORD`.

> ⚠️ **Advertencia:** la variable `SECRET_TOKEN_KEY` debe tener **al menos 32 caracteres**.

## Paso 3. Crear la red y levantar el contenedor de la base de datos

Primero se levanta **solo** el contenedor de la base de datos, para poder configurarla (restaurar la base y crear el login) antes de levantar el resto. Ejecuta esto desde la carpeta `fitnessgym-install`.

### Paso 3 en Linux / macOS

**Comandos de instalación manual**

```bash
docker network inspect fitnessgym-net >/dev/null 2>&1 || docker network create fitnessgym-net

docker compose --env-file .env \
  -f docker-compose.bd.installer.dev.yml \
  up -d
```

**Mismos comandos anteriores pero paso a paso con explicación**

Crea la red `fitnessgym-net` solo si todavía no existe:

```bash
docker network inspect fitnessgym-net >/dev/null 2>&1 || docker network create fitnessgym-net
```

Levanta únicamente el contenedor de la base de datos en segundo plano:

```bash
docker compose --env-file .env \
  -f docker-compose.bd.installer.dev.yml \
  up -d
```

### Paso 3 en Windows

**Comandos de instalación manual**

```powershell
docker network inspect fitnessgym-net 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { docker network create fitnessgym-net }

docker compose --env-file .env `
  -f docker-compose.bd.installer.dev.yml `
  up -d
```

> En PowerShell 5.1, si al pegar solo se ejecuta la primera línea, presiona Enter otra vez.

**Mismos comandos anteriores pero paso a paso con explicación**

Crea la red `fitnessgym-net` solo si todavía no existe (las dos líneas van juntas: la primera comprueba y la segunda crea la red si la comprobación falló):

```powershell
docker network inspect fitnessgym-net 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { docker network create fitnessgym-net }
```

Levanta únicamente el contenedor de la base de datos en segundo plano:

```powershell
docker compose --env-file .env `
  -f docker-compose.bd.installer.dev.yml `
  up -d
```

## Paso 4. Restaurar la base de datos

Con el contenedor de la base de datos ya levantado, restaura la base ejecutando `restore.sql`. Siempre se usa la cuenta `sa`, porque el login de la aplicación no tiene permisos para restaurar.

Antes de restaurar se cargan las variables del `.env` en la terminal. Así el comando de restauración usa automáticamente los valores definidos en el `.env` (por ejemplo `MSSQL_SA_PASSWORD`), en lugar de tener que escribirlos a mano dentro del comando.

### Paso 4 en Linux / macOS

**Comandos de instalación manual**

```bash
set -a; source .env; set +a

sqlcmd -S 127.0.0.1,1433 -U sa -P "$MSSQL_SA_PASSWORD" -C -b -d master -i ./restore.sql
```

**Mismos comandos anteriores pero paso a paso con explicación**

Carga las variables del `.env` en la terminal actual, para que el comando use automáticamente sus valores (como `$MSSQL_SA_PASSWORD`) en lugar de escribirlos a mano:

```bash
set -a; source .env; set +a
```

Restaura la base ejecutando `restore.sql`:

```bash
sqlcmd -S 127.0.0.1,1433 -U sa -P "$MSSQL_SA_PASSWORD" -C -b -d master -i ./restore.sql
```

### Paso 4 en Windows

**Comandos de instalación manual**

```powershell
$envMap = @{}
Get-Content .env | ForEach-Object {
    if ($_ -match '^\s*([A-Za-z_][A-Za-z0-9_]*)=(.*)$') { $envMap[$matches[1]] = $matches[2] }
}
$saPassword  = $envMap['MSSQL_SA_PASSWORD']
$appPassword = $envMap['MSSQL_APP_LOGIN_PASSWORD']

sqlcmd -S localhost,1433 -U sa -P $saPassword -C -b -d master -i .\restore.sql
```

**Mismos comandos anteriores pero paso a paso con explicación**

PowerShell no tiene el comando `source`, así que el equivalente es leer el `.env` y guardar las contraseñas en variables, para que el comando use automáticamente sus valores en lugar de escribirlos a mano (ejecuta las 6 líneas juntas):

```powershell
$envMap = @{}
Get-Content .env | ForEach-Object {
    if ($_ -match '^\s*([A-Za-z_][A-Za-z0-9_]*)=(.*)$') { $envMap[$matches[1]] = $matches[2] }
}
$saPassword  = $envMap['MSSQL_SA_PASSWORD']
$appPassword = $envMap['MSSQL_APP_LOGIN_PASSWORD']
```

Restaura la base ejecutando `restore.sql`:

```powershell
sqlcmd -S localhost,1433 -U sa -P $saPassword -C -b -d master -i .\restore.sql
```

`restore.sql` se puede ejecutar sin riesgo: si `FitnessCenterDB` ya existe, no hace nada.

> Si `sqlcmd` no logra conectarse, espera unos segundos a que SQL Server termine de iniciar y vuelve a intentarlo.

> Si tu compose publica la base en otro puerto, cambia el puerto `1433` de los comandos `sqlcmd` por el valor de `BD_HOST_PORT`.

## Paso 5. Crear el login de la aplicación

Este paso va después del restore, porque necesita que `FitnessCenterDB` ya exista. Crea el login `fitnessgymlogin` y le da los permisos necesarios. Si el login ya existe, solo actualiza su contraseña.

### Paso 5 en Linux / macOS

**Comandos de instalación manual**

```bash
set -a; source .env; set +a

sqlcmd -S 127.0.0.1,1433 -U sa -P "$MSSQL_SA_PASSWORD" -C -b -d master \
  -v "APP_LOGIN_PASSWORD=$MSSQL_APP_LOGIN_PASSWORD" \
  -i ./create-login.sql
```

**Mismos comandos anteriores pero paso a paso con explicación**

Carga las variables del `.env` en la terminal actual para poder usar las contraseñas (sáltate este comando si sigues en la misma terminal del paso 4):

```bash
set -a; source .env; set +a
```

Crea el login y sus permisos, pasando la contraseña de la aplicación al script:

```bash
sqlcmd -S 127.0.0.1,1433 -U sa -P "$MSSQL_SA_PASSWORD" -C -b -d master \
  -v "APP_LOGIN_PASSWORD=$MSSQL_APP_LOGIN_PASSWORD" \
  -i ./create-login.sql
```

### Paso 5 en Windows

**Comandos de instalación manual**

```powershell
$envMap = @{}
Get-Content .env | ForEach-Object {
    if ($_ -match '^\s*([A-Za-z_][A-Za-z0-9_]*)=(.*)$') { $envMap[$matches[1]] = $matches[2] }
}
$saPassword  = $envMap['MSSQL_SA_PASSWORD']
$appPassword = $envMap['MSSQL_APP_LOGIN_PASSWORD']

sqlcmd -S localhost,1433 -U sa -P $saPassword -C -b -d master `
  -v "APP_LOGIN_PASSWORD=$appPassword" `
  -i .\create-login.sql
```

**Mismos comandos anteriores pero paso a paso con explicación**

Lee el `.env` y guarda las contraseñas en variables de PowerShell (ejecuta las 6 líneas juntas; sáltate este bloque si sigues en la misma terminal del paso 4):

```powershell
$envMap = @{}
Get-Content .env | ForEach-Object {
    if ($_ -match '^\s*([A-Za-z_][A-Za-z0-9_]*)=(.*)$') { $envMap[$matches[1]] = $matches[2] }
}
$saPassword  = $envMap['MSSQL_SA_PASSWORD']
$appPassword = $envMap['MSSQL_APP_LOGIN_PASSWORD']
```

Crea el login y sus permisos, pasando la contraseña de la aplicación al script:

```powershell
sqlcmd -S localhost,1433 -U sa -P $saPassword -C -b -d master `
  -v "APP_LOGIN_PASSWORD=$appPassword" `
  -i .\create-login.sql
```

Si todo salió bien, verás los cuatro pasos marcados con `[OK]` y ningún `[ERROR]`.

## Paso 6. Levantar los demás contenedores

Con la base de datos restaurada y el login creado, levanta **todos los contenedores restantes** (la aplicación y Nginx). El contenedor de la base de datos no se incluye, porque ya lo levantaste en el paso 3. **Este es el paso que realmente pone el sistema a funcionar.**

### Paso 6 en Linux / macOS

**Comandos de instalación manual**

```bash
docker compose --env-file .env \
  -f docker-compose.app.installer.dev.yml \
  up -d

docker compose --env-file .env \
  -f docker-compose.nginx.installer.dev.yml \
  up -d
```

**Mismos comandos anteriores pero paso a paso con explicación**

Levanta la aplicación (API y frontend) en segundo plano:

```bash
docker compose --env-file .env \
  -f docker-compose.app.installer.dev.yml \
  up -d
```

Levanta Nginx, que es el punto de entrada del sistema:

```bash
docker compose --env-file .env \
  -f docker-compose.nginx.installer.dev.yml \
  up -d
```

### Paso 6 en Windows

**Comandos de instalación manual**

```powershell
docker compose --env-file .env `
  -f docker-compose.app.installer.dev.yml `
  up -d

docker compose --env-file .env `
  -f docker-compose.nginx.installer.dev.yml `
  up -d
```

> En PowerShell 5.1, si al pegar solo se ejecuta la primera línea, presiona Enter otra vez.

**Mismos comandos anteriores pero paso a paso con explicación**

Levanta la aplicación (API y frontend) en segundo plano:

```powershell
docker compose --env-file .env `
  -f docker-compose.app.installer.dev.yml `
  up -d
```

Levanta Nginx, que es el punto de entrada del sistema:

```powershell
docker compose --env-file .env `
  -f docker-compose.nginx.installer.dev.yml `
  up -d
```

## Paso 7. Probar el sistema

> ⚠️ Antes de continuar, confirma que completaste los **pasos 1 al 6** sin errores.

Después de seguir estos pasos, FitnessGym queda instalado de forma manual y listo para usarse.

1. Abre tu navegador y entra a **http://localhost**. Deberías ver la página principal de FitnessGym.
2. Haz clic en la opción **Login** del menú.
3. Cuando se abra la página de inicio de sesión, elige el botón **Empleado** o **Cliente**, según la parte del sistema que quieras ver.
4. Una vez dentro, explora las funcionalidades del sistema.

## Detener el sistema

Los datos viven en los volúmenes `fitnessgym-mssql-data` y `fitnessgym-mssql-log`.

### Detener los contenedores

`docker compose stop` detiene los contenedores sin eliminarlos, así que se conservan tanto los contenedores como los datos. Para volver a iniciarlos, ejecuta de nuevo los comandos del paso 6.

**Linux / macOS**

```bash
docker compose --env-file .env \
  -f docker-compose.bd.installer.dev.yml \
  -f docker-compose.app.installer.dev.yml \
  -f docker-compose.nginx.installer.dev.yml \
  stop
```

**Windows**

```powershell
docker compose --env-file .env `
  -f docker-compose.bd.installer.dev.yml `
  -f docker-compose.app.installer.dev.yml `
  -f docker-compose.nginx.installer.dev.yml `
  stop
```

### Desinstalación manual

Para desinstalar FitnessGym por completo hay que hacer dos cosas, en este orden:

1. **Eliminar todos los contenedores junto con sus datos y volúmenes**, ejecutando el `docker compose down --volumes` que aparece abajo. Ejecútalo desde la carpeta `fitnessgym-install` y **antes** de borrar los archivos, porque necesita los Compose y el `.env`. Esto **no se puede deshacer**: borra permanentemente los datos de la base de datos.
2. **Borrar manualmente todos los archivos descargados** durante la instalación manual (lista más abajo).

`docker compose down` elimina los contenedores y, con la opción `--volumes`, también los volúmenes con los datos de la base.

**Linux / macOS**

```bash
docker compose --env-file .env \
  -f docker-compose.bd.installer.dev.yml \
  -f docker-compose.app.installer.dev.yml \
  -f docker-compose.nginx.installer.dev.yml \
  down --volumes
```

**Windows**

```powershell
docker compose --env-file .env `
  -f docker-compose.bd.installer.dev.yml `
  -f docker-compose.app.installer.dev.yml `
  -f docker-compose.nginx.installer.dev.yml `
  down --volumes
```

Después, elimina manualmente cada uno de estos archivos de la carpeta `fitnessgym-install` (`$HOME/fitnessgym-install` en Linux/macOS y `$HOME\fitnessgym-install` en Windows):

- `docker-compose.app.installer.dev.yml`
- `docker-compose.bd.installer.dev.yml`
- `docker-compose.nginx.installer.dev.yml`
- `create-login.sql`
- `restore.sql`
- `.env.example`
- `.env` (contiene tus contraseñas y secretos)

Cuando los hayas borrado, la carpeta `fitnessgym-install` queda vacía y también puedes eliminarla.

## Arquitectura

FitnessGym utiliza una **arquitectura por capas**, lo que permite separar responsabilidades y facilita el mantenimiento, las pruebas y la evolución del sistema.

Toda la aplicación se ejecuta en **contenedores**: el API, el frontend, el reverse proxy con Nginx y la base de datos SQL Server. Los servicios se comunican entre sí a través de una **red Docker interna**, y Nginx actúa como **único punto de entrada expuesto al exterior**. La API, el frontend y la base de datos no son accesibles públicamente. La información de la base de datos se **persiste en volúmenes Docker**.

![Diagrama de despliegue](docsgit/diagrama%20de%20despluiegue.png)

### Despliegue en contenedores

Cada componente corre como un contenedor independiente orquestado con Docker Compose:

* **Nginx:** recibe todo el tráfico externo (HTTPS, WebSockets para SignalR) y redirige a frontend o API según la ruta.
* **Frontend:** contenedor ASP.NET Core MVC.
* **API:** contenedor ASP.NET Core Web API con SignalR y Quartz.
* **Base de datos:** contenedor SQL Server 2022 con imagen propia.

El diagrama refleja este flujo: navegador → Nginx → (Frontend / API) → SQL Server, todo dentro de la red Docker, excepto la comunicación en tiempo real por SignalR, la cual se hace del cliente a Nginx y de Nginx al API directamente.

Los datos sensibles no viven en archivos versionados. Los instaladores generan secretos y los guardan en el `.env` local del directorio de instalación, tambien puedes usar un gestor de secretos si asi lo prefieres. En ambos casos, los contenedores los reciben por variables de entorno.

### Nginx

El reverse proxy se ejecuta a partir de una **imagen personalizada** de Nginx. La configuración se define por medio de **templates** al arrancar el contenedor mediante **inyección de variables de entorno**, lo que facilita modificar los datos necesarios del reverse proxy sin tener que construir una nueva imagen, incluyendo el sportorte opciona para ssl.

Las variables que se inyectan son:

   * **`GYM_PRIMARY_DOMAIN`:** dominio principal del despliegue.
   * **`GYM_APP_DOMAIN`:** dominio de la aplicación.
   * **`GYM_API_UPSTREAM`:** dirección del backend de la API.
   * **`GYM_FRONTEND_UPSTREAM`:** dirección del frontend.
   * **`GYM_SSL_DHPARAM`:** ruta del archivo de parámetros Diffie-Hellman para TLS.
   * **`GYM_CLIENT_MAX_BODY_SIZE`:** tamaño máximo del cuerpo de las peticiones.
   * **`GYM_SSL_CERT`:**(opcional, solo aplica cuando usas ssl) ruta, dentro del contenedor, del certificado `fullchain.pem`. La lee el entrypoint; si el archivo no existe, NGINX arranca solo con HTTP. Debe empezar con el valor de `GYM_SSL_CERTS_CONTAINER_PATH`.
   * **`GYM_SSL_KEY`:** (opcional, solo aplica cuando usas ssl) ruta, dentro del contenedor, de la clave privada `privkey.pem`. Se usa junto con `GYM_SSL_CERT` y también debe empezar con el valor de `GYM_SSL_CERTS_CONTAINER_PATH`.
   * **`GYM_SSL_DHPARAM`:** (opcional, solo aplica cuando usas ssl) ruta, dentro del contenedor, del archivo de parámetros Diffie-Hellman (`dhparam.pem`) para TLS.
   * **`GYM_SSL_CERTS_HOST_PATH`:** (opcional, solo aplica cuando usas ssl) ruta en el host del directorio de certificados (por defecto `/etc/letsencrypt`). Se monta como volumen de solo lectura en el Compose de producción.
   * **`GYM_SSL_CERTS_CONTAINER_PATH`:** (opcional, solo aplica cuando usas ssl) ruta, dentro del contenedor, donde se monta el directorio de certificados del host. Es el valor común de `GYM_SSL_CERT` y `GYM_SSL_KEY`: aunque se usa en partes distintas del proceso (el montaje del volumen y el entrypoint), si la cambias debes actualizar también esas dos variables.
   * **`GYM_SSL_DHPARAM_HOST_PATH`:** (opcional, solo aplica cuando usas ssl) ruta en el host del archivo `dhparam.pem`, que se monta en la ruta interna definida por `GYM_SSL_DHPARAM`.

### Frontend

Es la **capa de presentación** del sistema. Está construida con **ASP.NET Core MVC**, **Razor**, **JavaScript**, **CSS** y **Bootstrap 5.3**.

Se encarga de mostrar la UI al usuario. Las peticiones del navegador llegan primero a Nginx y después al frontend. Cuando el frontend necesita información de la API, realiza la petición desde el servidor mediante la capa BL. De esta forma, el navegador no necesita comunicarse directamente con la API. El frontend recibe la respuesta de la API, prepara la información necesaria para la vista y finalmente devuelve la respuesta al navegador a través de Nginx, esto se hace para evitar la exposición de los tokens en JavaScript por medio del uso de cookies seguras http only; de esta manera se disminuye el riesgo de robo de tokens, dado que las cookies http only solo son enviadas y leídas por el servidor.

### BL (Business Logic)

La capa BL contiene los elementos propios de la capa de negocio, así como un cliente HTTP y clases relacionadas para gestionar la comunicación del frontend con la API de forma reutilizable.

Esta capa incluye:

* Lógica organizada por dominio.
* Un cliente HTTP centralizado para realizar las llamadas a la API.
* Generación de respuestas con un formato uniforme.
* Validaciones personalizadas.
* Manejo centralizado de errores.


### API

La API es el **punto de entrada del backend** y está construida con **ASP.NET Core Web API**.

Su responsabilidad es recibir las peticiones del frontend, ejecutar las operaciones correspondientes y devolver las respuestas con los datos solicitados en los casos que aplique.

La API contiene:

* **Controladores:** exponen los endpoints REST organizados por dominio.
* **Servicios:** contienen operaciones reutilizables que encapsulan la lógica de procesos de registro, consulta, eliminación, etc., junto con sus respectivas llamadas a validaciones de negocio (estas últimas separadas en sus clases respectivas), para que de esta forma los controladores tengan una separación clara de responsabilidades, encargándose solo de lo correspondiente a la gestión de peticiones HTTP y conservándose más limpios.
* **SignalR Hubs:** permiten actualizar información en tiempo real, como horarios y reservas.
* **Trabajos en segundo plano:** utiliza Quartz para ejecutar tareas como los recordatorios de citas.
* **Configuración de infraestructura:** incluye servicios que encapsulan la lógica de autenticación mediante JWT y la lógica de actualización de datos en tiempo real.

### DataAccess

DataAccess es la capa responsable de **acceder y guardar información en la base de datos**.

Utiliza **Entity Framework Core** e incluye:

* El contexto de la base de datos.
* Las entidades utilizadas por el sistema.
* Los repositorios.
* La integración con **ASP.NET Core Identity** para la gestión de usuarios.
* Las migraciones de la base de datos.
Es la única capa de la aplicación que se comunica directamente con SQL Server.

### DTO

Contiene los objetos utilizados para transportar información entre las diferentes partes del sistema.

Incluye:

* DTOs del sistema.
* Una clase con formato genérico para las respuestas.
* Enumeraciones.
* Atributos de validación personalizados.
* Convertidores y serializadores JSON.

Esta separación permite que las diferentes capas compartan los mismos modelos de comunicación sin depender directamente de las entidades utilizadas para la persistencia de datos ni redefinir entidades en distintas capas del sistema.

### Base de datos

El sistema utiliza **SQL Server 2022** como base de datos.

Su objetivo es compartir el esquema de la base de datos, los procedimientos almacenados y las funciones que conforman el sistema, así como el contenido de la base de datos para que pueda verse cómo están construidas las funcionalidades que están hechas en SQL y T-SQL; además incluye la construcción de la imagen de la base de datos con Docker y los scripts utilizados para su construcción. También sirve como respaldo de la base de datos y apoyo para migraciones posteriores a otros motores. No contiene proyectos .csproj ejecutables.

La base de datos se ejecuta en un **contenedor**. Su script de inicio espera a que SQL Server esté disponible, restaura `FitnessGymDB.bak` cuando corresponde y configura el login de la aplicación. Los datos se conservan en volúmenes Docker; el estado de esos volúmenes determina si la base se restaura de nuevo.

Algunos ejemplos de la funcionalidad implementada en la base de datos son **procedimientos almacenados** y **funciones**, para la búsqueda y el cálculo de horarios disponibles, y el registro de clases programadas e inscripciones.

### Testing (GymWebApp.Tests)

El proyecto **GymWebApp.Tests** concentra todas las pruebas del sistema y se ejecuta con **xUnit**. Las pruebas están organizadas en tres tipos de acuerdo al alcance que cubren:

* **Unitarias:** prueban métodos individuales sin levantar infraestructura.
* **De integración:** pruebas de integración de las funcionalidades del sistema usando **WebApplicationFactory** para levantar la API y un contenedor de prueba para la base de datos.
* **E2E:** verifican los flujos críticos de usuario a través de toda la pila (browser → Nginx → API → BD → Frontend) con **Playwright**; se utiliza **Testcontainers** para levantar la aplicación y toda la infraestructura necesaria.

**Stack de testing:** WebApplicationFactory, FluentAssertions, Respawn, NSubstitute, Bogus, Playwright .NET, TSQL y Testcontainers.

Los patrones que implementa el proyecto son:

* **AAA (Arrange, Act, Assert):** las pruebas se estructuran en tres fases siguiendo el patrón AAA: preparación del estado y de los objetos de prueba (Arrange), ejecución de la acción a probar (Act), y verificación de los resultados (Assert).
* **Page Model:** cada página o componente de la interfaz se encapsula en una clase que conoce sus selectores y realiza acciones sobre ella. Las pruebas solo declaran el flujo del usuario y las aserciones, sin manipular el HTML. Los beneficios son reducir la duplicación de acciones compartidas, simplificar el mantenimiento ante cambios en la interfaz, y mantener una separación clara entre la abstracción de la interfaz y la lógica de la prueba.
* **Test Base Class y Shared Fixture:** tanto las pruebas de integración como las E2E heredan de una clase base que se encarga de la inicialización y el ciclo de vida comunes, como levantar contenedores, reiniciar la base de datos y entregar clientes o servicios listos para usar. La instancia compartida entre las pruebas de una misma clase se maneja por medio de un fixture compartido. Cada clase de prueba concreta define únicamente su escenario y sus aserciones, garantizando la misma inicialización en todas las pruebas y evitando la duplicación de lógica.
