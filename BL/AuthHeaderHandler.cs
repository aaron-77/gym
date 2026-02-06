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
        try
        {
            var backendAddress = _configuration["EndPoints:api:nossl"]; //Environment.GetEnvironmentVariable("BACKEND_BASE_ADDRESS");
            var frontendAddress = _configuration["EndPoints:api:frontend"];//Environment.GetEnvironmentVariable("ASPNETCORE_URLS");

            var accessToken = _httpContextAccessor.HttpContext?.Request.Cookies["AccessToken"];
            var idToken = _httpContextAccessor.HttpContext?.Request.Cookies["AuthToken"];
            bool isApiRequest = request.RequestUri.ToString().Contains(backendAddress, StringComparison.OrdinalIgnoreCase);
            bool isFrontendRequest = request.RequestUri.ToString().Contains(frontendAddress, StringComparison.OrdinalIgnoreCase);
            string logMessage = $"\n\nREUQEST URL: {request.RequestUri.ToString()}\n IDTOKEN: {idToken}\n ACCESSTOKEN: {accessToken}\n isApiRequest: {isApiRequest}\n isFrontnedRequest: {isFrontendRequest} \n\n";                
            Console.WriteLine(logMessage);

            if (!string.IsNullOrEmpty(accessToken) && isApiRequest)
            {
                logMessage= $"\n\nACCESS TOKEN ADDED: {accessToken}\n\n";
                Console.WriteLine(logMessage);

                request.Headers.Authorization =
                    new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken);
            }

            if (!string.IsNullOrEmpty(idToken) && isFrontendRequest)
            {
                logMessage= $"\n\nID TOKEN ADDED: {accessToken}\n\n";
                Console.WriteLine(logMessage);
                request.Headers.Authorization =
                    new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", idToken);
            }
            Console.WriteLine($"[HTTP REQUEST] {request.Method} {request.RequestUri}");
            logMessage= $"\n\nHEADERS ADDED TO REQUEST: {accessToken}\n\n";
            Console.WriteLine(logMessage);
            foreach (var header in request.Headers)
            {
                    
                Console.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
            }

            return await base.SendAsync(request, cancellationToken);
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] M�todo: SendAsync (AuthHeaderHandler) | " +
                $"L�nea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"RequestUri: {request?.RequestUri} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            // Re-throw the exception to allow normal error handling
            throw;
        }
    }
}
