using BL;

namespace GymWebApp.Tests.Integration.Helpers;

/// <summary>
/// Fake de IHttpCustomClient que simula un error de conexión con la API.
/// Lanza HttpRequestException en cualquier llamada para que el controller
/// entre al bloque catch y muestre el mensaje de error en la vista.
/// </summary>
public class ApiErrorSimulatorClient : IHttpCustomClient
{
    public Task<string> get(string endPointUrl)
        => throw new HttpRequestException("Simulated API connection error");

    public Task<string> post(string endPointUrl, HttpContent body)
        => throw new HttpRequestException("Simulated API connection error");

    public Task<string> put(string endPointUrl, HttpContent body)
        => throw new HttpRequestException("Simulated API connection error");
}
