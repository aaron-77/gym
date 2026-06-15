using System.Net;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Factories;
using FluentAssertions;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("IntegrationTests")]
public class PreviewRateLimitTests : IClassFixture<ClasesApiProductionWebApplicationFactory<Program>>, IAsyncLifetime
{
    private readonly ClasesApiProductionWebApplicationFactory<Program> _factory;
    private readonly HttpClient Client;
    private readonly TestContainerHelper _testContainerHelper;

    public PreviewRateLimitTests(ClasesApiProductionWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
    {
        _factory = factory;
        _testContainerHelper = testContainerHelper;
        Client = factory.CreateClient();
    }

    public async Task InitializeAsync()
    {
        await _testContainerHelper.ResetDatabaseAsync();
    }

    public Task DisposeAsync() => Task.CompletedTask;

    /// <summary>
    /// Scenario 3: Rate limit applies in Production environment
    /// 
    /// GIVEN the application is running in Production environment
    /// AND the rate limit is set to 15 requests per minute per IP
    /// WHEN a client exceeds this limit from the same IP
    /// THEN the response status MUST be 429 Too Many Requests
    /// </summary>
    [Fact]
    public async Task RateLimitExceeded_Returns429()
    {
        // Arrange - seed data for the endpoint to return OK
        var connectionString = _testContainerHelper.ConnectionString;
        
        var clase = ClaseFactory.CrearClaseActiva();
        var saved = await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase);
        
        var imagen = ClaseFactory.CrearImagenParaBanner(saved.ClaseId);
        await DatabaseHelper.NonQueryAsyncTyped(connectionString, "ImagesForClases", imagen);

        // Act & Assert - 16 sequential requests
        // First 15 should return 200 OK
        // 16th should return 429 Too Many Requests
        for (int i = 1; i <= 16; i++)
        {
            var response = await Client.GetAsync("/api/Clases/preview");
            
            if (i <= 15)
            {
                response.StatusCode.Should().Be(HttpStatusCode.OK, 
                    $"Request #{i} should succeed (within rate limit)");
            }
            else
            {
                response.StatusCode.Should().Be(HttpStatusCode.TooManyRequests,
                    $"Request #{i} should be rate limited (exceeded 15 requests/minute)");
            }
        }
    }
}

/// <summary>
/// Tests for Scenario 4: Rate limit bypassed in Development environment
/// 
/// Uses ClasesApiWebApplicationFactory (Testing environment) where rate limiter is NOT active.
/// 
/// Spec: specs/04-preview-clases.md - Scenario 4
/// </summary>
[Collection("IntegrationTests")]
public class PreviewRateLimitDevelopmentTests : IntegrationTestBase
{
    public PreviewRateLimitDevelopmentTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    /// <summary>
    /// Scenario 4: Rate limit bypassed in Development environment
    /// 
    /// GIVEN the application is running in Development environment
    /// WHEN a client makes multiple requests to /api/Clases/preview
    /// THEN all requests MUST be processed without rate limiting
    /// AND no 429 responses MUST be returned
    /// </summary>
    [Fact]
    public async Task RateLimitBypassedInDevelopment_ReturnsOk()
    {
        // Arrange - create active class with banner BEFORE requests
        var connectionString = TestContainerHelper.ConnectionString;
        
        var clase = ClaseFactory.CrearClaseActiva();
        var saved = await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase);
        
        var imagen = ClaseFactory.CrearImagenParaBanner(saved.ClaseId);
        await DatabaseHelper.NonQueryAsyncTyped(connectionString, "ImagesForClases", imagen);

        // Act & Assert - 20 requests, all should be 200 OK
        for (int i = 1; i <= 20; i++)
        {
            var response = await Client.GetAsync("/api/Clases/preview");
            response.StatusCode.Should().Be(HttpStatusCode.OK, 
                $"Request #{i} should succeed in Development (no rate limiting)");
        }
    }
}
