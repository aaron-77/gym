using Bogus;
using DTO.Dtos;

namespace GymWebApp.Tests.Factories;

public static class RutinaFactory
{
    /// <summary>
    /// Crea una Rutina válida para tests
    /// </summary>
    public static DTO.Dtos.Rutina CrearRutinaValida(
        string? usuarioId = null,
        string? entrenadorId = null,
        Action<Faker<DTO.Dtos.Rutina>>? customRules = null)
    {
        var faker = new Faker<DTO.Dtos.Rutina>("es")
            .RuleFor(r => r.RutinaId, _ => null)
            .RuleFor(r => r.UsuarioID, usuarioId ?? Guid.NewGuid().ToString())
            .RuleFor(r => r.EntrenadorID, entrenadorId ?? Guid.NewGuid().ToString())
            .RuleFor(r => r.FechaCreacion, DateTime.Now)
            .RuleFor(r => r.Observaciones, f => f.Lorem.Sentence());
        
        customRules?.Invoke(faker);
        return faker.Generate();
    }

    /// <summary>
    /// Crea una AsignacionDeEjercicio válida para tests
    /// </summary>
    public static DTO.Dtos.AsignacionDeEjercicio CrearAsignacionValida(
        string? usuarioId = null,
        int? rutinaId = null,
        int? ejercicioId = null,
        Action<Faker<DTO.Dtos.AsignacionDeEjercicio>>? customRules = null)
    {
        var faker = new Faker<DTO.Dtos.AsignacionDeEjercicio>("es")
            .RuleFor(a => a.UsuarioID, usuarioId ?? Guid.NewGuid().ToString())
            .RuleFor(a => a.RutinaId, rutinaId ?? 1)
            .RuleFor(a => a.EjercicioID, ejercicioId ?? 1)
            .RuleFor(a => a.Sets, f => f.Random.Int(1, 10))
            .RuleFor(a => a.Repeticiones, f => f.Random.Int(1, 20))
            .RuleFor(a => a.Peso, f => f.Random.Decimal(1, 100))
            .RuleFor(a => a.Tiempo, f => f.Random.Int(0, 60))
            .RuleFor(a => a.MetaRepeticiones, f => f.Random.Int(1, 25));
        
        customRules?.Invoke(faker);
        return faker.Generate();
    }

    /// <summary>
    /// Crea AsignacionDeEjercicio con valores inválidos específicos
    /// </summary>
    public static AsignacionDeEjercicio CrearAsignacionInvalida(
        string? usuarioId = null,        // null = inválido
        int? rutinaId = null,           // null/0/-1 = inválido
        int? ejercicioId = null,         // null/0 = inválido
        int? sets = null,                // null/0/-1 = inválido
        int? repeticiones = null)        // null/-1 = inválido
    {
        var faker = new Faker<AsignacionDeEjercicio>("es")
            .RuleFor(a => a.UsuarioID, _ => usuarioId)
            .RuleFor(a => a.RutinaId, _ => rutinaId ?? 0)
            .RuleFor(a => a.EjercicioID, _ => ejercicioId ?? 0)
            .RuleFor(a => a.Sets, _ => sets ?? 0)
            .RuleFor(a => a.Repeticiones, _ => repeticiones ?? -1)
            .RuleFor(a => a.Peso, 20.5m)
            .RuleFor(a => a.Tiempo, 0)
            .RuleFor(a => a.MetaRepeticiones, 12);
        return faker.Generate();
    }

    /// <summary>
    /// Crea Rutina con valores inválidos específicos
    /// </summary>
    public static Rutina CrearRutinaInvalida(
        string? usuarioId = null,        // null = inválido
        string? entrenadorId = null,    // null = inválido
        DateTime? fechaCreacion = null, // null/default = inválido
        string? observaciones = null)   // null = inválido
    {
        var faker = new Faker<Rutina>("es")
            .RuleFor(r => r.RutinaId, _ => (int?)null)
            .RuleFor(r => r.UsuarioID, _ => usuarioId)
            .RuleFor(r => r.EntrenadorID, _ => entrenadorId)
            .RuleFor(r => r.FechaCreacion, _ => fechaCreacion ?? default(DateTime))
            .RuleFor(r => r.Observaciones, _ => observaciones);
        return faker.Generate();
    }
}
