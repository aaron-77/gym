use fitnessCenterDB
-- =============================================
-- FUNCTION: fn_yaExistePreReservaDeInscripcion
-- Spec: 61-spect-fn_yaExistePreReservaDeInscripcion
-- =============================================

CREATE FUNCTION dbo.fn_yaExistePreReservaDeInscripcion(
    @idClase INT,
    @idEntrenador NVARCHAR(450),
    @fechaReservada DATE,
    @idCliente NVARCHAR(450),
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
            AND (@idCliente IS NULL OR pr.idUsuarioQueReserva = @idCliente)
            AND GETDATE() BETWEEN pr.fechaInicioDeLaReserva AND pr.fechaDeExpiracionDeLaReserva
    )
    BEGIN
        SET @yaExiste = 1;
    END;

    RETURN @yaExiste;
END;

GO
