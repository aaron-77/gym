using System.Net.Http;

namespace BL;

public interface IHttpCustomClient
{
    Task<string> post(string endPointUrl, HttpContent body);
    Task<string> put(string endPointUrl, HttpContent body);
    Task<string> get(string endPointUrl);
}