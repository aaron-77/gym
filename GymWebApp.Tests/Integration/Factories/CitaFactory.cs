using Bogus;
using Cita = DTO.Dtos.Cita;

namespace GymWebApp.Tests.Integration.Factories;

public static class CitaFactory
{
    private static readonly string[] _estados = { "Pendiente", "Confirmada", "Cancelada", "Completada" };
    private static readonly string[] _tipos = { "medición", "entrenamiento personal" };

    public static Cita Crear(
        DateTime? fechaInicioCita = null,
        DateTime? fechaFinCita = null,
        string? fkCliente = null,
        string? fkEntrenador = null,
        string? tipoCita = null)
    {
        return new Faker<Cita>("es")
            .RuleFor(c => c.fechaInicioCita, f => fechaInicioCita ?? f.Date.Future().Date.AddHours(10))
            .RuleFor(c => c.fechaFinCita, f => fechaFinCita ?? f.Date.Future().Date.AddHours(11))
            .RuleFor(c => c.fkCliente, _ => fkCliente ?? "")
            .RuleFor(c => c.fkEntrenador, _ => fkEntrenador ?? "")
            .RuleFor(c => c.tipoCita, f => tipoCita ?? f.PickRandom(_tipos))
            .Generate();
    }
}
