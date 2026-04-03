using Bogus;
using DTO.Dtos;

namespace GymWebApp.Tests.Integration.Factories;

public static class MedidaFactory
{
    public static DTOMedida CrearMedida(
        string? fkUsuario = null,
        int? fkParametro = null,
        int? unidadDeMedidaId = null,
        decimal? valor = null)
    {
        return new Faker<DTOMedida>("es")
            .RuleFor(m => m.fkUsuario, f => fkUsuario ?? Guid.NewGuid().ToString())
            .RuleFor(m => m.fkParametro, f => fkParametro ?? f.PickRandom(new[] { 1, 2, 3, 4 }))
            .RuleFor(m => m.unidadDeMedidaId, f => unidadDeMedidaId ?? f.PickRandom(new[] { 1, 2, 3 }))
            .RuleFor(m => m.valor, f => valor ?? f.Random.Decimal(50m, 150m))
            .Generate();
    }

    public static DTOMedida CrearMedidaPeso(string fkUsuario, decimal peso)
    {
        return new DTOMedida
        {
            fkUsuario = fkUsuario,
            fkParametro = 1, // peso
            unidadDeMedidaId = 1, // kg
            valor = peso
        };
    }

    public static DTOMedida CrearMedidaImc(string fkUsuario, decimal imc)
    {
        return new DTOMedida
        {
            fkUsuario = fkUsuario,
            fkParametro = 2, // imc
            unidadDeMedidaId = 2, // kg/m²
            valor = imc
        };
    }

    public static DTOMedida CrearMedidaAltura(string fkUsuario, decimal altura)
    {
        return new DTOMedida
        {
            fkUsuario = fkUsuario,
            fkParametro = 3, // altura
            unidadDeMedidaId = 3, // m
            valor = altura
        };
    }

    public static DTOMedida CrearMedidaFuerza(string fkUsuario, decimal fuerza)
    {
        return new DTOMedida
        {
            fkUsuario = fkUsuario,
            fkParametro = 4, // fuerza
            unidadDeMedidaId = 1, // kg
            valor = fuerza
        };
    }
}