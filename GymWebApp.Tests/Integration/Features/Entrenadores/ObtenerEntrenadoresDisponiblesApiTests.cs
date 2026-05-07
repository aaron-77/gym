using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;

namespace GymWebApp.Tests.Integration.Features.Entrenadores;

[Collection("IntegrationTests")]
public class ObtenerEntrenadoresDisponiblesApiTests : IntegrationTestBase
{
    public ObtenerEntrenadoresDisponiblesApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper) { }

    public override async Task InitializeAsync()
    {
        await base.InitializeAsync();
        await SetAuthHeaderAsync();
    }

    #region Happy Path (Integration)

    [Fact]
    public async Task ObtenerEntrenadoresDisponibles_WithAuthAndValidDate_ReturnsNonEmptyList()
    {
        var fechaHoy = DateTime.Now.ToString("yyyy-MM-dd");
        var response = await Client.GetAsync($"/api/obtenerEntrenadoresDisponibles?fechaInicio={fechaHoy}");

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