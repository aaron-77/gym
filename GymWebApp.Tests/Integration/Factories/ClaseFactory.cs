using Bogus;
using DataAccess.EntityFramework;
using DTOClaseDto = DTO.Dtos.DTOClase;

namespace GymWebApp.Tests.Integration.Factories;

public static class ClaseFactory
{
    /// <summary>
    /// Creates a single active Clase entity with FkEstadoClase = 1
    /// </summary>
    public static Clase CrearClaseActiva(
        Action<Faker<Clase>>? customRules = null)
    {
        var faker = new Faker<Clase>("es")
            .RuleFor(c => c.ClaseId, 0)
            .RuleFor(c => c.NombreClase, f => f.Lorem.Sentence(2).TrimEnd('.'))
            .RuleFor(c => c.Cupo, f => f.Random.Int(5, 30))
            .RuleFor(c => c.Descripcion, f => f.Lorem.Sentences(2))
            .RuleFor(c => c.DuracionEnMinutos, f => f.Random.Int(30, 90))
            .RuleFor(c => c.FkIntensidad, f => f.PickRandom(1, 2, 3))
            .RuleFor(c => c.FkDificultad, f => f.PickRandom(1, 2, 3))
            .RuleFor(c => c.TiempoDeDescansoEnMinutos, f => f.Random.Int(0, 15))
            .RuleFor(c => c.DuracionEnMinutosConDescansoIncluido, f => f.Random.Int(30, 105))
            .RuleFor(c => c.FkEstadoClase, 1)
            .RuleFor(c => c.InstructorId, _ => null)
            .RuleFor(c => c.ImagesForClases, _ => new List<ImagesForClase>())
            .RuleFor(c => c.BeneficiosDeClases, _ => new List<BeneficiosDeClase>())
            .RuleFor(c => c.ClasesProgramada, _ => new List<ClasesProgramada>())
            .RuleFor(c => c.ConsejosParaLasClases, _ => new List<ConsejosParaLasClase>())
            .RuleFor(c => c.EstructuraDeClases, _ => new List<EstructuraDeClase>())
            .RuleFor(c => c.Rutinas, _ => new List<Rutina>());

        customRules?.Invoke(faker);
        return faker.Generate();
    }

    /// <summary>
    /// Creates multiple active Clase entities
    /// </summary>
    public static IEnumerable<Clase> CrearClasesActivas(
        int cantidad,
        Action<Faker<Clase>>? customRules = null)
    {
        var faker = new Faker<Clase>("es")
            .RuleFor(c => c.ClaseId, 0)
            .RuleFor(c => c.NombreClase, f => f.Lorem.Sentence(2).TrimEnd('.'))
            .RuleFor(c => c.Cupo, f => f.Random.Int(5, 30))
            .RuleFor(c => c.Descripcion, f => f.Lorem.Sentences(2))
            .RuleFor(c => c.DuracionEnMinutos, f => f.Random.Int(30, 90))
            .RuleFor(c => c.FkIntensidad, f => f.PickRandom(1, 2, 3))
            .RuleFor(c => c.FkDificultad, f => f.PickRandom(1, 2, 3))
            .RuleFor(c => c.TiempoDeDescansoEnMinutos, f => f.Random.Int(0, 15))
            .RuleFor(c => c.DuracionEnMinutosConDescansoIncluido, f => f.Random.Int(30, 105))
            .RuleFor(c => c.FkEstadoClase, 1)
            .RuleFor(c => c.InstructorId, _ => null)
            .RuleFor(c => c.ImagesForClases, _ => new List<ImagesForClase>())
            .RuleFor(c => c.BeneficiosDeClases, _ => new List<BeneficiosDeClase>())
            .RuleFor(c => c.ClasesProgramada, _ => new List<ClasesProgramada>())
            .RuleFor(c => c.ConsejosParaLasClases, _ => new List<ConsejosParaLasClase>())
            .RuleFor(c => c.EstructuraDeClases, _ => new List<EstructuraDeClase>())
            .RuleFor(c => c.Rutinas, _ => new List<Rutina>());

        customRules?.Invoke(faker);
        return faker.Generate(cantidad);
    }

    /// <summary>
    /// Creates a single inactive Clase entity with FkEstadoClase = 2
    /// </summary>
    public static Clase CrearClaseInactiva(
        Action<Faker<Clase>>? customRules = null)
    {
        var faker = new Faker<Clase>("es")
            .RuleFor(c => c.ClaseId, 0)
            .RuleFor(c => c.NombreClase, f => f.Lorem.Sentence(2).TrimEnd('.'))
            .RuleFor(c => c.Cupo, f => f.Random.Int(5, 30))
            .RuleFor(c => c.Descripcion, f => f.Lorem.Sentences(2))
            .RuleFor(c => c.DuracionEnMinutos, f => f.Random.Int(30, 90))
            .RuleFor(c => c.FkIntensidad, f => f.PickRandom(1, 2, 3))
            .RuleFor(c => c.FkDificultad, f => f.PickRandom(1, 2, 3))
            .RuleFor(c => c.TiempoDeDescansoEnMinutos, f => f.Random.Int(0, 15))
            .RuleFor(c => c.DuracionEnMinutosConDescansoIncluido, f => f.Random.Int(30, 105))
            .RuleFor(c => c.FkEstadoClase, 2)
            .RuleFor(c => c.InstructorId, _ => null)
            .RuleFor(c => c.ImagesForClases, _ => new List<ImagesForClase>())
            .RuleFor(c => c.BeneficiosDeClases, _ => new List<BeneficiosDeClase>())
            .RuleFor(c => c.ClasesProgramada, _ => new List<ClasesProgramada>())
            .RuleFor(c => c.ConsejosParaLasClases, _ => new List<ConsejosParaLasClase>())
            .RuleFor(c => c.EstructuraDeClases, _ => new List<EstructuraDeClase>())
            .RuleFor(c => c.Rutinas, _ => new List<Rutina>());

        customRules?.Invoke(faker);
        return faker.Generate();
    }

    /// <summary>
    /// Creates an ImagesForClase entity for banner images
    /// </summary>
    public static ImagesForClase CrearImagenParaBanner(
        int fkClase,
        Action<Faker<ImagesForClase>>? customRules = null)
    {
        var faker = new Faker<ImagesForClase>("es")
            .RuleFor(i => i.IdClassImage, 0)
            .RuleFor(i => i.FkClase, fkClase)
            .RuleFor(i => i.UrlParaBanner, f => f.Image.PicsumUrl(800, 600))
            .RuleFor(i => i.UrlParaParaDescripcionDeClase, f => f.Image.PicsumUrl(400, 300))
            .RuleFor(i => i.UrlParaBloqueConsejos, f => f.Image.PicsumUrl(200, 200))
            .RuleFor(i => i.FechaDeCreacion, f => f.Date.Recent(30))
            .RuleFor(i => i.FechaDeModificacion, f => f.Date.Recent(7))
            .RuleFor(i => i.FkClaseNavigation, _ => null!);

        customRules?.Invoke(faker);
        return faker.Generate();
    }

    /// <summary>
    /// Creates multiple ImagesForClase entities
    /// </summary>
    public static IEnumerable<ImagesForClase> CrearImagenesParaBanner(
        int cantidad,
        Action<Faker<ImagesForClase>>? customRules = null)
    {
        var faker = new Faker<ImagesForClase>("es")
            .RuleFor(i => i.IdClassImage, 0)
            .RuleFor(i => i.FkClase, f => f.Random.Int(1, 100))
            .RuleFor(i => i.UrlParaBanner, f => f.Image.PicsumUrl(800, 600))
            .RuleFor(i => i.UrlParaParaDescripcionDeClase, f => f.Image.PicsumUrl(400, 300))
            .RuleFor(i => i.UrlParaBloqueConsejos, f => f.Image.PicsumUrl(200, 200))
            .RuleFor(i => i.FechaDeCreacion, f => f.Date.Recent(30))
            .RuleFor(i => i.FechaDeModificacion, f => f.Date.Recent(7))
            .RuleFor(i => i.FkClaseNavigation, _ => null!);

        customRules?.Invoke(faker);
        return faker.Generate(cantidad);
    }

    /// <summary>
    /// Creates a valid DTOClase for API requests
    /// </summary>
    public static DTOClaseDto CrearDTOClaseValida(Action<Faker<DTOClaseDto>>? customRules = null)
    {
        var faker = new Faker<DTOClaseDto>("es")
            .RuleFor(c => c.ClaseID, 0)
            .RuleFor(c => c.NombreClase, f => $"Clase Test {Guid.NewGuid():N}")
            .RuleFor(c => c.Descripcion, f => f.Lorem.Sentences(2))
            .RuleFor(c => c.DuracionEnMinutos, 60)
            .RuleFor(c => c.FkIntensidad, f => f.PickRandom(1, 2, 3))
            .RuleFor(c => c.FkDificultad, f => f.PickRandom(1, 2, 3))
            .RuleFor(c => c.TiempoDeDescansoEnMinutos, 15)
            .RuleFor(c => c.DuracionEnMinutosConDescansoIncluido, 75)
            .RuleFor(c => c.Cupo, 20)
            .RuleFor(c => c.FkEstadoClase, 1)
            .RuleFor(c => c.InstructorId, f => (string?)null);

        customRules?.Invoke(faker);
        return faker.Generate();
    }
}
