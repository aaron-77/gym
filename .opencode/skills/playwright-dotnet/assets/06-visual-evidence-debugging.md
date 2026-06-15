## Visual Evidence and Debugging

Capture screenshots and traces upon failure to facilitate rendering debugging.

### Screenshot on Failure

```csharp
public class PlaywrightFixture : IAsyncLifetime
{
    private IBrowser? _browser;
    public IBrowser Browser => _browser!;
    public IBrowserContext? Context { get; private set; }

    public async Task InitializeAsync()
    {
        var playwright = await Playwright.CreateAsync();
        _browser = await playwright.Chromium.LaunchAsync();
        
        Context = await _browser.NewContextAsync();
    }

    public async Task DisposeAsync()
    {
        Context?.DisposeAsync();
        await _browser?.CloseAsync()!;
    }
}

public class RazorPageTests : IClassFixture<PlaywrightFixture>
{
    private readonly PlaywrightFixture _fixture;

    public RazorPageTests(PlaywrightFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task ProductPage_LoadsCorrectly()
    {
        var page = await _fixture.NewPageAsync();
        
        try
        {
            await page.GotoAsync("/products/1");
            
            var productName = page.Locator(".product-name");
            await Expect(productName).ToHaveTextAsync("Laptop Pro");
        }
        catch (Exception)
        {
            // Capture screenshot on failure
            var screenshotPath = Path.Combine(
                Directory.GetCurrentDirectory(),
                "test-results",
                $"failure_{DateTime.Now:yyyyMMdd_HHmmss}.png");
            
            Directory.CreateDirectory(Path.GetDirectoryName(screenshotPath)!);
            await page.ScreenshotAsync(new PageScreenshotOptions
            {
                Path = screenshotPath,
                FullPage = true
            });
            
            throw;
        }
    }
}
```

### Automatic Screenshot on Every Failure

```csharp
public class PlaywrightFixture : IAsyncLifetime
{
    public IBrowserContext? Context { get; private set; }
    
    public async Task InitializeAsync()
    {
        var playwright = await Playwright.CreateAsync();
        var browser = await playwright.Chromium.LaunchAsync();
        
        Context = await browser.NewContextAsync();
        
        // Auto-screenshot on failure for all tests
        Context.SetDefaultTimeout(30000);
    }
}
```

### Trace Recording

```csharp
[Fact]
public async Task ComplexWorkflow_CompletesSuccessfully()
{
    var page = await _fixture.NewPageAsync();
    
    // Start trace before the test
    var tracing = page.Context.Tracing;
    await tracing.StartAsync(new TracingStartOptions
    {
        Screenshots = true,
        Snapshots = true,
        Sources = true
    });

    try
    {
        // Perform actions
        await page.GotoAsync("/");
        await page.ClickAsync(".products-link");
        await page.WaitForSelectorAsync(".product-list");
        
        // Stop and save trace
        var tracePath = Path.Combine(
            Directory.GetCurrentDirectory(),
            "test-results",
            $"trace_{DateTime.Now:yyyyMMdd_HHmmss}.zip");
        
        await tracing.StopAsync(new TracingStopOptions
        {
            Path = tracePath
        });
        
        // To view: playwright show-trace tracePath
    }
    catch (Exception)
    {
        var screenshotPath = Path.Combine(
            Directory.GetCurrentDirectory(),
            "test-results",
            $"failure_screenshot.png");
        await page.ScreenshotAsync(new PageScreenshotOptions
        {
            Path = screenshotPath,
            FullPage = true
        });
        throw;
    }
}
```

### Video Recording

```csharp
public async Task InitializeAsync()
{
    var playwright = await Playwright.CreateAsync();
    var browser = await playwright.Chromium.LaunchAsync();
    
    Context = await browser.NewContextAsync(new BrowserNewContextOptions
    {
        // Record video for each test
        RecordVideoDir = Path.Combine(Directory.GetCurrentDirectory(), "test-results", "videos"),
        RecordVideoSize = new RecordVideoSize { Width = 1280, Height = 720 }
    });
}
```

### Console Log Capture

```csharp
[Fact]
public async Task Page_LogsRenderedCorrectly()
{
    var page = await _fixture.NewPageAsync();
    
    // Capture console logs
    var consoleMessages = new List<string>();
    page.Console += (_, msg) => consoleMessages.Add($"[{msg.Type}] {msg.Text}");

    await page.GotoAsync("/products");

    // Verify no JavaScript errors
    var errors = consoleMessages.Where(m => m.Contains("[error]")).ToList();
    Assert.Empty(errors);
}
```

### HTML Dump on Failure

```csharp
[Fact]
public async Task DebugHtmlOnFailure()
{
    var page = await _fixture.NewPageAsync();
    
    try
    {
        await page.GotoAsync("/products");
        await page.WaitForSelectorAsync(".product-item");
    }
    catch (Exception)
    {
        // Dump HTML on failure
        var htmlPath = Path.Combine(
            Directory.GetCurrentDirectory(),
            "test-results",
            $"failure_{DateTime.Now:yyyyMMdd_HHmmss}.html");
        
        var html = await page.ContentAsync();
        await File.WriteAllTextAsync(htmlPath, html);
        
        throw;
    }
}
```

### Key Points

- Use `page.ScreenshotAsync()` to capture visual evidence
- Use `page.Context.Tracing` for detailed traces
- Save traces to ZIP files for later analysis with `playwright show-trace`
- Use video recording for complex workflows
- Capture console logs to detect JavaScript errors
- Dump HTML content for debugging rendering issues
- Organize screenshots/traces in dedicated test-results folder
