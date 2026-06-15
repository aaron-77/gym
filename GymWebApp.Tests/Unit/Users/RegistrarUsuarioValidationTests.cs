using API.Controllers;
using API.Services;
using DataAccess.EntityFramework;
using DataAccess.Identity;
using DTO.Dtos;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using NSubstitute;
using Xunit;

namespace GymWebApp.Tests.Unit.Users;

public class RegistrarUsuarioValidationTests
{
    private readonly UsersController _sut;
    private readonly ILogger<UsersController> _mockLogger;
    private readonly UserManager<ApplicationUser> _mockUserManager;

    public RegistrarUsuarioValidationTests()
    {
        // Create mocks following the project's pattern
        var mockUserStore = Substitute.For<IUserStore<ApplicationUser>>();
        _mockUserManager = Substitute.For<UserManager<ApplicationUser>>(
            mockUserStore,
            null!, null!, null!, null!, null!, null!, null!, null!);
        
        // JwtTokenGenerator requires all dependencies in constructor
        // We use a minimal mock setup that doesn't crash on construction
        var mockJwtOptions = Substitute.For<Microsoft.Extensions.Options.IOptions<JwtSettings>>();
        mockJwtOptions.Value.Returns(new JwtSettings { ExpiryMinutes = 60, RefreshTokenExpiryDays = 7 });
        
        var mockJwtTokenGenerator = Substitute.For<BL.Utils.JwtTokenGenerator>(
            mockJwtOptions,
            Substitute.For<Microsoft.Extensions.Options.IOptions<ClaimsSettings>>(),
            null!, null!, null!);
        
        // SignInManager requires many dependencies - create proper mock
        var mockHttpContextAccessor = Substitute.For<IHttpContextAccessor>();
        var mockUserClaimsPrincipalFactory = Substitute.For<IUserClaimsPrincipalFactory<ApplicationUser>>();
        var mockSignInManager = Substitute.For<SignInManager<ApplicationUser>>(
            _mockUserManager,
            mockHttpContextAccessor,
            mockUserClaimsPrincipalFactory,
            null!, null!, null!, null!);
        
        var mockDbContext = Substitute.For<FitnessCenterDbContext>();
        
        // For unit testing validation, we don't need actual service implementations
        // The validation logic happens in the controller before services are called
        // We'll create minimal mocks that won't crash on construction
        
        // Create a mock RoleManager with minimal setup
        var mockRoleManager = Substitute.For<RoleManager<IdentityRole>>(
            Substitute.For<IRoleStore<IdentityRole>>(),
            Substitute.For<IEnumerable<IRoleValidator<IdentityRole>>>(),
            Substitute.For<ILookupNormalizer>(),
            Substitute.For<IdentityErrorDescriber>(),
            Substitute.For<ILogger<RoleManager<IdentityRole>>>()
        );
        
        var mockAuthService = new API.Services.AuthService(
            _mockUserManager, 
            mockSignInManager,
            mockJwtTokenGenerator,
            mockRoleManager,
            Substitute.For<IHttpContextAccessor>(),
            new API.Services.TokensService(null!, null!),
            Substitute.For<Microsoft.Extensions.Options.IOptions<JwtSettings>>(),
            mockDbContext,
            Substitute.For<ILogger<API.Services.AuthService>>());
        
        _mockLogger = Substitute.For<ILogger<UsersController>>();

        var mockJwtOptionsForController = Substitute.For<Microsoft.Extensions.Options.IOptions<JwtSettings>>();

        _sut = new UsersController(
            mockSignInManager,
            _mockUserManager,
            mockJwtTokenGenerator,
            mockAuthService,
            mockJwtOptionsForController,
            mockDbContext,
            _mockLogger
        );
    }

    [Fact]
    public async Task WhenNombreIsNull_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: null!,
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: "Calle 123",
            curp: "ABCD123456HMBCDN09",
            correo: "test@test.com",
            telefono: "1234567890",
            apellido: "Test",
            contrasena: "Password123"
        );
        _sut.ModelState.AddModelError("Nombre", "Ingresa tu nombre");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenNombreIsEmpty_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "",
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: "Calle 123",
            curp: "ABCD123456HMBCDN09",
            correo: "test@test.com",
            telefono: "1234567890",
            apellido: "Test",
            contrasena: "Password123"
        );
        _sut.ModelState.AddModelError("Nombre", "Ingresa tu nombre");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenApellidoIsNull_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "Juan",
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: "Calle 123",
            curp: "ABCD123456HMBCDN09",
            correo: "test@test.com",
            telefono: "1234567890",
            apellido: null!,
            contrasena: "Password123"
        );
        _sut.ModelState.AddModelError("Apellido", "Ingresa tu apellido");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenApellidoIsEmpty_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "Juan",
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: "Calle 123",
            curp: "ABCD123456HMBCDN09",
            correo: "test@test.com",
            telefono: "1234567890",
            apellido: "",
            contrasena: "Password123"
        );
        _sut.ModelState.AddModelError("Apellido", "Ingresa tu apellido");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenFechaDeNacimientoIsDefault_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "Juan",
            fechaDeNacimiento: default,
            direccion: "Calle 123",
            curp: "ABCD123456HMBCDN09",
            correo: "test@test.com",
            telefono: "1234567890",
            apellido: "Perez",
            contrasena: "Password123"
        );
        _sut.ModelState.AddModelError("FechaDeNacimiento", "Ingresa tu fecha de nacimiento");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenDireccionIsNull_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "Juan",
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: null!,
            curp: "ABCD123456HMBCDN09",
            correo: "test@test.com",
            telefono: "1234567890",
            apellido: "Perez",
            contrasena: "Password123"
        );
        _sut.ModelState.AddModelError("Direccion", "Ingresa tu direccion");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenCurpIsNull_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "Juan",
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: "Calle 123",
            curp: null!,
            correo: "test@test.com",
            telefono: "1234567890",
            apellido: "Perez",
            contrasena: "Password123"
        );
        _sut.ModelState.AddModelError("Curp", "Ingresa tu CURP");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenCorreoIsNull_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "Juan",
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: "Calle 123",
            curp: "ABCD123456HMBCDN09",
            correo: null!,
            telefono: "1234567890",
            apellido: "Perez",
            contrasena: "Password123"
        );
        _sut.ModelState.AddModelError("Correo", "Ingresa tu correo");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenCorreoIsInvalidFormat_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "Juan",
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: "Calle 123",
            curp: "ABCD123456HMBCDN09",
            correo: "invalid-email",
            telefono: "1234567890",
            apellido: "Perez",
            contrasena: "Password123"
        );
        _sut.ModelState.AddModelError("Correo", "Correo no válido");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenTelefonoIsNull_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "Juan",
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: "Calle 123",
            curp: "ABCD123456HMBCDN09",
            correo: "test@test.com",
            telefono: null!,
            apellido: "Perez",
            contrasena: "Password123"
        );
        _sut.ModelState.AddModelError("Telefono", "Ingresa tu telefono");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenContrasenaIsNull_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "Juan",
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: "Calle 123",
            curp: "ABCD123456HMBCDN09",
            correo: "test@test.com",
            telefono: "1234567890",
            apellido: "Perez",
            contrasena: null!
        );
        _sut.ModelState.AddModelError("Contrasena", "Ingresa tu contraseña");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenRolIsNull_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "Juan",
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: "Calle 123",
            curp: "ABCD123456HMBCDN09",
            correo: "test@test.com",
            telefono: "1234567890",
            apellido: "Perez",
            contrasena: "Password123",
            rol: null!
        );
        _sut.ModelState.AddModelError("Rol", "Ingresa el rol para el usuario");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenEstadoIsNull_ReturnsBadRequest()
    {
        // Arrange
        var usuario = new NewUser(
            nombre: "Juan",
            fechaDeNacimiento: DateTime.Now.AddYears(-20),
            direccion: "Calle 123",
            curp: "ABCD123456HMBCDN09",
            correo: "test@test.com",
            telefono: "1234567890",
            apellido: "Perez",
            contrasena: "Password123",
            rol: "cliente",
            estado: null!
        );
        _sut.ModelState.AddModelError("Estado", "El usuario requiere un estado");

        // Act
        var result = await _sut.RegistrarUsuario(usuario);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }
}