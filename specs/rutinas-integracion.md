# Spec: Tests de Integración para Endpoints de Rutinas

## Tests (7)

### Happy Path
1. **RegistrarRutina_WithValidData_ReturnsOk**
   - Descripción: Un empleado autenticado registra una rutina con datos válidos
   - Expected: Status 200 OK, response con datos de la rutina creada

2. **AsignarEjercicio_WithValidData_ReturnsOk**
   - Descripción: Un empleado autenticado asigna un ejercicio a una rutina con datos válidos
   - Expected: Status 200 OK, response con datos de la asignación

3. **ConsultarRutinas_WithEmpleadoAuth_ReturnsOk**
   - Descripción: Un empleado autenticado consulta las rutinas de un usuario
   - Expected: Status 200 OK, lista de rutinas

### Sad Path
4. **ConsultarRutinas_WithClienteAuth_ReturnsForbidden**
   - Descripción: Un cliente autenticado intenta consultar rutinas
   - Expected: Status 403 Forbidden (el endpoint solo permite rol "empleado")

5. **RegistrarRutina_WithoutAuthentication_ReturnsUnauthorized**
   - Descripción: Intento de registrar rutina sin token JWT válido
   - Expected: Status 401 Unauthorized

6. **AsignarEjercicio_WithoutAuthentication_ReturnsUnauthorized**
   - Descripción: Intento de asignar ejercicio sin token JWT válido
   - Expected: Status 401 Unauthorized

7. **ConsultarRutinas_WithoutAuthentication_ReturnsUnauthorized**
   - Descripción: Intento de consultar rutinas sin token JWT válido
   - Expected: Status 401 Unauthorized