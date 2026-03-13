## UI Testing Host Configuration

Use `WebApplicationFactory<TEntryPoint>` to launch the application on a real ephemeral local port for Playwright to connect as an external client.

### Basic WebApplicationFactory Configuration

```csharp
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Playwright;

public class PlaywrightWebApplicationFactory<TProgram> : WebApplicationFactory<TProgram> where TProgram : class
{
    public string BaseUrl { get; private set; } = null!;

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseUrls("http://127.0.0.1:0");  // Ephemeral port

        builder.ConfigureServices(services =>
        {
            // Configure services for testing if needed
        });
    }

    protected override async Task CreateHostAsync()
    {
        await base.CreateHostAsync();
        BaseUrl = Server.Url;  // Get dynamically assigned port
    }
}
```

### Browser and Context Management

```csharp
public class PlaywrightFixture : IAsyncLifetime
{
    private IBrowser? _browser;
    public IBrowser Browser => _browser!;
    public IBrowserContext? Context { get; private set; }
    public string? BaseUrl { get; private set; }

    private PlaywrightWebApplicationFactory<Program>? _factory;

    public async Task InitializeAsync()
    {
        // Start the application
        _factory = new PlaywrightWebApplicationFactory<Program>();
        await _factory.CreateHostAsync();
        BaseUrl = _factory.BaseUrl;

        // Launch browser - reuse context for efficiency
        var playwright = await Playwright.CreateAsync();
        _browser = await playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
        {
            Headless = true
        });

        Context = await _browser.NewContextAsync();
    }

    public async Task<IPage> NewPageAsync()
    {
        if (Context == null || BaseUrl == null)
            throw new InvalidOperationException("Fixture not initialized");

        var page = await Context.NewPageAsync();
        await page.GotoAsync(BaseUrl);
        return page;
    }

    public async Task DisposeAsync()
    {
        Context?.DisposeAsync();
        await _browser?.CloseAsync()!;
        _factory?.Dispose();
    }
}
```

### Using with IClassFixture

```csharp
public class RazorPageTests : IClassFixture<PlaywrightFixture>
{
    private readonly PlaywrightFixture _playwrightFixture;

    public RazorPageTests(PlaywrightFixture playwrightFixture)
    {
        _playwrightFixture = playwrightFixture;
    }

    [Fact]
    public async Task HomePage_LoadsSuccessfully()
    {
        var page = await _playwrightFixture.NewPageAsync();
        await page.GotoAsync("/");
        
        await Expect(page).ToHaveTitleAsync(new Regex("Home"));
    }
}
```

### Key Points

- Use `http://127.0.0.1:0` for ephemeral port assignment
- Get dynamic URL from `Server.Url` after host is created
- Reuse browser context between tests to optimize resources
- Use `IAsyncLifetime` for proper browser lifecycle management
- Launch Chromium/Firefox/WebKit based on needs
