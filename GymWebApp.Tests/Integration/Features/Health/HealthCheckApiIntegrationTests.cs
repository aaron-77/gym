using System.Net;
using System.Text.Json;
using GymWebApp.Tests.Integration.Common;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Health;

[Collection("HealthApiIntegrationTests")]
public class HealthCheckApiIntegrationTests : IntegrationTestBase
{
    public HealthCheckApiIntegrationTests(
        CitasApiWebApplicationFactory<Program> factory,
        TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper)
    {
    }

    [Fact]
    public async Task HealthCheck_GetHealth_Returns200OkWithHealthyStatus()
    {
        // Given: API is running via WebApplicationFactory
        // When: GET request is made to /api/health
        // Then: Returns 200 OK with {"status":"Healthy"}
        var response = await Client.GetAsync("/api/health");
        Console.WriteLine("URL BASE: " + Client.BaseAddress);
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var body = await response.Content.ReadAsStringAsync();
        var json = JsonSerializer.Deserialize<JsonElement>(body);
        
        json.GetProperty("status").GetString().Should().Be("Healthy");
    }
}