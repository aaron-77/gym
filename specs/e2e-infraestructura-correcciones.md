# Especificación de Correcciones de Infraestructura E2E

## Problemas Identificados

### Problema 1: Sin restauración de base de datos
Los tests E2E iniciaban un contenedor SQL Server vacío sin restaurar la base de datos desde el backup. Esto causaba que los tests fallaran al no encontrar las tablas y datos necesarios.

### Problema 2: Ruta de nginx.conf incorrecta
El código intentaba buscar el archivo nginx.conf en una ruta relativa calculada desde el directorio bin del proyecto, pero el archivo real está en una ubicación externa.

### Problema 3: nginx.conf usaba IPs locales en lugar de aliases de red
El archivo nginx.conf estaba configurado con `127.0.0.1:8090` y `127.0.0.1:8091`, pero en el entorno Docker los contenedores necesitan comunicarse usando sus network aliases (`api` y `frontend`).

### Problema 4: Sin health check HTTP
No se verificaba que los servicios estuvieran respondiendo HTTP después de iniciar los contenedores.

## Soluciones Aplicadas

### 1. Restauración de base de datos en E2eContainerHelper.cs
- Agregado bind mount para el directorio de backups: `/mnt/archivos/estudio/proyectos/gym/bd/respaldosbd` → `/backup`
- Agregada lógica de restore copiada de TestContainerHelper:
  - Espera a que SQL Server esté listo (`WaitForContainerReady`)
  - Restaura la BD desde el backup: `FitnessCenterDB20260331.bak`
  - Usa la misma lógica de RESTORE con MOVE para archivos .mdf y .ldf

### 2. Corrección de ruta del nginx.conf
- Cambiado de ruta relativa calculada a ruta absoluta:
  ```csharp
  var nginxConfPath = "/home/aaron/archivosl/estudio/proyectos/fitnessgymreverseproxy/nginx.conf";
  ```

### 3. Actualización del nginx.conf para Docker
- Cambiado `proxy_pass http://127.0.0.1:8090` → `proxy_pass http://api:5274`
- Cambiado `proxy_pass http://127.0.0.1:8091` → `proxy_pass http://frontend:5062`
- Esto permite que nginx se comunique con los contenedores usando los network aliases configurados en E2eContainerHelper

### 4. Health check HTTP agregado
- Agregado método `WaitForHttpReadyAsync` que:
  - Realiza requests HTTP al endpoint después de iniciar cada contenedor
  - Acepta cualquier respuesta (incluyendo 401) como indicador de que el servicio está arriba
  - Reintenta hasta 30 veces con delay de 1 segundo
  - Lanza excepción si el servicio no responde

## Verificaciones Realizadas

- ✅ Los network aliases están configurados correctamente:
  - SQL Server: `sqlserver`
  - API: `api`
  - Frontend: `frontend`
  - Nginx: `nginx`
- ✅ El proyecto compila sin errores
- ✅ Los archivos referenciados existen:
  - Backup: `/mnt/archivos/estudio/proyectos/gym/bd/respaldosbd/FitnessCenterDB20260331.bak`
  - nginx.conf: `/home/aaron/archivosl/estudio/proyectos/fitnessgymreverseproxy/nginx.conf`