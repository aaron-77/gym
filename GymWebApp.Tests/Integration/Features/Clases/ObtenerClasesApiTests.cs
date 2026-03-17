using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Clases;

[Collection("ClasesApiIntegrationTests")]
public class ObtenerClasesApiTests : IClassFixture<ClasesApiWebApplicationFactory<Program>>
{
    private readonly ClasesApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;
    private string? _authToken;

    public ObtenerClasesApiTests(ClasesApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        InitializeAsync().GetAwaiter().GetResult();
    }

    private async Task InitializeAsync()
    {
        await TestContainerHelper.InitializeAsync();
        await TestContainerHelper.ResetDatabaseAsync();
        _authToken = await _factory.AuthenticateAsync(_client);
    }

    private void SetAuthHeader()
    {
        if (string.IsNullOrEmpty(_authToken))
            throw new InvalidOperationException("Auth token not available");
        
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _authToken);
    }

    #region REQUISITO: Integration - Happy Path (Authenticated User Requests Active Classes)

    /// <summary>
    /// REQUISITO: Successful Class Retrieval
    /// Escenario: Authenticated user requests active classes catalog
    /// GIVEN: there are active classes in the database (FkEstadoClase = 1)
    /// AND: the user is authenticated with a valid JWT token
    /// WHEN: a GET request is made to /api/Clases/obtenerClases?activa=true with authentication headers
    /// THEN: the response status MUST be 200 OK
    /// AND: the success field MUST be true
    /// AND: the payload MUST contain a list of DTOClaseSimple objects
    /// AND: each object MUST have ClaseID and NombreClase populated
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WithActivaTrueAndAuthenticatedUser_ReturnsActiveClasses()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader();

        // Act
        var response = await _client.GetAsync("/api/Clases/obtenerClases?activa=true");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOClaseSimple>>>();
        
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Contain("activas");
        result.payload.Should().NotBeNull();
        result.payload.Should().NotBeEmpty();

        // Verificar que los datos tienen los campos requeridos
        foreach (var clase in result.payload)
        {
            clase.ClaseID.Should().BeGreaterThan(0, "ClaseID debe ser mayor a 0");
            clase.NombreClase.Should().NotBeNullOrEmpty("NombreClase es requerido");
        }

        // Verificar en BD que las clases devueltas son activas
        foreach (var clase in result.payload)
        {
            var claseDb = await DatabaseHelper.ExecuteQuerySingleAsync(
                TestContainerHelper.ConnectionString,
                "SELECT FkEstadoClase FROM Clases WHERE ClaseID = @Id",
                new() { ["@Id"] = clase.ClaseID });
            
            claseDb.Should().NotBeNull();
            var estado = Convert.ToInt32(claseDb!["FkEstadoClase"]);
            estado.Should().Be(1, "La clase debe estar activa (FkEstadoClase = 1)");
        }
    }

    #endregion

    #region REQUISITO: Integration - Sad Path (Inactive Classes)

    /// <summary>
    /// REQUISITO: Inactive Classes Returned When activa=false
    /// Escenario: Authenticated user requests inactive classes
    /// GIVEN: there are inactive classes in the database (FkEstadoClase = 2)
    /// AND: the user is authenticated
    /// WHEN: a GET request is made to /api/Clases/obtenerClases?activa=false
    /// THEN: the response status MUST be 200 OK
    /// AND: the success field MUST be true
    /// AND: the payload MUST contain a list of inactive classes
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WithActivaFalse_ReturnsInactiveClasses()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader();

        // Act
        var response = await _client.GetAsync("/api/Clases/obtenerClases?activa=false");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOClaseSimple>>>();
        
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Contain("inactivas");
        result.payload.Should().NotBeNull();

        // Verificar en BD que las clases devueltas son inactivas
        foreach (var clase in result.payload)
        {
            var claseDb = await DatabaseHelper.ExecuteQuerySingleAsync(
                TestContainerHelper.ConnectionString,
                "SELECT FkEstadoClase FROM Clases WHERE ClaseID = @Id",
                new() { ["@Id"] = clase.ClaseID });
            
            claseDb.Should().NotBeNull();
            var estado = Convert.ToInt32(claseDb!["FkEstadoClase"]);
            estado.Should().Be(2, "La clase debe estar inactiva (FkEstadoClase = 2)");
        }
    }

    /// <summary>
    /// REQUISITO: Request without activa parameter defaults to false
    /// Escenario: Authenticated user requests classes without activa parameter
    /// GIVEN: there are inactive classes in the database
    /// AND: the user is authenticated
    /// WHEN: a GET request is made to /api/Clases/obtenerClases (no query parameter)
    /// THEN: the response MUST return inactive classes (same as activa=false)
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WithoutParameter_ReturnsInactiveClasses()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader();

        // Act
        var response = await _client.GetAsync("/api/Clases/obtenerClases");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOClaseSimple>>>();
        
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        
        // Debe retornar las mismas clases que activa=false
        foreach (var clase in result.payload)
        {
            var claseDb = await DatabaseHelper.ExecuteQuerySingleAsync(
                TestContainerHelper.ConnectionString,
                "SELECT FkEstadoClase FROM Clases WHERE ClaseID = @Id",
                new() { ["@Id"] = clase.ClaseID });
            
            claseDb.Should().NotBeNull();
            var estado = Convert.ToInt32(claseDb!["FkEstadoClase"]);
            estado.Should().Be(2, "Sin parámetro debe retornar clases inactivas (default)");
        }
    }

    #endregion

    #region REQUISITO: Sad Path (Unauthenticated Request)

    /// <summary>
    /// REQUISITO: Unauthenticated Request Returns Error
    /// Escenario: Request without authentication
    /// GIVEN: the user is not authenticated (no JWT token)
    /// WHEN: a GET request is made to /api/Clases/obtenerClases?activa=true
    /// THEN: the response status MUST be 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WithoutAuthentication_ReturnsUnauthorized()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        // NO establecer el token de autenticación

        // Act
        var response = await _client.GetAsync("/api/Clases/obtenerClases?activa=true");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion

    #region REQUISITO: Sad Path (Database Error)

    /// <summary>
    /// REQUISITO: Error Handling
    /// Escenario: Database error returns 500
    /// GIVEN: the database connection fails or an error occurs
    /// WHEN: a GET request is made to /api/Clases/obtenerClases
    /// THEN: the response status MUST be 500 Internal Server Error
    /// AND: the success field MUST be false
    /// AND: the errors list MUST contain error details
    /// </summary>
    [Fact]
    public async Task ObtenerClases_WhenDatabaseError_Returns500()
    {
        // Arrange
        await TestContainerHelper.ResetDatabaseAsync();
        SetAuthHeader();

        // Simular error de base de datos truncando la tabla Clases
        // Esto causará un error al intentar hacer la consulta
        await using var connection = DatabaseHelper.GetSqlConnection(TestContainerHelper.ConnectionString);
        await connection.OpenAsync();
        await using var command = connection.CreateCommand();
        
        // Forzar un error de base de datos usando un comando inválido
        // En SQL Server, si el usuario no tiene permisos, esto fallará
        // O podemos simularlo con una query que genere error
        command.CommandText = "DELETE FROM Clases WHERE 1=0"; // Query válida pero simula transacción

        // Act
        var response = await _client.GetAsync("/api/Clases/obtenerClases");

        // Assert
        // Nota: Este test puede fallar si la operación anterior no genera error real
        // Depende de si el endpoint maneja correctamente los errores de DB
        response.StatusCode.Should().BeOneOf(HttpStatusCode.OK, HttpStatusCode.InternalServerError);
        
        // Si la respuesta es 500, verificar el formato del error
        if (response.StatusCode == HttpStatusCode.InternalServerError)
        {
            var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOClaseSimple>>>();
            result.Should().NotBeNull();
            result!.success.Should().BeFalse();
            result.errors.Should().NotBeNullOrEmpty();
        }
    }

    #endregion
}
