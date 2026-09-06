# Spec 75: Función SQL `fn_yaEstaInscritoElCliente` + Guard Clause en Endpoint de Inscripción

## 1. Resumen

Crear una función SQL scalar `fn_yaEstaInscritoElCliente` que detecte si un cliente ya tiene una inscripción vigente para una combinación específica de clase programada, hora y fecha. Esta función se invocará como guard clause en el endpoint `POST /api/clases/inscribirAClase` después de la validación de cupo disponible, retornando 409 Conflict si el cliente ya está inscrito.

## 2. Contexto

- **Capa:** Base de datos (SQL Server) + API Controller

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Tabla | `inscripcionesDeClases` | Inscripciones de clientes a clases | — |
| Tabla | `clasesProgramadas` | Clases programadas con fecha y horario | — |
| Tabla | `horariosDeClasesProgramadas` | Relación entre clase programada y hora laboral | — |
| Tabla | `horasLaborales` | Horas laborales con hora inicio/fin | — |
| Tabla | `estadosInscripciones` | Estados de inscripción (vigente/cancelado) | — |
| Endpoint | `POST /api/clases/inscribirAClase` | Endpoint de inscripción | — |
| DTO | `DTOInscripcionAClase` | Modelo de request para inscripción | — |
| Spec | spect-skeleton | Plantilla de spec | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| `FitnessCenterDbContext` | DataAccess/EF | DbContext existente del proyecto |
| `sp_registrarInsrcipcionAClase` | Stored Procedure | SP que ejecuta la inscripción (ya existente) |

---

## 3. Función SQL `fn_yaEstaInscritoElCliente` a crear

### 3.1 Contrato

```sql
CREATE FUNCTION dbo.fn_yaEstaInscritoElCliente
(
    @idCliente     NVARCHAR(450),
    @idHora        INT,
    @fechaDeClase  DATE
)
RETURNS BIT
```

**Parámetros:**

| Parámetro | Tipo SQL | Descripción |
|-----------|----------|-------------|
| `@idCliente` | `NVARCHAR(450)` | ID del cliente (AspNetUsers) |
| `@idHora` | `INT` | ID de la hora laboral (`horasLaborales.idHora`) |
| `@fechaDeClase` | `DATE` | Fecha de la clase (`clasesProgramadas.fechaDeLaClase`) |

**Retorno:** `BIT` — 1 si el cliente ya tiene una inscripción vigente para esa combinación, 0 en caso contrario.

**Comportamiento:** Retorna 1 si existe al menos una inscripción del cliente donde:
- El estado de la inscripción sea "vigente" (no cancelado)
- La clase programada coincida en `fechaDeLaClase`
- La relación `horariosDeClasesProgramadas` apunte al `idHora` proporcionado

### 3.2 Flujo de validación

| Paso | Validación | Descripción |
|------|-----------|-------------|
| 1 | JOIN a `clasesProgramadas` | Via `fkProgramacionClase` → фильтрация по `fechaDeLaClase` |
| 2 | JOIN a `horariosDeClasesProgramadas` | фильтрация по `fkHorarioLaboral = @idHora` |
| 3 | фильтрация por estado de inscripción | Solo inscripciones "vigentes" |
| 4 | Retornar | `1` si existe coincidencia, `0` si no |

### 3.3 Acciones que debe realizar

1. Recibir los tres parámetros: `@idCliente`, `@idHora`, `@fechaDeClase`
2. Realizar un JOIN desde `inscripcionesDeClases` hacia `clasesProgramadas` usando `fkProgramacionClase`
3. De la clase programada resultante, filtrar por `fechaDeLaClase = @fechaDeClase`
4. JOIN hacia `horariosDeClasesProgramadas` usando `idProgramacionClase`
5. Filtrar donde `fkHorarioLaboral = @idHora`
6. JOIN hacia `estadosInscripciones` para verificar que el estado sea "vigente"
7. Retornar `1` si existe al menos un registro, `0` en caso contrario

### 3.4 Query SQL de referencia

```sql
CREATE FUNCTION dbo.fn_yaEstaInscritoElCliente
(
    @idCliente    NVARCHAR(450),
    @idHora       INT,
    @fechaDeClase DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @resultado BIT = 0;

    SELECT @resultado = 1
    FROM dbo.inscripcionesDeClases i
    INNER JOIN dbo.clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
    INNER JOIN dbo.horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
    INNER JOIN dbo.estadosInscripciones ei ON i.fkEstadoInscripcion = ei.idEstadoInscripcion
    WHERE i.fkCliente = @idCliente
      AND hcp.fkHorarioLaboral = @idHora
      AND cp.fechaDeLaClase = @fechaDeClase
      AND ei.nombreEstadoInscripcion = 'Vigente';  -- Ajustar según el valor real en BD

    RETURN @resultado;
END
```

> **Nota:** El valor del estado "vigente" debe verificarse en la tabla `estadosInscripciones`. Comúnmente será `'Vigente'`, `'Activa'` o similar. Ajustar el WHERE según el valor real.

### 3.5 Patrones a aplicar

- **Scalar Function:** Función SQL que retorna un valor único `BIT`
- **JOIN multinivel:** Un solo JOIN chain que atraviesa 4 tablas
- **Estado como filtro:** Filtrar por estado de inscripción para excluir canceladas

---

## 4. Guard Clause en Endpoint `POST /api/clases/inscribirAClase`

### 4.1 Ubicación en el flujo

```
[HTTP POST /api/clases/inscribirAClase]
         │
         ▼
[1. Validar ModelState]
         │
         ▼
[2. Validar cupo disponible ← YA EXISTE]
         │
         ▼
[3. fn_yaEstaInscritoElCliente ← NUEVO GUARD CLAUSE]
         │
    ┌────┴────┐
    │ ¿yaInscrito? │
    ├ YES → 409 Conflict
    │ NO  → continuar
    ▼
[4. sp_registrarInsrcipcionAClase ← YA EXISTE]
         │
         ▼
[5. Notificar cupos actualizados ← YA EXISTE]
         │
         ▼
[200 OK]
```

### 4.2 Acciones que debe realizar

1. Extraer `idCliente` y `idProgramacionClase` del `DTOInscripcionAClase`
2. Obtener la fecha de clase y el id de hora de la clase programada relacionada (a través de la navegación EF o query directa)
3. Invocar `fn_yaEstaInscritoElCliente` con los tres parámetros
4. Si retorna `1`: retornar `409 Conflict` con mensaje "El cliente ya está inscrito en esta clase"
5. Si retorna `0`: continuar con el flujo existente

### 4.3 Invocación de la función SQL

Usar el mismo patrón que `fn_cupoDisponibleClaseProgramada` (stored procedure con `DatabaseParameter`):

```csharp
// Obtener fechaDeClase e idHora de la clase programada
// ...

var yaInscritoResult = await DataAccess.Infraestructure.DatabaseExecutor.ExecuteStoredProcedureAsync(
    _context.Database.GetDbConnection(),
    "dbo.fn_yaEstaInscritoElCliente",
    new Dictionary<string, object>
    {
        { "idCliente", new DatabaseParameter(modelo.IdCliente, ParameterDirection.Input, DbType.String) },
        { "idHora", new DatabaseParameter(idHora, ParameterDirection.Input, DbType.Int32) },
        { "fechaDeClase", new DatabaseParameter(fechaDeClase, ParameterDirection.Input, DbType.Date) },
        { "resultado", new DatabaseParameter(null, ParameterDirection.ReturnValue, DbType.Boolean) }
    }
);

var yaInscrito = (bool)yaInscritoResult.OutputParameters["resultado"];
if (yaInscrito)
{
    return Conflict(
        ResponseManager.BuildResponse<int>(
            false,
            409,
            "El cliente ya está inscrito en esta clase",
            new List<ErrorModel>
            {
                new ErrorModel { propiedad = "IdCliente", message = "El cliente ya tiene una inscripción vigente para esta clase, hora y fecha." }
            },
            0
        )
    );
}
```

### 4.4 Patrones a aplicar

- **Guard Clause:** Early return cuando la condición de negocio no se cumple
- **409 Conflict:** HTTP status code apropiado para "recurso ya existe"
- **Mismo patrón de invocación:** Usar `ExecuteStoredProcedureAsync` con `DatabaseParameter` como en la validación de cupo

---

## 5. Archivos a crear / modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `bd/esquemaBdsDeReferenciaParaIa/FitnessGymSchemaActual.sql` | Modificar | Agregar `CREATE FUNCTION fn_yaEstaInscritoElCliente` |
| `API/Controllers/ClasesController.cs` | Modificar | Agregar guard clause post-cupo en `InscribirAClase` |

---

## 6. Criterios de aceptación

- [ ] La función `fn_yaEstaInscritoElCliente` compila y se crea en la base de datos
- [ ] La función retorna `1` cuando existe una inscripción vigente con la misma combinación de cliente, hora y fecha
- [ ] La función retorna `0` cuando no existe inscripción vigente con esa combinación
- [ ] La función no cuenta inscripciones canceladas (filtra por estado "Vigente")
- [ ] El endpoint `POST /api/clases/inscribirAClase` retorna `409 Conflict` cuando `fn_yaEstaInscritoElCliente` retorna `1`
- [ ] El endpoint retorna `409 Conflict` antes de llamar al stored procedure de inscripción
- [ ] El mensaje de error indica claramente que el cliente ya está inscrito
- [ ] El flujo normal de inscripción (cuando no está inscrito) no se ve afectado
