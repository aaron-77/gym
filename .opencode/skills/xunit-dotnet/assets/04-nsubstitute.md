## NSubstitute Isolation

Use for all interface dependencies.

```csharp
[Fact]
public void GetUserById_WhenUserExists_ReturnsUser()
{
    // Arrange
    var userId = Guid.NewGuid();
    var expectedUser = new User { Id = userId, Name = "John" };
    
    _mockUserRepository
        .GetByIdAsync(userId)
        .Returns(expectedUser);

    // Act
    var result = _sut.GetUserById(userId);

    // Assert
    result.Should().BeEquivalentTo(expectedUser);
    await _mockUserRepository.Received(1).GetByIdAsync(userId);
}

[Fact]
public void CreateUser_WhenEmailExists_ThrowsException()
{
    // Arrange
    var newUser = new CreateUserDto { Email = "existing@test.com" };
    _mockUserRepository.GetByEmailAsync(newUser.Email).Returns(new User());

    // Act & Assert
    Func<Task> act = () => _sut.CreateUser(newUser);
    await act.Should().ThrowAsync<DuplicateEmailException>();
}
```
