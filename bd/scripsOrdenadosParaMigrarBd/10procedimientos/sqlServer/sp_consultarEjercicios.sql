-- =============================================
-- PROCEDURE: sp_consultarEjercicios
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_consultarEjercicios]
AS
BEGIN
		select * from Ejercicios;
END;

GO
