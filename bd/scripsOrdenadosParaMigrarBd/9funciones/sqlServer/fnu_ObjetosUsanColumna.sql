-- =============================================
-- FUNCTION: fnu_ObjetosUsanColumna
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION dbo.fnu_ObjetosUsanColumna
(
    @NombreTabla NVARCHAR(256),
    @NombreColumna NVARCHAR(256)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        OBJECT_SCHEMA_NAME(o.object_id) AS Esquema,
        o.name AS NombreObjeto,
        o.type_desc AS TipoObjeto
    FROM sys.sql_modules m
    INNER JOIN sys.objects o ON m.object_id = o.object_id
    WHERE m.definition LIKE '%' + @NombreColumna + '%'
      AND m.definition LIKE '%' + @NombreTabla + '%'
);

-- Function to retrieve the benefits of the class (from beneficios table)

GO
