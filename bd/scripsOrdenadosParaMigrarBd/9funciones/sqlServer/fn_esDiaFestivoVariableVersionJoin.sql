-- =============================================
-- FUNCTION: fn_esDiaFestivoVariableVersionJoin
-- Fuente: FitnessGymSchemaV8 (procedimientosYFuncionesOneFileV8.sql)
-- =============================================

CREATE FUNCTION dbo.fn_esDiaFestivoVariableVersionJoin (
    @fechaAnalizada DATE,                   -- Fecha a comprobar
    @diaDeFechaVariable INT,                -- Interpretación según los parámetros disponibles
    @semanaDeFechaVariable INT = NULL,      -- Semana del mes (1-4) o semana del año (1-52)
    @mesDeFechaVariable INT = NULL,         -- Mes (1-12)
    @idTipoDeRecurrencia INT = NULL         -- ID del tipo de recurrencia
)
RETURNS nvarchar(max)
AS
BEGIN
-- ////TODO VALIDAR QUE EL NUMERO DE SEMANA SEA VALIDO PARA EL MES,EN ALGUNOS HAY SEMANA 5 PERO EN FEBRERO NO
-----//////////////////////////////////////////////////////////////////////
    

	DECLARE @resultado BIT = 0;
    DECLARE @anioActual INT = YEAR(@fechaAnalizada);
    DECLARE @nombreTipoDeRecurrencia NVARCHAR(50) = NULL;
    
    -- Obtener el nombre del tipo de recurrencia si se proporciona un ID
    IF @idTipoDeRecurrencia IS NOT NULL
    BEGIN
        SET @nombreTipoDeRecurrencia = dbo.fn_obtenerNombreTipoDeRecurrencia(@idTipoDeRecurrencia);
    END
    
    -- CASO 1:dia festivo anual con fecha variable (ej: "el segundo lunes de enero del año")
    IF @diaDeFechaVariable IS NOT NULL 
       AND @semanaDeFechaVariable IS NOT NULL 
       AND @mesDeFechaVariable IS NOT NULL
    BEGIN
        -- Solo proceder si la fecha analizada está en el mes especificado
        IF MONTH(@fechaAnalizada) = @mesDeFechaVariable
        BEGIN
            -- Primer día del mes especificado
            DECLARE @primerDiaMes_caso1 DATE = DATEFROMPARTS(@anioActual, @mesDeFechaVariable, 1);
            
            -- Encontrar el primer día de la semana especificado (@diaDeFechaVariable) en el mes
            DECLARE @primerDiaSemanaEnMes_caso1 DATE = @primerDiaMes_caso1;
            WHILE (DATEPART(dw, @primerDiaSemanaEnMes_caso1) != @diaDeFechaVariable)
            BEGIN
                SET @primerDiaSemanaEnMes_caso1 = DATEADD(DAY, 1, @primerDiaSemanaEnMes_caso1);
            END
            
            -- Calcular el día festivo sumando las semanas necesarias
            DECLARE @diaFestivo_caso1 DATE = DATEADD(WEEK, @semanaDeFechaVariable - 1, @primerDiaSemanaEnMes_caso1);
            
            -- Verificar que sigue estando en el mismo mes
            IF MONTH(@diaFestivo_caso1) = @mesDeFechaVariable
            BEGIN
                -- Comprobar si la fecha analizada coincide con el día festivo calculado
                IF @fechaAnalizada = @diaFestivo_caso1
                BEGIN
                    SET @resultado = 1;
                END
            END
        END
    END
    

    -- CASO 2:  dia festivo de acuerdo a al numero consecutivo de la semana en el año (1-52),(ej: "día 2 de la semana 15 del año")
    ELSE IF @diaDeFechaVariable IS NOT NULL 
            AND @semanaDeFechaVariable IS NOT NULL
            AND @mesDeFechaVariable IS NULL
            AND @nombreTipoDeRecurrencia = 'diaSemana'
    BEGIN
        -- Primer día del año actual
        DECLARE @primerDiaAnio_caso2 DATE = DATEFROMPARTS(@anioActual, 1, 1);
        
        -- Calcular la fecha de inicio de la semana especificada
        DECLARE @inicioDeSemana_caso2 DATE = DATEADD(WEEK, @semanaDeFechaVariable - 1, @primerDiaAnio_caso2);
        
        -- Ajustar al primer día de la semana (asumiendo que 1 = domingo en DATEPART)
        WHILE (DATEPART(dw, @inicioDeSemana_caso2) != 1)
        BEGIN
            SET @inicioDeSemana_caso2 = DATEADD(DAY, -1, @inicioDeSemana_caso2);
        END
        
        -- Calcular el día específico dentro de esa semana
        DECLARE @diaEspecifico_caso2 DATE = DATEADD(DAY, @diaDeFechaVariable - 1, @inicioDeSemana_caso2);
        
        -- Verificar si coincide con la fecha analizada
        IF @fechaAnalizada = @diaEspecifico_caso2
        BEGIN
            SET @resultado = 1;
        END
    END

    --CASO 3 MENSUAL,un dia especifico de una semana especifica de cualquier mes
    ELSE IF @diaDeFechaVariable IS NOT NULL 
       AND @semanaDeFechaVariable IS NOT NULL 
       AND @mesDeFechaVariable IS NULL
       AND @nombreTipoDeRecurrencia = 'mensual'
    BEGIN
	        
        -- Primer día del mes especificado
        DECLARE @primerDiaMes_caso3 DATE = DATEFROMPARTS(@anioActual, MONTH(@fechaAnalizada), 1);
            

	       
       	-- Encontrar el primer día de la semana que sea igual a @diaDeFechaVariable en el mes
            DECLARE @primerDiaSemanaEnMes_caso3 DATE = @primerDiaMes_caso3;

           WHILE (DATEPART(dw, @primerDiaSemanaEnMes_caso3) != @diaDeFechaVariable)
            BEGIN
                SET @primerDiaSemanaEnMes_caso3 = DATEADD(DAY, 1, @primerDiaSemanaEnMes_caso3);
            END
                       
        
            -- Calcular el día festivo sumando las semanas necesarias
            DECLARE @diaFestivo_caso3 DATE = DATEADD(WEEK, @semanaDeFechaVariable - 1, @primerDiaSemanaEnMes_caso3);
        
        --RETURN CONVERT(NVARCHAR(10), @diaFestivo_caso3, 23) + CONVERT(NVARCHAR(10), @fechaAnalizada, 23);
           IF @fechaAnalizada = @diaFestivo_caso3
                BEGIN
	    
                    SET @resultado = 1;
                END 
        
            
    END
    
    -- CASO 4 solo dia y mes tienen valor,la fecha festiva es mensual 
    --un dia espeficico de cualquier mes(dia 1-31) 
    ELSE IF @diaDeFechaVariable IS NOT NULL 
               AND @mesDeFechaVariable IS NULL 
               AND @semanaDeFechaVariable IS NULL
               AND @nombreTipoDeRecurrencia = 'mensual'
        BEGIN
            DECLARE @fechaFestiva_caso4 DATE = DATEFROMPARTS(YEAR(@fechaAnalizada), MONTH(@fechaAnalizada), @diaDeFechaVariable);
            IF @fechaFestiva_caso4 = @fechaAnalizada
            BEGIN
                SET @resultado = 1;
            END   
        END
    
    -- CASO 5: Solo día tiene valor y el tipo es relativo (ej: "todos los martes")
    ELSE IF @diaDeFechaVariable IS NOT NULL 
            AND @semanaDeFechaVariable IS NULL
            AND @mesDeFechaVariable IS NULL
            AND @nombreTipoDeRecurrencia = 'diaRelativo'
    BEGIN
        -- Verificar si el día de la semana coincide
        IF DATEPART(dw, @fechaAnalizada) = @diaDeFechaVariable
        BEGIN
            SET @resultado = 1;
        END
    END
    
    -- CASO 6: Solo día tiene valor y el tipo es consecutivo (ej: "día 100 del año")
    ELSE IF @diaDeFechaVariable IS NOT NULL 
            AND @semanaDeFechaVariable IS NULL
            AND @mesDeFechaVariable IS NULL
            AND @nombreTipoDeRecurrencia = 'diaConsecutivo'
    BEGIN
        -- Calcular el día especificado dentro del año
        DECLARE @diaDelAnio_caso6 DATE = DATEADD(DAY, @diaDeFechaVariable - 1, DATEFROMPARTS(@anioActual, 1, 1));
        
        -- Verificar si coincide con la fecha analizada
        IF @fechaAnalizada = @diaDelAnio_caso6
        BEGIN
            SET @resultado = 1;
        END
    END
    
    RETURN @resultado;
END;

GO
