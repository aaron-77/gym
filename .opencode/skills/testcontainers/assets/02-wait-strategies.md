# Wait Strategies

Para configuración de wait strategies, usar la skill dedicada: **testcontainers-wait-strategies**

## Quick Reference

```csharp
using DotNet.Testcontainers.Containers;

// HTTP wait - para API/Frontend
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilHttpRequestIsSucceeded(r => r.ForPath("/")))

// TCP wait - para Nginx/Database
.WithWaitStrategy(Wait.ForUnixContainer()
    .UntilPortIsAvailable(8080))
```

## Ver Também

- **Skill completa**: [testcontainers-wait-strategies](../testcontainers-wait-strategies/SKILL.md)
- **Documentación**: https://dotnet.testcontainers.org/api/wait_strategies/