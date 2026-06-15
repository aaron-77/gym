## AAA Structure (Arrange-Act-Assert)

Separate phases with comments. Never mix assertions with Arrange/Act.

```csharp
[Fact]
public void CalculateTotal_WithValidItems_ReturnsCorrectSum()
{
    // Arrange
    var sut = new OrderCalculator();
    var items = new List<OrderItem>
    {
        new() { Price = 100, Quantity = 2 },
        new() { Price = 50, Quantity = 1 }
    };

    // Act
    decimal result = sut.CalculateTotal(items);

    // Assert
    result.Should().Be(250);
}
```
