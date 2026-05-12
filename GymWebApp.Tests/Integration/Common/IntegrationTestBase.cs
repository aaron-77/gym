using System.Net.Http;
using System.Net.Http.Headers;
using Microsoft.AspNetCore.Mvc.Testing;
using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Common;

public abstract class IntegrationTestBase : IClassFixture<CitasApiWebApplicationFactory<Program>>, IAsyncLifetime
{
    protected readonly CitasApiWebApplicationFactory<Program> Factory;
    protected readonly HttpClient Client;
    protected readonly TestContainerHelper TestContainerHelper;
    protected string? _empleadoToken;
    protected string? _clienteToken;

    protected IntegrationTestBase(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper)
    {
        Factory = factory;
        TestContainerHelper = testContainerHelper;
        Client = factory.CreateClient();
    }

    public virtual async Task InitializeAsync()
    {
        // Reset database before each test - TestContainerHelper is already initialized by ICollectionFixture
        await TestContainerHelper.ResetDatabaseAsync();
    }

    public virtual Task DisposeAsync()
    {
        return Task.CompletedTask;
    }

    protected async Task SetAuthHeaderAsync()
    {
        if (string.IsNullOrEmpty(_empleadoToken))
        {
            _empleadoToken = await Factory.AuthenticateAsync(Client);
        }
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _empleadoToken);
    }

    protected async Task SetAuthHeaderAsClienteAsync()
    {
        if (string.IsNullOrEmpty(_clienteToken))
        {
            _clienteToken = await Factory.AuthenticateAsClienteAsync(Client);
        }
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _clienteToken);
    }

    protected void ClearAuthHeader()
    {
        Client.DefaultRequestHeaders.Authorization = null;
    }

    protected void SetAuthHeader(string token)
    {
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
    }
}