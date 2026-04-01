using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;

namespace GymWebApp.Tests.Integration.Features.Entrenadores;

[Collection("EntrenadoresApiIntegrationTests")]
public class ObtenerEntrenadoresDisponiblesApiTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;
    private string? _authToken;

    public ObtenerEntrenadoresDisponiblesApiTests(CitasApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        InitializeAsync().GetAwaiter().GetResult();
    }

    private async Task InitializeAsync()
    {
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        _authToken = await _factory.AuthenticateAsync(_client);
    }

    private void SetAuthHeader()
    {
        if (string.IsNullOrEmpty(_authToken))
            throw new InvalidOperationException("Auth token not available");
        
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _authToken);
    }

    #region Happy Path (Integration)

    [Fact]
    public async Task ObtenerEntrenadoresDisponibles_WithAuthAndValidDate_ReturnsNonEmptyList()
    {
        await TestContainerHelper.ResetDatabaseAsync();
        
        SetAuthHeader();

        var fechaHoy = DateTime.Now.ToString("yyyy-MM-dd");
        var response = await _client.GetAsync($"/api/obtenerEntrenadoresDisponibles?fechaInicio={fechaHoy}");

        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<QueryUser>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Be("Consulta exitosa");
        result.payload.Should().NotBeNull();
        result.payload.Should().NotBeEmpty();
    }

    #endregion
}