# Spec: Modificación fn_obtenerClasesProgramadasPorIdClase - Filtrar por Cupo Disponible

## 1. Resumen

Modificación a la función SQL `fn_obtenerClasesProgramadasPorIdClase` para que solo retorne clases programadas que tengan cupo disponible. Se agrega una condición en el `WHERE` que invoca a `fn_validarCupoDeClase` y filtra las clases cuyo cupo disponible sea mayor a cero.

## 2. Contexto

- **Capa:** DataAccess (SQL Server)

### 2.1 Recursos utilizados

| Recurso | Nombre | Descripción | Spec |
|---------|--------|-------------|------|
| Función | fn_obtenerClasesProgramadasPorIdClase | Función existente a modificar | 14 |
| Función | fn_validarCupoDeClase | Función nueva que valida si hay cupo disponible | 59 |

### 2.2 Dependencias

| Dependencia | Tipo | Descripción |
|-------------|------|-------------|
| FitnessCenterDB | Base de datos | Base de datos donde se ejecuta la función |

## 3. Modificación a fn_obtenerClasesProgramadasPorIdClase

### 3.1 Archivo a modificar

| Archivo | Descripción |
|---------|-------------|
| `bd/scripsOrdenadosParaMigrarBd/9funciones/sqlServer/fn_obtenerClasesProgramadasPorIdClase.sql` | Función a modificar |

### 3.2 Cambio en el WHERE

Se modifica la condición del `WHERE` existente. La lógica anterior solo filtraba por fecha mayor o igual a la fecha de referencia. Ahora se agrega:

1. **Filtro de hora para el día actual** — Si la clase es el día de hoy, se verifica que la `horaInicio` sea mayor a la hora actual del sistema
2. **Filtro de cupo** — La clase debe tener cupo disponible mayor a cero

```sql
WHERE cp.fkClase = @idClase
    AND cp.fechaDeLaClase >= COALESCE(@fechaReferencia, CAST(GETDATE() AS DATE))
    AND (
        cp.fechaDeLaClase > CAST(GETDATE() AS DATE)
        OR (
            cp.fechaDeLaClase = CAST(GETDATE() AS DATE)
            AND hl.horaInicio > CAST(GETDATE() AS TIME)
        )
    )
    AND dbo.fn_validarCupoDeClase(cp.idProgramacionClase) = 1
```

### 3.3 Efecto del cambio

- Las clases con fecha futura entran sin filtro de hora adicional
- Las clases del día actual cuya hora de inicio ya pasó quedan excluidas
- Las clases llenas (cupoMaximo - inscripcionesActivas <= 0) quedan excluidas
- El resto de la lógica de la función permanece sin cambios

## 4. Criterios de aceptación

- [ ] La función retorna solo clases programadas con fecha y hora aún vigentes
- [ ] Las clases del día actual cuya hora de inicio ya pasó no aparecen en el resultado
- [ ] Las clases llenas (cupo = 0) no aparecen en el resultado
- [ ] La firma y contrato de la función no cambian (mismos parámetros, mismo tipo de retorno)
- [ ] El cálculo de `cupoDisponible` en el SELECT sigue funcionando y muestra el valor correcto
