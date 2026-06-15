-- =============================================
-- PROCEDURE: sp_obtenerMetasDeMedidas
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_obtenerMetasDeMedidas]
    @idCliente nvarchar(450),
    @idParametro INT,
    @idEjercicio INT = NULL,
    @datosDeMedida DatosObtencionMetasDeMedida READONLY
AS
BEGIN
    SET NOCOUNT ON;

    
    BEGIN TRY
    declare @mesExtracted int,@añoExtracted int;
   select @mesExtracted = mes,@añoExtracted = año from @datosDeMedida; 
	INSERT INTO LogErrores (procedimiento, mensaje, severidad, estado)
        VALUES ('sp_obtenerMetasDeMedidas', 
        concat(
        'idCliente ',
        @idCliente,
       	' Parametro: ',
      	@idParametro,
     	' Ejercicio: ',
    	@idEjercicio,
   		' mes ',
  		@mesExtracted,
  		' año ',
  		@añoExtracted
  		)
  		,
  		1
 		,
 		3
		);

    -- Selección de los datos requeridos
    SELECT 
        distinct m.metaId,
        i.nombre AS intencion,
        pm.nombre AS nombreParametro,
        e.NombreEjercicio AS nombreEjercicio,
        m.valorObjetivo,
        nl.nombre AS nombreNivelDeLogro,
        m.fechaDeInicioDeLaMeta ,
        m.fechaLimite,
        m.fkEjercicio,
        m.fkParametro,
        m.fkUsuario
    FROM metas m
    LEFT JOIN intenciones i ON m.fkIntencion = i.intencionId
    INNER JOIN parametrosDeMedicion pm ON m.fkParametro = pm.parametroMedicionId 
    LEFT JOIN ejercicios e ON m.fkEjercicio = e.EjercicioID 
    INNER JOIN nivelesDeLogro nl ON m.fkNivelDeLogro = nl.idNivelDeLogro 
    --INNER JOIN medidas md ON pm.parametroMedicionId = md.fkParametro 
    INNER JOIN @datosDeMedida dm ON MONTH(m.fechaDeInicioDeLaMeta) = dm.mes AND YEAR(m.fechaDeInicioDeLaMeta) = dm.año
    WHERE m.fkUsuario = @idCliente
      AND m.fkParametro = @idParametro
      AND (m.fkEjercicio = @idEjercicio OR @idEjercicio IS NULL);
  END TRY
  BEGIN CATCH
        -- Capturar información del error
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Registrar el error en una tabla de logs (opcional)
        INSERT INTO LogErrores (procedimiento, mensaje, severidad, estado)
        VALUES ('sp_obtenerMetasDeMedidas', @ErrorMessage, @ErrorSeverity, @ErrorState);

        -- Relanzar el error para que sea visible en la aplicación
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;

END;

CREATE PROCEDURE sp_obtenerParametrosDeMedicionConUnidad
AS
BEGIN
    SELECT 
        pm.parametroMedicionId,
        pm.nombre,
        pum.fkUnidadDeMedida,
        um.nombre AS nombreUnidadDeMedida,
        pm.fkICon
    FROM parametrosDeMedicion pm
    JOIN parametros_unidadesDeMedida pum ON pm.parametroMedicionId = pum.fkParametroDeMedicion
    JOIN unidadesDeMedida um ON pum.fkUnidadDeMedida = um.unidadDeMedidaId
    ORDER BY pm.nombre;
END;

GO
