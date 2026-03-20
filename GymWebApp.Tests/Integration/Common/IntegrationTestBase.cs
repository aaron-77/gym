using System.Net.Http.Headers;
using Microsoft.AspNetCore.Mvc.Testing;
using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.Integration.Common;

public abstract class IntegrationTestBase<TFactory> : IClassFixture<TFactory>, IAsyncLifetime
    where TFactory : CitasApiWebApplicationFactory<Program>
{
    protected readonly TFactory Factory;
    protected readonly HttpClient Client;
    protected string? _authToken;

    protected IntegrationTestBase(TFactory factory)
    {
        Factory = factory;
        Client = factory.CreateClient();
    }

    public virtual async Task InitializeAsync()
    {
        // Initialize TestContainer and run migrations
        await TestContainerHelper.InitializeAsync();
        
        // Reset database before each test
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

    protected void ClearAuthHeader()
    {
        Client.DefaultRequestHeaders.Authorization = null;
    }
}
