## Attribute and Dynamic CSS Validation

Check that conditional Razor CSS classes and attributes are correctly applied in the DOM.

### Conditional CSS Classes

```csharp
[Fact]
public async Task ActiveMenuItem_HasActiveClass()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products");

    // Verify @class="@(isActive ? "active" : "")"
    var activeItem = page.Locator(".nav-item.active");
    await Expect(activeItem).ToHaveClassAsync(new Regex("active"));
    await Expect(activeItem).ToHaveTextAsync("Products");
}

[Fact]
public Task InactiveMenuItem_DoesNotHaveActiveClass()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products");

    var inactiveItem = page.Locator(".nav-item:not(.active)").First;
    return Expect(inactiveItem).Not.ToHaveClassAsync(new Regex("active"));
}
```

### Dynamic Attribute Values

```csharp
[Fact]
public async Task ProductImage_HasCorrectSrc()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products/1");

    // Verify src attribute from @Model.ImageUrl
    var image = page.Locator(".product-image img");
    await Expect(image).ToHaveAttributeAsync("src", new Regex("/images/products/"));
}

[Fact]
public async Task Input_HasValueFromModel()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products/edit/1");

    // Verify value attribute from @Model.ProductName
    var input = page.Locator("input[name=\"ProductName\"]");
    await Expect(input).ToHaveValueAsync("Laptop Pro");
}
```

### Data Attributes

```csharp
[Fact]
public async Task Element_HasDataAttributes()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products/1");

    // Verify data-* attributes from Razor
    var productCard = page.Locator(".product-card");
    await Expect(productCard).ToHaveAttributeAsync("data-product-id", "1");
    await Expect(productCard).ToHaveAttributeAsync("data-price", "999.99");
}

[Fact]
public async Task Buttons_HaveDataActions()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/admin/products");

    var editButton = page.Locator(".edit-button").First;
    await Expect(editButton).ToHaveAttributeAsync("data-action", "edit");
    await Expect(editButton).ToHaveAttributeAsync("data-id", "1");
}
```

### Disabled/Readonly States

```csharp
[Fact]
public async Task DisabledInput_HasDisabledAttribute()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products/1");

    // Verify @Html.EditorFor(m => m.Id, new { disabled = "disabled" })
    var idInput = page.Locator("input[name=\"Id\"]");
    await Expect(idInput).ToHaveAttributeAsync("disabled");
}

[Fact]
public async Task ReadOnlyField_HasReadonlyAttribute()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products/edit/1");

    var createdAtInput = page.Locator("input[name=\"CreatedAt\"]");
    await Expect(createdAtInput).ToHaveAttributeAsync("readonly");
}
```

### Conditional Visibility

```csharp
[Fact]
public async Task AdminControls_VisibleForAdmin()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products/1");

    // @if (User.IsInRole("Admin"))
    var deleteButton = page.Locator(".delete-button");
    await Expect(deleteButton).ToBeVisibleAsync();
}

[Fact]
public async Task AdminControls_HiddenForUser()
{
    // Login as regular user first
    await LoginAsUserAsync("regularuser@example.com");

    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products/1");

    // Verify admin-only button is hidden
    var deleteButton = page.Locator(".delete-button");
    await Expect(deleteButton).Not.ToBeVisibleAsync();
}
```

### Form Validation Attributes

```csharp
[Fact]
public async Task RequiredField_HasRequiredAttribute()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/products/create");

    var nameInput = page.Locator("input[name=\"Name\"]");
    await Expect(nameInput).ToHaveAttributeAsync("required");
}

[Fact]
public async Task EmailField_HasEmailType()
{
    var page = await _playwrightFixture.NewPageAsync();
    await page.GotoAsync("/account/register");

    var emailInput = page.Locator("input[name=\"Email\"]");
    await Expect(emailInput).ToHaveAttributeAsync("type", "email");
}
```

### Key Points

- Use `Expect(locator).ToHaveClassAsync()` for CSS class validation
- Use `Expect(locator).ToHaveAttributeAsync()` for HTML attributes
- Use regex patterns for flexible matching
- Test both presence and absence of conditional classes
- Verify data-* attributes for JavaScript interactions
- Check disabled/readonly states from model or policy
- Validate form validation attributes (required, type, etc.)
