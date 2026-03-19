# Delta for Clases - Preview Endpoint

## ADDED Requirements

### Requirement: Public Preview Endpoint for Active Classes

The system MUST provide a public endpoint that returns a preview of all active classes for unauthenticated users.

#### Scenario 1: Anonymous user requests class previews (Happy Path)

- GIVEN there are active classes in the database (FkEstadoClase = 1)
- AND each class has an associated banner image
- WHEN a GET request is made to `/api/Clases/preview` without authentication
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a list of `DTOClasePreview` objects
- AND each object MUST contain `idClase`, `urlImage`, `nombreClase`, and `descripcionCortaClase`

#### Scenario 2: Anonymous user requests previews when no active classes exist (Edge Case)

- GIVEN there are no active classes in the database
- WHEN a GET request is made to `/api/Clases/preview`
- THEN the response status MUST be `200 OK`
- AND the `payload` MUST contain an empty list

### Requirement: Rate Limiting Protection (Staging/Production Only)

The system MUST protect the preview endpoint with rate limiting ONLY when the environment is Staging or Production.

#### Scenario 3: Rate limit applies in Production environment

- GIVEN the application is running in Production environment
- AND the rate limit is set to 15 requests per minute per IP
- WHEN a client exceeds this limit from the same IP
- THEN the response status MUST be `429 Too Many Requests`

#### Scenario 4: Rate limit bypassed in Development environment

- GIVEN the application is running in Development environment
- WHEN a client makes multiple requests to `/api/Clases/preview`
- THEN all requests MUST be processed without rate limiting
- AND no `429` responses MUST be returned

### Requirement: CORS Origin Restriction

The system MUST restrict CORS to only allow requests from the configured frontend domain.

#### Scenario 5: Request from allowed origin

- GIVEN the request originates from the configured frontend domain
- WHEN a GET request is made to `/api/Clases/preview`
- THEN the response MUST include appropriate CORS headers
- AND the request MUST be processed

#### Scenario 6: Request from disallowed origin

- GIVEN the request originates from an untrusted domain
- WHEN a GET request is made to `/api/Clases/preview`
- THEN the response status MUST be `403 Forbidden`

## Technical Specifications

### Endpoint Definition

| Property | Value |
|----------|-------|
| Method | GET |
| Path | `/api/Clases/preview` |
| Authorization | None (Public) |
| Rate Limiter | `PublicPolicy` (15 req/min per IP) - **Staging/Production only** |
| CORS Policy | `originsPolicyOne` |

### Response Schema

```json
{
  "success": true,
  "httpCode": 200,
  "message": "Preview de clases obtenido correctamente",
  "errors": [],
  "payload": [
    {
      "idClase": 1,
      "urlImage": "/img/functional.jpg",
      "nombreClase": "Entrenamiento Funcional",
      "descripcionCortaClase": "Mejora tus movimientos diarios..."
    }
  ]
}
```

### Data Mapping

| Source (Entity) | Target (DTO) |
|-----------------|--------------|
| Clase.ClaseId | DTOClasePreview.idClase |
| ImagesForClase.UrlParaBanner | DTOClasePreview.urlImage |
| Clase.NombreClase | DTOClasePreview.nombreClase |
| Clase.Descripcion | DTOClasePreview.descripcionCortaClase |

### Filter Criteria

- FkEstadoClase = 1 (Activo)
- Include ImagesForClase with non-null UrlParaBanner

### Environment-Specific Behavior

| Environment | Rate Limiting | CORS |
|-------------|---------------|------|
| Development | Disabled | Enabled |
| Staging | Enabled | Enabled |
| Production | Enabled | Enabled |

## Scenario Summary

| # | Name | Type | Expected Outcome | Status |
|---|------|------|-----------------|--------|
| 1 | Anonymous user requests class previews | Happy Path | 200 OK with list of DTOClasePreview | ✅ Implemented |
| 2 | No active classes exist | Edge Case | 200 OK with empty list | ✅ Implemented |
| 3 | Rate limit exceeded in Production | Error State | 429 Too Many Requests | ✅ Implemented |
| 4 | Rate limit bypassed in Development | Edge Case | 200 OK (no rate limiting) | ✅ Implemented |
| 5 | Request from allowed origin | Happy Path | 200 OK with CORS headers | 🔲 Pending |
| 6 | Request from disallowed origin | Error State | 403 Forbidden | 🔲 Pending |
