# Spec: Frontend - Endpoint Reagendar Inscripción (Proxy)

## 1. Resumen

Crear un endpoint POST en el frontend que reciba la petición de reagendación desde JavaScript,
le agregue el ID del usuario desde el token JWT, reenvíe la petición al API de reagendación
y devuelva la respuesta obtenida a la UI del frontend.

## 2. Contexto

- **Capa:** GymFrontend Controllers

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| API Endpoint | `POST api/inscripciones/reagendar` | API a consumir | 43 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `IHttpClientFactory` | HTTP | Crear clientes HTTP para consumir API |
| `ILogger` | Logging | Logear errores y eventos |

## 3. Endpoint a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/Controllers/InscripcionesController.cs` | Controlador frontend (modificar existente) |

### 3.2 Ruta y método

| Método HTTP | Ruta | Descripción |
|-------------|------|-------------|
| POST | `/inscripciones/reagendar` | Proxy de reagendación a la API |

### 3.3 Request (desde JavaScript)

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| `idInscripcion` | `int` | Sí | ID de la inscripción a reagendar |
| `idClaseProgramada` | `int` | Sí | ID de la clase programada destino |
| `idCliente` | `string` | Sí | ID del cliente |

### 3.4 Autenticación

- **Requiere autenticación:** Sí (cookie JWT)
- **Obtención de ID:** Desde el claim del token de identificación del usuario

### 3.5 Acciones que debe realizar

1. Obtener ID del usuario desde el claim del token JWT (sin validar existencia ni formato)
2. Recibir `idInscripcion`, `idClaseProgramada`, `idCliente` del body de la petición POST
3. Agregar el `userId` (obtenido del token) a los datos de la petición
4. Obtener token JWT para consumir la API
5. Crear cliente HTTP con el token JWT
6. Reenviar la petición POST a `api/inscripciones/reagendar` con todos los datos
7. Devolver la misma respuesta obtenida del API (código de estado y body) a la UI del frontend

### 3.6 Patrones a aplicar

- **Proxy Pattern:** El controller frontend actúa como proxy entre JavaScript UI y la API
- **Response passthrough:** Devolver el mismo status code y body que respondió la API
- **Token reenvío:** Usar el token JWT del usuario para autenticar contra la API
- **Error Handling:** Try/catch con logging, devolver error JSON

## 4. Archivos a modificar

| Archivo | Descripción |
|---------|-------------|
| `GymFrontend/Controllers/InscripcionesController.cs` | Agregar método POST Reagendar (proxy) |

## 5. Criterios de aceptación

- [ ] Endpoint POST con ruta `/inscripciones/reagendar`
- [ ] Autenticación requerida (cookie JWT)
- [ ] ID del usuario obtenido desde el claim del token
- [ ] Se agrega userId del token a los datos de la petición
- [ ] Reenvío de petición al API con token JWT
- [ ] La respuesta del API se devuelve tal cual al frontend JavaScript
- [ ] No realiza validaciones de usuario, rol ni GUID
