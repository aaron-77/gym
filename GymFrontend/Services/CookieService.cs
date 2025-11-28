using Microsoft.AspNetCore.Http;
using Newtonsoft.Json.Linq;

public class CookieService
{


    private readonly IHttpContextAccessor _httpContextAccessor;

    public CookieService(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }



    /// <summary>
    /// Agrega una cookie al Response recibido desde el controller.
    /// </summary>
    /// <param name="response">Objeto HttpResponse del controller</param>
    /// <param name="key">Nombre de la cookie</param>
    /// <param name="value">Valor de la cookie</param>
    /// <param name="options">Opciones de configuración de la cookie. Si no se proporciona, se usan valores por defecto.</param>
    public void AgregarCookie(HttpResponse response, string key, string value, CookieOptions? options = null)
    {
        try
        {
            if (response == null) 
                throw new ArgumentNullException(nameof(response));
            if (string.IsNullOrEmpty(key)) 
                throw new ArgumentException("La clave no puede ser nula o vacía", nameof(key));


            var context = _httpContextAccessor.HttpContext
                          ?? throw new InvalidOperationException("No hay contexto HTTP disponible");

            var request = context.Request;
            CookieOptions cookieOptions = options ?? new CookieOptions
            {
                HttpOnly = true,
                Secure = false,
                SameSite = SameSiteMode.Strict,
                Path = "/"
                // No se asigna Expires por defecto
            };
            if (request.IsHttps)
            {
                cookieOptions = new CookieOptions
                {
                    HttpOnly = true,
                    Secure = true,
                    SameSite = SameSiteMode.Strict,
                    Path = "/"
                };
            }
            
           
            response.Cookies.Append(key, value ?? string.Empty, cookieOptions);
        }
        catch (ArgumentNullException ex)
        {
            string logMessage = $"[ERROR] Método: AgregarCookie - ArgumentNullException | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"Parámetro: {ex.ParamName} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            throw;
        }
        catch (ArgumentException ex)
        {
            string logMessage = $"[ERROR] Método: AgregarCookie - ArgumentException | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"ClaveCookie: {key} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            throw;
        }
        catch (InvalidOperationException ex)
        {
            string logMessage = $"[ERROR] Método: AgregarCookie - InvalidOperationException | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"ClaveCookie: {key} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            throw;
        }
        catch (Exception ex)
        {
            string logMessage = $"[ERROR] Método: AgregarCookie - Excepción no prevista | " +
                $"Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | " +
                $"Causa: {ex.GetType().Name} - {ex.Message} | " +
                $"ClaveCookie: {key} | " +
                $"Stack Trace: {ex.StackTrace}";
            Console.WriteLine(logMessage);
            
            throw;
        }
    }
}
