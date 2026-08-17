# Spec: Refactor de tests E2E del calendario a Page Models

## 1. Resumen

Se documenta el refactor de los flujos E2E de calendario para consumir los Page Models de la spec 55. La restauración de los Page Models es independiente de la migración de los tests existentes.

## 2. Contexto

- **Capa:** Pruebas E2E

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Component Object | CalendarComponent | Navegación y selección del calendario | 55 |
| Page Models | Tres modelos de páginas | Encapsulan controles y flujos | 55 |
| Tests existentes | Flujos inline de calendario | Fuente de comportamiento que debe conservarse | InscripcionesReagendarE2ETests y E2EHappyPathsTests |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| PlaywrightTestBase | Infraestructura E2E | Proporciona IPage y contenedores |
| E2ETestSettings | Configuración | Proporciona credenciales sin hardcodearlas |
| Helpers de seed existentes | Datos de prueba | Preparan los registros necesarios para cada flujo |

## 3. Tests incluidos en el refactor

### 3.1 Reagendado exitoso

El flujo de reagendado debe conservar la preparación de datos, login de empleado, navegación, selección de cliente e inscripción y activación del checkbox. El Page Model debe encargarse de la fecha y de seleccionar el horario destino mediante la operación JavaScript definida en la spec 55. El test mantiene las aserciones reales del SweetAlert de éxito.

### 3.2 Registro de clase programada

El flujo debe conservar el login, la navegación a registro de clases, la selección del día disponible, la selección de clase y entrenador, la carga del cupo, la selección del horario y el envío. El Page Model debe encapsular los controles de página y componer el componente de calendario.

### 3.3 Inscripción de cliente a clase

El flujo debe conservar el seed de clase programada, la navegación, la selección de clase y cliente, la selección del horario y el envío. Aunque el escenario actual no requiera navegación entre meses, debe consumir el Page Model para mantener una única frontera de acceso a la página y permitir evolución posterior.

## 4. Reglas del refactor

- No cambiar los escenarios ni agregar tests derivados.
- No mover seed de datos, credenciales ni aserciones de contenido real al Page Model.
- No duplicar selectores del calendario dentro de los tests.
- Mantener los nombres y comportamiento de los tests existentes.
- Mantener las esperas de transición dentro de CalendarComponent.
- Mantener el uso de evaluación JavaScript para el horario de reagendado.
- La migración puede realizarse después de recrear los archivos; esta tarea no exige modificar los tests inline.

## 5. Criterios de aceptación

- [ ] Los tres flujos documentados tienen una correspondencia directa con un Page Model.
- [ ] El comportamiento observable y las aserciones existentes se conservan.
- [ ] Los tests no contienen lógica de navegación interna del calendario.
- [ ] No se hardcodean credenciales ni se agregan escenarios.
- [ ] El refactor usa los selectores encapsulados y los waits explícitos definidos en la spec 55.
