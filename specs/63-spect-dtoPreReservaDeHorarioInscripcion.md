# Spec: DTOPreReservaDeHorarioInscripcion - Data Transfer Object

## 1. Resumen

DTO que representa los datos necesarios para crear una pre-reserva de horario asociada al flujo de inscripciones y reagendaciones. Es similar a `DTOPreReservaDeHorario`, pero incluye el `idClaseProgramada` requerido para validar el cupo disponible en la clase programada destino.

## 2. Contexto

- **Capa:** DTO

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| DTO | DTOPreReservaDeHorario | DTO base para pre-reservas generales | — |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| Proyecto DTO | Proyecto .NET | Capa compartida de Data Transfer Objects |

## 3. DTOPreReservaDeHorarioInscripcion a crear

### 3.1 Archivo

| Archivo | Descripción |
|---------|-------------|
| `DTO/Dtos/DTOPreReservaDeHorarioInscripcion.cs` | DTO para pre-reservas de inscripción/reagendación |

### 3.2 Propiedades

| Propiedad | Tipo | Requerido | Validaciones | Descripción |
|-----------|------|-----------|--------------|-------------|
| idUsuarioQueReserva | `string?` | Sí | `[Required]`, `[StringLength(36, MinimumLength = 36)]` | ID del cliente que realiza la pre-reserva |
| fechaTentativa | `DateOnly` | Sí | `[Required]`, `[DataType(DataType.Date)]`, `[FechaMinimaValida(1890)]` | Fecha para la cual se reserva el horario |
| idHoraLaboral | `int` | Sí | `[Required]`, `[Range(1, int.MaxValue)]` | ID del horario laboral seleccionado |
| idClase | `int?` | No | `[Range(1, int.MaxValue)]` | ID de la clase genérica |
| idEntrenador | `string?` | No | `[StringLength(36, MinimumLength = 36)]` | ID del entrenador asignado |
| idClaseProgramada | `int` | Sí | `[Required]`, `[Range(1, int.MaxValue)]` | ID de la clase programada destino (para validar cupo) |

### 3.3 Diferencias con DTOPreReservaDeHorario

| Aspecto | DTOPreReservaDeHorario | DTOPreReservaDeHorarioInscripcion |
|---------|------------------------|-----------------------------------|
| Flujo | Registro de clase programada | Inscripción / reagendación |
| `idClaseProgramada` | No tiene | Requerido (`int`) |
| SP asociado | `sp_preReservarHorario` | `sp_preReservarHorarioInscripcion` |

## 4. Archivos a crear

| Archivo | Descripción |
|---------|-------------|
| `DTO/Dtos/DTOPreReservaDeHorarioInscripcion.cs` | Clase DTO con las propiedades definidas |

## 5. Criterios de aceptación

- [ ] El DTO tiene las 6 propiedades definidas
- [ ] `idClaseProgramada` es requerido (`int`, no nullable)
- [ ] `idClase` e `idEntrenador` son opcionales
- [ ] Usa tipos consistentes con `DTOPreReservaDeHorario`
- [ ] Está en el namespace `DTO.Dtos`
- [ ] No contiene lógica de negocio, solo propiedades
- [ ] `idUsuarioQueReserva` tiene `[Required]` y `[StringLength(36, MinimumLength = 36)]`
- [ ] `fechaTentativa` tiene `[Required]`, `[DataType(DataType.Date)]` y `[FechaMinimaValida(1890)]`
- [ ] `idHoraLaboral` tiene `[Required]` y `[Range(1, int.MaxValue)]`
- [ ] `idClase` tiene `[Range(1, int.MaxValue)]`
- [ ] `idEntrenador` tiene `[StringLength(36, MinimumLength = 36)]`
- [ ] `idClaseProgramada` tiene `[Required]` y `[Range(1, int.MaxValue)]`
