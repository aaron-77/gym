using System.Net;
using System.Text.Json;
using GymWebApp.Tests.E2E.Common;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Health;

[Collection("HealthNginxIntegrationTests")]
public class HealthCheckNginxIntegrationTests : IAsyncLifetime
{
    [Fact]
    public async Task HealthCheck_GetViaNginxToApi_Returns200OkWithHealthyStatus()
    {
        // Given: Nginx (port 5080) forwards /api/* to API
        // When: GET request is made to http://localhost:5080/api/health
        // Then: Returns 200 OK with {"status":"Healthy"}
        
        using var httpClient = new HttpClient();
        var response = await httpClient.GetAsync($"{E2eContainerHelper.FrontendBaseUrl}/api/health");
        
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var body = await response.Content.ReadAsStringAsync();
        var json = JsonSerializer.Deserialize<JsonElement>(body);
        
        json.GetProperty("status").GetString().Should().Be("Healthy");
    }

    [Fact]
    public async Task HealthCheck_GetViaNginxToFrontend_Returns200OkWithHealthyStatus()
    {
        // Given: Nginx (port 5080) forwards /health to Frontend
        // When: GET request is made to http://localhost:5080/health
        // Then: Returns 200 OK with {"status":"Healthy"}
        
        using var httpClient = new HttpClient();
        var response = await httpClient.GetAsync($"{E2eContainerHelper.FrontendBaseUrl}/health");
        
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var body = await response.Content.ReadAsStringAsync();
        var json = JsonSerializer.Deserialize<JsonElement>(body);
        
        json.GetProperty("status").GetString().Should().Be("Healthy");
    }

    public async Task InitializeAsync()
    {
        await E2eContainerHelper.InitializeAsync();
    }

    public async Task DisposeAsync()
    {
        await E2eContainerHelper.DisposeAsync();
    }
}