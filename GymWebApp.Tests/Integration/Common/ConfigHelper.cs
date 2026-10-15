using Microsoft.Extensions.Configuration;

namespace GymWebApp.Tests.Integration.Common;

public static class ConfigHelper
{
    private const string DefaultJsonFileName = "appsettings.Testing.json";

    private static IConfiguration? _configuration;
    private static bool _isRegistered;

    public static void RegisterConfig(string jsonFileName)
    {
        if (_isRegistered)
            return; // already registered, skip rebuild

        _configuration = Build(jsonFileName);
        _isRegistered = true;
    }

    public static string GetProperty(string key)
    {
        var value = Configuration()[key];

        if (string.IsNullOrEmpty(value))
            throw new InvalidOperationException($"Config key '{key}' not found");

        return value;
    }

    public static string GetPropertyOrDefault(string key, string defaultValue)
    {
        var value = Configuration()[key];

        return string.IsNullOrEmpty(value) ? defaultValue : value;
    }

    public static IConfigurationSection GetSection(string sectionName)
    {
        var section = Configuration().GetSection(sectionName);

        if (!section.Exists())
            throw new InvalidOperationException($"Config section '{sectionName}' not found");

        return section;
    }

    /// <summary>
    /// Única fuente de configuración de las pruebas. Todo punto de lectura pasa por acá,
    /// de modo que no puedan existir dos rutas base distintas resolviendo lo mismo.
    /// </summary>
    private static IConfiguration Configuration()
    {
        if (_configuration is null)
            RegisterConfig(DefaultJsonFileName);

        return _configuration!;
    }

    private static IConfiguration Build(string jsonFileName) =>
        new ConfigurationBuilder()
            .SetBasePath(AppContext.BaseDirectory)
            .AddJsonFile(jsonFileName, optional: false, reloadOnChange: false)
            .Build();
}