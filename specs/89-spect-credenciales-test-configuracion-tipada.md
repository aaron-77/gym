# Spec: Tests - Credenciales de autenticación obtenidas de configuración tipada

## 1. Resumen

Los tests del proyecto escriben a mano los correos y contraseñas con los que se autentican: hay ochenta literales de correo repartidos entre peticiones de login, aserciones y consultas directas a la base. Cincuenta y seis de ellos corresponden a usuarios reales de prueba y deben salir del código para vivir en la configuración de testing.

Además, el proyecto carga el archivo de configuración desde tres lugares distintos, con tres rutas base distintas. Si el directorio de trabajo del proceso de pruebas no coincide con el directorio de salida, cada cargador resuelve distinto y el resultado depende de quién corra primero.

Esta spec unifica la lectura en un único cargador con ruta base única, introduce una clase fuertemente tipada con una lista de entradas —el mismo patrón que la spec 88 aplicó en el frontend— y hace que todos los consumidores pasen por ella. La clase existente que hoy expone las credenciales a los tests de interfaz se conserva como fachada con idénticos nombres, de modo que los consumidores que ya funcionan no se modifican.

El cambio se ejecuta en seis fases y el intercambio de correos por los de la nueva copia de seguridad se produce al final, cuando todo lo que depende de los valores antiguos ya fue migrado.

Al terminar, agregar un usuario de prueba es una línea de configuración sin escribir código, ninguna consulta a la base contiene un correo escrito a mano, y los tests autentican con las cuentas que existen en la copia de seguridad vigente.

## 2. Contexto

- **Capa:** GymWebApp.Tests (configuración + helpers + tests de integración + tests de interfaz)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Patrón de opciones tipadas | Clase de configuración con lista de entradas | Precedente de forma y de registro aplicado en el frontend; se replica en el proyecto de pruebas | `88-spect-credenciales-login-configuracion.md` |
| Regla vigente de credenciales | `GymWebApp.Tests/AGENTS.md` | Mandata que las credenciales salgan de la configuración de testing y nunca se escriban en los archivos de prueba; se amplía su alcance explícito | — |
| Regla de escenario de interfaz | `specs/e2e-tests.md` | Declara la misma regla para los tests de interfaz; se actualiza con los usuarios vigentes | — |
| Infraestructura de interfaz | `specs/e2e-infraestructura.md` | Declara los usuarios que el seed debe contener; se actualiza | — |
| Configuración de pruebas | `GymWebApp.Tests/appsettings.Testing.json` | Archivo fuente de verdad; recibe la nueva forma y los correos vigentes | — |
| Expuesto de credenciales de interfaz | `E2E/Common/E2ETestSettings.cs` | Clase estática que hoy expone cuatro propiedades sin valores de reserva; se conserva como fachada | — |
| Cargador genérico | `Integration/Common/ConfigHelper.cs` | Cargador con ruta base distinta; se unifica y queda como carga interna de la fachada | — |
| Segundo cargador a eliminar | Constructor de `E2E/Features/E2EHappyPathsTests.cs` | Tercer cargador con sondeo de ruta y cuatro valores de reserva; se elimina | — |
| Fábricas con autenticación | `Integration/Common/CitasApiWebApplicationFactory.cs`, `Integration/Common/CancelarReagendarApiErrorWebApplicationFactory.cs` | Ya leen de configuración pero por secciones planas; migran a la lista tipada | — |
| Ayudante de consulta de usuarios | `Integration/Helpers/UserHelper.cs` | Resuelve usuarios por rol sin correos escritos a mano; recibe el nuevo método de consulta por correo | — |
| Copia de seguridad de pruebas | `FitnessGymBackup20261001.bak` | Fuente real de los datos de las pruebas; contiene las cuentas vigentes y ya no contiene las anteriores | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Opciones tipadas del framework | Framework | Enlace de secciones de configuración a clases con lista de entradas |
| Ayudante de configuración propio | Código de pruebas | Lectura de claves con lanzamiento de excepción si faltan |
| Contenedores de pruebas | Infraestructura | Restauran la copia de seguridad que alimenta a los usuarios de prueba |
| Ayudante de conexión | Infraestructura | Provee la conexión para las consultas que resuelven identificadores de usuario |

## 3. Acceso tipado a credenciales a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/Integration/Common/TestUsersOptions.cs` | Nuevo: entrada de credencial y contenedor con la lista |
| `GymWebApp.Tests/Integration/Helpers/UserHelper.cs` | Se agrega la consulta de identificador por correo, parametrizada |

Los consumidores se dividen en tres grupos: los que ya usan la fachada no cambian, los que leen secciones planas migran, y los que escriben el correo a mano se reemplazan.

### 3.2 Contrato

**Entrada de credencial**, con tres campos:

| Campo | Tipo | Obligatorio | Propósito |
|-------|------|-------------|-----------|
| Título | texto | sí | Identificador con el que los consumidores recuperan la entrada |
| Correo | texto | sí | Cuenta con la que se autentica o se localiza al usuario |
| Contraseña | texto anulable | no | Solo para cuentas que efectivamente se autentican |

**Contenedor de opciones**, con un único campo de lista que reúne las entradas.

**Semántica de acceso:**

| Situación | Comportamiento |
|-----------|----------------|
| Se pide una entrada por su título | Se devuelve la entrada coincidente, ignorando mayúsculas |
| El título no existe en la lista | Lanza excepción; nunca devuelve nulo ni un valor vacío |
| El título existe pero no trae contraseña | Devuelve la entrada con la contraseña nula; quien intente autenticarse con ella falla de forma visible |
| Falta la sección completa de configuración | Lanza excepción |
| Se pide un campo vacío | Lanza excepción |

**Fachada de interfaz:** la clase existente conserva exactamente los mismos nombres de propiedad que hoy, de modo que los once puntos de uso de las cinco clases de interfaz que ya la consumen no se modifican. Por dentro, cada propiedad resuelve la entrada correspondiente de la lista. Se agrega una propiedad nueva para el correo de la tercera cuenta. **No se introducen valores de reserva en ninguna propiedad**: si falta un dato, el fallo es inmediato y ruidoso.

**Carga interna:** la fachada y el ayudante genérico pasan a compartir una única ruta base, la del directorio de salida del proceso. El cargador con sondeo de ruta relativa se elimina.

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Comportamiento en error |
|------|-----------|--------|------------------------|
| 1 | El archivo de configuración existe en el directorio de salida | Carga obligatoria, sin opcionalidad | Excepción al iniciar; ningún test corre con datos por defecto |
| 2 | La sección de la lista existe y tiene al menos una entrada | Comprobación previa al enlace | Excepción |
| 3 | Cada entrada tiene título y correo | Enlace tipado con campos obligatorios | Excepción |
| 4 | La entrada pedida por título está en la lista | Búsqueda insensible a mayúsculas | Excepción con el título pedido |
| 5 | La contraseña es obligatoria solo donde se autentica | Comprobación en el punto de uso | Excepción si se intenta autenticar sin contraseña |
| 6 | El correo pedido existe en la base | Consulta parametrizada que devuelve identificador | El test falla con su propia aserción, no con una consulta vacía |

Ningún paso tiene valor por defecto. La ausencia de un dato de configuración interrumpe la ejecución en lugar de degradarla en silencio.

### 3.4 Acciones que debe realizar

**Fase 1 — Unificar la lectura:**

1. Crear la entrada de credencial con título, correo y contraseña anulable, y el contenedor con la lista de entradas.
2. Declarar el enlace de la sección de configuración al contenedor tipado.
3. Reescribir la fachada de interfaz para que cada propiedad existente resuelva su entrada de la lista, conservando su nombre y su lanzamiento de excepción.
4. Agregar la propiedad nueva para el correo de la tercera cuenta.
5. Unificar la ruta base del ayudante genérico con la de la fachada.
6. Migrar las dos fábricas que leen secciones planas para que consuman la lista tipada.
7. Eliminar el cargador con sondeo de ruta del constructor de la clase de caminos felices.

**Fase 2 — Tests de interfaz:**

8. Eliminar de ese constructor el campo de configuración que no se vuelve a leer después de asignarlo.
9. Eliminar el constructor propio de configuración con sondeo de ruta.
10. Eliminar los cuatro valores de reserva de las credenciales.
11. Reemplazar los cuatro campos locales por las propiedades de la fachada, en los veintidós puntos de uso.
12. Dejar intacto el correo y la contraseña deliberadamente inválidos del escenario negativo.

**Fase 3 — Lógica de autenticación:**

13. Reemplazar las credenciales escritas a mano en las peticiones de autenticación, de cierre de sesión y de refresco de token.
14. Reemplazar el correo del cuerpo de la petición de cambio de contraseña y los dos parámetros de correo de sus consultas.
15. Reemplazar la aserción que repite el correo enviado: debe comparar contra el valor leído, no contra un literal, para que un cambio de configuración no lo haga fallar por el motivo equivocado.
16. Corregir el nombre del método de prueba de contraseñas, que anuncia un usuario de un rol mientras lee el otro.

**Fase 4 — Consultas a la base:**

17. Agregar al ayudante de usuarios la consulta de identificador por correo con parámetro en lugar de interpolación.
18. Reemplazar las veintinueve consultas que escriben el correo dentro del texto de la instrucción por la llamada al ayudante, pasando el correo resuelto desde la lista tipada.
19. Limpiar los comentarios que repiten los correos.

**Fase 5 — Configuración:** *(se ejecuta al final; es el punto de quiebre)*

20. Reemplazar las dos secciones planas por la lista de entradas con tres cuentas: la de empleado y la de cliente con los correos de la copia de seguridad vigente, y la tercera solo con correo.
21. Confirmar que ninguna consulta ni petición conserve un correo anterior antes de dar por valida la fase.

**Fase 6 — Documentación:**

22. Ampliar la regla de credenciales del archivo de normas del proyecto de pruebas para que cubra explícitamente las pruebas de integración, no solo las de interfaz.
23. Actualizar los tres documentos de especificación que declaran los usuarios disponibles.

### 3.5 Patrones a aplicar

- **Fachada estable:** la clase que ya exponen los consumidores conserva sus nombres; cambia su interior, no su superficie. Los once puntos de uso funcionan sin edición.
- **Lista sobre claves planas:** los usuarios viven en una lista de entradas, no en una sección por usuario. Agregar un usuario es agregar un renglón de configuración, sin escribir código.
- **Sin valores de reserva:** ninguna propiedad ni consulta tiene un valor por defecto. Un dato ausente interrumpe, no degrada.
- **Contraseña anulable con propósito:** la tercera cuenta solo se usa para localizar identificadores, nunca para autenticarse; su contraseña queda nula a propósito para que un uso indebido falle de inmediato.
- **Consulta parametrizada:** el correo llega como parámetro de la consulta, no como parte de su texto. Se elimina de paso la interpolación de cadenas en instrucciones contra la base.
- **Orden con punto de quiebre explícito:** todo lo que depende de los valores antiguos se migra antes de intercambiar los correos; la última fase es la única que cambia datos y es la única que puede romper pruebas.
- **Coherencia con el patrón del producto:** la misma forma de configuración tipada con lista de entradas que ya usa el frontend, de modo que ambos extremos se leen con el mismo modelo mental.

### 3.6 Inyección de dependencias

No se registra nada. El enlace se realiza al leer la sección de configuración dentro de la fachada y del ayudante genérico, con la misma técnica que usan hoy, porque estos componentes son clases estáticas a las que ningún contenedor inyecta nada. Las fábricas de prueba no reciben la opción por contenedor: reciben credenciales resueltas al construir la sesión autenticada. Registrar opciones en el contenedor de la aplicación de pruebas introduciría una segunda vía de lectura, que es precisamente lo que este cambio elimina.

## 4. Archivos a modificar

### 4.1 Fase 1 — Unificación de lectura

| Archivo | Acción |
|---------|--------|
| `GymWebApp.Tests/Integration/Common/TestUsersOptions.cs` | Crear |
| `GymWebApp.Tests/Integration/Common/ConfigHelper.cs` | Unificar ruta base y enlazar la nueva sección |
| `GymWebApp.Tests/E2E/Common/E2ETestSettings.cs` | Convertir en fachada sobre la lista tipada |
| `GymWebApp.Tests/Integration/Common/CitasApiWebApplicationFactory.cs` | Migrar de sección plana a lista tipada |
| `GymWebApp.Tests/Integration/Common/CancelarReagendarApiErrorWebApplicationFactory.cs` | Migrar de sección plana a lista tipada |
| `GymWebApp.Tests/E2E/Features/E2EHappyPathsTests.cs` | Eliminar el cargador con sondeo de ruta |

### 4.2 Fase 2 — Tests de interfaz

| Archivo | Acción |
|---------|--------|
| `GymWebApp.Tests/E2E/Features/E2EHappyPathsTests.cs` | Eliminar campo muerto, constructor propio y cuatro valores de reserva |

### 4.3 Fase 3 — Lógica de autenticación

| Archivo | Acción |
|---------|--------|
| `GymWebApp.Tests/Integration/Features/Users/AutenticarUsuarioApiTests.cs` | Credenciales y aserción que las repite |
| `GymWebApp.Tests/Integration/Features/Users/LogoutApiTests.cs` | Credenciales |
| `GymWebApp.Tests/Integration/Features/Users/RefreshTokenApiTests.cs` | Credenciales |
| `GymWebApp.Tests/Integration/Features/Users/CambiarPasswordApiTests.cs` | Correo de la petición y de las dos consultas |
| `GymWebApp.Tests/Integration/Features/Users/PasswordHelperTests.cs` | Corrección del nombre del método de prueba |

### 4.4 Fase 4 — Consultas a la base

| Archivo | Sitios |
|---------|--------|
| `GymWebApp.Tests/Integration/Helpers/UserHelper.cs` | Nuevo método de consulta |
| `GymWebApp.Tests/Integration/Features/Medidas/MedidasApiTests.cs` | 11 |
| `GymWebApp.Tests/Integration/Features/Medidas/MedidasDuplicatesValidationTests.cs` | 4 |
| `GymWebApp.Tests/Integration/Features/Clases/CancelarClasesProgramadasTests.cs` | 2 |
| `GymWebApp.Tests/Integration/Features/Clases/InscribirAClaseApiTests.cs` | 2 |
| `GymWebApp.Tests/Integration/Features/Clases/ReagendarInscripcionAClaseApiTests.cs` | 2 |
| `GymWebApp.Tests/Integration/Features/Clases/RegistrarClaseProgramadaTests.cs` | 2 |
| `GymWebApp.Tests/Integration/Features/Citas/CitasApiTests.cs` | 2 |
| `GymWebApp.Tests/Integration/Features/Rutinas/RutinasApiTests.cs` | 2 |
| `GymWebApp.Tests/Integration/Features/PreReservas/ClasesControllerInscribirAClaseLimpiezaTests.cs` | 2 |

### 4.5 Fase 5 — Configuración y documentación

| Archivo | Acción |
|---------|--------|
| `GymWebApp.Tests/appsettings.Testing.json` | Reemplazar secciones planas por la lista de tres entradas |
| `GymWebApp.Tests/AGENTS.md` | Ampliar el alcance de la regla de credenciales |
| `specs/e2e-tests.md` | Actualizar los usuarios disponibles |
| `specs/e2e-infraestructura.md` | Actualizar el seed declarado |
| `GymWebApp.Tests/specs/e2e-happy-paths.md` | Actualizar las credenciales declaradas |

### 4.6 Alcance fuera de esta spec

Estos archivos **no se modifican**. Se listan aquí para que la verificación de la fase 6 los confirme intactos:

| Ítem | Motivo por el que queda fuera |
|------|------------------------------|
| Contraseñas y correos de los tests unitarios de validación | Son entradas de formato para probar reglas de contraseña y de correo, no credenciales de acceso; acoplarlos a la configuración de usuarios los haría depender de un dato ajeno a lo que verifican |
| Contraseña deliberadamente inválida del escenario negativo de interfaz | Su valor incorrecto es el contenido del escenario; si leyera de configuración dejaría de ser negativo sin aviso |
| Contraseña del usuario recién registrado en los tests de alta | Es la contraseña que se está creando, no una con la que se ingresa |
| Correo de destino del gestor de correo | Es destinatario de envío, no cuenta de acceso |
| Correo inexistente usado como afirmación de un token local | Su inexistencia a propósito es el escenario |
| Contraseña nueva y distinta en los tests de cambio de contraseña | Es el valor que se está fijando, no una credencial vigente |
| Secciones muertas de configuración de la aplicación y de la api | Decisión explícita de mantenerlas tal como están |
| Diferencia de clave de firma entre el camino de integración y el de interfaz | Asunto distinto, no decidido en este cambio |
| Contraseña de aplicación de correo electrónico presente en el repositorio | Asunto de seguridad aparte, no decidido en este cambio |

## 5. Criterios de aceptación

- [ ] El archivo de configuración de pruebas expone una única lista de entradas con título, correo y contraseña anulable
- [ ] La entrada de empleado y la de cliente usan los correos de la copia de seguridad vigente
- [ ] La entrada de la tercera cuenta existe con correo y sin contraseña, y se usa exclusivamente para resolver identificadores
- [ ] Las dos secciones planas anteriores quedan eliminadas de la configuración
- [ ] La clase de fachada conserva todos sus nombres de propiedad actuales y agrega la propiedad del correo de la tercera cuenta
- [ ] Ninguna propiedad de la fachada ni ninguna lectura de credenciales tiene un valor por defecto
- [ ] Existe un único cargador de la configuración de pruebas con una única ruta base, la del directorio de salida
- [ ] El cargador con sondeo de ruta relativa y el campo muerto de configuración de la clase de caminos felices fueron eliminados
- [ ] Ninguna de las cinco clases de interfaz que ya consumían la fachada fue editada
- [ ] La clase de caminos felices no contiene ningún valor de reserva de credenciales
- [ ] Los escenarios negativos de interfaz conservan su contraseña deliberadamente inválida sin cambios
- [ ] Ninguna petición de autenticación, de cierre de sesión o de refresco contiene un correo o una contraseña escritos a mano
- [ ] La aserción que repetía el correo enviado compara ahora contra el valor leído de la configuración
- [ ] Ninguna consulta a la base interpola un correo dentro de su texto; todas pasan el correo como parámetro
- [ ] Las veintinueve consultas de resolución de identificador usan el nuevo método del ayudante de usuarios
- [ ] Los comentarios que repetían correos fueron actualizados o eliminados
- [ ] Las pruebas unitarias de validación, el escenario negativo de interfaz, el alta de usuarios, el gestor de correo y el token con usuario inexistente quedaron intactos
- [ ] Las secciones muertas de configuración de la aplicación y de la api quedaron intactas
- [ ] Ningún archivo fuera de la lista de la sección 4 fue modificado
- [ ] No se buildea ni se ejecutan pruebas después del cambio; la verificación corresponde a quien ejecuta las pruebas
- [ ] Verificación: ejecutar la suite de pruebas y confirmar que los cincuenta y seis literales de correo en alcance desaparecieron del código, dejando solo los veinticuatro fuera de alcance
