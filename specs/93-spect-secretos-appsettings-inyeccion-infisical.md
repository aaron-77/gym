# Spec: Secrets de connection strings de ambientes - remoción de appsettings e inyección por Infisical

## 1. Resumen

Las cadenas de conexión con autenticación SqlPassword de la API y del frontend contienen la contraseña real del login de base de datos escrita adentro de archivos de configuración trackeados y publicados en GitHub: la misma contraseña aparece en más de una decena de puntos repartidos en cinco ambientes declarados y en una carpeta de publicación que no debería estar en el repositorio.

Esta spec saca todas esas cadenas de los archivos de configuración: cada `appsettings` de ambiente queda con la sección de conexión sin valor y el proceso recibe la cadena completa por variable de entorno en el momento de ejecución. Los valores viven exclusivamente en Infisical (un valor por concepto de entorno) y el ejecutable de cada aplicación se lanza bajo el envoltorio del CLI de Infisical, que resuelve el entorno elegido e inyecta las variables al proceso. El patrón ya está precedido en el repo por el flujo de Nginx de la spec 91: los archivos trackeados quedan sin secretos y un componente de ejecución completa los valores al arrancar.

Al terminar, ningún archivo trackeado contiene la contraseña de base de datos, las formas de lanzamiento por terminal y contenedores resuelven la conexión por el mismo nombre de variable, y el perfil de lanzamiento con IDE queda intacto en la máquina local sin subirse al repositorio.

## 2. Contexto

- **Capa:** Configuración de ejecución de API y GymFrontend (más dos endurecimientos menores de arranque en el Program.cs de cada aplicación)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Precedente de externalización | Sección Nginx de templates con envsubst | Precedente de archivo trackeado sin secretos y resolución de valores al arrancar | `91-nginx-envsubst-docker.md` |
| Convención de configuración | `extraContext/code-style/configuration.md` | Pauta vigente de appsettings y variables de entorno; se amplía con la nueva variable | — |
| Plantillas de contenedores | `docker-compose.prod.yml`, `bd/docker-compose.prod.yml`, `bd/Dockerfile` | Ya consumen la cadena por variable con placeholder; se mantiene el nombre de variable existente | — |
| Referencia de lanzamiento con IDE | `API/Properties/launchSettings.json` | Contiene la cadena con contraseña en un perfil; no se modifica, deja de trackearse | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Infisical | Infraestructura | Proyecto ya configurado en el repo (archivo de vínculo de workspace en la raíz); provee los valores por entorno |
| Mecanismo de configuración de ASP.NET | Framework | La variable de entorno con prefijo de doble subrayado reemplaza el valor de la sección de conexión sin cambiar código |
| CLI de Infisical | Ejecución | Envoltorio `run` que inyecta el conjunto de variables del entorno seleccionado al proceso |

## 3. Alcance de la externalización

### 3.1 Archivos con el secreto a vaciar

| Archivo | Apariciones | Detalle |
|---------|-------------|---------|
| `API/appsettings.Development.json` | 1 | Clave `DefaultConnection` de la sección ConnectionStrings |
| `API/appsettings.Staging.json` | 1 | Ídem |
| `API/appsettings.Production.json` | 1 | Ídem |
| `GymFrontend/appsettings.json` | 1 | Clave `DefaultConnection` de la sección ConnectionStrings |
| `GymFrontend/appsettings.Development.json` | 1 | Ídem |
| `GymFrontend/appsettings.Production.json` | 2 | Claves `windowsConnection` y `DefaultConnection` |
| `GymFrontend/appsettings.Staging.json` | 1 | Clave `DefaultConnection` |
| `GymFrontend/appp/appsettings.json` | 1 | Ídem, en carpeta de publicación |
| `GymFrontend/appp/appsettings.Development.json` | 1 | Ídem |

Claves que quedan sin cambio por no contener secretos: `windowsConnection` de la API (autenticación integrada de Windows), placeholder SMTP de los appsettings (valores ficticios), y el resto de secciones de configuración.

### 3.2 Archivo excluido del repositorio sin modificación

`API/Properties/launchSettings.json` contiene la cadena con contraseña en las variables de entorno de un perfil, pero **no se modifica**: es un archivo de ejecución local, se usa para correr la API desde el IDE y nada más. Su tratamiento es dejarlo intacto en la máquina y quitarlo del repositorio: remoción del tracking de git y agregado a .gitignore. La contraseña que contiene no llega al repo por el archivo, y su presencia en el historial queda cubierta por la rotación de credenciales (fuera de alcance, responsabilidad humana).

### 3.3 Variable de entorno única por proceso

| Variable | Provisiona | Consumidor |
|----------|-----------|------------|
| `DB_CONNECTION_STRING` | La cadena completa con autenticación SqlPassword | API y GymFrontend, cada uno en su propio proceso |

| Punto de configuración | Clave resuelta | Mecanismo |
|------------------------|----------------|-----------|
| Sección ConnectionStrings del appsettings | `DefaultConnection` | Reemplazo automático por la variable de entorno con el nombre de la sección y la clave unidos por doble guion bajo |

El nombre `DB_CONNECTION_STRING` no es nuevo: es exactamente el que ya esperan las plantillas de despliegue, de modo que contenedores y ejecuciones locales convergen en una sola convención.

### 3.4 Estado final de los archivos

Cada appsettings de ambiente conserva la sección ConnectionStrings y su clave `DefaultConnection` con una cadena vacía, más un campo de documentación textual breve que indique que el valor proviene del entorno por Infisical. No se eliminan las claves, para que la estructura del archivo siga declarando los contratos de configuración; solo desaparece el valor.

### 3.5 Endurecimiento del arranque (cambios menores de código)

La cadena de resolución vigente en la API ordena así: primero la variable de entorno `DB_CONNECTION_STRING`, luego la clave `ConnectionStrings:DefaultConnection` del appsettings si aquella no existe, la clave `ConnectionStrings:windowsConnection` sobre el resultado si el sistema operativo es Windows, y la variable de entorno otra vez sobre el resultado en producción y staging. El frontend lo hace en una sola línea: variable de entorno o clave del JSON.

Dos debilidades de ese bloque se corrigen en esta spec:

| Programa | Ubicación | Endurecimiento |
|----------|-----------|----------------|
| API | Salidas a consola dentro del bloque de conexión | Dejan de volcar la cadena completa al log (aporta la contraseña); registran solo servidor y nombre de base de datos |
| API | Final del bloque de conexión, después del reemplazo por Windows | Si la cadena resuelta queda vacía, el arranque se detiene con un mensaje que nombra la variable `DB_CONNECTION_STRING` faltante |
| GymFrontend | Líneas de resolución previas al registro del DbContext | Ídem: vacío al final del mapeo detiene el arranque nombre y variable |

Motivo del primero: hoy dos salidas de consola imprimen la cadena entera, y con Infisical inyectando el valor en cada arranque, la contraseña acabaría en logs. Motivo del segundo: con el valor vacío en el JSON de la spec, un arranque sin env var en un sistema no Windows seguiría con cadena vacía y fallaría lejos del origen del problema; el fallo debe nombrar la causa.

## 4. Flujo de ejecución con Infisical

### 4.1 Valores en Infisical

1. Dentro del proyecto Infisical del workspace ya vinculado, se cargan los valores para los conceptos de entorno Devel, Staging y Producción: un único secreto con nombre `DB_CONNECTION_STRING` por concepto, con la cadena completa correspondiente a ese entorno.
2. El archivo de vínculo del workspace queda en la raíz como está; la correspondencia rama de git a entorno queda configurada por concepto elegido con el modificador del CLI al invocar, no por el archivo.

### 4.2 Formas de lanzamiento

| Forma | Comando base | Origen del valor |
|-------|--------------|------------------|
| Ejecución local de la API o del frontend | dotnet run envuelto por `infisical run` con entorno Devel | Infisical |
| Lanzamiento con IDE | Perfil de lanzamiento local intacto, con el archivo fuera del repositorio | Archivo local |
| Contenedores de despliegue | Plantillas actuales: variable con placeholder completada al desplegar bajo Infisical | Infisical |

## 5. Acciones que debe realizar

1. Dar de alta los tres secretos `DB_CONNECTION_STRING` en Infisical (tarea humana fuera del repo).
2. Vaciar los valores secretos de los nueve archivos listados en 3.1, dejando la cadena vacía y la documentación textual.
3. Excluir `API/Properties/launchSettings.json` del repositorio: remoción del tracking de git y agregado a .gitignore, sin modificar el archivo local.
4. Ampliar `extraContext/code-style/configuration.md` con la variable nueva y la regla de doble subrayado para connection strings.
5. Ampliar el README en la sección de despliegue con la forma de lanzamiento por Infisical (una mención, no nueva sección).
6. En el bloque de conexión del Program.cs de la API: redactar ambas salidas de consola para que solo registren servidor y base de datos, jamás la cadena completa.
7. En el Program.cs de la API (tras el reemplazo por Windows) y en el del frontend (tras el mapeo de la variable): si la cadena final queda vacía, detener el arranque con mensaje que nombre la variable faltante.

## 6. Patrones a aplicar

- **Configuración externa:** los appsettings declaran forma, el entorno provee valores; ningún archivo trackeado porta credenciales.
- **Un nombre canónico:** una sola variable por concepto de dato sensible, reutilizada por cualquier consumidor futuro.

## 7. Criterios de aceptación

- [ ] Ninguna aparición de la contraseña de base de datos queda en archivos trackeados (búsqueda textual global vacía)
- [ ] La API y el frontend levantan en Devel con el envoltorio de Infisical y consumen la base
- [ ] El lanzamiento por contenedores sigue resolviendo la conexión por la misma variable
- [ ] `API/Properties/launchSettings.json` deja de estar trackeado en git y permanece local sin ninguna modificación
- [ ] La convención queda documentada en la referencia de configuración
- [ ] El arranque no vuelca la cadena completa al log: solo servidor y base de datos
- [ ] Sin env var y en un sistema no Windows, tanto la API como el frontend fallan al arrancar nombrando `DB_CONNECTION_STRING` como causa
- [ ] En Windows el arranque sigue resolviendo por `windowsConnection` (autenticación integrada, sin secreto)

## 8. Fuera del alcance de esta spec

- `GymFrontend/appp/`: el tratamiento de archivos se aplica solo si la carpeta sigue trackeada; su remoción del repositorio (noventa y tres megabytes de artefactos de publicación con dos secretos adentro) es un cambio de limpieza propio y prioritario.
- Rotación de la contraseña ya comprometida en el historial de git: trámite humano obligatorio, previo o posterior a esta externalización.
- Fallback de clave JWT del arranque de la API: decisión de diseño aparte.
- `appsettings.Testing.json`: pertenece a la spec 94.
- Secretos con literales en código C#: pertenecen a la spec 95.
