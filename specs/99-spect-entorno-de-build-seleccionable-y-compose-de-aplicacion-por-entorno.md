# Spec: Entorno de build seleccionable y compose de aplicación por entorno - scripts Bash y archivos Compose

## 1. Resumen

Las imágenes de la aplicación se hornean con un único entorno (el declarado en el compose local), y el instalador levanta la aplicación siempre con la variante Development del Compose, sin importar el entorno de Infisical elegido. Eso produce un desajuste silencioso: una instalación con entorno prod termina con contenedores que declaran producción en runtime, pero sobre imágenes construidas para desarrollo. El problema es estructural, no cosmético: los Dockerfiles de la aplicación exigen que exista el `appsettings` del entorno horneado, eliminan de la imagen los `appsettings` de los demás entornos y fijan el `ASPNETCORE_ENVIRONMENT` en el momento del build, de modo que un runtime que pide un entorno distinto al horneado cae sin aviso al `appsettings` base.

Esta spec agrega cuatro piezas: primero, al ciclo de construcción de imágenes, una pregunta inicial de entorno (Development, Staging o Production) que viaja como argumento de build sin modificar ningún archivo en disco; segundo, una variante de producción del Compose de aplicación del instalador, con la semántica del template general pero adaptada a máquina destino (imágenes descargables del registro, sin sección de build); tercero, al instalador, la elección del Compose de aplicación según el entorno seleccionado; cuarto, al desinstalador, la derivación del mismo archivo a partir del estado guardado por el instalador.

Al terminar, el entorno queda alineado en toda la cadena: se elige al construir, se hornea en la imagen, se declara en el Compose de despliegue y se registra en el estado que gobierna la bajada.

## 2. Contexto

- **Capa:** Scripts Bash del repositorio (`build-images.sh`, `install-fitnessgym.sh`, `uninstall-fitnessgym.sh`) más archivos Compose en la raíz del repositorio.

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Selección de gestor de secretos en el instalador | `97-spect-instalador-seleccion-gestor-secretos-infisical.md` | Modo Infisical, menú de entorno, ejecución de Compose por proyecto y reporte íntegro de errores | 97 |
| Desinstalador con archivo de estado | `98-spect-desinstalador-bajada-infisical-archivo-estado.md` | Archivo de estado local con modo, entorno e IDs de proyecto; bajada por Infisical | 98 |
| Dockerfiles de API y Frontend | `API/DockerFile`, `GymFrontend/DockerFile` | Consumen el argumento de entorno, validan los tres valores, exigen el `appsettings` del entorno y eliminan los demás | — |
| Template general de la app | `docker-compose.template.yml` | Referencia semántica de producción: entorno Production, puertos 8090 y 8091, zona horaria por defecto | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `appsettings.Development.json`, `appsettings.Staging.json`, `appsettings.Production.json` | Archivos de la app | Deben existir en API y Frontend para que el build de cualquiera de los tres entornos no falle |
| Imágenes `aaron77/fitnessgymapi` y `aaron77/fitnessgymfrontend` en el registro | Infraestructura | El Compose de aplicación del instalador es de solo descarga; sin imágenes publicadas no hay despliegue |
| Archivo de estado del instalador | Configuración local | Fuente de verdad del entorno de la instalación para el desinstalador |
| CLI de Infisical | Infraestructura | Solo en modo Infisical, con el mismo comportamiento condicional de las specs 97 y 98 |

## 3. Componentes a crear y modificar

### 3.1 Archivos

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `build-images.sh` | Modificar | Pregunta de entorno al inicio de la corrida y uso de la selección como argumento de build |
| `docker-compose.app.installer.prod.yml` | Nuevo | Variante de producción del Compose de aplicación del instalador |
| `install-fitnessgym.sh` | Modificar | Elección del Compose de aplicación según el entorno seleccionado |
| `uninstall-fitnessgym.sh` | Modificar | Derivación del Compose de aplicación a partir del entorno del archivo de estado |

### 3.2 Contrato

Reglas del contrato:

1. El entorno se elige UNA sola vez por corrida de construcción, al inicio, después del menú de imágenes; los valores válidos son Development, Staging y Production; una opción inválida aborta sin construir ni pushear nada.
2. La selección viaja como argumento de build directamente al comando de construcción; el valor declarado en el Compose local queda como default de referencia y NUNCA se escribe en disco; si difiere de la selección, se informa la diferencia y gana la selección.
3. El argumento de build solo se pasa a las imágenes cuyo Compose local declare ese argumento (es la señal de que su Dockerfile lo consume); las imágenes que no lo consumen no lo reciben.
4. El Compose de aplicación de producción es de solo descarga: imágenes del registro con política de descarga siempre, sin sección de build; conserva la semántica del template general (entorno Production, puertos de host por variable con default 8090 y 8091, zona horaria por variable con default) y las mismas variables obligatorias y red externa que la variante Development.
5. En el instalador: modo Infisical con entorno prod usa la variante de producción; modo Infisical con dev o staging, y modo `.env`, usan la variante Development; la URL de descarga se deriva del archivo elegido.
6. En el desinstalador: la bajada usa la variante que corresponde según el entorno registrado en el archivo de estado (prod deriva a la variante de producción; cualquier otro caso mantiene la variante Development); si el archivo no existe, se degrada a la limpieza por nombre canónico existente sin interrumpir nada.
7. Los Compose de base de datos y de proxy no cambian: no tienen variante por entorno en esta spec.

### 3.3 Flujo de decisión y validación

| Paso | Decisión o validación | Comportamiento | Error |
|------|----------------------|----------------|-------|
| 1 | Menú de entorno al inicio de la corrida de build | Tres opciones con valores válidos; la elección aplica a todas las imágenes de la corrida | Opción inválida: aborta la corrida sin construir ni pushear |
| 2 | Compose local con argumento de entorno declarado | Se pasa el argumento de build con la selección de la corrida; si el valor del compose difiere, se informa | — |
| 3 | Compose local sin argumento de entorno declarado | No se pasa el argumento (imágenes que no lo consumen) | — |
| 4 | Instalador, elección de Compose de aplicación | Modo Infisical con entorno prod deriva a la variante de producción; resto deriva a la de desarrollo; la descarga apunta al archivo elegido | Descarga fallida: aborta con mensaje, como hoy |
| 5 | Desinstalador, derivación del Compose de aplicación | Con estado válido en modo Infisical y entorno prod, la bajada de la aplicación usa la variante de producción; resto, la de desarrollo | Archivo ausente: se salta y continúa con la limpieza por nombre canónico |

### 3.4 Acciones que debe realizar

Ciclo de construcción de imágenes:

1. Tras el menú de selección de imágenes, preguntar el entorno con las tres opciones y guardar la elección para toda la corrida.
2. Para cada imagen construida, extraer del Compose local el contexto, el Dockerfile y la declaración del argumento de entorno, como hoy.
3. Si el Compose local declara el argumento, pasarlo al build con el valor elegido al inicio, informando la diferencia si la hubiera; si no lo declara, no pasarlo.
4. El resto del ciclo (congelado, rotación de tags, push final) permanece idéntico.

Instalador:

5. Determinar el archivo de Compose de aplicación antes de las descargas, según el modo y el entorno elegido, y descargarlo de la ruta que corresponde a su nombre.

Desinstalador:

6. Después de leer el archivo de estado y antes de la bajada, derivar el archivo de Compose de aplicación según el entorno registrado y usarlo en la detención por Infisical y en la limpieza de archivos.

### 3.5 Patrones a aplicar

- **Simetría build-runtime:** el entorno horneado en la imagen y el declarado en el Compose de despliegue deben coincidir; cualquier divergencia es un defecto de configuración, no algo que la app deba absorber en silencio.
- **Script sin estado en disco:** el ciclo de construcción no muta archivos trackeados; la elección viaja por parámetro del comando de build.
- **Estado local como fuente de verdad (spec 98):** el entorno de la instalación queda registrado y de él se deriva el comportamiento de la bajada, sin re-preguntar al operador.
- **Degradación segura (specs 97 y 98):** ante archivos ausentes o estado inválido, los scripts continúan con la limpieza canónica en lugar de fallar.

## 4. Archivos a crear y modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `build-images.sh` | Modificar | Menú de entorno al inicio y argumento de build con la selección |
| `docker-compose.app.installer.prod.yml` | Nuevo | Variante de producción del Compose de aplicación del instalador |
| `install-fitnessgym.sh` | Modificar | Selección y descarga del Compose de aplicación según entorno |
| `uninstall-fitnessgym.sh` | Modificar | Derivación del Compose de aplicación desde el estado |

## 5. Criterios de aceptación

- [ ] El ciclo de construcción pregunta el entorno una sola vez, al inicio, y acepta exactamente Development, Staging y Production
- [ ] Una opción inválida en el menú de entorno aborta sin construir ni pushear
- [ ] La selección viaja como argumento de build y el Compose local no se modifica en disco
- [ ] Si el Compose local declara un entorno distinto, se informa y la selección de la corrida gana
- [ ] Las imágenes cuyo Dockerfile no consume el argumento no lo reciben
- [ ] Existe la variante de producción del Compose de aplicación: solo descarga, entorno Production, puertos y zona horaria con los defaults del template
- [ ] El instalador en modo Infisical con entorno prod descarga y usa la variante de producción; con dev o staging y en modo `.env` usa la de desarrollo
- [ ] El desinstalador usa la variante derivada del entorno del estado y, ante archivo ausente, degrada a la limpieza por nombre canónico
- [ ] Los tres scripts pasan la verificación de sintaxis de Bash

## 6. Fuera del alcance de esta spec

- Los instaladores de Windows (`install-fitnessgym.ps1`, `uninstall-fitnessgym.ps1`): fuera por la misma razón que en las specs 97 y 98.
- Un Compose de staging propio: staging reutiliza la variante de desarrollo; una variante dedicada queda para una spec futura si hiciera falta.
- Redirección HTTP a HTTPS y certificados del proxy: son decisiones del repositorio del proxy, con su propia historia.
- Cambios en los Dockerfiles de la aplicación o en sus `appsettings`: esta spec solo orquesta el entorno que ya consumen.
