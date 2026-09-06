# Spec: Navegación del calendario en Cancelar/Reagendar Inscripción - Pruebas E2E

## 1. Resumen

Crear tres pruebas E2E de navegación sobre el componente calendario desde la vista
Cancelar/Reagendar Inscripción. Las pruebas comparten el mismo bloque común de acceso
que el escenario exitoso de reagendación (login de empleado, selección de cliente e
inscripción, habilitación del checkbox de reagendar), con la única diferencia de que
validan exclusivamente que la navegación por el calendario llegó hasta la fecha
señalada y que se seleccionó correctamente uno de sus horarios, sin ejecutar la
reagendación. La única escritura de datos es el seed de la inscripción mediante el
helper existente: la fecha de referencia proviene del helper de horarios disponibles
filtrados para garantizar que sea posterior y pertenezca al período objetivo, esa
fecha se valida con el helper que obtiene un único horario disponible, y la propio
programación de la inscripción sembrada actúa como el horario seleccionable en el
calendario. Ninguna prueba escribe datos por fuera de ese seed.

## 2. Contexto

- **Capa:** Tests E2E (GymWebApp.Tests/E2E)
- **Vista bajo prueba:** Cancelar/Reagendar Inscripción (GymFrontend)
- **Componente bajo prueba:** `CalendarComponent` (GymWebApp.Tests/E2E/Components/)
- **Page Model:** `CancelarReagendarPage` (GymWebApp.Tests/E2E/PageModels/)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Test E2E existente | `Reagendar_InscripcionValida_RetornaExito` | Bloque común de acceso (seed + login + selecciones + checkbox + espera de horarios) que estas pruebas replican hasta la selección del horario, sin ejecutar la reagendación | 47 |
| Component Object | `CalendarComponent` | Encapsula la navegación de año/mes/día del calendario y la selección de horarios del día | 56 |
| Page Model | `CancelarReagendarPage` | Navegación y controles de la vista; compone el componente de calendario | 55 |
| Helper | `HorariosHelper.ObtenerHorariosDisponiblesFiltrados` | Fuente de la fecha de referencia posterior (choke point del filtro único de horarios) | 06 / 50 |
| Helper | `HorariosHelper.ObtenerUnHorarioDisponible` | Selección del slot concreto (fecha + franja laboral) usando la fecha de referencia obtenida | 06 |
| Helper | `InscripcionTestHelper` | Seed de inscripción fresca con retorno del ID de cliente y de inscripción | 10 |
| Infraestructura | `PlaywrightTestBase` / `E2eContainerHelper` | Ciclo de vida del browser, contenedores (SQL Server + API + Frontend + Nginx), base URL y connection string | e2e-infraestructura |
| Escenario aprobado | Scenario Group: Calendar Navigation | Los tres escenarios fueron incorporados y aprobados en el catálogo de escenarios E2E | e2e-tests |

### 2.2 Dependencias de testing

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| xUnit | Framework | Framework de testing |
| Playwright .NET | E2E | Automatización del browser |
| Testcontainers | Infraestructura | BD real en Docker para el seeding |
| `E2ETestSettings` | Configuración | Credenciales del empleado desde appsettings.Testing.json (nunca hardcodeadas) |

## 3. Pruebas a implementar

| # | Prueba | Tipo | Descripción | Resultado |
|---|--------|------|-------------|-----------|
| 1 | `Calendar_NavigateSameMonthLaterDay_SelectsSchedule` | Happy Path | Tras el bloque común de acceso, navegar con los métodos del componente de calendario hasta una fecha del mismo mes pero día posterior al actual —obtenida de horarios disponibles filtrados con base en el mes en curso y validada como día con slot libre— y seleccionar la programación de la inscripción sembrada en esa fecha | Calendario visible en el mes/año destino, día destino seleccionado, programación de la inscripción marcada como seleccionada, sin modal de éxito/error y sin ejecutar la reagendación |
| 2 | `Calendar_NavigateOtherMonth_SelectsSchedule` | Happy Path | Igual que la prueba 1 pero con base el primer día del mes siguiente, obligando a cruzar al menos un límite de mes en la navegación | Calendario visible en el mes/año destino, día destino seleccionado, programación de la inscripción seleccionada, sin ejecutar la reagendación |
| 3 | `Calendar_NavigateOtherYear_SelectsSchedule` | Happy Path | Igual que la prueba 2 pero con base el primer día de enero del año siguiente, obligando a cruzar al menos un límite de año mediante el selector de años | Calendario visible en el mes/año destino, día destino seleccionado, programación de la inscripción seleccionada, sin ejecutar la reagendación |

### 3.1 Bloque común de acceso (idéntico al happy path de reagendar del spec 47)

Acciones que debe realizar cada prueba, en orden, sin repetir lógica interna de Page Model o Component. Previamente a estos pasos se ejecuta el seeding completo descripto en la sección 3.2, porque la selección de cliente e inscripción depende de sus identificadores:

1. Autenticar al empleado por la UI de login usando las credenciales de configuración de testing.
2. Navegar a la vista Cancelar/Reagendar mediante el método de navegación del Page Model.
3. Verificar que la vista renderiza su título.
4. Seleccionar en el combo de clientes el cliente devuelto por el seed.
5. Esperar la carga del combo de inscripciones y seleccionar exactamente la inscripción sembrada.
6. Marcar el checkbox de reagendar, lo que muestra el calendario y el scheduler.
7. Esperar a que el scheduler renderice al menos un horario con identificador de clase programada.

> Nota: no se manipula el reloj del browser ni la expiración del token almacenado: todas las fechas objetivo son futuras respecto del reloj real y la sesión del empleado vive sesenta minutos, muy por encima de la duración de cada prueba.

### 3.2 Estrategia de fecha de referencia (única escritura: seed de inscripción)

Acciones que debe realizar el seeding de cada escenario:

1. Definir la base del período objetivo según el escenario: el día actual para el mismo mes, el primer día del mes siguiente para otro mes, y el primer día de enero del año siguiente para otro año.
2. Llamar al helper de horarios disponibles filtrados con filtro de fecha estrictamente mayor y esa base. El stored procedure subyacente solo genera fechas del mes del parámetro recibido, por lo que el resultado queda confinado al período objetivo.
3. De ese resultado, seleccionar la fecha que cumple la condición del escenario: primera fecha posterior al día actual dentro del mismo mes (prueba 1), primera fecha del resultado (pruebas 2 y 3). Si no hay resultados, la prueba falla con mensaje explícito; nunca se recurre a fechas arbitrarias.
4. Validar la fecha elegida llamando al helper que obtiene un único horario disponible con filtro de fecha igual a esa fecha; si no devuelve slot, la prueba falla explícitamente.
5. Sembrar la inscripción mediante el helper existente pasando la fecha validada como fecha de referencia; esta es la ÚNICA escritura de la prueba y su clase programada queda sobre el período objetivo.
6. Leer por identificador de inscripción la fecha real y el identificador de la clase programada creada por el seed, para usarlos en la navegación y las aserciones (la fecha exacta puede diferir de la elegida dentro del mismo período).

> Nota de diseño: la propia programación de la inscripción es el horario destino. Esto evita insertar clases programadas adicionales: sin una programación de la clase inscrita en la fecha, el calendario deshabilita el día y el scheduler no renderiza ítems, pues ambos se construyen exclusivamente desde las clases programadas de esa clase.

### 3.3 Acciones de navegación y selección (parte diferencial)

Acciones que debe realizar cada prueba después del bloque común:

1. Utilizar el método del componente de calendario que navega a la fecha leída del seed y selecciona por identificador de clase programada: cambio de año mediante el selector de años cuando aplique, confirmación del mes, y selección del día.
2. Verificar que tras la navegación el mes y el año visibles coinciden con la fecha leída del seed.
3. No pulsar el botón de ejecutar reagendación en ningún caso: la prueba termina en la selección del horario.

> Nota: la selección usa el mecanismo de selección directa por identificador del componente (equivalente funcional usado por el test del spec 47) y no un click nativo en el horario, porque el click dispara la pre-reserva de horario y dejaría un modal bloqueante ajeno a este escenario.

## 4. Aserciones

Cada prueba verifica contenido real del DOM, no solo existencia:

- El mes y el año visibles en el calendario coinciden con el mes y el año de la fecha destino.
- El día correspondiente a la fecha destino queda con el estado de seleccionado y expone su atributo de fecha con el valor esperado.
- El horario destino queda marcado como seleccionado y expone el atributo de identificador de clase programada sembrado.
- No aparece ningún modal de éxito ni de error propio de la reagendación, dado que la acción nunca se ejecuta.

## 5. Patrones de testing

- **Herencia obligatoria:** todas las pruebas heredan de la clase base de Playwright, que garantiza contenedores inicializados y BD limpia.
- **Colección:** adhesión a la misma colección E2E de happy paths que las pruebas de reagendar, para serializar el acceso al browser y a la BD.
- **Page Model + Component Object:** los tests conservan el flujo del escenario y las aserciones; la manipulación del calendario vive en el Component Object y la de la página en el Page Model. Prohibido duplicar selectores internos en los tests.
- **Credenciales:** siempre desde la configuración de testing.
- **AAA Pattern:** Arrange (seed + acceso), Act (navegación + selección), Assert (estado del DOM).
- **Aislamiento:** ninguna prueba depende del orden de ejecución respecto de otras clases.

## 6. Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymWebApp.Tests/E2E/Features/CalendarNavigationE2ETests.cs` | Tests E2E de navegación del calendario en la vista Cancelar/Reagendar (NUEVO) |

No se modifican `CalendarComponent` ni `CancelarReagendarPage`: ambos ya exponen los métodos necesarios.

## 7. Criterios de aceptación

- [ ] 3 pruebas E2E implementadas, exactamente las de la tabla del spec, con la convención de nombres aprobada
- [ ] Las pruebas replican el bloque común de acceso del test `Reagendar_InscripcionValida_RetornaExito` (spec 47) sin duplicar lógica interna del Page Model ni del Component Object
- [ ] Ninguna prueba pulsa el botón de ejecutar reagendación ni espera modales de éxito/error de la operación
- [ ] La única escritura de datos es el seed de la inscripción vía helper existente; sin inserts manuales, sin SQL propio y sin clases programadas adicionales
- [ ] La fecha de referencia proviene siempre del helper de horarios disponibles filtrados (base = inicio del período objetivo) y se valida con el helper de obtención de un único horario disponible antes de sembrar
- [ ] La fecha e identificador usados en navegación y aserciones se leen del seed real, no de supuestos
- [ ] Aserciones sobre mes/año visible, día seleccionado (atributo de fecha), horario seleccionado (atributo de identificador) y ausencia de modales de la operación
- [ ] Sin manipulación del reloj del browser ni del token almacenado
- [ ] Credenciales tomadas de la configuración de testing, sin valores hardcodeados
- [ ] SOLO los escenarios definidos en este spec — sin tests derivados
- [ ] Catálogo `specs/e2e-tests.md` actualizado con el Scenario Group: Calendar Navigation (ya realizado)
