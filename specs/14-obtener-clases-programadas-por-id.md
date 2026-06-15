# Especificaciones de Pruebas: Obtener Clases Programadas por ID

Este documento detalla los escenarios de prueba divididos por tipo de prueba: Integración (flujos de éxito) y Unitarias (validaciones y errores).

---

## 1. Pruebas de Integración (Happy Paths y Sad Paths)

### 1.1 GET /api/Clases/obtenerClasesProgramadasPorId
- **Escenario (Happy Path)**: Un usuario autenticado con rol empleado solicita las clases programadas de una clase existente.
- **Resultado esperado**: Status 200 OK, `success: true`, `payload` contiene una lista con al menos un elemento, cada elemento tiene `idClaseProgramada > 0`.

### 1.2 GET /api/Clases/obtenerClasesProgramadasPorId — Sin autenticación
- **Escenario**: Un usuario anónimo intenta acceder al endpoint sin token.
- **Resultado esperado**: Status 401 Unauthorized.

### 1.3 GET /api/Clases/obtenerClasesProgramadasPorId — ID inexistente
- **Escenario**: Un usuario autenticado solicita clases programadas con un ID que no existe (ej: 99999).
- **Resultado esperado**: Status 200 OK, `success: true`, `payload` es una lista vacía.

---

## 2. Pruebas Unitarias (Sad Paths / Validaciones)

### 2.1 Validación de ID cero
- **Escenario**: Se solicita con `idClase = 0`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, `httpCode: 400`.

### 2.2 Validación de ID negativo
- **Escenario**: Se solicita con `idClase = -5`.
- **Resultado esperado**: Status 400 Bad Request, `success: false`, `httpCode: 400`.
