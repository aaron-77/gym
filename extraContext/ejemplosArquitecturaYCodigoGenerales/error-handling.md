## Error Handling

Handle exceptions with proper logging including method name, line number, exception type, and message.

```csharp
try { /* business logic */ }
catch (ArgumentNullException ex)
{
    string logMessage = $"[ERROR] Método: MethodName - ArgumentNullException | " +
        $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
        $"Causa: {ex.GetType().Name} - {ex.Message}";
    Console.WriteLine(logMessage);  // Serilog in API layer
    return null;
}
catch (Exception ex)
{
    string logMessage = $"[ERROR] Método: MethodName | " +
        $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
        $"Causa: {ex.GetType().Name} - {ex.Message}";
    Console.WriteLine(logMessage);
    return null;
}
```
