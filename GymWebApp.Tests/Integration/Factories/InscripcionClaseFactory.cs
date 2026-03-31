using Bogus;
using DataAccess.EntityFramework;

namespace GymWebApp.Tests.Integration.Factories;

public static class InscripcionClaseFactory
{
    public static InscripcionesDeClase Crear(
        int fkProgramacionClase,
        string fkCliente,
        int fkEstadoInscripcion = 1,
        Action<Faker<InscripcionesDeClase>>? customRules = null)
    {
        var faker = new Faker<InscripcionesDeClase>("es")
            .RuleFor(i => i.FkProgramacionClase, _ => fkProgramacionClase)
            .RuleFor(i => i.FkCliente, _ => fkCliente)
            .RuleFor(i => i.FkEstadoInscripcion, _ => fkEstadoInscripcion)
            .RuleFor(i => i.FechaDeInscripcion, f => f.Date.Recent(30));

        customRules?.Invoke(faker);

        return faker.Generate();
    }
}