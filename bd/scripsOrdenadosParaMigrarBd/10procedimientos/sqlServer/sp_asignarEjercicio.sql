-- =============================================
-- PROCEDURE: sp_asignarEjercicio
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_asignarEjercicio]
( 
@rutinaID int,
@ejercicioID int,
@sets int,
@repeticiones int,
@peso decimal,
@tiempo int,
@metaRepeticiones int
)	
AS
BEGIN
	
	
		insert into RutinaEjercicios(
		RutinaID,
		EjercicioID,
		Sets,
		Repeticiones,
		Peso,
		Tiempo,
		MetaRepeticiones
		)
		values(
		@rutinaID,
		@ejercicioID,
		@sets,
		@repeticiones,
		@peso,
		@tiempo,
		@metaRepeticiones
		)
END;

GO
