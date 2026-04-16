using System.Net;
using System.Text.Json;
using GymWebApp.Tests.Integration.Common;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Health;

[Collection("HealthApiIntegrationTests")]
public class HealthCheckApiIntegrationTests : IClassFixture<CitasApiWebApplicationFactory<Program>>, IAsyncLifetime
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public HealthCheckApiIntegrationTests(CitasApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
    }

    public async Task InitializeAsync()
    {
        // WebApplicationFactory already initializes API in memory
        // No containers needed for health check
    }

    public async Task DisposeAsync()
    {
    }

    [Fact]
    public async Task HealthCheck_GetHealth_Returns200OkWithHealthyStatus()
    {
        // Given: API is running via WebApplicationFactory
        // When: GET request is made to /health
        // Then: Returns 200 OK with {"status":"Healthy"}
        var response = await _client.GetAsync("/health");
        
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var body = await response.Content.ReadAsStringAsync();
        var json = JsonSerializer.Deserialize<JsonElement>(body);
        
        json.GetProperty("status").GetString().Should().Be("Healthy");
    }
}