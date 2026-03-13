## Response Pattern

Use `ResponseManager.BuildResponse` for consistent API responses.

```csharp
return ResponseManager.BuildResponse<bool>(true, 200, "Operación exitosa", null, payload);
```
