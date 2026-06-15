using Microsoft.Playwright;
using Xunit;

namespace GymWebApp.Tests.E2E.Common;

public class PlaywrightHelper : IAsyncLifetime
{
    private IPlaywright? _playwright;
    private IBrowser? _browser;

    public IBrowser Browser => _browser 
        ?? throw new InvalidOperationException("PlaywrightHelper not initialized");

    public async Task InitializeAsync()
    {
        _playwright = await Playwright.CreateAsync();
        _browser = await _playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
        {
            Headless = false
        });
    }

    public async Task<(IBrowserContext Context, IPage Page)> CreateNewContextAndPageAsync()
    {
        if (_browser == null)
            throw new InvalidOperationException("Browser not initialized");

        var context = await _browser.NewContextAsync();
        var page = await context.NewPageAsync();
        return (context, page);
    }

    public async Task DisposeAsync()
    {
        if (_browser != null)
            await _browser.CloseAsync();
        _playwright?.Dispose();
    }
}