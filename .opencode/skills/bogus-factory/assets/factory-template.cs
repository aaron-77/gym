using Bogus;

namespace GymWebApp.Tests.Common;

public static class EntidadFactory
{
    public static TEntity Crear<TEntity>(
        Action<Faker<TEntity>>? customRules = null) where TEntity : class, new()
    {
        var faker = new Faker<TEntity>("es");
        
        customRules?.Invoke(faker);
        
        return faker.Generate();
    }

    public static IEnumerable<TEntity> CrearVarios<TEntity>(
        int cantidad,
        Action<Faker<TEntity>>? customRules = null) where TEntity : class, new()
    {
        var faker = new Faker<TEntity>("es");
        
        customRules?.Invoke(faker);
        
        return faker.Generate(cantidad);
    }
}
