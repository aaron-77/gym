## Naming Convention

Follow: `MethodName_Scenario_ExpectedResult`

```csharp
[Fact]
public void CalculateTax_WithValidAmount_ReturnsCorrectTax()
{
}

[Fact]
public void Login_WithInvalidPassword_ReturnsNull()
{
}

[Theory]
[InlineData(0)]
[InlineData(-1)]
public void ProcessOrder_WithNonPositiveQuantity_ThrowsException(int quantity)
{
}
```
