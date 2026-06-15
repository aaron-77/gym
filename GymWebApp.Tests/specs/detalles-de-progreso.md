# Detalles de Progreso - Flujo de Trabajo en UI

## Explicación del Flujo
Página de visualización de progreso del cliente con gráfico Chart.js. Permite filtrar datos de medidas por parámetro, ejercicio, espaciado temporal y período (meses/años) para visualizar tendencias de progreso.

## Flujo de Interacción Básico

### 1. Navegación a Detalles de Progreso
- **Desde**: Dashboard `/clientes`
- **Acción**: Click en botón `button.details-button`
- **Resultado**: Navega a `/detallesDeProgreso`
- **Verificación**: `#chartForm` visible

### 2. Formulario de Filtros (#chartForm)

| Campo | Selector | Valores Disponibles |
|-------|----------|-------------------|
| Ejercicio | `#inputEjercicio` | Lista dinámica |
| Parámetro | `#inputParametro` | Lista dinámica (peso, etc.) |
| Espaciado Temporal | `#espaciadoTemporal` | individual, rango |
| Tipo de Búsqueda | `#tipoDeBusqueda` | mes, año |
| Fecha Inicio | `#fechaInicio` | date (habilitado con rango) |
| Fecha Fin | `#fechaFin` | date (habilitado con rango) |

### 3. Checkboxes de Período

| Contenedor | Selector |
|-----------|---------|
| Meses | `.months-grid` |
| Años | `.years-grid` |

### 4. Consulta

| Elemento | Selector | Acción |
|---------|---------|--------|
| Botón Consultar | `#submitButton` | Envía formulario |

### 5. Feedback Visual

| Estado | Elemento | Condición |
|-------|---------|-----------|
| Éxito | `#errorMessageContainer` | Vacío (`display: none`) |
| Error | `#errorMessageContainer` | Texto "No encontraron medidas con esos datos" |

## Selectores Clave para Tests E2E

```csharp
// Navegar a detalles de progreso
await Page.Locator("button.details-button").First().ClickAsync();

// Verificar formulario
await Assertions.Expect(Page.Locator("#chartForm")).ToBeVisibleAsync();

// Seleccionar filtros
await Page.SelectOptionAsync("select#inputParametro", "peso");
await Page.SelectOptionAsync("select#espaciadoTemporal", "individual");
await Page.SelectOptionAsync("select#tipoDeBusqueda", "año");
await Page.CheckAsync("input#year2025");

// Consultar
await Page.ClickAsync("input#submitButton");

// Verificar gráfico visible
var errorMessage = await Page.Locator("#errorMessageContainer").InnerTextAsync();
Assert.True(string.IsNullOrWhiteSpace(errorMessage));
```

## Notas de Implementación

- Los selectores de `#inputParametro` y `#inputEjercicio` se llenan dinámicamente desde la API
- El campo `#espaciadoTemporal` está deshabilitado hasta seleccionar parámetro
- El campo `#tipoDeBusqueda` está deshabilitado hasta seleccionar espaciado
- Los campos de fecha están deshabilitados y solo se habilitan con "rango"
- El checkbox de año tiene ID dinámico: `input#year@year` (ej: `input#year2025`)