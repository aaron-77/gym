use FitnessCenterDB
SELECT 
    TABLE_SCHEMA AS Esquema,
    TABLE_NAME AS NombreTabla
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;


EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';

-- Genera y ejecuta un TRUNCATE TABLE para cada tabla
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql + 'TRUNCATE TABLE [' + s.name + '].[' + t.name + '];' + CHAR(13)
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
ORDER BY t.name;

PRINT @sql; -- Muestra el script generado (opcional, para verificar antes de ejecutar)
EXEC sp_executesql @sql;

-- Reactiva las restricciones de clave foránea
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';


--@sql = @sql + 'TRUNCATE TABLE [' + s.name + '].[' + t.name + '];' + CHAR(13)
SELECT * FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
ORDER BY t.name;