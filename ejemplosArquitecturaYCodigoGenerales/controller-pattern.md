## Controller Pattern

Use attributes for routing and authorization, with proper try-catch and logging.

```csharp
[Authorize(Roles = "empleado")]
[HttpGet]
[Route("api/obtenerUsuarios")]
public async Task<IActionResult> GetUsuarios()
{
    try
    {
        _logger.LogInformation("Start GetUsuarios");
        var usuarios = await _userManager.Users.Select(u => new ExistingUser { }).ToListAsync();
        return Ok(respuesta);
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, logMessage);
        return StatusCode(500, respuesta);
    }
}
```
