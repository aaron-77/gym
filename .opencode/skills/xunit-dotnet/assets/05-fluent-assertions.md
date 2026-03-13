## FluentAssertions

Replace native Assert with fluent syntax.

```csharp
// Simple value
result.Should().Be(42);
result.Should().NotBeNull();
result.Should().BeTrue();

// Collections
users.Should().HaveCount(3);
users.Should().Contain(u => u.IsActive);
users.Should().ContainSingle(u => u.Name == "John");
users.Should().BeEmpty();

// Exceptions
Action act = () => service.Delete(0);
act.Should().Throw<ArgumentException>();
act.Should().Throw<ArgumentException>().WithMessage("*must be positive*");

// Object equivalence
result.Should().BeEquivalentTo(expectedUser, options =>
    options.Excluding(u => u.Id));

// DateTime
date.Should().BeCloseTo(DateTime.UtcNow, TimeSpan.FromSeconds(5));
```
