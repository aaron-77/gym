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
/// Tests de integración para el endpoint GET api/inscripciones/obtenerInscripcionesDelCliente/{idUsuario}
/// (spec 34). Valida happy path, edge cases y autorización.
/// </summary>
[Collection("IntegrationTests")]
public class InscripcionesControllerTests : IntegrationTestBase
{
    public InscripcionesControllerTests(
        CitasApiWebApplicationFactory<Program> factory,
        TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    private const string EndpointBase = "/api/inscripciones/obtenerInscripcionesDelCliente";

    #region Happy Path

    [Fact]
    public async Task ObtenerInscripciones_ClienteConInscripcionesFuturas_ReturnsOkWithList()
    {
        // Arrange — generar inscripciones frescas via SPs
        var clienteId = await InscripcionEndpointHelper.SeedFreshInscripcionAsync(
            TestContainerHelper.ConnectionString);

        // Autenticar como empleado
        await SetAuthHeaderAsync();

        // Act
        var response = await Client.GetAsync($"{EndpointBase}/{clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOInscripcionDelCliente>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().NotBeEmpty("El cliente fue inscrito via SP a una clase futura");
        result.payload.Should().AllSatisfy(i =>
        {
            i.IdInscripcion.Should().BeGreaterThan(0);
            i.NombreClase.Should().NotBeNullOrEmpty();
            i.FechaDeLaClase.Should().BeOnOrAfter(DateTime.Today);
        });
    }

    [Fact]
    public async Task ObtenerInscripciones_ClienteSinInscripciones_ReturnsOkWithEmptyList()
    {
        // Arrange — BD reseteada, buscar o crear usuario sin inscripciones
        await SetAuthHeaderAsync();

        var clienteRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            @"SELECT TOP 1 u.Id FROM AspNetUsers u
              WHERE NOT EXISTS (
                  SELECT 1
                  FROM inscripcionesDeClases i
                      INNER JOIN clasesProgramadas cp ON i.fkProgramacionClase = cp.idProgramacionClase
                      INNER JOIN horariosDeClasesProgramadas hcp ON cp.idProgramacionClase = hcp.fkClaseProgramada
                      INNER JOIN horasLaborales hl ON hcp.fkHorarioLaboral = hl.idHora
                  WHERE i.fkCliente = u.Id
                      AND (
                          cp.fechaDeLaClase > CAST(GETDATE() AS DATE)
                          OR (cp.fechaDeLaClase = CAST(GETDATE() AS DATE) AND hl.horaInicio > CAST(GETDATE() AS TIME))
                      )
              )");

        var clienteId = clienteRow?["Id"]?.ToString();

        // Si no hay usuarios sin inscripciones, crear uno nuevo
        if (clienteId == null)
        {
            var nuevoId = Guid.NewGuid().ToString();
            await DatabaseHelper.ExecuteNonQueryAsync(
                TestContainerHelper.ConnectionString,
                @"INSERT INTO AspNetUsers (Id, UserName, NormalizedUserName, Email, EmailConfirmed, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEnabled, AccessFailedCount, NombreCompleto, FechaDeRegistro)
                  VALUES (@Id, @Id, @Id, @Id + '@test.com', 0, 0, 0, 0, 0, 'Test User', GETDATE())",
                new Dictionary<string, object?> { ["@Id"] = nuevoId });

            // Asignar rol cliente
            var rolRow = await DatabaseHelper.ExecuteQuerySingleAsync(
                TestContainerHelper.ConnectionString,
                "SELECT TOP 1 Id FROM AspNetRoles WHERE Name = 'cliente'");
            var rolId = rolRow?["Id"]?.ToString();
            if (rolId != null)
            {
                await DatabaseHelper.ExecuteNonQueryAsync(
                    TestContainerHelper.ConnectionString,
                    "INSERT INTO AspNetUserRoles (UserId, RoleId) VALUES (@UserId, @RoleId)",
                    new Dictionary<string, object?>
                    {
                        ["@UserId"] = nuevoId,
                        ["@RoleId"] = rolId
                    });
            }

            clienteId = nuevoId;
        }

        // Act
        var response = await Client.GetAsync($"{EndpointBase}/{clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOInscripcionDelCliente>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload.Should().BeEmpty();
    }

    #endregion

    #region Edge Cases — Validación de parámetros

    [Fact]
    public async Task ObtenerInscripciones_GuidInvalido_ReturnsBadRequest()
    {
        // Arrange
        await SetAuthHeaderAsync();
        // string sin formato GUID
        var idCliente = "abc123";

        // Act — pasar string sin formato GUID
        var response = await Client.GetAsync($"{EndpointBase}/{idCliente}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOInscripcionDelCliente>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
        result.httpCode.Should().Be(400);
    }

    [Fact]
    public void ObtenerInscripciones_GuidVacio_ReturnsBadRequest()
    {
        // Arrange
        SetAuthHeaderAsync().GetAwaiter().GetResult();

        // Act — pasar string vacío
        var response = Client.GetAsync($"{EndpointBase}/").GetAwaiter().GetResult();

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public void ObtenerInscripciones_GuidInexistente_ReturnsNotFound()
    {
        // Arrange
        SetAuthHeaderAsync().GetAwaiter().GetResult();
        // GUID que sabemos que ningún usuario tiene en la BD
        var guidInexistente = "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF";

        // Act — GUID con formato válido pero usuario no existe
        var response = Client.GetAsync($"{EndpointBase}/{guidInexistente}").GetAwaiter().GetResult();

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);

        var result = response.Content.ReadFromJsonAsync<DTOResponse<List<DTOInscripcionDelCliente>>>().GetAwaiter().GetResult();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
        result.httpCode.Should().Be(404);
    }

    #endregion

    #region Edge Cases — Autorización

    [Fact]
    public async Task ObtenerInscripciones_SinAutenticacion_ReturnsUnauthorized()
    {
        // Arrange — sin token
        ClearAuthHeader();
        // GUID cualquiera con formato válido
        var idCliente = Guid.NewGuid().ToString();

        // Act
        var response = await Client.GetAsync($"{EndpointBase}/{idCliente}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task ObtenerInscripciones_RolCliente_ReturnsForbidden()
    {
        // Arrange — autenticar como cliente (NO empleado)
        await SetAuthHeaderAsClienteAsync();
        // GUID cualquiera con formato válido
        var idCliente = Guid.NewGuid().ToString();

        // Act
        var response = await Client.GetAsync($"{EndpointBase}/{idCliente}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    #endregion
}
