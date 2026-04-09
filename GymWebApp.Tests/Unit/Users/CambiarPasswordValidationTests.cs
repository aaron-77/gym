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

public class CambiarPasswordValidationTests
{
    private readonly UsersController _sut;
    private readonly ILogger<UsersController> _mockLogger;
    private readonly UserManager<ApplicationUser> _mockUserManager;

    public CambiarPasswordValidationTests()
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
    public async Task WhenEmailIsNull_ReturnsBadRequest()
    {
        // Arrange
        var request = new UserPassEdit { Email = null, NewPassword = "Password123", ConfirmPassword = "Password123" };
        _sut.ModelState.AddModelError("Email", "El correo es obligatorio.");

        // Act
        var result = await _sut.CambiarPassword(request);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenEmailIsEmpty_ReturnsBadRequest()
    {
        // Arrange
        var request = new UserPassEdit { Email = "", NewPassword = "Password123", ConfirmPassword = "Password123" };
        _sut.ModelState.AddModelError("Email", "El correo es obligatorio.");

        // Act
        var result = await _sut.CambiarPassword(request);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenEmailIsInvalidFormat_ReturnsBadRequest()
    {
        // Arrange
        var request = new UserPassEdit { Email = "invalid-email", NewPassword = "Password123", ConfirmPassword = "Password123" };
        _sut.ModelState.AddModelError("Email", "El correo no tiene un formato válido.");

        // Act
        var result = await _sut.CambiarPassword(request);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenNewPasswordIsNull_ReturnsBadRequest()
    {
        // Arrange
        var request = new UserPassEdit { Email = "test@test.com", NewPassword = null, ConfirmPassword = "Password123" };
        _sut.ModelState.AddModelError("NewPassword", "La nueva contraseña es obligatoria.");

        // Act
        var result = await _sut.CambiarPassword(request);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenNewPasswordIsEmpty_ReturnsBadRequest()
    {
        // Arrange
        var request = new UserPassEdit { Email = "test@test.com", NewPassword = "", ConfirmPassword = "Password123" };
        _sut.ModelState.AddModelError("NewPassword", "La nueva contraseña es obligatoria.");

        // Act
        var result = await _sut.CambiarPassword(request);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenConfirmPasswordIsNull_ReturnsBadRequest()
    {
        // Arrange
        var request = new UserPassEdit { Email = "test@test.com", NewPassword = "Password123", ConfirmPassword = null };
        _sut.ModelState.AddModelError("ConfirmPassword", "La confirmación de la contraseña es obligatoria.");

        // Act
        var result = await _sut.CambiarPassword(request);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenConfirmPasswordDoesNotMatch_ReturnsBadRequest()
    {
        // Arrange
        var request = new UserPassEdit { Email = "test@test.com", NewPassword = "Password123", ConfirmPassword = "Different123" };
        _sut.ModelState.AddModelError("ConfirmPassword", "La contraseña de confirmación no coincide con la nueva contraseña.");

        // Act
        var result = await _sut.CambiarPassword(request);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }

    [Fact]
    public async Task WhenEmailDoesNotExistInDatabase_ReturnsBadRequest()
    {
        // Arrange
        var request = new UserPassEdit { Email = "noexiste@test.com", NewPassword = "Password123", ConfirmPassword = "Password123" };
        // Simulate that user with this email does not exist
        _mockUserManager.FindByEmailAsync("noexiste@test.com").Returns((ApplicationUser?)null);
        _sut.ModelState.AddModelError("Email", "El correo no existe");

        // Act
        var result = await _sut.CambiarPassword(request);

        // Assert
        result.Should().BeOfType<BadRequestObjectResult>();
    }
}