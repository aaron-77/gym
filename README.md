# FitnessGym

FitnessGym es un sistema de administración de gimnasios que permite a los clientes visualizar su progreso mediante un dashboard, mientras que los empleados pueden administrar las citas y rutinas de ejercicios de los clientes.

Los empleados también pueden gestionar los horarios de las clases para los instructores y administrar las inscripciones de los clientes en tiempo real. El sistema permite reagendar las inscripciones a las clases y envía notificaciones por correo electrónico relacionadas con las citas de los clientes.

**Stack tecnológico:** .NET 8, SignalR, SQL, SQL Server 2022, procedimientos almacenados, Razor, JavaScript, CSS, Bootstrap 5.3, Nginx 1.28, Docker 20.10 y 29, ASP.NET Core Identity, AWS (EC2, RDS y S3) y SSL.

## Arquitectura

FitnessGym utiliza una **arquitectura por capas**, lo que permite separar responsabilidades y facilita el mantenimiento, las pruebas y la evolución del sistema.

El app esta desplegada  en contendores docker,concretamente **la API y el frontend se ejecutan en contenedores Docker** y están protegidos por un **reverse proxy con Nginx** que corre en el host. Todo el sistema se ejecuta dentro del mismo sistema operativo. La base de datos SQL Server se encuentra directamnete en el host 

![Diagrama de despliegue](docsgit/diagrama%20de%20despluiegue.jpeg)

### Frontend

Es la **capa de presentación** del sistema. Está construida con **ASP.NET Core MVC**, **Razor**, **JavaScript**, **CSS** y **Bootstrap 5.3**.

Se encarga de es mostrar la UI al usuario . Esta contruido con el patron  **Backend for Frontend (BFF)**. Las peticiones del navegador llegan primero a Nginx y después al frontend. Cuando el frontend necesita información de la API, realiza la petición desde el servidor mediante la capa .De esta forma, el navegador no necesita comunicarse directamente con la API. El frontend recibe la respuesta de la API, prepara la información necesaria para la vista y finalmente devuelve la respuesta al navegador a través de Nginx.

### BL (Business Logic)

La capa BL contiene los elementos propios de la capa de negocio, asi como un cliente http y clases relacionadas para gestionar la comunicacion del frontend con el api de forma reutilizable.

Esta capa incluye:

* Lógica organizada por dominio.
* Un cliente HTTP centralizado para realizar las llamadas a la API.
* Gestión de tokens.
* Generación de respuestas con un formato uniforme.
* Validaciones personalizadas.
* Manejo centralizado de errores.


### API

La API es el **punto de entrada del backend** y está construida con **ASP.NET Core Web API**.

Su responsabilidad es recibir las peticiones del frontend, ejecutar las operaciones correspondientes y devolver las respuestas con los datos solcitados en los casos que aplique.

La API contiene:

* **Controladores:** exponen los endpoints REST organizados por dominio.
* **Servicios:** contienen operaciones reutilizables que encapsulan la logica de  procesos de registro,consulta, eliminacion,etc junto con sus respectivas llamnadas a validaciones de neegocio(estas ultimas separadas en sus calses reséctivas), para que de esta forma los controladores tengan una sepracion clara de responsabilidades encargandose solo de los correspondiente a la gestion de pticiones http y se conserven mas limpios.
* **SignalR Hubs:** permiten actualizar información en tiempo real, como horarios y reservas.
* **Trabajos en segundo plano:** utiliza Quartz para ejecutar tareas como los recordatorios de citas.
* **Configuración de infraestructura:** incluye servicios que encapsulan logica de  autenticación mediante JWT y logica de actualizacionde datos en tiempo real.

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

La base de datos contiene tablas, procedimientos almacenados y funciones utilizados por la aplicación y todos los objetos utilizados en la bd, esta capa es solamnete para facilitar la gestion de los scripts de bd del sistemay su respaldo, no contiene proyectos .csproj ejecutables.