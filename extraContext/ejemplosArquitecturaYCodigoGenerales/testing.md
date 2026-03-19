## Testing

Write unit tests using xUnit with Moq.

```csharp
namespace GymWebApp.Tests;

public class UserManagerTests
{
    [Fact]
    public void Login_WithValidCredentials_ReturnsUser()
    {
        var mockHttpClient = new Mock<IHttpCustomClient>();
        // arrange, act, assert
    }
}
```
