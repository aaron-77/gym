## DOM Structure and Selector Validation

Use Playwright's `Locator` and asynchronous assertions to validate Razor-rendered elements.

### Basic Locator Usage

```csharp
[Fact]
public async Task HomePage_HasNavigationMenu()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/");

    // Verify element exists
    var navMenu = page.Locator("nav.main-menu");
    await Expect(navMenu).ToBeVisibleAsync();
}
```

### Validating @if Conditional Rendering

```csharp
[Fact]
public async Task UserDashboard_WhenLoggedIn_ShowsUserMenu()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/dashboard");

    // Element rendered by @if (User.Identity?.IsAuthenticated == true)
    var userMenu = page.Locator(".user-menu");
    await Expect(userMenu).ToBeVisibleAsync();

    // Verify login button is NOT rendered
    var loginButton = page.Locator(".login-button");
    await Expect(loginButton).Not.ToBeVisibleAsync();
}

[Fact]
public async Task UserDashboard_WhenNotLoggedIn_ShowsLoginButton()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/dashboard");

    // Element rendered by @if (!User.Identity?.IsAuthenticated)
    var loginButton = page.Locator(".login-button");
    await Expect(loginButton).ToBeVisibleAsync();
}
```

### Validating @foreach Loops

```csharp
[Fact]
public async Task ProductList_RendersAllItems()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products");

    // Verify count of items rendered by @foreach
    var productItems = page.Locator(".product-item");
    await Expect(productItems).ToHaveCountAsync(3);
}
```

### Using nth-child Selector

```csharp
[Fact]
public async Task ProductList_FirstItemHasCorrectData()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products");

    // Get first item rendered by @foreach var product in Model
    var firstProduct = page.Locator(".product-item").First;
    await Expect(firstProduct).ToHaveTextAsync("Laptop Pro");
}

[Fact]
public async Task ProductList_SecondItemHasCorrectData()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products");

    var secondProduct = page.Locator(".product-item").Nth(1);
    await Expect(secondProduct).ToHaveTextAsync("Wireless Mouse");
}
```

### Text and Content Validation

```csharp
[Fact]
public async Task Page_HasExpectedHeading()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/about");

    // Validate text content from Razor @Model.Title
    var heading = page.Locator("h1");
    await Expect(heading).ToHaveTextAsync("About Us");
}

[Fact]
public async Task ProductList_HasProductNames()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products");

    var productNames = page.Locator(".product-name");
    await Expect(productNames).ToContainTextAsync(new[] { "Laptop Pro", "Wireless Mouse", "USB Hub" });
}
```

### Key Points

- Use `Expect(locator).ToBeVisibleAsync()` for visibility assertions
- Use `Expect(locator).ToHaveTextAsync()` for text content
- Use `Expect(locator).ToHaveCountAsync()` for collections
- Use `.First` or `.Nth(index)` for specific items in loops
- Use `.Not.ToBeVisibleAsync()` for elements that should not exist
- Validate both presence and absence of conditional elements
