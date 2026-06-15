# Specification for Clases - Obtener Clases Endpoint

## Purpose

Define the behavior and requirements for the `GET /api/Clases/obtenerClases` endpoint in the FitnessGym API, which returns a catalog of classes (not scheduled classes).

## Integration Requirements (Happy Path)

### Requirement: Authenticated User Requests Active Classes

The endpoint MUST return a list of active classes when the user is authenticated and the `activa` parameter is `true`.

#### Scenario: Authenticated user requests active classes catalog

- GIVEN there are active classes in the database (FkEstadoClase = 1)
- AND the user is authenticated with a valid JWT token
- WHEN a GET request is made to `/api/Clases/obtenerClases?activa=true` with authentication headers
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain a list of `DTOClaseSimple` objects
- AND each object MUST have `ClaseID` and `NombreClase` populated
