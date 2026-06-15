# Flujo de Trabajo: Programar Clase

## Descripción
Empleado programa una clase con día, horario y capacidad.

## Pré-conditiones
- Empleado logueado en dashboard /empleados

## Flujo de Interacción
### Paso 1: Login como empleado
- URL: /signIn
- Input: _employeeEmail, _employeePassword

### Paso 2: Navegar a registro de clases
- URL: /Clases/registroClasesProgramadas

### Paso 3: Seleccionar día disponible
- Locator: .calendar-cell:not(.calendar-cell--disabled) (Nth 0)

### Paso 4: Seleccionar clase
- Locator: #inputClase
- Input: Index = 1

### Paso 5: Seleccionar entrenador
- Locator: #inputEntrenador
- Input: Index = 1

### Paso 6: Completar cupo máximo
- Locator: #inputCupoMaximo
- Input: 20

### Paso 7: Seleccionar horario disponible
- Locator: .schedule-viewer__item--disponible (Nth 0)

### Paso 8: Confirmar advertencia SweetAlert2
- Locator: .swal2-confirm.swal2-styled (texto "Aceptar")

### Paso 9: Enviar formulario
- Locator: button.btn-primary[type='submit']

## Comportamiento Esperado (Aserciones)
- [ ] div.swal2-icon-warning.swal2-showvisible (modal advertencia)
- [ ] div.swal2-popup.swal2-modal.swal2-icon-success.swal2-show visible (éxito)