# Spec: Cliente - Ver Detalles de Progreso

## Scenario: Cliente filtra y visualiza medidas en gráfico

| Step | GIVEN | WHEN | THEN |
|------|-------|------|------|
| 1 | Cliente autenticado | Login con credenciales cliente | Sidebar visible, URL `/clientes` |
| 2 | Cliente en dashboard | Click en botón de detalles | Navega a `/detallesDeProgreso`, `#chartForm` visible |
| 3 | Formulario de gráfico | Selecciona parámetro "peso" | Parámetro seleccionado |
| 4 | Parámetro seleccionado | Selecciona espaciado "individual" | Espaciado seleccionado |
| 5 | Espaciado seleccionado | Selecciona tipo "año" | Tipo seleccionado |
| 6 | Tipo seleccionado | Checkbox año 2025 | Checkbox marcado |
| 7 | Filtros configurados | Click botón "Consultar" | Gráfico se muestra (errorMessage vacío) |

## UI Elements
- `#chartForm` - Formulario del gráfico
- `select#inputParametro` - Selector de parámetro
- `select#espaciadoTemporal` - Selector de espaciado
- `select#tipoDeBusqueda` - Selector de tipo de búsqueda
- `input#year2025` - Checkbox de año
- `input#submitButton` - Botón de consulta
- `#errorMessageContainer` - Contenedor de mensajes de error