# Especificaciones de Pruebas: Consultar Ejercicios

Este documento detalla los escenarios de prueba de integración para el endpoint de consulta de ejercicios.

---

## 1. Pruebas de Integración (Happy Paths y Sad Paths)

### 1.1 GET /api/consultarEjercicios
- **Escenario (Happy Path)**: Un usuario autenticado con token JWT válido solicita la lista de ejercicios.
- **Resultado esperado**: Status 200 OK, `success: true`, `payload` es una lista de `Ejercicio`, cada ejercicio tiene `EjercicioID > 0` y `NombreEjercicio` no es null ni vacío, y los ejercicios existen en la base de datos.

### 1.2 GET /api/consultarEjercicios — Sin autenticación
- **Escenario**: Un usuario no autenticado intenta acceder al endpoint sin token.
- **Resultado esperado**: Status 401 Unauthorized.
