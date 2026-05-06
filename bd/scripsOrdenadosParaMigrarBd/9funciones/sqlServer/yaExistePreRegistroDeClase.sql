-- =============================================
-- FUNCTION: yaExistePreRegistroDeClase
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION [dbo].[yaExistePreRegistroDeClase](
    @idClase INT,
    @idEntrenador NVARCHAR(450),
    @fechaReservada DATE,
    @fksHorasLaborales IdsHorasLaborales READONLY
)
RETURNS BIT
AS
BEGIN
    DECLARE @yaExiste BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM preReservasDeHorario pr
        WHERE pr.fechaDeLaClase = @fechaReservada
            AND pr.fkHoraLaboral IN (SELECT fkHoraLaboral FROM @fksHorasLaborales)
            AND (@idClase IS NULL OR pr.idClase = @idClase)
            AND (@idEntrenador IS NULL OR pr.idEntrenador = @idEntrenador)
            AND GETDATE() BETWEEN pr.fechaInicioDeLaReserva AND pr.fechaDeExpiracionDeLaReserva
    )
    BEGIN
        SET @yaExiste = 1;
    END;

    RETURN @yaExiste;
END;

GO
