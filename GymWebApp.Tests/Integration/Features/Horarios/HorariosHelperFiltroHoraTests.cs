using FluentAssertions;
using Xunit;
using BL.Utils.Enums;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;

namespace GymWebApp.Tests.Integration.Features.Horarios;

/// <summary>
/// Tests de integración del filtro de hora único (<see cref="FiltroHora.Mayor"/>) del
/// <see cref="HorariosHelper"/> (spec 51). Verifican el ceil de la referencia a la próxima
/// hora completa, la preservación de la referencia 00:00 con fecha explícita futura y el
/// guard de fin de jornada que desplaza la referencia al día siguiente.
/// </summary>
[Collection("IntegrationTests")]
public class HorariosHelperFiltroHoraTests : IAsyncLifetime
{
    private readonly string _connectionString;
    private TestContainerHelper _testContainerHelper = null!;

    public HorariosHelperFiltroHoraTests(TestContainerHelper testContainerHelper)
    {
        _connectionString = testContainerHelper.ConnectionString;
        _testContainerHelper = testContainerHelper;
    }

    public async Task InitializeAsync()
    {
        await _testContainerHelper.ResetDatabaseAsync();
    }

    public async Task DisposeAsync()
    {
    }

    /// <summary>
    /// Test 1: FiltroHoraMayor con hora con minutos → ceil a próxima hora.
    /// Doble llamada: primera con fecha fija (día 15), segunda con hora laboral
    /// que tiene minutos (ej: 08:30). El ceil descarta el slot de la hora iniciada.
    /// </summary>
    [Fact]
    public async Task FiltroHoraMayor_HoraActualConMinutos_CeilAProximaHora()
    {
        // Arrange - Fecha fija: día 15 del mes actual
        var fechaFija = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 15);

        // Primera llamada para verificar que la fecha existe
        var horariosRef = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            _connectionString, FiltroFecha.Igual, FiltroHora.SinFiltro, fechaFija);

        horariosRef.Should().NotBeEmpty("debe haber horarios disponibles para la fecha fija");
        var fechaRef = DateOnly.FromDateTime(fechaFija);

        // Consultar la primera hora laboral
        var horaRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            _connectionString,
            "SELECT TOP 1 horaInicio FROM horasLaborales ORDER BY horaInicio");
        var minHora = (TimeSpan)horaRow["horaInicio"];

        // Hora con minutos: minHora + 30min → ceil = minHora + 1h
        var horaConMinutos = new TimeSpan(minHora.Hours, 30, 0);
        var horaRefEsperada = minHora.Add(TimeSpan.FromHours(1)); // ceil

        var fechaHoraConfigurada = fechaRef.ToDateTime(TimeOnly.FromTimeSpan(horaConMinutos));

        // Act - Segunda llamada con hora que tiene minutos
        var horarios = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            _connectionString, FiltroFecha.Igual, FiltroHora.Mayor, fechaHoraConfigurada);

        // Assert
        horarios.Should().OnlyContain(r =>
            DateOnly.FromDateTime(Convert.ToDateTime(r["FechaDisponible"])) == fechaRef,
            "debe permanecer en la fecha de referencia (ceil dentro de jornada)");
        horarios.Should().OnlyContain(r => (TimeSpan)r["horaInicio"] >= horaRefEsperada,
            $"los slots deben tener horaInicio >= {horaRefEsperada} (ceil de {horaConMinutos})");
        horarios.Should().NotContain(r => (TimeSpan)r["horaInicio"] == minHora,
            $"el slot de {minHora} debe ser descartado por el ceil");
    }

    /// <summary>
    /// Test 2: FiltroHoraMayor con fecha explícita futura → referencia 00:00 preservada.
    /// Con fecha explícita (DateOnly → 00:00) no aplica ceil ni guard: se devuelven los
    /// slots del día solicitado, incluidos los primeros horarios de la jornada.
    /// </summary>
    [Fact]
    public async Task FiltroHoraMayor_FechaExplicitaFutura_Referencia00Preservada()
    {
        // Arrange
        var fechaExplicita = DateOnly.FromDateTime(DateTime.Today.AddDays(7));

        // Act
        var horarios = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            _connectionString,
            FiltroFecha.Igual,
            FiltroHora.Mayor,
            fechaExplicita.ToDateTime(TimeOnly.MinValue));

        // Assert
        horarios.Should().NotBeEmpty("debe haber slots disponibles para la fecha futura solicitada");
        horarios.Should().OnlyContain(r =>
            DateOnly.FromDateTime(Convert.ToDateTime(r["FechaDisponible"])) == fechaExplicita);
        horarios.Should().OnlyContain(r => (TimeSpan)r["horaInicio"] > TimeSpan.Zero,
            "la referencia 00:00 preservada no excluye ningún horario del día");
    }

    /// <summary>
    /// Test 3: FiltroHoraMayor fin de jornada → desplaza al día siguiente.
    /// Doble llamada: primera con fecha fija (día 15), segunda con la hora máxima
    /// de inicio. El salto de día lo hace NormalizarFecha dentro del helper.
    /// </summary>
    [Fact]
    public async Task FiltroHoraMayor_FinDeJornada_DesplazaAlDiaSiguiente()
    {
        // Arrange - Fecha fija: día 15 del mes actual
        var fechaFija = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 15);

        // Primera llamada para verificar que la fecha existe
        var horariosRef = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            _connectionString, FiltroFecha.Igual, FiltroHora.SinFiltro, fechaFija);

        horariosRef.Should().NotBeEmpty("debe haber horarios disponibles para la fecha fija");
        var fechaRef = DateOnly.FromDateTime(fechaFija);

        // Consultar la hora máxima de inicio directamente
        var horaRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            _connectionString,
            "SELECT MAX(horaInicio) AS MaxHora FROM horasLaborales");
        var maxHora = (TimeSpan)horaRow["MaxHora"];

        // Configurar fechaRef + 1 día con maxHora
        var fechaHoraConfigurada = fechaRef.AddDays(1).ToDateTime(TimeOnly.FromTimeSpan(maxHora));

        // Act - Segunda llamada con maxHora
        var horarios = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            _connectionString, FiltroFecha.Igual, FiltroHora.Mayor, fechaHoraConfigurada);

        // Assert
        var fechaEsperada = fechaRef.AddDays(1);
        horarios.Should().NotBeEmpty("el salto de día debe devolver slots");
        horarios.Should().OnlyContain(r =>
            DateOnly.FromDateTime(Convert.ToDateTime(r["FechaDisponible"])) == fechaEsperada,
            $"todos los slots deben ser del {fechaEsperada}");
    }

    /// <summary>
    /// Test 4: FiltroHoraMayor dentro de jornada → permanece el día actual.
    /// Doble llamada: primera con fecha fija (día 15), segunda con hora laboral exacta.
    /// Sin if/else sobre DateTime.Now o maxHora.
    /// </summary>
    [Fact]
    public async Task FiltroHoraMayor_DentroDeJornada_PermaneceDiaActual()
    {
        // Arrange - Fecha fija: día 15 del mes actual
        var fechaFija = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 15);

        // Primera llamada para verificar que la fecha existe
        var horariosRef = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            _connectionString, FiltroFecha.Igual, FiltroHora.SinFiltro, fechaFija);

        horariosRef.Should().NotBeEmpty("debe haber horarios disponibles para la fecha fija");
        var fechaRef = DateOnly.FromDateTime(fechaFija);

        // Consultar la primera hora laboral y sumar 1h
        var horaRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            _connectionString,
            "SELECT TOP 1 horaInicio FROM horasLaborales ORDER BY horaInicio");
        var horaLaboral = (TimeSpan)horaRow["horaInicio"];
        var horaConfigurada = horaLaboral.Add(TimeSpan.FromHours(1));

        var fechaHoraConfigurada = fechaRef.ToDateTime(TimeOnly.FromTimeSpan(horaConfigurada));

        // Act - Segunda llamada con hora configurada
        var horarios = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            _connectionString, FiltroFecha.Igual, FiltroHora.Mayor, fechaHoraConfigurada);

        // Assert
        horarios.Should().NotBeEmpty("dentro de la jornada debe haber slots disponibles");
        horarios.Should().OnlyContain(r =>
            DateOnly.FromDateTime(Convert.ToDateTime(r["FechaDisponible"])) == fechaRef,
            "debe permanecer en la fecha de referencia");
        horarios.Should().OnlyContain(r => (TimeSpan)r["horaInicio"] >= horaConfigurada,
            "los slots deben tener horaInicio >= hora configurada");
    }
}
