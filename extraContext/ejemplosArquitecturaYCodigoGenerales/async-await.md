## Async/Await Usage

Use `async/await` for I/O operations and return `Task<T>`.

```csharp
public async Task<DTOResponse<DTOLoggedUser>> Login(UserCredentials credenciales) { }

public async Task<RefreshToken?> GetRefreshTokenByTokenHashAsync(string tokenHash) { }
```
