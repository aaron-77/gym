# FitnessGym

FitnessGym es un sistema de administración de gimnasios que permite a los clientes visualizar su progreso mediante un dashboard, mientras que los empleados pueden administrar las citas y rutinas de ejercicios de los clientes.

Los empleados también pueden gestionar los horarios de las clases para los instructores y administrar las inscripciones de los clientes en tiempo real. El sistema permite reagendar las inscripciones a las clases y envía notificaciones por correo electrónico relacionadas con las citas de los clientes.

**Stack tecnológico:** .NET 8, SignalR, SQL, SQL Server 2022, procedimientos almacenados, Razor, JavaScript, CSS, Bootstrap 5.3, Nginx 1.28, Docker 20.10 y 29, ASP.NET Core Identity, Azure VM (anteriormente S3, EC2 y RDS) y SSL.

## Arquitectura

FitnessGym utiliza una **arquitectura por capas**, lo que permite separar responsabilidades y facilita el mantenimiento, las pruebas y la evolución del sistema.

Toda la aplicación se ejecuta en **contenedores**: la API, el frontend, el reverse proxy con Nginx y la base de datos SQL Server. Los servicios se comunican entre sí a través de una **red Docker interna**, y Nginx actúa como **único punto de entrada expuesto al exterior**. La API, el frontend y la base de datos no son accesibles públicamente. La información de la base de datos se **persiste en volúmenes Docker**.

![Diagrama de despliegue](docsgit/diagrama%20de%20despluiegue.png)

### Despliegue en contenedores

Cada componente corre como un contenedor independiente orquestado con Docker Compose:

* **Nginx:** recibe todo el tráfico externo (HTTPS, WebSockets para SignalR) y redirige a frontend o API según la ruta.
* **Frontend:** contenedor ASP.NET Core MVC.
* **API:** contenedor ASP.NET Core Web API con SignalR y Quartz.
* **Base de datos:** contenedor SQL Server 2022 con imagen propia.

El diagrama refleja este flujo: navegador → Nginx → (Frontend / API) → SQL Server, todo dentro de la red Docker, excepto la comunicación en tiempo real por SignalR, la cual se hace del cliente a Nginx y de Nginx al API directamente.

Los datos sensibles del entorno (cadenas de conexión y demás secretos) no viven en los archivos versionados: se inyectan al proceso por **variables de entorno mediante Infisical** (`infisical run`). Tanto el frontend como la API resuelven su conexión a la base por la variable `DB_CONNECTION_STRING` (ver `specs/93-spect-secretos-appsettings-inyeccion-infisical.md`).

### Nginx

El reverse proxy se ejecuta a partir de una **imagen personalizada** de Nginx. La configuración se define por medio de **templates** al arrancar el contenedor mediante **inyección de variables de entorno**, lo que facilita modificar los datos necesarios del reverse proxy sin tener que construir una nueva imagen.

Las variables que se inyectan son:

* **`GYM_PRIMARY_DOMAIN`:** dominio principal del despliegue.
* **`GYM_APP_DOMAIN`:** dominio de la aplicación.
* **`GYM_API_UPSTREAM`:** dirección del backend de la API.
* **`GYM_FRONTEND_UPSTREAM`:** dirección del frontend.
* **`GYM_SSL_DHPARAM`:** ruta del archivo de parámetros Diffie-Hellman para TLS.
* **`GYM_CLIENT_MAX_BODY_SIZE`:** tamaño máximo del cuerpo de las peticiones.

### Frontend

Es la **capa de presentación** del sistema. Está construida con **ASP.NET Core MVC**, **Razor**, **JavaScript**, **CSS** y **Bootstrap 5.3**.

Se encarga de mostrar la UI al usuario. Las peticiones del navegador llegan primero a Nginx y después al frontend. Cuando el frontend necesita información de la API, realiza la petición desde el servidor mediante la capa BL. De esta forma, el navegador no necesita comunicarse directamente con la API. El frontend recibe la respuesta de la API, prepara la información necesaria para la vista y finalmente devuelve la respuesta al navegador a través de Nginx, esto se hace para evitar la exposición de los tokens en JavaScript por medio del uso de cookies seguras http only; de esta manera se disminuye el riesgo de robo de tokens, dado que las cookies http only solo son enviadas y leídas por el servidor.

### BL (Business Logic)

La capa BL contiene los elementos propios de la capa de negocio, así como un cliente HTTP y clases relacionadas para gestionar la comunicación del frontend con la API de forma reutilizable.

Esta capa incluye:

* Lógica organizada por dominio.
* Un cliente HTTP centralizado para realizar las llamadas a la API.
* Generación de respuestas con un formato uniforme.
* Validaciones personalizadas.
* Manejo centralizado de errores.


### API

La API es el **punto de entrada del backend** y está construida con **ASP.NET Core Web API**.

Su responsabilidad es recibir las peticiones del frontend, ejecutar las operaciones correspondientes y devolver las respuestas con los datos solicitados en los casos que aplique.

La API contiene:

* **Controladores:** exponen los endpoints REST organizados por dominio.
* **Servicios:** contienen operaciones reutilizables que encapsulan la lógica de procesos de registro, consulta, eliminación, etc., junto con sus respectivas llamadas a validaciones de negocio (estas últimas separadas en sus clases respectivas), para que de esta forma los controladores tengan una separación clara de responsabilidades, encargándose solo de lo correspondiente a la gestión de peticiones HTTP y conservándose más limpios.
* **SignalR Hubs:** permiten actualizar información en tiempo real, como horarios y reservas.
* **Trabajos en segundo plano:** utiliza Quartz para ejecutar tareas como los recordatorios de citas.
* **Configuración de infraestructura:** incluye servicios que encapsulan la lógica de autenticación mediante JWT y la lógica de actualización de datos en tiempo real.

### DataAccess

DataAccess es la capa responsable de **acceder y guardar información en la base de datos**.

Utiliza **Entity Framework Core** e incluye:

* El contexto de la base de datos.
* Las entidades utilizadas por el sistema.
* Los repositorios.
* La integración con **ASP.NET Core Identity** para la gestión de usuarios.
* Las migraciones de la base de datos.
Es la única capa de la aplicación que se comunica directamente con SQL Server.

### DTO

Contiene los objetos utilizados para transportar información entre las diferentes partes del sistema.

Incluye:

* DTOs del sistema.
* Una clase con formato genérico para las respuestas.
* Enumeraciones.
* Atributos de validación personalizados.
* Convertidores y serializadores JSON.

Esta separación permite que las diferentes capas compartan los mismos modelos de comunicación sin depender directamente de las entidades utilizadas para la persistencia de datos ni redefinir entidades en distintas capas del sistema.

### Base de datos

El sistema utiliza **SQL Server 2022** como base de datos.

Su objetivo es compartir el esquema de la base de datos, los procedimientos almacenados y las funciones que conforman el sistema, así como el contenido de la base de datos para que pueda verse cómo están construidas las funcionalidades que están hechas en SQL y T-SQL; además incluye la construcción de la imagen de la base de datos con Docker y los scripts utilizados para su construcción. También sirve como respaldo de la base de datos y apoyo para migraciones posteriores a otros motores. No contiene proyectos .csproj ejecutables.

La base de datos se ejecuta en un **contenedor**. La imagen incorpora un healthcheck que verifica que la base esté operativa, lo que permite que los servicios dependientes y los tests esperen a que esté lista antes de conectarse.

Algunos ejemplos de la funcionalidad implementada en la base de datos son **procedimientos almacenados** y **funciones**, para la búsqueda y el cálculo de horarios disponibles, y el registro de clases programadas e inscripciones.

### Testing (GymWebApp.Tests)

El proyecto **GymWebApp.Tests** concentra todas las pruebas del sistema y se ejecuta con **xUnit**. Las pruebas están organizadas en tres tipos de acuerdo al alcance que cubren:

* **Unitarias:** prueban métodos individuales sin levantar infraestructura.
* **De integración:** pruebas de integración de las funcionalidades del sistema usando **WebApplicationFactory** para levantar la API y un contenedor de prueba para la base de datos.
* **E2E:** verifican los flujos críticos de usuario a través de toda la pila (browser → Nginx → API → BD → Frontend) con **Playwright**; se utiliza **Testcontainers** para levantar la aplicación y toda la infraestructura necesaria.

**Stack de testing:** WebApplicationFactory, FluentAssertions, Respawn, NSubstitute, Bogus, Playwright .NET, TSQL y Testcontainers.

Los patrones que implementa el proyecto son:

* **AAA (Arrange, Act, Assert):** las pruebas se estructuran en tres fases siguiendo el patrón AAA: preparación del estado y de los objetos de prueba (Arrange), ejecución de la acción a probar (Act), y verificación de los resultados (Assert).
* **Page Model:** cada página o componente de la interfaz se encapsula en una clase que conoce sus selectores y realiza acciones sobre ella. Las pruebas solo declaran el flujo del usuario y las aserciones, sin manipular el HTML. Los beneficios son reducir la duplicación de acciones compartidas, simplificar el mantenimiento ante cambios en la interfaz, y mantener una separación clara entre la abstracción de la interfaz y la lógica de la prueba.
* **Test Base Class y Shared Fixture:** tanto las pruebas de integración como las E2E heredan de una clase base que se encarga de la inicialización y el ciclo de vida comunes, como levantar contenedores, reiniciar la base de datos y entregar clientes o servicios listos para usar. La instancia compartida entre las pruebas de una misma clase se maneja por medio de un fixture compartido. Cada clase de prueba concreta define únicamente su escenario y sus aserciones, garantizando la misma inicialización en todas las pruebas y evitando la duplicación de lógica.
