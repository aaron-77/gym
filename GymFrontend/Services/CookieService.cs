using Microsoft.AspNetCore.Http;

public class CookieService
{
    /// <summary>
    /// Agrega una cookie al Response recibido desde el controller.
    /// </summary>
    /// <param name="response">Objeto HttpResponse del controller</param>
    /// <param name="key">Nombre de la cookie</param>
    /// <param name="value">Valor de la cookie</param>
    /// <param name="options">Opciones de configuración de la cookie. Si no se proporciona, se usan valores por defecto.</param>
    public void AgregarCookie(HttpResponse response, string key, string value, CookieOptions? options = null)
    {
        if (response == null) 
            throw new ArgumentNullException(nameof(response));
        if (string.IsNullOrEmpty(key)) 
            throw new ArgumentException("La clave no puede ser nula o vacía", nameof(key));

        // Valores por defecto si no se pasan opciones
        var cookieOptions = options ?? new CookieOptions
        {
            HttpOnly = true,
            Secure = false,
            SameSite = SameSiteMode.Strict
            // No se asigna Expires por defecto
        };

        response.Cookies.Append(key, value ?? string.Empty, cookieOptions);
    }
}
