# Spec: Tests - Resolución de identificadores de usuario por correo de configuración

## 1. Resumen

Se elimina el método privado de resolución de identificadores que vive dentro de las clases de prueba y se reemplaza por llamadas directas al ayudante de usuarios, pasándole el correo leído de la configuración tipada. Cada clase de prueba pide únicamente los identificadores que efectivamente usa.

Para que ninguna prueba tenga que referenciar la clave de título, el contenedor de opciones expone un accesor público de correo por cuenta configurada. La tercera cuenta de la lista pasa a llamarse `ClienteRebeca`, de modo que su nombre indique que es una cuenta de cliente usada para resolver identificadores de datos.

## 2. Contexto

- **Capa:** GymWebApp.Tests (configuración + opciones tipadas + fachada de interfaz + tests de integración)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Lista tipada de usuarios de prueba | `GymWebApp.Tests/appsettings.Testing.json` | Se conserva su forma; solo se renombra la entrada de la tercera cuenta | `89-spect-credenciales-test-configuracion-tipada.md` |
| Contenedor de opciones | `GymWebApp.Tests/Integration/Common/TestUsersOptions.cs` | Ya resuelve entradas por título; agrega los accesorios públicos de correo y deja el título como asunto interno | `89-spect-credenciales-test-configuracion-tipada.md` |
| Ayudante de consulta de usuarios | `GymWebApp.Tests/Integration/Helpers/UserHelper.cs` | Ya resuelve identificadores por correo de forma parametrizada; se usa tal cual, sin cambios | `89-spect-credenciales-test-configuracion-tipada.md` |
| Fachada de credenciales de interfaz | `GymWebApp.Tests/E2E/Common/E2ETestSettings.cs` | Delega en el contenedor; renombra la propiedad de la tercera cuenta | `89-spect-credenciales-test-configuracion-tipada.md` |
| Regla de prohibición de ayudantes en pruebas | `GymWebApp.Tests/AGENTS.md` | Prohíbe escribir lógica de ayudante dentro de las clases de prueba; los ayudantes van en la carpeta de ayudantes | — |
| Regla de no depender del orden de ejecución | `GymWebApp.Tests/AGENTS.md` | Exige que las pruebas no dependan del orden entre clases; se satisface porque cada identificador sale de una cuenta nombrada, no de una fila arbitraria | — |
| Siete clases con método privado de identificadores | `Integration/Features/Citas/CitasApiTests.cs`, `Integration/Features/Clases/CancelarClasesProgramadasTests.cs`, `Integration/Features/Clases/InscribirAClaseApiTests.cs`, `Integration/Features/Clases/ReagendarInscripcionAClaseApiTests.cs`, `Integration/Features/Clases/RegistrarClaseProgramadaTests.cs`, `Integration/Features/PreReservas/ClasesControllerInscribirAClaseLimpiezaTests.cs`, `Integration/Features/Rutinas/RutinasApiTests.cs` | Cada una declara su propia copia privada del método; las siete desaparecen | — |
| Documentación que nombra a la tercera cuenta | `GymWebApp.Tests/AGENTS.md`, `GymWebApp.Tests/specs/e2e-happy-paths.md`, `specs/e2e-tests.md` | Mencionan el nombre de la entrada; se actualizan para que no contradigan la configuración | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Enlace de secciones de configuración | Framework | Mantiene el mecanismo actual de recuperación de entradas por título dentro del contenedor |
| Ayudante de configuración | Código de pruebas | Provee la sección de la que el contenedor enlaza la lista |
| Contenedores de pruebas | Infraestructura | Restauran la copia de seguridad que contiene las tres cuentas configuradas |
| Ayudante de conexión | Infraestructura | Provee la conexión para las consultas que resuelven identificadores |

## 3. Acceso por correo a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/appsettings.Testing.json` | Renombra la entrada de la tercera cuenta |
| `GymWebApp.Tests/Integration/Common/TestUsersOptions.cs` | Agrega la constante del nuevo título y los tres accesorios públicos de correo |
| `GymWebApp.Tests/E2E/Common/E2ETestSettings.cs` | Renombra la propiedad de la tercera cuenta |

### 3.2 Contrato

**Accesorios públicos de correo**, uno por cuenta configurada:

| Accesor | Entrada que resuelve | Correo vigente | Contraseña |
|---------|----------------------|----------------|-----------|
| Correo de empleado | `Empleado` | empleado.spiffy479@aleeas.com | sí |
| Correo de cliente | `Cliente` | clientefitnessgym.jockey868@simplelogin.com | sí |
| Correo de cliente con datos | `ClienteRebeca` | rebeca@gmail.com | no |

**Semántica de acceso:**

| Situación | Comportamiento |
|-----------|----------------|
| El accesor se invoca y la entrada existe | Devuelve el correo configurado |
| La entrada no existe en la lista | Lanza excepción; no devuelve cadena vacía ni valor de reserva |
| La entrada existe pero su correo está vacío o en blanco | Lanza excepción |
| Se pide la contraseña de una cuenta sin contraseña | Lanza excepción explicando que solo sirve para resolver identificadores |
| Fuera del contenedor de opciones | Ningún consumidor referencia la constante de título; solo se usan los accesorios de correo |
| Dentro del contenedor de opciones | La recuperación por título sigue existiendo como mecanismo interno; es el único lugar donde la constante de título aparece |

### 3.3 Flujo de validación

| Paso | Validación | Patrón | Resultado del error |
|------|-----------|--------|---------------------|
| 1 | La lista de la sección de configuración existe y tiene al menos una entrada | Enlace con falla inmediata | Excepción con el nombre de la sección |
| 2 | La entrada solicitada por título está presente, sin importar mayúsculas | Búsqueda por igualdad de texto insensible a mayúsculas | Excepción con el título buscado y la sección |
| 3 | El correo de la entrada no está vacío | Comprobación de texto en blanco | Excepción con el título buscado |
| 4 | Si además se pide contraseña, la entrada la tiene | Comprobación de ausencia | Excepción que indica que la cuenta solo resuelve identificadores |

### 3.4 Acciones que debe realizar

1. Renombrar la entrada de la tercera cuenta en el archivo de configuración de pruebas para que su título exprese que es una cuenta de cliente usada por su nombre.
2. Renombrar la constante pública de título correspondiente en el contenedor de opciones, conservando el resto de las constantes sin cambios.
3. Agregar al contenedor de opciones un accesor público por cuenta que devuelva el correo, reutilizando la recuperación interna existente para no duplicar la lógica de búsqueda.
4. Mantener el accesor de contraseña existente, que ya lanza excepción cuando la cuenta no tiene contraseña.
5. Redirigir la propiedad de la fachada de interfaz que exponía la tercera cuenta al nuevo nombre, sin alterar las otras cuatro propiedades.
6. En cada una de las siete clases de prueba, eliminar el método privado de resolución de identificadores y el bloque de región que lo contiene cuando quede vacío.
7. En el primer punto de cada clase de prueba, invocar directamente al ayudante de usuarios pasándole la conexión de prueba y el accesor de correo de la cuenta que ese punto necesita.
8. En los puntos que necesitan los dos identificadores, hacer dos invocaciones consecutivas: una con el correo del cliente y otra con el correo del empleado.
9. En los puntos que necesitan un solo identificador, hacer una única invocación con el correo correspondiente, sin consultar la otra cuenta.
10. Unificar el nombre de la variable del identificador del entrenador en todas las clases, eliminando las variantes en inglés y la variante de empleado.
11. Actualizar las tres referencias documentales que nombran a la tercera cuenta.
12. Ejecutar la auditoría final de la sección 5 antes de dar por terminado el cambio.

### 3.5 Patrones a aplicar

- **Encapsulación por exposición mínima:** el contenedor expone correos, no claves. Quien llama no necesita conocer la estructura de la lista.
- **Ayudante fuera de la clase de prueba:** la lógica de resolución vive en la carpeta de ayudantes; la clase de prueba solo invoca y usa el resultado.
- **Consulta mínima:** cada punto de prueba consulta exactamente las cuentas que usa; ninguna consulta resuelve un identificador que se descarta.
- **Consulta parametrizada:** el correo viaja como parámetro de la consulta, nunca interpolado dentro de su texto.
- **Determinismo por nombre de cuenta:** el identificador sale de una cuenta nombrada en configuración, no de la primera fila que encuentre la base.

## 4. Archivos a modificar

### 4.1 Fase 1 — Configuración y contenedor

| Archivo | Cambio |
|---------|--------|
| `GymWebApp.Tests/appsettings.Testing.json` | La tercera entrada de la lista cambia de título; su correo y su contraseña anulable no cambian |
| `GymWebApp.Tests/Integration/Common/TestUsersOptions.cs` | Constante de título de la tercera cuenta renombrada y tres accesorios públicos de correo agregados |

### 4.2 Fase 2 — Fachada de interfaz

| Archivo | Cambio |
|---------|--------|
| `GymWebApp.Tests/E2E/Common/E2ETestSettings.cs` | La propiedad de la tercera cuenta adopta el nuevo nombre; las otras cuatro quedan intactas |

### 4.3 Fase 3 — Las siete clases de prueba

Cada clase pierde su método privado y pasa a invocar al ayudante de usuarios. Los puntos de prueba se reparten así:

| Archivo | Puntos | Solo identificador de cliente | Solo identificador de empleado | Los dos identificadores |
|---------|--------|-------------------------------|--------------------------------|--------------------------|
| `Integration/Features/Citas/CitasApiTests.cs` | 3 | 1 | 0 | 2 |
| `Integration/Features/Clases/CancelarClasesProgramadasTests.cs` | 3 | 1 | 0 | 2 |
| `Integration/Features/Clases/InscribirAClaseApiTests.cs` | 3 | 3 | 0 | 0 |
| `Integration/Features/Clases/ReagendarInscripcionAClaseApiTests.cs` | 1 | 1 | 0 | 0 |
| `Integration/Features/Clases/RegistrarClaseProgramadaTests.cs` | 1 | 0 | 0 | 1 |
| `Integration/Features/PreReservas/ClasesControllerInscribirAClaseLimpiezaTests.cs` | 2 | 2 | 0 | 0 |
| `Integration/Features/Rutinas/RutinasApiTests.cs` | 5 | 3 | 1 | 1 |
| **Total** | **18** | **11** | **1** | **6** |

Resultado: de treinta y seis consultas de resolución de identificador se pasa a veinticuatro.

### 4.4 Fase 4 — Documentación

| Archivo | Cambio |
|---------|--------|
| `GymWebApp.Tests/AGENTS.md` | La enumeración de entradas de la lista tipada refleja el nuevo nombre de la tercera entrada |
| `GymWebApp.Tests/specs/e2e-happy-paths.md` | La referencia a la propiedad de la fachada adopta el nuevo nombre |
| `specs/e2e-tests.md` | La entrada documentada de la tercera cuenta adopta el nuevo nombre |

### 4.5 Alcance fuera de esta spec

Estos elementos **no se modifican**. Se listan para que la verificación los confirme intactos:

| Ítem | Motivo por el que queda fuera |
|------|------------------------------|
| Los quince sitios de resolución por correo de las dos clases de medidas | No participan del método privado que se elimina; usan la cuenta de cliente y no se ven afectados por el renombre, que se propone migrar a los accesorios en un cambio posterior |
| Los demás consultores de identificador por correo del proyecto de pruebas | Ninguno declara método privado de resolución dentro de la clase de prueba |
| La consulta de identificador por rol del ayudante de usuarios | Se conserva sin cambios; la siguen usando las pruebas de alta de roles |
| Las pruebas de autenticación, de cierre de sesión, de refresco y de cambio de contraseña | Ya leen de configuración y no usan el método privado eliminado |
| Las fábricas con autenticación | Ya leen de la lista tipada por su cuenta |
| Las consultas de las clases de medidas | Fuera del alcance del método eliminado, según la tabla anterior |
| Los identificadores fijos de los escenarios sin autenticación | Son parte del contenido del escenario negativo |
| Las pruebas unitarias de validación y el correo de destino del gestor de correo | Fuera de alcance desde la spec anterior |
| La sección muerta de configuración de la aplicación y de la api | Decisión explícita de mantenerlas tal como están |
| La documentación de la spec anterior sobre la tercera cuenta | Se actualiza únicamente el nombre de la entrada, nunca su semántica de uso |
| Ejecución de compilación y de pruebas | La verificación corresponde a quien ejecuta las pruebas |
| Operaciones de control de versiones | Se ejecutan por separado, con la herramienta de flujo de trabajo del proyecto |

## 5. Criterios de aceptación

- [ ] La entrada de la tercera cuenta en la configuración de pruebas tiene un título que expresa que es una cuenta de cliente, con el mismo correo y sin contraseña
- [ ] El contenedor de opciones expone tres accesorios públicos de correo, uno por cuenta configurada
- [ ] Fuera del contenedor de opciones no queda ninguna referencia a las constantes de título en el código de pruebas
- [ ] Cada accesor lanza excepción si la entrada no existe o si su correo está vacío
- [ ] La propiedad de la fachada de interfaz correspondiente a la tercera cuenta adopta el nuevo nombre, y las otras cuatro propiedades quedan intactas
- [ ] Las siete clases de prueba perdieron su método privado de resolución de identificadores
- [ ] Los bloques de región de ayudantes que quedaron vacíos fueron eliminados
- [ ] Ninguna clase de prueba contiene lógica de resolución de identificadores; solo invoca al ayudante de usuarios
- [ ] Los dieciocho puntos de prueba invocan al ayudante de usuarios directamente
- [ ] Los once puntos que solo necesitan el identificador del cliente hacen una única consulta
- [ ] El punto que solo necesita el identificador del entrenador hace una única consulta
- [ ] Los seis puntos que necesitan ambos identificadores hacen dos consultas, una por cuenta
- [ ] Ninguna consulta resuelve un identificador que el punto de prueba descarta
- [ ] El nombre de la variable del identificador del entrenador es el mismo en las siete clases
- [ ] Los correos de las tres cuentas provienen de la configuración; ninguno está escrito a mano en el código de pruebas
- [ ] Las tres referencias documentales que nombran a la tercera cuenta fueron actualizadas
- [ ] Las quince resoluciones de las clases de medidas quedaron intactas
- [ ] La consulta por rol del ayudante de usuarios y las pruebas que la usan quedaron intactas
- [ ] Los escenarios sin autenticación conservan sus identificadores fijos sin cambios
- [ ] Las fábricas con autenticación y las pruebas de autenticación quedaron intactas
- [ ] Ningún archivo fuera de la lista de las secciones 4.1 a 4.4 fue modificado
- [ ] No se buildea ni se ejecutan pruebas después del cambio; la verificación corresponde a quien ejecuta las pruebas
