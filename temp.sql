use FitnessCenterDB

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20251209185552_AddRecreacionSnapshot', N'8.0.22');
GO
select * from AspNetUsers
COMMIT;
GO

select * from __EFMigrationsHistory

-- Ver el nombre de la BD actual
SELECT DB_NAME() AS DatabaseActual;

-- Ver si existe la tabla
SELECT * FROM [FitnessCenterDB].[dbo].[__EFMigrationsHistory]
ORDER BY MigrationId DESC;

-- Ver si existe la columna
SELECT COLUMN_NAME 
FROM [FitnessCenterDB].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'AspNetUsers' 
  AND COLUMN_NAME = 'IdSecundario';
