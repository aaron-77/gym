using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using FluentAssertions;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using DTO.Dtos;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Inscripciones;

/// <summary>
/// Tests de integración para el endpoint POST api/inscripciones/cancelar
/// (spec 42). Valida happy path, edge cases de validación y autorización.
/// </summary>
[Collection("IntegrationTests")]
public class InscripcionesControllerCancelarTests : IntegrationTestBase
{
    private const string Endpoint = "/api/inscripciones/cancelar";

    public InscripcionesControllerCancelarTests(
        CitasApiWebApplicationFactory<Program> factory,
        TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    #region Happy Path

    /// <summary>
    /// Test 1: Cancelar una inscripción válida con fecha futura.
    /// Debe retornar 200 con payload = true.
    /// </summary>
    [Fact]
    public async Task CancelarInscripcion_InscripcionValida_ReturnsOk()
    {
        // Arrange — generar inscripción con fecha estrictamente posterior a hoy
        var seedResult = await InscripcionTestHelper.SeedSingleInscripcionConFechaPosteriorAsync(
            TestContainerHelper.ConnectionString);

        if (seedResult == null)
        {
            var fallbackDate = await InscripcionTestHelper.SeedFallbackAsync(
                TestContainerHelper.ConnectionString, DateTime.Today.Year);

            fallbackDate.Should().NotBeNull("No se pudo encontrar fecha alternativa para el seed");

            seedResult = await InscripcionTestHelper.SeedSingleInscripcionConFechaPosteriorAsync(
                TestContainerHelper.ConnectionString,
                fallbackDate!.Value.ToDateTime(TimeOnly.MinValue));
        }

        seedResult.Should().NotBeNull("El seed debería tener una inscripción disponible");
        var (_, idInscripcion) = seedResult!.Value;

        await SetAuthHeaderAsync();

        // Act
        var response = await Client.PostAsJsonAsync(Endpoint,
            new CancelarInscripcionRequest { IdInscripcion = idInscripcion });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<bool>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().BeTrue();
    }

    #endregion

    #region Edge Cases — Validación de parámetros

    /// <summary>
    /// Test 2: Enviar request body vacío (IdInscripcion default = 0).
    /// Debe retornar 400 por validación de [Range(1, int.MaxValue)].
    ///
    /// NOTA: [ApiController] devuelve ValidationProblemDetails en vez de
    /// DTOResponse cuando falla la validación del modelo. Solo validamos
    /// status code y que el body contenga el error de validación esperado.
    /// </summary>
    [Fact]
    public async Task CancelarInscripcion_RequestBodyNull_ReturnsBadRequest()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Act — IdInscripcion = 0, falla [Range(1, int.MaxValue)]
        var response = await Client.PostAsJsonAsync(Endpoint, new CancelarInscripcionRequest());

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);

        var body = await response.Content.ReadAsStringAsync();
        body.Should().Contain("El ID de inscripci");
    }

    /// <summary>
    /// Test 3a: Enviar IdInscripcion = 0.
    /// Debe retornar 400 por validación de [Range(1, int.MaxValue)].
    /// </summary>
    [Fact]
    public async Task CancelarInscripcion_IdCero_ReturnsBadRequest()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Act — IdInscripcion = 0, fuera del rango [1, int.MaxValue]
        var response = await Client.PostAsJsonAsync(Endpoint,
            new CancelarInscripcionRequest { IdInscripcion = 0 });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);

        var body = await response.Content.ReadAsStringAsync();
        body.Should().Contain("El ID de inscripci");
    }

    /// <summary>
    /// Test 3b: Enviar IdInscripcion negativo.
    /// Debe retornar 400 por validación de [Range(1, int.MaxValue)].
    /// </summary>
    [Fact]
    public async Task CancelarInscripcion_IdNegativo_ReturnsBadRequest()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Act — IdInscripcion = -1, fuera del rango [1, int.MaxValue]
        var response = await Client.PostAsJsonAsync(Endpoint,
            new CancelarInscripcionRequest { IdInscripcion = -1 });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);

        var body = await response.Content.ReadAsStringAsync();
        body.Should().Contain("El ID de inscripci");
    }

    /// <summary>
    /// Test 4: Enviar IdInscripcion con ID que no existe en BD.
    /// Debe retornar 404.
    /// </summary>
    [Fact]
    public async Task CancelarInscripcion_InscripcionInexistente_ReturnsNotFound()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Act — ID alto que seguro no existe en BD
        var response = await Client.PostAsJsonAsync(Endpoint,
            new CancelarInscripcionRequest { IdInscripcion = 999999 });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<bool>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
        result.httpCode.Should().Be(404);
    }

    #endregion

    #region Edge Cases — Autorización

    /// <summary>
    /// Test 5: Request sin token JWT.
    /// Debe retornar 401 por [Authorize].
    /// </summary>
    [Fact]
    public async Task CancelarInscripcion_SinAutenticacion_ReturnsUnauthorized()
    {
        // Arrange
        ClearAuthHeader();

        // Act
        var response = await Client.PostAsJsonAsync(Endpoint,
            new CancelarInscripcionRequest { IdInscripcion = 1 });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    /// <summary>
    /// Test 6: Token con rol cliente (no empleado).
    /// Debe retornar 403 por [Authorize(Roles = "empleado")].
    /// </summary>
    [Fact]
    public async Task CancelarInscripcion_RolCliente_ReturnsForbidden()
    {
        // Arrange
        await SetAuthHeaderAsClienteAsync();

        // Act
        var response = await Client.PostAsJsonAsync(Endpoint,
            new CancelarInscripcionRequest { IdInscripcion = 1 });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    /// <summary>
    /// Test 7: Token JWT válido pero con un ID de usuario que no existe en BD.
    /// Debe retornar 404 por validadorUsuario.ValidarAsync().
    ///
    /// Estrategia: generar un JWT custom usando la misma clave secreta de la API,
    /// con un GUID aleatorio (inexistente en BD) como NameIdentifier.
    /// No requiere modificar la BD ni eliminar usuarios existentes.
    /// </summary>
    [Fact]
    public async Task CancelarInscripcion_UsuarioNoExistente_ReturnsNotFound()
    {
        // Arrange — generar JWT con un UUID inventado (no existe en BD)
        var jwtToken = JwtTestHelper.GenerarJwtPersonalizado(
            userId: Guid.NewGuid().ToString(),
            role: "empleado",
            email: "inexistente@test.com");

        SetAuthHeader(jwtToken);

        // Act
        var response = await Client.PostAsJsonAsync(Endpoint,
            new CancelarInscripcionRequest { IdInscripcion = 1 });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<object?>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
        result.httpCode.Should().Be(404);
        result.errors.Should().Contain(e => e.message.Contains("no existe"));
    }

    #endregion
}
