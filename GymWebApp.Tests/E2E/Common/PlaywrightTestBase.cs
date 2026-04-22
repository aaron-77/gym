using System.Text.RegularExpressions;
using Microsoft.Playwright;
using Xunit;

namespace GymWebApp.Tests.E2E.Common;

public abstract class PlaywrightTestBase : IAsyncLifetime
{
    private static bool _isInitialized;
    protected IPlaywright? _playwright;
    protected IBrowser? _browser;
    protected IBrowserContext? _context;
    protected IPage? _page;

    protected IPage Page => _page!;

    public async Task InitializeAsync()
    {
        // Ensure containers are initialized before any test runs
        // This uses IAsyncLifetime pattern which xUnit calls properly
        if (!_isInitialized)
        {
            await E2eContainerHelper.InitializeAsync();
            _isInitialized = true;
        }

        _playwright = await Playwright.CreateAsync();
        _browser = await _playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
        {
            Headless = false
        });
        _context = await _browser.NewContextAsync();
        _page = await _context.NewPageAsync();
    }

    public async Task DisposeAsync()
    {
        if (_page != null) await _page.CloseAsync();
        if (_context != null) await _context.CloseAsync();
        if (_browser != null) await _browser.CloseAsync();
        _playwright?.Dispose();

        if (_isInitialized)
        {
            await E2eContainerHelper.DisposeAsync();
            _isInitialized = false;
        }
    }

    /// <summary>
    /// Captures a screenshot on test failure for debugging.
    /// Call this in a catch block or after an assertion failure.
    /// </summary>
    protected async Task CaptureScreenshotAsync(string testName)
    {
        if (_page == null) return;

        var screenshotsDir = Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "E2E", "Screenshots");
        Directory.CreateDirectory(screenshotsDir);

        var fileName = $"{testName}_{DateTimeOffset.UtcNow:yyyyMMdd_HHmmss}.png";
        var filePath = Path.Combine(screenshotsDir, fileName);

        await _page.ScreenshotAsync(new PageScreenshotOptions
        {
            Path = filePath,
            FullPage = true
        });
    }
}
