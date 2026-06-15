# Spec: Asignación de Ejercicios - Flujo E2E

## Scenario: Empleado asigna ejercicios a una rutina exitosamente

| Step | GIVEN | WHEN | THEN |
|------|-------|------|------|
| 1 | Empleado autenticado | Login con credenciales empleado | Sidebar visible |
| 2 | Empleado en dashboard | Navega a `/AsignacionEjercicios` | Formulario `#formGestionRutinas` visible |
| 3 | Formulario cargado | Selecciona cliente (`#inputCliente`) | Campo `#inputRutina` se habilita |
| 4 | inputRutina habilitado | Selecciona rutina | Campo `#inputEjercicio` se habilita |
| 5 | inputEjercicio habilitado | Selecciona ejercicio | Campos numéricos habilitados |
| 6 | Campos habilitados | Ingresa Sets=3, Repeticiones=12 | Campos llenados |
| 7 | Formulario completo | Click botón "Asignar" | Mensaje de éxito visible |

## UI Elements
- `#inputCliente` - Select de cliente
- `#inputRutina` - Select de rutina (cascada)
- `#inputEjercicio` - Select de ejercicio (cascada)
- `#inputSets` - Input numérico de sets
- `#inputRepeticiones` - Input numérico de repeticiones

## Mensaje de Éxito
Contiene: "exitosamente" | "asignado" | "éxito"