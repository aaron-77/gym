using FluentAssertions;
using Microsoft.AspNetCore.Http;
using NSubstitute;
using Xunit;

namespace GymWebApp.Tests.Unit.Seguridad;

public class CookieServiceTests
{
    [Fact]
    public void AgregarCookie_WhenRequestIsHttps_SetsSecureFlag()
    {
        var accessor = Substitute.For<IHttpContextAccessor>();
        var context = new DefaultHttpContext();
        context.Request.IsHttps = true;
        accessor.HttpContext.Returns(context);

        var service = new CookieService(accessor);
        service.AgregarCookie(context.Response, "AuthToken", "value");

        context.Response.Headers["Set-Cookie"].ToString()
            .Should().ContainEquivalentOf("secure");
    }

    [Fact]
    public void AgregarCookie_WhenRequestIsHttp_DoesNotSetSecureFlag()
    {
        var accessor = Substitute.For<IHttpContextAccessor>();
        var context = new DefaultHttpContext();
        context.Request.IsHttps = false;
        accessor.HttpContext.Returns(context);

        var service = new CookieService(accessor);
        service.AgregarCookie(context.Response, "AuthToken", "value");

        context.Response.Headers["Set-Cookie"].ToString().Should().NotContain("Secure");
    }
}
