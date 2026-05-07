using System.Net;
using System.Text.Json;
using GymWebApp.Tests.Integration.Common;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Health;

[Collection("HealthFrontendIntegrationTests")]
public class HealthCheckFrontendIntegrationTests : IClassFixture<GymFrontendWebApplicationFactory<GymFrontend.Program>>, IAsyncLifetime
{                                                   
    private readonly GymFrontendWebApplicationFactory<GymFrontend.Program> _factory;
    private readonly HttpClient _client;
    private readonly TestContainerHelper _testContainerHelper;

    public HealthCheckFrontendIntegrationTests(
        GymFrontendWebApplicationFactory<GymFrontend.Program> factory,
        TestContainerHelper testContainerHelper)
    {
        _factory = factory;
        _testContainerHelper = testContainerHelper;
        _client = factory.CreateClient();
    }

    public async Task InitializeAsync()
    {
        // WebApplicationFactory already initializes Frontend in memory
        // No containers needed for health check
    }

    public async Task DisposeAsync()
    {
    }

    [Fact]
    public async Task HealthCheck_GetHealth_Returns200OkWithHealthyStatus()
    {
        // Given: Frontend is running via WebApplicationFactory
        // When: GET request is made to /health
        // Then: Returns 200 OK with {"status":"Healthy"}
        var response = await _client.GetAsync("/health");
        Console.WriteLine("URL BASE: "+_client.BaseAddress);
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var body = await response.Content.ReadAsStringAsync();
        var json = JsonSerializer.Deserialize<JsonElement>(body);
        
        json.GetProperty("status").GetString().Should().Be("Healthy");
    }
}