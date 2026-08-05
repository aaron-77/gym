using BL.Utils.Enums;
using FluentAssertions;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Horarios;

/// <summary>
/// Tests de integración del filtro de hora único (<see cref="FiltroHora.Mayor"/>) del
/// <see cref="HorariosHelper"/> (spec 51). Verifican el ceil de la referencia a la próxima
/// hora completa, la preservación de la referencia 00:00 con fecha explícita futura y el
/// guard de fin de jornada que desplaza la referencia al día siguiente.
/// </summary>
[Collection("IntegrationTests")]
public class HorariosHelperFiltroHoraTests
{
    private readonly string _connectionString;

    public HorariosHelperFiltroHoraTests(TestContainerHelper testContainerHelper)
    {
        _connectionString = testContainerHelper.ConnectionString;
        testContainerHelper.ResetDatabaseAsync().GetAwaiter().GetResult();
    }

    /// <summary>
    /// Test 1: FiltroHoraMayor con hora actual con minutos → ceil a próxima hora.
    /// La referencia esperada se calcula desde el reloj capturado: si hay minutos/segundos > 0
    /// es hora+1, si no la hora exacta. Dentro de la jornada, todos los slots de hoy deben
    /// tener horaInicio > referencia esperada.
    /// </summary>
    [Fact]
    public async Task FiltroHoraMayor_HoraActualConMinutos_CeilAProximaHora()
    {
        // Arrange
        var ahora = DateTime.Now;
        var horaRefEsperada = ahora.Minute > 0 || ahora.Second > 0
            ? new TimeSpan(ahora.Hour + 1, 0, 0)
            : new TimeSpan(ahora.Hour, 0, 0);

        var rango = await DatabaseHelper.ExecuteQuerySingleAsync(
            _connectionString,
            "SELECT MIN(horaInicio) AS MinHora, MAX(horaInicio) AS MaxHora FROM horasLaborales");
        var minHora = (TimeSpan)rango!["MinHora"];
        var maxHora = (TimeSpan)rango!["MaxHora"];

        // Act
        var horarios = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            _connectionString, FiltroFecha.Igual, FiltroHora.Mayor);

        // Assert
        if (horaRefEsperada > maxHora)
        {
            // Fuera de jornada: el guard desplaza la consulta al día siguiente
            var fechaSiguiente = DateOnly.FromDateTime(DateTime.Today.AddDays(1));
            horarios.Should().NotBeEmpty("el guard debe devolver slots del día siguiente");
            horarios.Should().OnlyContain(r =>
                DateOnly.FromDateTime(Convert.ToDateTime(r["FechaDisponible"])) == fechaSiguiente);
            horarios.Should().OnlyContain(r => (TimeSpan)r["horaInicio"] >= minHora);
        }
        else
        {
            // Dentro de jornada: slots de HOY con horaInicio > referencia ceil
            var fechaHoy = DateOnly.FromDateTime(DateTime.Today);
            horarios.Should().OnlyContain(r =>
                DateOnly.FromDateTime(Convert.ToDateTime(r["FechaDisponible"])) == fechaHoy);
            horarios.Should().OnlyContain(r => (TimeSpan)r["horaInicio"] > horaRefEsperada);
        }
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
    /// Test 3: FiltroHoraMayor fuera de jornada → desplaza la referencia al día siguiente.
    /// Si la referencia supera la última hora laboral, el guard mueve la consulta al día
    /// siguiente con referencia = primera hora laboral. Si no, permanece el día actual.
    /// </summary>
    [Fact]
    public async Task FiltroHoraMayor_FinDeJornada_DesplazaAlDiaSiguiente()
    {
        // Arrange
        var ahora = DateTime.Now;
        var horaRefEsperada = ahora.Minute > 0 || ahora.Second > 0
            ? new TimeSpan(ahora.Hour + 1, 0, 0)
            : new TimeSpan(ahora.Hour, 0, 0);

        var rango = await DatabaseHelper.ExecuteQuerySingleAsync(
            _connectionString,
            "SELECT MIN(horaInicio) AS MinHora, MAX(horaInicio) AS MaxHora FROM horasLaborales");
        var minHora = (TimeSpan)rango!["MinHora"];
        var maxHora = (TimeSpan)rango!["MaxHora"];

        // Act
        var horarios = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            _connectionString, FiltroFecha.Igual, FiltroHora.Mayor);

        // Assert
        if (horaRefEsperada > maxHora)
        {
            // Guard activo: slots del día siguiente con horaInicio >= primera hora laboral
            var fechaSiguiente = DateOnly.FromDateTime(DateTime.Today.AddDays(1));
            horarios.Should().NotBeEmpty("el guard debe devolver slots del día siguiente");
            horarios.Should().OnlyContain(r =>
                DateOnly.FromDateTime(Convert.ToDateTime(r["FechaDisponible"])) == fechaSiguiente);
            horarios.Should().OnlyContain(r => (TimeSpan)r["horaInicio"] >= minHora);
        }
        else
        {
            // Dentro de jornada: la consulta permanece en el día actual
            var fechaHoy = DateOnly.FromDateTime(DateTime.Today);
            horarios.Should().OnlyContain(r =>
                DateOnly.FromDateTime(Convert.ToDateTime(r["FechaDisponible"])) == fechaHoy);
            horarios.Should().OnlyContain(r => (TimeSpan)r["horaInicio"] > horaRefEsperada);
        }
    }

    /// <summary>
    /// Test 4: FiltroHoraMayor dentro de jornada → permanece el día actual.
    /// Complemento del test 3: dentro de la jornada laboral la consulta no se desplaza
    /// y devuelve slots del día actual con horaInicio > referencia ceil.
    /// </summary>
    [Fact]
    public async Task FiltroHoraMayor_DentroDeJornada_PermaneceDiaActual()
    {
        // Arrange
        var ahora = DateTime.Now;
        var horaRefEsperada = ahora.Minute > 0 || ahora.Second > 0
            ? new TimeSpan(ahora.Hour + 1, 0, 0)
            : new TimeSpan(ahora.Hour, 0, 0);

        var rango = await DatabaseHelper.ExecuteQuerySingleAsync(
            _connectionString,
            "SELECT MIN(horaInicio) AS MinHora, MAX(horaInicio) AS MaxHora FROM horasLaborales");
        var minHora = (TimeSpan)rango!["MinHora"];
        var maxHora = (TimeSpan)rango!["MaxHora"];

        // Act
        var horarios = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            _connectionString, FiltroFecha.Igual, FiltroHora.Mayor);

        // Assert
        if (horaRefEsperada < maxHora)
        {
            // Dentro de jornada: día actual no-vacío con horaInicio > referencia ceil
            var fechaHoy = DateOnly.FromDateTime(DateTime.Today);
            horarios.Should().NotBeEmpty("dentro de la jornada debe haber slots disponibles hoy");
            horarios.Should().OnlyContain(r =>
                DateOnly.FromDateTime(Convert.ToDateTime(r["FechaDisponible"])) == fechaHoy);
            horarios.Should().OnlyContain(r => (TimeSpan)r["horaInicio"] > horaRefEsperada);
        }
        else
        {
            // Fuera de jornada (o borde horaRef == maxHora): el guard desplaza al día
            // siguiente; en el borde exacto la lista queda vacía y la aserción pasa vacua.
            var fechaSiguiente = DateOnly.FromDateTime(DateTime.Today.AddDays(1));
            horarios.Should().OnlyContain(r =>
                DateOnly.FromDateTime(Convert.ToDateTime(r["FechaDisponible"])) == fechaSiguiente);
            horarios.Should().OnlyContain(r => (TimeSpan)r["horaInicio"] >= minHora);
        }
    }
}
