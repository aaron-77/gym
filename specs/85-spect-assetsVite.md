# Spec: Build de assets CSS/JS con Vite en GymFrontend

## 1. Resumen

Migrar el pipeline de assets estáticos del frontend a Vite: los 22 CSS y 30 JS hoy servidos desde las carpetas raíz de estáticos (sin minificar, sin cache-busting y referenciados directamente por ~24 vistas/layouts) pasan a vivir como fuente en una carpeta de entrada y se publican minificados y con hash de contenido en una carpeta de salida, junto con un manifest de build. Un tag helper resuelve las rutas por ambiente: desarrollo sirve la fuente sin transformar; producción y staging sirven las rutas hasheadas desde el manifest. La carpeta de fuentes queda excluida del publish (no llega a producción ni a la imagen final del contenedor) y el publish dispara automáticamente el build de assets. De paso se elimina una referencia rota a un script inexistente y se corrige una extensión mal referenciada.

## 2. Contexto

- **Capa:** Frontend (GymFrontend — ASP.NET Core MVC .NET 8)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Proposal | `minificacion-css-js-vite` | Plan aprobado del cambio (Intent/Scope/Capabilities/Approach/Risks/Success Criteria) | — |
| Tag Helper existente | `AppConfigTagHelper` | Tag helper vigente en GymFrontend; referencia de contrato y registro para el nuevo tag helper | — |
| Herramienta | Vite | Bundler de assets: entrada por archivo, salida minificada con hash y manifest de build | — |
| Herramienta | npm + Node v20 | Ejecución del build de assets (local, publish y contenedor) | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Node v20 | Tooling | Requerido para ejecutar npm y el build de Vite (local, publish y contenedor) |
| Vite | Tooling | Herramienta de build declarada como dependencia de desarrollo del frontend |
| Manifest de Vite | Salida de build | Mapeo entrada → archivo emitido con hash; fuente de rutas para Producción/Staging |
| Entorno del host web | Infraestructura ASP.NET Core | Diferencia Desarrollo de Producción/Staging para resolver rutas |
| Registro global de tag helpers | Infraestructura Razor | El archivo de imports de vistas ya registra los tag helpers del ensamblado del frontend |

## 3. Cambios a realizar

### 3.1 Migración de estructura de assets

| Origen | Destino | Descripción |
|--------|---------|-------------|
| `wwwroot/css/` (22 archivos) | `wwwroot/src/css/` | Fuente CSS sin minificar |
| `wwwroot/js/` (27 `.js` + 3 `.mjs`) | `wwwroot/src/js/` | Fuente JS sin minificar |
| — (nuevo, generado) | `wwwroot/dist/` | Salida Vite minificada + hash de contenido + manifest; se regenera en cada build |

Reglas de alcance:

- Los assets de terceros (`wwwroot/lib/`), las imágenes (`wwwroot/img/` y `wwwroot/content/`), el favicon y la hoja de estilos generada por el proyecto (`GymFrontend.styles.css`) NO se tocan: se sirven como hoy.
- El contenido de los CSS/JS no cambia de lógica: solo movimiento de archivos y build. La excepción es la corrección de referencias rotas (sección 3.7).
- El inventario exacto se valida al momento de la migración: los archivos presentes en las carpetas de origen son los que se mueven (el conteo del proposal es el contrato de referencia).

### 3.2 Configuración del build de Vite

- **Una entrada por archivo:** cada CSS y cada JS de la carpeta de fuentes es una entrada nombrada de build (nombre derivado de la ubicación relativa dentro de la carpeta de fuentes), autogenerada por exploración de la carpeta de entrada: no se mantiene una lista manual de entradas. Consecuencia: cada asset es un bundle independiente y cada vista carga únicamente lo que usa.
- **Salida:** la carpeta de salida recibe los assets minificados con nombre hasheado por contenido; el permalink de cada entrada se resuelve al producir el manifest.
- **Manifest:** el build genera un manifest con el mapeo entrada → archivo(s) emitido(s); es la única fuente de verdad para las rutas de producción.
- **Limpieza:** el build vacía la carpeta de salida antes de regenerar, evitando archivos huérfanos de builds anteriores.
- La configuración vive en un archivo de configuración de Vite en la raíz del frontend.

### 3.3 Tooling en el repositorio

- Un manifiesto de paquete (`package.json`) en la raíz del frontend declara Vite como dependencia de desarrollo y un script de build que invoca a Vite.
- En el control de versiones: la carpeta de dependencias de npm y la carpeta de salida `dist` se declaran ignoradas (se regeneran); la carpeta de fuentes `src` SÍ se versiona.
- Si existe un archivo de bloqueo de dependencias commiteado, la instalación usa modo estricto; si no existe, la instalación resuelve dependencias en modo normal (el proposal prefiere la variante que aplique según exista o no el lock).

### 3.4 Auto-build y exclusión de la carpeta de fuentes en el publish

- El archivo de proyecto del frontend incorpora un paso de pre-publicación que: instala las dependencias de npm y ejecuta el script de build de Vite. Se ejecuta automáticamente antes de cada publicación y puede desactivarse con una propiedad opcional de compilación (para builds que no requieran assets).
- El contenido publicado queda compuesto únicamente por la salida de `dist`: la carpeta de fuentes `src` se marca como contenido no publicado mediante los metadatos de contenido del archivo de proyecto del frontend.
- Consecuencia verificable: `src` NO aparece en el output de publish → no llega a producción ni a la imagen final del contenedor.

### 3.5 Docker

- La imagen SDK de .NET 8 de la etapa de build actual no incluye Node. Se agrega un paso de instalación de Node v20 dentro de esa misma etapa, ANTES del comando de publicación, para que el paso automático de npm del publish pueda ejecutarse.
- La carpeta de fuentes permanece disponible durante el build del contenedor (el contexto de build copia el proyecto completo y no excluye `src`), pero no llega a la imagen final porque el publish la excluye.
- El contexto de build del contenedor excluye las dependencias de npm y la carpeta `dist` (ambas se regeneran dentro del build), sin excluir `src`.
- Nota de contexto verificada en el repositorio: el archivo de exclusión Docker vigente vive dentro de la carpeta del frontend pero las copias del DockerFile usan rutas relativas a la raíz del repositorio, lo que indica que el contexto de build es la raíz. El archivo de exclusión que efectivamente aplica es el de la raíz del contexto: debe garantizarse que las exclusiones de dependencias npm y `dist` queden declaradas allí.

### 3.6 ViteTagHelper: comportamiento

Tag helper que reemplaza las referencias directas a CSS/JS en las vistas. Contrato:

- **Carga selectiva:** dos atributos independientes (uno para hojas de estilo y otro para scripts), cada uno acepta una lista separada por comas de nombres de asset. Un atributo opcional permite marcar los scripts como módulos ES.
- **Resolución por ambiente:**

| Ambiente | Origen | Comportamiento |
|----------|--------|----------------|
| Desarrollo | Fuentes (`src`) | Emite la referencia local sin minificar, sin hash |
| Producción / Staging | Salida (`dist`) | Lee el manifest de build (cacheado en memoria, una sola lectura por proceso) y emite la ruta hasheada de la entrada solicitada |

- El tag helper soporta ambas ubicaciones posibles del manifest que Vite puede generar según su versión, verificando cuál existe en el momento de leerlo.
- Si en Producción/Staging la entrada solicitada no existe en el manifest: NO emite la referencia y registra el problema con claridad (falla visible en logs, nunca una ruta rota silenciosa servida al cliente).
- Registro: el tag helper vive en el ensamblado del frontend; el archivo de imports de vistas ya registra globalmente los tag helpers de ese ensamblado, por lo que queda disponible en todas las vistas sin registro adicional (se verifica en la implementación, sin cambiar el archivo si el registro existente ya lo cubre).

### 3.7 Migración de vistas

- Todas las referencias directas a hojas de estilo y scripts (rutas relativas a las carpetas de origen) en las ~24 vistas y layouts se reemplazan por el tag helper, usando los nombres de asset correspondientes (los mismos que genera el build).
- **Referencia rota confirmada, se elimina:** la vista de detalle de clase referencia un script inexistente (el archivo no existe en la carpeta de scripts — verificado). Esa referencia se elimina como parte de la migración.
- **Referencia mal formada confirmada, se corrige:** una vista de entrenadores referencia con terminación `.js` un módulo que en realidad termina en `.mjs` (el archivo real existe con la otra terminación — verificado). Al migrar se apunta al archivo real para que el build la incluya.
- Los nombres de las referencias migradas deben coincidir con los nombres de las entradas generadas por el build, un asset por nombre.

### 3.8 Acciones que debe realizar (ViteTagHelper)

Lista de pasos que el tag helper debe ejecutar, sin código:

1. Detectar el ambiente de ejecución mediante el entorno del host web.
2. En Desarrollo: construir la ruta local del archivo fuente solicitado y emitir la etiqueta correspondiente (hoja de estilo o script) sin transformaciones.
3. En Producción/Staging: localizar el manifest de build (probando las ubicaciones posibles) y cachearlo en memoria para las siguientes peticiones.
4. Buscar en el manifest la entrada solicitada por su nombre.
5. Si la entrada existe: emitir la referencia a la ruta hasheada emitida por el build.
6. Si la entrada no existe: omitir la emisión y registrar el problema con contexto suficiente (nombre del asset y ambiente).
7. Emitir una etiqueta por cada asset de las listas recibidas; si el atributo de módulos ES está activo, marcar los scripts como módulos.

### 3.9 Patrones a aplicar

- **Tag helper de resolución de rutas:** mismo patrón del tag helper existente de configuración: sin lógica de negocio, recibe atributos y emite etiquetas.
- **Caché en memoria:** el manifest se lee una sola vez por proceso y se reutiliza en todas las peticiones.
- **Entrada por archivo (bundle por asset):** cada vista carga solo lo que declara; no hay un bundle global que arrastre todo el sitio.
- **Contrato por ambiente:** la resolución difiere solo por el ambiente inyectado; el resto del pipeline (build, manifest, exclusión) es único.

## 4. Archivos a crear y modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymFrontend/wwwroot/src/css/` | Crear (mover) | 22 CSS fuente sin minificar |
| `GymFrontend/wwwroot/src/js/` | Crear (mover) | 30 JS fuente sin minificar |
| `GymFrontend/wwwroot/dist/` | Generado | Salida minificada + hash + manifest; ignorada en git |
| `GymFrontend/package.json` | Crear | Dependencia de desarrollo Vite + script de build |
| `GymFrontend/vite.config.mjs` | Crear | Entradas autogeneradas desde la carpeta de fuentes, salida `dist`, manifest, limpieza previa |
| `GymFrontend/GymFrontend.csproj` | Modificar | Exclusión de `src` del contenido publicado + paso de pre-publicación npm (instalación + build, desactivable por propiedad) |
| `GymFrontend/DockerFile` | Modificar | Instalación de Node v20 en la etapa de build antes del publish |
| `.dockerignore` (raíz del contexto) | Modificar | Excluir dependencias npm y `dist` del contexto; mantener `src` |
| `.gitignore` (raíz) | Modificar | Ignorar dependencias npm y `dist` del frontend |
| `GymFrontend/TagHelpers/ViteTagHelper.cs` | Crear | Resolución de rutas por ambiente (src en Desarrollo, dist hasheado vía manifest en Producción/Staging) |
| `GymFrontend/Views/_ViewImports.cshtml` | Verificar | El registro global existente del ensamblado ya cubre el nuevo tag helper |
| ~24 vistas/layouts en `GymFrontend/Views/` | Modificar | Referencias directas a CSS/JS reemplazadas por el tag helper |
| `GymFrontend/Views/Home/DetalleDeClase.cshtml` | Modificar | Eliminar la referencia rota al script inexistente (además del reemplazo del resto) |
| `GymFrontend/Views/Users/EntrenadorMainPage.cshtml` | Modificar | Corregir la terminación del módulo referenciado al archivo real |

## 5. Criterios de aceptación

- [ ] Los 22 CSS y 30 JS viven como fuente en `wwwroot/src/{css,js}` y en Desarrollo el tag helper los sirve desde `src` sin minificar ni hash
- [ ] El build genera una entrada por archivo en `wwwroot/dist`, minificada y con hash de contenido, más el manifest de build
- [ ] El publish ejecuta automáticamente instalación de dependencias npm + build de Vite antes de compilar/publicar, y el paso se puede desactivar con la propiedad opcional
- [ ] El output de publish NO contiene la carpeta `src` (solo `dist`), verificable tras publicar
- [ ] El build del contenedor es exitoso con Node v20 instalado en la etapa de build, y la imagen final no contiene `src` ni dependencias npm
- [ ] El tag helper emite rutas hasheadas de `dist` en Producción/Staging y rutas de `src` en Desarrollo; carga selectiva por tipo de asset y módulos ES funcionan
- [ ] Las ~24 vistas/layouts migradas cargan correctamente en ambos ambientes y no quedan referencias directas a las carpetas de origen (salvo assets fuera de alcance)
- [ ] La referencia rota al script inexistente queda eliminada y la terminación mal referenciada del módulo de entrenadores apunta al archivo real
- [ ] Assets de terceros (`wwwroot/lib/`), imágenes, favicon y la hoja de estilos generada por el proyecto no se tocan y se sirven como hoy