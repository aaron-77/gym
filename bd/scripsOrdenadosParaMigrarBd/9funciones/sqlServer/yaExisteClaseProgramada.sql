-- =============================================
-- FUNCTION: yaExisteClaseProgramada
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION [dbo].[yaExisteClaseProgramada](
    @fkClase INT,
    @fkEntrenador NVARCHAR(450),
    @fecha DATE,
    @fksHorasLaborales IdsHorasLaborales READONLY
)
RETURNS BIT
AS
BEGIN
    DECLARE @yaExiste BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM clasesProgramadas cp
        INNER JOIN horariosDeClasesProgramadas hcp 
            ON cp.idProgramacionClase = hcp.fkClaseProgramada
            AND hcp.fkEstadoHorarioClase = 1
            AND hcp.fkHorarioLaboral IN (SELECT fkHoraLaboral FROM @fksHorasLaborales)
        WHERE cp.fechaDeLaClase = @fecha
          AND cp.fkClase = @fkClase
          AND (@fkEntrenador IS NULL OR cp.fkEntrenador = @fkEntrenador)
          AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas)
    )
    BEGIN
        SET @yaExiste = 1;
    END;

    RETURN @yaExiste;
END;

GO
