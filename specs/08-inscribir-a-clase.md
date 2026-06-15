# Especificaciones de Pruebas: Inscribir a Clase

Este documento detalla los escenarios de prueba divididos por tipo de prueba: Integración (flujos de éxito) y Unitarias (validaciones y errores).

---

## 1. Pruebas de Integración (Happy Paths y Sad Paths)

### 1.1 POST /api/Clases/inscribirAClase
- **Escenario (Happy Path)**: Un usuario autenticado inscribe un cliente a una clase programada con cupo disponible.
- **Resultado esperado**: Status 200 OK, `success: true`, y el registro de inscripción persiste en la base de datos.

### 1.2 POST /api/Clases/inscribirAClase — Sin autenticación
- **Escenario**: Se intenta inscribir sin token JWT válido.
- **Resultado esperado**: Status 401 Unauthorized.

### 1.3 POST /api/Clases/inscribirAClase — Sin cupo disponible
- **Escenario**: Se intenta inscribir a una clase programada con `cupoMaximo = 0`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, mensaje que contiene "No hay cupo disponible".

### 1.4 POST /api/Clases/inscribirAClase — Clase programada inexistente
- **Escenario**: Se intenta inscribir con un `IdProgramacionClase` que no existe (ej: 99999).
- **Resultado esperado**: Status 400 o 500, `success: false`.

### 1.5 POST /api/Clases/inscribirAClase — Cliente inexistente
- **Escenario**: Se intenta inscribir con un `IdCliente` que no existe en la base de datos.
- **Resultado esperado**: Status 400 o 500, `success: false`.

---

## 2. Pruebas Unitarias (Sad Paths / Validaciones)

### 2.1 Validación de IdProgramacionClase cero
- **Escenario**: Se envía `IdProgramacionClase = 0`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, `httpCode: 400`, mensaje que contiene "Datos inválidos".

### 2.2 Validación de IdProgramacionClase negativo
- **Escenario**: Se envía `IdProgramacionClase = -1`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, `httpCode: 400`, mensaje que contiene "Datos inválidos".

### 2.3 Validación de IdCliente vacío
- **Escenario**: Se envía `IdCliente = ""`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, `httpCode: 400`, mensaje que contiene "Datos inválidos".

### 2.4 Validación de IdCliente nulo
- **Escenario**: Se envía `IdCliente = null`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, `httpCode: 400`, mensaje que contiene "Datos inválidos".

### 2.5 Error de base de datos
- **Escenario**: El servicio de actualizaciones en tiempo real falla durante la inscripción.
- **Resultado esperado**: Status 500 Internal Server Error, `success: false`, mensaje que contiene "Error al registrar la inscripción".
