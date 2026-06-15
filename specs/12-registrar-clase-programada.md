# Especificaciones de Pruebas: Registrar Clase Programada

Este documento detalla los escenarios de prueba de integración para el endpoint de registro de clases programadas.

---

## 1. Pruebas de Integración (Happy Paths y Sad Paths)

### 1.1 POST /api/Clases/registrarClaseProgramada
- **Escenario (Happy Path)**: Un usuario autenticado (empleado) registra una nueva clase programada con datos válidos.
- **Resultado esperado**: Status 200 OK, `success: true`, `payload > 0`, mensaje que contiene "Clase programada registrada correctamente", y el registro persiste en la base de datos con el ID retornado.

### 1.2 POST /api/Clases/registrarClaseProgramada — Sin autenticación
- **Escenario**: Se intenta registrar sin token JWT válido.
- **Resultado esperado**: Status 401 Unauthorized.
