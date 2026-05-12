using Microsoft.Extensions.Configuration;

namespace GymWebApp.Tests.Integration.Common;

public static class ConfigHelper
{
    private static IConfiguration? _configuration;
    private static bool _isRegistered;

    public static void RegisterConfig(string jsonFileName)
    {
        if (_isRegistered)
            return; // already registered, skip rebuild

        var configBuilder = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile(jsonFileName, optional: false, reloadOnChange: true);
        
        _configuration = configBuilder.Build();
        _isRegistered = true;
    }

    public static string GetProperty(string key)
    {
        var value = _configuration?[key];
        
        if (string.IsNullOrEmpty(value))
            throw new InvalidOperationException($"Config key '{key}' not found");
            
        return value;
    }

    public static IConfigurationSection GetSection(string sectionName)
    {
        var section = _configuration?.GetSection(sectionName);
        
        if (section == null || !section.Exists())
            throw new InvalidOperationException($"Config section '{sectionName}' not found");
            
        return section;
    }
}
