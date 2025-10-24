use FitnessCenterDB
-- 1️⃣ Deshabilitar todas las restricciones FOREIGN KEY
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';

-- 2️⃣ Generar y ejecutar TRUNCATE TABLE para todas las tablas
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += 'TRUNCATE TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + ';' + CHAR(13)
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0;  -- excluir tablas del sistema

PRINT @sql;  -- Opcional: revisar el SQL que se va a ejecutar
EXEC sp_executesql @sql;

-- 3️⃣ Volver a habilitar las restricciones FOREIGN KEY
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
