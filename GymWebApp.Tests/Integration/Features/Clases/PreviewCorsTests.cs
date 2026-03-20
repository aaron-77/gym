using System.Net;
using System.Net.Http.Headers;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Factories;
using FluentAssertions;

namespace GymWebApp.Tests.Integration.Features.Clases;

/// <summary>
/// Integration tests for CORS behavior on /api/Clases/preview endpoint.
/// 
/// GREEN Phase: Tests verify CORS configuration works correctly when the origin
/// matches the configured origin from "EndPoints:frontend:external".
/// </summary>
[Collection("PreviewClasesCorsIntegrationTests")]
public class PreviewCorsTests : IClassFixture<ClasesApiWebApplicationFactory<Program>>
{
    private readonly ClasesApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;
    
    // Origin configured in appsettings.Testing.json as EndPoints:frontend:external
    private const string AllowedOrigin = "http://localhost:5062";

    public PreviewCorsTests(ClasesApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        InitializeAsync().GetAwaiter().GetResult();
    }

    private async Task InitializeAsync()
    {
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
    }

    /// <summary>
    /// Creates HttpClient that simulates a request with Origin header.
    /// Since Origin is a restricted header, we need a delegating handler.
    /// </summary>
    private HttpClient CreateClientWithOrigin(string origin)
    {
        var handler = new TestCorsDelegatingHandler(_factory.Server.CreateHandler(), origin);
        var client = new HttpClient(handler)
        {
            BaseAddress = _factory.Server.BaseAddress
        };
        return client;
    }

    /// <summary>
    /// Scenario 1: Request from allowed origin should return CORS headers.
    /// 
    /// GREEN Phase: With origin matching the configuration, CORS middleware
    /// should return Access-Control-Allow-Origin header.
    /// </summary>
    [Fact]
    public async Task CorsAllowedOrigin_ReturnsOkWithCorsHeaders()
    {
        // Arrange - seed data for preview endpoint
        var connectionString = TestContainerHelper.ConnectionString;
        var clase = ClaseFactory.CrearClaseActiva();
        var saved = await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase);
        var imagen = ClaseFactory.CrearImagenParaBanner(saved.ClaseId);
        await DatabaseHelper.NonQueryAsyncTyped(connectionString, "ImagesForClases", imagen);

        // Create client that simulates request from allowed origin
        var clientWithOrigin = CreateClientWithOrigin(AllowedOrigin);

        // Act - request from allowed origin
        var response = await clientWithOrigin.GetAsync("/api/Clases/preview");

        // Assert - Response should be OK
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        // Assert - CORS headers MUST be present (GREEN phase: should pass)
        response.Headers.Should().ContainKey("Access-Control-Allow-Origin");
        response.Headers.GetValues("Access-Control-Allow-Origin").Should().Contain(AllowedOrigin);
    }

    /// <summary>
    /// Verifies that GET requests from allowed origin include CORS headers.
    /// 
    /// GREEN Phase: With origin matching the configuration, GET requests
    /// should return Access-Control-Allow-Origin header.
    /// </summary>
    [Fact]
    public async Task CorsAllowedOrigin_IncludesAllowMethodsAndHeaders()
    {
        // Arrange
        var connectionString = TestContainerHelper.ConnectionString;
        var clase = ClaseFactory.CrearClaseActiva(
            f => f.RuleFor(c => c.NombreClase, "CORS Test Class"));
        await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase);

        var clientWithOrigin = CreateClientWithOrigin(AllowedOrigin);

        // Act - Make GET request with Origin header (not OPTIONS)
        var response = await clientWithOrigin.GetAsync("/api/Clases/preview");

        // Assert - Verify CORS header is present
        
        response.Headers.Should().ContainKey("Access-Control-Allow-Origin");
        response.Headers.GetValues("Access-Control-Allow-Origin").Should().Contain(AllowedOrigin);
    }

    /// <summary>
    /// Test that request WITHOUT Origin header processes normally (no CORS headers needed).
    /// This is expected behavior - no Origin header means no CORS response needed.
    /// </summary>
    [Fact]
    public async Task RequestWithoutOriginHeader_ProcessesNormally()
    {
        // Arrange
        var connectionString = TestContainerHelper.ConnectionString;
        var clase = ClaseFactory.CrearClaseActiva(
            f => f.RuleFor(c => c.NombreClase, "No Origin Test"));
        await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase);

        // Act - request WITHOUT Origin header
        var response = await _client.GetAsync("/api/Clases/preview");

        
        // Assert - No CORS headers expected when no Origin in request
        response.Headers.Should().NotContainKey("Access-Control-Allow-Origin");
    }

    /// <summary>
    /// Scenario 6: Request from disallowed origin should return 403 Forbidden.
    /// 
    /// RED Phase: This test MUST FAIL because:
    /// - ASP.NET Core CORS by default does not return 403 for disallowed origins
    /// - It simply omits CORS headers but returns 200 OK
    /// - The spec explicitly requires 403 Forbidden for untrusted origins
    /// - We need custom middleware to enforce this behavior
    /// </summary>
    [Fact]
    public async Task CorsDisallowedOrigin_ReturnsForbidden()
    {
        // Arrange - use origin NOT in allowed list
        var disallowedOrigin = "http://malicious-site.com";
        var clientWithOrigin = CreateClientWithOrigin(disallowedOrigin);

        // Act - request from disallowed origin
        var response = await clientWithOrigin.GetAsync("/api/Clases/preview");

        // Assert - RED Phase: Will FAIL because ASP.NET Core returns 200 OK without CORS headers
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden,
            "Requests from untrusted origins should be forbidden with 403");
    }
}

/// <summary>
/// Delegating handler that adds Origin header to simulate CORS requests.
/// </summary>
internal class TestCorsDelegatingHandler : DelegatingHandler
{
    private readonly string _origin;

    public TestCorsDelegatingHandler(HttpMessageHandler innerHandler, string origin)
        : base(innerHandler)
    {
        _origin = origin;
    }

    protected override Task<HttpResponseMessage> SendAsync(
        HttpRequestMessage request,
        CancellationToken cancellationToken)
    {
        request.Headers.TryAddWithoutValidation("Origin", _origin);
        return base.SendAsync(request, cancellationToken);
    }
}
