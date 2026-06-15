## Data Generation

### Factory Methods (Object Mother)

```csharp
public static class TestDataFactory
{
    public static User CreateUser(string name = "Test User", string email = "test@test.com")
    {
        return new User
        {
            Id = Guid.NewGuid(),
            Name = name,
            Email = email,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };
    }

    public static List<User> CreateUsers(int count)
    {
        return Enumerable.Range(1, count)
            .Select(i => CreateUser($"User{i}", $"user{i}@test.com"))
            .ToList();
    }
}
```

### Bogus

```csharp
[Fact]
public void GetAllUsers_ReturnsPagedResults()
{
    // Arrange
    var faker = new Faker<User>()
        .RuleFor(u => u.Id, f => Guid.NewGuid())
        .RuleFor(u => u.Name, f => f.Name.FullName())
        .RuleFor(u => u.Email, f => f.Internet.Email())
        .RuleFor(u => u.IsActive, f => f.Random.Bool());

    var users = faker.Generate(10);

    _mockRepository.GetAllAsync().Returns(users);

    // Act
    var result = _sut.GetAllUsers();

    // Assert
    result.Should().HaveCount(10);
}
```
