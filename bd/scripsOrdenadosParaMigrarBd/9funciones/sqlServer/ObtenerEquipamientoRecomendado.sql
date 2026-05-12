-- =============================================
-- FUNCTION: ObtenerEquipamientoRecomendado
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.ObtenerEquipamientoRecomendado(@IdClase INT)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
        e.EquipoId,
        e.NombreEquipo,
        e.Descripcion,
        i.urlPublica AS UrlIcono
    FROM 
        Rutinas r
        INNER JOIN RutinaEjercicios re on r.RutinaId =  re.RutinaId
        INNER JOIN Ejercicios ej on re.EjercicioId = ej.EjercicioId
        INNER JOIN EjercicioEquipos ee ON ee.EjercicioId = ej.EjercicioID
        INNER JOIN Equipos e ON ee.EquipoId = e.EquipoId
        LEFT JOIN IconsForParameters i ON e.FkIcon = i.iconId
    WHERE 
        r.FkClase = @IdClase
);

GO
