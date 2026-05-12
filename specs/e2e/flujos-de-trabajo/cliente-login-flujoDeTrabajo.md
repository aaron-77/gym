# Flujo de Trabajo: Cliente Login

## Descripción
Cliente accede a su dashboard con credenciales válidas.

## Pré-conditiones
- Cliente registrado en el sistema

## Flujo de Interacción
### Paso 1: Navegar a página de login
- URL: /signIn
- Locator: input[name='correo'], input[name='contrasena'], button.sign

### Paso 2: Ingresar credenciales de cliente
- Input: _clientEmail, _clientPassword

### Paso 3: Enviar formulario
- Locator: button.sign

## Comportamiento Esperado (Aserciones)
- [ ] #sidebar visible
- [ ] URL contiene "clientes"