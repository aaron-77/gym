-- =============================================
-- FUNCTION: fnu_ObjetosDependenTabla
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION dbo.fnu_ObjetosDependenTabla
(
    @NombreTabla NVARCHAR(256)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        OBJECT_SCHEMA_NAME(referencing_id) AS Esquema,
        OBJECT_NAME(referencing_id) AS NombreObjeto,
        o.type_desc AS TipoObjeto
    FROM sys.sql_expression_dependencies sed
    INNER JOIN sys.objects o ON sed.referencing_id = o.object_id
    WHERE sed.referenced_entity_name = @NombreTabla
);

GO
