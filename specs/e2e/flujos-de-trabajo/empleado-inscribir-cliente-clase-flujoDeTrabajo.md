# Flujo de Trabajo: Inscribir Cliente a Clase

## Descripción
Empleado-inscribe un cliente a una clase programada.

## Pré-conditiones
- Empleado logueado en dashboard /empleados
- Clase programada existente en BD

## Flujo de Interacción
### Paso 1: Login como empleado
- URL: /signIn
- Input: _employeeEmail, _employeePassword

### Paso 2: Navegar a inscripción
- URL: /Clases/inscripcionAClases

### Paso 3: Seleccionar clase por ID
- Locator: #comboClases
- Input: claseId

### Paso 4: Seleccionar día del calendario
- Locator: .calendar-cell:not(.calendar-cell--disabled):has-text(día)
- Output: Día seleccionado

### Paso 5: Seleccionar horario
- Locator: .schedule-viewer__item (First)

### Paso 6: Seleccionar cliente
- Locator: #comboCliente
- Input: valor del primer option

### Paso 7: Click en botón Inscribir
- Locator: #botonInscribir

## Comportamiento Esperado (Aserciones)
- [ ] div.swal2-popup.swal2-modal.swal2-icon-success.swal2-show visible