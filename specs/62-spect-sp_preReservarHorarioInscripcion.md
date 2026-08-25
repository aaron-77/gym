# Spec: sp_preReservarHorarioInscripcion - Stored Procedure

## 1. Resumen

Stored Procedure para crear pre-reservas de horarios destinadas al flujo de inscripciones y reagendaciones. Tiene la misma estructura que `sp_preReservarHorario`, pero en lugar de validar que no exista una clase programada, valida que la clase programada destino tenga cupo disponible y que el cliente no tenga una pre-reserva vigente duplicada DE INSCRIPCION.

## 2. Contexto

- **Capa:** DataAccess (SQL Server)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Función | fn_validarCupoDeClase | Valida si hay cupo disponible en la clase programada | 59 |
| Función | fn_yaExistePreReservaDeInscripcion | Valida si el cliente ya tiene una pre-reserva vigente | 61 |
| SP | sp_preReservarHorario | SP base con la misma estructura | — |
| SP | sp_RegistrarError | Registra errores en LogErrores | — |
| Tabla | preReservasDeHorario | Almacena las pre-reservas | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| FitnessCenterDB | Base de datos | Base de datos donde se ejecuta el SP |
| User-defined table type | IdsHorasLaborales | Tipo de tabla usado para validar duplicados |

## 3. sp_preReservarHorarioInscripcion a crear

### 3.1 Archivo

| Archivo | Descripción |
|---------|-------------|
| `bd/scripsOrdenadosParaMigrarBd/10procedimientos/sqlServer/sp_preReservarHorarioInscripcion.sql` | Script de creación del SP |

### 3.2 Firma

```sql
CREATE PROCEDURE [dbo].[sp_preReservarHorarioInscripcion]
    @idUsuarioQueReserva nvarchar(450),
    @fechaTentativa date,
    @idHoraLaboral int,
    @idClase int = NULL,
    @idEntrenador nvarchar(450) = NULL,
    @idClaseProgramada int,
    @idPrereservaOut int OUTPUT
```

### 3.3 Parámetros

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| @idUsuarioQueReserva | nvarchar(450) | Sí | ID del cliente que realiza la pre-reserva |
| @fechaTentativa | date | Sí | Fecha para la cual se reserva el horario |
| @idHoraLaboral | int | Sí | ID del horario laboral seleccionado |
| @idClase | int | No | ID de la clase genérica |
| @idEntrenador | nvarchar(450) | No | ID del entrenador asignado |
| @idClaseProgramada | int | Sí | ID de la clase programada destino (para validar cupo) |
| @idPrereservaOut | int OUTPUT | Sí | ID de la pre-reserva creada |

### 3.4 Acciones que debe realizar

1. Inicializar la tabla de horas laborales con el `@idHoraLaboral` recibido
2. Iniciar una transacción
3. Validar que la clase programada tenga cupo disponible usando `fn_validarCupoDeClase`
4. Si no hay cupo, hacer rollback y retornar error
5. Validar que el cliente no tenga ya una pre-reserva vigente para la misma combinación usando `fn_yaExistePreReservaDeInscripcion`
6. Si ya existe, hacer rollback y retornar error
7. Insertar la nueva pre-reserva en `preReservasDeHorario` con vigencia de 5 minutos
8. Asignar el ID generado al parámetro de salida
9. Hacer commit de la transacción
10. En caso de error, hacer rollback, registrar el error en `LogErrores` con `sp_RegistrarError`, y propagar el error

### 3.5 Validaciones

| Validación | Componente | Mensaje de error |
|------------|-----------|------------------|
| Cupo disponible | `fn_validarCupoDeClase(@idClaseProgramada)` | "No hay cupo disponible en la clase programada seleccionada" |
| Pre-reserva duplicada por cliente | `fn_yaExistePreReservaDeInscripcion(...)` | "Ya existe una pre-reserva vigente para este cliente en esa combinación (clase, fecha, hora, entrenador)" |
| Constraint unique violada | SQL Server (error 2627/2601) | "Ya existe una pre-reserva duplicada (constraint unique violada)" |

### 3.6 Manejo de errores

- Usar `BEGIN TRY / BEGIN CATCH`
- Hacer `ROLLBACK` si existe transacción activa
- Llamar a `sp_RegistrarError` con los datos del error
- Manejar errores de unique constraint (2627, 2601) con mensaje específico
- Propagar errores no controlados con `THROW`

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `bd/scripsOrdenadosParaMigrarBd/10procedimientos/sqlServer/sp_preReservarHorarioInscripcion.sql` | CREATE PROCEDURE del SP |

## 5. Criterios de aceptación

- [ ] El SP tiene el mismo patrón estructural que `sp_preReservarHorario`
- [ ] Valida cupo disponible antes de insertar
- [ ] Valida que el cliente no tenga pre-reserva vigente duplicada
- [ ] Inserta la pre-reserva con vigencia de 5 minutos
- [ ] Retorna el ID de la pre-reserva creada en `@idPrereservaOut`
- [ ] Registra errores en `LogErrores` usando `sp_RegistrarError`
- [ ] Maneja unique constraint (2627, 2601) con mensaje específico
- [ ] No valida `yaExisteClaseProgramada` (a diferencia del SP original)
