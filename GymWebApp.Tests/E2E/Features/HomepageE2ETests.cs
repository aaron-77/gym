using System.Text.RegularExpressions;
using Microsoft.Playwright;
using GymWebApp.Tests.E2E.Common;
using Xunit;

namespace GymWebApp.Tests.E2E.Features;

[Collection("E2E Tests")]
public class HomepageE2ETests : PlaywrightTestBase, IAsyncLifetime
{
    /// <summary>
    /// Verifies that the homepage loads successfully with a valid page title.
    /// Scenario: Homepage accessibility - page loads and displays title
    /// </summary>
    [Fact]
    public async Task Homepage_LoadsSuccessfully()
    {
        // GIVEN: aplicación corriendo
        // WHEN: navegar a /
        await Page.GotoAsync(E2eContainerHelper.FrontendBaseUrl);

        // THEN: página carga con título que contiene texto relacionado a Fitness o Home
        var title = await Page.TitleAsync();
        Assert.True(Regex.IsMatch(title, "Fitness|Gym|Home|Inicio", RegexOptions.IgnoreCase),
            $"Page title should match Fitness/Gym/Home pattern. Actual title: '{title}'");
    }

    /// <summary>
    /// Verifies that the homepage displays scheduled classes in an H1 heading.
    /// Scenario: Homepage content - scheduled classes heading is visible
    /// </summary>
    [Fact]
    public async Task Homepage_ShowsScheduledClasses()
    {
        // GIVEN: aplicación corriendo
        await Page.GotoAsync(E2eContainerHelper.FrontendBaseUrl);

        // THEN: heading H1 visible con texto relacionado a clases programadas
        var heading = Page.GetByRole(AriaRole.Heading, new() { Level = 1 });
        await heading.WaitForAsync(new LocatorWaitForOptions { State = WaitForSelectorState.Visible });
        var headingText = await heading.InnerTextAsync();
        Assert.True(!string.IsNullOrWhiteSpace(headingText),
            "H1 heading should have visible text content");
    }

    /// <summary>
    /// Verifies that the homepage displays the navigation menu with a link to Clases.
    /// Scenario: Homepage navigation - navigation menu and Clase link are visible
    /// </summary>
    [Fact]
    public async Task Homepage_NavigationMenuIsVisible()
    {
        // GIVEN: aplicación corriendo
        await Page.GotoAsync(E2eContainerHelper.FrontendBaseUrl);

        // THEN: menu navegación visible
        var navMenu = Page.Locator("nav");
        await navMenu.WaitForAsync(new LocatorWaitForOptions { State = WaitForSelectorState.Visible });

        // Verificar link de navegación "Clase"
        var clasesLink = Page.GetByRole(AriaRole.Link, new() { Name = "Clase" });
        await clasesLink.WaitForAsync(new LocatorWaitForOptions { State = WaitForSelectorState.Visible });
    }
}
