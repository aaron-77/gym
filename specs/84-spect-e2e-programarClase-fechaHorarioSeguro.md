# Spec: Tests E2E - Programar clase usando fecha con horario disponible (robustez ante días festivos)

## 1. Resumen

Modificar el test E2E `Empleado_ProgramarClase` para que, en lugar de seleccionar el primer día disponible del mes visible en el calendario, obtenga primero desde la base de datos un horario disponible con fecha posterior a la actual y use esa fecha como referencia para navegar el calendario y seleccionar el horario del schedule viewer. Esto elimina la dependencia de que la fecha actual tenga horarios disponibles, que es la causa de fallas cuando la fecha actual cae en un día festivo.

## 2. Contexto

- **Capa:** Pruebas E2E (GymWebApp.Tests)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Helper | `HorariosHelper.ObtenerUnHorarioDisponible` | Ejecuta `sp_obtenerHorariosDisponibles` y devuelve un slot aleatorio (fecha + id de hora). El SP filtra slots ocupados, pre-reservas activas y días festivos | 06 |
| Enumeración | `FiltroFecha.Mayor` | Filtro de fecha estrictamente mayor a la fecha de referencia | 50 |
| Enumeración | `FiltroHora.SinFiltro` | Sin filtro de hora: solo interesa la fecha | 50 |
| Page Model | `RegistroClasesProgramadasPage` | Página de registro de clases programadas; compone `CalendarComponent` y expone `SelectDateAsync` | 55 |
| Component | `CalendarComponent.NavigateToMonthYearAsync` | Navega el calendario al mes/año destino, selecciona el día exacto y valida la posición final | 55 |
| Helper | `E2eContainerHelper.HostConnectionString` | Cadena de conexión a la BD de pruebas desde el host | e2e-infraestructura |
| Spec escenario | Registro de Clases Programadas - Flujo E2E | Documenta el escenario actual que se corrige (paso 3) | e2e-registro-clases-programadas |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `PlaywrightTestBase` | Infraestructura E2E | Proporciona `IPage` y contenedores |
| `E2eContainerHelper` | Infraestructura E2E | Proporciona la cadena de conexión de pruebas |
| `sp_obtenerHorariosDisponibles` | Procedimiento almacenado | Fuente de verdad de disponibilidad: filtra festivos, slots ocupados y pre-reservas |
| Respawn | Limpieza de BD | Ignora las tablas de horarios, clases, clases programadas y festivos, por lo que el backup persiste entre tests |

## 3. Cambios a realizar

### 3.1 Archivos

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymWebApp.Tests/E2E/Features/E2EHappyPathsTests.cs` | Modificar | Test `Empleado_ProgramarClase`: obtener fecha segura desde la BD y navegar el calendario a esa fecha |

### 3.2 Comportamiento actual (problema)

1. El test selecciona el primer día no deshabilitado del calendario (`.calendar-cell:not(.calendar-cell--disabled)`), lo que equivale a la fecha actual cuando esta no es festiva, o al primer día hábil del mes visible.
2. Si la fecha actual es un día festivo, ese día está deshabilitado o el schedule viewer no renderiza horarios disponibles para él, y el test falla.
3. El test depende de datos implícitos del backup de la BD en lugar de consultar la disponibilidad real.

### 3.3 Comportamiento deseado

1. Tras el login, consultar desde la BD un horario disponible con fecha estrictamente mayor a la actual.
2. Usar esa fecha como referencia para navegar el calendario hasta ese día puntual (incluso cruzando meses o años).
3. El horario seleccionado en el schedule viewer pertenece a esa fecha garantizada por construcción.

### 3.4 Acciones que debe realizar

Lista de pasos que el test debe ejecutar, sin código:

1. Obtener la cadena de conexión de pruebas desde el helper de contenedores E2E.
2. Consultar un único horario disponible con filtro de fecha "mayor" a la actual y filtro de hora "sin filtro".
3. Validar que la consulta devuelva un resultado; si no lo hace, abortar con un mensaje descriptivo que indique que no hay horarios futuros disponibles (guard explícito).
4. Realizar el login de empleado con las credenciales del archivo de configuración de pruebas.
5. Navegar a la página de registro de clases programadas y esperar a que el calendario esté renderizado.
6. Navegar el calendario al mes y año de la fecha obtenida en el paso 2 y seleccionar el día exacto, usando el Page Model existente.
7. Esperar a que el schedule viewer renderice los horarios del día seleccionado.
8. Seleccionar el primer horario disponible del schedule viewer.
9. Aceptar el modal de confirmación de pre-reserva.
10. Llenar el formulario (clase, entrenador y cupo máximo) como hasta ahora.
11. Enviar el formulario y verificar el mensaje de éxito.
12. Mantener sin cambios las aserciones finales del test.

### 3.5 Patrones a aplicar

- **Fecha segura por construcción:** la fecha proviene de `sp_obtenerHorariosDisponibles`, que filtra festivos y slots ocupados; no se asume disponibilidad sobre el calendario.
- **Seed por disponibilidad:** mismo patrón que los tests hermanos que consultan disponibilidad antes de interactuar; la consulta con filtro de fecha "mayor" garantiza días futuros no festivos.
- **Component Object:** la navegación de calendario se delega a `CalendarComponent` a través del Page Model, sin duplicar selectores de calendario en el test.
- **Guard explícito:** si no hay horarios futuros disponibles, fallar con mensaje descriptivo en lugar de un timeout opaco sobre la UI.

### 3.6 Consideraciones

- No se modifican el resto del flujo del test: selección de clase, entrenador, cupo, modal de confirmación y aserciones de éxito se conservan.
- El schedule viewer renderiza únicamente los horarios del día seleccionado; al navegar a la fecha garantizada, el primer horario "disponible" pertenece a esa fecha por construcción.
- No es necesario sembrar clases programadas: el seed del backup persiste entre tests (Respawn ignora las tablas de horarios, clases y festivos) y el procedimiento almacenado garantiza la disponibilidad.
- No se manipula el reloj del browser ni el token de sesión.
- Se agregan a la clase de prueba las referencias necesarias a la enumeración de filtros y al helper de horarios.
- El spec de escenario `e2e-registro-clases-programadas` documenta el paso 3 con el comportamiento antiguo; al archivar este cambio debe actualizarse esa referencia.

## 4. Archivos a modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymWebApp.Tests/E2E/Features/E2EHappyPathsTests.cs` | Modificar | Test `Empleado_ProgramarClase`: consultar fecha segura y navegar el calendario a esa fecha |

## 5. Criterios de aceptación

- [ ] El test obtiene un horario disponible con fecha posterior a la actual desde la BD antes de interactuar con el calendario
- [ ] El calendario navega al mes y año de la fecha obtenida y selecciona el día exacto
- [ ] El horario seleccionado en el schedule viewer pertenece a la fecha obtenida
- [ ] El test pasa cuando la fecha actual es un día festivo (no depende de hoy)
- [ ] El flujo de formulario y las aserciones de éxito se conservan sin cambios
- [ ] No se agregan tests derivados ni se modifica la infraestructura E2E
- [ ] Si no hay horarios futuros disponibles, el test falla con un mensaje descriptivo