CREATE VIEW v_idEstadoVigenteInscripcionAClase
AS
SELECT 
    idEstadoInscripcion
FROM 
    FitnessCenterDB.dbo.estadosInscripciones
WHERE 
    nombreEstadoInscripcion = 'vigente';