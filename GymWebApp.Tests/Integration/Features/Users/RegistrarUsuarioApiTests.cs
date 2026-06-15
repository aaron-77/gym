using System.Net;
using System.Net.Http.Json;
using GymWebApp.Tests.Integration.Common;
using DTO.Dtos;
using FluentAssertions;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("IntegrationTests")]
public class RegistrarUsuarioApiTests : IntegrationTestBase
{
    public RegistrarUsuarioApiTests(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper) { }

    #region Happy Paths (HP)

    /// <summary>
    /// HP01: Datos válidos → 200 OK + DTOCreatedUser
    /// </summary>
    [Fact]
    public async Task RegistrarUsuario_WithValidData_Returns200OkAndDTOCreatedUser()
    {
        // Arrange
        var registerRequest = new NewUser(
            nombre: "John",
            fechaDeNacimiento: new DateTime(1990, 1, 1),
            direccion: "Calle Falsa 123",
            curp: "ABCD123456HMBCDN09",
            correo: $"john.doe.{Guid.NewGuid():N}@test.com",
            telefono: "+1234567890",
            apellido: "Doe",
            contrasena: "Password123!",
            rol: "cliente",
            estado: "activo"
        );

        // Act
        var response = await Client.PostAsJsonAsync("/api/RegistrarUsuario", registerRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<DTOCreatedUser>>();
        result.Should().NotBeNull();
        result!.success.Should().BeTrue();
        result.httpCode.Should().Be(200);
        result.payload.Should().NotBeNull();
        result.payload!.Id.Should().NotBeEmpty();
        result.payload.NombreCompleto.Should().Be("John");
        result.payload.Apellido.Should().Be("Doe");
        result.payload.Correo.Should().Be(registerRequest.Correo);
    }

    #endregion

    #region Sad Paths (SP)

    /// <summary>
    /// SP01: Email duplicado → 500 Internal Server Error
    /// </summary>
    [Fact]
    public async Task RegistrarUsuario_WithDuplicateEmail_Returns500InternalServerError()
    {
        // Arrange
        // Create the object ONCE with unique email
        var duplicateEmail = $"duplicate.{Guid.NewGuid():N}@test.com";
        var registerRequest = new NewUser(
            nombre: "John",
            fechaDeNacimiento: new DateTime(1990, 1, 1),
            direccion: "Calle Falsa 123",
            curp: "ABCD123456HMBCDN09",
            correo: duplicateEmail,
            telefono: "+1234567890",
            apellido: "Doe",
            contrasena: "Password123!",
            rol: "cliente",
            estado: "activo"
        );

        // First registration should succeed - same instance
        await Client.PostAsJsonAsync("/api/RegistrarUsuario", registerRequest);

        // Act - same instance second time
        var response = await Client.PostAsJsonAsync("/api/RegistrarUsuario", registerRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.InternalServerError);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<DTOCreatedUser>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
        
        // Verificar que el mensaje indica email duplicado
        result.message.Should().Match(m => m.Contains("email", StringComparison.OrdinalIgnoreCase) 
            || m.Contains("correo", StringComparison.OrdinalIgnoreCase) 
            || m.Contains("registrado", StringComparison.OrdinalIgnoreCase));
        result.errors.Should().NotBeEmpty();
        // Verificar que el error menciona que ya existe
        result.errors.First().message.Should().Match(m => m.Contains("registrado", StringComparison.OrdinalIgnoreCase) 
            || m.Contains("existe", StringComparison.OrdinalIgnoreCase) 
            || m.Contains("email", StringComparison.OrdinalIgnoreCase));
    }

    /// <summary>
    /// SP02: Datos inválidos → 400 Bad Request
    /// </summary>
    [Fact]
    public async Task RegistrarUsuario_WithInvalidData_Returns400BadRequest()
    {
        // Arrange
        var registerRequest = new NewUser(
            nombre: "",  // Invalid - empty
            fechaDeNacimiento: new DateTime(1990, 1, 1),
            direccion: "Calle Falsa 123",
            curp: "ABCD123456HMBCDN09",
            correo: "not-an-email",  // Invalid email format
            telefono: "+1234567890",
            apellido: "",
            contrasena: "short",  // Too short
            rol: "cliente",
            estado: "activo"
        );

        // Act
        var response = await Client.PostAsJsonAsync("/api/RegistrarUsuario", registerRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        
        var result = await response.Content.ReadFromJsonAsync<DTOResponse<DTOCreatedUser>>();
        result.Should().NotBeNull();
        result!.success.Should().BeFalse();
    }

    #endregion
}
