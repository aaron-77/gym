# Flujo de Trabajo: Modificar Cita

## Descripción
Empleado modifica fecha y hora de una cita existente.

## Pré-conditiones
- Empleado logueado en dashboard /empleados

## Flujo de Interacción
### Paso 1: Login como empleado
- URL: /signIn
- Input: _employeeEmail, _employeePassword

### Paso 2: Navegar a modificar cita
- URL: /modificarCita

### Paso 3: Seleccionar cliente
- Locator: #inputCliente
- Input: valor del primer option

### Paso 4: Seleccionar cita
- Locator: #inputCita
- Input: valor del primer option

### Paso 5: Modificar fecha inicio
- Locator: #inputFechaInicio
- Input: 2027-06-20T10:00

### Paso 6: Modificar fecha fin
- Locator: #inputFechaFin
- Input: 2027-06-20T11:00

### Paso 7: Enviar formulario
- Locator: button.btn-primary[type='submit']

## Comportamiento Esperado (Aserciones)
- [ ] Texto "Consulta exitosa" visible