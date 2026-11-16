# Spec: Desinstalador - bajada del stack con Infisical y archivo de estado del instalador - scripts Bash

## 1. Resumen

El instalador de FitnessGym puede levantar el stack de dos formas: con archivo `.env` o con Infisical. El desinstalador, en cambio, solo sabe bajar el stack con un `down` combinado que interpola los archivos Compose con variables de entorno locales. Eso tiene un defecto: los archivos Compose declaran variables obligatorias (con la sintaxis que exige valor), de modo que si el stack se levantó con Infisical, el `down` del desinstalador falla en la interpolación antes de detener un solo contenedor, y la limpieza queda librada a la limpieza por nombre canónico.

Esta spec agrega al instalador la escritura de un archivo de estado local (no trackeado) que registra el modo de instalación, el entorno de Infisical elegido y los IDs de proyecto, y le enseña al desinstalador a leerlo: si el stack se levantó con Infisical, se baja con la misma mecánica (token de acceso, entorno y IDs de proyecto), ejecutando por proyecto el levantamiento inverso: un `down` completo que detiene y elimina contenedores, volúmenes y orfanatos. Si no hay archivo de estado (instalación clásica con `.env` o instalada antes de este cambio), el desinstalador sigue haciendo exactamente lo que hace hoy.

Al terminar, desinstalar elimina absolutamente todo el stack con la misma herramienta que lo levantó, sin que el operador tenga que memorizar ni reingresar datos de la instalación.

## 2. Contexto

- **Capa:** Scripts de instalación y desinstalación (`install-fitnessgym.sh`, `uninstall-fitnessgym.sh`, Bash) más un archivo de estado local por máquina.

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Selección de gestor de secretos en el instalador | `97-spect-instalador-seleccion-gestor-secretos-infisical.md` | Establece el modo Infisical, la autenticación universal-auth con token exportado, el patrón de reporte íntegro de errores y la ejecución de Compose por proyecto | 97 |
| Archivos Compose del instalador | `docker-compose.app.installer.dev.yml`, `bd/docker-compose.installer.dev.yml`, compose de Nginx del repositorio del proxy | Declaran variables obligatorias que exigen interpolación con valores en el `down` | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| CLI de Infisical | Infraestructura | Requisito condicional: solo si hay archivo de estado en modo Infisical; si falta, la limpieza continúa por nombre canónico |
| Credenciales universal-auth | Humana | Client id y client secret, solo si no existe token en la sesión |
| Archivo de estado del instalador | Configuración local | Fuente de verdad del modo, entorno e IDs de proyecto; vive en el directorio de instalación, no se trackea |

## 3. Componentes a modificar

### 3.1 Archivos

| Archivo | Modificación |
|---------|-------------|
| `install-fitnessgym.sh` | Escritura del archivo de estado en modo Infisical y remoción de un estado obsoleto en modo `.env` |
| `uninstall-fitnessgym.sh` | Lectura del archivo de estado, bajada condicional por proyecto con Infisical, pregunta opcional de borrado del token del `.bashrc` y limpieza del archivo de estado |

### 3.2 Contrato

Archivo de estado (ruta fija dentro del directorio de instalación, nombre con punto inicial):

| Contenido | Origen |
|-----------|--------|
| Modo de instalación | Decisión del operador al instalar |
| Entorno de Infisical elegido | Menú dev, staging o prod al instalar |
| ID de proyecto de Infisical de fitnessgymapp, fitnessgymbd y fitnessgymnginx | Suministrados por el operador al instalar |

Reglas del contrato:

1. El archivo de estado se escribe únicamente en modo Infisical; en modo `.env` no se escribe y se elimina cualquier estado previo que pueda quedar obsoleto de una instalación anterior.
2. El desinstalador hace SIEMPRE las mismas preguntas que hace hoy: confirmación inicial de desinstalación, eliminación de imágenes, eliminación de archivos y, como nueva pregunta final, eliminación de la línea de exportación del token en `.bashrc` (por defecto No).
3. La bajada con Infisical solo sustituye el paso de detención cuando el archivo de estado existe, es legible y declara modo Infisical con entorno válido y los tres IDs de proyecto no vacíos; en cualquier otro caso se usa el flujo de `down` combinado existente.
4. El orden de bajada es el inverso al de subida: primero el proxy Nginx, luego la aplicación, luego la base de datos.
5. Un fallo en la bajada con Infisical no aborta la desinstalación: se reporta con mensaje, código de salida y salida de error íntegra del CLI, y se continúa con la limpieza por nombre canónico, que es la red de seguridad final.
6. Si el CLI de Infisical no está instalado y hay estado en modo Infisical, se informa y se continúa directamente con la limpieza por nombre canónico.

### 3.3 Flujo de decisión y validación

| Paso | Decisión o validación | Comportamiento | Error |
|------|----------------------|----------------|-------|
| 1 | Preguntas existentes del desinstalador | Confirmación inicial, imágenes y archivos se preguntan igual que hoy, sin cambios | — |
| 2 | Lectura del archivo de estado | Si existe, es legible y declara modo Infisical con entorno válido y tres IDs de proyecto, se usa la bajada por Infisical; si no, se usa el `down` combinado existente | — |
| 3 | CLI de Infisical instalado (solo bajada por Infisical) | Verifica el binario en PATH | No detiene: informa y continúa con la limpieza por nombre canónico |
| 4 | `INFISICAL_TOKEN` (solo bajada por Infisical) | Si está definida en la sesión se usa; si no, se pide client id y client secret (sin eco para el secreto) y se genera con el login por método universal-auth en modo no interactivo y de salida en claro; el token se exporta solo para la sesión del desinstalador, sin escribir en `.bashrc` | Si el login falla, se reporta con el detalle íntegro del CLI y se continúa con la limpieza por nombre canónico |
| 5 | Bajada por proyecto | Orden proxy Nginx, aplicación, base de datos; cada ejecución envuelve el `down` con eliminación de volúmenes y huérfanos, con el entorno y el ID de proyecto del archivo de estado, y salta los archivos que no existan | Fallo de un proyecto: reporte completo y continúa con los siguientes y con la limpieza canónica |
| 6 | Borrado del token del `.bashrc` | Pregunta final con No por defecto; si se acepta, elimina las líneas de exportación del token y confirma | Sin línea encontrada: solo informa |
| 7 | Limpieza de archivos | La lista de archivos a eliminar incluye el archivo de estado | — |

### 3.4 Acciones que debe realizar

Instalador:

1. En modo Infisical, tras crear el directorio de instalación y contar con entorno e IDs de proyecto, escribir el archivo de estado con modo, entorno y los tres IDs de proyecto.
2. En modo `.env`, eliminar un archivo de estado previo si existiera, para que nunca quede apuntando a una instalación que ya no existe.

Desinstalador:

3. Mantener intactas las preguntas y pasos actuales: confirmación inicial, detención combinada con `.env`, limpieza por nombre canónico de contenedores y volúmenes, red, verificación final, imágenes y archivos.
4. Antes de la detención, leer el archivo de estado: si declara modo Infisical válido, verificar el CLI, obtener el token si hace falta (login universal-auth, sin persistirlo en `.bashrc`) y bajar cada proyecto en orden inverso al de subida con la mecánica de Infisical y reporte íntegro de errores; los fallos no detienen la desinstalación.
5. Agregar como pregunta final (No por defecto) la eliminación de las líneas de exportación de `INFISICAL_TOKEN` del `.bashrc`.
6. Incluir el archivo de estado en la lista de archivos que el desinstalador elimina al aceptar la limpieza de archivos.

### 3.5 Patrones a aplicar

- **Simetría de ciclo de vida:** quien levanta con Infisical baja con Infisical; quien levanta con `.env` baja como siempre.
- **Estado local como fuente de verdad:** el operador no memoriza nada; el archivo de estado (no trackeado) viaja junto a la instalación y se destruye con ella.
- **Limpieza canónica como red de seguridad:** la limpieza por nombre que ya existía corre siempre y es el último recurso, por lo que un fallo de Infisical nunca deja una desinstalación a medias.
- **Reporte íntegro de errores (spec 97):** los fallos de comandos de Infisical muestran mensaje, código de salida y salida de error completa del CLI.

## 4. Archivos a crear y modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `install-fitnessgym.sh` | Modificar | Escritura/remoción del archivo de estado según el modo |
| `uninstall-fitnessgym.sh` | Modificar | Bajada condicional por Infisical, pregunta de borrado de token, limpieza del estado |
| Directorio de instalación del operador | Nuevo (condicional) | Archivo de estado local, no trackeado, con modo, entorno e IDs de proyecto |

## 5. Criterios de aceptación

- [ ] En modo Infisical, el instalador escribe el archivo de estado con modo, entorno y los tres IDs de proyecto
- [ ] En modo `.env`, el instalador no escribe estado y elimina cualquier estado previo obsoleto
- [ ] El desinstalador hace exactamente las mismas preguntas que antes, más la nueva pregunta final sobre el token del `.bashrc` (No por defecto)
- [ ] Con estado en modo Infisical, la bajada usa `infisical run` por proyecto con el entorno y los IDs del archivo de estado, en orden proxy, aplicación y base de datos, con `down` que elimina contenedores, volúmenes y huérfanos
- [ ] El token del desinstalador se genera para la sesión y no se escribe en `.bashrc` durante la desinstalación
- [ ] Un fallo de Infisical durante la bajada se reporta con código de salida y detalle íntegro, y la limpieza por nombre canónico continúa
- [ ] Sin CLI de Infisical o con estado ausente o inválido, la desinstalación sigue funcionando como hoy
- [ ] La limpieza de archivos incluye el archivo de estado
- [ ] Al aceptar el borrado del token, las líneas de exportación de `INFISICAL_TOKEN` desaparecen del `.bashrc`

## 6. Fuera del alcance de esta spec

- El desinstalador de Windows (`uninstall-fitnessgym.ps1`): queda fuera por la misma razón que el instalador de Windows en la spec 97.
- Soporte de gestores de secretos adicionales.
- Persistencia del token de Infisical durante la desinstalación: el token es efímero para la sesión de limpieza; la única escritura de `.bashrc` posible es su eliminación, siempre preguntada.
