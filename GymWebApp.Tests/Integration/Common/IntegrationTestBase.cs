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
    protected string? _authToken;

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
        if (string.IsNullOrEmpty(_authToken))
        {
            _authToken = await Factory.AuthenticateAsync(Client);
        }
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _authToken);
    }

    protected async Task SetAuthHeaderAsClienteAsync()
    {
        if (string.IsNullOrEmpty(_authToken))
        {
            _authToken = await Factory.AuthenticateAsClienteAsync(Client);
        }
        Client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _authToken);
    }

    protected void ClearAuthHeader()
    {
        Client.DefaultRequestHeaders.Authorization = null;
    }
}