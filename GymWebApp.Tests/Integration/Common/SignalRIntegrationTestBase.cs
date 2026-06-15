using System.Net.Http;
using System.Net.Http.Headers;
using Microsoft.AspNetCore.SignalR.Client;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System.Diagnostics;

namespace GymWebApp.Tests.Integration.Common;

/// <summary>
/// Base class for SignalR Hub integration tests.
/// Uses StartConnectionAsync approach with HttpMessageHandler for manual Hub connection setup.
/// </summary>
/// <remarks>
/// Note: IAsyncLifetime is already implemented by IntegrationTestBase, so it's not implemented here.
/// Each test class must implement GetHubName() to specify which hub to connect to.
/// </remarks>
public abstract class SignalRIntegrationTestBase : IntegrationTestBase
{
    protected HubConnection? _hubConnection;
    private readonly ILogger<SignalRIntegrationTestBase> _logger;

    protected SignalRIntegrationTestBase(CitasApiWebApplicationFactory<Program> factory, TestContainerHelper testContainerHelper) 
        : base(factory, testContainerHelper)
    {
        _logger = factory.Services.GetRequiredService<ILogger<SignalRIntegrationTestBase>>();
    }

    /// <summary>
    /// Creates a HubConnection using the HttpMessageHandler approach.
    /// Uses StartConnectionAsync for manual HttpMessageHandler setup.
    /// </summary>
    /// <param name="handler">The HttpMessageHandler from the test server.</param>
    /// <param name="hubName">The name of the hub (e.g., "reservaciones").</param>
    /// <returns>A started HubConnection.</returns>
    private async Task<HubConnection> StartConnectionAsync(HttpMessageHandler handler, string hubName)
    {
        try
        {
            var hubConnection = new HubConnectionBuilder()
                .WithUrl($"ws://localhost/{hubName}", o =>
                {
                    o.HttpMessageHandlerFactory = _ => handler;
                })
                .Build();

            await hubConnection.StartAsync();
            return hubConnection;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex,
                "[ERROR] Método: StartConnectionAsync | Línea: {LineNumber} | Causa: {Cause} - {Message}",
                GetLineNumber(ex),
                ex.InnerException?.GetType().Name ?? "NONE",
                ex.Message);
            throw;
        }
    }

    public override async Task InitializeAsync()
    {
        try
        {
            await base.InitializeAsync();

            // CRITICAL: CreateClient must be called before accessing Server property
            Factory.CreateClient();
            var server = Factory.Server;
            var handler = server.CreateHandler();

            _hubConnection = await StartConnectionAsync(handler, GetHubName());

            // Closed handler with reconnection logic
            _hubConnection.Closed += async error =>
            {
                await Task.Delay(new Random().Next(0, 5) * 1000);
                await _hubConnection.StartAsync();
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex,
                "[ERROR] Método: InitializeAsync | Línea: {LineNumber} | Causa: {Cause} - {Message}",
                GetLineNumber(ex),
                ex.InnerException?.GetType().Name ?? "NONE",
                ex.Message);
            throw;
        }
    }

    /// <summary>
    /// Returns the name of the SignalR hub to connect to.
    /// Each test class must implement this to specify its hub (e.g., "reservaciones", "clases").
    /// </summary>
    /// <returns>The hub name without prefix (e.g., "reservaciones").</returns>
    protected abstract string GetHubName();

    public override async Task DisposeAsync()
    {
        try
        {
            if (_hubConnection != null)
            {
                await _hubConnection.StopAsync();
                await _hubConnection.DisposeAsync();
            }

            await base.DisposeAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex,
                "[ERROR] Método: DisposeAsync | Línea: {LineNumber} | Causa: {Cause} - {Message}",
                GetLineNumber(ex),
                ex.InnerException?.GetType().Name ?? "NONE",
                ex.Message);
            throw;
        }
    }

    private static int GetLineNumber(Exception ex)
    {
        var stackTrace = new StackTrace(ex, true);
        var frame = stackTrace.GetFrame(0);
        return frame?.GetFileLineNumber() ?? 0;
    }
}