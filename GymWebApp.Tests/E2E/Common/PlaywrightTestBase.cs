using System.Text.RegularExpressions;
using Microsoft.Playwright;
using Xunit;

namespace GymWebApp.Tests.E2E.Common;

public abstract class PlaywrightTestBase : IAsyncLifetime
{
    protected E2eContainerHelper E2eContainerHelper { get; }
    protected PlaywrightHelper PlaywrightHelper { get; }

    private IBrowserContext? _context;
    private IPage? _page;

    protected IPage Page => _page 
        ?? throw new InvalidOperationException("Page not initialized. Call InitializeAsync first.");

    protected PlaywrightTestBase(E2eContainerHelper e2eContainerHelper, PlaywrightHelper playwrightHelper)
    {
        E2eContainerHelper = e2eContainerHelper;
        PlaywrightHelper = playwrightHelper;
    }

    public async Task InitializeAsync()
    {
        var (context, page) = await PlaywrightHelper.CreateNewContextAndPageAsync();
        _context = context;
        _page = page;

        await E2eContainerHelper.ResetDatabaseAsync();
    }

    public async Task DisposeAsync()
    {
        if (_page != null)
            await _page.CloseAsync();
        if (_context != null)
            await _context.CloseAsync();
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