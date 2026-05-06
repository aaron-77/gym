-- =============================================
-- PROCEDURE: sp_registrarRutina
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   PROCEDURE [dbo].[sp_registrarRutina]
(
    @usuarioID NVARCHAR(450),    -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
    @entrenadorID NVARCHAR(450), -- MODIFICADO: Tipo de dato de INT a NVARCHAR(450)
    @fechaCreacion datetime,
    @observaciones nvarchar(max)
)
AS
BEGIN
    IF @fechaCreacion IS NULL
    BEGIN
        SET @fechaCreacion = GETDATE();
    END

    INSERT INTO FitnessCenterDB.dbo.Rutinas(
        UserId,       -- MODsp_consultarRutinasDeUsuarioIFICADO: UsuarioID a UserId
        EntrenadorId, -- MODIFICADO: EntrenadorID a EntrenadorId
        FechaCreacion,
        Observaciones)
    VALUES(
        @usuarioID,
        @entrenadorID,
        @fechaCreacion,
        @observaciones)
END;

GO
