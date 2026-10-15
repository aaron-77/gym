# Spec: Seguridad - Permisos mínimos de aaronlogin en FitnessCenterDB

## 1. Resumen

Los scripts de seguridad de la base tienen dos defectos concretos.

**Primero, la contraseña no coincide con la de la aplicación.** El script del login escribe una contraseña que no es la que la aplicación envía desde sus archivos de configuración. Si el script corre tal cual, la API y el frontend quedan sin poder conectarse: el login existe pero rechaza la contraseña que le llega.

**Segundo, el permiso de ejecución es más amplio de lo necesario.** Se otorga a nivel de base de datos, lo que alcanza a todos los esquemas de la base y no solo al esquema donde viven los objetos de la aplicación. Tampoco bloquea los procedimientos almacenados de diagramas de base de datos, utilidades de administración que un usuario de aplicación no debería poder invocar.

El cambio hace tres cosas: alinea la contraseña del script con la que ya usan los archivos de configuración, acota el permiso de ejecución al esquema donde viven los objetos de la aplicación, y deniega los procedimientos de diagrama que existan en la base.

Los archivos de configuración **no se tocan**: ya tienen la contraseña correcta. El script es el que se ajusta a ellos.

## 2. Contexto

- **Capa:** `bd/scripsOrdenadosParaMigrarBd/12seguridad/` (scripts de migración de base de datos — no pertenece a ninguna capa de código de la aplicación)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Script de login | `bd/scripsOrdenadosParaMigrarBd/12seguridad/login.sql` | Crea el login en el ámbito de servidor; recibe la corrección de contraseña | — |
| Script de usuario | `bd/scripsOrdenadosParaMigrarBd/12seguridad/usuarios.sql` | Crea el usuario en la base, da los permisos; recibe la acotación de ejecución y la denegación | — |
| Fuente de verdad de la contraseña | `API/appsettings.*.json`, `API/Properties/launchSettings.json` (9 archivos) | Ya contienen la contraseña vigente; definen el valor que el script debe igualar. **No se modifican** | — |
| Objetos que deben ser ejecutables | `bd/scripsOrdenadosParaMigrarBd/procedimientosYFuncionesOneFile.sql` | 91 objetos propios: 52 procedimientos almacenados y 39 funciones. Todos viven en el esquema de la aplicación | — |
| Objetos que deben ser legibles y escribibles | `bd/esquemaBdsDeReferenciaParaIa/FitnessGymSchemaActual.sql` | 57 tablas, todas en el esquema de la aplicación | — |
| Restauración previa | `bd/restore.sql` | Crea la base desde el respaldo, lo que trae un usuario huérfano ligado al login viejo. Debe correr primero | — |
| Procedimientos de diagrama | Los siete procedimientos de diagrama de base de datos que la utilidad de diagramas instala en el esquema de la aplicación | Candidatos a denegación; pueden o no existir según si alguien creó un diagrama. El script no asume que existen | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Restauración de la base | Secuencia | Si el script de usuario corre antes de la restauración, la base aún no existe y todo falla |
| Login previo | Secuencia | El usuario se crea ligado al login; sin el login, la creación del usuario falla |
| Contraseña de la aplicación | Acoplamiento | El login debe quedarse con la misma contraseña que envían los nueve archivos de configuración |
| Conexiones de la aplicación | Acoplamiento | Los dos composes locales y el de producción, más los tres archivos de configuración de la API y el archivo de perfiles de lanzamiento, apuntan al mismo servicio de base y usan la misma contraseña |

## 3. Permisos de aaronlogin a crear

### 3.1 Archivos

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `bd/scripsOrdenadosParaMigrarBd/12seguridad/login.sql` | Modificar | Reemplaza la contraseña por la de la configuración de la aplicación y ajusta el comentario que explica la política de contraseñas, que hoy describe un caso que ya no aplica |
| `bd/scripsOrdenadosParaMigrarBd/12seguridad/usuarios.sql` | Modificar | Cambia la ejecución de nivel base de datos a nivel esquema, agrega la denegación condicional de los procedimientos de diagrama y actualiza el comentario de la sección de permisos |

No se crean archivos nuevos. No se modifica ningún archivo fuera de la carpeta de seguridad.

### 3.2 Contrato

**Script de login (ámbito de servidor):**

- Crea el login si no existe y lo recrea si ya existe, de modo que el script se puede correr más de una vez sin fallar.
- Usa la misma contraseña que los archivos de configuración de la aplicación.
- No agrega el login a ningún rol de servidor. En particular no queda con permiso de administrador, que era como estaba antes.
- Deja la política de contraseñas y la expiración desactivadas: es una cuenta de aplicación con contraseña fija, no una cuenta de persona que deba rotar su contraseña.
- Al terminar imprime un reporte con el nombre, el tipo, el estado y la base por defecto del login.

**Script de usuario (ámbito de base de datos):**

- Quita al usuario de los roles de base de datos que el respaldo pudiera traerle heredados, en particular los roles de lectura y escritura totales y el de dueño. Sin esto, cualquier permiso acotado que se otorgue después no restringe nada, porque esos roles tienen control sobre todo.
- Transfiere al dueño de la base cualquier esquema u objeto que el usuario pudiera poseer, para que la eliminación del usuario no falle.
- Elimina el usuario si existe y lo recrea ligado al login, con el esquema por defecto de la aplicación. Esto borra cualquier permiso heredado y alinea el usuario al identificador actual del login.
- Otorga permiso de lectura, inserción, actualización y borrado sobre el esquema de la aplicación. Al ser a nivel de esquema, cubre las 57 tablas actuales y las futuras sin volver a tocar el script.
- Otorga permiso de ejecución sobre el esquema de la aplicación. Al ser a nivel de esquema, cubre los 91 objetos propios actuales y los futuros. **No** se otorga a nivel de base de datos.
- Deniega el permiso de ejecución sobre los procedimientos de diagrama, pero solo sobre los que realmente existan en la base. La denegación se construye consultando el catálogo en lugar de escribir los nombres a mano, de modo que el script no falla cuando falta alguno.
- Al terminar imprime tres reportes: el usuario y sus roles, el conjunto de permisos vigentes con su estado, y la pertenencia a roles.

**Garantía que el conjunto debe cumplir:** el usuario puede leer y escribir las tablas de la aplicación y ejecutar sus procedimientos y funciones, y no puede ejecutar las utilidades de administración de diagramas. No tiene permisos a nivel de base de datos, solo a nivel de esquema.

### 3.3 Flujo de validación

| Paso | Condición previa | Qué pasa si no se cumple |
|------|------------------|--------------------------|
| 1 | La restauración de la base ya corrió | El script de usuario falla porque la base no existe |
| 2 | El login ya existe en el servidor | El script de usuario falla al crear el usuario ligado, porque no hay login al que ligarlo |
| 3 | El script de login corrió con la contraseña vigente | La aplicación conecta con una contraseña que el login no reconoce y toda petición falla de autenticación |
| 4 | El respaldo no trajo al usuario como dueño de esquemas u objetos | La eliminación del usuario falla por propiedad; el script lo previene transfiriendo la propiedad antes |
| 5 | Los procedimientos de diagrama se deniegan de forma condicional | Si se deniegan por nombre fijo y alguno no existe, el script aborta y el resto de permisos no se aplica |

Los reportes finales son informativos: imprimen el estado real, no interrumpen la ejecución.

### 3.4 Patrones a aplicar

- **Mínimo privilegio:** el usuario recibe solo lo que la aplicación necesita. No se crean miembros de roles de lectura o escritura totales, porque esos roles otorgan más de lo pedido y anulan cualquier acotación posterior.
- **Otorgamiento por esquema en lugar de por objeto:** enumerar los 91 objetos uno por uno obliga a reejecutar el script cada vez que se agrega un procedimiento. Otorgar sobre el esquema cubre los actuales y los futuros.
- **La denegación siempre gana:** el permiso denegado prevalece sobre el permiso otorgado y sobre cualquier permiso heredado por pertenecer al rol público. Por eso la denegación de los procedimientos de diagrama se aplica después del otorgamiento sobre el esquema.
- **Scripts reejecutables:** cada paso comprueba la existencia de lo que va a crear o borrar, para que correr el script dos veces seguidas dé el mismo resultado sin errores.
- **Separación de ámbitos:** el login vive en el servidor y el usuario vive en la base. Script distinto por ámbito, con un orden de ejecución fijo.

## 4. Archivos a crear o modificar

| Archivo | Acción | Cambio |
|---------|--------|--------|
| `bd/scripsOrdenadosParaMigrarBd/12seguridad/login.sql` | Modificar | Contraseña igualada a la de la configuración; comentario de política de contraseñas ajustado a la nueva situación |
| `bd/scripsOrdenadosParaMigrarBd/12seguridad/usuarios.sql` | Modificar | Ejecución acotada al esquema; denegación condicional de procedimientos de diagrama; comentario de la sección de permisos actualizado |

Archivos nuevos: ninguno.

Archivos de configuración de la aplicación modificados: ninguno. Los nueve ya contienen la contraseña correcta.

## 5. Criterios de aceptación

- [ ] La contraseña que escribe el script del login coincide con la que envían los nueve archivos de configuración de la aplicación.
- [ ] El login no es miembro de ningún rol de servidor; en particular no tiene permiso de administrador.
- [ ] El usuario no es miembro de los roles de dueño, de lectura total ni de escritura total de la base.
- [ ] El usuario tiene permiso de lectura, inserción, actualización y borrado sobre el esquema de la aplicación, y sobre ningún otro esquema.
- [ ] El usuario tiene permiso de ejecución otorgado a nivel de esquema y no a nivel de base de datos.
- [ ] Los 91 objetos propios de la aplicación —52 procedimientos y 39 funciones— son ejecutables por el usuario.
- [ ] Ningún procedimiento de diagrama existente en la base es ejecutable por el usuario.
- [ ] El script de permisos no falla cuando un procedimiento de diagrama no existe.
- [ ] Ambos scripts se pueden ejecutar dos veces seguidas sin producir errores.
- [ ] Los scripts se ejecutan en el orden: restauración, login, usuario.
- [ ] Los reportes finales confirman el usuario creado, la ausencia de membresías de rol y el conjunto de permisos vigentes.
- [ ] Los nueve archivos de configuración de la aplicación quedan sin modificar.
