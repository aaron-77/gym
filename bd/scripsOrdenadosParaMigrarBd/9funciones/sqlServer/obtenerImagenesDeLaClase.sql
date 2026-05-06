-- =============================================
-- FUNCTION: obtenerImagenesDeLaClase
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.obtenerImagenesDeLaClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
    urlParaBanner,
	urlParaParaDescripcionDeClase,
	urlParaBloqueConsejos 
FROM imagesForClases i
    WHERE 
        i.FkClase = @IdClase
);

CREATE PROCEDURE ObtenerParametrosDeMedicion
    @PageNumber INT,       
    @PageSize INT          
AS
BEGIN
    SET NOCOUNT ON;

    -- Calcular el índice de desplazamiento
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    -- Obtener los resultados paginados
    SELECT 
        parametroMedicionId,
        nombre
    FROM parametrosDeMedicion
    ORDER BY parametroMedicionId ASC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;

    SET NOCOUNT OFF;
END;

CREATE PROCEDURE showtables
    @tableName NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        TABLE_CATALOG,
        TABLE_SCHEMA,
        TABLE_NAME,
        COLUMN_NAME, 
        DATA_TYPE, 
        IS_NULLABLE, 
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @tableName;
END;

GO
