## [Fact] vs [Theory]

### [Fact] - Single logical flow, invariant behavior

```csharp
[Fact]
public void Login_WithValidCredentials_ReturnsUser()
{
    // Arrange
    var credentials = new Credentials("user@test.com", "password123");
    _mockRepository.GetByEmailAsync(credentials.Email).Returns(new User { Email = credentials.Email });

    // Act
    var result = _sut.Login(credentials);

    // Assert
    result.Should().NotBeNull();
}
```

### [Theory] - Multiple inputs, edge cases, null/empty values

```csharp
[Theory]
[InlineData(null)]
[InlineData("")]
[InlineData("   ")]
[InlineData("invalid-email")]
public void ValidateEmail_WithInvalidInput_ReturnsFalse(string email)
{
    // Arrange & Act
    var result = _sut.ValidateEmail(email);

    // Assert
    result.Should().BeFalse();
}

[Theory]
[InlineData(0)]
[InlineData(-1)]
[InlineData(-100)]
public void CalculateDiscount_ForNegativeAmount_ReturnsZero(decimal amount)
{
    // Arrange
    var sut = new DiscountCalculator();

    // Act
    var result = sut.CalculateDiscount(amount);

    // Assert
    result.Should().Be(0);
}
```
