using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Factories;
using DTO.Dtos;
using FluentAssertions;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("PreviewClasesApiIntegrationTests")]
public class PreviewClasesApiTests : IClassFixture<ClasesApiWebApplicationFactory<Program>>
{
    private readonly ClasesApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public PreviewClasesApiTests(ClasesApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        InitializeAsync().GetAwaiter().GetResult();
    }

    private async Task InitializeAsync()
    {
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
    }

    [Fact]
    public async Task PreviewClases_WithoutAuthentication_ReturnsOkWithActiveClasses()
    {
        var connectionString = TestContainerHelper.ConnectionString;

        for (int i = 0; i < 3; i++)
        {
            var clase = ClaseFactory.CrearClaseActiva(
                f => f.RuleFor(c => c.NombreClase, $"Clase Test {i + 1}"));

            var savedClase = await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase);

            var imagen = ClaseFactory.CrearImagenParaBanner(savedClase.ClaseId,
                f => f.RuleFor(img => img.UrlParaBanner, $"/img/clase{i + 1}.jpg"));

            await DatabaseHelper.NonQueryAsyncTyped(connectionString, "ImagesForClases", imagen);
        }

        var response = await _client.GetAsync("/api/Clases/preview");

        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOClasePreview>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeEmpty();

        foreach (var preview in result.payload!)
        {
            preview.idClase.Should().BeGreaterThan(0);
            preview.urlImage.Should().NotBeNullOrEmpty();
            preview.nombreClase.Should().NotBeNullOrEmpty();
            preview.descripcionCortaClase.Should().NotBeNullOrEmpty();
        }
    }

    [Fact]
    public async Task PreviewClases_ReturnsOnlyActiveClasses()
    {
        var connectionString = TestContainerHelper.ConnectionString;

        var claseActiva = ClaseFactory.CrearClaseActiva(
            f => f.RuleFor(c => c.NombreClase, "Clase Activa"));
        var savedActiva = await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", claseActiva);
        var imagenActiva = ClaseFactory.CrearImagenParaBanner(savedActiva.ClaseId);
        await DatabaseHelper.NonQueryAsyncTyped(connectionString, "ImagesForClases", imagenActiva);

        var claseInactiva = ClaseFactory.CrearClaseInactiva(
            f => f.RuleFor(c => c.NombreClase, "Clase Inactiva"));
        var savedInactiva = await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", claseInactiva);
        var imagenInactiva = ClaseFactory.CrearImagenParaBanner(savedInactiva.ClaseId);
        await DatabaseHelper.NonQueryAsyncTyped(connectionString, "ImagesForClases", imagenInactiva);

        var response = await _client.GetAsync("/api/Clases/preview");

        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOClasePreview>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();

        foreach (var preview in result.payload!)
        {
            var claseInDb = await DatabaseHelper.ExecuteQuerySingleAsync(
                connectionString,
                "SELECT FkEstadoClase FROM Clases WHERE ClaseId = @Id",
                new() { ["@Id"] = preview.idClase });

            claseInDb.Should().NotBeNull();
            var estado = Convert.ToInt32(claseInDb!["FkEstadoClase"]);
            estado.Should().Be(1);
        }
    }
}
