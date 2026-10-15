using Microsoft.Extensions.Configuration;

namespace GymWebApp.Tests.Integration.Common;

/// <summary>
/// Una cuenta de prueba declarada en la lista "TestUsers" de appsettings.Testing.json.
/// </summary>
public sealed class TestUserEntry
{
    /// <summary>
    /// Identificador con el que los consumidores recuperan la entrada. Insensible a mayúsculas.
    /// </summary>
    public string Title { get; set; } = string.Empty;

    /// <summary>
    /// Cuenta con la que se autentica o se localiza al usuario en la base.
    /// </summary>
    public string Email { get; set; } = string.Empty;

    /// <summary>
    /// Nula a propósito en las cuentas que solo se usan para resolver identificadores:
    /// un uso indebido falla de inmediato en lugar de autenticarse sin querer.
    /// </summary>
    public string? Password { get; set; }
}

/// <summary>
/// Acceso tipado a los usuarios de prueba. Agregar un usuario es agregar una entrada a la
/// lista de configuración; no requiere escribir código.
/// </summary>
public sealed class TestUsersOptions
{
    public const string SectionName = "TestUsers";

    public const string EmpleadoTitle = "Empleado";
    public const string ClienteTitle = "Cliente";
    public const string ClienteRebecaTitle = "ClienteRebeca";
    public const string UnoTitle = "Uno";

    private static TestUsersOptions? _current;

    public List<TestUserEntry> Entries { get; set; } = new();

    /// <summary>
    /// Lista enlazada desde la configuración. Se enlaza una sola vez por proceso.
    /// </summary>
    public static TestUsersOptions Current => _current ??= Load();

    public static TestUsersOptions Load()
    {
        var options = ConfigHelper.GetSection(SectionName).Get<TestUsersOptions>()
            ?? throw new InvalidOperationException($"Config section '{SectionName}' could not be bound");

        if (options.Entries.Count == 0)
            throw new InvalidOperationException($"Config section '{SectionName}' has no entries");

        return options;
    }

    /// <summary>
    /// Devuelve la entrada con el título dado. Lanza si no existe: nunca devuelve nulo
    /// ni un valor de reserva.
    /// </summary>
    public TestUserEntry Get(string title)
    {
        var entry = Entries.FirstOrDefault(e =>
            string.Equals(e.Title, title, StringComparison.OrdinalIgnoreCase));

        if (entry is null)
            throw new InvalidOperationException(
                $"Test user entry '{title}' not found in config section '{SectionName}'");

        if (string.IsNullOrWhiteSpace(entry.Email))
            throw new InvalidOperationException(
                $"Test user entry '{title}' has no Email configured in config section '{SectionName}'");

        return entry;
    }

    public string Email(string title) => Get(title).Email;

    /// <summary>
    /// Correo de la cuenta de empleado. Accesor de uso preferente: quien llama
    /// no necesita conocer la constante de título, que queda como detalle interno.
    /// </summary>
    public static string EmpleadoEmail => Current.Email(EmpleadoTitle);

    /// <summary>
    /// Correo de la cuenta de cliente que se autentica.
    /// </summary>
    public static string ClienteEmail => Current.Email(ClienteTitle);

    /// <summary>
    /// Correo de la cuenta de cliente que solo se usa para resolver identificadores.
    /// Nunca se autentica, por eso no expone contraseña.
    /// </summary>
    public static string ClienteRebecaEmail => Current.Email(ClienteRebecaTitle);

    /// <summary>
    /// Contraseña de la cuenta de empleado. Accesor de uso preferente: quien llama
    /// no necesita conocer la constante de título, que queda como detalle interno.
    /// </summary>
    public static string EmpleadoPassword => Current.Password(EmpleadoTitle);

    /// <summary>
    /// Contraseña de la cuenta de cliente que se autentica.
    /// </summary>
    public static string ClientePassword => Current.Password(ClienteTitle);

    /// <summary>
    /// Correo de la cuenta "uno". Se usa para el Happy Path de autenticación.
    /// </summary>
    public static string UnoEmail => Current.Email(UnoTitle);

    /// <summary>
    /// Contraseña de la cuenta "uno".
    /// </summary>
    public static string UnoPassword => Current.Password(UnoTitle);

    public string Password(string title) =>
        Get(title).Password
        ?? throw new InvalidOperationException(
            $"Test user entry '{title}' has no Password configured; it can only be used to resolve identifiers");
}
