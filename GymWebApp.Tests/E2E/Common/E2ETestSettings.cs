using GymWebApp.Tests.Integration.Common;

namespace GymWebApp.Tests.E2E.Common;

/// <summary>
/// Provides test configuration from appsettings.Testing.json.
/// Facade over the typed "TestUsers" list — property names are unchanged, so the
/// existing call sites keep working without edits. No fallback values: a missing
/// setting fails immediately instead of degrading silently.
/// </summary>
public static class E2ETestSettings
{
    public static string TestUserEmail => TestUsersOptions.EmpleadoEmail;

    public static string TestUserPassword => TestUsersOptions.EmpleadoPassword;

    public static string TestUserClienteEmail => TestUsersOptions.ClienteEmail;

    public static string TestUserClientePassword => TestUsersOptions.ClientePassword;

    /// <summary>
    /// Account that is only ever used to resolve user identifiers; it never authenticates.
    /// </summary>
    public static string ClienteRebecaEmail => TestUsersOptions.ClienteRebecaEmail;
}
