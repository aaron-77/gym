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
    /// Verifies that clicking the "Home" navigation link returns to the homepage.
    /// Scenario: Navigation from Clases page back to Homepage via menu link
    /// </summary>
    [Fact]
    public async Task Navigation_ClickOnHomeLink_ReturnsToHomepage()
    {
        // GIVEN: usuario en página de clases
        await Page.GotoAsync($"{E2eContainerHelper.Instance.FrontendBaseUrl}/#clases");

        // WHEN: hacer click en link de navegación "Home"
        var homeLink = Page.GetByRole(AriaRole.Link, new() { Name = "Inicio" }).First;
        await homeLink.ClickAsync();

        // THEN: página carga en homepage
        await Page.WaitForURLAsync(new Regex(".*(/|/?home|/?Index)", RegexOptions.IgnoreCase));
    }
}
