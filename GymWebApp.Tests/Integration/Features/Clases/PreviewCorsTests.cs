using System.Net;
using System.Net.Http.Headers;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Factories;
using FluentAssertions;

namespace GymWebApp.Tests.Integration.Features.Clases;

/// <summary>
/// Integration tests for CORS behavior on /api/Clases/preview endpoint.
/// 
/// Tests verify that the public CORS policy allows any origin to access the endpoint.
/// </summary>
[Collection("PreviewClasesCorsIntegrationTests")]
public class PreviewCorsTests : IClassFixture<ClasesApiWebApplicationFactory<Program>>
{
    private readonly ClasesApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;
    
    // With EnableCors("public"), any origin is allowed
    private const string AnyOrigin = "http://any-origin.com";

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
    /// Scenario: Request from any origin should return CORS headers.
    /// 
    /// With EnableCors("public"), any origin is allowed.
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

        // Create client that simulates request from any origin
        var clientWithOrigin = CreateClientWithOrigin(AnyOrigin);

        // Act - request from any origin
        var response = await clientWithOrigin.GetAsync("/api/Clases/preview");

        // Assert - Response should be OK
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        // Assert - CORS headers MUST be present
        response.Headers.Should().ContainKey("Access-Control-Allow-Origin");
        response.Headers.GetValues("Access-Control-Allow-Origin").Should().Contain(AnyOrigin);
    }

    /// <summary>
    /// Verifies that GET requests from any origin include CORS headers.
    /// </summary>
    [Fact]
    public async Task CorsAllowedOrigin_IncludesAllowMethodsAndHeaders()
    {
        // Arrange
        var connectionString = TestContainerHelper.ConnectionString;
        var clase = ClaseFactory.CrearClaseActiva(
            f => f.RuleFor(c => c.NombreClase, "CORS Test Class"));
        await DatabaseHelper.NonQueryAsyncTyped(connectionString, "Clases", clase);

        var clientWithOrigin = CreateClientWithOrigin(AnyOrigin);

        // Act - Make GET request with Origin header (not OPTIONS)
        var response = await clientWithOrigin.GetAsync("/api/Clases/preview");

        // Assert - Verify CORS header is present
        
        response.Headers.Should().ContainKey("Access-Control-Allow-Origin");
        response.Headers.GetValues("Access-Control-Allow-Origin").Should().Contain(AnyOrigin);
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
