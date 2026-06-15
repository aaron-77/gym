using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Factories;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

// ============================================================================
// MEDIDAS API INTEGRATION TESTS
// ============================================================================
// Total: 17 tests en 6 endpoints
//
// 1. RegistrarMedidaTests             (3 tests) - POST /api/RegistrarMedida
// 2. GetParametrosDeMedicionTests     (3 tests) - GET /api/getParametrosDeMedicion
// 3. ObtenerAñosConActividadTests     (3 tests) - GET /api/obtenerAñosConActividadDelCliente
// 4. ObtenerEjerciciosYParametros     (3 tests) - GET /api/obtenerEjerciciosYParametros
// 5. ObtenerDetallesDeProgreso        (3 tests) - GET /api/obtenerDetallesDeProgreso
// 6. GetProgresoDeUsuario             (2 tests) - GET /api/progresoDeUsuario
// ============================================================================

namespace GymWebApp.Tests.Integration.Features.Medidas;

[Collection("IntegrationTests")]
public class MedidasApiTests : IntegrationTestBase
{
    public MedidasApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper) { }

    // ============================================================================
    // POST /api/RegistrarMedida
    // ============================================================================
    // Propósito: Registrar una nueva medida corporal para un cliente
    // Roles permitidos: empleado (solo)
    // Tests: 3
    //   - AsEmpleado: 200 OK + inserta en BD
    //   - WithoutAuth: 401 Unauthorized
    //   - AsCliente: 403 Forbidden
    // ============================================================================
    #region POST /api/RegistrarMedida

    /// <summary>
    /// GIVEN: Un empleado autenticado con datos válidos de medida
    /// WHEN: Se envía una solicitud POST a /api/RegistrarMedida con un DTOMedida válido
    /// THEN: Retorna 200 OK con mensaje de éxito Y la medida se inserta en la base de datos
    /// </summary>
    [Fact]
    public async Task RegistrarMedida_AsEmpleado_Returns200AndInsertsToDb()
    {
        // Arrange
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data (aaronhl1313@gmail.com)
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Create valid medida request
        var medidaRequest = MedidaFactory.CrearMedidaPeso(clienteId, 75.5m);

        // Act
        var response = await Client.PostAsJsonAsync("/api/RegistrarMedida", medidaRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<DTOMedida>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.message.Should().Contain("Registro exitoso");

        // Verify DB insert
        var insertedMedida = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 FkUsuario, FkParametro, Valor FROM Medidas WHERE FkUsuario = @ClienteId ORDER BY medidaId DESC",
            new Dictionary<string, object?> { ["@ClienteId"] = clienteId });

        insertedMedida.Should().NotBeNull("La medida debe existir en la BD");
        insertedMedida!["FkUsuario"]!.ToString().Should().Be(clienteId);
        insertedMedida["FkParametro"].Should().Be(1); // peso
        insertedMedida["Valor"].Should().Be(75.5m);
    }

    /// <summary>
    /// GIVEN: Sin token de autenticación
    /// WHEN: Se envía POST a /api/RegistrarMedida
    /// THEN: Retorna 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task RegistrarMedida_WithoutAuth_Returns401()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = null;

        var medidaRequest = MedidaFactory.CrearMedidaPeso(Guid.NewGuid().ToString(), 75.5m);

        // Act
        var response = await Client.PostAsJsonAsync("/api/RegistrarMedida", medidaRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    /// <summary>
    /// GIVEN: Un cliente autenticado con rol "cliente"
    /// WHEN: Se envía POST a /api/RegistrarMedida
    /// THEN: Retorna 403 Forbidden
    /// </summary>
    [Fact]
    public async Task RegistrarMedida_AsCliente_Returns403()
    {
        // Arrange
        var token = await Factory.AuthenticateAsClienteAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data (aaronhl1313@gmail.com)
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        var medidaRequest = MedidaFactory.CrearMedidaPeso(clienteId, 75.5m);

        // Act
        var response = await Client.PostAsJsonAsync("/api/RegistrarMedida", medidaRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    #endregion
    // Fin de pruebas para POST /api/RegistrarMedida

    // ============================================================================
    // GET /api/getParametrosDeMedicion
    // ============================================================================
    // Propósito: Obtener lista de parámetros de medición disponibles
    // Roles permitidos: empleado, cliente
    // Tests: 3
    //   - AsEmpleado: 200 OK
    //   - AsCliente: 200 OK
    //   - WithoutAuth: 401 Unauthorized
    // ============================================================================
    #region GET /api/getParametrosDeMedicion

    /// <summary>
    /// GIVEN: Un empleado autenticado
    /// WHEN: Se envía una solicitud GET a /api/getParametrosDeMedicion?idUsuario={id}
    /// THEN: Retorna 200 OK con una lista de parámetros de medición
    /// </summary>
    [Fact]
    public async Task GetParametrosDeMedicion_AsEmpleado_Returns200()
    {
        // Arrange
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await Client.GetAsync($"/api/getParametrosDeMedicion?idUsuario={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOParametroDeMedicion>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
    }

    /// <summary>
    /// GIVEN: Un cliente autenticado
    /// WHEN: Se envía una solicitud GET a /api/getParametrosDeMedicion?idUsuario={id}
    /// THEN: Retorna 200 OK con una lista de parámetros de medición
    /// </summary>
    [Fact]
    public async Task GetParametrosDeMedicion_AsCliente_Returns200()
    {
        // Arrange
        var token = await Factory.AuthenticateAsClienteAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data (itself)
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await Client.GetAsync($"/api/getParametrosDeMedicion?idUsuario={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOParametroDeMedicion>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
    }

    /// <summary>
    /// GIVEN: Sin token de autenticación
    /// WHEN: Se envía GET a /api/getParametrosDeMedicion
    /// THEN: Retorna 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task GetParametrosDeMedicion_WithoutAuth_Returns401()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = null;

        // Act
        var response = await Client.GetAsync("/api/getParametrosDeMedicion?idUsuario=test");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
    // Fin de pruebas para GET /api/getParametrosDeMedicion

    // ============================================================================
    // GET /api/obtenerAñosConActividadDelCliente
    // ============================================================================
    // Propósito: Obtener años donde el cliente tuvo actividad registrada
    // Roles permitidos: empleado, cliente
    // Tests: 3
    //   - AsEmpleado: 200 OK
    //   - AsCliente: 200 OK
    //   - WithoutAuth: 401 Unauthorized
    // ============================================================================
    #region GET /api/obtenerAñosConActividadDelCliente

    /// <summary>
    /// GIVEN: Un empleado autenticado
    /// WHEN: Se envía una solicitud GET a /api/obtenerAñosConActividadDelCliente?idCliente={id}
    /// THEN: Retorna 200 OK con lista de años con actividad
    /// </summary>
    [Fact]
    public async Task ObtenerAñosConActividadDelCliente_AsEmpleado_Returns200()
    {
        // Arrange
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await Client.GetAsync($"/api/obtenerAñosConActividadDelCliente?idCliente={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<int>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
    }

    /// <summary>
    /// GIVEN: Un cliente autenticado
    /// WHEN: Se envía una solicitud GET a /api/obtenerAñosConActividadDelCliente?idCliente={id}
    /// THEN: Retorna 200 OK con lista de años con actividad
    /// </summary>
    [Fact]
    public async Task ObtenerAñosConActividadDelCliente_AsCliente_Returns200()
    {
        // Arrange
        var token = await Factory.AuthenticateAsClienteAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data (itself)
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await Client.GetAsync($"/api/obtenerAñosConActividadDelCliente?idCliente={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<int>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
    }

    /// <summary>
    /// GIVEN: Sin token de autenticación
    /// WHEN: Se envía GET a /api/obtenerAñosConActividadDelCliente
    /// THEN: Retorna 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerAñosConActividadDelCliente_WithoutAuth_Returns401()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = null;

        // Act
        var response = await Client.GetAsync("/api/obtenerAñosConActividadDelCliente?idCliente=test");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
    // Fin de pruebas para GET /api/obtenerAñosConActividadDelCliente

    // ============================================================================
    // GET /api/obtenerEjerciciosYParametros
    // ============================================================================
    // Propósito: Obtener lista de ejercicios y parámetros del cliente
    // Roles permitidos: empleado, cliente
    // Tests: 3
    //   - AsEmpleado: 200 OK
    //   - AsCliente: 200 OK
    //   - WithoutAuth: 401 Unauthorized
    // ============================================================================
    #region GET /api/obtenerEjerciciosYParametros

    /// <summary>
    /// GIVEN: Un empleado autenticado
    /// WHEN: Se envía una solicitud GET a /api/obtenerEjerciciosYParametros?idCliente={id}
    /// THEN: Retorna 200 OK con lista de ejercicios y parámetros del cliente
    /// </summary>
    [Fact]
    public async Task ObtenerEjerciciosYParametros_AsEmpleado_Returns200()
    {
        // Arrange
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await Client.GetAsync($"/api/obtenerEjerciciosYParametros?idCliente={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOEjerciciosYParametrosDelCliente>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
    }

    /// <summary>
    /// GIVEN: Un cliente autenticado
    /// WHEN: Se envía una solicitud GET a /api/obtenerEjerciciosYParametros?idCliente={id}
    /// THEN: Retorna 200 OK con lista de ejercicios y parámetros del cliente
    /// </summary>
    [Fact]
    public async Task ObtenerEjerciciosYParametros_AsCliente_Returns200()
    {
        // Arrange
        var token = await Factory.AuthenticateAsClienteAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data (itself)
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await Client.GetAsync($"/api/obtenerEjerciciosYParametros?idCliente={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOEjerciciosYParametrosDelCliente>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
    }

    /// <summary>
    /// GIVEN: Sin token de autenticación
    /// WHEN: Se envía GET a /api/obtenerEjerciciosYParametros
    /// THEN: Retorna 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerEjerciciosYParametros_WithoutAuth_Returns401()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = null;

        // Act
        var response = await Client.GetAsync("/api/obtenerEjerciciosYParametros?idCliente=test");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
    // Fin de pruebas para GET /api/obtenerEjerciciosYParametros

    // ============================================================================
    // GET /api/obtenerDetallesDeProgreso
    // ============================================================================
    // Propósito: Obtener detalles de progreso (medidas y metas) de un cliente
    // Roles permitidos: empleado, cliente
    // Tests: 3
    //   - AsEmpleado: 200 OK
    //   - AsCliente: 200 OK
    //   - WithoutAuth: 401 Unauthorized
    // ============================================================================
    #region GET /api/obtenerDetallesDeProgreso

    /// <summary>
    /// GIVEN: Un empleado autenticado con parámetros válidos
    /// WHEN: Se envía una solicitud GET a /api/obtenerDetallesDeProgreso?idCliente={id}&idParametro=1
    /// THEN: Retorna 200 OK con medidas y metas del cliente
    /// </summary>
    [Fact]
    public async Task ObtenerDetallesDeProgreso_AsEmpleado_Returns200()
    {
        // Arrange
        var token = await Factory.AuthenticateAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await Client.GetAsync($"/api/obtenerDetallesDeProgreso?idCliente={clienteId}&idParametro=1&espaciadoTemporal=individual&tipoDeBusqueda=MES");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<MedidasConMetas>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
    }

    /// <summary>
    /// GIVEN: Un cliente autenticado con parámetros válidos
    /// WHEN: Se envía una solicitud GET a /api/obtenerDetallesDeProgreso?idCliente={id}&idParametro=1
    /// THEN: Retorna 200 OK con medidas y metas del cliente
    /// </summary>
    [Fact]
    public async Task ObtenerDetallesDeProgreso_AsCliente_Returns200()
    {
        // Arrange
        var token = await Factory.AuthenticateAsClienteAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data (itself)
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await Client.GetAsync($"/api/obtenerDetallesDeProgreso?idCliente={clienteId}&idParametro=1&espaciadoTemporal=individual&tipoDeBusqueda=MES");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<MedidasConMetas>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
    }

    /// <summary>
    /// GIVEN: Sin token de autenticación
    /// WHEN: Se envía GET a /api/obtenerDetallesDeProgreso
    /// THEN: Retorna 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task ObtenerDetallesDeProgreso_WithoutAuth_Returns401()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = null;

        // Act
        var response = await Client.GetAsync("/api/obtenerDetallesDeProgreso?idCliente=test&idParametro=1");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
    // Fin de pruebas para GET /api/obtenerDetallesDeProgreso

    // ============================================================================
    // GET /api/progresoDeUsuario
    // ============================================================================
    // Propósito: Obtener progreso del usuario (últimas medidas y metas)
    // Roles permitidos: cliente
    // Tests: 2
    //   - AsCliente: 200 OK
    //   - WithoutAuth: 401 Unauthorized
    // ============================================================================
    #region GET /api/progresoDeUsuario

    /// <summary>
    /// GIVEN: Un cliente autenticado
    /// WHEN: Se envía una solicitud GET a /api/progresoDeUsuario?idUsuario={id}
    /// THEN: Retorna 200 OK con datos de progreso (últimas medidas y metas)
    /// </summary>
    [Fact]
    public async Task GetProgresoDeUsuario_AsCliente_Returns200()
    {
        // Arrange
        var token = await Factory.AuthenticateAsClienteAsync(Client);
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // Get existing cliente from seed data (itself)
        var cliente = await DatabaseHelper.ExecuteQuerySingleAsync(
            TestContainerHelper.ConnectionString,
            "SELECT TOP 1 Id FROM AspNetUsers WHERE Email = 'aaronhl1313@gmail.com'");

        var clienteId = cliente?["Id"]?.ToString() ?? throw new Exception("Cliente not found");

        // Act
        var response = await Client.GetAsync($"/api/progresoDeUsuario?idUsuario={clienteId}");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<DTOResponse<List<DTOItemProgreso>>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.payload.Should().NotBeNull();
    }

    /// <summary>
    /// GIVEN: Sin token de autenticación
    /// WHEN: Se envía GET a /api/progresoDeUsuario
    /// THEN: Retorna 401 Unauthorized
    /// </summary>
    [Fact]
    public async Task GetProgresoDeUsuario_WithoutAuth_Returns401()
    {
        // Arrange
        Client.DefaultRequestHeaders.Authorization = null;

        // Act
        var response = await Client.GetAsync("/api/progresoDeUsuario?idUsuario=test");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
    // Fin de pruebas para GET /api/progresoDeUsuario
}
