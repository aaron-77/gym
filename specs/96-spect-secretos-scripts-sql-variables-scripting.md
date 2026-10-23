# Spec: Contraseñas de scripts SQL de la base de datos - externalización via variables de scripting

## 1. Resumen

Los scripts SQL de la base de datos —fuente de verdad del directorio de migración— crean y alteran los logins de SQL Server con las contraseñas escritas dentro del archivo: un login de servicio de la aplicación y un login personal, con repeticiones del mismo literal a lo largo de tres scripts. Todo trackeado y publicado en GitHub.

Esta spec reemplaza cada contraseña por una variable de scripting del cliente SQL: el script declara las variables al inicio, cada sentencia CREATE y ALTER LOGIN refiere el valor por nombre, y quien ejecuta provee los valores en el momento de la ejecución, de forma que el valor pueda venir de la resolución del entorno (por Infisical, con el mismo flujo declarado por la spec 93) en lugar de quedar anotadas en el repositorio. Los nombres de los logins y de la base de datos no son secretos y quedan como literales en el script.

Con esta exteriorización, los scripts de seguridad siguen siendo ejecutables de punta a punta por el directorio de migración sin restringir el valor de contraseña, y el contenido del repositorio deja de exponer las contraseñas.

## 2. Contexto

- **Capa:** Base de datos (scripts de seguridad del directorio de fuente de verdad)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Precedente de semillas seguras | Refactor a semillas generadas sin literales | Mismo espíritu de la remoción de valores inseguros escritos en SQL | `57-spect-generarClaseProgramada-seedSeguro.md` |
| Ajuste aún previo de semillas inseguras | Remoción de ítems inseguros de semillas | Antecedente directo de corrección de contraseñas duras en SQL | `58-spect-correccion-seeds-inseguros-items-2-5.md` |
| Permisos del login personal | Script de permisos de aaronlogin sobre FitnessCenterDB | Convivencia con el mismo login creado por los scripts que esta spec externaliza | `92-spect-permisos-aaronlogin-fitnesscenterdb.md` |
| Directorio de migración | `bd/scripsOrdenadosParaMigrarBd/` | Regla de fuente de verdad y organización por tipo; los scripts modificados residen en 12seguridad | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Variables de scripting del cliente SQL global | Mecanismo de ejecución | Sustitución por nombre en tiempo de ejecución, provisión de valores al invocar |
| CLI de Infisical | Infraestructura | Fuente opcional del valor en el momento de la ejecución para entornos desplegados |
| Búsqueda textual | Verificación | Confirmación de ausencia de literales |

## 3. Scripts a modificar

### 3.1 Archivos y apariciones

| Archivo | Apariciones | Literales envueltos |
|---------|-------------|---------------------|
| `bd/create-login.sql` | 2 | Contraseña del login de servicio en el CREATE LOGIN y en el ALTER LOGIN |
| `bd/scripsOrdenadosParaMigrarBd/12seguridad/login.sql` | 1 | Contraseña del login personal en el CREATE LOGIN |
| `bd/scripsOrdenadosParaMigrarBd/12seguridad/fitnessgymuser.sql` | 3 con comentario | Contraseña escrita en comentario de cabecera, CREATE LOGIN y en la variante incluida en bloque condicional |

### 3.2 Contrato

| Elemento | Descripción |
|----------|-------------|
| Declaración de variables | Cada script declara con nombre único las variables de contraseña que usa, con documentación breve en cabecera sin valores |
| Sustitución por referencia | Cada CREATE y ALTER LOGIN refiere la variable por nombre; ningún contenido del archivo porta el literal |
| Provisión al invocar | El comando de ejecución recibe los valores como variables del cliente SQL, una por variable declarada |
| Gestión local | El desarrollador ejecuta con los valores con que compone; despliegues resuelven de Infisical; nunca en el archivo |
| Idempotencia preservada | El bloque condicional y el ALTER de restauración del script de creación mantienen su lógica; lo único que cambia es el origen del valor de contraseña |

## 4. Acciones que debe realizar

1. Declarar las variables de contraseña al inicio de cada script con su documentación.
2. Reemplazar cada literal de contraseña por la referencia a su variable.
3. Remover el comentario de cabecera que imprime la contraseña en texto plano.
4. Documentar en el README de la carpeta de scripts (o en la referencia de configuración si el repo prefiere un único lugar) el flujo de provisión de valores al ejecutar, con mención del caso local y del caso desplegado por Infisical.
5. Confirmar mediante búsqueda textual de los literales en `bd/` que no quede ninguna aparición restante.

## 5. Patrones a aplicar

- **Scripts parametrizados:** el script declara su contrato de variables; los valores llegan solo al momento de ejecutar, como en la externalización de Nginx de la spec 91.
- **Comentarios inocentes también cuentan:** un literal en un comentario es igual de filtrable que un literal en código.
- **Nombres versus secretos:** identificadores (login, database) son estructura; contraseñas son valores, y solo los valores viajan.

## 6. Criterios de aceptación

- [ ] Búsqueda textual de las dos contraseñas comprometidas en el nodo `bd/`: cero resultados
- [ ] Los tres scripts ejecutan fin a fin proviendo los valores al invocar, con la misma huella que la ejecución previa - logins, permisos y estados intactos
- [ ] La ejecución sin proveer las variables falla con un mensaje de variable de scripting faltante, no con éxito silencioso
- [ ] La documentación de flujo de ejecución ubicada en el lugar acordado da cuenta del caso local y del desplegado
- [ ] Los nombres de los logins y de la base de datos quedan como literales intactos: los únicos valores removidos de los archivos son las contraseñas

## 7. Fuera del alcance de esta spec

- Rotación de las contraseñas ya comprometidas: trámite humano.
- connection strings de appsettings: spec 93; secretos de tests: spec 94; secretos de código C#: spec 95.
