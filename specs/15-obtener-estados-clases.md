# Especificaciones de Pruebas: Obtener Estados de Clases Programadas

Este documento detalla los escenarios de prueba de integración para el endpoint de estados de clases programadas.

---

## 1. Pruebas de Integración (Happy Paths y Sad Paths)

### 1.1 GET /api/Clases/obtenerEstadosDeClasesProgramdas
- **Escenario (Happy Path)**: Un usuario autenticado con rol empleado obtiene los estados de clases programadas.
- **Resultado esperado**: Status 200 OK, `success: true`, mensaje que contiene "Estados de clases programadas obtenidos correctamente", `payload` es una lista no vacía de `DTOEstadoClaseProgramada`, cada estado tiene `IdEstadoClaseProgramada > 0` y `NombresEstado` no es null ni vacío.

### 1.2 GET /api/Clases/obtenerEstadosDeClasesProgramdas — Sin autenticación
- **Escenario**: Un usuario no autenticado intenta acceder al endpoint.
- **Resultado esperado**: Status 401 Unauthorized.
