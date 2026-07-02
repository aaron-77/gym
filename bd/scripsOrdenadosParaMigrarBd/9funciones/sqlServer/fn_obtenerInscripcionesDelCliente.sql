-- =============================================
-- FUNCTION: fn_obtenerInscripcionesDelCliente
-- Descripción: Consulta las inscripciones vigentes de un cliente específico,
--              devolviendo únicamente inscripciones para clases con
--              horario de la fecha actual en adelante. Si la clase es
--              del día actual, la hora de la clase debe ser mayor a la actual.
-- Parámetros:
--   @idUsuario NVARCHAR(450) - ID del usuario (GUID de AspNetUsers)
-- =============================================

CREATE FUNCTION dbo.fn_obtenerInscripcionesDelCliente(@idUsuario NVARCHAR(450))
RETURNS TABLE
AS
RETURN
(
    SELECT
        ic.idInscripcion,
        ic.fechaDeInscripcion,
        ei.nombreEstadoInscripcion AS estadoInscripcion,
        cp.idProgramacionClase AS idClaseProgramada,
        c.NombreClase AS nombreClase,
        cp.fechaDeLaClase,
        hl.horaInicio,
        hl.horaFin,
        cp.cupoMaximo,
        CONCAT(u.NombreCompleto, ' ', u.Apellido) AS nombreEntrenador
    FROM inscripcionesDeClases ic
        INNER JOIN clasesProgramadas cp 
            ON ic.fkProgramacionClase = cp.idProgramacionClase
        INNER JOIN horariosDeClasesProgramadas hcp 
            ON cp.idProgramacionClase = hcp.fkClaseProgramada
        INNER JOIN horasLaborales hl 
            ON hcp.fkHorarioLaboral = hl.idHora
        INNER JOIN estadosInscripciones ei 
            ON ic.fkEstadoInscripcion = ei.idEstadoInscripcion
        INNER JOIN Clases c 
            ON cp.fkClase = c.ClaseID
        LEFT JOIN AspNetUsers u 
            ON cp.fkEntrenador = u.Id
    WHERE ic.fkCliente = @idUsuario
        -- Solo inscripciones vigentes
        AND ei.idEstadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase)
        AND (
            -- Clase futura: fecha posterior a hoy
            cp.fechaDeLaClase > CAST(GETDATE() AS DATE)
            OR 
            -- Clase del día actual con hora futura
            (
                cp.fechaDeLaClase = CAST(GETDATE() AS DATE)
                AND hl.horaInicio > CAST(GETDATE() AS TIME)
            )
        )
);

GO
