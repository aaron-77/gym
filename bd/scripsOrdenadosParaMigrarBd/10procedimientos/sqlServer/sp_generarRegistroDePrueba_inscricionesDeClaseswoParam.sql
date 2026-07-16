-- =============================================
-- Author:		Generated
-- Create date: 2026-07-13
-- Description:	Registra una inscripción de prueba a una clase programada para un cliente.
--              Valida existencia del cliente, disponibilidad de la clase, cupo disponible
--              y que el cliente no esté ya inscrito de forma vigente.
--              Devuelve el ID de inscripción generada como parámetro de salida.
-- =============================================
CREATE PROCEDURE dbo.sp_generarRegistroDePrueba_inscricionesDeClaseswoParam
(
    @idCliente NVARCHAR(450),
    @idClaseProgramada INT,
    @idInscripcionGenerada INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- =============================================
        -- VALIDACIONES
        -- =============================================

        -- Validar que los parámetros no sean nulos o vacíos
        IF @idCliente IS NULL OR @idCliente = ''
        BEGIN
            THROW 51000, 'El id del cliente es requerido.', 1;
        END

        IF @idClaseProgramada IS NULL OR @idClaseProgramada <= 0
        BEGIN
            THROW 51000, 'El id de la clase programada es requerido y debe ser mayor a 0.', 1;
        END

        -- Validar que el cliente exista en AspNetUsers
        IF NOT EXISTS (SELECT 1 FROM FitnessCenterDB.dbo.AspNetUsers WHERE Id = @idCliente)
        BEGIN
            THROW 51000, 'El cliente especificado no existe en el sistema.', 1;
        END

        -- Validar que la clase programada exista y esté disponible
        IF NOT EXISTS (
            SELECT 1 
            FROM FitnessCenterDB.dbo.clasesProgramadas cp
            WHERE cp.idProgramacionClase = @idClaseProgramada
              AND cp.fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM v_idEstadoDisponibleClasesProgramadas)
        )
        BEGIN
            THROW 51000, 'La clase programada no existe o no está disponible.', 1;
        END

        -- Validar que haya cupo disponible
        IF dbo.fn_cupoDisponibleClaseProgramada(@idClaseProgramada) <= 0
        BEGIN
            THROW 51000, 'La clase programada no tiene cupo disponible.', 1;
        END

        -- Validar que el cliente no esté ya inscrito de forma vigente
        IF EXISTS (
            SELECT 1 
            FROM FitnessCenterDB.dbo.inscripcionesDeClases ic
            WHERE ic.fkCliente = @idCliente
              AND ic.fkProgramacionClase = @idClaseProgramada
              AND ic.fkEstadoInscripcion = (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase)
        )
        BEGIN
            THROW 51000, 'El cliente ya está inscrito de forma vigente a esta clase programada.', 1;
        END

        -- =============================================
        -- REGISTRO DE LA INSCRIPCIÓN
        -- =============================================

        BEGIN TRANSACTION;

        DECLARE @idEstatusActivoDeInscripcion INT = 
            (SELECT idEstadoInscripcion FROM v_idEstadoVigenteInscripcionAClase);

        INSERT INTO FitnessCenterDB.dbo.inscripcionesDeClases
        (
            fkCliente,
            fkProgramacionClase,
            fechaDeInscripcion,
            fkEstadoInscripcion
        )
        VALUES
        (
            @idCliente,
            @idClaseProgramada,
            GETDATE(),
            @idEstatusActivoDeInscripcion
        );

        -- Devolver el ID de la inscripción generada como OUTPUT
        SET @idInscripcionGenerada = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

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
