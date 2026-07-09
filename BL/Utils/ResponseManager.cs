using DTO.Dtos;

namespace BL.Utils;

public static class ResponseManager
{
    /// <summary>
    /// Construye una respuesta con todos los parámetros explícitos.
    /// Se mantiene para compatibilidad con código existente.
    /// </summary>
    public static DTOResponse<T> BuildResponse<T>(
        bool success,
        int httpCode,
        string message,
        List<ErrorModel>? errors,
        T payload)
    {
        try
        {
            return new DTOResponse<T>
            {
                success = success,
                httpCode = httpCode,
                message = message,
                errors = errors ?? new List<ErrorModel>(),
                payload = payload
            };
        }
        catch (System.Exception ex)
        {
            string logMessage = $"[ERROR] Método: BuildResponse | Línea: {new System.Diagnostics.StackTrace(ex, true).GetFrame(0)?.GetFileLineNumber()} | Causa: {ex.GetType().Name} - {ex.Message} | Stack Trace: {ex.StackTrace}";
            System.Console.WriteLine(logMessage);
            throw;
        }
    }

    // ──────────────────────────────
    //  Success (2xx)
    // ──────────────────────────────

    /// <summary>
    /// 200 OK — Respuesta exitosa con payload.
    /// </summary>
    public static DTOResponse<T> Ok<T>(string message, T payload)
        => BuildResponse(true, 200, message, null, payload);

    /// <summary>
    /// 201 Created — Recurso creado exitosamente.
    /// </summary>
    public static DTOResponse<T> Created<T>(string message, T payload)
        => BuildResponse(true, 201, message, null, payload);

    // ──────────────────────────────
    //  Client Errors (4xx)
    // ──────────────────────────────

    /// <summary>
    /// 400 Bad Request — Error de validación del lado del cliente.
    /// Los errores se pasan como strings con formato "propiedad|mensaje"
    /// o simplemente "mensaje" cuando no hay una propiedad específica.
    /// </summary>
    public static DTOResponse<T> BadRequest<T>(string message, params string[] errores)
        => BuildResponse<T>(false, 400, message, ConstruirErrores(errores), default!);

    /// <summary>
    /// 404 Not Found — Recurso no encontrado.
    /// </summary>
    public static DTOResponse<T> NotFound<T>(string message, params string[] errores)
        => BuildResponse<T>(false, 404, message, ConstruirErrores(errores), default!);

    // ──────────────────────────────
    //  Server Errors (5xx)
    // ──────────────────────────────

    /// <summary>
    /// 500 Internal Server Error — Error inesperado del servidor.
    /// </summary>
    public static DTOResponse<T> InternalServerError<T>(string message, params string[] errores)
        => BuildResponse<T>(false, 500, message, ConstruirErrores(errores), default!);

    /// <summary>
    /// 500 Internal Server Error — A partir de una excepción.
    /// Extrae automáticamente el mensaje de la excepción como error.
    /// </summary>
    public static DTOResponse<T> InternalServerError<T>(Exception ex, string message)
        => BuildResponse<T>(false, 500, message, ConstruirErrores(ex), default!);

    // ──────────────────────────────
    //  Internal Helpers
    // ──────────────────────────────

    /// <summary>
    /// Construye la lista de ErrorModel a partir de strings.
    /// Formato: "propiedad|mensaje" o solo "mensaje".
    /// </summary>
    private static List<ErrorModel> ConstruirErrores(params string[] errores)
    {
        if (errores is null || errores.Length == 0)
            return new List<ErrorModel>();

        return errores.Select(e =>
        {
            var separador = e.IndexOf('|');

            if (separador > 0)
            {
                return new ErrorModel
                {
                    propiedad = e[..separador],
                    message = e[(separador + 1)..]
                };
            }

            return new ErrorModel { propiedad = null, message = e };
        }).ToList();
    }

    /// <summary>
    /// Construye la lista de ErrorModel a partir de una excepción.
    /// Usa el mensaje de la excepción como error.
    /// </summary>
    private static List<ErrorModel> ConstruirErrores(Exception ex)
    {
        return new List<ErrorModel>
        {
            new() { propiedad = null, message = ex.Message }
        };
    }
}
