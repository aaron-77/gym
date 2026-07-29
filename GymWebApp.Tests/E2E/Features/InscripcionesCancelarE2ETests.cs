using Microsoft.Playwright;
using GymWebApp.Tests.E2E.Common;
using GymWebApp.Tests.Integration.Helpers;
using Xunit;
using static Microsoft.Playwright.Assertions;

namespace GymWebApp.Tests.E2E.Features;

/// <summary>
/// Tests E2E para el botón Cancelar en la vista de cancelar/reagendar inscripción
/// (spec 46). Verifica que el empleado autenticado pueda cancelar una inscripción
/// desde la UI, y que los casos de acceso no autorizado redirijan correctamente.
/// </summary>
[Collection("E2E HappyPaths")]
public class InscripcionesCancelarE2ETests : PlaywrightTestBase
{
    public InscripcionesCancelarE2ETests(
        E2eContainerHelper e2eContainerHelper,
        PlaywrightHelper playwrightHelper)
        : base(e2eContainerHelper, playwrightHelper)
    {
    }

    private string BaseUrl => E2eContainerHelper.Instance.NginxBaseUrl;

    #region Happy Path

    /// <summary>
    /// Test 1: Empleado autenticado cancela una inscripción desde la UI.
    /// Login → selecciona cliente → selecciona inscripción → click Cancelar →
    /// SweetAlert2 de éxito.
    /// </summary>
    [Fact]
    public async Task Cancelar_InscripcionValida_RetornaOk()
    {
        // GIVEN: empleado logueado en el sistema
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);
        await Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // GIVEN: datos de prueba en BD
        await InscripcionEndpointHelper.SeedFreshInscripcionAsync(E2eContainerHelper.Instance.HostConnectionString);

        // WHEN: navega a la vista de cancelar/reagendar
        await Page.GotoAsync($"{BaseUrl}/Inscripciones/cancelarReagendar");
        await Page.WaitForLoadStateAsync(LoadState.NetworkIdle);

        // THEN: la vista se renderiza con el título
        await Expect(Page.Locator("h1")).ToContainTextAsync("Cancelar / Reagendar Inscripción");

        // WHEN: selecciona el primer cliente del combo
        var comboCliente = Page.Locator("#comboCliente");
        var firstClientOption = comboCliente.Locator("option:not([value=''])").First;
        var clientValue = await firstClientOption.GetAttributeAsync("value");
        await comboCliente.SelectOptionAsync(clientValue!);

        // WHEN: espera que se carguen las inscripciones y selecciona una
        var comboInscripcion = Page.Locator("#comboInscripcion");
        await Expect(comboInscripcion).ToBeEnabledAsync(new LocatorAssertionsToBeEnabledOptions
        {
            Timeout = 15_000
        });

        var firstInscripcionOption = comboInscripcion.Locator("option:not([value=''])").First;
        var inscripcionValue = await firstInscripcionOption.GetAttributeAsync("value");
        await comboInscripcion.SelectOptionAsync(inscripcionValue!);

        // WHEN: click en Cancelar
        await Page.Locator("#btnEjecutar").ClickAsync();

        // THEN: muestra SweetAlert2 con mensaje de éxito
        var swalTitle = Page.Locator(".swal2-title");
        await Expect(swalTitle).ToHaveTextAsync("Inscripción cancelada exitosamente", new LocatorAssertionsToHaveTextOptions
        {
            Timeout = 10_000
        });

        // AND: el icono de éxito está presente en el Swal2
        var swalIcon = Page.Locator(".swal2-success");
        await Expect(swalIcon).ToBeVisibleAsync();
    }

    #endregion

    #region Edge Cases — Autenticación y Autorización

    /// <summary>
    /// Test 2: Usuario sin autenticación intenta acceder a la página.
    /// El middleware JWT OnChallenge redirige a /signIn.
    /// </summary>
    [Fact]
    public async Task Cancelar_SinAutenticacion_RetornaRedirectToLogin()
    {
        // WHEN: navegar directamente a la página sin estar autenticado
        await Page.GotoAsync($"{BaseUrl}/Inscripciones/cancelarReagendar");

        // THEN: redirige a signIn
        var loginInput = Page.Locator("input[name='correo']");
        await Expect(loginInput).ToBeVisibleAsync(new LocatorAssertionsToBeVisibleOptions
        {
            Timeout = 10_000
        });

        Assert.Contains("signIn", Page.Url, StringComparison.OrdinalIgnoreCase);
    }

    /// <summary>
    /// Test 3: Usuario logueado como cliente intenta acceder a la página
    /// exclusiva para empleados. El middleware retorna 403 y redirige.
    /// </summary>
    [Fact]
    public async Task Cancelar_UsuarioSinRolEmpleado_RetornaForbidden()
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

        // THEN: redirige a AccesoDenegado
        Assert.Contains("AccesoDenegado", Page.Url, StringComparison.OrdinalIgnoreCase);
    }

    #endregion
}