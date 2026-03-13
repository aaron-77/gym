---
name: xunit-dotnet
description: >
  Unit testing patterns for .NET 8 with xUnit, NSubstitute, and FluentAssertions.
  Trigger: When writing unit tests for .NET projects - test structure, mocking, assertions.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

- Writing unit tests for .NET 8+ projects
- Creating tests using xUnit framework
- Needing to mock dependencies with NSubstitute
- Writing assertions with FluentAssertions
- Generating test data with Bogus or Object Mother pattern

## Critical Patterns

### AAA Structure (Mandatory)

Separate phases with comments. Never mix assertions with Arrange/Act.

See [assets/01-aaa-structure.md](assets/01-aaa-structure.md) for example.

### SUT Naming

Always name the System Under Test as `_sut`.

See [assets/02-sut-naming.md](assets/02-sut-naming.md) for example.

### [Fact] vs [Theory]

**[Fact]**: Single logical flow, invariant behavior

**[Theory]**: Multiple inputs, edge cases, null/empty values

See [assets/03-fact-theory.md](assets/03-fact-theory.md) for examples.

### NSubstitute Isolation

Use for all interface dependencies.

See [assets/04-nsubstitute.md](assets/04-nsubstitute.md) for examples.

### FluentAssertions

Replace native Assert with fluent syntax.

See [assets/05-fluent-assertions.md](assets/05-fluent-assertions.md) for examples.

### Data Generation

**Factory Methods (Object Mother)** and **Bogus** for generating test data.

See [assets/06-data-generation.md](assets/06-data-generation.md) for examples.

## Naming Convention

Follow: `MethodName_Scenario_ExpectedResult`

See [assets/07-naming-convention.md](assets/07-naming-convention.md) for examples.

## Test Class Organization

See [assets/08-test-organization.md](assets/08-test-organization.md) for complete example.

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
