## HTML Endpoint Verification

Validate endpoints that return HTML fragments (PartialView, View Components).

### Basic Partial View Testing

```csharp
[Fact]
public async Task PartialView_ReturnsHtmlFragment()
{
    var page = await _playwrightFixture.NewPageAsync();
    
    // Request the partial view directly
    var response = await page.Request.GetAsync("/products/_ProductCard/1");

    // Verify Content-Type is text/html
    Assert.Equal("text/html; charset=utf-8", response.Headers["Content-Type"]);

    // Verify HTML content
    var body = await response.TextAsync();
    Assert.Contains("product-card", body);
    Assert.Contains("Laptop Pro", body);
}
```

### View Component Testing

```csharp
[Fact]
public async Task ViewComponent_ReturnsHtml()
{
    var page = await _playwrightFixture.NewPageAsync();
    
    // Invoke View Component directly
    var response = await page.Request.GetAsync("/Components/NavigationMenu/Default");

    // Verify HTML response
    Assert.Contains("text/html", response.Headers["Content-Type"]);
    
    var html = await response.TextAsync();
    Assert.Contains("nav-menu", html);
}

[Fact]
public async Task ViewComponent_WithParameters()
{
    var page = await _playwrightFixture.NewPageAsync();
    
    // View Component with route values
    var response = await page.Request.GetAsync("/Components/ProductList/Default?category=electronics");

    var html = await response.TextAsync();
    Assert.Contains("product-item", html);
}
```

### AJAX/HTMX Partial Updates

```csharp
[Fact]
public async Task AjaxLoadMore_ReturnsPartialHtml()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products");

    // Click load more button (triggers AJAX)
    await page.ClickAsync(".load-more-button");

    // Wait for response
    await page.WaitForResponseAsync(response => 
        response.Url.Contains("/products/loadmore") && 
        response.Status == 200);

    // Verify new items added to DOM
    var productItems = page.Locator(".product-item");
    var count = await productItems.CountAsync();
    Assert.True(count > 3);
}
```

### Form Submission Returns Partial

```csharp
[Fact]
public async Task FormSubmit_UpdatesPartialView()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/cart");

    // Fill and submit form via HTMX
    await page.FillAsync(".quantity-input", "2");
    await page.ClickAsync(".update-cart-button");

    // Wait for partial update
    await page.WaitForSelectorAsync(".cart-summary");

    // Verify partial view updated
    var cartTotal = page.Locator(".cart-total");
    await Expect(cartTotal).ToHaveTextAsync("$199.99");
}
```

### JSON vs HTML Response

```csharp
[Fact]
public async Task ApiEndpoint_ReturnsJson()
{
    var page = await _playwrightFixture.NewPageAsync();
    
    var response = await page.Request.GetAsync("/api/products/1");

    Assert.Contains("application/json", response.Headers["Content-Type"]);
    
    var json = await response.JsonAsync();
    Assert.Equal("Laptop Pro", json.GetProperty("name").GetString());
}

[Fact]
public async Task HtmlEndpoint_ReturnsHtml()
{
    var page = await _playwrightFixture.NewPageAsync();
    
    var response = await page.Request.GetAsync("/products/1");

    Assert.Contains("text/html", response.Headers["Content-Type"]);
}
```

### Key Points

- Use `page.Request.GetAsync()` to intercept HTTP responses
- Verify `Content-Type` header matches expected format
- Check HTML fragments contain expected markup
- Test View Components at their endpoints
- Use `WaitForResponseAsync` for AJAX/HTMX requests
- Verify both success and error partial responses
