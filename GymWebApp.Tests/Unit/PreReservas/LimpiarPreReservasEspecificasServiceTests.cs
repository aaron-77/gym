using FluentAssertions;
using Microsoft.Extensions.Logging;
using NSubstitute;
using Xunit;

using API.Services;
using API.Services.Validaciones;
using BL.Validaciones;
using DataAccess.EntityFramework;
using DataAccess.Repositories;

namespace GymWebApp.Tests.Unit.PreReservas;

/// <summary>
/// Tests unitarios (U1–U6, spec 83) para InscripcionesService.LimpiarPreReservasEspecificasAsync.
/// El repository se mockea con NSubstitute: NO hay SQL real ni acceso a BD. Se valida únicamente
/// la orquestación del wrapper (qué elimina, qué loguea y qué retorna) a partir de listas de
/// PreReservasDeHorario armadas a mano en el test.
/// </summary>
public class LimpiarPreReservasEspecificasServiceTests
{
    private readonly InscripcionesService _sut;
    private readonly IInscripcionRepository _mockRepository;
    private readonly ILogger<InscripcionesService> _mockLogger;
    private readonly IValidadorFechasInscripcionesYClasesProgramadas _mockValidadorFecha;
    private readonly IValidadorUsuarioExistente _mockValidadorUsuario;

    public LimpiarPreReservasEspecificasServiceTests()
    {
        _mockRepository = Substitute.For<IInscripcionRepository>();
        _mockLogger = Substitute.For<ILogger<InscripcionesService>>();
        _mockValidadorFecha = Substitute.For<IValidadorFechasInscripcionesYClasesProgramadas>();
        _mockValidadorUsuario = Substitute.For<IValidadorUsuarioExistente>();

        _sut = new InscripcionesService(_mockRepository, _mockLogger, _mockValidadorFecha, _mockValidadorUsuario);
    }

    [Fact]
    public async Task LimpiarPreReservasEspecificasAsync_SinPreReservas_RetornaTrueSinEliminar()
    {
        // Arrange
        // U1: el repository no encuentra pre-reservas → no hay nada que limpiar
        _mockRepository.EncontrarPreReservasAsync(Arg.Any<int>(), Arg.Any<DateOnly>(), Arg.Any<int>(), Arg.Any<string>())
            .Returns(new List<PreReservasDeHorario>());

        // Act
        var result = await _sut.LimpiarPreReservasEspecificasAsync(10, DateOnly.FromDateTime(DateTime.Now.AddDays(7)), 5, "entrenador-1");

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().BeTrue();
        result.message.Should().Be("No hay pre-reservas para limpiar");

        // Al no haber pre-reservas, el eliminator no debe invocarse
        await _mockRepository.DidNotReceive().EliminarPreReservasEspecificasAsync(Arg.Any<ICollection<int>>());

        _mockLogger.Received(1).Log(
            LogLevel.Information,
            Arg.Any<EventId>(),
            Arg.Is<object>(o => o.ToString()!.Contains("No hay pre-reservas para limpiar")),
            Arg.Any<Exception>(),
            Arg.Any<Func<object, Exception?, string>>());
    }

    [Fact]
    public async Task LimpiarPreReservasEspecificasAsync_TodasLasPreReservasSeEliminan_RetornaTrue()
    {
        // Arrange
        // U2: 2 pre-reservas válidas y el eliminator borra ambas → true
        var preReservas = new List<PreReservasDeHorario>
        {
            CrearPreReserva(1, "entrenador-1"),
            CrearPreReserva(2, "entrenador-1")
        };

        _mockRepository.EncontrarPreReservasAsync(Arg.Any<int>(), Arg.Any<DateOnly>(), Arg.Any<int>(), Arg.Any<string>())
            .Returns(preReservas);
        _mockRepository.EliminarPreReservasEspecificasAsync(Arg.Any<ICollection<int>>())
            .Returns(2);

        // Act
        var result = await _sut.LimpiarPreReservasEspecificasAsync(10, DateOnly.FromDateTime(DateTime.Now.AddDays(7)), 5, "entrenador-1");

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().BeTrue();
        result.message.Should().Be("Pre-reservas limpiadas correctamente");

        // Se pasan ambas ids al eliminator
        await _mockRepository.Received(1).EliminarPreReservasEspecificasAsync(
            Arg.Is<ICollection<int>>(ids => ids.Count == 2 && ids.Contains(1) && ids.Contains(2)));

        // Se loguean los ids eliminados correctamente
        _mockLogger.Received(1).Log(
            LogLevel.Information,
            Arg.Any<EventId>(),
            Arg.Is<object>(o => o.ToString()!.Contains("Pre-reservas eliminadas correctamente: 1, 2")),
            Arg.Any<Exception>(),
            Arg.Any<Func<object, Exception?, string>>());
    }

    [Fact]
    public async Task LimpiarPreReservasEspecificasAsync_UnaPreReservaNoSeElimina_RetornaFalse()
    {
        // Arrange
        // U3: el eliminator borra menos registros de los esperados → payload false
        var preReservas = new List<PreReservasDeHorario>
        {
            CrearPreReserva(1, "entrenador-1"),
            CrearPreReserva(2, "entrenador-1")
        };

        _mockRepository.EncontrarPreReservasAsync(Arg.Any<int>(), Arg.Any<DateOnly>(), Arg.Any<int>(), Arg.Any<string>())
            .Returns(preReservas);
        _mockRepository.EliminarPreReservasEspecificasAsync(Arg.Any<ICollection<int>>())
            .Returns(1); // Solo eliminó 1 de 2

        // Act
        var result = await _sut.LimpiarPreReservasEspecificasAsync(10, DateOnly.FromDateTime(DateTime.Now.AddDays(7)), 5, "entrenador-1");

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().BeFalse("El spec espera false cuando no se eliminan todas las esperadas");
        result.message.Should().Be("No se pudieron eliminar todas las pre-reservas");
    }

    [Fact]
    public async Task LimpiarPreReservasEspecificasAsync_PreReservaConIdEntrenadorNull_NoSeEliminaYSeLogueaComoNoProcesable()
    {
        // Arrange
        // U4: una pre-reserva encontrada tiene IdEntrenador null (error de negocio según spec 82):
        // se ignora y NUNCA se envía al eliminator; se loguea como no-procesable.
        // El mock elimina 0 de las válidas → payload false.
        // Nota de comportamiento real: si TODAS las encontradas tuvieran IdEntrenador null, el servicio
        // real retorna true (rama LogWarning + "No hay pre-reservas válidas para limpiar", spec 82);
        // el caso mezclado con eliminación parcial es el que produce payload=false según la spec.
        const int idNoProcesable = 1;
        const int idValida = 2;
        var preReservas = new List<PreReservasDeHorario>
        {
            CrearPreReserva(idNoProcesable, idEntrenador: null),
            CrearPreReserva(idValida, "entrenador-1")
        };

        _mockRepository.EncontrarPreReservasAsync(Arg.Any<int>(), Arg.Any<DateOnly>(), Arg.Any<int>(), Arg.Any<string>())
            .Returns(preReservas);
        _mockRepository.EliminarPreReservasEspecificasAsync(Arg.Any<ICollection<int>>())
            .Returns(0);

        // Act
        var result = await _sut.LimpiarPreReservasEspecificasAsync(10, DateOnly.FromDateTime(DateTime.Now.AddDays(7)), 5, "entrenador-1");

        // Assert
        result.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().BeFalse("El spec espera false cuando no se eliminan todas las válidas");
        result.message.Should().Be("No se pudieron eliminar todas las pre-reservas");

        // La pre-reserva no-procesable (IdEntrenador null) NO se envía al eliminator: solo la válida
        await _mockRepository.Received(1).EliminarPreReservasEspecificasAsync(
            Arg.Is<ICollection<int>>(ids => ids.Count == 1 && ids.Contains(idValida)));

        // Se loguea como no-procesable con su id
        _mockLogger.Received(1).Log(
            LogLevel.Error,
            Arg.Any<EventId>(),
            Arg.Is<object>(o =>
                o.ToString()!.Contains("no-procesables") &&
                o.ToString()!.Contains(idNoProcesable.ToString())),
            Arg.Any<Exception>(),
            Arg.Any<Func<object, Exception?, string>>());
    }

    [Fact]
    public async Task LimpiarPreReservasEspecificasAsync_ExcepcionEnRepository_RetornaError500()
    {
        // Arrange
        // U5: el repository lanza excepción → manejo de error 500 (payload false)
        _mockRepository.EncontrarPreReservasAsync(Arg.Any<int>(), Arg.Any<DateOnly>(), Arg.Any<int>(), Arg.Any<string>())
            .Returns(Task.FromException<List<PreReservasDeHorario>>(
                new InvalidOperationException("Error simulado de BD")));

        // Act
        var result = await _sut.LimpiarPreReservasEspecificasAsync(10, DateOnly.FromDateTime(DateTime.Now.AddDays(7)), 5, "entrenador-1");

        // Assert
        result.success.Should().BeFalse();
        result.httpCode.Should().Be(500);
        result.payload.Should().BeFalse();
        result.message.Should().Be("Error interno del servidor");

        // El flujo se corta antes de eliminar
        await _mockRepository.DidNotReceive().EliminarPreReservasEspecificasAsync(Arg.Any<ICollection<int>>());

        // Se loguea el error con la excepción original
        _mockLogger.Received(1).Log(
            LogLevel.Error,
            Arg.Any<EventId>(),
            Arg.Is<object>(o => o.ToString()!.Contains("Error al limpiar pre-reservas")),
            Arg.Is<Exception>(e => e is InvalidOperationException),
            Arg.Any<Func<object, Exception?, string>>());
    }

    [Fact]
    public async Task LimpiarPreReservasEspecificasAsync_EliminacionParcial_LoggeaIdsEncontradosYNoEliminados()
    {
        // Arrange
        // U6: se verifica la emisión de logs — LogInformation con los ids encontrados
        // y LogError con los ids que quedaron pendientes de revisión
        var preReservas = new List<PreReservasDeHorario>
        {
            CrearPreReserva(1, "entrenador-1"),
            CrearPreReserva(2, "entrenador-1")
        };

        _mockRepository.EncontrarPreReservasAsync(Arg.Any<int>(), Arg.Any<DateOnly>(), Arg.Any<int>(), Arg.Any<string>())
            .Returns(preReservas);
        _mockRepository.EliminarPreReservasEspecificasAsync(Arg.Any<ICollection<int>>())
            .Returns(1); // Eliminación parcial: 1 de 2

        // Act
        var result = await _sut.LimpiarPreReservasEspecificasAsync(10, DateOnly.FromDateTime(DateTime.Now.AddDays(7)), 5, "entrenador-1");

        // Assert
        result.payload.Should().BeFalse();

        // LogInformation con los ids encontrados que van a procesarse
        _mockLogger.Received(1).Log(
            LogLevel.Information,
            Arg.Any<EventId>(),
            Arg.Is<object>(o => o.ToString()!.Contains("Se encontraron 2 pre-reservas para limpiar: 1, 2")),
            Arg.Any<Exception>(),
            Arg.Any<Func<object, Exception?, string>>());

        // LogError con las esperadas, eliminadas y pendientes de revisión
        _mockLogger.Received(1).Log(
            LogLevel.Error,
            Arg.Any<EventId>(),
            Arg.Is<object>(o =>
                o.ToString()!.Contains("No se pudieron eliminar todas las pre-reservas") &&
                o.ToString()!.Contains("Esperadas=2 Eliminadas=1") &&
                o.ToString()!.Contains("Pre-reservas pendientes de revisión: 1, 2")),
            Arg.Any<Exception>(),
            Arg.Any<Func<object, Exception?, string>>());
    }

    /// <summary>
    /// Factory (Object Mother) para armar pre-reservas de prueba con datos controlados.
    /// </summary>
    private static PreReservasDeHorario CrearPreReserva(int idPreReserva, string? idEntrenador)
    {
        return new PreReservasDeHorario
        {
            IdPreReserva = idPreReserva,
            FechaInicioDeLaReserva = DateTime.Now,
            FechaDeExpiracionDeLaReserva = DateTime.Now.AddHours(2),
            FkHoraLaboral = 10,
            IdUsuarioQueReserva = "cliente-1",
            FechaReservada = DateOnly.FromDateTime(DateTime.Now),
            IdClase = 5,
            FechaDeLaClase = null,
            IdEntrenador = idEntrenador
        };
    }
}