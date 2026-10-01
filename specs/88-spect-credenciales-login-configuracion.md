# Spec: Frontend - Credenciales de prueba del login obtenidas de configuración

## 1. Resumen

El bloque de credenciales de prueba del login —los dos usuarios de prueba con su contraseña y sus títulos de sección— está escrito a mano dentro de la vista. Cualquier cambio de un correo, una contraseña o un título obliga a abrir la vista, editar marcado y recompilar. Esta spec traslada esos valores a la configuración base de la aplicación y hace que la vista los lea de ahí para renderizarlos.

La decisión de **en qué ambientes se muestra** no cambia: sigue siendo exclusiva del tag helper de ambiente que define la spec 87, con su lista blanca de Production y Staging. La configuración aporta únicamente **qué valores** se muestran; el ambiente sigue aportando **dónde** se muestran. Ninguno de los dos se entromete en el otro.

Los valores se leen mediante el patrón Opciones con una clase fuertemente tipada, de modo que la forma de los datos queda definida en un solo lugar y el compilador acompaña cualquier cambio de nombre. No se usa acceso por rutas de configuración armadas con strings en ninguna parte del flujo.

Al terminar, el HTML servido del login en Production y Staging es idéntico al de hoy, Development y Testing siguen sin rastro alguno del bloque, y cambiar un correo o una contraseña pasa a ser una edición de configuración sin tocar código.

## 2. Contexto

- **Capa:** GymFrontend (vista) + DTO (clase tipada) + GymFrontend (registro de opciones)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Vista de login | `Views/Users/Login.cshtml` | Única vista con el bloque de credenciales de prueba; se modifica para delegar el contenido en un partial. Se renderiza desde seis puntos de retorno del controller de usuarios | `87-spect-credenciales-prueba-por-ambiente.md` |
| Tag helper de ambiente | Tag helper de ambiente del framework | Gate de visibilidad vigente, con lista blanca Production y Staging; no se modifica | `87-spect-credenciales-prueba-por-ambiente.md` |
| Configuración base | `GymFrontend/appsettings.json` | Recibe la nueva sección; es la fuente heredada por todos los ambientes | — |
| Configuración por ambiente | `appsettings.Staging.json`, `appsettings.Production.json`, `appsettings.Development.json`, `appsettings.Testing.json` | No se modifican; heredan la sección de la base y pueden sobreescribirla si algún ambiente lo necesita | — |
| Registro de opciones | `GymFrontend/Program.cs` | Ya bindea secciones de configuración a clases tipadas (`JwtSettings`, `PagesSettings`); el nuevo registro se agrega junto a esos | — |
| Clases de configuración | `DTO/Dtos/JwtSettings.cs`, `DTO/Dtos/PageSettings.cs` | Precedente de ubicación y estilo para clases de configuración tipadas | — |
| Partials de vista | `Views/Shared/_ProgresoElement.cshtml`, `Views/Shared/_EstructuraClaseItem.cshtml` | Precedente de unidades de render reutilizables dentro del proyecto | — |
| Import de vistas | `Views/_ViewImports.cshtml` | No se modifica; los nombres de espacio necesarios se declaran dentro del partial | — |
| Estilos del bloque | `wwwroot/css/login.css` | No se modifica; el marcado de salida se conserva idéntico | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Patrón Opciones | .NET | Resolución de opciones tipadas desde contenedor de dependencias; se usa la variante con alcance de request |
| Vinculación de configuración | .NET | Mapeo automático de la sección de configuración a la clase tipada, insensible a mayúsculas |
| Herencia de configuración | .NET | La configuración base se carga en todos los ambientes y la del ambiente se superpone encima |
| Tag helper de ambiente | Razor | Condiciona la emisión del bloque al ambiente de hosting vigente |
| Proveedor de ambiente | Framework | Expone el nombre del ambiente que evalúa el tag helper |
| Contenedor de dependencias | Framework | Entrega la opción tipada resuelta al partial dentro del request |

## 3. Sección de configuración a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/appsettings.json` | Se agrega la nueva sección con las credenciales que hoy están escritas en la vista |

Los archivos de configuración por ambiente no se modifican. Al estar la sección en la base, todos los ambientes la heredan; si en algún momento un ambiente necesita valores distintos, basta con repetir la sección en su archivo de configuración para que pise a la base, sin tocar código.

### 3.2 Contrato

| Aspecto | Definición |
|---------|-----------|
| Nombre de la sección | `TestCredentialsForRealUsers` |
| Forma | Lista ordenada de entradas |
| Cantidad | Dos hoy; cantidad abierta en el futuro sin necesidad de modificar la vista |
| Campo de título | Etiqueta de la sección que se muestra en la vista; corresponde a los títulos que hoy están escritos a mano |
| Campo de correo | Correo electrónico que se muestra en la vista |
| Campo de contraseña | Contraseña que se muestra en la vista |
| Notación de los campos | Mayúscula inicial, consistente con las secciones de credenciales que ya existen en la configuración de pruebas del proyecto |
| Orden | El orden de la lista es el orden de salida en la vista |
| Valores iniciales | Traslado literal de los valores que hoy están en la vista; ninguno de los valores se altera |
| Ubicación | Solamente en la configuración base |

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Comportamiento |
|------|-----------|--------|----------------|
| 1 | Carga de configuración al arrancar | Proveedor de configuración con la configuración base del ambiente vigente | La sección queda disponible para vincular |
| 2 | Vinculación de la sección a la clase tipada | Vinculación automática de propiedades, insensible a mayúsculas | La lista de la clase queda poblada con las entradas de la sección |
| 3 | Sección presente con entradas | Vinculación normal | La lista contiene las entradas en el orden del archivo |
| 4 | Sección ausente | La propiedad de lista arranca inicializada vacía | Lista vacía, sin excepción de ningún tipo |
| 5 | Entrada con algún campo vacío | Sin validación en tiempo de ejecución | Se emite el bloque con el valor vacío; nunca se produce un error |

No hay validación en tiempo de ejecución porque son datos de presentación: el contrato es que las entradas lleguen completas, y si alguna llegara incompleta el comportamiento correcto es degradar a una salida incompleta, nunca interrumpir el render ni tirar abajo la página.

## 4. Clase tipada a crear

| Aspecto | Definición |
|---------|-----------|
| Nombre | `TestCredentialsForRealUsers` |
| Ubicación | `DTO/Dtos/`, igual que las clases de configuración existentes |
| Miembro contenedor | Propiedad de lista de entradas, **inicializada vacía** |
| Miembros de entrada | Título, correo y contraseña, en la notación definida en el contrato de la sección |
| Lógica | Ninguna; es una clase de datos sin comportamiento |
| Validaciones | Ninguna |

Inicializar la lista vacía es requisito, no detalle estético: si la sección faltara, la propiedad quedaría sin asignar y el partial tiraría una excepción de referencia nula al intentar recorrerla. Con la lista inicializada, el recorrido itera cero veces y no se emite nada.

## 5. Registro de opciones y consumo

### 5.1 Registro de inyección de dependencias

En `GymFrontend/Program.cs`, junto a los registros existentes de `JwtSettings` y `PagesSettings`, se registra la vinculación de la sección `TestCredentialsForRealUsers` hacia la clase tipada de la sección anterior. Mismo patrón, misma forma de registro, mismo lugar: un solo bloque de configuración tipada en el arranque.

### 5.2 Variante de opciones elegida

| Aspecto | Definición |
|---------|-----------|
| Variante | `IOptionsSnapshot` de la clase tipada |
| Alcance | Scoped, un valor por request |
| ¿Requiere registro aparte? | No; el registro de la vinculación ya da de alta las tres variantes de opciones |
| ¿Dónde se consume? | En el partial, inyectado en la vista |
| Restricción conocida de esta variante | No puede consumirse desde un singleton; no aplica acá, porque el consumo ocurre en la vista dentro del request |
| Recarga | La configuración se carga con recarga por archivo: una corrección hecha en el archivo se refleja en el siguiente request, sin reiniciar la aplicación |
| Límite de la recarga | Solo aplica a archivos editados en su lugar; no aplica a variables de entorno ni a una imagen contenedor en la que la configuración esté horneada |

Se eligió esta variante y no la de alcance único porque el dato no es crítico para el rendimiento, el consumo es por request y el beneficio de reflejar una corrección de configuración sin reiniciar vale el costo marginal de resolver por scope.

### 5.3 Consumo

El partial inyecta la variante elegida sobre la clase tipada y recorre la lista desde su valor. En ningún punto del flujo —vista, partial o controller— se arma una ruta de configuración con strings ni se accede a índices numéricos de lista: la forma de los datos la define un solo lugar, la clase tipada, y un cambio de nombre de campo lo encuentre el compilador en todos los usos.

### 5.4 Patrones a aplicar

- **Patrón Opciones con tipado fuerte:** la configuración se expone como objeto tipado, no como pares de clave y valor. El acceso por strings queda prohibido en todo el flujo.
- **Separación de responsabilidades:** la configuración dice qué valores se muestran; el ambiente de hosting dice dónde se muestran. Cada uno tiene una sola fuente de verdad.
- **Configuración heredada por ambiente:** la base aporta el valor en todos los ambientes y los archivos por ambiente pueden sobreescribirla sin código nuevo.
- **Presentación condicionada en la vista:** la decisión de visibilidad vive donde ocurre el render, criterio heredado de la spec 87.
- **Lista blanca de ambientes:** el tag helper existente ya declara los ambientes donde corresponde mostrar; lo no listado queda oculto por defecto. Criterio heredado de la spec 87.
- **Unidad de render autocontenida:** el partial resuelve su propia configuración, de modo que los seis puntos de retorno del controller quedan cubiertos sin modificar ninguna línea del controller.
- **Ausencia total, no ocultamiento visual:** cuando el bloque no corresponde o la lista viene vacía, no se emite marca ni contenido; el HTML servido no deja rastro.

## 6. Partial a crear

### 6.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/Views/Shared/_TestCredentials.cshtml` | Resuelve la configuración tipada y emite el bloque de credenciales |

### 6.2 Contrato

| Aspecto | Definición |
|---------|-----------|
| Entrada | Ninguna; no recibe parámetros ni modelo |
| Fuente de datos | La opción tipada resuelta desde el contenedor del request |
| Salida | El mismo marcado, el mismo orden, las mismas clases y los mismos textos que el bloque actual |
| Lista con entradas | Un bloque por entrada, en el orden de la lista |
| Lista vacía | No se emite nada, ni siquiera el título del bloque |
| Nombres de espacio | Se declaran dentro del propio partial; el import global de vistas no se modifica |
| Dependencia de estilos | Ninguna nueva; el CSS existente sigue aplicando porque el marcado no cambia |

## 7. Integración con la vista de login

| Aspecto | Definición |
|---------|-----------|
| Acción | Se reemplaza el contenido escrito a mano del bloque por la invocación del partial |
| Tag helper de ambiente | Permanece intacto, con la misma lista blanca de ambientes |
| Orden | El partial se invoca por dentro del tag de ambiente, de modo que el ambiente evalúa primero |
| Resto de la vista | Formulario, validaciones, enlaces y estilos sin modificación |

## 8. Flujo global de render

La vista de login se devuelve desde seis puntos distintos del controller de usuarios: dos en la carga por método de consulta y cuatro en el intento de inicio de sesión. Como el partial resuelve su propia configuración al renderizar, los seis quedan cubiertos sin tocar el controller.

| Paso | Validación | Patrón | Comportamiento |
|------|-----------|--------|----------------|
| 1 | El servidor devuelve la vista de login | Seis puntos de retorno, sin cambios | La vista comienza a renderizar |
| 2 | Evaluación del tag de ambiente | Lista blanca Production y Staging | Determina si el bloque corresponde |
| 3 | Ambiente fuera de la lista | Lista blanca | No se emite nada; ni marca, ni partial, ni contenido |
| 4 | Ambiente dentro de la lista | Lista blanca | Se invoca el partial |
| 5 | Resolución de la opción tipada | Contenedor de dependencias del request | La opción entrega la lista |
| 6 | Recorrido de la lista | Vinculación desde la configuración base | Un bloque por entrada, en orden |
| 7 | Lista vacía | Supresión total | No se emite el bloque completo, incluido su título |

**Resultado esperado por ambiente:**

| Ambiente | Bloque de credenciales | Origen de los valores |
|----------|------------------------|----------------------|
| Development | No visible | Configuración base, sin emitir |
| Testing | No visible | Configuración base, sin emitir |
| Staging | Visible | Configuración base |
| Production | Visible | Configuración base |
| Cualquier otro nombre | No visible | Configuración base, sin emitir |
| Ambiente con lista de credenciales vacía | No visible | Sin entradas que emitir |

## 9. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `DTO/Dtos/TestCredentialsForRealUsers.cs` | Clase tipada con la lista de credenciales |
| `GymFrontend/Views/Shared/_TestCredentials.cshtml` | Partial que resuelve la opción y emite el bloque |
| `specs/88-spect-credenciales-login-configuracion.md` | Este documento |

## 10. Archivos a modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymFrontend/appsettings.json` | Modificar | Se agrega la sección con las credenciales actuales de la vista |
| `GymFrontend/Program.cs` | Modificar | Se registra la vinculación de la sección a la clase tipada, junto a los registros existentes |
| `GymFrontend/Views/Users/Login.cshtml` | Modificar | El bloque escrito a mano se reemplaza por la invocación del partial, dentro del tag de ambiente existente |

## 11. Alcance fuera de esta spec

| Ítem | Motivo por el que queda fuera |
|------|------------------------------|
| Controller de usuarios | No requiere cambio: los seis puntos de retorno devuelven la misma vista y el partial se resuelve en ella |
| Archivos de configuración por ambiente | Heredan la sección de la base; solo se tocarían si un ambiente necesita valores distintos |
| Tag helper de ambiente | Su comportamiento y su lista blanca los define la spec 87 y no cambian |
| Import de vistas | Los nombres de espacio se declaran dentro del partial |
| Estilos del bloque | El marcado de salida se conserva idéntico |
| Valores de las credenciales | Traslado literal desde la vista; auditar o rotar esos valores es un tema aparte |
| Presencia de Production en la lista blanca | Decisión de la spec 87, no se revisa acá |
| Tests automatizados | Van en un spec de tests separado, según la regla del repo de separar spec de implementación y spec de tests |
| Verificación del modelo nulo en dos puntos del controller | Tema aparte, detectado durante el análisis de esta change y ajeno a su alcance |
| `docker-compose-local.yml` | Excluido por decisión de la spec 87 |

## 12. Criterios de aceptación

- [ ] La configuración base contiene la sección `TestCredentialsForRealUsers` con las credenciales que hoy están escritas en la vista, sin alterar ninguno de sus valores
- [ ] La sección es una lista ordenada de entradas con título, correo y contraseña
- [ ] La clase `TestCredentialsForRealUsers` existe en `DTO/Dtos/` con la lista inicializada vacía
- [ ] El registro de la vinculación está en `Program.cs`, junto a los registros existentes de `JwtSettings` y `PagesSettings`
- [ ] El consumo se hace mediante `IOptionsSnapshot` sobre la clase tipada, y no mediante la variante de alcance único
- [ ] No existe ningún acceso a la configuración armado con strings en la vista, en el partial ni en el controller
- [ ] El HTML servido en Production es idéntico al actual: mismas clases, mismo orden y mismos textos
- [ ] El HTML servido en Staging es idéntico al actual
- [ ] El HTML servido en Development no contiene ninguna marca ni ningún texto del bloque
- [ ] El HTML servido en Testing no contiene ninguna marca ni ningún texto del bloque
- [ ] Con la lista de credenciales vacía no se emite el bloque completo, incluido su título
- [ ] El tag helper de ambiente no se modificó y sigue con la misma lista blanca
- [ ] El controller de usuarios no se modificó
- [ ] Los archivos de configuración por ambiente no se modificaron
- [ ] El import de vistas y la hoja de estilos no se modificaron
- [ ] Se mantuvo el bloque de los seis puntos de retorno del controller sin ninguna edición
- [ ] No se buildea el proyecto después del cambio, según la regla del repositorio
- [ ] Verificación manual: revisar el HTML servido del login en los cuatro ambientes del proyecto y confirmar la tabla de resultados esperados
