-- =============================================
-- PROCEDURE: sp_registrarClaseProgramada
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE  PROCEDURE [dbo].[sp_registrarClaseProgramada]
    @datos dbo.DatosClaseProgramada READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @idClaseProgramada INT;
        DECLARE @fkClase INT, 
                @fkEntrenador NVARCHAR(450),
                @cupoMaximo INT, 
                @fkEstadoClaseProgramada INT,
                @fkHorarioLaboralString NVARCHAR(MAX),
                @idPreReservaDeHorario INT,
                @fechaDeLaClase DATE,
                @idHorarioClaseProgramadaRegistrado INT;

        -- Extraer datos del parámetro tabla
        SELECT TOP 1 
            @fkClase = fkClase,
            @fkEntrenador = fkEntrenador,
            @cupoMaximo = cupoMaximo,
            @fkEstadoClaseProgramada = fkEstadoClaseProgramada,
            @fkHorarioLaboralString = fkHoraLaboral,
            @idPreReservaDeHorario = idPreservaDeHorario,
            @fechaDeLaClase = fechaDeLaClase
        FROM @datos;

        -- Insertar clase programada con fecha y entrenador
        INSERT INTO clasesProgramadas (
            fkClase, 
            fkEntrenador, 
            cupoMaximo, 
            fkEstadoClaseProgramada,
            fechaDeLaClase
        )
        VALUES (
            @fkClase, @fkEntrenador, @cupoMaximo, @fkEstadoClaseProgramada, @fechaDeLaClase
        );

        SET @idClaseProgramada = SCOPE_IDENTITY();

        -- Si hay horarios en string (coma-separado), registrarlos
        IF @fkHorarioLaboralString IS NOT NULL AND LEN(@fkHorarioLaboralString) > 0
        BEGIN
            DECLARE @horarioId INT;
            DECLARE @posicion INT = 1;
            DECLARE @longitud INT = LEN(@fkHorarioLaboralString);
            DECLARE @valorActual VARCHAR(50);

            WHILE @posicion <= @longitud
            BEGIN
                SET @valorActual = '';
                WHILE @posicion <= @longitud AND SUBSTRING(@fkHorarioLaboralString, @posicion, 1) != ','
                BEGIN
                    SET @valorActual = @valorActual + SUBSTRING(@fkHorarioLaboralString, @posicion, 1);
                    SET @posicion = @posicion + 1;
                END

                IF SUBSTRING(@fkHorarioLaboralString, @posicion, 1) = ','
                    SET @posicion = @posicion + 1;

                IF ISNUMERIC(@valorActual) = 1 AND LEN(@valorActual) > 0
                BEGIN
                    SET @horarioId = CAST(@valorActual AS INT);
                    SET @idHorarioClaseProgramadaRegistrado = 0;

                    -- Registrar horario (procedimiento ya no requiere fkEntrenador)
                    EXEC sp_registrarHorarioDeClaseProgramada 
                        @fkClaseProgramada = @idClaseProgramada,
                        @fkHorarioLaboral = @horarioId,
                        @idHorarioDeClaseProgramada = @idHorarioClaseProgramadaRegistrado OUTPUT;
                END
            END
        END

        -- Limpiar pre-reserva si existe
        IF @idPreReservaDeHorario IS NOT NULL
        BEGIN
            DELETE FROM preReservasDeHorario 
            WHERE idPreReserva = @idPreReservaDeHorario;
        END

        COMMIT TRANSACTION;
        SELECT @idClaseProgramada AS IdClaseProgramada;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        DECLARE 
            @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
            @ErrorNumber INT = ERROR_NUMBER(),
            @ErrorSeverity INT = ERROR_SEVERITY(),
            @ErrorState INT = ERROR_STATE(),
            @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
            @ErrorLine INT = ERROR_LINE();

        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorNumber,
            @ErrorSeverity,
            @ErrorState,
            @ErrorMessage,
            @ErrorLine;

        THROW;
    END CATCH
END;

GO
