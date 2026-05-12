-- =============================================
-- FUNCTION: ObtenerDetalleDeClase
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   FUNCTION dbo.ObtenerDetalleDeClase(@IdClase INT)
    RETURNS TABLE
    AS
    RETURN
    (
        SELECT 
            c.claseId,
            c.NombreClase,
            c.DuracionEnMinutos as Duracion,
            ni.NombreNivelDeIntensidad as NivelDeIntensidad ,
            nd.NombreNivelDeDificultad as NivelDeDificultad ,
            c.Descripcion AS DescripcionDeLaClase,
            (SELECT * FROM dbo.obtenerImagenesDeLaClase(@IdClase) FOR JSON AUTO) as imagenesDeClase,
            (SELECT * FROM dbo.ObtenerBeneficiosDeClase(@IdClase) FOR JSON AUTO) AS BeneficiosDeLaClase,
        (SELECT * FROM (SELECT * FROM dbo.ObtenerEstructuraDeClase(@IdClase)) AS ec 
                ORDER BY ec.NumeroConsecutivoDelBloque FOR JSON AUTO) AS EstructuraDeLaClase,
            (SELECT * FROM dbo.ObtenerEjerciciosDeClase(@IdClase) FOR JSON AUTO) AS EjerciciosDeClase,
            (SELECT * FROM dbo.ObtenerConsejosDeClase(@IdClase) FOR JSON AUTO) AS Consejos,
            (SELECT * FROM dbo.ObtenerEquipamientoRecomendado(@IdClase) FOR JSON AUTO) AS EquipamientoRecomendado,
            (SELECT * FROM dbo.ObtenerClasesProgramadas(@IdClase) FOR JSON AUTO) AS HorariosProgramados
        FROM 
            Clases c
            INNER JOIN nivelesDeIntensidadDeClase  ni ON c.FkIntensidad = ni.IdNivelDeIntensidad
            INNER JOIN nivelesDeDificultadDeClase nd ON c.FkDificultad = nd.IdNivelDeDificultadDeClase
        WHERE 
            c.claseId = @IdClase
    );

GO
