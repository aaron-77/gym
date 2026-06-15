# Flujo de Trabajo: Registrar Cita

## Descripción
Empleado agenda una cita de medición para un cliente.

## Pré-conditiones
- Empleado logueado en dashboard /empleados

## Flujo de Interacción
### Paso 1: Login como empleado
- URL: /signIn
- Input: _employeeEmail, _employeePassword

### Paso 2: Navegar a registrar cita
- URL: /registrarCita

### Paso 3: Seleccionar tipo de cita
- Locator: #inputTipoCita
- Input: Medicion

### Paso 4: Completar fecha inicio
- Locator: #inputFechaInicio
- Input: 2027-06-15T14:00

### Paso 5: Completar fecha fin
- Locator: #inputFechaFin
- Input: 2027-06-15T15:00

### Paso 6: Seleccionar cliente
- Locator: #inputCliente
- Input: Index = 1

### Paso 7: Seleccionar entrenador
- Locator: #inputEntrenador
- Input: Index = 1

### Paso 8: Enviar formulario
- Locator: button.btn-primary.fix-margin

## Comportamiento Esperado (Aserciones)
- [ ] Contenido contiene "Registro exitoso"