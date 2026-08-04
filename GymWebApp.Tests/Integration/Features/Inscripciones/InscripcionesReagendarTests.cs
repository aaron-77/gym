using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using FluentAssertions;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using BL.Utils.Enums;
using DTO.Dtos;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Inscripciones;

/// <summary>
/// Tests de integración para el endpoint POST api/inscripciones/reagendar
/// (spec 43). Valida happy path, edge cases de validación y autorización.
/// </summary>
[Collection("IntegrationTests")]
public class InscripcionesReagendarTests : IntegrationTestBase
{
    private const string Endpoint = "/api/inscripciones/reagendar";

    public InscripcionesReagendarTests(
        CitasApiWebApplicationFactory<Program> factory,
        TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    #region Happy Path

    /// <summary>
    /// Test 1: Reagendar una inscripción válida (con fecha de hoy y hora futura)
    /// a una clase destino válida (fecha futura con horario disponible).
    /// Debe retornar 200 con payload = true.
    /// </summary>
    [Fact]
    public async Task Reagendar_InscripcionValida_RetornaOk()
    {
        // Arrange — verificar si estamos fuera del horario laboral máximo
        var maxHoraInicio = await InscripcionTestHelper.GetMaxHoraInicioAsync(
            TestContainerHelper.ConnectionString);

        DateOnly? fechaReferencia = null;

        if (DateTime.Now.TimeOfDay >= maxHoraInicio - TimeSpan.FromMinutes(1))
        {
            var slotDisponible = await HorariosHelper.ObtenerUnHorarioDisponible(
                TestContainerHelper.ConnectionString,
                FiltroFecha.Mayor,
                FiltroHora.SinFiltro);

            slotDisponible.Should().NotBeNull(
                "Debe haber al menos un horario disponible en fecha futura como fallback");
            fechaReferencia = slotDisponible!.Value.FechaDisponible;
        }

        // Arrange — generar inscripción con fecha disponible
        var seedResult = await InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(
            TestContainerHelper.ConnectionString, fechaReferencia);

        if (seedResult == null)
        {
            var fallbackDate = await InscripcionTestHelper.SeedFallbackAsync(
                TestContainerHelper.ConnectionString, DateTime.Today.Year);

            fallbackDate.Should().NotBeNull("No se pudo encontrar fecha alternativa para el seed");
            fechaReferencia = fallbackDate!.Value;

            seedResult = await InscripcionTestHelper.SeedFreshInscripcionAndReturnIdAsync(
                TestContainerHelper.ConnectionString, fechaReferencia);
        }

        seedResult.Should().NotBeNull("El seed debería tener una inscripción disponible");
        var (clienteId, idInscripcion) = seedResult!.Value;

        // Crear clase destino válida para el reagendamiento (con fechaReferencia si aplica)
        var idClaseDestino = await InscripcionTestHelper.CreateValidDestinationClassForReagendarAsync(
            TestContainerHelper.ConnectionString, idInscripcion, fechaReferencia);

        idClaseDestino.Should().NotBeNull("No se pudo crear la clase destino para el reagendamiento");

        await SetAuthHeaderAsync();

        var request = new ReagendarInscripcionRequest
        {
            IdInscripcion = idInscripcion,
            IdClaseProgramada = idClaseDestino!.Value,
            IdCliente = clienteId
        };

        // Act
        var response = await Client.PostAsJsonAsync(Endpoint, request);

        // Assert — el endpoint usa Responder(), que mapea HTTP status + DTOResponse.httpCode
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<bool>>();
        result.Should().NotBeNull();
        result!.httpCode.Should().Be(200);
        result.success.Should().BeTrue();
        result.payload.Should().BeTrue();
    }

    #endregion

    #region Edge Cases — Validación de parámetros

    /// <summary>
    /// Test 2: Enviar IdInscripcion = 0.
    /// Debe retornar 400 por validación de [Range(1, int.MaxValue)].
    /// El endpoint responde con DTOResponse<object> via InvalidModelStateResponseFactory.
    /// </summary>
    [Fact]
    public async Task Reagendar_IdInscripcionCero_RetornaBadRequest()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Act — IdInscripcion = 0, fuera del rango [1, int.MaxValue]
        var response = await Client.PostAsJsonAsync(Endpoint,
            new ReagendarInscripcionRequest { IdInscripcion = 0, IdClaseProgramada = 1, IdCliente = "valid-id" });

        // Assert — el endpoint responde SIEMPRE con DTOResponse
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<object>>();
        result.Should().NotBeNull();
        result!.httpCode.Should().Be(400);
        result.success.Should().BeFalse();
        result.errors.Should().Contain(e => e.propiedad == "IdInscripcion" && e.message.Contains("ID de inscripci"));
    }

    /// <summary>
    /// Test 3: Enviar IdClaseProgramada = 0.
    /// Debe retornar 400 por validación de [Range(1, int.MaxValue)].
    /// </summary>
    [Fact]
    public async Task Reagendar_IdClaseProgramadaCero_RetornaBadRequest()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Act — IdClaseProgramada = 0, fuera del rango [1, int.MaxValue]
        var response = await Client.PostAsJsonAsync(Endpoint,
            new ReagendarInscripcionRequest { IdInscripcion = 1, IdClaseProgramada = 0, IdCliente = "valid-id" });

        // Assert — el endpoint responde SIEMPRE con DTOResponse
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<object>>();
        result.Should().NotBeNull();
        result!.httpCode.Should().Be(400);
        result.success.Should().BeFalse();
        result.errors.Should().Contain(e => e.propiedad == "IdClaseProgramada" && e.message.Contains("ID de clase programada"));
    }

    /// <summary>
    /// Test 4: Enviar IdCliente vacío.
    /// Debe retornar 400 por validación de [Required].
    /// </summary>
    [Fact]
    public async Task Reagendar_IdClienteVacio_RetornaBadRequest()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Act — IdCliente = "", falla [Required]
        var response = await Client.PostAsJsonAsync(Endpoint,
            new ReagendarInscripcionRequest { IdInscripcion = 1, IdClaseProgramada = 1, IdCliente = "" });

        // Assert — el endpoint responde SIEMPRE con DTOResponse
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<object>>();
        result.Should().NotBeNull();
        result!.httpCode.Should().Be(400);
        result.success.Should().BeFalse();
        result.errors.Should().Contain(e => e.propiedad == "IdCliente" && e.message.Contains("ID del cliente"));
    }

    /// <summary>
    /// Test 5: Enviar IdInscripcion con ID que no existe en BD.
    /// Debe retornar 404.
    /// </summary>
    [Fact]
    public async Task Reagendar_InscripcionNoExiste_RetornaNotFound()
    {
        // Arrange
        await SetAuthHeaderAsync();

        // Act — ID alto que seguro no existe en BD
        var response = await Client.PostAsJsonAsync(Endpoint,
            new ReagendarInscripcionRequest { IdInscripcion = 999999, IdClaseProgramada = 1, IdCliente = "valid-id" });

        // Assert — el endpoint responde SIEMPRE con DTOResponse
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<bool>>();
        result.Should().NotBeNull();
        result!.httpCode.Should().Be(404);
        result.success.Should().BeFalse();
    }

    #endregion

    #region Edge Cases — Autorización

    /// <summary>
    /// Test 6: Request sin token JWT.
    /// Debe retornar 401 por [Authorize].
    /// </summary>
    [Fact]
    public async Task Reagendar_SinAutenticacion_RetornaUnauthorized()
    {
        // Arrange
        ClearAuthHeader();

        // Act
        var response = await Client.PostAsJsonAsync(Endpoint,
            new ReagendarInscripcionRequest { IdInscripcion = 1, IdClaseProgramada = 1, IdCliente = "valid-id" });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    #endregion
}
