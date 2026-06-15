# Specification for Clases Details Endpoint

## Purpose

Define the behavior and requirements for the `GET /api/Clases/detallesDeClase` endpoint in the FitnessGym API.

## Integration Requirements (Happy Path)

### Requirement: Successful Class Retrieval

The endpoint MUST return a complete `DetalleDeClase` DTO when a valid ID is provided.

#### Scenario: Anonymous user requests class details with success

- GIVEN a class with ID `1` exists in the database with full details
- WHEN a GET request is made to `/api/Clases/detallesDeClase?idClase=1`
- THEN the response status MUST be `200 OK`
- AND the `success` field MUST be `true`
- AND the `payload` MUST contain all mapped properties (Duracion, Beneficios, etc.) matching the database.
