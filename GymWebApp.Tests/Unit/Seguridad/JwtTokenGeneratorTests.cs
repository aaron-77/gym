using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Threading.Tasks;
using BL.Utils;
using DataAccess.Identity;
using DataAccess.Repositories;
using DTO.Dtos;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using NSubstitute;
using Xunit;

namespace GymWebApp.Tests.Unit.Seguridad;

public class JwtTokenGeneratorTests
{
    private readonly JwtSettings _jwtSettings;
    private readonly JwtTokenGenerator _generator;
    private readonly ApplicationUser _user;
    private readonly IList<string> _roles;

    public JwtTokenGeneratorTests()
    {
        Environment.SetEnvironmentVariable(
            "SECRET_TOKEN_KEY",
            "SuperSecretKeyForTestingThatIsLongEnough32Bytes");

        _jwtSettings = new JwtSettings
        {
            Issuer = "test-issuer",
            BackendAudiencie = "backend-aud-http",
            BackendAudienceSsl = "backend-aud-ssl",
            FrontAudiencie = "front-aud-http",
            FrontendAudienceSsl = "front-aud-ssl",
            ExpiryMinutes = 60,
            RefreshTokenExpiryDays = 7,
        };

        var jwtOptions = Options.Create(_jwtSettings);
        var claimsOptions = Options.Create(new ClaimsSettings());
        var accessTokenRepository = Substitute.For<IAccessTokenRepository>();
        var refreshTokenRepository = Substitute.For<IRefreshTokenRepository>();
        var httpContextAccessor = Substitute.For<IHttpContextAccessor>();

        _generator = new JwtTokenGenerator(
            jwtOptions,
            claimsOptions,
            accessTokenRepository,
            refreshTokenRepository,
            httpContextAccessor);

        _user = new ApplicationUser
        {
            Id = "user-1",
            UserName = "testuser",
            Email = "test@example.com",
            NombreCompleto = "Test User",
            Curp = "GARC900101HDFRRN3",
        };

        _roles = new List<string> { "admin" };
    }

    [Fact]
    public async Task GenerateAccessToken_ReturnsTokenWithBackendAudiencie()
    {
        var token = await _generator.GenerateAccessToken(_user, _roles);

        var aud = new JwtSecurityTokenHandler()
            .ReadJwtToken(token)
            .Claims.First(c => c.Type == "aud")
            .Value;

        aud.Should().Be(_jwtSettings.BackendAudiencie);
        aud.Should().NotBe(_jwtSettings.BackendAudienceSsl);
    }

    [Fact]
    public void GenerateIdToken_ReturnsTokenWithFrontAudiencie()
    {
        var token = _generator.GenerateIdToken(_user, _roles);

        var aud = new JwtSecurityTokenHandler()
            .ReadJwtToken(token)
            .Claims.First(c => c.Type == "aud")
            .Value;

        aud.Should().Be(_jwtSettings.FrontAudiencie);
        aud.Should().NotBe(_jwtSettings.FrontendAudienceSsl);
    }

    [Fact]
    public void ValidateAccessToken_AcceptsHttpAudience_ReturnsClaims()
    {
        var userValues = new Dictionary<string, string>
        {
            { "userId", _user.Id },
            { "userName", _user.UserName! },
        };

        var token = _generator.CreateTokenWithConfig(
            TokenType.BackendToken,
            false,
            userValues,
            _roles);
        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

        var claims = _generator.ValidateAccessToken(tokenString);

        claims.Should().NotBeNull();
        claims.Should().NotBeEmpty();
    }

    [Fact]
    public void ValidateAccessToken_RejectsSslAudience_ReturnsNull()
    {
        var userValues = new Dictionary<string, string>
        {
            { "userId", _user.Id },
            { "userName", _user.UserName! },
        };

        var token = _generator.CreateTokenWithConfig(
            TokenType.BackendToken,
            true,
            userValues,
            _roles);
        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

        var claims = _generator.ValidateAccessToken(tokenString);

        claims.Should().BeNull();
    }

    [Fact]
    public void ValidateIdToken_AcceptsHttpAudience_ReturnsClaims()
    {
        var userValues = new Dictionary<string, string>
        {
            { "userId", _user.Id },
            { "userName", _user.UserName! },
            { "email", _user.Email! },
            { "nombreCompleto", _user.NombreCompleto },
            { "curp", _user.Curp },
        };

        var token = _generator.CreateTokenWithConfig(
            TokenType.FrontendToken,
            false,
            userValues,
            _roles);
        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

        var claims = _generator.ValidateIdToken(tokenString);

        claims.Should().NotBeNull();
        claims.Should().NotBeEmpty();
    }

    [Fact]
    public void ValidateIdToken_RejectsSslAudience_ReturnsNull()
    {
        var userValues = new Dictionary<string, string>
        {
            { "userId", _user.Id },
            { "userName", _user.UserName! },
            { "email", _user.Email! },
            { "nombreCompleto", _user.NombreCompleto },
            { "curp", _user.Curp },
        };

        var token = _generator.CreateTokenWithConfig(
            TokenType.FrontendToken,
            true,
            userValues,
            _roles);
        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

        var claims = _generator.ValidateIdToken(tokenString);

        claims.Should().BeNull();
    }

    [Fact]
    public async Task GenerateAccessToken_AudienceIsHttp_EvenWhenAspnetcoreUrlsIsHttps()
    {
        Environment.SetEnvironmentVariable("ASPNETCORE_URLS", "https://localhost:5001");

        var token = await _generator.GenerateAccessToken(_user, _roles);

        Environment.SetEnvironmentVariable("ASPNETCORE_URLS", null);

        var aud = new JwtSecurityTokenHandler()
            .ReadJwtToken(token)
            .Claims.First(c => c.Type == "aud")
            .Value;

        aud.Should().Be(_jwtSettings.BackendAudiencie);
    }
}
