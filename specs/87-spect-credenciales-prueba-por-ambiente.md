# Spec: Frontend - Credenciales de prueba del login visibles según ambiente

## 1. Resumen

El bloque de credenciales de prueba que aparece en la vista de login —los dos usuarios de prueba con su contraseña— se muestra actualmente siempre, sin importar en qué ambiente corra la aplicación. Esta spec lo condiciona al ambiente de hosting: el bloque solo se emite en el HTML servido cuando el ambiente es Production o Staging, y desaparece por completo en cualquier otro caso.

La condición se resuelve con el tag helper de ambiente que ya trae el framework y que ya está registrado en el proyecto. No se escribe ninguna clase, no se toca ningún controller, no se agrega ninguna configuración: el cambio se limita a envolver el bloque existente en la vista de login.

Al final de la spec, el login muestra las credenciales de prueba únicamente en Production y Staging, y no deja rastro alguno de ese bloque —ni elemento ni contenido— en Development, Testing o cualquier ambiente no listado.

## 2. Contexto

- **Capa:** GymFrontend (Views)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Vista | `Login.cshtml` | Única vista que contiene el bloque de credenciales de prueba; se renderiza desde la acción de GET y desde la acción de login fallido | `Views/Users/Login.cshtml` |
| Import de tag helpers | `_ViewImports.cshtml` | Archivo que registra los tag helpers del framework y los del proyecto para todas las vistas; ya contiene el registro necesario, no se modifica | `Views/_ViewImports.cshtml` |
| Tag helper de ambiente | Tag helper de ambiente del framework | Componente de presentación que emite su contenido solo si el ambiente de hosting coincide con la lista recibida; vive en el ensamblado de tag helpers de MVC | — |
| Estilos | `login.css` | Reglas del bloque de credenciales; quedan sin uso cuando el bloque no se emite y no requieren cambio | `wwwroot/css/login.css` |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Registro de tag helpers | Razor | Línea de registro del ensamblado de tag helpers de MVC ya presente en el import de vistas; habilita el tag helper de ambiente en todas las vistas |
| Hosting environment | Framework | Proveedor de ambiente inyectado por el contenedor de dependencias; expone el nombre del ambiente vigente |
| Nombre de ambiente | Configuración de despliegue | Valor definido fuera de esta spec, por la parte que configura el ambiente de la aplicación |

## 3. Condicionamiento del bloque a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/Views/Users/Login.cshtml` | Se envuelve el bloque completo de credenciales de prueba con el tag helper de ambiente, indicando Production y Staging como ambientes donde corresponde mostrarlo |

No se crea ningún archivo nuevo. No se modifica el import de tag helpers: el registro del ensamblado del framework ya está presente y es el que habilita el componente a usar. No se modifica ningún controller, ningún archivo de configuración, ningún archivo CSS y ningún script.

### 3.2 Contrato

El bloque existente pasa a quedar dentro de un tag helper de ambiente con la siguiente especificación:

| Aspecto | Definición |
|---------|-----------|
| Elemento | Elemento de tag helper de ambiente, propio del framework |
| Atributo | Atributo de inclusión, con valor de lista separada por comas |
| Valor | Los dos nombres de ambiente Production y Staging |
| Sentido | Lista blanca: el contenido se emite solo si el ambiente vigente está en la lista |
| Comparación | Insensible a mayúsculas y minúsculas, y con los nombres recortados de espacios |
| Comportamiento al coincidir | Se emite el contenido del bloque con su marcaje y sus clases intactas |
| Comportamiento al no coincidir | Se suprime la salida completa: no se emite la marca del tag helper ni nada de su contenido |
| Corrida | El tag helper se evalúa antes que el resto, por orden de ejecución priorario |
| Atributos sin resolver | Si el atributo de inclusión no está presente o viene vacío, el tag helper no suprime nada y el contenido se emite siempre |

Se eligió la lista blanca y no la lista negra a propósito: un ambiente desconocido, mal escrito o aún no previsto cae fuera de la lista y el bloque no se muestra. Con una lista negra, ese mismo ambiente desconocido expondría las credenciales.

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Comportamiento |
|------|-----------|--------|----------------|
| 1 | Determinar el nombre del ambiente vigente | Lectura del proveedor de ambiente inyectado | Si el nombre estuviera vacío, el tag helper no suprime y el contenido se emite |
| 2 | Comparar ese nombre contra la lista Production, Staging | Comparación insensible a mayúsculas con recorte de espacios | Cualquier coincidencia habilita la emisión |
| 3 | Coincidencia encontrada | Lista blanca | Se emite el bloque completo de credenciales |
| 4 | Sin coincidencia | Lista blanca | Se suprime la salida: ni marca del tag helper ni contenido |
| 5 | Atributo de inclusión ausente o vacío | Fallo silencioso del componente | Se emite el contenido igual; se cubre con la verificación del HTML servido |

**Resultado esperado por ambiente:**

| Ambiente | Bloque de credenciales |
|----------|------------------------|
| Development | No visible |
| Testing | No visible |
| Staging | Visible |
| Production | Visible |
| Cualquier otro nombre | No visible |
| Nombre de ambiente vacío | Visible |

### 3.4 Patrones a aplicar

- **Presentación condicionada en la vista:** la decisión es puramente de presentación y vive donde ocurre el render, no en el controller. El controller sigue devolviendo la misma vista en el GET y en el login fallido, y la condición se evalúa en ambos caminos sin duplicar lógica.
- **Lista blanca sobre lista negra:** se declaran los ambientes donde sí corresponde mostrar, de modo que el caso por defecto sea ocultar. Es el criterio correcto para información sensible: lo no previsto queda protegido.
- **Reutilización de componente del framework:** no se implementa lógica propia de ambiente en el proyecto. El tag helper ya existe, ya está registrado y ya resuelve su dependencia de ambiente por inyección. Implementar una clase equivalente sería código nuevo para replicar comportamiento probado.
- **Sin fuente de configuración paralela:** el nombre del ambiente es la única fuente de verdad, igual que ya se usa en el arranque de la aplicación. No se introduce un indicador duplicado en archivos de configuración que pueda divergir del ambiente real.
- **Ausencia total, no ocultamiento visual:** cuando el bloque no corresponde, se suprime la salida completa. No se emite un elemento vacío ni un bloque con clase de ocultamiento, de modo que el HTML servido no deja rastro de la existencia del bloque ni de su contenido.

## 4. Archivos a modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymFrontend/Views/Users/Login.cshtml` | Modificar | Envolver el bloque de credenciales de prueba con el tag helper de ambiente, listando Production y Staging |

## 5. Alcance fuera de esta spec

| Ítem | Motivo por el que queda fuera |
|------|------------------------------|
| Definición del valor de ambiente en cada despliegue | Se define desde la parte que configura el ambiente, fuera de este alcance |
| `docker-compose-local.yml` | Excluido por decisión explícita |
| Archivos `appsettings` | La condición no depende de configuración de la aplicación |
| Controller de usuarios | No requiere cambio: ambos caminos devuelven la misma vista |
| Estilos del bloque | Se conservan tal como están; quedan sin uso en los ambientes donde el bloque no se emite |
| Credenciales almacenadas en la vista | Se mantienen como están; auditar el valor de esas credenciales es un tema aparte |
| Otras vistas | El bloque existe únicamente en el login, verificado por búsqueda en todo el frontend |
| Test automatizado | Testear el tag helper sería testear el framework, no código propio; la cobertura queda en la verificación manual por ambiente |

## 6. Criterios de aceptación

- [ ] En ambiente Production, el login muestra el bloque completo de credenciales de prueba con sus dos usuarios y sus contraseñas
- [ ] En ambiente Staging, el login muestra el bloque completo de credenciales de prueba
- [ ] En ambiente Development, el HTML servido del login no contiene ninguna marca ni ningún texto del bloque de credenciales
- [ ] En ambiente Testing, el HTML servido del login no contiene ninguna marca ni ningún texto del bloque de credenciales
- [ ] El HTML servido en los ambientes donde el bloque no corresponde no deja elemento vacío residual del tag helper
- [ ] La comparación de nombre de ambiente ignora diferencias de mayúsculas y minúsculas
- [ ] Un ambiente no listado no muestra el bloque
- [ ] El bloque se condiciona tanto en el ingreso por GET al login como en la devolución de la vista tras un login fallido
- [ ] No se modificó el import de tag helpers, porque el registro necesario ya existía
- [ ] No se creó ninguna clase de tag helper propia ni ninguna clase nueva en el proyecto
- [ ] No se modificó ningún controller, ningún archivo de configuración, ningún archivo CSS y ningún script
- [ ] No se modificó el contenido, el orden ni las clases del bloque de credenciales
- [ ] No se buildea el proyecto después del cambio, según la regla del repositorio
- [ ] Verificación manual: revisar el HTML servido del login en los cuatro ambientes del proyecto y confirmar la tabla de resultados esperados
