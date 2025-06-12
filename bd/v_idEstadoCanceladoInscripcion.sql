CREATE VIEW v_idEstadoCanceladoInscripcionAClase
AS
SELECT 
    idEstadoInscripcion
FROM 
    FitnessCenterDB.dbo.estadosInscripciones
WHERE 
    nombreEstadoInscripcion = 'cancelada';