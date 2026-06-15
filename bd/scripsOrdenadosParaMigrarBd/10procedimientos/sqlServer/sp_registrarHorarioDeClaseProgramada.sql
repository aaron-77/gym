-- =============================================
-- PROCEDURE: sp_registrarHorarioDeClaseProgramada
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_registrarHorarioDeClaseProgramada]
    @fkClaseProgramada INT,
    @fkHorarioLaboral INT,
    @idHorarioDeClaseProgramada INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO horariosDeClasesProgramadas (fkClaseProgramada, fkHorarioLaboral, fkEstadoHorarioClase)
    VALUES (@fkClaseProgramada, @fkHorarioLaboral, 1);
    
    SET @idHorarioDeClaseProgramada = SCOPE_IDENTITY();
END;

GO
