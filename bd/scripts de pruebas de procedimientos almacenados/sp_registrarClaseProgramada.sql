CREATE PROCEDURE dbo.sp_registrarClaseProgramada
    @datos dbo.DatosClaseProgramada READONLY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @idClaseProgramada INT;
        DECLARE @fkClase INT, 
                @fkEntrenador INT,
                @cupoMaximo INT, 
                @fkEstadoClaseProgramada INT,
                @fkHorarioLaboralString NVARCHAR(MAX),
                @idPreReservaDeHorario INT,
               	@fechaDeLaClase DATE;

        -- se extraen los datos del parametro en variables indepedientes para facilitar su insercion posterioemnete
        SELECT TOP 1 
            @fkClase = fkClase,
            @fkEntrenador = fkEntrenador,
            @cupoMaximo = cupoMaximo,
            @fkEstadoClaseProgramada = fkEstadoClaseProgramada,
            @fkHorarioLaboralString = fkHoraLaboral,
            @idPreReservaDeHorario = idPreservaDeHorario,
            @fechaDeLaClase = fechaDeLaClase
        FROM @datos;
	
        -- Insertar en clasesProgramadas
        PRINT N'1/14 determinando horarios laborales '+cast(@fkEntrenador as nvarchar(10));
       
        
       PRINT N'2/14 registrando clase programada';
        INSERT INTO FitnessCenterDB.dbo.clasesProgramadas (
            fkClase, 
            fkEntrenador, 
            cupoMaximo, 
            fkEstadoClaseProgramada
        )
        VALUES (
            @fkClase, @fkEntrenador, @cupoMaximo, @fkEstadoClaseProgramada
        );

        PRINT N'3/14 clase programada registrada correctamente';
        SET @idClaseProgramada = SCOPE_IDENTITY();


        -- Si hay datos de horarios, registrarlos
        IF @fkHorarioLaboralString IS NOT NULL AND LEN(@fkHorarioLaboralString) > 0
        BEGIN
            PRINT N'4/14 se encontraron horarios laborales';
            DECLARE @horarioId INT;
            DECLARE @posicion INT = 1;
            DECLARE @longitud INT = LEN(@fkHorarioLaboralString);
            DECLARE @valorActual VARCHAR(20);
            DECLARE @estaDisponibleElHorario BIT = 0;
            DECLARE @idsHorasLabotales IdsHorasLaborales;
            WHILE @posicion <= @longitud
            BEGIN
                PRINT N'5/14 empieza bucle conversor de horarios laborales';
                -- Extraer el siguiente valor hasta la coma
                SET @valorActual = '';
                WHILE @posicion <= @longitud AND SUBSTRING(@fkHorarioLaboralString, @posicion, 1) != ','
                BEGIN
                    SET @valorActual = @valorActual + SUBSTRING(@fkHorarioLaboralString, @posicion, 1);
                    SET @posicion = @posicion + 1;
                END

                -- Saltar la coma
                SET @posicion = @posicion + 1;
                    
                PRINT N'6/14 determinando validez del horario';

                -- Convertir a entero y validar
                IF ISNUMERIC(@valorActual) = 1
                BEGIN
                    PRINT N'7/14 id hora laboral correcto';
                    SET @horarioId = CAST(@valorActual AS INT);             
                    -- Registrar el horario
                    PRINT N'8/14 registrando horario';
                    EXEC FitnessCenterDB.dbo.sp_registrarHorarioDeClaseProgramada 
                        @fkClaseProgramada = @idClaseProgramada,
                        @fkHorarioLaboral = @horarioId,
                        @fkEntrenador = @fkEntrenador;

                    PRINT N'9/14 horario registrado correctamente';
                END
            END
        END

        PRINT N'10/14 transacción completada correctamente';
        COMMIT TRANSACTION;

        SELECT @idClaseProgramada AS IdClaseProgramada;

    END TRY
    BEGIN CATCH
        PRINT N'11/14 excepción capturada';
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
    
        DECLARE 
        @ProcName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
        @ErrorNumber INT = ERROR_NUMBER(),
        @ErrorSeverity INT = ERROR_SEVERITY(),
        @ErrorState INT = ERROR_STATE(),
        @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
        @ErrorLine INT = ERROR_LINE(); 

        PRINT N'12/14 registrando log de error';
        EXEC sp_RegistrarError 
            @ProcName,
            @ErrorNumber,
            @ErrorSeverity,
            @ErrorState,
            @ErrorMessage,
            @ErrorLine;

        PRINT N'13/14 error registrado correctamente';

        -- Opcional: volver a lanzar el error para que el cliente lo reciba
        PRINT N'14/14 relanzando THROW'; 
        THROW;
    END CATCH
END;