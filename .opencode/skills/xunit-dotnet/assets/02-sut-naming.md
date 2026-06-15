## SUT (System Under Test) Naming

Always name the System Under Test as `_sut`.

```csharp
public class UserServiceTests
{
    private readonly IUserRepository _mockRepository;
    private readonly UserService _sut;

    public UserServiceTests()
    {
        _mockRepository = Substitute.For<IUserRepository>();
        _sut = new UserService(_mockRepository);
    }
}
```
