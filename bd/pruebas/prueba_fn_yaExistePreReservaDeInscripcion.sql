-- =============================================
-- Script de prueba: fn_yaExistePreReservaDeInscripcion
-- Objetivo: Verificar que la función detecta pre-reservas
--           duplicadas por cliente, clase, fecha, hora e instructor.
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
DECLARE @idPreReserva INT;
DECLARE @yaExiste BIT;

DECLARE @datos dbo.DatosClaseProgramada;
DECLARE @idsHorasLaborales dbo.IdsHorasLaborales;

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
-- 6. REGISTRAR CLASE PROGRAMADA
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
    10,
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

-- Preparar tabla de horas laborales para la función
INSERT INTO @idsHorasLaborales (fkHoraLaboral) VALUES (@idHora);

-- ------------------------------------------------
-- 7. PRUEBA 1: Sin pre-reserva previa → debe retornar 0
-- ------------------------------------------------
SET @yaExiste = dbo.fn_yaExistePreReservaDeInscripcion(
    @idClase,
    @idEntrenador,
    @fechaDisponible,
    @idCliente,
    @idsHorasLaborales
);

PRINT 'Prueba 1 (sin pre-reserva): ' + CAST(@yaExiste AS VARCHAR(1)) + ' (esperado: 0)';

IF @yaExiste <> 0
BEGIN
    RAISERROR('ERROR: Se esperaba 0 sin pre-reserva previa.', 16, 1);
    RETURN;
END

-- ------------------------------------------------
-- 8. INSERTAR PRE-RESERVA DE PRUEBA
-- ------------------------------------------------
INSERT INTO preReservasDeHorario (
    fkHoraLaboral,
    idUsuarioQueReserva,
    fechaReservada,
    fechaInicioDeLaReserva,
    fechaDeExpiracionDeLaReserva,
    idClase,
    fechaDeLaClase,
    idEntrenador
)
VALUES (
    @idHora,
    @idCliente,
    @fechaDisponible,
    GETDATE(),
    DATEADD(MINUTE, 5, GETDATE()),
    @idClase,
    @fechaDisponible,
    @idEntrenador
);

SET @idPreReserva = SCOPE_IDENTITY();
PRINT 'Pre-reserva insertada: ' + CAST(@idPreReserva AS VARCHAR(10));

-- ------------------------------------------------
-- 9. PRUEBA 2: Con pre-reserva del mismo cliente → debe retornar 1
-- ------------------------------------------------
SET @yaExiste = dbo.fn_yaExistePreReservaDeInscripcion(
    @idClase,
    @idEntrenador,
    @fechaDisponible,
    @idCliente,
    @idsHorasLaborales
);

PRINT 'Prueba 2 (mismo cliente): ' + CAST(@yaExiste AS VARCHAR(1)) + ' (esperado: 1)';

IF @yaExiste <> 1
BEGIN
    RAISERROR('ERROR: Se esperaba 1 con pre-reserva del mismo cliente.', 16, 1);
    RETURN;
END

-- ------------------------------------------------
-- 10. PRUEBA 3: Con otro cliente → debe retornar 0
-- ------------------------------------------------
SET @yaExiste = dbo.fn_yaExistePreReservaDeInscripcion(
    @idClase,
    @idEntrenador,
    @fechaDisponible,
    @idCliente2,
    @idsHorasLaborales
);

PRINT 'Prueba 3 (otro cliente): ' + CAST(@yaExiste AS VARCHAR(1)) + ' (esperado: 0)';

IF @yaExiste <> 0
BEGIN
    RAISERROR('ERROR: Se esperaba 0 con otro cliente.', 16, 1);
    RETURN;
END

-- ------------------------------------------------
-- 11. LIMPIEZA
-- ------------------------------------------------
DELETE FROM preReservasDeHorario WHERE idPreReserva = @idPreReserva;
DELETE FROM horariosDeClasesProgramadas WHERE fkClaseProgramada = @idClaseProgramada;
DELETE FROM clasesProgramadas WHERE idProgramacionClase = @idClaseProgramada;

PRINT 'Limpieza completada.';
PRINT 'Todas las pruebas pasaron correctamente.';

GO
