---
name: playwright-dotnet
description: >
  E2E testing patterns for .NET 8 Razor pages with Playwright.
  Trigger: When writing end-to-end tests for ASP.NET Core apps - browser automation, DOM validation, Razor components.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

- Writing E2E tests for .NET 8+ Razor Pages / MVC applications
- Using Playwright for browser automation
- Testing Razor component rendering and dynamic content
- Validating DOM structure and selectors
- Testing View Components and Partial Views
- Capturing visual evidence and debugging test failures

## Critical Patterns

### UI Testing Host Configuration

Use `WebApplicationFactory<TEntryPoint>` with ephemeral port for Playwright connection.

See [assets/01-webapplication-factory-setup.md](assets/01-webapplication-factory-setup.md) for examples.

### DOM Structure and Selector Validation

Use `Locator` and asynchronous assertions to validate Razor-rendered elements.

See [assets/02-dom-selector-validation.md](assets/02-dom-selector-validation.md) for examples.

### Razor Dynamic Content Testing

Validate that Models passed to views are correctly rendered in HTML.

See [assets/03-razor-dynamic-content.md](assets/03-razor-dynamic-content.md) for examples.

### HTML Endpoint Verification

Test Partial Views and View Components returning HTML fragments.

See [assets/04-html-endpoint-verification.md](assets/04-html-endpoint-verification.md) for examples.

### Attribute and Dynamic CSS Validation

Check conditional Razor CSS classes and HTML attributes.

See [assets/05-attribute-css-validation.md](assets/05-attribute-css-validation.md) for examples.

### Visual Evidence and Debugging

Capture screenshots and traces for debugging rendering issues.

See [assets/06-visual-evidence-debugging.md](assets/06-visual-evidence-debugging.md) for examples.

### E2E Test Examples

Complete test examples with all patterns combined.

See [assets/07-e2e-test-examples.md](assets/07-e2e-test-examples.md) for complete examples.

## Commands

```bash
# Run all tests
dotnet test

# Run with verbose output
dotnet test --verbosity normal

# Run single test
dotnet test --filter "FullyQualifiedName~Namespace.ClassName.MethodName"

# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage"

# Run tests in release mode
dotnet test -c Release
```
