USE [FitnessCenterDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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