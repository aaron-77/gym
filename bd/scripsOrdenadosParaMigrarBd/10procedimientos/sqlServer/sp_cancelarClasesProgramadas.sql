-- =============================================
-- PROCEDURE: sp_cancelarClasesProgramadas
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE PROCEDURE [dbo].[sp_cancelarClasesProgramadas]
    @idClaseProgramada int =null,
	@fechaDeReferencia DATE = null,
    @idEntrenador nvarchar(450) = null,
    @idClase int = null
AS
BEGIN
    SET NOCOUNT ON;
    declare @idsClasesCanceladas ListadoIdsGenericos; 
   -- Si la fechaDeReferencia es NULL, se establece como la fecha actual
    
   --si no se da ua fecha se toma como referencia la fecha actual
   if @fechaDeReferencia is null
   begin
   	 set  @fechaDeReferencia = GETDATE();
   end
   
   IF @idClaseProgramada is not null
   BEGIN
   		insert into @idsClasesCanceladas(id)
   		select idProgramacionClase 
   		from clasesProgramadas cp 
		WHERE cp.fkEstadoClaseProgramada =  (select idEstadoClaseProgramada 
		  								from v_idEstadoDisponibleClasesProgramadas)
		and cp.idProgramacionClase = @idClaseProgramada
   END
   ELSE
   	BEGIN
   		IF @fechadeReferencia = GETDATE() and @idEntrenador is null and @idClase is null
		    BEGIN
			    PRINT 'FECHA POR DEFECTO';
		    	insert into @idsClasesCanceladas
		    	select idProgramacionClase  
		   		from clasesProgramadas cp	
		   		join horariosDeClasesProgramadas hdcp on cp.idProgramacionClase = hdcp.fkClaseProgramada 
		  		where hdcp.fechaDeLaClase  >= @fechaDeReferencia 
		  			and cp.fkEstadoClaseProgramada = (select idEstadoClaseProgramada 
		  								from v_idEstadoDisponibleClasesProgramadas)
		    END
		    ELSE 
		    BEGIN
			    PRINT 'FECHA CUSTOM'+CAST(@fechaDeReferencia as  nvarchar(20));
		    	insert into @idsClasesCanceladas
		    	select idProgramacionClase  
		   		from clasesProgramadas cp	
		   		join horariosDeClasesProgramadas 
		   		hdcp on cp.idProgramacionClase = hdcp.fkClaseProgramada 
		  		where 
		  		((@fechaDeReferencia is null 
		  		or hdcp.fechaDeLaClase  = @fechaDeReferencia)
		  			and (@idEntrenador is null or cp.fkEntrenador  = @idEntrenador)
		  			and (@idClase is null or cp.fkClase  = @idClase))
		  			and cp.fkEstadoClaseProgramada = (select idEstadoClaseProgramada 
		  								from v_idEstadoDisponibleClasesProgramadas)
		    END
   	END
   
   	if not exists (select 1 from @idsClasesCanceladas)
   	begin
   		THROW 51000, 'No se encontraron clases activas para cancelar', 1;
   	end
   	
    --Actualizar el estado de las clases programadas a 'Cancelada' para la fecha especificada
    UPDATE FitnessCenterDB.dbo.clasesProgramadas
    SET fkEstadoClaseProgramada = (SELECT idEstadoClaseProgramada FROM FitnessCenterDB.dbo.estadosClasesProgramadas WHERE nombresEstado = 'cancelada')
    WHERE idProgramacionClase in (select * from @idsClasesCanceladas);

    select * from @idsClasesCanceladas;
END;

-- Modified stored procedure adapted to schema V6

GO
