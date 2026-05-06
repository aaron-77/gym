-- =============================================
-- FUNCTION: ObtenerEjerciciosDeClase
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.ObtenerEjerciciosDeClase(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        i.urlPublica as UrlIcono,
        e.NombreEjercicio,
        e.Descripcion as DescripcionEjercicio,
        ife.urlPublica as urlImagen
    FROM 
    	Rutinas r 
    	INNER JOIN RutinaEjercicios re on re.RutinaID =  r.RutinaID
        INNER JOIN Ejercicios e on e.EjercicioId = re.EjercicioID
        LEFT JOIN iconsForParameters  i ON e.FkIcon = i.iconId
        LEFT JOIN imagesForExercises ife on ife.fkEjercicio = e.EjercicioId 
    WHERE 
        r.fkClase = @IdClase
);

GO
