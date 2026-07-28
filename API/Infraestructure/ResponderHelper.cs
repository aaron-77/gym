using Microsoft.AspNetCore.Mvc;

using DTO.Dtos;

namespace API.Infraestructure;

/// <summary>
/// Helper que convierte un <see cref="DTOResponse{T}"/> en el <see cref="IActionResult"/>
/// correspondiente según su código HTTP, manteniendo sincronizados el status code
/// de la respuesta HTTP con el httpCode del DTO.
/// </summary>
public static class ResponderHelper
{
    /// <summary>
    /// Convierte un DTOResponse&lt;T&gt; en el IActionResult correspondiente
    /// según su httpCode.
    /// </summary>
    public static IActionResult Responder<T>(this ControllerBase controller, DTOResponse<T> response)
    {
        return response.httpCode switch
        {
            200 => controller.Ok(response),
            201 => controller.Created(string.Empty, response),
            400 => controller.BadRequest(response),
            404 => controller.NotFound(response),
            _ => controller.StatusCode(response.httpCode, response)
        };
    }
}
