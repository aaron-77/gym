# Especificaciones de Pruebas: Cancelar Clases Programadas

Este documento detalla los escenarios de prueba de integración para el endpoint de cancelación de clases programadas.

---

## 1. Pruebas de Integración (Happy Paths y Sad Paths)

### 1.1 POST /api/Clases/cancelarClasesProgramadas
- **Escenario (Happy Path)**: Un usuario autenticado cancela una clase programada con solicitud de reagendamiento válida.
- **Resultado esperado**: Status 200 OK, `success: true`, mensaje que contiene "cancelada exitosamente".

### 1.2 POST /api/Clases/cancelarClasesProgramadas — Sin autenticación
- **Escenario**: Se intenta cancelar sin token JWT válido.
- **Resultado esperado**: Status 401 Unauthorized.

### 1.3 POST /api/Clases/cancelarClasesProgramadas — Reagendamiento inválido
- **Escenario**: Se intenta cancelar con un reagendamiento que referencia una clase inexistente (fkClase = 99999).
- **Resultado esperado**: Status 200 OK, mensaje que contiene "Error al reagendar" o "No se pudo cancelar".

### 1.4 POST /api/Clases/cancelarClasesProgramadas — Sin reagendamiento
- **Escenario**: Se cancela una clase programada sin solicitar reagendamiento (`claseReagendada = null`).
- **Resultado esperado**: Status 200 OK, `success: true`, mensaje que contiene "Sin petición de reagendación".
