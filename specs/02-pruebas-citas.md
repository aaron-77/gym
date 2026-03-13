# Especificaciones de Pruebas: Endpoints de Citas

Este documento detalla los escenarios de prueba divididos por tipo de prueba: Integración (flujos de éxito) y Unitarias (validaciones y errores).

---

## 1. Pruebas de Integración (Happy Paths)

Estas pruebas aseguran que la comunicación entre la API, la lógica de negocio y la base de datos funcione correctamente en escenarios de éxito.

### 1.1 POST /api/RegistrarCita
- **Escenario**: El registro se inserta correctamente con información válida.
- **Resultado esperado**: Status 200 OK, `success: true` y el registro persiste físicamente en la base de datos.

### 1.2 PUT /api/RegistrarCita
- **Escenario**: El endpoint realiza la modificación de una cita existente cuando se suministran datos correctos.
- **Resultado esperado**: Status 200 OK y los cambios se reflejan en la base de datos.

### 1.3 POST /api/registrarDuracion
- **Escenario**: El sistema registra exitosamente la duración de las citas y la frecuencia de notificaciones.
- **Resultado esperado**: Status 200 OK y persistencia de la configuración.

### 1.4 GET /api/getDuracionCita
- **Escenario**: El endpoint devuelve la duración de las citas de medición para un usuario correctamente autenticado.
- **Resultado esperado**: Status 200 OK y retorno del valor de duración configurado.

### 1.5 GET /api/getCitasAgendadas
- **Escenario**: El endpoint devuelve las citas agendadas que coinciden con el IdUsuario cuando está correctamente autenticado.
- **Resultado esperado**: Status 200 OK, `success: true` y retorno de lista de citas.

---

## 2. Pruebas Unitarias (Sad Paths / Validaciones)

Estas pruebas se centran en la lógica de validación de los DTOs y reglas de negocio, verificando que el sistema maneje correctamente los datos inválidos.

### 2.1 Validaciones de Registro (POST /api/RegistrarCita)
- **Error por body vacío**: El registro debe fallar si no se envía información.
- **Campos obligatorios faltantes**: No debe registrarse si falta:
    - `fechaInicioCita`
    - `fechaFinCita`
    - `fkCliente`
    - `fkEntrenador`
    - `tipoCita`
- **Lógica de fechas**: La fecha de inicio no puede ser mayor que la de fin, y la de fin no puede ser menor que la de inicio.

### 2.2 Validaciones de Modificación (PUT /api/RegistrarCita)
- **Fechas vacías**: No debe permitir la modificación si `fechaInicioCita` o `fechaFinCita` están vacíos.
- **Rango de fechas**: La fecha de inicio no puede ser mayor que la de finalización.
- **Campos requeridos faltantes**: Debe fallar si falta:
    - `fkEntrenador`
    - `estado`

### 2.3 Validaciones de Duración (POST /api/registrarDuracion)
- **Campos nulos o vacíos**: No debe registrar la duración si falta `duracion` o `frecuenciaNotificaciones`.

### 2.4 Validaciones de Consulta (GET /api/getDuracionCita)
- **Falta de Autenticación**: El endpoint debe devolver un error (401 Unauthorized) cuando se intenta consultar sin un token válido.

### 2.5 Validaciones de Consulta (GET /api/getCitasAgendadas)
- **Falta de Autenticación**: El endpoint debe devolver error (401 Unauthorized) cuando se intenta consultar sin un token válido.
