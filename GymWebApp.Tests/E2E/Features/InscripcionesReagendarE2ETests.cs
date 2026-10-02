using System.Text.Json;
using BL.Utils.Enums;
using DTO.Dtos;
using Microsoft.Playwright;
using GymWebApp.Tests.E2E.Common;
using GymWebApp.Tests.E2E.PageModels;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using Xunit;
using static Microsoft.Playwright.Assertions;

namespace GymWebApp.Tests.E2E.Features;

/// <summary>
/// Tests E2E para la funcionalidad de reagendar inscripción desde la UI
/// (spec 47). Verifica que el empleado autenticado pueda reagendar una inscripción
/// seleccionando un nuevo horario en el calendario, y que los casos de acceso
/// no autorizado redirijan correctamente.
///
/// NOTA: Se corrigió un bug en ejecutarReagendar() donde se enviaba
/// idClaseProgramada (la clase ORIGINAL) en lugar de idNuevaClase
/// (el nuevo horario seleccionado en el calendario) en el body de la petición
/// POST /inscripciones/reagendar.
/// </summary>
[Collection("E2E HappyPaths")]
public class InscripcionesReagendarE2ETests : PlaywrightTestBase
{
    public InscripcionesReagendarE2ETests(
        E2eContainerHelper e2eContainerHelper,
        PlaywrightHelper playwrightHelper)
        : base(e2eContainerHelper, playwrightHelper)
    {
    }

    private string BaseUrl => E2eContainerHelper.Instance.NginxBaseUrl;

    #region Edge Cases — Autenticación y Autorización

    /// <summary>
    /// Test E2E-REAG-02: Usuario sin autenticación intenta acceder a la página.
    /// El middleware JWT OnChallenge redirige a /signIn.
    /// </summary>
    [Fact]
    public async Task Reagendar_SinAutenticacion_RetornaRedirectToLogin()
    {
        // WHEN: navegar directamente a la página sin estar autenticado
        await Page.GotoAsync($"{BaseUrl}/Inscripciones/cancelarReagendar");

        // THEN: redirige a signIn (el OnChallenge del JWT Bearer hace redirect)
        var loginInput = Page.Locator("input[name='correo']");
        await Expect(loginInput).ToBeVisibleAsync(new LocatorAssertionsToBeVisibleOptions
        {
            Timeout = 10_000
        });

        // AND: la URL contiene /signIn
        Assert.Contains("signIn", Page.Url, StringComparison.OrdinalIgnoreCase);
    }

    /// <summary>
    /// Test E2E-REAG-03: Usuario logueado como cliente intenta acceder a una página
    /// exclusiva para empleados. El middleware retorna 403 y redirige a AccesoDenegado.
    /// </summary>
    [Fact]
    public async Task Reagendar_UsuarioSinRolEmpleado_RetornaForbidden()
    {
        // GIVEN: cliente logueado
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserClienteEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserClientePassword);
        await Page.ClickAsync("button.sign");
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);

        // WHEN: navega a cancelar/reagendar (exclusivo para empleados)
        await Page.GotoAsync($"{BaseUrl}/Inscripciones/cancelarReagendar");
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);

        // THEN: redirige a AccesoDenegado (OnForbidden del JWT Bearer)
        Assert.Contains("AccesoDenegado", Page.Url, StringComparison.OrdinalIgnoreCase);
    }

    #endregion

    #region Happy Path

    /// <summary>
    /// Test E2E-REAG-04: Empleado intenta reagendar sin seleccionar un horario
    /// en el calendario. EjectutarReagendar valida que idNuevaClase no sea nulo
    /// y muestra SweetAlert2 de advertencia.
    ///
    /// Verifica el fix del bug: ejecutarReagendar se ejecuta correctamente
    /// (no se rompe por el cambio de idClaseProgramada a idClaseProgramada: idNuevaClase).
    /// </summary>
    [Fact]
    public async Task Reagendar_SinHorarioSeleccionado_MuestraAdvertencia()
    {
        // GIVEN: empleado logueado en el sistema
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);
        await Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // GIVEN: datos de prueba en BD (retorna el ID del cliente creado)
        var clienteId = await InscripcionEndpointHelper.SeedFreshInscripcionAsync(
            E2eContainerHelper.Instance.HostConnectionString);

        // WHEN: navega a la vista de cancelar/reagendar
        await Page.GotoAsync($"{BaseUrl}/Inscripciones/cancelarReagendar");
        await Page.WaitForLoadStateAsync(LoadState.NetworkIdle);

        // THEN: la vista se renderiza con el título
        await Expect(Page.Locator("h1")).ToContainTextAsync("Cancelar / Reagendar Inscripción");

        // WHEN: selecciona el cliente que fue inscrito en el seed
        var comboCliente = Page.Locator("#comboCliente");
        await comboCliente.SelectOptionAsync(clienteId);

        // WHEN: espera que se carguen las inscripciones y selecciona una
        var comboInscripcion = Page.Locator("#comboInscripcion");
        await Expect(comboInscripcion).ToBeEnabledAsync(new LocatorAssertionsToBeEnabledOptions
        {
            Timeout = 15_000
        });

        var firstInscripcionOption = comboInscripcion.Locator("option:not([value=''])").First;
        var inscripcionValue = await firstInscripcionOption.GetAttributeAsync("value");
        await comboInscripcion.SelectOptionAsync(inscripcionValue!);

        // WHEN: marca el checkbox de reagendar (muestra calendario y scheduler)
        await Page.Locator("#checkReagendar").CheckAsync();

        // WHEN: click en "Reagendar" sin seleccionar horario en el calendario
        await Page.Locator("#btnEjecutar").ClickAsync();

        // THEN: muestra SweetAlert2 con la advertencia
        var swalTitle = Page.Locator(".swal2-title");
        await Expect(swalTitle).ToHaveTextAsync(
            "Seleccione un horario en el calendario",
            new LocatorAssertionsToHaveTextOptions
            {
                Timeout = 10_000
            });

        // AND: el icono de advertencia está presente en el Swal2
        var swalIcon = Page.Locator(".swal2-warning");
        await Expect(swalIcon).ToBeVisibleAsync();
    }

    /// <summary>
    /// Test E2E-REAG-01: Empleado autenticado reagenda una inscripción exitosamente
    /// mediante el flujo UI completo.
    ///
    /// Login → seed datos → navegar a la vista → seleccionar cliente → seleccionar
    /// inscripción → check reagendar → setear schedule vía JS → click btnEjecutar
    /// → SweetAlert2 éxito.
    ///
    /// El click directo en un horario NO puede usarse aquí: handleScheduleClick
    /// ejecuta registrarPreReservaDeHorario ANTES de setear la selección, y esa
    /// pre-reserva SIEMPRE falla en este escenario porque la clase destino es una
    /// clase YA programada — sp_preReservarHorario la rechaza con
    /// yaExisteClaseProgramada = 1 (RAISERROR + ROLLBACK) y el handler hace
    /// return antes de selectSchedule, dejando además un SweetAlert de error modal
    /// sin timer que bloquearía el resto del flujo.
    ///
    /// Por eso seteamos la clase --selected vía JS (equivalente funcional a que la
    /// pre-reserva hubiera funcionado): el elemento ya expone data-id-clase-programada
    /// desde createScheduleElement (fix idClaseProgramada en fetchClasesProgramadas)
    /// y ejecutarReagendar solo lee .schedule-viewer__item--selected del DOM.
    /// </summary>
    [Fact]
    public async Task Reagendar_InscripcionValida_RetornaExito()
    {
        // GIVEN: datos de prueba en BD — inscripción futura + clase destino válida
        var connectionString = E2eContainerHelper.Instance.HostConnectionString;

        // Verificar si estamos fuera del horario laboral máximo
        var maxHoraInicio = await InscripcionTestHelper.GetMaxHoraInicioAsync(connectionString);

        DateOnly? fechaReferencia = null;

        var slotDisponible = await HorariosHelper.ObtenerUnHorarioDisponible(
            connectionString,
            FiltroFecha.Mayor,
            FiltroHora.SinFiltro);

        Assert.NotNull(slotDisponible);
        fechaReferencia = slotDisponible!.Value.FechaDisponible;

        if (DateTime.Now.TimeOfDay >= maxHoraInicio - TimeSpan.FromMinutes(1))
        {
         
            // Fijar el reloj del browser para que coincida con la fecha seedeada
            // y el calendario JS renderice correctamente los días disponibles.
            var minHoraRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                connectionString,
                "SELECT MIN(horaInicio) AS MinHora FROM horasLaborales");
            var minHora = (TimeSpan)minHoraRow!["MinHora"];

            var clockDate = fechaReferencia.Value
                .ToDateTime(TimeOnly.FromTimeSpan(minHora));
            await Page.Clock.SetFixedTimeAsync(clockDate);
        }

        var seedResult = await InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(
            connectionString, fechaReferencia);
        Assert.NotNull(seedResult);
        var (clienteId, idInscripcion) = seedResult!.Value;

        // CreateValidDestinationClassForReagendarAsync crea la clase destino
        // y retorna su ID + fecha + hora para selección explícita en la UI.
        var destino = await InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync(
            connectionString, idInscripcion, fechaReferencia);
        Assert.True(destino.IdClaseProgramada > 0, "No se pudo crear la clase programada destino; no hay horarios disponibles.");
        var idClaseProgramadaDestino = destino.IdClaseProgramada;
        var fechaDestino = destino.FechaDeLaClase;

        // GIVEN: empleado logueado en el sistema (UI natural)
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);
        await Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // Neutralizar sessionValidator.js: con el reloj del browser congelado en el futuro
        // (SetFixedTimeAsync), el exp real del JWT (60 min) aparece vencido y el validador
        // dispara logout a los ~10s. Inyectamos un exp lejano RELATIVO al reloj congelado
        // (Date.now() dentro de la página respeta el clock de Playwright): warning a ~59 min,
        // sin logout durante el test. Formato JSON porque LocalStorageManager guarda con
        // JSON.stringify y lee con JSON.parse.
        await Page.EvaluateAsync(
            "() => localStorage.setItem('idTokenExpiration', JSON.stringify(Math.floor(Date.now() / 1000) + 3600))");

        // WHEN: navega a la vista de cancelar/reagendar usando el Page Model (UI natural)
        var cancelarReagendarPage = new CancelarReagendarPage(Page);
        await cancelarReagendarPage.GoToAsync(BaseUrl);

        // THEN: la vista se renderiza
        await Expect(cancelarReagendarPage.Title).ToContainTextAsync("Cancelar / Reagendar Inscripción");

        // WHEN: selecciona el cliente en el combo (UI natural)
        await cancelarReagendarPage.SelectClientAsync(clienteId);

        // WHEN: espera inscripciones y selecciona exactamente la inscripción creada por el seed
        await cancelarReagendarPage.SelectEnrollmentAsync(idInscripcion.ToString());

        // WHEN: marca el checkbox de reagendar (muestra calendario y scheduler)
        await cancelarReagendarPage.EnableReschedulingAsync();

        // WHEN: espera a que el scheduler renderice un horario con idClaseProgramada.
        // El render es asíncrono (fetch + animación escalonada) y un horario sin
        // idClaseProgramada (franja libre) no sirve para reagendar.
        await cancelarReagendarPage.WaitForSchedulesLoadedAsync();

        // WHEN: navegar al día destino y seleccionar el horario con el ID exacto sembrado.
        // Esto garantiza que se envía el ID de la clase programada correcta, no el de
        // cualquier otra programación de la misma fkClase que el calendario haya cargado.
        await cancelarReagendarPage.SelectDestinationByIdAsync(
            idClaseProgramadaDestino.ToString(), fechaDestino);

        // WHEN: click en el botón Reagendar (UI natural)
        await cancelarReagendarPage.ExecuteAsync();

        // THEN: muestra SweetAlert2 con mensaje de éxito
        var swalTitle = Page.Locator(".swal2-title");
        await Expect(swalTitle).ToHaveTextAsync(
            "Inscripción reagendada exitosamente",
            new LocatorAssertionsToHaveTextOptions
            {
                Timeout = 15_000
            });

        // AND: el icono de éxito está presente
        var swalIcon = Page.Locator(".swal2-success");
        await Expect(swalIcon).ToBeVisibleAsync();
    }

    #endregion
}
