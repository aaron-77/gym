using BL.Utils.Enums;
using GymWebApp.Tests.E2E.Common;
using GymWebApp.Tests.E2E.PageModels;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using Microsoft.Playwright;
using Xunit;
using static Microsoft.Playwright.Assertions;

namespace GymWebApp.Tests.E2E.Features;

/// <summary>
/// Tests E2E de navegación del calendario desde la vista Cancelar/Reagendar
/// Inscripción (spec 77 / escenarios 11-13 del catálogo e2e-tests.md).
///
/// Cada prueba replica el bloque común de acceso del happy path de reagendación
/// y termina en la selección del horario por ID, sin ejecutar la reagendación.
///
/// Diseño de seed único: la única escritura de cada prueba es la inscripción
/// creada vía InscripcionTestHelper; su propia clase programada es el horario
/// seleccionable en el calendario. Esto es así porque el scheduler de la vista
/// renderiza exclusivamente las clases programadas de la clase inscrita y
/// calendario.js deshabilita los días sin programación. La fecha de referencia
/// proviene de HorariosHelper.ObtenerHorariosDisponiblesFiltrados con base en el
/// inicio del período objetivo (el SP subyacente solo genera fechas del mes del
/// parámetro recibido) y se valida con ObtenerUnHorarioDisponible antes de sembrar.
/// No hay inserts manuales, ni clases destino adicionales, ni manipulación del
/// reloj del browser ni del token almacenado.
/// </summary>
[Collection("E2E HappyPaths")]
public class CalendarNavigationE2ETests : PlaywrightTestBase
{
    public CalendarNavigationE2ETests(
        E2eContainerHelper e2eContainerHelper,
        PlaywrightHelper playwrightHelper)
        : base(e2eContainerHelper, playwrightHelper)
    {
    }

    private string BaseUrl => E2eContainerHelper.Instance.NginxBaseUrl;

    /// <summary>
    /// Test E2E-CALNAV-01 (escenario 11): navega el calendario a un día posterior
    /// dentro del mes actual y selecciona la programación de la inscripción sembrada.
    /// </summary>
    [Fact]
    public async Task Calendar_NavigateSameMonthLaterDay_SelectsSchedule()
    {
        var connectionString = E2eContainerHelper.Instance.HostConnectionString;

        // Arrange: base del período = hoy. El SP genera el calendario completo del mes
        // recibido y el filtro estrictamente mayor deja solo días posteriores dentro
        // del mes actual, garantizando la condición "mismo mes, día posterior".
        var periodBase = DateTime.Today;

        var horariosDisponibles = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            connectionString, FiltroFecha.Mayor, FiltroHora.SinFiltro, periodBase);

        var fechaElegida = horariosDisponibles
            .Select(row => DateOnly.FromDateTime(Convert.ToDateTime(row["FechaDisponible"])))
            .FirstOrDefault(fecha => fecha.Month == periodBase.Month
                && fecha.Year == periodBase.Year
                && fecha > DateOnly.FromDateTime(DateTime.Today));

        Assert.True(fechaElegida != default,
            $"No hay horarios disponibles posteriores a hoy dentro del mes {periodBase:yyyy-MM}. " +
            "El escenario requiere disponibilidad en el mes en curso; no se recurre a fechas arbitrarias.");

        // Valida que la fecha elegida tenga al menos un slot disponible ese día.
        var slotValidado = await HorariosHelper.ObtenerUnHorarioDisponible(
            connectionString, FiltroFecha.Igual, FiltroHora.SinFiltro, fechaElegida);

        Assert.True(slotValidado.HasValue,
            $"La fecha elegida {fechaElegida:yyyy-MM-dd} no tiene slots disponibles para sembrar la inscripción.");

        // ÚNICA escritura del test: la inscripción cuya programación actúa como horario destino.
        var seedResult = await InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(
            connectionString, fechaElegida);
        Assert.NotNull(seedResult);
        var (clienteId, idInscripcion) = seedResult!.Value;

        // Readback: fecha real e ID real de la programación creada por el seed.
        // El día exacto puede diferir de fechaElegida dentro del mismo período;
        // navegación y aserciones usan siempre los valores reales.
        var programacionRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 cp.idProgramacionClase AS IdClaseProgramada,
                            cp.fechaDeLaClase AS FechaDeLaClase
              FROM inscripcionesDeClases icd
              INNER JOIN clasesProgramadas cp ON cp.idProgramacionClase = icd.fkProgramacionClase
              WHERE icd.idInscripcion = @IdInscripcion",
            new Dictionary<string, object?> { ["@IdInscripcion"] = idInscripcion });

        Assert.NotNull(programacionRow);
        var idClaseProgramadaReal = Convert.ToInt32(programacionRow!["IdClaseProgramada"]);
        var fechaReal = DateOnly.FromDateTime(Convert.ToDateTime(programacionRow["FechaDeLaClase"]));

        // Act: bloque común de acceso (idéntico al happy path de reagendación).
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);
        await Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        var cancelarReagendarPage = new CancelarReagendarPage(Page);
        await cancelarReagendarPage.GoToAsync(BaseUrl);

        await Expect(cancelarReagendarPage.Title).ToContainTextAsync("Cancelar / Reagendar Inscripción");

        await cancelarReagendarPage.SelectClientAsync(clienteId);
        await cancelarReagendarPage.SelectEnrollmentAsync(idInscripcion.ToString());
        await cancelarReagendarPage.EnableReschedulingAsync();

        // Espera a que el scheduler renderice un horario seleccionable con ID de
        // clase programada (el render es asíncrono: fetch + animación escalonada).
        await cancelarReagendarPage.WaitForSchedulesLoadedAsync();

        // Act: navega a la fecha real del seed (mismo mes que hoy) y selecciona
        // el horario por su ID exacto. NavigateToMonthYearAsync valida internamente
        // que el calendario quedó posicionado en el mes/año destino.
        var seleccionado = await cancelarReagendarPage.SelectDestinationByIdAsync(
            idClaseProgramadaReal.ToString(), fechaReal);

        // Assert: el horario destino fue encontrado y quedó marcado como seleccionado.
        Assert.False(string.IsNullOrEmpty(seleccionado),
            $"No se encontró en el scheduler el horario con ID {idClaseProgramadaReal} para la fecha {fechaReal:yyyy-MM-dd}.");

        await Expect(Page.Locator(
                $".schedule-viewer__item--selected[data-id-clase-programada='{idClaseProgramadaReal}']"))
            .ToBeVisibleAsync();

        // AND: el día destino aparece seleccionado en la grilla del calendario.
        await Expect(Page.Locator(
                $"button.calendar-cell--selected[data-fecha='{fechaReal:yyyy-MM-dd}']"))
            .ToBeVisibleAsync();

        // AND: sin modales de éxito/error: la prueba nunca ejecuta la reagendación.
        await Expect(Page.Locator(".swal2-title")).ToHaveCountAsync(0);
    }

    /// <summary>
    /// Test E2E-CALNAV-02 (escenario 12): navega el calendario cruzando un límite
    /// de mes hasta una fecha del mes siguiente y selecciona la programación sembrada.
    /// </summary>
    [Fact]
    public async Task Calendar_NavigateOtherMonth_SelectsSchedule()
    {
        var connectionString = E2eContainerHelper.Instance.HostConnectionString;

        // Arrange: base del período = primer día del mes siguiente. Como el SP solo
        // genera fechas del mes del parámetro recibido, todo el resultado queda
        // confinado al mes siguiente respecto de hoy.
        var periodBase = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1).AddMonths(1);

        var horariosDisponibles = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            connectionString, FiltroFecha.Mayor, FiltroHora.SinFiltro, periodBase);

        var fechaElegida = horariosDisponibles
            .Select(row => DateOnly.FromDateTime(Convert.ToDateTime(row["FechaDisponible"])))
            .FirstOrDefault();

        Assert.True(fechaElegida != default,
            $"No hay horarios disponibles en el mes {periodBase:yyyy-MM}. " +
            "El escenario requiere disponibilidad en el mes siguiente; no se recurre a fechas arbitrarias.");

        var slotValidado = await HorariosHelper.ObtenerUnHorarioDisponible(
            connectionString, FiltroFecha.Igual, FiltroHora.SinFiltro, fechaElegida);

        Assert.True(slotValidado.HasValue,
            $"La fecha elegida {fechaElegida:yyyy-MM-dd} no tiene slots disponibles para sembrar la inscripción.");

        var seedResult = await InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(
            connectionString, fechaElegida);
        Assert.NotNull(seedResult);
        var (clienteId, idInscripcion) = seedResult!.Value;

        var programacionRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 cp.idProgramacionClase AS IdClaseProgramada,
                            cp.fechaDeLaClase AS FechaDeLaClase
              FROM inscripcionesDeClases icd
              INNER JOIN clasesProgramadas cp ON cp.idProgramacionClase = icd.fkProgramacionClase
              WHERE icd.idInscripcion = @IdInscripcion",
            new Dictionary<string, object?> { ["@IdInscripcion"] = idInscripcion });

        Assert.NotNull(programacionRow);
        var idClaseProgramadaReal = Convert.ToInt32(programacionRow!["IdClaseProgramada"]);
        var fechaReal = DateOnly.FromDateTime(Convert.ToDateTime(programacionRow["FechaDeLaClase"]));

        // Act: bloque común de acceso.
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);
        await Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        var cancelarReagendarPage = new CancelarReagendarPage(Page);
        await cancelarReagendarPage.GoToAsync(BaseUrl);

        await Expect(cancelarReagendarPage.Title).ToContainTextAsync("Cancelar / Reagendar Inscripción");

        await cancelarReagendarPage.SelectClientAsync(clienteId);
        await cancelarReagendarPage.SelectEnrollmentAsync(idInscripcion.ToString());
        await cancelarReagendarPage.EnableReschedulingAsync();
        await cancelarReagendarPage.WaitForSchedulesLoadedAsync();

        // Act: cruza al menos un límite de mes hasta la fecha real del seed y
        // selecciona el horario por ID exacto.
        var seleccionado = await cancelarReagendarPage.SelectDestinationByIdAsync(
            idClaseProgramadaReal.ToString(), fechaReal);

        // Assert.
        Assert.False(string.IsNullOrEmpty(seleccionado),
            $"No se encontró en el scheduler el horario con ID {idClaseProgramadaReal} para la fecha {fechaReal:yyyy-MM-dd}.");

        await Expect(Page.Locator(
                $".schedule-viewer__item--selected[data-id-clase-programada='{idClaseProgramadaReal}']"))
            .ToBeVisibleAsync();

        await Expect(Page.Locator(
                $"button.calendar-cell--selected[data-fecha='{fechaReal:yyyy-MM-dd}']"))
            .ToBeVisibleAsync();

        await Expect(Page.Locator(".swal2-title")).ToHaveCountAsync(0);
    }

    /// <summary>
    /// Test E2E-CALNAV-03 (escenario 13): navega el calendario cruzando un límite
    /// de año mediante el selector de años hasta enero del año siguiente y
    /// selecciona la programación sembrada.
    /// </summary>
    [Fact]
    public async Task Calendar_NavigateOtherYear_SelectsSchedule()
    {
        var connectionString = E2eContainerHelper.Instance.HostConnectionString;

        // Arrange: base del período = 1° de enero del año próximo. El resultado del
        // SP queda confinado a enero del año siguiente, garantizando el cruce de año.
        var periodBase = new DateTime(DateTime.Today.Year + 1, 1, 1);

        var horariosDisponibles = await HorariosHelper.ObtenerHorariosDisponiblesFiltrados(
            connectionString, FiltroFecha.Mayor, FiltroHora.SinFiltro, periodBase);

        var fechaElegida = horariosDisponibles
            .Select(row => DateOnly.FromDateTime(Convert.ToDateTime(row["FechaDisponible"])))
            .FirstOrDefault();

        Assert.True(fechaElegida != default,
            $"No hay horarios disponibles en enero {periodBase:yyyy}. " +
            "El escenario requiere disponibilidad en el primer mes del año siguiente; no se recurre a fechas arbitrarias.");

        var slotValidado = await HorariosHelper.ObtenerUnHorarioDisponible(
            connectionString, FiltroFecha.Igual, FiltroHora.SinFiltro, fechaElegida);

        Assert.True(slotValidado.HasValue,
            $"La fecha elegida {fechaElegida:yyyy-MM-dd} no tiene slots disponibles para sembrar la inscripción.");

        var seedResult = await InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(
            connectionString, fechaElegida);
        Assert.NotNull(seedResult);
        var (clienteId, idInscripcion) = seedResult!.Value;

        var programacionRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            @"SELECT TOP 1 cp.idProgramacionClase AS IdClaseProgramada,
                            cp.fechaDeLaClase AS FechaDeLaClase
              FROM inscripcionesDeClases icd
              INNER JOIN clasesProgramadas cp ON cp.idProgramacionClase = icd.fkProgramacionClase
              WHERE icd.idInscripcion = @IdInscripcion",
            new Dictionary<string, object?> { ["@IdInscripcion"] = idInscripcion });

        Assert.NotNull(programacionRow);
        var idClaseProgramadaReal = Convert.ToInt32(programacionRow!["IdClaseProgramada"]);
        var fechaReal = DateOnly.FromDateTime(Convert.ToDateTime(programacionRow["FechaDeLaClase"]));

        // Act: bloque común de acceso.
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);
        await Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        var cancelarReagendarPage = new CancelarReagendarPage(Page);
        await cancelarReagendarPage.GoToAsync(BaseUrl);

        await Expect(cancelarReagendarPage.Title).ToContainTextAsync("Cancelar / Reagendar Inscripción");

        await cancelarReagendarPage.SelectClientAsync(clienteId);
        await cancelarReagendarPage.SelectEnrollmentAsync(idInscripcion.ToString());
        await cancelarReagendarPage.EnableReschedulingAsync();
        await cancelarReagendarPage.WaitForSchedulesLoadedAsync();

        // Act: cruza al menos un límite de año (selector de años del componente)
        // hasta la fecha real del seed y selecciona el horario por ID exacto.
        var seleccionado = await cancelarReagendarPage.SelectDestinationByIdAsync(
            idClaseProgramadaReal.ToString(), fechaReal);

        // Assert.
        Assert.False(string.IsNullOrEmpty(seleccionado),
            $"No se encontró en el scheduler el horario con ID {idClaseProgramadaReal} para la fecha {fechaReal:yyyy-MM-dd}.");

        await Expect(Page.Locator(
                $".schedule-viewer__item--selected[data-id-clase-programada='{idClaseProgramadaReal}']"))
            .ToBeVisibleAsync();

        await Expect(Page.Locator(
                $"button.calendar-cell--selected[data-fecha='{fechaReal:yyyy-MM-dd}']"))
            .ToBeVisibleAsync();

        await Expect(Page.Locator(".swal2-title")).ToHaveCountAsync(0);
    }
}
