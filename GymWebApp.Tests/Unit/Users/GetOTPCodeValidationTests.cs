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

public class GetOTPCodeValidationTests
{
    private readonly UsersController _sut;
    private readonly ILogger<UsersController> _mockLogger;
    private readonly UserManager<ApplicationUser> _mockUserManager;

    public GetOTPCodeValidationTests()
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
    public async Task WhenCorreoDoesNotExist_ReturnsBadRequest()
    {
        // Arrange
        var request = new CanalDeEnvioOTP { correo = "noexiste@test.com", cel = null };
        _sut.ModelState.AddModelError("correo", "El correo no existe");

        // Act
        var result = await _sut.obtenerCodigoOTP(request);

        // Assert - una línea usando 'as' para convertir
        var otpResponse = (result as BadRequestObjectResult)?.Value as HttpResponseGenerateOTP;
        otpResponse.ok.Should().BeFalse();
        otpResponse.errors.Should().NotBeEmpty();
    }

    [Fact]
    public async Task WhenCelularDoesNotExist_ReturnsBadRequest()
    {
        // Arrange
        var request = new CanalDeEnvioOTP { cel = "+549999999999", correo = null };
        _sut.ModelState.AddModelError("cel", "El celular no existe");

        // Act
        var result = await _sut.obtenerCodigoOTP(request);

        // Assert
        var otpResponse = (result as BadRequestObjectResult)?.Value as HttpResponseGenerateOTP;
        otpResponse.ok.Should().BeFalse();
        otpResponse.errors.Should().NotBeEmpty();
    }

    [Fact]
    public async Task WhenBothCorreoAndCelularAreNull_ReturnsBadRequest()
    {
        // Arrange
        var request = new CanalDeEnvioOTP { correo = null, cel = null };
        _sut.ModelState.AddModelError("cel", "Debe proporcionar al menos un canal de envío");
        _sut.ModelState.AddModelError("correo", "Debe proporcionar al menos un canal de envío");

        // Act
        var result = await _sut.obtenerCodigoOTP(request);

        // Assert
        var otpResponse = (result as BadRequestObjectResult)?.Value as HttpResponseGenerateOTP;
        otpResponse.ok.Should().BeFalse();
        otpResponse.errors.Should().NotBeEmpty();
        otpResponse.errors.Count.Should().Be(2);
    }
}