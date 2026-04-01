# Especificaciones de Pruebas: Niveles de Dificultad

Este documento detalla los escenarios de prueba de integración para el endpoint de niveles de dificultad.

---

## 1. Pruebas de Integración (Happy Paths y Sad Paths)

### 1.1 GET /api/Clases/nivelesDeDificultad
- **Escenario (Happy Path)**: Un usuario autenticado con token JWT válido solicita el catálogo de niveles de dificultad.
- **Resultado esperado**: Status 200 OK, `success: true`, `payload` contiene al menos 3 niveles (principiante, intermedio, avanzado), cada nivel tiene `Id > 0` y `Nombre` no es null ni vacío.

### 1.2 GET /api/Clases/nivelesDeDificultad — Sin autenticación
- **Escenario**: Se envía un request sin token JWT.
- **Resultado esperado**: Status 401 Unauthorized.

### 1.3 GET /api/Clases/nivelesDeDificultad — Token inválido
- **Escenario**: Se envía un request con un token JWT inválido (ej: "invalid-token-xyz").
- **Resultado esperado**: Status 401 Unauthorized.

### 1.4 GET /api/Clases/nivelesDeDificultad — Estructura de respuesta
- **Escenario**: Un usuario autenticado verifica la estructura de la respuesta.
- **Resultado esperado**: Status 200 OK, `httpCode: 200` en la respuesta, `message` no es null ni vacío, cada elemento del payload tiene `Id > 0` y `Nombre` no es null ni vacío.
