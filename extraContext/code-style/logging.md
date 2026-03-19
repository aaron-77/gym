## Logging

- **BL Layer:** `Console.WriteLine()`
- **API Layer:** Serilog with `_logger.LogError(ex, message)`
- Include method name, line number, exception type, message
