# Spec: Obtener Entrenadores Disponibles

## Happy Path (Integración)
- CUANDO se consulta GET /api/obtenerEntrenadoresDisponibles con un usuario autenticado y una fecha válida
- ENTONCES el endpoint debe retornar HTTP 200
- Y el payload debe contener una lista NO vacía de entrenadores disponibles
- Y cada entrenador debe tener: UsuarioID, Nombre, Apellido, Email, Telefono, NombreUsuario, RolID, Estado