using Microsoft.Playwright;
using GymWebApp.Tests.E2E.Common;
using Xunit;
using static Microsoft.Playwright.Assertions;

namespace GymWebApp.Tests.E2E.Features;

/// <summary>
/// Tests E2E para el endpoint GET /Inscripciones/cancelarReagendar (spec 36).
/// Verifica que el empleado autenticado pueda acceder a la vista de cancelar/reagendar
/// inscripciones, y que los casos de acceso no autorizado redirijan correctamente.
/// </summary>
[Collection("E2E HappyPaths")]
public class CancelarReagendarE2ETests : PlaywrightTestBase
{
    public CancelarReagendarE2ETests(E2eContainerHelper e2eContainerHelper, PlaywrightHelper playwrightHelper)
        : base(e2eContainerHelper, playwrightHelper)
    {
    }

    private string BaseUrl => E2eContainerHelper.Instance.NginxBaseUrl;

    #region Happy Path

    /// <summary>
    /// Test 1: Empleado autenticado accede a la vista de cancelar/reagendar.
    /// Se loguea como empleado, navega a la página y verifica que el contenido
    /// se renderiza correctamente (tabla de clientes o mensaje informativo).
    /// </summary>
    [Fact]
    public async Task Empleado_CancelarReagendar_AccedeVistaConClientes()
    {
        // GIVEN: empleado logueado en el sistema
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);
        await Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // WHEN: navega a cancelar/reagendar inscripción
        await Page.GotoAsync($"{BaseUrl}/Inscripciones/cancelarReagendar");
        await Page.WaitForLoadStateAsync(LoadState.NetworkIdle);

        // THEN: la vista se renderiza con el título correspondiente
        await Expect(Page.Locator("h1")).ToContainTextAsync("Cancelar / Reagendar Inscripción");

        // AND: muestra el combo de clientes o el mensaje de "no se encontraron clientes"
        // Ambos casos son válidos — lo importante es que NO muestra un error
        var comboCliente = Page.Locator("#comboCliente");
        var noClientesMsg = Page.Locator("text=No se encontraron clientes activos");
        var errorAlert = Page.Locator(".alert-danger");

        var comboVisible = await comboCliente.IsVisibleAsync();
        var noClientesVisible = await noClientesMsg.IsVisibleAsync();

        Assert.True(comboVisible || noClientesVisible,
            $"La página debería mostrar el combo de clientes o el mensaje de 'no se encontraron clientes'. " +
            $"Combo visible: {comboVisible}, NoClientes visible: {noClientesVisible}");

        // AND: el mensaje de error de API NO debe aparecer
        await Expect(errorAlert).Not.ToBeVisibleAsync();
    }

    #endregion

    #region Edge Cases — Autenticación y Autorización

    /// <summary>
    /// Test 2: Usuario sin autenticación intenta acceder a la página.
    /// El middleware JWT OnChallenge redirige a /signIn.
    /// </summary>
    [Fact]
    public async Task CancelarReagendar_SinAutenticacion_RedirectALogin()
    {
        // WHEN: navegar directamente a la página sin estar autenticado
        await Page.GotoAsync($"{BaseUrl}/Inscripciones/cancelarReagendar");

        // THEN: redirige a signIn (el OnChallenge del JWT Bearer hace redirect)
        // o bien muestra el formulario de login si la redirección ocurre
        var loginInput = Page.Locator("input[name='correo']");
        await Expect(loginInput).ToBeVisibleAsync(new LocatorAssertionsToBeVisibleOptions
        {
            Timeout = 10_000
        });

        // AND: la URL contiene /signIn
        Assert.Contains("signIn", Page.Url, StringComparison.OrdinalIgnoreCase);
    }

    /// <summary>
    /// Test 3: Usuario logueado como cliente intenta acceder a una página
    /// exclusiva para empleados. El middleware retorna 403 y redirige a AccesoDenegado.
    /// </summary>
    [Fact]
    public async Task CancelarReagendar_RolCliente_AccesoDenegado()
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

    // NOTA: El test de error de API (API no responde → vista con mensaje de error)
    // se implementa como test de integración en:
    // Integration/Features/Inscripciones/CancelarReagendarApiErrorTests.cs
    // porque requiere simular un error de conexión que no es posible en E2E
    // (el stack completo está corriendo).
}
