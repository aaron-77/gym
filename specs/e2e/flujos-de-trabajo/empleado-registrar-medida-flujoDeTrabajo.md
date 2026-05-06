# Flujo de Trabajo: Registrar Medida

## Descripción
Empleado registra measurements corporales de un cliente.

## Pré-conditiones
- Empleado logueado en dashboard /empleados

## Flujo de Interacción
### Paso 1: Login como empleado
- URL: /signIn
- Input: _employeeEmail, _employeePassword

### Paso 2: Seleccionar usuario
- Locator: select[name='fkUsuario']
- Input: Index = 1

### Paso 3: Seleccionar parámetro
- Locator: select[name='fkParametro']
- Input: Index = 1

### Paso 4: Seleccionar unidad de medida
- Locator: select[name='unidadDeMedidaId']
- Input: Index = 1

### Paso 5: Ingresar valor
- Locator: input[name='valor']
- Input: 75.5

### Paso 6: Enviar formulario
- Locator: button.btn-primary[type='submit']

## Comportamiento Esperado (Aserciones)
- [ ] select[name='fkUsuario'] option[selected] contiene "selecciona un usuario"
- [ ] select[name='fkParametro'] option[selected] contiene "selecciona un parametro"
- [ ] select[name='unidadDeMedidaId'] option[selected] contiene "Selecciona una Unidad de medida"
- [ ] input[name='valor'] está vacío

### Post-Envío (SweetAlert)
- [ ] .swal2-container está visible en el DOM
- [ ] .swal2-title contiene "Éxito" o "Error"
- [ ] .swal2-confirm-button es clickeable