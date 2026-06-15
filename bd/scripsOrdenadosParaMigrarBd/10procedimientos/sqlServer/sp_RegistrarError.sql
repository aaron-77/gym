-- =============================================
-- PROCEDURE: sp_RegistrarError
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_RegistrarError]
    @Procedimiento NVARCHAR(255),
    @Mensaje NVARCHAR(MAX),
    @Severidad INT,
    @Estado INT,
    @Usuario NVARCHAR(100) = null, -- Obtiene el usuario actual por defecto
    @Host NVARCHAR(100) = null, -- Obtiene el nombre del host por defecto
    @Aplicacion NVARCHAR(255) = null -- Obtiene el nombre de la aplicación por defecto
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LogErrores (procedimiento, mensaje, severidad, estado, fecha, usuario, host, aplicacion)
    VALUES (@Procedimiento, @Mensaje, @Severidad, @Estado, GETDATE(), @Usuario, @Host, @Aplicacion);
END;

GO
