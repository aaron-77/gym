using System.Net;
using System.Net.Http.Json;
using DTO.Dtos;
using FluentAssertions;
using GymWebApp.Tests.Integration.Common;
using Microsoft.AspNetCore.Mvc.Testing;

namespace GymWebApp.Tests.Unit.Citas;

public class CitasControllerTests : IClassFixture<GymWebApp.Tests.Integration.CitasApiWebApplicationFactory<Program>>
{
    private readonly HttpClient _client;
    private readonly GymWebApp.Tests.Integration.CitasApiWebApplicationFactory<Program> _factory;

    public CitasControllerTests(GymWebApp.Tests.Integration.CitasApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task GetCitasAgendadas_WithoutAuth_ReturnsUnauthorized()
    {
        var response = await _client.GetAsync("/api/getCitasAgendadas?idUsuario=123");

        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    public async Task DisposeAsync()
    {
        _client.Dispose();
        _factory.Dispose();
    }
}
