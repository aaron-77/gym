# Flujo de Trabajo: Crear Cuenta

## Descripción
Usuario nuevo se registra en la plataforma completando el formulario de registro.

## Pré-conditiones
- Usuario accede a la página de registro /signUp

## Flujo de Interacción
### Paso 1: Navegar a página de registro
- URL: /signUp

### Paso 2: Completar campo Correo
- Locator: input[name='correo']
- Input: testuser{timestamp}@test.com

### Paso 3: Completar campo Contraseña
- Locator: input[name='contrasena']
- Input: Test1234*

### Paso 4: Completar Confirmar Contraseña
- Locator: input[name='ContrasenaConfirmacion']
- Input: Test1234*

### Paso 5: Completar Nombre
- Locator: input[name='nombre']
- Input: Test

### Paso 6: Completar Apellido
- Locator: input[name='apellido']
- Input: User

### Paso 7: Completar Fecha de Nacimiento
- Locator: input[name='fechaDeNacimiento']
- Input: 2000-01-01

### Paso 8: Completar Dirección
- Locator: input[name='direccion']
- Input: Calle Falsa 123

### Paso 9: Completar N° Identificación
- Locator: input[name='numeroDeIdentificacion']
- Input: 123456789

### Paso 10: Completar Teléfono
- Locator: input[name='telefono']
- Input: 123456789

### Paso 11: Enviar formulario
- Locator: button.sign.fix-margin-button-crear-cuenta

## Comportamiento Esperado (Aserciones)
- [ ] URL contiene "signIn" O contenido contiene "éxito" O contenido contiene "exito" O contenido contiene "success" O URL contiene "login"