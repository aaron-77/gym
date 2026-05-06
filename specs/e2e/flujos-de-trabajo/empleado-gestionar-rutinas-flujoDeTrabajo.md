# Flujo de Trabajo: Gestionar Rutinas

## Descripción
Empleado crea y gestiona rutinas para clientes.

## Pré-conditiones
- Empleado logueado en dashboard /empleados

## Flujo de Interacción
### Paso 1: Login como empleado
- URL: /signIn
- Input: _employeeEmail, _employeePassword

### Paso 2: Navegar a gestión de rutinas
- URL: /gestionRutinas

### Paso 3: Seleccionar cliente
- Locator: #inputUsuario
- Input: Index = 1

### Paso 4: Seleccionar entrenador
- Locator: #inputEntrenador
- Input: Index = 1

### Paso 5: Completar observaciones
- Locator: #inputObservaciones
- Input: Rutina E2E Test

### Paso 6: Enviar formulario
- Locator: button.btn-primary[type='submit']

## Comportamiento Esperado (Aserciones)
- [ ] Contenido contiene "Registro exitoso"