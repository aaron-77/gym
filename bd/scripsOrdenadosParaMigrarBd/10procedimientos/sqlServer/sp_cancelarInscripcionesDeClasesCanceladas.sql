-- =============================================
-- PROCEDURE: sp_cancelarInscripcionesDeClasesCanceladas
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE dbo.sp_cancelarInscripcionesDeClasesCanceladas(
    @idsClasesProgramadasCanceladas ListadoIdsGenericos READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;
    -- Actualizar el estado de las clases programadas a 'Cancelada' para la fecha especificada
    UPDATE FitnessCenterDB.dbo.inscripcionesDeClases 
    SET fkEstadoInscripcion = (SELECT top 1 idEstadoInscripcion 
    							FROM FitnessCenterDB.dbo.estadosInscripciones ei 
    							WHERE ei.nombreEstadoInscripcion = 'cancelada'
    						   )
    WHERE fkProgramacionClase in (select * from @idsClasesProgramadasCanceladas);
END;

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	consulta todos los clientes con el estado asignado en el parametro
-- =============================================

GO
