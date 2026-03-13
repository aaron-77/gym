## E2E Test Examples

Complete end-to-end test examples combining all patterns.

### Complete Test Class with All Patterns

```csharp
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Playwright;
using System.Text.RegularExpressions;

namespace GymWebApp.Tests.E2E;

public class ProductPageTests : IClassFixture<PlaywrightFixture>
{
    private readonly PlaywrightFixture _fixture;

    public ProductPageTests(PlaywrightFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task ProductList_DisplaysAllProducts_WithCorrectData()
    {
        // Arrange - handled by fixture

        // Act
        var page = await _fixture.NewPageAsync();
        await page.GotoAsync("/products");

        // Assert - DOM validation
        var productItems = page.Locator(".product-item");
        await Expect(productItems).ToHaveCountAsync(3);

        // Assert - First product data from @Model
        var firstProduct = productItems.First;
        await Expect(firstProduct).ToHaveClassAsync(new Regex("product-card"));
        await Expect(firstProduct).ToHaveTextAsync(new Regex("Laptop Pro"));
        await Expect(firstProduct).ToHaveTextAsync(new Regex("\\$999\\.99"));
    }

    [Fact]
    public async Task ProductList_FilterByCategory_WorksCorrectly()
    {
        var page = await _fixture.NewPageAsync();
        await page.GotoAsync("/products?category=electronics");

        // Verify filter applied
        var categoryFilter = page.Locator(".active-filter");
        await Expect(categoryFilter).ToHaveTextAsync("Electronics");

        // Verify filtered results
        var productItems = page.Locator(".product-item");
        await Expect(productItems).ToHaveCountAsync(new Regex("[1-9]"));
    }

    [Fact]
    public async Task ProductDetail_Navigation_Works()
    {
        var page = await _fixture.NewPageAsync();
        await page.GotoAsync("/products");

        // Click first product
        await page.ClickAsync(".product-item:first-child .product-link");

        // Verify navigation
        await Expect(page).ToHaveURLAsync(new Regex("/products/\\d+"));

        // Verify detail page renders model
        var productName = page.Locator(".product-detail .product-name");
        await Expect(productName).ToBeVisibleAsync();
    }
}
```

### Authentication Flow Test

```csharp
public class AuthenticationTests : IClassFixture<PlaywrightFixture>
{
    private readonly PlaywrightFixture _fixture;

    public AuthenticationTests(PlaywrightFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task Login_WithValidCredentials_RedirectsToDashboard()
    {
        var page = await _fixture.NewPageAsync();
        
        // Navigate to login page
        await page.GotoAsync("/account/login");

        // Fill login form (@model LoginViewModel)
        await page.FillAsync("input[name=\"Email\"]", "user@example.com");
        await page.FillAsync("input[name=\"Password\"]", "Password123!");

        // Submit form
        await page.ClickAsync("button[type=\"submit\"]");

        // Verify redirect
        await Expect(page).ToHaveURLAsync(new Regex("/dashboard"));

        // Verify user menu rendered (@if (User.Identity.IsAuthenticated))
        var userMenu = page.Locator(".user-menu");
        await Expect(userMenu).ToBeVisibleAsync();
    }

    [Fact]
    public async Task Login_WithInvalidCredentials_ShowsError()
    {
        var page = await _fixture.NewPageAsync();
        await page.GotoAsync("/account/login");

        await page.FillAsync("input[name=\"Email\"]", "wrong@example.com");
        await page.FillAsync("input[name=\"Password\"]", "wrongpassword");
        awaitbutton[type=\"submit\"]");

        page.ClickAsync(" // Verify error message rendered
        var errorMessage = page.Locator(".validation-summary-errors");
        await Expect(errorMessage).ToBeVisibleAsync();
        await Expect(errorMessage).ToContainTextAsync("Invalid login attempt");
    }
}
```

### Shopping Cart E2E Test

```csharp
public class ShoppingCartTests : IClassFixture<PlaywrightFixture>
{
    private readonly PlaywrightFixture _fixture;

    public ShoppingCartTests(PlaywrightFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task AddToCart_UpdatesCartCount()
    {
        var page = await _fixture.NewPageAsync();
        await page.GotoAsync("/products/1");

        // Add to cart (button rendered by Razor)
        await page.ClickAsync(".add-to-cart-button");

        // Verify cart badge updated (@ViewBag.CartCount)
        var cartBadge = page.Locator(".cart-badge");
        await Expect(cartBadge).ToHaveTextAsync("1");
    }

    [Fact]
    public async Task CartPage_DisplaysAddedItems()
    {
        // First add item
        var page = await _fixture.NewPageAsync();
        await page.GotoAsync("/products/1");
        await page.ClickAsync(".add-to-cart-button");

        // Navigate to cart
        await page.GotoAsync("/cart");

        // Verify item in cart (@foreach var item in Model)
        var cartItems = page.Locator(".cart-item");
        await Expect(cartItems).ToHaveCountAsync(1);

        // Verify item details
        var firstItem = cartItems.First;
        await Expect(firstItem).ToHaveTextAsync("Laptop Pro");
        await Expect(firstItem).ToHaveTextAsync("$999.99");
    }

    [Fact]
    public async Task UpdateQuantity_RecalculatesTotal()
    {
        var page = await _fixture.NewPageAsync();
        await page.GotoAsync("/cart");

        // Update quantity
        await page.SelectOptionAsync(".quantity-select", "2");

        // Wait for AJAX update
        await page.WaitForResponseAsync(response => 
            response.Url.Contains("/cart/update"));

        // Verify total updated
        var cartTotal = page.Locator(".cart-total");
        await Expect(cartTotal).ToHaveTextAsync("$1999.98");
    }
}
```

### Admin Panel Test

```csharp
public class AdminPanelTests : IClassFixture<PlaywrightFixture>
{
    private readonly PlaywrightFixture _fixture;

    public AdminPanelTests(PlaywrightFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task AdminPanel_OnlyVisibleToAdmins()
    {
        // Test as regular user
        await LoginAsUserAsync("regular@example.com");
        
        var page = await _fixture.NewPageAsync();
        await page.GotoAsync("/admin");
        
        // Verify access denied or redirect
        var forbiddenMessage = page.Locator(".access-denied");
        await Expect(forbiddenMessage).ToBeVisibleAsync();
    }

    [Fact]
    public async Task AdminPanel_VisibleToAdmins()
    {
        // Test as admin
        await LoginAsAdminAsync("admin@example.com");
        
        var page = await _fixture.NewPageAsync();
        await page.GotoAsync("/admin");

        // Verify admin panel rendered (@if (User.IsInRole("Admin")))
        var adminNav = page.Locator(".admin-navigation");
        await Expect(adminNav).ToBeVisibleAsync();

        // Verify user management (@foreach var user in Model)
        var usersTable = page.Locator(".users-table");
        await Expect(usersTable).ToBeVisibleAsync();
    }

    private async Task LoginAsUserAsync(string email)
    {
        // Implementation to login as regular user
    }

    private async Task LoginAsAdminAsync(string email)
    {
        // Implementation to login as admin
    }
}
```

### Complete PlaywrightFixture with Reuse

```csharp
public class PlaywrightFixture : IAsyncLifetime
{
    private IBrowser? _browser;
    public IBrowser Browser => _browser!;
    public IBrowserContext? Context { get; private set; }
    public string? BaseUrl { get; private set; }
    private WebApplicationFactory<Program>? _factory;

    public async Task InitializeAsync()
    {
        // Start application
        _factory = new WebApplicationFactory<Program>();
        await _factory.CreateHostAsync();
        BaseUrl = _factory.BaseUrl;

        // Launch browser (reuse for efficiency)
        var playwright = await Playwright.CreateAsync();
        _browser = await playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
        {
            Headless = true
        });

        // Create context (can be reused or new per test)
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
        await Context?.DisposeAsync()!;
        await _browser?.CloseAsync()!;
        _factory?.Dispose();
    }
}
```

### Key Points

- Use `IClassFixture<PlaywrightFixture>` for shared browser lifecycle
- Reuse browser context to optimize resources
- Combine DOM validation with data model verification
- Test both positive and negative scenarios
- Use `IAsyncLifetime` for proper fixture setup/teardown
- Include visual evidence capture in complex tests
- Test authorization with different user roles
