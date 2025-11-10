EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';

-- 2️⃣ Generar DELETE dinámico
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += 'DELETE FROM ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + ';' + CHAR(13)
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0;

PRINT @sql;  -- Opcional: revisar el SQL
EXEC sp_executesql @sql;

-- 3️⃣ Volver a habilitar las restricciones FOREIGN KEY
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';