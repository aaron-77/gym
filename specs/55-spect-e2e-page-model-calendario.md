# Spec: Component Object y Page Models del calendario E2E

## 1. Resumen

Se recrea el objeto de componente reutilizable del calendario y los Page Models de las tres páginas E2E que lo muestran. El objetivo es encapsular selectores, esperas y navegación del calendario sin modificar todavía los tests inline.

## 2. Contexto

- **Capa:** Pruebas E2E
- **Dependencia principal:** Playwright .NET y la infraestructura definida en la spec de E2E.

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Infraestructura | PlaywrightTestBase | Proporciona la página de Playwright a los tests | e2e-infraestructura.md |
| Componente visual | Calendario compartido | Widget usado por registro, inscripción y reagendado | Fuente de selectores vigente |
| Escenarios | Flujos E2E existentes | Fuente de verdad para selectores y comportamiento | e2e-tests.md |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| IPage | Playwright | Página sobre la que trabajan los objetos |
| CalendarComponent | Component Object | Abstrae el widget compartido |
| DateOnly | Tipo de fecha | API de los Page Models para fechas de negocio |

## 3. Componentes a recrear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| GymWebApp.Tests/E2E/Components/CalendarComponent.cs | Comportamiento reutilizable del calendario |
| GymWebApp.Tests/E2E/PageModels/RegistroClasesProgramadasPage.cs | Página de registro de clases programadas |
| GymWebApp.Tests/E2E/PageModels/CancelarReagendarPage.cs | Página de cancelación y reagendado |
| GymWebApp.Tests/E2E/PageModels/InscripcionAClasesPage.cs | Página de inscripción a clases |

### 3.2 Contrato del CalendarComponent

El componente recibe IPage y encapsula el calendario identificado por sus controles estables. Debe permitir esperar su renderizado, leer el mes y año visibles, navegar a una fecha, seleccionar el primer día disponible y seleccionar un horario de destino.

La espera de renderizado debe esperar el control de mes en estado Attached, con un timeout de 15 segundos. No debe depender de que el grid sea Visible.

La lectura de meses debe reconocer los doce nombres en español capitalizados sin sensibilidad a mayúsculas, y exponer mes y año con numeración de mes 1-based.

### 3.3 Navegación de fecha

1. Leer el año actualmente mostrado.
2. Si el año difiere, entrar en la vista de años.
3. Navegar con los controles anterior y siguiente hasta que esté disponible el año solicitado; en la vista de años el siguiente avanza diez años.
4. Elegir el botón de año por la clase de celda de año y su texto.
5. Elegir el mes solicitado en la vista de meses.
6. Elegir el día mediante su atributo de fecha ISO.
7. Esperar 250 milisegundos entre las transiciones y validar al final el mes y año visibles.

La navegación debe tener límites independientes para movimientos hacia adelante y hacia atrás. No se deben introducir esperas de transición en las clases de test.

### 3.4 Selección de horario de destino

La selección de horario para reagendar debe ejecutarse mediante evaluación JavaScript sobre la página, agregando la clase de selección al primer horario no ocupado que exponga un identificador de clase programada. No debe realizarse un click natural, porque ese click dispara la pre-reserva y altera el flujo confirmado.

### 3.5 Contrato de los Page Models

Cada Page Model recibe IPage, expone los controles relevantes de su página y compone una instancia de CalendarComponent cuando la página contiene el calendario. Los Page Models aceptan fechas DateOnly y realizan internamente la conversión requerida por el componente.

Los modelos deben encapsular navegación a sus rutas, selección de cliente, inscripción, clase, entrenador, fecha, horario y acciones de formulario correspondientes, sin mover lógica de negocio a los tests.

## 4. Criterios de aceptación

- [ ] Los cuatro archivos de código se pueden consumir desde tests E2E mediante IPage.
- [ ] Los selectores encapsulados coinciden con el markup y los flujos E2E vigentes.
- [ ] La espera usa el control de mes en Attached y timeout de 15 segundos.
- [ ] La navegación respeta año, modo years, meses españoles, fecha ISO y esperas de 250 milisegundos.
- [ ] La selección de horario de reagendado usa evaluación JavaScript y no click natural.
- [ ] Los Page Models componen CalendarComponent donde corresponde y mantienen una API basada en DateOnly.
