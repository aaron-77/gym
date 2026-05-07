using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

/// <summary>
/// Integration tests for GET /api/Clases/nivelesDeDificultad endpoint.
/// 
/// RED Phase: Tests verify the expected behavior per requirements:
/// - Authenticated users should receive 200 OK with difficulty levels
/// - Unauthenticated requests should receive 401 Unauthorized
/// 
/// CURRENT STATE: Endpoint lacks [Authorize] attribute, so tests WILL FAIL.
/// After implementing [Authorize], tests should pass (GREEN phase).
/// </summary>
[Collection("IntegrationTests")]
public class NivelesDificultadTests : IntegrationTestBase
{
    private string? _authToken;

    public NivelesDificultadTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    public override async Task InitializeAsync()
    {
        await base.InitializeAsync();
        
        // Get authentication token for authenticated tests
        _authToken = await Factory.AuthenticateAsync(Client);
    }

    private void SetAuthHeader()
    {
        if (string.IsNullOrEmpty(_authToken))
            throw new InvalidOperationException("Auth token not available");
        
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _authToken);
    }

    private void ClearAuthHeader()
    {
        Client.DefaultRequestHeaders.Authorization = null;
    }

    #region Happy Path Tests

    /// <summary>
    /// Escenario: Usuario autenticado solicita catálogo de niveles de dificultad
    /// 
    /// GIVEN: Usuario autenticado con token JWT válido
    /// WHEN: GET /api/Clases/nivelesDeDificultad
    /// THEN: Returns 200 OK with payload containing list of DTODificultad objects
    /// AND: Lista contiene principiante (id=1), intermedio (id=2), avanzado (id=3)
    /// 
    /// RED Phase: WILL FAIL because endpoint lacks [Authorize] attribute.
    /// After adding [Authorize], this test should pass.
    /// </summary>
    [Fact]
    public async Task ObtenerNivelesDificultad_WithAuthenticatedUser_ReturnsOk()
    {
        // Arrange
        SetAuthHeader();

        // Act
        var response = await Client.GetAsync("/api/Clases/nivelesDeDificultad");

        // Assert - Response should be OK
        response.StatusCode.Should().Be(HttpStatusCode.OK,
            "Authenticated user should be able to access difficulty levels");

        // Assert - Parse response
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTODificultad>>>();
        result.Should().NotBeNull("Response should contain valid JSON");
        result!.success.Should().BeTrue("Success flag should be true");
        result.payload.Should().NotBeNull("Payload should not be null");

        // Assert - Verify difficulty levels structure
        result.payload.Should().HaveCountGreaterThanOrEqualTo(3,
            "Should contain at least 3 difficulty levels (principiante, intermedio, avanzado)");

        // Assert - Verify known difficulty levels exist
        var principiante = result.payload!.FirstOrDefault(n => n.Nombre.Equals("principiante", StringComparison.OrdinalIgnoreCase));
        var intermedio = result.payload!.FirstOrDefault(n => n.Nombre.Equals("intermedio", StringComparison.OrdinalIgnoreCase));
        var avanzado = result.payload!.FirstOrDefault(n => n.Nombre.Equals("avanzado", StringComparison.OrdinalIgnoreCase));

        principiante.Should().NotBeNull("principiante level should exist");
        principiante!.Id.Should().BeGreaterThan(0);
        
        intermedio.Should().NotBeNull("intermedio level should exist");
        intermedio!.Id.Should().BeGreaterThan(0);
        
        avanzado.Should().NotBeNull("avanzado level should exist");
        avanzado!.Id.Should().BeGreaterThan(0);

        // Assert - Each level has valid data
        foreach (var nivel in result.payload)
        {
            nivel.Id.Should().BeGreaterThan(0, "Each difficulty level should have Id > 0");
            nivel.Nombre.Should().NotBeNullOrEmpty("Each difficulty level should have a non-empty Nombre");
        }
    }

    /// <summary>
    /// Verifies the response structure matches DTODificultad contract.
    /// 
    /// RED Phase: WILL FAIL because endpoint lacks [Authorize].
    /// </summary>
    [Fact]
    public async Task ObtenerNivelesDificultad_ResponseStructure_IsValid()
    {
        // Arrange
        SetAuthHeader();

        // Act
        var response = await Client.GetAsync("/api/Clases/nivelesDeDificultad");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTODificultad>>>();
        result.Should().NotBeNull();
        
        // Verify response metadata
        result!.httpCode.Should().Be(200, "HTTP code in response should be 200");
        result.message.Should().NotBeNullOrEmpty("Response should include a message");

        // Verify payload structure
        result.payload.Should().AllSatisfy(nivel =>
        {
            nivel.Id.Should().BeGreaterThan(0);
            nivel.Nombre.Should().NotBeNullOrEmpty();
        }, "Each DTODificultad should have valid Id and Nombre");
    }

    #endregion

    #region Sad Path Tests

    /// <summary>
    /// Escenario: Request sin token JWT debe fallar
    /// 
    /// GIVEN: Request sin autenticación (sin Bearer token)
    /// WHEN: GET /api/Clases/nivelesDeDificultad
    /// THEN: Returns 401 Unauthorized
    /// 
    /// RED Phase: WILL FAIL because endpoint lacks [Authorize] attribute.
    /// Currently returns 200 OK (public endpoint). 
    /// After adding [Authorize], this test should pass.
    /// </summary>
    [Fact]
    public async Task ObtenerNivelesDificultad_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange
        ClearAuthHeader(); // Ensure no token is sent

        // Act
        var response = await Client.GetAsync("/api/Clases/nivelesDeDificultad");

        // Assert - Should be Unauthorized (401)
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized,
            "Requests without JWT token should be rejected with 401 Unauthorized");
    }

    /// <summary>
    /// Verifies that invalid/bad token also returns 401.
    /// 
    /// RED Phase: WILL FAIL because endpoint lacks [Authorize].
    /// </summary>
    [Fact]
    public async Task ObtenerNivelesDificultad_WithInvalidToken_ReturnsUnauthorized()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "invalid-token-xyz");

        // Act
        var response = await Client.GetAsync("/api/Clases/nivelesDeDificultad");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized,
            "Requests with invalid JWT token should be rejected with 401 Unauthorized");
    }

    #endregion
}
