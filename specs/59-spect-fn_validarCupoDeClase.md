# Spec: fn_validarCupoDeClase - Función SQL

## 1. Resumen

Función SQL Scalar que valida si una clase programada tiene cupo disponible. Retorna `1` (true) si el cupo disponible es mayor a cero, o `0` (false) si el cupo es cero o menor. Se usa para filtrar clases programadas disponibles al momento de consultar horarios para reagendación de pre-reservas.

## 2. Contexto

- **Capa:** DataAccess (SQL Server)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Tabla | clasesProgramadas | Tabla con la información de cupos máximos por clase programada | — |
| Tabla | estadosInscripciones | Catálogo de estados de inscripción (activa, cancelada) | — |
| Tabla | inscripcionesDeClases | Inscripciones activas por clase programada | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| FitnessCenterDB | Base de datos | Base de datos donde se ejecuta la función |

## 3. fn_validarCupoDeClase a crear

### 3.1 Archivos

| Archivo | Descripción |
|---------|-------------|
| `bd/functions/fn_validarCupoDeClase.sql` | Script de creación de la función |

### 3.2 Contrato

```sql
CREATE FUNCTION fn_validarCupoDeClase
(
    @idClaseProgramada INT
)
RETURNS BIT
```

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| @idClaseProgramada | INT | idProgramacionClase de la clase programada a validar |

**Retorno:** `BIT` — 1 si hay cupo disponible (> 0), 0 si no hay cupo (<= 0)

### 3.3 Algoritmo

1. Buscar el `cupoMaximo` de la clase programada con `idProgramacionClase = @idClaseProgramada`
2. Contar las inscripciones activas en `inscripcionesDeClases` donde:
   - `fkProgramacionClase = @idClaseProgramada`
   - `fkEstadoInscripcion` sea distinto del estado "Cancelada"
3. Calcular: `cupoDisponible = cupoMaximo - cantidadInscritos`
4. Retornar `1` si `cupoDisponible > 0`, caso contrario retornar `0`

### 3.4 Consideraciones

- Si la clase programada no existe, retornar `0`
- Se excluyen del conteo las inscripciones con estado "Cancelada"
- El conteo de inscritos se hace "en vivo" al momento de la consulta
- No se consideran pre-reservas en el cálculo (ver sección 3.5)

### 3.5 Decisión de diseño: Pre-reservas no incluidas en el cálculo

Las pre-reservas en `preReservasDeHorario` guardan `idClase` (clase genérica), `fechaDeLaClase` y `idEntrenador`, pero no tienen vínculo directo con `clasesProgramadas`. No existe forma confiable de saber si una pre-reserva corresponde a una clase programada específica, por lo que no se incluyen en el cálculo de cupo. Esta decisión puede revisarse cuando se implemente el vínculo formal entre pre-reservas y clases programadas.

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `bd/functions/fn_validarCupoDeClase.sql` | CREATE FUNCTION con el algoritmo descrito |

## 5. Criterios de aceptación

- [ ] La función retorna `1` cuando `cupoMaximo - inscripcionesActivas > 0`
- [ ] La función retorna `0` cuando `cupoMaximo - inscripcionesActivas <= 0`
- [ ] Las inscripciones canceladas no se incluyen en el conteo
- [ ] Si la clase programada no existe, retorna `0`
- [ ] El cálculo de inscritos se hace en tiempo real (no usa cache)
