## Test Class Organization

```csharp
namespace GymWebApp.Tests.Services;

public class UserServiceTests
{
    private readonly IUserRepository _mockRepository;
    private readonly IEmailService _mockEmailService;
    private readonly UserService _sut;

    public UserServiceTests()
    {
        _mockRepository = Substitute.For<IUserRepository>();
        _mockEmailService = Substitute.For<IEmailService>();
        _sut = new UserService(_mockRepository, _mockEmailService);
    }

    [Fact]
    public void CreateUser_WithValidData_ReturnsCreatedUser()
    {
        // Arrange
        var userDto = TestDataFactory.CreateUserDto();
        
        _mockRepository.AddAsync(Arg.Any<User>()).Returns(User);
        
        // Act
        var result = _sut.CreateUser(userDto);
        
        // Assert
        result.Should().NotBeNull();
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    public void CreateUser_WithInvalidEmail_ThrowsException(string email)
    {
        // Arrange & Act & Assert
        Func<Task> act = () => _sut.CreateUser(new CreateUserDto { Email = email });
        await act.Should().ThrowAsync<ValidationException>();
    }
}
```
