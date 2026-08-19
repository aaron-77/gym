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

| Propiedad | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| idUsuarioQueReserva | `string?` | Sí | ID del cliente que realiza la pre-reserva |
| fechaTentativa | `DateOnly` | Sí | Fecha para la cual se reserva el horario |
| idHoraLaboral | `int` | Sí | ID del horario laboral seleccionado |
| idClase | `int?` | No | ID de la clase genérica |
| idEntrenador | `string?` | No | ID del entrenador asignado |
| idClaseProgramada | `int` | Sí | ID de la clase programada destino (para validar cupo) |

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
