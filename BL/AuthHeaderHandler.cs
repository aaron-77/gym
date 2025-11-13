using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
namespace BL;
    
public class AuthHeaderHandler : DelegatingHandler
{
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IConfiguration _configuration;

    public AuthHeaderHandler(IHttpContextAccessor httpContextAccessor, IConfiguration configuration)
    {
        _httpContextAccessor = httpContextAccessor;
        _configuration = configuration;
    }

    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
    {
        var backendAddress = Environment.GetEnvironmentVariable("BACKEND_BASE_ADDRESS");
        var frontendAddress = Environment.GetEnvironmentVariable("ASPNETCORE_URLS");

        var accessToken = _httpContextAccessor.HttpContext?.Request.Cookies["AccessToken"];
        var idToken = _httpContextAccessor.HttpContext?.Request.Cookies["AuthToken"];
        bool isApiRequest = request.RequestUri.ToString().Contains(backendAddress, StringComparison.OrdinalIgnoreCase);
        bool isFrontendRequest = request.RequestUri.ToString().Contains(frontendAddress, StringComparison.OrdinalIgnoreCase);
        if (!string.IsNullOrEmpty(accessToken) && isApiRequest)
        {

            request.Headers.Authorization =
                new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken);
        }

        if (!string.IsNullOrEmpty(idToken) && isFrontendRequest)
        {

            request.Headers.Authorization =
                new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", idToken);
        }
        Console.WriteLine($"[HTTP REQUEST] {request.Method} {request.RequestUri}");
        foreach (var header in request.Headers)
        {
            Console.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
        }

        return await base.SendAsync(request, cancellationToken);
    }
}
