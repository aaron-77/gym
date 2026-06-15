using Bogus;
using DTO.Dtos;

namespace GymWebApp.Tests.Integration.Factories;

public static class ReagendacionInscripcionFactory
{
    public static DTOReagendacionDeInscripcion Crear(
        int? idInscripcionCancelada = null,
        int? idClaseProgramadaNueva = null,
        string? idCliente = null)
    {
        var faker = new Faker("es");

        return new DTOReagendacionDeInscripcion
        {
            idInscripcionCancelada = idInscripcionCancelada ?? faker.Random.Int(1, 100),
            idClaseProgramadaNueva = idClaseProgramadaNueva ?? faker.Random.Int(1, 100),
            idCliente = idCliente ?? Guid.NewGuid().ToString()
        };
    }
}