# Especificaciones de Pruebas: Eliminar Prereserva de Clase Programada

Este documento detalla los escenarios de prueba divididos por tipo de prueba: Integración (flujos de éxito) y Unitarias (validaciones y errores).

---

## 1. Pruebas de Integración (Happy Paths y Sad Paths)

### 1.1 POST /api/Clases/eliminarPrereservaDeClaseProgramada
- **Escenario (Happy Path)**: Un usuario autenticado (empleado) elimina una pre-reserva existente.
- **Resultado esperado**: Status 200 OK, `success: true`, `httpCode: 200`, mensaje que contiene "Pre-reserva eliminada correctamente", `payload > 0`, y el registro se elimina físicamente de la base de datos.

### 1.2 POST /api/Clases/eliminarPrereservaDeClaseProgramada — Sin autenticación
- **Escenario**: Se intenta eliminar sin token JWT válido.
- **Resultado esperado**: Status 401 Unauthorized.

---

## 2. Pruebas Unitarias (Sad Paths / Validaciones)

### 2.1 Validación de ID cero
- **Escenario**: Se envía `idPreReserva = 0`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, `httpCode: 400`.

### 2.2 Validación de ID negativo
- **Escenario**: Se envía `idPreReserva = -5`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, `httpCode: 400`.

### 2.3 Validación de ID inexistente
- **Escenario**: Se envía un `idPreReserva` que no existe en la base de datos.
- **Resultado esperado**: Este escenario se cubre mediante pruebas de integración (mocking de ExecuteDeleteAsync es complejo con NSubstitute).
