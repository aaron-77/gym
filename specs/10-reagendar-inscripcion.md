# Especificaciones de Pruebas: Reagendar Inscripción a Clase

Este documento detalla los escenarios de prueba divididos por tipo de prueba: Integración (flujos de éxito) y Unitarias (validaciones y errores).

---

## 1. Pruebas de Integración (Happy Paths y Sad Paths)

### 1.1 POST /api/Clases/reagendacionDeInscripcionAClase
- **Escenario (Happy Path)**: Un usuario autenticado reagenda una inscripción de una clase programada a otra.
- **Resultado esperado**: Status 200 OK, `success: true`, mensaje que contiene "exitosamente", la inscripción original cambia de estado, se crea una nueva inscripción con el mismo `clienteId`, y el estado de la clase programada original permanece sin cambios.

### 1.2 POST /api/Clases/reagendacionDeInscripcionAClase — Sin autenticación
- **Escenario**: Se intenta reagendar sin token JWT válido.
- **Resultado esperado**: Status 401 Unauthorized.

---

## 2. Pruebas Unitarias (Sad Paths / Validaciones)

### 2.1 Validación de idInscripcionCancelada faltante
- **Escenario**: Se envía `idInscripcionCancelada = 0`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, `httpCode: 400`, mensaje que contiene "Datos inválidos".

### 2.2 Validación de idClaseProgramadaNueva faltante
- **Escenario**: Se envía `idClaseProgramadaNueva = 0`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, `httpCode: 400`, mensaje que contiene "Datos inválidos".

### 2.3 Validación de idCliente faltante
- **Escenario**: Se envía `idCliente = ""`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, `httpCode: 400`, mensaje que contiene "Datos inválidos".

### 2.4 Datos válidos
- **Escenario**: Se envía un DTO con todos los campos válidos.
- **Resultado esperado**: El endpoint procesa la solicitud correctamente (la ejecución del stored procedure se valida en pruebas de integración).
