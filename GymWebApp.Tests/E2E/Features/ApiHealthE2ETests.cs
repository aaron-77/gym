using System.Net.Http;
using System.Text.Json;
using FluentAssertions;
using GymWebApp.Tests.E2E.Common;
using Xunit;

namespace GymWebApp.Tests.E2E.Features;

/// <summary>
/// End-to-end tests for API health and information endpoints.
/// These tests verify that the API responds correctly when accessed through the containerized environment.
/// </summary>
[Collection("E2E Tests")]
public class ApiHealthE2ETests : PlaywrightTestBase, IAsyncLifetime
{
    /// <summary>
    /// Verifies that the health endpoint returns a 200 OK status code.
    /// Scenario: API health check - /api/health endpoint responds successfully
    /// </summary>
    [Fact]
    public async Task ApiHealth_GetHealthEndpoint_Returns200Ok()
    {
        using var httpClient = new HttpClient();
        var baseUrl = E2eContainerHelper.ApiBaseUrl;

        var response = await httpClient.GetAsync($"{baseUrl}/api/health");

        Assert.Equal(200, (int)response.StatusCode);
    }

    /// <summary>
    /// Verifies that the health endpoint returns valid JSON with "Healthy" status.
    /// Scenario: API health check - /api/health endpoint returns correct JSON body
    /// </summary>
    [Fact]
    public async Task ApiHealth_GetHealthEndpoint_ReturnsHealthyJson()
    {
        using var httpClient = new HttpClient();
        var baseUrl = E2eContainerHelper.ApiBaseUrl;

        var response = await httpClient.GetAsync($"{baseUrl}/api/health");
        var body = await response.Content.ReadAsStringAsync();
        var json = JsonSerializer.Deserialize<JsonElement>(body);

        Assert.Equal(200, (int)response.StatusCode);
        json.GetProperty("status").GetString().Should().Be("Healthy");
    }

    /// <summary>
    /// Verifies that the API info endpoint returns a 200 OK status code.
    /// Scenario: API info check - api endpoint responds successfully
    /// </summary>
    [Fact]
    public async Task ApiHealth_GetApiInfo_Returns200Ok()
    {
        using var httpClient = new HttpClient();
        var baseUrl = E2eContainerHelper.ApiBaseUrl;

        var response = await httpClient.GetAsync($"{baseUrl}/api");

        Assert.Equal(200, (int)response.StatusCode);
    }
}
