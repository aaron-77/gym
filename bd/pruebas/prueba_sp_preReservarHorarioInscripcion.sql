use fitnessCenterDB
-- =============================================
-- Script de prueba: sp_preReservarHorarioInscripcion
-- Objetivo: Verificar que el SP crea pre-reservas para inscripciones
--           solo cuando hay cupo y el cliente no tiene una pre-reserva vigente.
-- =============================================

SET NOCOUNT ON;

-- ------------------------------------------------
-- 1. DECLARACIÓN DE VARIABLES
-- ------------------------------------------------
DECLARE @fechaDePrueba DATE = DATEADD(DAY, 1, CAST(GETDATE() AS DATE));
DECLARE @idClase INT;
DECLARE @idEntrenador NVARCHAR(450);
DECLARE @idCliente NVARCHAR(450);
DECLARE @idCliente2 NVARCHAR(450);
DECLARE @idHora INT;
DECLARE @horaInicio TIME;
DECLARE @fechaDisponible DATE;
DECLARE @fechaHoraReferencia DATETIME2;
DECLARE @idClaseProgramada INT;
DECLARE @idPreReserva1 INT;
DECLARE @idPreReserva2 INT;
DECLARE @idInscripcion INT;
DECLARE @idEstadoVigente INT;
DECLARE @idPrereservaOut INT;

DECLARE @datos dbo.DatosClaseProgramada;

-- ------------------------------------------------
-- 2. OBTENER CLASE VÁLIDA
-- ------------------------------------------------
SELECT TOP 1 @idClase = ClaseID FROM Clases ORDER BY ClaseID;
IF @idClase IS NULL
BEGIN
    RAISERROR('No existe ninguna clase en la tabla Clases.', 16, 1);
    RETURN;
END

PRINT 'Clase seleccionada: ' + CAST(@idClase AS VARCHAR(10));

-- ------------------------------------------------
-- 3. OBTENER HORARIO DISPONIBLE
-- ------------------------------------------------
DECLARE @horarios TABLE (
    DiaDeLaSemana NVARCHAR(50),
    FechaDisponible DATE,
    horaInicio TIME,
    horaFin TIME,
    idHora INT,
    TipoDeDia NVARCHAR(50)
);

INSERT INTO @horarios
EXEC sp_obtenerHorariosDisponibles @Fecha = @fechaDePrueba;

SELECT TOP 1 
    @idHora = idHora,
    @horaInicio = horaInicio,
    @fechaDisponible = FechaDisponible
FROM @horarios
ORDER BY FechaDisponible, horaInicio;

IF @idHora IS NULL
BEGIN
    RAISERROR('No hay horarios disponibles para la fecha de prueba.', 16, 1);
    RETURN;
END

PRINT 'Horario seleccionado: idHora=' + CAST(@idHora AS VARCHAR(10)) + ', horaInicio=' + CAST(@horaInicio AS VARCHAR(10));

-- ------------------------------------------------
-- 4. OBTENER ENTRENADOR DISPONIBLE (seguro)
-- ------------------------------------------------
SET @fechaHoraReferencia = DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', @horaInicio), CAST(@fechaDisponible AS DATETIME2));

DECLARE @entrenadores TABLE (
    UsuarioID NVARCHAR(450),
    Nombre NVARCHAR(MAX),
    Apellido NVARCHAR(50),
    Email NVARCHAR(256),
    Telefono NVARCHAR(MAX),
    NombreUsuario NVARCHAR(256),
    FechaNacimiento DATETIME2,
    FechaRegistro DATETIME2,
    RolID NVARCHAR(450),
    Estado NVARCHAR(50)
);

INSERT INTO @entrenadores
EXEC sp_obtenerEntrenadoresDisponibles @fechaReferencia = @fechaHoraReferencia;

SELECT TOP 1 @idEntrenador = UsuarioID FROM @entrenadores;

IF @idEntrenador IS NULL
BEGIN
    RAISERROR('No hay entrenadores disponibles para la fecha/hora de prueba.', 16, 1);
    RETURN;
END

PRINT 'Entrenador seleccionado: ' + @idEntrenador;

-- ------------------------------------------------
-- 5. OBTENER CLIENTES DE PRUEBA
-- ------------------------------------------------
SELECT TOP 1 @idCliente = u.Id
FROM AspNetUsers u
INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId
INNER JOIN AspNetRoles ar ON ur.RoleId = ar.Id
WHERE ar.Name = 'Cliente'
ORDER BY u.Id;

SELECT TOP 1 @idCliente2 = u.Id
FROM AspNetUsers u
INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId
INNER JOIN AspNetRoles ar ON ur.RoleId = ar.Id
WHERE ar.Name = 'Cliente'
  AND u.Id <> @idCliente
ORDER BY u.Id;

IF @idCliente IS NULL OR @idCliente2 IS NULL
BEGIN
    RAISERROR('No se encontraron suficientes clientes de prueba.', 16, 1);
    RETURN;
END

PRINT 'Clientes seleccionados: ' + @idCliente + ' y ' + @idCliente2;

-- ------------------------------------------------
-- 6. OBTENER ESTADO VIGENTE DE INSCRIPCIONES
-- ------------------------------------------------
SELECT TOP 1 @idEstadoVigente = idEstadoInscripcion
FROM estadosInscripciones
WHERE LOWER(nombreEstadoInscripcion) = 'vigente';

IF @idEstadoVigente IS NULL
BEGIN
    RAISERROR('No se encontro el estado "Vigente" en estadosInscripciones.', 16, 1);
    RETURN;
END

PRINT 'Estado vigente de inscripcion: ' + CAST(@idEstadoVigente AS VARCHAR(10));

-- ------------------------------------------------
-- 7. REGISTRAR CLASE PROGRAMADA (cupo = 1)
-- ------------------------------------------------
INSERT INTO @datos (
    fkClase,
    fkEntrenador,
    cupoMaximo,
    fkEstadoClaseProgramada,
    fechaDeLaClase,
    idUsuarioQueReserva,
    fkHoraLaboral,
    idPreservaDeHorario
)
VALUES (
    @idClase,
    @idEntrenador,
    1,                  -- cupo = 1 para facilitar prueba de sin cupo
    1,                  -- estado activo/disponible
    @fechaDisponible,
    @idCliente,
    CAST(@idHora AS NVARCHAR(MAX)),
    NULL
);

DECLARE @resultadoClase TABLE (IdClaseProgramada INT);
INSERT INTO @resultadoClase
EXEC sp_registrarClaseProgramada @datos;

SELECT @idClaseProgramada = IdClaseProgramada FROM @resultadoClase;

IF @idClaseProgramada IS NULL
BEGIN
    RAISERROR('No se pudo registrar la clase programada de prueba.', 16, 1);
    RETURN;
END

PRINT 'Clase programada registrada: ' + CAST(@idClaseProgramada AS VARCHAR(10));

-- ------------------------------------------------
-- 8. PRUEBA 1: Cupo disponible, sin duplicados → éxito
-- ------------------------------------------------
EXEC sp_preReservarHorarioInscripcion
    @idUsuarioQueReserva = @idCliente,
    @fechaTentativa = @fechaDisponible,
    @idHoraLaboral = @idHora,
    @idClase = @idClase,
    @idEntrenador = @idEntrenador,
    @idClaseProgramada = @idClaseProgramada,
    @idPrereservaOut = @idPrereservaOut OUTPUT;

SET @idPreReserva1 = @idPrereservaOut;

PRINT 'Prueba 1 (crear pre-reserva): idPreReserva=' + CAST(@idPreReserva1 AS VARCHAR(10)) + ' (esperado: > 0)';

IF @idPreReserva1 IS NULL OR @idPreReserva1 <= 0
BEGIN
    RAISERROR('ERROR: No se creo la pre-reserva.', 16, 1);
    RETURN;
END

-- ------------------------------------------------
-- 9. PRUEBA 2: Mismo cliente, pre-reserva vigente duplicada → falla
-- ------------------------------------------------
BEGIN TRY
    EXEC sp_preReservarHorarioInscripcion
        @idUsuarioQueReserva = @idCliente,
        @fechaTentativa = @fechaDisponible,
        @idHoraLaboral = @idHora,
        @idClase = @idClase,
        @idEntrenador = @idEntrenador,
        @idClaseProgramada = @idClaseProgramada,
        @idPrereservaOut = @idPrereservaOut OUTPUT;

    RAISERROR('ERROR: Se esperaba que fallara por pre-reserva duplicada.', 16, 1);
    RETURN;
END TRY
BEGIN CATCH
    PRINT 'Prueba 2 OK: fallo como se esperaba - ' + ERROR_MESSAGE();
END CATCH

-- ------------------------------------------------
-- 10. PREPARAR PRUEBA 3: Llenar el cupo con una inscripcion
-- ------------------------------------------------
-- Eliminar la pre-reserva del cliente 1 para poder llenar el cupo
DELETE FROM preReservasDeHorario WHERE idPreReserva = @idPreReserva1;
SET @idPreReserva1 = NULL;

-- Insertar inscripcion vigente para ocupar el unico cupo
INSERT INTO inscripcionesDeClases (
    fkProgramacionClase,
    fechaDeInscripcion,
    fkEstadoInscripcion,
    fkCliente
)
VALUES (
    @idClaseProgramada,
    GETDATE(),
    @idEstadoVigente,
    @idCliente
);

SET @idInscripcion = SCOPE_IDENTITY();
PRINT 'Inscripcion de prueba insertada: ' + CAST(@idInscripcion AS VARCHAR(10));

-- ------------------------------------------------
-- 11. PRUEBA 3: Sin cupo disponible → falla
-- ------------------------------------------------
BEGIN TRY
    EXEC sp_preReservarHorarioInscripcion
        @idUsuarioQueReserva = @idCliente2,
        @fechaTentativa = @fechaDisponible,
        @idHoraLaboral = @idHora,
        @idClase = @idClase,
        @idEntrenador = @idEntrenador,
        @idClaseProgramada = @idClaseProgramada,
        @idPrereservaOut = @idPrereservaOut OUTPUT;

    RAISERROR('ERROR: Se esperaba que fallara por falta de cupo.', 16, 1);
    RETURN;
END TRY
BEGIN CATCH
    PRINT 'Prueba 3 OK: fallo como se esperaba - ' + ERROR_MESSAGE();
END CATCH

-- ------------------------------------------------
-- 12. LIMPIEZA
-- ------------------------------------------------
IF @idPreReserva1 IS NOT NULL
    DELETE FROM preReservasDeHorario WHERE idPreReserva = @idPreReserva1;

IF @idPreReserva2 IS NOT NULL
    DELETE FROM preReservasDeHorario WHERE idPreReserva = @idPreReserva2;

IF @idInscripcion IS NOT NULL
    DELETE FROM inscripcionesDeClases WHERE idInscripcion = @idInscripcion;

DELETE FROM horariosDeClasesProgramadas WHERE fkClaseProgramada = @idClaseProgramada;
DELETE FROM clasesProgramadas WHERE idProgramacionClase = @idClaseProgramada;

PRINT 'Limpieza completada.';
PRINT 'Todas las pruebas pasaron correctamente.';


