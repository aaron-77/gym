using Bogus;
using DTO.Dtos;

namespace GymWebApp.Tests.Integration.Factories;

public static class AgregarRolFactory
{
    public static DTOAgregarRol Crear(string? userId = null, string? role = null)
    {
        return new Faker<DTOAgregarRol>("es")
            .RuleFor(r => r.UserId, f => userId ?? Guid.NewGuid().ToString())
            .RuleFor(r => r.Role, f => role ?? f.PickRandom(new[] { "cliente", "empleado" }))
            .Generate();
    }
}