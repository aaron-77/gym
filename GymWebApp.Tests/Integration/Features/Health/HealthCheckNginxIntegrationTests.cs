using System.Net;
using System.Text.Json;
using GymWebApp.Tests.E2E.Common;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Health;


[Collection("E2E HappyPaths")]
public class HealthCheckNginxIntegrationTests
{
    private readonly E2eContainerHelper _e2eContainerHelper;

    public HealthCheckNginxIntegrationTests(E2eContainerHelper e2eContainerHelper)
    {
        _e2eContainerHelper = e2eContainerHelper;
    }

    [Fact]
    public async Task HealthCheck_GetViaNginxToApi_Returns200OkWithHealthyStatus()
    {
        // Given: Nginx forwards /api/* to API
        // When: GET request is made via Nginx to /api/health
        // Then: Returns 200 OK with {"status":"Healthy"}
        
        using var httpClient = new HttpClient();
        var response = await httpClient.GetAsync($"{E2eContainerHelper.Instance.NginxBaseUrl}/api/health");
        
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var body = await response.Content.ReadAsStringAsync();
        var json = JsonSerializer.Deserialize<JsonElement>(body);
        
        json.GetProperty("status").GetString().Should().Be("Healthy");
    }

    [Fact]
    public async Task HealthCheck_GetViaNginxToFrontend_Returns200OkWithHealthyStatus()
    {
        // Given: Nginx forwards /health to Frontend
        // When: GET request is made via Nginx to /health
        // Then: Returns 200 OK with {"status":"Healthy"}
        
        using var httpClient = new HttpClient();
        var response = await httpClient.GetAsync($"{E2eContainerHelper.Instance.NginxBaseUrl}/health");
        
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var body = await response.Content.ReadAsStringAsync();
        var json = JsonSerializer.Deserialize<JsonElement>(body);
        
        json.GetProperty("status").GetString().Should().Be("Healthy");
    }
}