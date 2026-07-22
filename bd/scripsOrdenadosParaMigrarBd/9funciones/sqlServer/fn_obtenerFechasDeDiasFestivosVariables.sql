CREATE FUNCTION dbo.fn_obtenerFechasDeDiasFestivosVariables (
    @anio INT,
    @datosDeDiasFestivosVariables DatosDiaFestivoVariable READONLY
)
RETURNS @fechas TABLE (fechaExacta DATE)
AS
BEGIN
    DECLARE @dia INT, @semana INT, @mes INT, @idTipo INT;
    DECLARE @nombreTipo NVARCHAR(100);
    DECLARE @primerDiaMes DATE, @primerDiaSemana DATE, @fechaFestiva DATE;
    DECLARE @primerDiaAnio DATE, @inicioSemana DATE, @primeraOcurrencia DATE;
    DECLARE @ultimoDia INT, @m INT;

    DECLARE c CURSOR FOR
        SELECT diaDeFechaVariable, semanaDeFechaVariable, mesDeFechaVariable, idTipoDeRecurrencia
        FROM @datosDeDiasFestivosVariables;

    OPEN c;
    FETCH NEXT FROM c INTO @dia, @semana, @mes, @idTipo;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @nombreTipo = dbo.fn_obtenerNombreTipoDeRecurrencia(@idTipo);

        IF @dia IS NOT NULL AND @semana IS NOT NULL AND @mes IS NOT NULL
        BEGIN
            SET @primerDiaMes = DATEFROMPARTS(@anio, @mes, 1);
            SET @primerDiaSemana = @primerDiaMes;
            WHILE DATEPART(dw, @primerDiaSemana) != @dia
                SET @primerDiaSemana = DATEADD(DAY, 1, @primerDiaSemana);
            SET @fechaFestiva = DATEADD(WEEK, @semana - 1, @primerDiaSemana);
            IF MONTH(@fechaFestiva) = @mes
                INSERT INTO @fechas VALUES (@fechaFestiva);
        END
        ELSE IF @dia IS NOT NULL AND @semana IS NOT NULL AND @mes IS NULL AND @nombreTipo = 'diaSemana'
        BEGIN
            SET @primerDiaAnio = DATEFROMPARTS(@anio, 1, 1);
            SET @inicioSemana = DATEADD(WEEK, @semana - 1, @primerDiaAnio);
            WHILE DATEPART(dw, @inicioSemana) != 1
                SET @inicioSemana = DATEADD(DAY, -1, @inicioSemana);
            SET @fechaFestiva = DATEADD(DAY, @dia - 1, @inicioSemana);
            INSERT INTO @fechas VALUES (@fechaFestiva);
        END
        ELSE IF @dia IS NOT NULL AND @semana IS NOT NULL AND @mes IS NULL AND @nombreTipo = 'mensual'
        BEGIN
            SET @m = 1;
            WHILE @m <= 12
            BEGIN
                SET @primerDiaMes = DATEFROMPARTS(@anio, @m, 1);
                SET @primerDiaSemana = @primerDiaMes;
                WHILE DATEPART(dw, @primerDiaSemana) != @dia
                    SET @primerDiaSemana = DATEADD(DAY, 1, @primerDiaSemana);
                SET @fechaFestiva = DATEADD(WEEK, @semana - 1, @primerDiaSemana);
                IF MONTH(@fechaFestiva) = @m
                    INSERT INTO @fechas VALUES (@fechaFestiva);
                SET @m = @m + 1;
            END
        END
        ELSE IF @dia IS NOT NULL AND @semana IS NULL AND @mes IS NULL AND @nombreTipo = 'mensual'
        BEGIN
            SET @m = 1;
            WHILE @m <= 12
            BEGIN
                SET @ultimoDia = DAY(EOMONTH(DATEFROMPARTS(@anio, @m, 1)));
                IF @dia <= @ultimoDia
                BEGIN
                    SET @fechaFestiva = DATEFROMPARTS(@anio, @m, @dia);
                    INSERT INTO @fechas VALUES (@fechaFestiva);
                END
                SET @m = @m + 1;
            END
        END
        ELSE IF @dia IS NOT NULL AND @semana IS NULL AND @mes IS NULL AND @nombreTipo = 'diaRelativo'
        BEGIN
            SET @primerDiaAnio = DATEFROMPARTS(@anio, 1, 1);
            SET @primeraOcurrencia = @primerDiaAnio;
            WHILE DATEPART(dw, @primeraOcurrencia) != @dia
                SET @primeraOcurrencia = DATEADD(DAY, 1, @primeraOcurrencia);
            SET @fechaFestiva = @primeraOcurrencia;
            WHILE YEAR(@fechaFestiva) = @anio
            BEGIN
                INSERT INTO @fechas VALUES (@fechaFestiva);
                SET @fechaFestiva = DATEADD(DAY, 7, @fechaFestiva);
            END
        END
        ELSE IF @dia IS NOT NULL AND @semana IS NULL AND @mes IS NULL AND @nombreTipo = 'diaConsecutivo'
        BEGIN
            SET @fechaFestiva = DATEADD(DAY, @dia - 1, DATEFROMPARTS(@anio, 1, 1));
            IF YEAR(@fechaFestiva) = @anio
                INSERT INTO @fechas VALUES (@fechaFestiva);
        END

        FETCH NEXT FROM c INTO @dia, @semana, @mes, @idTipo;
    END

    CLOSE c;
    DEALLOCATE c;

    RETURN;
END;
GO
