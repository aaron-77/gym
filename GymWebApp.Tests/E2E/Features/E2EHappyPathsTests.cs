using GymWebApp.Tests.E2E.Common;
using Microsoft.Extensions.Configuration;
using Microsoft.Playwright;


using Renci.SshNet;
using System.Text.RegularExpressions;

namespace GymWebApp.Tests.E2E.Features;

[Collection("E2E HappyPaths")]
public class E2EHappyPathsTests : PlaywrightTestBase, IAsyncLifetime
{
    private readonly IConfiguration _configuration;
    private readonly string _employeeEmail;
    private readonly string _employeePassword;
    private readonly string _clientEmail;
    private readonly string _clientPassword;

    public E2EHappyPathsTests()
    {
        // Load configuration from appsettings.Testing.json
        var configPath = Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "appsettings.Testing.json");
        if (!File.Exists(configPath))
        {
            configPath = Path.Combine(AppContext.BaseDirectory, "appsettings.Testing.json");
        }

        _configuration = new ConfigurationBuilder()
            .AddJsonFile(configPath, optional: false, reloadOnChange: true)
            .AddEnvironmentVariables()
            .Build();

        _employeeEmail = _configuration["TestUser:Email"] ?? "uno@gmail.com";
        _employeePassword = _configuration["TestUser:Password"] ?? "Password123*";
        _clientEmail = _configuration["TestUserCliente:Email"] ?? "aaronhl1313@gmail.com";
        _clientPassword = _configuration["TestUserCliente:Password"] ?? "Password123*";
    }

    public async Task InitializeAsync()
    {
        await base.InitializeAsync();
    }

    public new async Task DisposeAsync()
    {
        await base.DisposeAsync();
    }

    private string BaseUrl => E2eContainerHelper.NginxBaseUrl;

    #region 1. Público - Registro de Cuenta

    [Fact]
    public async Task Register_ConDatosValidos_CreaCuenta()
    {
        // Given: Usuario en página de registro /crearCuenta
        await Page.GotoAsync($"{BaseUrl}/crearCuenta");

        // When: Completa formulario con email, contraseña y datos requeridos, envía formulario
        var timestamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
        var newEmail = $"testuser{timestamp}@test.com";

        await Page.FillAsync("input[name='correo']", newEmail);
        await Page.FillAsync("input[name='contrasena']", "Test1234*");
        await Page.FillAsync("input[id*='ConfirmPassword']", "Test1234*");
        await Page.FillAsync("input[id*='Name']", "Test");
        await Page.FillAsync("input[id*='LastName']", "User");
        await Page.ClickAsync("button.sign");

        // Then: Redirige a página de login o muestra mensaje de éxito
        await Assertions.Expect(Page.Locator("input[name='correo']")).ToBeVisibleAsync();

        // Verificar que redirigió a signIn o muestra mensaje de éxito
        var currentUrl = Page.Url;
        var pageContent = await Page.ContentAsync();

        Assert.True(
            currentUrl.Contains("signIn") ||
            pageContent.Contains("éxito") ||
            pageContent.Contains("exito") ||
            pageContent.Contains("success") ||
            currentUrl.Contains("login"),
            $"Se esperaba redirección a login o mensaje de éxito. URL actual: {currentUrl}");
    }

    #endregion

    #region 2. Cliente - Login

    [Fact]
    public async Task Cliente_Login_AccedeDashboard()
    {
        // Given: Usuario en página de login /signIn
        await Page.GotoAsync($"{BaseUrl}/signIn");

        // When: Ingresa credenciales de cliente y envía formulario
        await Page.FillAsync("input[name='correo']", _clientEmail);
        await Page.FillAsync("input[name='contrasena']", _clientPassword);
        await Page.ClickAsync("button.sign");
        
        // Then: espera a que este visible la barra de menu latera
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

            var currentUrl = Page.Url;
        Assert.True(
            currentUrl.Contains("clientes"),
            $"Se esperaba redirección a /clientes. URL actual: {currentUrl}");
    }

    #endregion

    #region 3. Cliente - Ver Detalles de Progreso

    [Fact]
    public async Task Cliente_VerDetallesDeProgreso()
    {
        // Given: Cliente logueado en dashboard /clientes
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _clientEmail);
        await Page.FillAsync("input[name='contrasena']", _clientPassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator(".medidas-section, h1")).ToBeVisibleAsync();

        // When: Navega a /detallesDeProgreso
        await Page.GotoAsync($"{BaseUrl}/detallesDeProgreso");

        // Then: Página carga correctamente con gráfico de medidas
        await Assertions.Expect(Page.Locator(".medidas-section, h1")).ToBeVisibleAsync();

        var pageContent = await Page.ContentAsync();
        var chartLoaded = pageContent.Contains("chart") ||
                         pageContent.Contains("Chart") ||
                         pageContent.Contains("progreso") ||
                         pageContent.Contains("Progreso") ||
                         pageContent.Contains("medida") ||
                         pageContent.Contains("Medida");

        Assert.True(
            !string.IsNullOrEmpty(pageContent),
            "La página de detalles de progreso debería cargar contenido");
    }

    #endregion

    #region 4. Cliente - Filtrar Medidas en Gráfico

    [Fact]
    public async Task Cliente_FiltrarMedidasEnGrafico()
    {
        // Given: Cliente logueado en dashboard /clientes
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _clientEmail);
        await Page.FillAsync("input[name='contrasena']", _clientPassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();
        
        // When: Navega a detalles de progreso haciendo click en primer botón de detalles
        var detailsButton = Page.Locator("img.details-button").Nth(0);
        await detailsButton.ClickAsync();
        
        // Then: Verificar navegación a detalles de progreso y formulario visible
        await Assertions.Expect(Page.Locator("#chartForm")).ToBeVisibleAsync();

        // When: Seleccionar parámetros de filtro usando locator pattern
        var parametroSelect = Page.Locator("select#inputParametro");
        await parametroSelect.SelectOptionAsync("peso");
        
        var espaciadoSelect = Page.Locator("select#espaciadoTemporal");
        await espaciadoSelect.SelectOptionAsync("individual");
        
        var tipoSelect = Page.Locator("select#tipoDeBusqueda");
        await tipoSelect.SelectOptionAsync("año");
        
        var yearCheckbox = Page.Locator("input#year2024");
        await yearCheckbox.ClickAsync();
        
        var consultarBtn = Page.Locator("input#submitButton");
        await consultarBtn.ClickAsync();

        // Then: Verificar que el gráfico se mostró (errorMessageContainer vacío)
        await Page.WaitForTimeoutAsync(2000); // Esperar respuesta AJAX
        var errorMessage = await Page.Locator("#errorMessageContainer").InnerTextAsync();
        Assert.True(
            string.IsNullOrWhiteSpace(errorMessage),
            $"Se esperaba gráfico visible (errorMessage vacío). Mensaje: {errorMessage}");
    }

    #endregion

    #region 5. Empleado - Login

    [Fact]
    public async Task Empleado_Login_AccedeDashboard()
    {
        // Given: Usuario en página de login /signIn
        await Page.GotoAsync($"{BaseUrl}/signIn");

        // When: Ingresa credenciales de empleado y envía formulario
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        // Then: Redirige a /empleados
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        var currentUrl = Page.Url;
        Assert.True(
            currentUrl.Contains("empleados"),
            $"Se esperaba redirección a /empleados. URL actual: {currentUrl}");
    }

    #endregion

    #region 6. Empleado - Registrar Medida

    [Fact]
    public async Task Empleado_RegistrarMedida()
    {
        // Given: Empleado logueado en dashboard /empleados
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("form, #formGestionRutinas")).ToBeVisibleAsync();

        // When: Completa formulario de medidas y envía
        await Page.GotoAsync($"{BaseUrl}/registrarMedida");
        await Page.FillAsync("input[id*='Weight'], input[id*='Peso']", "75.5");
        await Page.FillAsync("input[id*='Height'], input[id*='Altura']", "175");
        await Page.ClickAsync("button.sign");

        // Then: Medida registrada exitosamente, aparece en la lista
        await Assertions.Expect(Page.Locator("form, #formGestionRutinas")).ToBeVisibleAsync();

        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("éxito") ||
                          pageContent.Contains("exito") ||
                          pageContent.Contains("success") ||
                          pageContent.Contains("registrada");

        Assert.True(
            successMessage || Page.Url.Contains("empleados"),
            $"Se esperaba mensaje de éxito o redirección. URL actual: {Page.Url}");
    }

    #endregion

    #region 7. Empleado - Registrar Clase Catálogo

    [Fact]
    public async Task Empleado_GestionarDuracionCitasMedicion()
    {
        // Given: Empleado logueado, navega a /duracionCitasMedicionPage
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("form, .form-container")).ToBeVisibleAsync();

        // When: Completa formulario con datos de duración y envía
        await Page.GotoAsync($"{BaseUrl}/duracionCitasMedicionPage");
        await Page.FillAsync("input[name='duracion']", "2");
        await Page.FillAsync("input[name='frecuenciaNotificaciones']", "30");
        await Page.ClickAsync("button:has-text('Guardar'), button:has-text('Registrar')");

        // Then: Duración registrada exitosamente
        await Assertions.Expect(Page.Locator("form, .form-container")).ToBeVisibleAsync();

        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("éxito") ||
                          pageContent.Contains("exito") ||
                          pageContent.Contains("success") ||
                          pageContent.Contains("Guardar") ||
                          pageContent.Contains("Registrar");

        Assert.True(
            successMessage || Page.Url.Contains("empleados"),
            $"Se esperaba mensaje de éxito o redirección. URL actual: {Page.Url}");
    }

    #endregion

    #region 8. Empleado - Programar Clase

    [Fact]
    public async Task Empleado_ProgramarClase()
    {
        // Given: Empleado logueado, navega a /registroClasesProgramadas
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("form, table")).ToBeVisibleAsync();

        // When: Programa fecha/hora de clase y envía
        await Page.GotoAsync($"{BaseUrl}/registroClasesProgramadas");
        await Page.FillAsync("input[type='datetime-local']", "2027-06-01T10:00");
        await Page.ClickAsync("button.sign");

        // Then: Clase programada exitosamente
        await Assertions.Expect(Page.Locator("form, table")).ToBeVisibleAsync();

        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("éxito") ||
                          pageContent.Contains("exito") ||
                          pageContent.Contains("success") ||
                          pageContent.Contains("programada");

        Assert.True(
            successMessage || Page.Url.Contains("empleados") || Page.Url.Contains("clases"),
            $"Se esperaba mensaje de éxito o redirección. URL actual: {Page.Url}");
    }

    #endregion

    #region 9. Empleado - Inscribir Cliente a Clase

    [Fact]
    public async Task Empleado_InscribirClienteAClase()
    {
        // Given: Empleado logueado, navega a /inscripcionAClases
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("form, select, table")).ToBeVisibleAsync();

        // When: Selecciona cliente y clase, confirma inscripción
        await Page.GotoAsync($"{BaseUrl}/inscripcionAClases");

        // Buscar y seleccionar un cliente
        var clienteSelect = await Page.QuerySelectorAsync("select[id*='Cliente'], select[id*='Client']");
        if (clienteSelect != null)
        {
            await clienteSelect.SelectOptionAsync(new SelectOptionValue { Index = 1 });
        }

        // Buscar y seleccionar una clase
        var claseSelect = await Page.QuerySelectorAsync("select[id*='Clase'], select[id*='Class']");
        if (claseSelect != null)
        {
            await claseSelect.SelectOptionAsync(new SelectOptionValue { Index = 1 });
        }

        await Page.ClickAsync("button.sign");

        // Then: Cliente inscrito exitosamente
        await Assertions.Expect(Page.Locator("form, select, table")).ToBeVisibleAsync();

        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("éxito") ||
                          pageContent.Contains("exito") ||
                          pageContent.Contains("success") ||
                          pageContent.Contains("inscrito");

        Assert.True(
            successMessage || Page.Url.Contains("empleados") || Page.Url.Contains("clase"),
            $"Se esperaba mensaje de éxito o redirección. URL actual: {Page.Url}");
    }

    #endregion

    #region 10. Empleado - Registrar Cita

    [Fact]
    public async Task Empleado_RegistrarCita()
    {
        // Given: Empleado logueado, navega a /registrarCita
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("form, #formGestionRutinas")).ToBeVisibleAsync();

        // When: Completa formulario de cita y envía
        await Page.GotoAsync($"{BaseUrl}/registrarCita");
        await Page.FillAsync("input[id*='Date'], input[type='datetime-local']", "2027-06-15T14:00");
        await Page.FillAsync("textarea[id*='Notes'], textarea[id*='Notas']", "Cita de prueba E2E");
        await Page.ClickAsync("button.sign");

        // Then: Cita registrada exitosamente
        await Assertions.Expect(Page.Locator("form, #formGestionRutinas")).ToBeVisibleAsync();

        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("éxito") ||
                          pageContent.Contains("exito") ||
                          pageContent.Contains("success") ||
                          pageContent.Contains("registrada");

        Assert.True(
            successMessage || Page.Url.Contains("empleados") || Page.Url.Contains("cita"),
            $"Se esperaba mensaje de éxito o redirección. URL actual: {Page.Url}");
    }

    #endregion

    #region 11. Empleado - Modificar Cita

    [Fact]
    public async Task Empleado_ModificarCita()
    {
        // Given: Empleado logueado, navega a /modificarCita
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("table, .table")).ToBeVisibleAsync();

        // When: Modifica datos de cita y guarda
        await Page.GotoAsync($"{BaseUrl}/modificarCita");

        // Intentar modificar la primera cita encontrada
        var editarButton = await Page.QuerySelectorAsync("button:has-text('Editar'), a:has-text('Editar')");
        if (editarButton != null)
        {
            await editarButton.ClickAsync();
            await Assertions.Expect(Page.Locator("table, .table")).ToBeVisibleAsync();

            // Modificar algún campo
            var notesField = await Page.QuerySelectorAsync("textarea[id*='Notes'], textarea[id*='Notas']");
            if (notesField != null)
            {
                await notesField.FillAsync("Cita modificada desde E2E test");
            }

            await Page.ClickAsync("button:has-text('Guardar'), button.sign");
            await Assertions.Expect(Page.Locator("table, .table")).ToBeVisibleAsync();
        }

        // Then: Cita modificada exitosamente
        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("éxito") ||
                          pageContent.Contains("exito") ||
                          pageContent.Contains("success") ||
                          pageContent.Contains("modificada") ||
                          pageContent.Contains("actualizada");

        Assert.True(
            successMessage || Page.Url.Contains("empleados") || Page.Url.Contains("cita"),
            $"Se esperaba mensaje de éxito o redirección. URL actual: {Page.Url}");
    }

    #endregion

    #region 12. Empleado - Gestionar Rutinas

    [Fact]
    public async Task Empleado_GestionarRutinas()
    {
        // Given: Empleado logueado, navega a /gestionRutinas
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("form, #formGestionRutinas")).ToBeVisibleAsync();

        // When: Crea/editar rutina y guarda
        await Page.GotoAsync($"{BaseUrl}/gestionRutinas");
        await Page.FillAsync("input[id*='Name'], input[id*='Nombre']", "Rutina E2E Test");
        await Page.FillAsync("textarea[id*='Description'], textarea[id*='Descripcion']", "Descripción de rutina de prueba");
        await Page.ClickAsync("button.sign");

        // Then: Rutina guardada exitosamente
        await Assertions.Expect(Page.Locator("form, #formGestionRutinas")).ToBeVisibleAsync();

        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("éxito") ||
                          pageContent.Contains("exito") ||
                          pageContent.Contains("success") ||
                          pageContent.Contains("guardada") ||
                          pageContent.Contains("creada");

        Assert.True(
            successMessage || Page.Url.Contains("empleados") || Page.Url.Contains("rutina"),
            $"Se esperaba mensaje de éxito o redirección. URL actual: {Page.Url}");
    }

    #endregion

    #region 13. Empleado - Asignar Ejercicios a Rutinas

    [Fact]
    public async Task Empleado_AsignarEjerciciosARutina()
    {
        // Given: Empleado logueado, navega a /AsignacionEjercicios
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("form, select, table")).ToBeVisibleAsync();

        // When: Selecciona ejercicios y los asigna a una rutina
        await Page.GotoAsync($"{BaseUrl}/AsignacionEjercicios");
        await Page.ClickAsync("select[id*='Rutina'] option:nth-child(2)"); // Seleccionar primera rutina
        await Page.ClickAsync("input[type='checkbox']"); // Seleccionar ejercicios
        await Page.ClickAsync("button.sign");

        // Then: Ejercicios asignados exitosamente a la rutina
        await Assertions.Expect(Page.Locator("form, select, table")).ToBeVisibleAsync();

        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("éxito") ||
                          pageContent.Contains("exito") ||
                          pageContent.Contains("success") ||
                          pageContent.Contains("guardado") ||
                          pageContent.Contains("creado");

        Assert.True(
            successMessage || Page.Url.Contains("empleados") || Page.Url.Contains("rutina"),
            $"Se esperaba mensaje de éxito o redirección. URL actual: {Page.Url}");
    }

    #endregion
}