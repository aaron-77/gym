using System.Text.RegularExpressions;
using Microsoft.Playwright;
using GymWebApp.Tests.E2E.Common;
using Xunit;

namespace GymWebApp.Tests.E2E.Features;

[Collection("E2E HappyPaths")]
public class NavigationE2ETests : PlaywrightTestBase
{
    public NavigationE2ETests(E2eContainerHelper e2eContainerHelper, PlaywrightHelper playwrightHelper) 
        : base(e2eContainerHelper, playwrightHelper)
    {
    }
    /// <summary>
    /// Verifies that clicking the "Clase" navigation link navigates to the Clases page.
    /// Scenario: Navigation from homepage to Clases page via menu link
    /// </summary>
    [Fact]
    public async Task Navigation_ClickOnClasesLink_LoadsClasesPage()
    {
        // GIVEN: usuario en homepage
        await Page.GotoAsync(E2eContainerHelper.Instance.FrontendBaseUrl);

        // WHEN: hacer click en link de navegación "Clases"
        var clasesLink = Page.GetByRole(AriaRole.Link, new() { Name = "Clase" }).First;
        await clasesLink.ClickAsync();

        // THEN: URL refleja navegación
        await Page.WaitForURLAsync(new Regex(".*/#classes.*", RegexOptions.IgnoreCase));

        // AND: verificar que la página contiene contenido relacionado
        var title = await Page.TitleAsync();
        Assert.True(!string.IsNullOrWhiteSpace(title),
            "Clases page should load with a valid title");
    }

    /// <summary>
    /// Verifies that clicking the "Horarios" navigation link navigates to the Horarios page.
    /// Scenario: Navigation from homepage to Horarios page via menu link
    /// </summary>
    [Fact]
    public async Task Navigation_ClickOnHorariosLink_LoadsHorariosPage()
    {
        // GIVEN: usuario en homepage
        await Page.GotoAsync(E2eContainerHelper.Instance.FrontendBaseUrl);

        // WHEN: hacer click en link de navegación "Horarios"
        var horariosLink = Page.GetByRole(AriaRole.Link, new() { Name = "Horarios" });
        await horariosLink.ClickAsync();

        // THEN: URL refleja navegación
        await Page.WaitForURLAsync(new Regex(".*/horarios.*", RegexOptions.IgnoreCase));

        // AND: verificar que la página contiene contenido relacionado
        var title = await Page.TitleAsync();
        Assert.True(!string.IsNullOrWhiteSpace(title),
            "Horarios page should load with a valid title");
    }

    /// <summary>
    /// Verifies that clicking the "Home" navigation link returns to the homepage.
    /// Scenario: Navigation from Clases page back to Homepage via menu link
    /// </summary>
    [Fact]
    public async Task Navigation_ClickOnHomeLink_ReturnsToHomepage()
    {
        // GIVEN: usuario en página de clases
        await Page.GotoAsync($"{E2eContainerHelper.Instance.FrontendBaseUrl}/#classes");

        // WHEN: hacer click en link de navegación "Home"
        var homeLink = Page.GetByRole(AriaRole.Link, new() { Name = "Inicio" }).First;
        await homeLink.ClickAsync();

        // THEN: página carga en homepage
        await Page.WaitForURLAsync(new Regex(".*(/|/?home|/?Index)", RegexOptions.IgnoreCase));
    }
}
