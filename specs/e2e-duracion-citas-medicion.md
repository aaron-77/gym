# Spec: Duración de Citas de Medición - Flujo E2E

## Scenario: Empleado registra duración de citas exitosamente

| Step | GIVEN | WHEN | THEN |
|------|-------|------|------|
| 1 | Empleado autenticado | Login con credenciales empleado | Sidebar visible |
| 2 | Empleado en dashboard | Navega a `/duracionCitasMedicionPage` | Formulario `#formGestionRutinas` visible |
| 3 | Formulario cargado | Ingresa duración=2, frecuencia=30 | Campos llenados |
| 4 | Formulario completo | Click botón "Registrar"/"Guardar" | Mensaje de éxito visible |

## UI Elements
- `input[name='duracion']` - Duración en horas
- `input[name='frecuenciaNotificaciones']` - Frecuencia en días

## Mensaje de Éxito
Contiene: "exitosamente" | "registrada" | "éxito" | "guardado"