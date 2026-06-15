# Flujo de Trabajo: Cliente Ver Detalles de Progreso

## Descripción
Cliente logueado visualiza gráficos de progreso corporal.

## Pré-conditiones
- Cliente logueado en dashboard /clientes

## Flujo de Interacción
### Paso 1: Login como cliente
- URL: /signIn
- Input: _clientEmail, _clientPassword
- Locator: input[name='correo'], input[name='contrasena'], button.sign

### Paso 2: Click en botón de detalles
- Locator: img.details-button (Nth 0)
- Output: Navegación a detalles de progreso

### Paso 3: Seleccionar parámetros de filtro
- Locator: select#inputParametro, select#espaciadoTemporal, select#tipoDeBusqueda
- Input: peso, individual, año

### Paso 4: Seleccionar año
- Locator: input#year2025
- Output: Checkbox marcado

### Paso 5: Consultar
- Locator: input#submitButton

## Comportamiento Esperado (Aserciones)
- [ ] #chartForm visible
- [ ] #errorMessageContainer NO visible