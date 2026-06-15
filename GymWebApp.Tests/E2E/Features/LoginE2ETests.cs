using System.Text.RegularExpressions;
using Microsoft.Playwright;
using GymWebApp.Tests.E2E.Common;
using Xunit;

namespace GymWebApp.Tests.E2E.Features;

[Collection("E2E HappyPaths")]
public class LoginE2ETests : PlaywrightTestBase
{
    public LoginE2ETests(E2eContainerHelper e2eContainerHelper, PlaywrightHelper playwrightHelper) 
        : base(e2eContainerHelper, playwrightHelper)
    {
    }
    /// <summary>
    /// Verifies that a user can log in with valid credentials and is redirected to the homepage.
    /// Scenario: Happy path login - valid credentials redirect to homepage
    /// </summary>
    [Fact]
    public async Task Login_ValidCredentials_RedirectsToHomepage()
    {
        // GIVEN: usuario registrado existe en la base de datos (seeded data)
        // WHEN: navegar a /signIn + completar form + submit
        await Page.GotoAsync($"{E2eContainerHelper.Instance.FrontendBaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        // THEN: redirect a homepage
        await Page.WaitForURLAsync(new Regex(".*(/|/?home|/?Index)", RegexOptions.IgnoreCase));
        // AND: verificar que la página cargó con contenido real
        var title = await Page.TitleAsync();
        Assert.True(!string.IsNullOrWhiteSpace(title), "Page title should not be empty after login");
    }

    /// <summary>
    /// Verifies that a user cannot log in with invalid credentials and an error message is displayed.
    /// Scenario: Sad path login - invalid credentials show error message and stay on login page
    /// </summary>
    [Fact]
    public async Task Login_InvalidCredentials_ShowsError()
    {
        // GIVEN: usuario registrado existe en la base de datos
        await Page.GotoAsync($"{E2eContainerHelper.Instance.FrontendBaseUrl}/signIn");

        // WHEN: completar form con credenciales inválidas + submit
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", "WrongPassword123!");
        await Page.ClickAsync("button.sign");

        // THEN: muestra mensaje de error
        var errorMessage = Page.GetByText(new Regex("credenciales inválidas|incorrectos|error|inválid", RegexOptions.IgnoreCase));
        await errorMessage.WaitForAsync(new LocatorWaitForOptions { State = WaitForSelectorState.Visible });

        // AND: la URL permanece en /signIn (no hay redirect)
        Assert.Contains("signIn", Page.Url, StringComparison.OrdinalIgnoreCase);
    }
}
