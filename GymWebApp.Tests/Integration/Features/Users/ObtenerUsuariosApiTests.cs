using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("ObtenerUsuariosApiIntegrationTests")]
public class ObtenerUsuariosApiTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;
    private string? _authTokenEmpleado;
    private string? _authTokenCliente;

    public ObtenerUsuariosApiTests(CitasApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        InitializeAsync().GetAwaiter().GetResult();
    }

    private async Task InitializeAsync()
    {
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        
        // Authenticate FIRST before database operations that require it
        _authTokenEmpleado = await _factory.AuthenticateAsync(_client);
        _authTokenCliente = await _factory.AuthenticateAsClienteAsync(_client);
    }

    private void SetAuthHeader(string? token)
    {
        _client.DefaultRequestHeaders.Authorization = token != null 
            ? new AuthenticationHeaderValue("Bearer", token) 
            : null;
    }

    #region Happy Paths (HP)

    /// <summary>
    /// HP01: Token de empleado válido → 200 OK + lista ExistingUser
    /// </summary>
    [Fact]
    public async Task ObtenerUsuarios_WithValidEmpleadoToken_Returns200OkAndUserList()
    {
        // Arrange - reset db and set auth
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader(_authTokenEmpleado);

        // Act
        var response = await _client.GetAsync("/api/obtenerUsuarios");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<ExistingUser>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().NotBeEmpty();
        
        // Verify each user has required fields
        foreach (var user in result.payload!)
        {
            user.Id.Should().NotBeEmpty();
            user.NombreCompleto.Should().NotBeEmpty();
        }
    }

    #endregion

    #region Sad Paths (SP)

    /// <summary>
    /// SP01: Sin token → 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerUsuarios_WithoutToken_Returns401Unauthorized()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader(null); // No token

        // Act
        var response = await _client.GetAsync("/api/obtenerUsuarios");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    /// <summary>
    /// SP02: Token de cliente → 403 Forbidden
    /// </summary>
    [Fact]
    public async Task ObtenerUsuarios_WithClienteToken_Returns403Forbidden()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader(_authTokenCliente);

        // Act
        var response = await _client.GetAsync("/api/obtenerUsuarios");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    #endregion
}
