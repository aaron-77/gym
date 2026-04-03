using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Factories;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Medidas;

/// <summary>
/// Integration tests para validar que los endpoints de Medidas no retornan datos duplicados
/// </summary>
[Collection("MedidasApiIntegrationTests")]
public class MedidasDuplicatesValidationTests : IClassFixture<CitasApiWebApplicationFactory<Program>>
{
    private readonly CitasApiWebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public MedidasDuplicatesValidationTests(CitasApiWebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
        TestContainerHelper.InitializeAsync().GetAwaiter().GetResult();
        TestContainerHelper.ResetDatabaseAsync().GetAwaiter().GetResult();
    }

    #region GET /api/getParametrosDeMedicion - No Duplicate Ids

    /// <summary>
    /// GIVEN: Un empleado autenticado
    /// WHEN: Se llama a getParametrosDeMedicion
    /// THEN: Los IDs de parámetros no deben estar duplicados y los nombres deben ser únicos
    /// </summary>
    [Fact]
    public async Task GetParametrosDeMedicion_ReturnsNoDuplicateParameterIds()
    {
        // Arrange
        var token = await _factory.AuthenticateAsync(_client);
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        
        // Get existing cliente from seed data
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await _client.GetAsync($"/api/getParametrosDeMedicion?idUsuario={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOParametroDeMedicion>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
        result.payload.Should().NotBeEmpty();

        // Verificar que no hay IDs duplicados
        var ids = result.payload.Select(p => p.parametroMedicionId).ToList();
        ids.Should().OnlyHaveUniqueItems("Los IDs de parámetros no deben estar duplicados");

        // Verificar que no hay nombres duplicados
        var nombres = result.payload.Select(p => p.nombre).ToList();
        nombres.Should().OnlyHaveUniqueItems("Los nombres de parámetros no deben estar duplicados");
    }

    #endregion

    #region GET /api/progresoDeUsuario - No Duplicate Progress Items

    /// <summary>
    /// GIVEN: Un cliente autenticado
    /// WHEN: Se llama a progresoDeUsuario
    /// THEN: Los items de progreso no deben tener parametroId ni nombreParametro duplicados
    /// </summary>
    [Fact]
    public async Task GetProgresoDeUsuario_ReturnsNoDuplicateParametroIds()
    {
        // Arrange
        var token = await _factory.AuthenticateAsClienteAsync(_client);
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await _client.GetAsync($"/api/progresoDeUsuario?idUsuario={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOItemProgreso>>>();
        result.Should().NotBeNull();

        // Si hay payload, verificar que no hay duplicados
        if (result!.payload != null && result.payload.Any())
        {
            // DTOItemProgreso contiene medida y meta, verificamos unicidad por medida.fkParametro
            var parametroIds = result.payload
                .Where(p => p.medida != null)
                .Select(p => p.medida.fkParametro)
                .ToList();
            parametroIds.Should().OnlyHaveUniqueItems("Los IDs de parámetros en progreso no deben estar duplicados");

            var nombresParametro = result.payload
                .Where(p => p.medida != null && !string.IsNullOrEmpty(p.medida.nombreParametro))
                .Select(p => p.medida.nombreParametro)
                .ToList();
            nombresParametro.Should().OnlyHaveUniqueItems("Los nombres de parámetros en progreso no deben estar duplicados");
        }
    }

    #endregion

    #region GET /api/obtenerAñosConActividadDelCliente - No Duplicate Years

    /// <summary>
    /// GIVEN: Un empleado autenticado
    /// WHEN: Se llama a obtenerAñosConActividadDelCliente
    /// THEN: Los años no deben estar duplicados
    /// </summary>
    [Fact]
    public async Task ObtenerAñosConActividadDelCliente_ReturnsNoDuplicateYears()
    {
        // Arrange
        var token = await _factory.AuthenticateAsync(_client);
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await _client.GetAsync($"/api/obtenerAñosConActividadDelCliente?idCliente={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<HttpResponseAñosActivo>();
        result.Should().NotBeNull();

        // Si hay datos, verificar que no hay años duplicados
        if (result!.data != null && result.data.Any())
        {
            result.data.Should().OnlyHaveUniqueItems("Los años con actividad no deben estar duplicados");
        }
    }

    #endregion

    #region GET /api/obtenerEjerciciosYParametros - No Duplicate Items

    /// <summary>
    /// GIVEN: Un empleado autenticado
    /// WHEN: Se llama a obtenerEjerciciosYParametros
    /// THEN: No debe haber ejercicioId, parametroId, nombreEjercicio ni nombreParametro duplicados
    /// </summary>
    [Fact]
    public async Task ObtenerEjerciciosYParametros_ReturnsNoDuplicateItems()
    {
        // Arrange
        var token = await _factory.AuthenticateAsync(_client);
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await _client.GetAsync($"/api/obtenerEjerciciosYParametros?idCliente={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOEjerciciosYParametrosDelCliente>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();

        // Si hay payload, verificar que no hay duplicados
        if (result.payload != null && result.payload.Any())
        {
            var ejercicioIds = result.payload.Where(e => e.EjercicioId.HasValue).Select(e => e.EjercicioId!.Value).ToList();
            ejercicioIds.Should().OnlyHaveUniqueItems("Los IDs de ejercicios no deben estar duplicados");

            var parametroIds = result.payload.Select(e => e.parametroMedicionId).ToList();
            parametroIds.Should().OnlyHaveUniqueItems("Los IDs de parámetros no deben estar duplicados");

            var nombresEjercicio = result.payload.Where(e => !string.IsNullOrEmpty(e.NombreEjercicio)).Select(e => e.NombreEjercicio).ToList();
            nombresEjercicio.Should().OnlyHaveUniqueItems("Los nombres de ejercicios no deben estar duplicados");

            var nombresParametro = result.payload.Select(e => e.nombreParametro).ToList();
            nombresParametro.Should().OnlyHaveUniqueItems("Los nombres de parámetros no deben estar duplicados");
        }
    }

    #endregion
}
