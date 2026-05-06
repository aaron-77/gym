# Flujo de Trabajo: Asignar Ejercicios a Rutina

## Descripción
Empleado asigna ejercicios específicos a una rutina de cliente.

## Pré-conditiones
- Empleado logueado en dashboard /empleados

## Flujo de Interacción
### Paso 1: Login como empleado
- URL: /signIn
- Input: _employeeEmail, _employeePassword

### Paso 2: Navegar a asignación de ejercicios
- URL: /AsignarEjercicios

### Paso 3: Seleccionar cliente
- Locator: #inputCliente
- Input: Index = 1

### Paso 4: Seleccionar rutina
- Locator: #inputRutina
- Input: Index = 1

### Paso 5: Seleccionar ejercicio
- Locator: #inputEjercicio
- Input: Index = 1

### Paso 6: Completar series
- Locator: #inputSets
- Input: 3

### Paso 7: Completar repeticiones
- Locator: #inputRepeticiones
- Input: 12

### Paso 8: Enviar formulario
- Locator: button.btn-primary[type='submit']

## Comportamiento Esperado (Aserciones)
- [ ] Texto "Registro exitoso" visible