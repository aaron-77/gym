using Bogus;
using DataAccess.EntityFramework;

namespace GymWebApp.Tests.E2E.Factories;

public static class DetalleDeClaseFactory
{
    private static string UniqueName => $"E2E Test {Guid.NewGuid():N}";

    public static Clase CrearClaseCompleta(Action<Faker<Clase>>? customRules = null)
    {
        var faker = new Faker<Clase>("es")
            .RuleFor(c => c.ClaseId, 0)
            .RuleFor(c => c.NombreClase, UniqueName)
            .RuleFor(c => c.SubtituloClase, f => f.Lorem.Sentence(3))
            .RuleFor(c => c.Cupo, 20)
            .RuleFor(c => c.Descripcion, f => f.Lorem.Paragraph())
            .RuleFor(c => c.DuracionEnMinutos, 45)
            .RuleFor(c => c.FkIntensidad, 2)
            .RuleFor(c => c.FkDificultad, 2)
            .RuleFor(c => c.TiempoDeDescansoEnMinutos, 10)
            .RuleFor(c => c.DuracionEnMinutosConDescansoIncluido, 55)
            .RuleFor(c => c.FkEstadoClase, 1)
            .RuleFor(c => c.InstructorId, _ => null)
            .RuleFor(c => c.ImagesForClases, _ => new List<ImagesForClase>())
            .RuleFor(c => c.BeneficiosDeClases, _ => new List<BeneficiosDeClase>())
            .RuleFor(c => c.ClasesProgramada, _ => new List<ClasesProgramada>())
            .RuleFor(c => c.ConsejosParaLasClases, _ => new List<ConsejosParaLasClase>())
            .RuleFor(c => c.EstructuraDeClases, _ => new List<EstructuraDeClase>())
            .RuleFor(c => c.Rutinas, _ => new List<Rutina>());
        return faker.Generate();
        customRules?.Invoke(faker);
    }

    public static Clase CrearClaseConDatosMinimos(Action<Faker<Clase>>? customRules = null)
    {
        var faker = new Faker<Clase>("es")
            .RuleFor(c => c.ClaseId, 0)
            .RuleFor(c => c.NombreClase, UniqueName)
            .RuleFor(c => c.SubtituloClase, _ => null)
            .RuleFor(c => c.Cupo, 20)
            .RuleFor(c => c.Descripcion, _ => null)
            .RuleFor(c => c.DuracionEnMinutos, _ => null)
            .RuleFor(c => c.FkIntensidad, 1 )
            .RuleFor(c => c.FkDificultad, 1)
            .RuleFor(c => c.TiempoDeDescansoEnMinutos, 0)
            .RuleFor(c => c.DuracionEnMinutosConDescansoIncluido, 0)
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

    public static Clase CrearClaseSinImagenes(Action<Faker<Clase>>? customRules = null)
    {
        var faker = new Faker<Clase>("es")
            .RuleFor(c => c.ClaseId, 0)
            .RuleFor(c => c.NombreClase, UniqueName)
            .RuleFor(c => c.SubtituloClase, f => f.Lorem.Sentence(3))
            .RuleFor(c => c.Cupo, 20)
            .RuleFor(c => c.Descripcion, f => f.Lorem.Paragraph())
            .RuleFor(c => c.DuracionEnMinutos, 45)
            .RuleFor(c => c.FkIntensidad, 2)
            .RuleFor(c => c.FkDificultad, 2)
            .RuleFor(c => c.TiempoDeDescansoEnMinutos, 10)
            .RuleFor(c => c.DuracionEnMinutosConDescansoIncluido, 55)
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

    public static ImagesForClase CrearImagen(int fkClase, Action<Faker<ImagesForClase>>? customRules = null)
    {
        var faker = new Faker<ImagesForClase>("es")
            .RuleFor(i => i.IdClassImage, 0)
            .RuleFor(i => i.FkClase, fkClase)
            .RuleFor(i => i.UrlParaBanner, f => f.Image.PicsumUrl())
            .RuleFor(i => i.UrlParaParaDescripcionDeClase, f => f.Image.PicsumUrl())
            .RuleFor(i => i.UrlParaBloqueConsejos, f => f.Image.PicsumUrl())
            .RuleFor(i => i.FechaDeCreacion, f => f.Date.Recent(30))
            .RuleFor(i => i.FechaDeModificacion, f => f.Date.Recent(7))
            .RuleFor(i => i.FkClaseNavigation, _ => null!);
        customRules?.Invoke(faker);
        return faker.Generate();
    }

    public static BeneficiosDeClase CrearBeneficio(int fkClase, Action<Faker<BeneficiosDeClase>>? customRules = null)
    {
        var faker = new Faker<BeneficiosDeClase>("es")
            .RuleFor(b => b.IdBeneficio, 0)
            .RuleFor(b => b.FkClase, fkClase)
            .RuleFor(b => b.Beneficio, f => f.Lorem.Word())
            .RuleFor(b => b.DescripcionBeneficio, f => f.Lorem.Sentence())
            .RuleFor(b => b.FkIcon, _ => null)
            .RuleFor(b => b.FechaDeCreacion, f => f.Date.Recent(30))
            .RuleFor(b => b.FechaDeModificacion, f => f.Date.Recent(7));
        customRules?.Invoke(faker);
        return faker.Generate();
    }

    public static EstructuraDeClase CrearBloqueEstructura(int fkClase, int numeroConsecutivo, Action<Faker<EstructuraDeClase>>? customRules = null)
    {
        var faker = new Faker<EstructuraDeClase>("es")
            .RuleFor(e => e.IdBloque, 0)
            .RuleFor(e => e.FkClase, fkClase)
            .RuleFor(e => e.NumeroConsecutivoDelBloque, numeroConsecutivo)
            .RuleFor(e => e.DuracionMenorEnMinutos, f => f.Random.Int(3, 10))
            .RuleFor(e => e.DuracionMayorEnMinutos, f => f.Random.Int(10, 30))
            .RuleFor(e => e.TituloBloque, f => f.Lorem.Word())
            .RuleFor(e => e.DescripcionBloque, f => f.Lorem.Paragraph())
            .RuleFor(e => e.FechaDeCreacion, f => f.Date.Recent(30))
            .RuleFor(e => e.FechaDeModificacion, f => f.Date.Recent(7));
        customRules?.Invoke(faker);
        return faker.Generate();
    }

    public static List<BeneficiosDeClase> CrearListaBeneficios(int fkClase, int cantidad = 3)
    {
        var beneficios = new List<BeneficiosDeClase>();
        for (int i = 0; i < cantidad; i++)
            beneficios.Add(CrearBeneficio(fkClase));
        return beneficios;
    }

    public static List<EstructuraDeClase> CrearListaBloquesEstructura(int fkClase, int cantidad = 3)
    {
        var bloques = new List<EstructuraDeClase>();
        for (int i = 0; i < cantidad; i++)
            bloques.Add(CrearBloqueEstructura(fkClase, i + 1));
        return bloques;
    }

    public static List<ClasesProgramada> CrearListaClasesProgramadas(
        int fkClase,
        int cantidad,
        string? entrenadorId)
    {
        var clasesProgramadas = new List<ClasesProgramada>();
        for (int i = 0; i < cantidad; i++)
        {
            var fechaFutura = DateOnly.FromDateTime(DateTime.Now.AddDays(i + 1));
            clasesProgramadas.Add(CrearClaseProgramada(fkClase, 1, entrenadorId, fechaFutura));
        }
        return clasesProgramadas;
    }

    public static List<HorariosDeClasesProgramada> CrearListaHorarios(
        List<int> idsProgramacion,
        List<int> idsHorasLaborales)
    {
        var horarios = new List<HorariosDeClasesProgramada>();
        var count = Math.Min(idsProgramacion.Count, idsHorasLaborales.Count);
        for (int i = 0; i < count; i++)
            horarios.Add(CrearHorarioClaseProgramada(idsProgramacion[i], idsHorasLaborales[i]));
        return horarios;
    }

    public static ConsejosParaLasClase CrearConsejo(int fkClase, Action<Faker<ConsejosParaLasClase>>? customRules = null)
    {
        var faker = new Faker<ConsejosParaLasClase>("es")
            .RuleFor(c => c.IdConsejo, 0)
            .RuleFor(c => c.FkClase, fkClase)
            .RuleFor(c => c.FkEjercicio, _ => null)
            .RuleFor(c => c.IntroduccionDeConsejo, f => f.Lorem.Sentence())
            .RuleFor(c => c.Consejos, "Consejo 1|Consejo 2|Consejo 3");
        customRules?.Invoke(faker);
        return faker.Generate();
    }

    public static ClasesProgramada CrearClaseProgramada(
        int fkClase,
        int fkEstado,
        string? entrenadorId,
        DateOnly fecha,
        Action<Faker<ClasesProgramada>>? customRules = null)
    {
        var faker = new Faker<ClasesProgramada>("es")
            .RuleFor(cp => cp.IdProgramacionClase, 0)
            .RuleFor(cp => cp.FkClase, fkClase)
            .RuleFor(cp => cp.CupoMaximo, 20)
            .RuleFor(cp => cp.FkEstadoClaseProgramada, fkEstado)
            .RuleFor(cp => cp.FechaCreacion, f => f.Date.Recent(30))
            .RuleFor(cp => cp.FechaModificacion, f => f.Date.Recent(7))
            .RuleFor(cp => cp.FkEntrenador, entrenadorId)
            .RuleFor(cp => cp.FechaDeLaClase, fecha)
            .RuleFor(cp => cp.HorariosDeClasesProgramada, _ => new List<HorariosDeClasesProgramada>());
        customRules?.Invoke(faker);
        return faker.Generate();
    }

    public static HorariosDeClasesProgramada CrearHorarioClaseProgramada(
        int fkProgramacionClase,
        int fkHorarioLaboral,
        Action<Faker<HorariosDeClasesProgramada>>? customRules = null)
    {
        var faker = new Faker<HorariosDeClasesProgramada>("es")
            .RuleFor(h => h.IdHorarioDeClaseProgramada, 0)
            .RuleFor(h => h.FkClaseProgramada, fkProgramacionClase)
            .RuleFor(h => h.FkHorarioLaboral, fkHorarioLaboral)
            .RuleFor(h => h.FkEstadoHorarioClase, 1);
        customRules?.Invoke(faker);
        return faker.Generate();
    }
}
