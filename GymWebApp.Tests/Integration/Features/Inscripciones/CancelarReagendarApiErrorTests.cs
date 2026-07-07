using System.Net;
using System.Net.Http.Headers;
using FluentAssertions;
using GymWebApp.Tests.Integration.Common;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Inscripciones;

/// <summary>
/// Tests de integración para el endpoint GET /Inscripciones/cancelarReagendar
/// (spec 36). Verifica que la vista maneja correctamente errores de la API,
/// mostrando el mensaje de error al usuario.
///
/// A diferencia de los tests E2E (que prueban el flujo completo con stack real),
/// este test de integración usa CancelarReagendarApiErrorWebApplicationFactory
/// con un IHttpCustomClient simulado para forzar errores de API que no se
/// pueden reproducir en E2E.
/// </summary>
[Collection("IntegrationTests")]
public class CancelarReagendarApiErrorTests : IClassFixture<CancelarReagendarApiErrorWebApplicationFactory>
{
    private readonly CancelarReagendarApiErrorWebApplicationFactory _factory;
    private readonly HttpClient _client;

    public CancelarReagendarApiErrorTests(
        CancelarReagendarApiErrorWebApplicationFactory factory,
        TestContainerHelper testContainerHelper)
    {
        _factory = factory;
        _client = factory.CreateClient();
    }

    /// <summary>
    /// Test 4: Verifica que cuando la API no responde (error de conexión),
    /// la vista se renderiza con un mensaje de error en .alert-danger.
    ///
    /// El ApiErrorSimulatorClient lanza HttpRequestException al llamar
    /// a cualquier endpoint de la API, lo que hace que el controller
    /// entre al bloque catch y asigne ViewBag.ErrorMessage.
    /// </summary>
    [Fact]
    public async Task CancelarReagendar_ApiNoDisponible_MuestraErrorEnVista()
    {
        // Arrange — autenticar como empleado (token JWT generado inline
        // por el factory, misma firma que CitasApiWebApplicationFactory)
        var token = await _factory.AuthenticateAsync(_client);
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Act
        var response = await _client.GetAsync("/Inscripciones/cancelarReagendar");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var content = await response.Content.ReadAsStringAsync();

        // La vista debe mostrar el mensaje de error cuando la API falla
        content.Should().Contain("alert-danger");
        
        content.Should().Contain("error al cargar los datos");
    }
}
