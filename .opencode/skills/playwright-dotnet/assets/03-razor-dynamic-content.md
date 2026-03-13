## Razor Dynamic Content Testing

Validate that Models passed to Razor views are correctly rendered in the final HTML.

### Model Binding Verification

```csharp
[Fact]
public async Task ProductDetail_DisplaysCorrectModelData()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products/1");

    // Verify @Model.Name is rendered
    var productName = page.Locator(".product-name");
    await Expect(productName).ToHaveTextAsync("Laptop Pro");

    // Verify @Model.Price is rendered
    var productPrice = page.Locator(".product-price");
    await Expect(productPrice).ToHaveTextAsync("$999.99");

    // Verify @Model.Description is rendered
    var productDescription = page.Locator(".product-description");
    await Expect(productDescription).ToHaveTextAsync(new Regex("High-performance laptop"));
}
```

### ViewBag/ViewData Validation

```csharp
[Fact]
public async Task Page_DisplaysViewBagData()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/home/about");

    // Verify @ViewBag.Title rendered in header
    var pageTitle = page.Locator("head title");
    await Expect(pageTitle).ToHaveTextAsync("About - Fitness Gym");

    // Verify @ViewData["MetaDescription"]
    var metaDesc = page.Locator("meta[name=\"description\"]");
    await Expect(metaDesc).ToHaveAttributeAsync("content", new Regex("Fitness"));
}
```

### List/Collection Model Validation

```csharp
[Fact]
public async Task UserList_DisplaysAllUsersFromModel()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/admin/users");

    // Verify @Model.Count matches rendered items
    var userRows = page.Locator("table.users tbody tr");
    await Expect(userRows).ToHaveCountAsync(5);

    // Verify each user's data
    var firstUser = userRows.First;
    await Expect(firstUser).ToContainTextAsync("john@example.com");
}

[Fact]
public async Task EmptyList_ShowsEmptyMessage()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products?category=nonexistent");

    // Verify @if (Model.Any()) else block rendered
    var emptyMessage = page.Locator(".empty-message");
    await Expect(emptyMessage).ToBeVisibleAsync();
    await Expect(emptyMessage).ToHaveTextAsync("No products found");

    // Verify product list is NOT rendered
    var productList = page.Locator(".product-grid");
    await Expect(productList).Not.ToBeVisibleAsync();
}
```

### Nested Model Properties

```csharp
[Fact]
public async Task OrderDetail_DisplaysNestedModelProperties()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/orders/123");

    // Verify @Model.Customer.Name
    var customerName = page.Locator(".customer-name");
    await Expect(customerName).ToHaveTextAsync("John Doe");

    // Verify @Model.Customer.Email
    var customerEmail = page.Locator(".customer-email");
    await Expect(customerEmail).ToHaveTextAsync("john@example.com");

    // Verify @foreach var item in Model.Items
    var orderItems = page.Locator(".order-item");
    await Expect(orderItems).ToHaveCountAsync(3);
}
```

### Validation Summary/Message

```csharp
[Fact]
public async Task ValidationErrors_DisplayedCorrectly()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products/create");

    // Submit empty form to trigger validation
    await page.ClickAsync(".submit-button");

    // Verify @Html.ValidationSummary() rendered
    var validationSummary = page.Locator(".validation-summary-errors");
    await Expect(validationSummary).ToBeVisibleAsync();

    // Verify individual field errors @Html.ValidationMessageFor()
    var nameError = page.Locator(".field-validation-error[data-valmsg-for=\"Name\"]");
    await Expect(nameError).ToContainTextAsync("The Name field is required");
}
```

### Key Points

- Validate actual rendered text, not just element existence
- Use regex for flexible text matching
- Check both positive (item exists) and negative (item doesn't exist) cases
- Verify nested properties in complex models
- Validate conditional rendering with @if/@else blocks
- Test empty collections and null models
