using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Factories;
using FluentAssertions;
using DataAccess.EntityFramework;

namespace GymWebApp.Tests.Integration.Features.Common;

[Collection("DatabaseHelperNonQueryAsyncTypedTests")]
public class DatabaseHelperNonQueryAsyncTypedTests
{
    public DatabaseHelperNonQueryAsyncTypedTests()
    {
        ConfigHelper.RegisterConfig("appsettings.Testing.json");
        InitializeAsync().GetAwaiter().GetResult();
    }

    private async Task InitializeAsync()
    {
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
    }

    [Fact]
    public async Task NonQueryAsyncTyped_InsertSimpleEntity_ReturnsEntityWithGeneratedId()
    {
        // Arrange
        var connectionString = TestContainerHelper.ConnectionString;
        var clase = ClaseFactory.CrearClaseActiva();

        // Act
        var savedClase = await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase);

        // Assert
        savedClase.Should().NotBeNull();
        savedClase.ClaseId.Should().BeGreaterThan(0, "the database should auto-generate an ID");
    }

    [Fact]
    public async Task NonQueryAsyncTyped_InsertEntity_VerifiesDataIntegrity()
    {
        // Arrange
        var connectionString = TestContainerHelper.ConnectionString;
        var expectedNombreClase = "Clase Integridad Test";
        var expectedCupo = 25;
        var expectedDuracion = 60;
        var expectedFkEstado = 1;

        var clase = ClaseFactory.CrearClaseActiva(f => f
            .RuleFor(c => c.NombreClase, expectedNombreClase)
            .RuleFor(c => c.Cupo, expectedCupo)
            .RuleFor(c => c.DuracionEnMinutos, expectedDuracion)
            .RuleFor(c => c.FkEstadoClase, expectedFkEstado)
        );

        // Act
        var savedClase = await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase);

        // Assert - Verify data was saved correctly
        var dbRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT NombreClase, Cupo, DuracionEnMinutos, FkEstadoClase FROM Clases WHERE ClaseId = @Id",
            new() { ["@Id"] = savedClase.ClaseId });

        dbRow.Should().NotBeNull("the entity should be persisted to the database");

        var nombreClase = dbRow!["NombreClase"]?.ToString();
        nombreClase.Should().Be(expectedNombreClase, "NombreClase should match the inserted value");

        var cupo = Convert.ToInt32(dbRow["Cupo"]);
        cupo.Should().Be(expectedCupo, "Cupo should match the inserted value");

        var duracion = Convert.ToInt32(dbRow["DuracionEnMinutos"]);
        duracion.Should().Be(expectedDuracion, "DuracionEnMinutos should match the inserted value");

        var fkEstado = Convert.ToInt32(dbRow["FkEstadoClase"]);
        fkEstado.Should().Be(expectedFkEstado, "FkEstadoClase should match the inserted value");
    }

    [Fact]
    public async Task NonQueryAsyncTyped_InvalidTableName_ThrowsInvalidOperationException()
    {
        // Arrange
        var connectionString = TestContainerHelper.ConnectionString;
        var clase = ClaseFactory.CrearClaseActiva();
        var invalidTableName = "NonExistentTable_12345";

        // Act & Assert
        await Assert.ThrowsAsync<InvalidOperationException>(
            async () => await DatabaseHelper.NonQueryAsyncTyped(connectionString, invalidTableName, clase)
        );
    }

    [Fact]
    public async Task NonQueryAsyncTyped_MultipleInserts_GeneratesUniqueIds()
    {
        // Arrange
        var connectionString = TestContainerHelper.ConnectionString;
        var clase1 = ClaseFactory.CrearClaseActiva(f => f.RuleFor(c => c.NombreClase, "Primera Clase"));
        var clase2 = ClaseFactory.CrearClaseActiva(f => f.RuleFor(c => c.NombreClase, "Segunda Clase"));
        var clase3 = ClaseFactory.CrearClaseActiva(f => f.RuleFor(c => c.NombreClase, "Tercera Clase"));

        // Act
        var saved1 = await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase1);
        var saved2 = await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase2);
        var saved3 = await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase3);

        // Assert
        saved1.ClaseId.Should().BeGreaterThan(0);
        saved2.ClaseId.Should().BeGreaterThan(0);
        saved3.ClaseId.Should().BeGreaterThan(0);

        saved1.ClaseId.Should().NotBe(saved2.ClaseId, "each insert should generate a unique ID");
        saved2.ClaseId.Should().NotBe(saved3.ClaseId, "each insert should generate a unique ID");
        saved1.ClaseId.Should().NotBe(saved3.ClaseId, "each insert should generate a unique ID");
    }
}
