---
name: sqlserver-dbtesting
description: >
  Database logic testing for SQL Server with Testcontainers, Respawn, and native T-SQL execution.
  Trigger: When testing SQL Server stored procedures and functions - testcontainers, respawn, AAA pattern.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

- Testing SQL Server Stored Procedures
- Testing SQL Functions (scalar and table-valued)
- Using Testcontainers for real database instances
- Managing test isolation with Respawn
- Executing native T-SQL commands
- Applying schema to test databases

## Critical Patterns

### Infrastructure Orchestration (Testcontainers)

Use `MsSqlBuilder` to spin up SQL Server container with reuse optimization.

See [assets/01-testcontainers-infrastructure.md](assets/01-testcontainers-infrastructure.md) for examples.

### Database State Management (Respawn)

Clean database tables between tests without restarting container.

See [assets/02-respawn-database-cleanup.md](assets/02-respawn-database-cleanup.md) for examples.

### Dynamic Connection Injection

Dynamically retrieve and inject connection string from container.

See [assets/03-dynamic-connection-injection.md](assets/03-dynamic-connection-injection.md) for examples.

### Native T-SQL Execution

Execute Stored Procedures and Functions using native SQL commands.

See [assets/04-tsql-native-execution.md](assets/04-tsql-native-execution.md) for examples.

### Stored Procedures Testing

Test SPs with AAA pattern and verify side effects.

See [assets/05-stored-procedures-testing.md](assets/05-stored-procedures-testing.md) for examples.

### SQL Functions Testing

Test scalar and table-valued functions.

See [assets/06-sql-functions-testing.md](assets/06-sql-functions-testing.md) for examples.

### Schema Synchronization

Apply database schema (tables, SPs, functions) to container.

See [assets/07-schema-synchronization.md](assets/07-schema-synchronization.md) for examples.

### Database Test Examples

Complete test examples with all patterns combined.

See [assets/08-dbtest-examples.md](assets/08-dbtest-examples.md) for complete examples.

## Commands

```bash
# Run all tests
dotnet test

# Run with verbose output
dotnet test --verbosity normal

# Run single test
dotnet test --filter "FullyQualifiedName~Namespace.ClassName.MethodName"

# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage"

# Run tests in release mode
dotnet test -c Release
```

## Resources

- **Testcontainers**: See [assets/01-testcontainers-infrastructure.md](assets/01-testcontainers-infrastructure.md)
- **Respawn**: See [assets/02-respawn-database-cleanup.md](assets/02-respawn-database-cleanup.md)
- **Connection Injection**: See [assets/03-dynamic-connection-injection.md](assets/03-dynamic-connection-injection.md)
- **T-SQL Execution**: See [assets/04-tsql-native-execution.md](assets/04-tsql-native-execution.md)
- **Stored Procedures**: See [assets/05-stored-procedures-testing.md](assets/05-stored-procedures-testing.md)
- **SQL Functions**: See [assets/06-sql-functions-testing.md](assets/06-sql-functions-testing.md)
- **Schema Sync**: See [assets/07-schema-synchronization.md](assets/07-schema-synchronization.md)
- **Test Examples**: See [assets/08-dbtest-examples.md](assets/08-dbtest-examples.md)
