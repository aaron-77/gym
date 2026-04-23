# Spec: Registro de Clases Programadas - Flujo E2E

## Scenario: Empleado programa una clase exitosamente

| Step | GIVEN | WHEN | THEN |
|------|-------|------|------|
| 1 | Empleado autenticado en `/signIn` | Ingresa credenciales y hace login | Sidebar visible, URL contiene `empleados` |
| 2 | Empleado en dashboard | Navega a `/registroClasesProgramadas` | Calendario `#calendarGrid` visible |
| 3 | Calendario cargado | Selecciona primer día disponible (`.calendar-cell:not(.calendar-cell--disabled)`) | ScheduleViewer renderiza horarios (`.schedule-viewer__item` visible) |
| 4 | Formulario cargado | Selecciona clase, entrenador, ingresa cupo máximo | Campos llenados correctamente |
| 5 | Horarios visibles | Selecciona horario disponible (`.schedule-viewer__item--disponible`) | Horario seleccionado |
| 6 | Formulario completo | Click en botón "Registrar" | Mensaje de éxito visible (`text=/exitosamente|registrada/i`) |

## UI Elements Referenced

- `#calendarGrid` - Grid del calendario
- `.calendar-cell` - Celdas de días
- `.calendar-cell--disabled` - Celdas deshabilitadas
- `.schedule-viewer__item` - Elementos de horarios
- `.schedule-viewer__item--disponible` - Horarios disponibles
- `#inputClase` - Select de clase
- `#inputEntrenador` - Select de entrenador
- `#inputCupoMaximo` - Input numérico de cupo

## Message de Éxito Esperado

El mensaje se renderiza en `agendarioDeHorarios.js` línea 577:
- Texto contiene: "exitosamente" o "registrada" o "éxito"