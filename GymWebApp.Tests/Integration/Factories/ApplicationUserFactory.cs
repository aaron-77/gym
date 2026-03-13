using Bogus;
using DataAccess.Identity;

namespace GymWebApp.Tests.Common;

public static class ApplicationUserFactory
{
    private static readonly string[] _estados = { "activo", "inactivo", "suspendido" };

    public static ApplicationUser Crear(
        string? email = null,
        string? nombreCompleto = null,
        string? apellido = null,
        string? numeroDeIdentificacion = null,
        string? direccion = null,
        DateTime? fechaDeNacimiento = null,
        string? estado = null)
    {
        return new Faker<ApplicationUser>("es")
            .RuleFor(u => u.Id, _ => Guid.NewGuid().ToString())
            .RuleFor(u => u.UserName, (f, u) => email ?? f.Internet.UserName())
            .RuleFor(u => u.Email, (f, u) => email ?? f.Internet.Email(u.UserName))
            .RuleFor(u => u.NormalizedUserName, (f, u) => u.UserName?.ToUpperInvariant())
            .RuleFor(u => u.NormalizedEmail, (f, u) => u.Email?.ToUpperInvariant())
            .RuleFor(u => u.NombreCompleto, (f, u) => nombreCompleto ?? f.Name.FullName())
            .RuleFor(u => u.Apellido, (f, u) => apellido ?? f.Name.LastName())
            .RuleFor(u => u.NumeroDeIdentificacion, (f, u) => numeroDeIdentificacion ?? f.Random.Replace("###########"))
            .RuleFor(u => u.Direccion, (f, u) => direccion ?? f.Address.FullAddress())
            .RuleFor(u => u.FechaDeNacimiento, (f, u) => fechaDeNacimiento ?? f.Date.Past(30, DateTime.Today.AddYears(-18)))
            .RuleFor(u => u.FechaDeRegistro, f => f.Date.Recent(30))
            .RuleFor(u => u.Estado, f => estado ?? f.PickRandom(_estados))
            .RuleFor(u => u.EmailConfirmed, f => f.Random.Bool())
            .RuleFor(u => u.PhoneNumberConfirmed, _ => false)
            .RuleFor(u => u.TwoFactorEnabled, _ => false)
            .RuleFor(u => u.LockoutEnabled, _ => false)
            .RuleFor(u => u.ConcurrencyStamp, _ => Guid.NewGuid().ToString())
            .RuleFor(u => u.SecurityStamp, _ => Guid.NewGuid().ToString())
            .RuleFor(u => u.PasswordHash, _ => "AQAAAAEAACcQAAAAEOXXXXXX==")
            .RuleFor(u => u.PhoneNumber, f => f.Phone.PhoneNumber("+54 9 11 #### ####"))
            .Generate();
    }

    public static IEnumerable<ApplicationUser> CrearVarios(int cantidad)
    {
        return new Faker<ApplicationUser>("es")
            .RuleFor(u => u.Id, _ => Guid.NewGuid().ToString())
            .RuleFor(u => u.UserName, f => f.Internet.UserName())
            .RuleFor(u => u.Email, f => f.Internet.Email())
            .RuleFor(u => u.NormalizedUserName, (f, u) => u.UserName?.ToUpperInvariant())
            .RuleFor(u => u.NormalizedEmail, (f, u) => u.Email?.ToUpperInvariant())
            .RuleFor(u => u.NombreCompleto, f => f.Name.FullName())
            .RuleFor(u => u.Apellido, f => f.Name.LastName())
            .RuleFor(u => u.NumeroDeIdentificacion, f => f.Random.Replace("###########"))
            .RuleFor(u => u.Direccion, f => f.Address.FullAddress())
            .RuleFor(u => u.FechaDeNacimiento, f => f.Date.Past(30, DateTime.Today.AddYears(-18)))
            .RuleFor(u => u.FechaDeRegistro, f => f.Date.Recent(30))
            .RuleFor(u => u.Estado, f => f.PickRandom(_estados))
            .RuleFor(u => u.EmailConfirmed, f => f.Random.Bool())
            .RuleFor(u => u.PhoneNumberConfirmed, _ => false)
            .RuleFor(u => u.TwoFactorEnabled, _ => false)
            .RuleFor(u => u.LockoutEnabled, _ => false)
            .RuleFor(u => u.ConcurrencyStamp, _ => Guid.NewGuid().ToString())
            .RuleFor(u => u.SecurityStamp, _ => Guid.NewGuid().ToString())
            .RuleFor(u => u.PasswordHash, _ => "AQAAAAEAACcQAAAAEOXXXXXX==")
            .RuleFor(u => u.PhoneNumber, f => f.Phone.PhoneNumber("+54 9 11 #### ####"))
            .Generate(cantidad);
    }
}
