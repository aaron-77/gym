using System.Net.Http;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using DTO.Dtos;

namespace GymWebApp.Tests.SharedHelpers;

/// <summary>
/// HttpClient helper para realizar requests a la API con soporte para autenticación Bearer.
/// </summary>
public class HttpClientCustom : IDisposable
{
    private readonly HttpClient _httpClient;
    private string _baseAddress;

    public string BaseAddress
    {
        get => _baseAddress;
        set => _baseAddress = value.TrimEnd('/');
    }

    public HttpClientCustom(string baseUrl)
    {
        _baseAddress = baseUrl.TrimEnd('/');
        _httpClient = new HttpClient
        {
            BaseAddress = new Uri(_baseAddress)
        };
    }

    /// <summary>
    /// Establece el token Bearer para autenticación en las próximas requests.
    /// </summary>
    /// <param name="token">Token JWT</param>
    public void SetAuthorizationToken(string token)
    {
        _httpClient.DefaultRequestHeaders.Authorization = 
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
    }

    /// <summary>
    /// Realiza una petición GET y retorna la respuesta como DTOResponse{T}.
    /// </summary>
    public async Task<DTOResponse<T>> GetAsync<T>(string endpoint)
    {
        var response = await _httpClient.GetAsync($"{_baseAddress}/{endpoint.TrimStart('/')}");
        var content = await response.Content.ReadAsStringAsync();
        return JsonSerializer.Deserialize<DTOResponse<T>>(content, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        })!;
    }

    /// <summary>
    /// Realiza una petición POST y retorna la respuesta como DTOResponse{T}.
    /// </summary>
    public async Task<DTOResponse<T>> PostAsync<T>(string endpoint, T data)
    {
        var json = JsonSerializer.Serialize(data);
        var httpContent = new StringContent(json, Encoding.UTF8, "application/json");
        var response = await _httpClient.PostAsync($"{_baseAddress}/{endpoint.TrimStart('/')}", httpContent);
        var content = await response.Content.ReadAsStringAsync();
        return JsonSerializer.Deserialize<DTOResponse<T>>(content, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        })!;
    }

    /// <summary>
    /// Realiza una petición PUT y retorna la respuesta como DTOResponse{T}.
    /// </summary>
    public async Task<DTOResponse<T>> PutAsync<T>(string endpoint, T data)
    {
        var json = JsonSerializer.Serialize(data);
        var httpContent = new StringContent(json, Encoding.UTF8, "application/json");
        var response = await _httpClient.PutAsync($"{_baseAddress}/{endpoint.TrimStart('/')}", httpContent);
        var content = await response.Content.ReadAsStringAsync();
        return JsonSerializer.Deserialize<DTOResponse<T>>(content, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        })!;
    }

    /// <summary>
    /// Realiza una petición DELETE y retorna la respuesta como DTOResponse{T}.
    /// </summary>
    public async Task<DTOResponse<T>> DeleteAsync<T>(string endpoint)
    {
        var response = await _httpClient.DeleteAsync($"{_baseAddress}/{endpoint.TrimStart('/')}");
        var content = await response.Content.ReadAsStringAsync();
        return JsonSerializer.Deserialize<DTOResponse<T>>(content, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        })!;
    }

    public void Dispose()
    {
        _httpClient.Dispose();
    }
}