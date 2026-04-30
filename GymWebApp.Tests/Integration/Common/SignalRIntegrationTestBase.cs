using System.Net.Http.Headers;
using Microsoft.AspNetCore.SignalR.Client;

namespace GymWebApp.Tests.Integration.Common;

public abstract class SignalRIntegrationTestBase : IntegrationTestBase<CitasApiWebApplicationFactory<Program>>, IAsyncLifetime
{
    protected HubConnection? _hubConnection;

    protected SignalRIntegrationTestBase(CitasApiWebApplicationFactory<Program> factory) : base(factory)
    {
    }

    public override async Task InitializeAsync()
    {
        await base.InitializeAsync();

        var token = await Factory.AuthenticateAsync(Client);
        var hubUrl = $"{Client.BaseAddress}reservacionesHub?access_token={token}";

        _hubConnection = new HubConnectionBuilder()
            .WithUrl(hubUrl)
            .WithStatefulReconnect()
            .Build();

        await _hubConnection.StartAsync();
    }

    public override async Task DisposeAsync()
    {
        if (_hubConnection != null)
        {
            await _hubConnection.StopAsync();
            await _hubConnection.DisposeAsync();
        }

        await base.DisposeAsync();
    }
}