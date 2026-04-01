# Especificaciones de Pruebas: Registrar Clase

Este documento detalla los escenarios de prueba de integración para el endpoint de registro de clases.

---

## 1. Pruebas de Integración (Happy Paths y Sad Paths)

### 1.1 POST /api/Clases/registrarClase
- **Escenario (Happy Path)**: Un usuario autenticado con rol empleado registra una nueva clase con datos válidos.
- **Resultado esperado**: Status 200 OK, `success: true`, `payload > 0`, mensaje "Clase registrada correctamente", y el registro persiste en la base de datos con todos los campos correctos (NombreClase, Descripcion, duracionEnMinutos, fkIntensidad, fkDificultad, tiempoDeDescansoEnMinutos, Cupo, fkEstadoClase).

### 1.2 POST /api/Clases/registrarClase — Sin autenticación
- **Escenario**: Se intenta registrar sin token JWT válido.
- **Resultado esperado**: Status 401 Unauthorized.

### 1.3 POST /api/Clases/registrarClase — Nombre duplicado
- **Escenario**: Se intenta registrar una clase con un `NombreClase` que ya existe en la base de datos.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, mensaje que contiene "Ya existe una clase con ese nombre", y `errors` contiene un error para la propiedad `nombreClase`.
