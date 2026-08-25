# Spec: fn_yaExistePreReservaDeInscripcion - Función SQL

## 1. Resumen

Función SQL scalar que valida si ya existe una pre-reserva vigente para una inscripción o reagendación. A diferencia de `yaExistePreRegistroDeClase`, esta función incluye al cliente en la validación de duplicados, evitando que un mismo cliente genere múltiples pre-reservas para la misma clase, fecha, hora e instructor.

## 2. Contexto

- **Capa:** DataAccess (SQL Server)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Función | yaExistePreRegistroDeClase | Función base que valida pre-reservas por clase, fecha, hora e instructor | — |
| Tabla | preReservasDeHorario | Almacena las pre-reservas de horarios | — |
| Table Type | IdsHorasLaborales | Tipo de tabla para recibir múltiples IDs de horas laborales | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| FitnessCenterDB | Base de datos | Base de datos donde se ejecuta la función |
| User-defined table type | IdsHorasLaborales | Tipo de tabla requerido como parámetro |

## 3. fn_yaExistePreReservaDeInscripcion a crear

### 3.1 Archivo

| Archivo | Descripción |
|---------|-------------|
| `bd/scripsOrdenadosParaMigrarBd/9funciones/sqlServer/fn_yaExistePreReservaDeInscripcion.sql` | Script de creación de la función |

### 3.2 Contrato

```sql
CREATE FUNCTION dbo.fn_yaExistePreReservaDeInscripcion
(
    @idClase INT,
    @idEntrenador NVARCHAR(450),
    @fechaReservada DATE,
    @idCliente NVARCHAR(450),
    @fksHorasLaborales IdsHorasLaborales READONLY
)
RETURNS BIT
```

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| @idClase | INT | ID de la clase genérica (tabla Clases). Puede ser NULL |
| @idEntrenador | NVARCHAR(450) | ID del entrenador. Puede ser NULL |
| @fechaReservada | DATE | Fecha de la clase reservada |
| @idCliente | NVARCHAR(450) | ID del usuario cliente que realiza la pre-reserva |
| @fksHorasLaborales | IdsHorasLaborales READONLY | Tabla con los IDs de horas laborales a validar |

**Retorno:** `BIT` — 1 si existe una pre-reserva vigente para esa combinación, 0 si no existe

### 3.3 Algoritmo

1. Buscar en `preReservasDeHorario` una fila que coincida con:
   - `fechaDeLaClase = @fechaReservada`
   - `fkHoraLaboral` esté dentro de `@fksHorasLaborales`
   - `idClase = @idClase` (si `@idClase` no es NULL)
   - `idEntrenador = @idEntrenador` (si `@idEntrenador` no es NULL)
   - `idUsuarioQueReserva = @idCliente` (si `@idCliente` no es NULL)
   - La pre-reserva esté vigente: `GETDATE()` entre `fechaInicioDeLaReserva` y `fechaDeExpiracionDeLaReserva`
2. Si existe al menos una fila, retornar 1
3. Si no existe, retornar 0

### 3.4 Diferencias con yaExistePreRegistroDeClase

| Aspecto | yaExistePreRegistroDeClase | fn_yaExistePreReservaDeInscripcion |
|---------|------------------------------|--------------------------------------|
| Tipo | Función scalar | Función scalar |
| Valida duplicado por | clase + fecha + hora + entrenador | **cliente** + clase + fecha + hora + entrenador |
| Incluye caducidad | Sí | Sí |
| Uso | `IF dbo.yaExistePreRegistroDeClase(...) = 1` | `IF dbo.fn_yaExistePreReservaDeInscripcion(...) = 1` |

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `bd/scripsOrdenadosParaMigrarBd/9funciones/sqlServer/fn_yaExistePreReservaDeInscripcion.sql` | CREATE FUNCTION con el algoritmo descrito |

## 5. Criterios de aceptación

- [ ] La función retorna 1 cuando existe una pre-reserva vigente para el mismo cliente, clase, fecha, hora e instructor
- [ ] La función retorna 0 cuando no existe coincidencia
- [ ] La función retorna 0 cuando la pre-reserva existe pero ya caducó
- [ ] Los parámetros NULL se manejan como comodines (no filtran por ese campo)
- [ ] La validación de vigencia usa `GETDATE() BETWEEN fechaInicioDeLaReserva AND fechaDeExpiracionDeLaReserva`
