-- =============================================
-- PROCEDURE: sp_cancelarClasesProgramadas_v6
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE   PROCEDURE dbo.sp_cancelarClasesProgramadas_v6
    @idClaseProgramada int = null,
    @fechaDeReferencia DATE = null,
    @idEntrenador nvarchar(450) = null,
    @idClase int = null
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @idsClasesCanceladas dbo.ListadoIdsGenericos; 

    IF @fechaDeReferencia IS NULL
    BEGIN
        SET @fechaDeReferencia = CAST(GETDATE() AS DATE);
    END

    IF @idClaseProgramada IS NOT NULL
    BEGIN
        INSERT INTO @idsClasesCanceladas(id)
        SELECT idProgramacionClase
        FROM dbo.clasesProgramadas cp
        WHERE cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM dbo.v_idEstadoDisponibleClasesProgramadas)
          AND cp.idProgramacionClase = @idClaseProgramada;
    END
    ELSE
    BEGIN
        IF @fechaDeReferencia = CAST(GETDATE() AS DATE) AND @idEntrenador IS NULL AND @idClase IS NULL
        BEGIN
            INSERT INTO @idsClasesCanceladas
            SELECT idProgramacionClase
            FROM dbo.clasesProgramadas cp
            JOIN dbo.horariosDeClasesProgramadas hdcp ON cp.idProgramacionClase = hdcp.fkClaseProgramada
            WHERE cp.fechaDeLaClase >= @fechaDeReferencia
              AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM dbo.v_idEstadoDisponibleClasesProgramadas);
        END
        ELSE
        BEGIN
            INSERT INTO @idsClasesCanceladas
            SELECT idProgramacionClase
            FROM dbo.clasesProgramadas cp
            JOIN dbo.horariosDeClasesProgramadas hdcp ON cp.idProgramacionClase = hdcp.fkClaseProgramada
            WHERE ((@fechaDeReferencia IS NULL OR cp.fechaDeLaClase= @fechaDeReferencia)
                AND (@idEntrenador IS NULL OR cp.fkEntrenador = @idEntrenador)
                AND (@idClase IS NULL OR cp.fkClase = @idClase))
              AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM dbo.v_idEstadoDisponibleClasesProgramadas);
        END
    END

    IF NOT EXISTS (SELECT 1 FROM @idsClasesCanceladas)
    BEGIN
        THROW 51000, 'No se encontraron clases activas para cancelar', 1;
    END

    UPDATE dbo.clasesProgramadas
    SET fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM dbo.estadosClasesProgramadas WHERE nombresEstado = 'cancelada')
    WHERE idProgramacionClase IN (SELECT id FROM @idsClasesCanceladas);

    SELECT * FROM @idsClasesCanceladas;
END;

GO
