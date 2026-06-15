# Flujo de Trabajo: Gestionar Duración de Citas

## Descripción
Empleado configura duración de citas y frecuencia de notificaciones.

## Pré-conditiones
- Empleado logueado en dashboard /empleados

## Flujo de Interacción
### Paso 1: Login como empleado
- URL: /signIn
- Input: _employeeEmail, _employeePassword

### Paso 2: Navegar a duración de citas
- URL: /duracionCitasMedicionPage

### Paso 3: Completar duración
- Locator: input[name='duracion']
- Input: 2

### Paso 4: Completar frecuencia
- Locator: input[name='frecuenciaNotificaciones']
- Input: 30

### Paso 5: Enviar formulario
- Locator: button.btn-primary[type='submit']

## Comportamiento Esperado (Aserciones)
- [ ] Texto "Registro exitoso" visible