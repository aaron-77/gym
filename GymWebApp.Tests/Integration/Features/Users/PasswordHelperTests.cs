using DataAccess.Identity;
using FluentAssertions;
using GymWebApp.Tests.Integration.Common;
using GymWebApp.Tests.Integration.Helpers;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

namespace GymWebApp.Tests.Integration.Features.Users;

[Collection("IntegrationTests")]
public class PasswordHelperTests : IntegrationTestBase
{
    public PasswordHelperTests(
        CitasApiWebApplicationFactory<Program> factory,
        TestContainerHelper testContainerHelper)
        : base(factory, testContainerHelper) { }

    [Fact]
    public async Task VerifyPasswordAsync_WithValidClienteCredentials_ReturnsTrue()
    {
        // Resolve UserManager and SignInManager from DI (PasswordHelper requires them in constructor)
        var userManager = Factory.Services.GetRequiredService<UserManager<ApplicationUser>>();
        var signInManager = Factory.Services.GetRequiredService<SignInManager<ApplicationUser>>();
        var passwordHelper = new PasswordHelper(userManager, signInManager);

        // Get credentials from appsettings.Testing.json → TestUserCliente section
        var testUserSection = ConfigHelper.GetSection("TestUser");
        var email = testUserSection["Email"]!;
        var password = testUserSection["Password"]!;

        // Act
        var result = await passwordHelper.VerifyPasswordAsync(email, password);

        // Assert
        result.Should().BeTrue();
    }
}