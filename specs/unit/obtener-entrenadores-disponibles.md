# Spec Unitario: Obtener Entrenadores Disponibles

## Sad Path 1: Fecha vacía o nula
- CUANDO se consulta el endpoint con fechaInicio null o string vacío
- ENTONCES debe retornar HTTP 400 Bad Request
- Y el mensaje de error debe ser "La fecha tiene un formato incorrecto"

## Sad Path 2: Fecha anterior a la actual
- CUANDO se consulta el endpoint con una fecha anterior a la fecha actual
- ENTONCES debe retornar HTTP 400 Bad Request
- Y el mensaje de error debe ser "La fecha no puede ser anterior a la fecha actual"