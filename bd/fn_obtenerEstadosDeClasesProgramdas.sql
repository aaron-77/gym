-- Función para obtener todos los estados de clases programadas
CREATE OR ALTER FUNCTION fn_obtenerEstadosDeClasesProgramdas()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        idEstadoClaseProgramada,
        nombresEstado,
        fechaCreacion,
        fechaModificacion
    FROM estadosClasesProgramadas
); 