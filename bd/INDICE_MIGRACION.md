# ?? ÍNDICE DE SCRIPTS DE MIGRACIÓN

**Proyecto:** GymWebApp Linux - FitnessCenterDB  
**Fecha de Creación:** 2025-12-04  
**Estado:** ? Completo y listo para usar

---

## ?? ¿POR DÓNDE EMPIEZO?

### Opción A: Ejecutar TODO automáticamente (RECOMENDADO)
?? **Archivo:** `00_MAESTRO_MIGRACION_Ejecutar_Primero.sql`

Este script ejecuta todos los pasos en orden:
1. Modifica tabla `preReservasDeHorario`
2. Actualiza 5 funciones
3. Actualiza 7 procedimientos
4. Valida los cambios

**Tiempo estimado:** ~5 minutos

---

### Opción B: Ejecutar paso a paso (EDUCATIVO)

Si prefieres ver qué hace cada paso:

| # | Script | Función | Tiempo |
|---|--------|---------|--------|
| 1 | `01_ALTER_preReservasDeHorario_AddColumns.sql` | Agrega columnas e índices | 2 min |
| 2 | `02_UPDATE_Funciones_Migration.sql` | Actualiza funciones | 1 min |
| 3 | `03_UPDATE_Procedimientos_Migration_Part1.sql` | Actualiza procedimientos generales | 1 min |
| 4 | `04_UPDATE_Procedimientos_Migration_Part2_Critical.sql` | Actualiza procedimientos críticos | 1 min |
| 5 | `05_Validacion_PostMigracion.sql` | Valida todo | 1 min |

**Tiempo total:** ~6 minutos

---

## ?? DOCUMENTACIÓN

### Para Administradores de BD
1. ?? **`RESUMEN_EJECUTIVO_MIGRACION.md`** - Vista general
2. ?? **`README_MIGRACION.md`** - Guía técnica detallada

### Para Desarrolladores .NET
1. ?? **`NOTAS_IMPLEMENTACION_DOTNET.md`** - Cambios en código C#
2. ? **Checklist de actualización**
3. ?? **Tests recomendados**

### Para DBA
1. ??? **Scripts SQL organizados por función**
2. ?? **Validación post-migración**
3. ?? **Rollback si es necesario**

---

## ?? ESTRUCTURA DE ARCHIVOS

```
bd/
??? 00_MAESTRO_MIGRACION_Ejecutar_Primero.sql ? COMIENZA AQUÍ
??? 01_ALTER_preReservasDeHorario_AddColumns.sql
??? 02_UPDATE_Funciones_Migration.sql
??? 03_UPDATE_Procedimientos_Migration_Part1.sql
??? 04_UPDATE_Procedimientos_Migration_Part2_Critical.sql
??? 05_Validacion_PostMigracion.sql
??? RESUMEN_EJECUTIVO_MIGRACION.md ? LEE ESTO PRIMERO
??? README_MIGRACION.md
??? NOTAS_IMPLEMENTACION_DOTNET.md ? EQUIPO .NET
??? INDICE_MIGRACION.md (este archivo)
```

---

## ?? FLUJO DE IMPLEMENTACIÓN RECOMENDADO

### FASE 1: PREPARACIÓN (Día 1)
- [ ] Lee: `RESUMEN_EJECUTIVO_MIGRACION.md`
- [ ] Lee: `README_MIGRACION.md`
- [ ] Comparte con equipo: `NOTAS_IMPLEMENTACION_DOTNET.md`
- [ ] Hacer backup de BD

### FASE 2: IMPLEMENTACIÓN SQL (Día 2)
- [ ] Ejecutar: `00_MAESTRO_MIGRACION_Ejecutar_Primero.sql` en staging
- [ ] Validar: `05_Validacion_PostMigracion.sql`
- [ ] Revisar logs

### FASE 3: ACTUALIZACIÓN .NET (Día 2-3)
- [ ] Actualizar `ClasesService.cs`
- [ ] Actualizar `HorariosService.cs`
- [ ] Ejecutar tests unitarios
- [ ] Ejecutar tests de integración

### FASE 4: VALIDACIÓN FINAL (Día 3-4)
- [ ] Test completo en staging
- [ ] Code review
- [ ] Documentar cambios
- [ ] Preparar para producción

### FASE 5: DEPLOY A PRODUCCIÓN (Día 4-5)
- [ ] Ejecutar scripts en producción
- [ ] Deploy código .NET
- [ ] Monitoreo

---

## ?? CAMBIOS PRINCIPALES (RESUMEN)

### Qué cambió
```
fechaDeLaClase: horariosDeClasesProgramadas ? clasesProgramadas
fkEntrenador:   horariosDeClasesProgramadas ? clasesProgramadas
```

### Qué se agregó
```
preReservasDeHorario ahora tiene:
??? idClase
??? fechaDeLaClase
??? idEntrenador
??? Índice UNIQUE para integridad
```

### Qué se actualizó
```
Funciones:    5 actualizadas
Procedimientos: 7 actualizados
Índices:      2 creados
Foreign Keys: 2 agregadas
```

---

## ? VALIDACIÓN POST-MIGRACIÓN

Después de ejecutar los scripts, verifica:

```sql
-- 1. Verificar columnas
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'preReservasDeHorario'
AND COLUMN_NAME IN ('idClase', 'fechaDeLaClase', 'idEntrenador')

-- 2. Verificar índices
SELECT name FROM sys.indexes
WHERE object_id = OBJECT_ID('preReservasDeHorario')

-- 3. Probar funciones
SELECT dbo.yaExisteClaseProgramada(GETDATE(), ...)

-- 4. Contar registros
SELECT COUNT(*) FROM clasesProgramadas
```

---

## ?? EN CASO DE PROBLEMAS

### Problema: "Column not found"
**Causa:** Script anterior no se ejecutó  
**Solución:** Ejecutar scripts en orden

### Problema: "Constraint violation"
**Causa:** Datos duplicados conflictivos  
**Solución:** Revisar integridad de datos

### Problema: "Procedure not found"
**Causa:** Script de procedimientos no ejecutado  
**Solución:** Ejecutar `02_UPDATE_Funciones_Migration.sql`

### Problema: Aplicación falla tras migración
**Causa:** Código .NET no actualizado  
**Solución:** Ver `NOTAS_IMPLEMENTACION_DOTNET.md`

**Opción nuclear:** Hacer ROLLBACK y reintentar

---

## ?? MÉTRICAS DE ÉXITO

Después de la migración, verifica que:

? Todas las funciones se ejecutan sin error  
? Todos los procedimientos se ejecutan sin error  
? Los índices se crearon correctamente  
? Los Foreign Keys funcionan  
? Aplicación .NET conecta correctamente  
? Tests unitarios pasan  
? Tests de integración pasan  

---

## ?? CONTACTO / ESCALACIÓN

Si algo sale mal:

1. **Revisar logs:** Ver scripts de validación
2. **Contactar DBA:** Para soporte con BD
3. **Contactar Dev Lead:** Para cambios .NET
4. **Hacer ROLLBACK:** Si es necesario

---

## ?? RECURSOS ADICIONALES

- Microsoft SQL Server Documentation
- Entity Framework Core Migration Guide
- C# Database Access Best Practices

---

## ?? HISTORIAL

| Versión | Fecha | Estado | Cambios |
|---------|-------|--------|---------|
| 1.0 | 2025-12-04 | ? Completo | Migración inicial |

---

## ?? CHECKLIST FINAL

- [x] Scripts SQL creados
- [x] Funciones actualizadas
- [x] Procedimientos actualizados
- [x] Validación incluida
- [x] Documentación completa
- [x] Notas .NET incluidas
- [x] Índice creado
- [ ] **SIGUIENTE: Ejecutar en staging**
- [ ] **SIGUIENTE: Ejecutar en producción**

---

**¡Migración lista para implementar!** ??

Para empezar, ejecuta: `00_MAESTRO_MIGRACION_Ejecutar_Primero.sql`

