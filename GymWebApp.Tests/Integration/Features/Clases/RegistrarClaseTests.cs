using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Factories;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("IntegrationTests")]
public class RegistrarClaseTests : IntegrationTestBase
{
    public RegistrarClaseTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper)
    {
    }

    #region Happy Path Tests

    [Fact]
    public async Task RegistrarClase_WithAuthenticatedEmpleado_ReturnsOk()
    {
        // Arrange
        await SetAuthHeaderAsync();

        var claseValida = ClaseFactory.CrearDTOClaseValida();

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/registrarClase", claseValida);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Be("Clase registrada correctamente");
        result.payload.Should().BeGreaterThan(0);

        // Verify database insertion
        var count = await DatabaseHelper.ExecuteScalarAsync<int>(
            TestContainerHelper.ConnectionString,
            "SELECT COUNT(*) FROM Clases WHERE ClaseId = @Id",
            new() { ["@Id"] = result.payload });
        
        count.Should().Be(1);

        // Verify the class was saved correctly
        var savedClase = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT * FROM Clases WHERE ClaseId = @Id",
            new() { ["@Id"] = result.payload });

        savedClase.Should().NotBeNull();
        savedClase!["NombreClase"].ToString().Should().Be(claseValida.NombreClase);
        savedClase["Descripcion"].ToString().Should().Be(claseValida.Descripcion);
        ((int)savedClase["duracionEnMinutos"]).Should().Be(claseValida.DuracionEnMinutos);
        ((int)savedClase["fkIntensidad"]).Should().Be(claseValida.FkIntensidad);
        ((int)savedClase["fkDificultad"]).Should().Be(claseValida.FkDificultad);
        ((int)savedClase["tiempoDeDescansoEnMinutos"]).Should().Be(claseValida.TiempoDeDescansoEnMinutos);
        ((int)savedClase["Cupo"]).Should().Be(claseValida.Cupo);
        ((int)savedClase["fkEstadoClase"]).Should().Be(claseValida.FkEstadoClase);
    }

    #endregion

    #region Sad Path Tests

    [Fact]
    public async Task RegistrarClase_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange
        ClearAuthHeader();

        var claseValida = ClaseFactory.CrearDTOClaseValida();

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/registrarClase", claseValida);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task RegistrarClase_WithDuplicateName_ReturnsBadRequest()
    {
        // Arrange
        await SetAuthHeaderAsync();

        var nombreDuplicado = $"Clase Duplicada {Guid.NewGuid():N}";

        // First, insert a class with this name directly in the database
        var claseExistente = ClaseFactory.CrearClaseActiva(f => f.RuleFor(c => c.NombreClase, nombreDuplicado));

        await DatabaseHelper.NonQueryAsyncTyped(
            TestContainerHelper.ConnectionString,
            "Clases",
            claseExistente);

        // Now try to register a new class with the same name
        var nuevaClase = ClaseFactory.CrearDTOClaseValida(f => f.RuleFor(c => c.NombreClase, nombreDuplicado));

        // Act
        var response = await Client.PostAsJsonAsync("/api/Clases/registrarClase", nuevaClase);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<int>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
        result.message.Should().Contain("Ya existe una clase con ese nombre");
        result.errors.Should().NotBeEmpty();
        result.errors!.Any(e => e.propiedad == "nombreClase").Should().BeTrue();
    }

    #endregion
}
