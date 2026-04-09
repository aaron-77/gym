using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using GymWebApp.Tests.Integration.Common;
using FitnessCenterDbContext = DataAccess.EntityFramework.FitnessCenterDbContext;

namespace GymWebApp.Tests.Integration;

public class RutinasApiWebApplicationFactory<TProgram> : CitasApiWebApplicationFactory<TProgram> where TProgram : class
{
    // Inherits from CitasApiWebApplicationFactory which provides:
    // - AuthenticateAsync(HttpClient) method - gets token for empleado (uno@gmail.com)
    // - AuthenticateAsClienteAsync(HttpClient) method - gets token for cliente (rebeca@gmail.com)
    // - GetAuthToken() method
    // - Connection string configuration
    // - TestContainerHelper integration
}