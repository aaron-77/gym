USE [FitnessCenterDB];
GO

/*
 ============================================================================
  Procedimiento : dbo.sp_cron_generarClasesProgramadas
  Propósito     : Generar clases programadas para el día actual.
                  Algoritmo de emparejamiento clase-horario + asignacion
                  aleatoria de instructores en 3 fases:

    FASE 1 - Obtener conjuntos base:
      - Clases activas del catalogo (sin clase programada existente para hoy)
      - Horarios laborales disponibles (via sp_obtenerHorariosDisponibles)
      - Instructores disponibles (via sp_obtenerEntrenadoresDisponibles)

    FASE 2 - Emparejar clases con horarios:
      Formula: c.rn = h.rn % TC  (ambos base 0)
      - TH > TC: cada clase recibe multiples horarios, distribuidos
      - TC > TH: solo las primeras TH clases reciben horario
      - TH = TC: 1 a 1 perfecto

    FASE 3 - Asignar instructores (aleatorio, round-robin):
      Cada tupla (clase, horario) recibe un instructor.
      Al ser los horarios inherentemente unicos, NO puede haber
      violacion del indice IX_EntrenadorFechaHora.

  Ejecucion     : SQL Server Agent Job (diario, 00:05)
                  EXEC dbo.sp_cron_generarClasesProgramadas;
  Transaccional : Si - todo o nada.
  Dependencias:
    - dbo.esDiaFestivo()
    - dbo.v_idEstadoDisponibleClasesProgramadas
    - dbo.v_estadoActivoClases
    - dbo.sp_obtenerHorariosDisponibles
    - dbo.sp_obtenerEntrenadoresDisponibles
    - dbo.sp_registrarClaseProgramada
    - dbo.sp_RegistrarError
 ============================================================================
*/


CREATE OR ALTER PROCEDURE [dbo].[sp_cron_generarClasesProgramadas]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @nombreSP NVARCHAR(255) = OBJECT_NAME(@@PROCID);
    DECLARE @fechaInicio DATETIME2 = GETDATE();

    -- ============================================================
    -- 1. Validar que hoy NO sea dia festivo
    -- ============================================================
    IF dbo.esDiaFestivo(@hoy) = 1
    BEGIN
        PRINT 'Hoy (' + CONVERT(VARCHAR, @hoy, 103) + ') es dia festivo. No se generan clases.';
        RETURN;
    END

    -- ============================================================
    -- 2. Obtener IDs de referencia desde las vistas existentes
    -- ============================================================
    DECLARE @idEstadoDisponible INT;
    SELECT @idEstadoDisponible = idEstadoClaseProgramada
    FROM dbo.v_idEstadoDisponibleClasesProgramadas;

    IF @idEstadoDisponible IS NULL
    BEGIN
        RAISERROR('No se encontro el estado "disponible" para clases programadas.', 16, 1);
        RETURN;
    END

    DECLARE @idEstadoActivoClase INT;
    SELECT @idEstadoActivoClase = idEstadoClase
    FROM dbo.v_estadoActivoClases;

    IF @idEstadoActivoClase IS NULL
    BEGIN
        RAISERROR('No se encontro el estado "activa" para clases del catalogo.', 16, 1);
        RETURN;
    END

    -- ============================================================
    -- FASE 1: OBTENER CONJUNTOS BASE
    -- ============================================================

    -- ----------------------------------------------------------
    -- 3. Clases activas del catalogo (excluyendo las que ya tienen
    --    clase programada para hoy)
    -- ----------------------------------------------------------
    SELECT
        c.ClaseID,
        c.Cupo AS cupoMaximo,
        c.NombreClase,
        ROW_NUMBER() OVER (ORDER BY c.ClaseID) - 1 AS rn  -- base 0
    INTO #clasesActivas
    FROM dbo.Clases c
    WHERE c.fkEstadoClase = @idEstadoActivoClase
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.clasesProgramadas cp
          WHERE cp.fkClase = c.ClaseID
            AND cp.fechaDeLaClase = @hoy
            AND cp.fkEstadoClaseProgramada = @idEstadoDisponible
      );

    DECLARE @totalClases INT;
    SELECT @totalClases = COUNT(*) FROM #clasesActivas;

    IF @totalClases = 0
    BEGIN
        PRINT 'No hay clases activas sin programar para hoy.';
        DROP TABLE #clasesActivas;
        RETURN;
    END

    -- ----------------------------------------------------------
    -- 4. Horarios disponibles para hoy
    -- ----------------------------------------------------------
    CREATE TABLE #horariosDelMes (
        DiaDeLaSemana NVARCHAR(50),
        FechaDisponible DATE,
        horaInicio TIME,
        horaFin TIME,
        idHora INT,
        TipoDeDia NVARCHAR(50)
    );

    INSERT INTO #horariosDelMes
    EXEC dbo.sp_obtenerHorariosDisponibles @Fecha = @hoy;

    SELECT
        h.idHora,
        ROW_NUMBER() OVER (ORDER BY h.idHora) - 1 AS rn  -- base 0
    INTO #horariosHoy
    FROM #horariosDelMes h
    WHERE h.FechaDisponible = @hoy;

    DECLARE @totalHorarios INT;
    SELECT @totalHorarios = COUNT(*) FROM #horariosHoy;

    IF @totalHorarios = 0
    BEGIN
        PRINT 'No hay horarios disponibles para hoy. Todas las franjas estan ocupadas.';
        DROP TABLE #clasesActivas;
        DROP TABLE #horariosDelMes;
        DROP TABLE #horariosHoy;
        RETURN;
    END

    -- ----------------------------------------------------------
    -- 5. Instructores disponibles
    -- ----------------------------------------------------------
    CREATE TABLE #instructoresDisponibles (
        rowId INT IDENTITY(1,1) PRIMARY KEY,
        UsuarioID NVARCHAR(450) NOT NULL,
        Nombre NVARCHAR(MAX) NULL,
        Apellido NVARCHAR(MAX) NULL,
        Email NVARCHAR(256) NULL,
        Telefono NVARCHAR(MAX) NULL,
        NombreUsuario NVARCHAR(256) NULL,
        FechaNacimiento DATETIME2 NULL,
        FechaRegistro DATETIME2 NULL,
        RolID NVARCHAR(450) NULL,
        Estado NVARCHAR(50) NULL
    );

    INSERT INTO #instructoresDisponibles (
        UsuarioID, Nombre, Apellido, Email, Telefono, NombreUsuario,
        FechaNacimiento, FechaRegistro, RolID, Estado
    )
    EXEC dbo.sp_obtenerEntrenadoresDisponibles @fechaReferencia = @hoy;

    -- Orden aleatorio para distribucion round-robin
    SELECT
        i.UsuarioID,
        ROW_NUMBER() OVER (ORDER BY NEWID()) - 1 AS rn  -- base 0, aleatorio
    INTO #instructoresShuffled
    FROM #instructoresDisponibles i;

    DECLARE @totalInstructores INT;
    SELECT @totalInstructores = COUNT(*) FROM #instructoresShuffled;

    IF @totalInstructores = 0
    BEGIN
        RAISERROR('No hay instructores disponibles para hoy.', 16, 1);
        DROP TABLE #clasesActivas;
        DROP TABLE #horariosDelMes;
        DROP TABLE #horariosHoy;
        DROP TABLE #instructoresDisponibles;
        DROP TABLE #instructoresShuffled;
        RETURN;
    END

    -- ============================================================
    -- FASE 2: EMPAREJAR CLASES - HORARIOS
    --   Formula: c.rn = h.rn % TC
    --   Garantiza horarios unicos en cada tupla
    -- ============================================================
    CREATE TABLE #tuplas (
        idTupla INT IDENTITY(0, 1) PRIMARY KEY,  -- base 0 para modulo
        fkClase INT NOT NULL,
        cupoMaximo INT NOT NULL,
        nombreClase NVARCHAR(100),
        fkHorario INT NOT NULL,
        fkEntrenador NVARCHAR(450) NULL          -- se asigna en FASE 3
    );

    INSERT INTO #tuplas (fkClase, cupoMaximo, nombreClase, fkHorario)
    SELECT c.ClaseID, c.cupoMaximo, c.NombreClase, h.idHora
    FROM #horariosHoy h
    INNER JOIN #clasesActivas c ON c.rn = h.rn % @totalClases
    ORDER BY h.rn;

    DECLARE @totalTuplas INT;
    SELECT @totalTuplas = COUNT(*) FROM #tuplas;

    -- ============================================================
    -- FASE 3: ASIGNAR INSTRUCTORES A LAS TUPLAS
    --   Round-robin con orden aleatorio
    --   Cada tupla tiene horario UNICO -> no puede violar el indice
    -- ============================================================
    UPDATE t
    SET t.fkEntrenador = i.UsuarioID
    FROM #tuplas t
    INNER JOIN #instructoresShuffled i ON i.rn = t.idTupla % @totalInstructores;

    -- ============================================================
    -- 6. EJECUTAR: registrar cada clase programada
    --    (cursor sobre las tuplas con instructor ya asignado)
    -- ============================================================
    DECLARE @fkClase INT,
            @cupoMaximo INT,
            @nombreClase NVARCHAR(100),
            @fkHorario INT,
            @fkEntrenador NVARCHAR(450);

    DECLARE @creadas INT = 0;
    DECLARE @datos dbo.DatosClaseProgramada;

    DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
        SELECT fkClase, cupoMaximo, nombreClase, fkHorario, fkEntrenador
        FROM #tuplas;

    OPEN cur;
    FETCH NEXT FROM cur INTO @fkClase, @cupoMaximo, @nombreClase, @fkHorario, @fkEntrenador;

    -- Transaccion: todo o nada
    BEGIN TRANSACTION;

    BEGIN TRY
        WHILE @@FETCH_STATUS = 0
        BEGIN
            DELETE FROM @datos;

            INSERT INTO @datos (
                fkClase, fkEntrenador, cupoMaximo, fkEstadoClaseProgramada,
                fechaDeLaClase, idUsuarioQueReserva, fkHoraLaboral, idPreservaDeHorario
            )
            VALUES (
                @fkClase, @fkEntrenador, @cupoMaximo, @idEstadoDisponible,
                @hoy, NULL, CAST(@fkHorario AS NVARCHAR(10)), NULL
            );

            EXEC dbo.sp_registrarClaseProgramada @datos;

            SET @creadas = @creadas + 1;
            PRINT 'Creada: ' + @nombreClase
                + ' (instructor: ' + @fkEntrenador
                + ', horario: ' + CAST(@fkHorario AS VARCHAR) + ')';

            FETCH NEXT FROM cur INTO @fkClase, @cupoMaximo, @nombreClase, @fkHorario, @fkEntrenador;
        END

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        DECLARE @mensajeErrorGral NVARCHAR(MAX);
        SET @mensajeErrorGral = 'Error en ' + @nombreSP
            + '. Clase actual: ' + ISNULL(@nombreClase, 'N/A')
            + ' (ID: ' + ISNULL(CAST(@fkClase AS VARCHAR), 'N/A') + '). '
            + 'Mensaje: ' + ISNULL(ERROR_MESSAGE(), 'Sin mensaje')
            + ' (Linea: ' + CAST(ISNULL(ERROR_LINE(), 0) AS VARCHAR) + ')';

        DECLARE @severidadGral INT = ERROR_SEVERITY();
        DECLARE @estadoGral INT = ERROR_STATE();

        EXEC dbo.sp_RegistrarError
            @Procedimiento = @nombreSP,
            @Mensaje = @mensajeErrorGral,
            @Severidad = @severidadGral,
            @Estado = @estadoGral;

        PRINT 'ERROR: ' + @mensajeErrorGral;

        THROW;
    END CATCH

    CLOSE cur;
    DEALLOCATE cur;

    -- ============================================================
    -- 7. Resumen final
    -- ============================================================
    DECLARE @duracion INT = DATEDIFF(SECOND, @fechaInicio, GETDATE());

    PRINT '';
    PRINT REPLICATE('=', 42);
    PRINT 'RESUMEN - ' + CONVERT(VARCHAR, @hoy, 103);
    PRINT REPLICATE('=', 42);
    PRINT 'Clases activas disponibles: ' + CAST(@totalClases AS VARCHAR);
    PRINT 'Horarios disponibles:       ' + CAST(@totalHorarios AS VARCHAR);
    PRINT 'Instructores disponibles:   ' + CAST(@totalInstructores AS VARCHAR);
    PRINT 'Tuplas generadas:           ' + CAST(@totalTuplas AS VARCHAR);
    PRINT 'Creadas:                    ' + CAST(@creadas AS VARCHAR);
    PRINT 'Duracion:                   ' + CAST(@duracion AS VARCHAR) + 's';
    PRINT REPLICATE('=', 42);

    -- Limpiar temp tables
    DROP TABLE #clasesActivas;
    DROP TABLE #horariosDelMes;
    DROP TABLE #horariosHoy;
    DROP TABLE #instructoresDisponibles;
    DROP TABLE #instructoresShuffled;
    DROP TABLE #tuplas;

END;

