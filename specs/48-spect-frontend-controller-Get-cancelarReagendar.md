# Spec: Frontend - Controller GET Cancelar/Reagendar Inscripción

## 1. Resumen

Crear el controller que sirve la vista "CancelarReagendarInscripcion", obteniendo la lista de clientes
activos con rol "cliente" y pasándola a la vista para que el combo de clientes se llene en Razor.

## 2. Contexto

- **Capa:** GymFrontend Controllers

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| UI | Vista CancelarReagendar | Vista que renderiza el controller | 49 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Manager | BL | Obtener lista de clientes activos con rol "cliente" |
| `ILogger` | Logging | Logging de errores y eventos |

## 3. Controller a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/Controllers/InscripcionesController.cs` | Controller con la acción GET |

### 3.2 Ruta y método

| Método HTTP | Ruta | Descripción |
|-------------|------|-------------|
| GET | `/inscripciones/cancelarReagendar` | Servir la vista Cancelar/Reagendar |

### 3.3 Acciones que debe realizar

1. Recibir petición GET a la ruta `/inscripciones/cancelarReagendar`
2. Consultar la lista de usuarios con rol "cliente" y estado "activo" usando el manager correspondiente
3. Pasar la lista de clientes a la vista a través del modelo de la vista (tipado)
4. Retornar la vista `CancelarReagendarInscripcion`

### 3.4 Modelo de la vista

La vista recibe un modelo tipado con una lista de clientes. Cada cliente contiene al menos:
- ID del usuario (GUID)
- Nombre completo del cliente

### 3.5 Patrones a aplicar

- **MVC Pattern:** Controller consulta datos y pasa a la vista
- **Logging:** Usar ILogger con LogInformation al inicio y LogError en catch
- **Try/Catch:** Envolver la lógica principal en try/catch

## 4. Archivos a crear

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `GymFrontend/Controllers/InscripcionesController.cs` | Crear | Controller con acción GET CancelarReagendar |

## 5. Criterios de aceptación

- [ ] Controller tiene ruta GET `/inscripciones/cancelarReagendar`
- [ ] Requiere autenticación con rol "empleado"
- [ ] Consulta clientes activos con rol "cliente"
- [ ] Pasa la lista de clientes a la vista
- [ ] Retorna la vista correspondiente
- [ ] Manejo de errores con logging
