using GymWebApp.Tests.E2E.Common;
using GymWebApp.Tests.SharedHelpers;
using Microsoft.Extensions.Configuration;
using Microsoft.Playwright;


using Renci.SshNet;
using System.Text.RegularExpressions;

namespace GymWebApp.Tests.E2E.Features;

[Collection("E2E HappyPaths")]
public class E2EHappyPathsTests : PlaywrightTestBase
{
    private readonly IConfiguration _configuration;
    private readonly string _employeeEmail;
    private readonly string _employeePassword;
    private readonly string _clientEmail;
    private readonly string _clientPassword;

    public E2EHappyPathsTests(E2eContainerHelper e2eContainerHelper, PlaywrightHelper playwrightHelper) 
        : base(e2eContainerHelper, playwrightHelper)
    {
        // Keep existing config loading as-is (don't change to E2ETestSettings)
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

    private string BaseUrl => E2eContainerHelper.NginxBaseUrl;

    #region 1. Público - Registro de Cuenta

    [Fact]
    public async Task CrearCuenta()
    {
        // Given: Usuario en página de registro /crearCuenta
        await Page.GotoAsync($"{BaseUrl}/signUp");

        // When: Completa formulario con email, contraseña y datos requeridos, envía formulario
        var timestamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
        var newEmail = $"testuser{timestamp}@test.com";

        await Page.FillAsync("input[name='correo']", newEmail);
        await Page.FillAsync("input[name='contrasena']", "Test1234*");
        await Page.FillAsync("input[name='ContrasenaConfirmacion']", "Test1234*");
        await Page.FillAsync("#inputNombre", "Test");
        await Page.FillAsync("#inputApellido", "User");
        await Page.ClickAsync("button.sign");

        // Then: Redirige a página de login o muestra mensaje de éxito en validation-error
        var validationError = Page.Locator(".validation-error");
        await Assertions.Expect(validationError).ToBeVisibleAsync();
        var validationText = await validationError.InnerTextAsync();
        Assert.False(string.IsNullOrEmpty(validationText), "Expected a success message from the API");
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
        var sidebar = Page.Locator("#sidebar");
        await Assertions.Expect(sidebar).ToBeVisibleAsync();

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
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);
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
        
        var yearCheckbox = Page.Locator("input#year2025");
        await yearCheckbox.CheckAsync();
        
        var consultarBtn = Page.Locator("input#submitButton");
        await consultarBtn.ClickAsync();


        
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
        var sidebar = Page.Locator("#sidebar");
        await Assertions.Expect(sidebar).ToBeVisibleAsync();

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
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        

        // Then: Formulario de empleados visible
        await Assertions.Expect(Page.Locator("select[name='unidadDeMedidaId']")).ToBeVisibleAsync();

        // When: Completa formulario de medidas
        await Page.Locator("select[name='fkUsuario']").SelectOptionAsync(new SelectOptionValue { Index = 1 });
        await Page.Locator("select[name='fkParametro']").SelectOptionAsync(new SelectOptionValue { Index = 1 });
        await Page.Locator("select[name='unidadDeMedidaId']").SelectOptionAsync(new SelectOptionValue { Index = 1 });
        await Page.Locator("input[name='valor']").FillAsync("75.5");

        // And: Envía formulario
        await Page.Locator("button.btn-primary[type='submit']").ClickAsync();

        // Then: Verificar reset del formulario (volvió a valores por defecto)
        var usuarioText = await Page.Locator("select[name='fkUsuario'] option[selected]").InnerTextAsync();
        var parametroText = await Page.Locator("select[name='fkParametro'] option[selected]").InnerTextAsync();
        var unidadText = await Page.Locator("select[name='unidadDeMedidaId'] option[selected]").InnerTextAsync();
        var valor = await Page.Locator("input[name='valor']").InputValueAsync();

        Assert.True(
            usuarioText.Contains("selecciona un usuario") &&
            parametroText.Contains("selecciona un parametro") &&
            unidadText.Contains("Selecciona una Unidad de medida") &&
            string.IsNullOrEmpty(valor),
            "Se esperaba que los campos volvieran a su estado inicial");

        
        
    }

    #endregion

    #region 7. Empleado - Registrar Clase Catálogo

    [Fact]
    public async Task Empleado_GestionarDuracionCitasMedicion()
    {
        // Given: Empleado logueado
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // When: Navega a gestión de duración de citas
        await Page.GotoAsync($"{BaseUrl}/duracionCitasMedicionPage");

        // Then: Formulario visible
        await Assertions.Expect(Page.Locator("#formDuracionCitas")).ToBeVisibleAsync();

        // When: Llenar datos de duración
        await Page.Locator("input[name='duracion']").FillAsync("2");
        await Page.Locator("input[name='frecuenciaNotificaciones']").FillAsync("30");

// And: Envía formulario
        await Page.Locator("#botonModificarDuracion").ClickAsync();

        // Then: Mensaje de éxito visible
        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("Registro exitoso");

        Assert.True(
            successMessage,
            $"Se esperaba mensaje de éxito.");
    }

    #endregion

    #region Pruebas Restauradas

    [Fact]
    public async Task Empleado_ProgramarClase()
    {
        // Given: Empleado logueado
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // When: Navega a registro de clases programadas
        await Page.GotoAsync($"{BaseUrl}/Clases/registroClasesProgramadas");

        // Then: Calendario visible (usa locator que tiene espera implícita)
        await Assertions.Expect(Page.Locator("#calendarGrid")).ToBeVisibleAsync();

        // When: Selecciona día disponible del calendario
        var diaDisponible = Page.Locator(".calendar-cell:not(.calendar-cell--disabled)").Nth(0);
        await diaDisponible.ClickAsync();

        // Then: ScheduleViewer se renderiza con horarios
        await Assertions.Expect(Page.Locator(".schedule-viewer__item").Nth(0)).ToBeVisibleAsync();

        // When: Llenar formulario de clase programada
        await Page.Locator("#inputClase").SelectOptionAsync(new SelectOptionValue { Index = 1 });
        await Page.Locator("#inputEntrenador").SelectOptionAsync(new SelectOptionValue { Index = 1 });
        await Page.Locator("#inputCupoMaximo").FillAsync("20");

        // And: Selecciona horario disponible del schedule viewer
        var horarioDisponible = Page.Locator(".schedule-viewer__item--disponible").Nth(0);
        await Assertions.Expect(horarioDisponible).ToBeVisibleAsync();
        await horarioDisponible.ClickAsync();

        // And: Envía formulario
        await Page.Locator("#registrarClaseProgramadaBtn").ClickAsync();

        // Then: Mensaje de éxito visible en la UI
        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("Clase programada registrada exitosamente");

        Assert.True(
            successMessage,
            $"Se esperaba mensaje de éxito. URL actual: {Page.Url}");
    }

    [Fact]
    public async Task Empleado_InscribirClienteAClase()
    {
        // Given: Empleado logueado, navega a /Clases/inscripcionAClases
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // When: Navega a inscripción de clases y selecciona cliente y clase
        await Page.GotoAsync($"{BaseUrl}/Clases/inscripcionAClases");
        await Assertions.Expect(Page.Locator("#comboCliente")).ToBeVisibleAsync();

        // Seleccionar un cliente
        await Page.Locator("#comboCliente").SelectOptionAsync(new SelectOptionValue { Index = 1 });

        // Seleccionar una clase
        await Page.Locator("#comboClases").SelectOptionAsync(new SelectOptionValue { Index = 1 });

        await Page.ClickAsync("button.btn-primary[type='submit']");

        // Then: Verificar mensaje de éxito en SweetAlert
        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("Inscripción exitosa");

        Assert.True(
            successMessage,
            $"Se esperaba mensaje de éxito");
    }

    [Fact]
    public async Task Empleado_RegistrarCita()
    {
        // Given: Empleado logueado, navega a /Citas/registrarCita
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        // When: Completa formulario de cita y envía
        await Page.GotoAsync($"{BaseUrl}/registrarCita?page=asignar");
        await Assertions.Expect(Page.Locator("#formRegistrarCita")).ToBeVisibleAsync();

        
        // Seleccionar tipo de cita: "Medicion"
        await Page.SelectOptionAsync("#inputTipoCita", "Medicion");
        
        // Llenar fecha inicio
        await Page.FillAsync("#inputFechaInicio", "2027-06-15T14:00");
        
        // Llenar fecha fin
        await Page.FillAsync("#inputFechaFin", "2027-06-15T15:00");
        
        // Seleccionar cliente (Index = 1 para evitar opción por defecto)
        await Page.SelectOptionAsync("#inputCliente", new SelectOptionValue { Index = 1 });

        // Seleccionar entrenador (Index = 1 para evitar opción por defecto)
        await Page.SelectOptionAsync("#inputEntrenador", new SelectOptionValue { Index = 1 });
        
        // Click en botón submit "Agendar"
        await Page.ClickAsync("button.btn-primary.fix-margin");

        // Then: Cita registrada exitosamente
        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("Registro exitoso");

        Assert.True(
            successMessage,
            $"Se esperaba mensaje de éxito. URL actual: {Page.Url}");
    }

    [Fact]
    public async Task Empleado_ModificarCita()
    {
        // Given: Empleado logueado
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // When: Navega a modificar cita
        await Page.GotoAsync($"{BaseUrl}/modificarCita");

        // Then: Formulario visible
        await Assertions.Expect(Page.Locator("#formModificarCita")).ToBeVisibleAsync();

        // When: Selecciona cliente (primero obtener el valor del primer option real)
        var valorCliente = await Page.Locator("#inputCliente option").Nth(1).GetAttributeAsync("value");
        await Page.Locator("#inputCliente").SelectOptionAsync(valorCliente);

        // Then: Input de cita se habilita, seleccionarlo
        await Assertions.Expect(Page.Locator("#inputCita")).ToBeEnabledAsync();
        var valorCita = await Page.Locator("#inputCita option").Nth(1).GetAttributeAsync("value");
        await Page.Locator("#inputCita").SelectOptionAsync(valorCita);

        // Then: Campos se habilitan, modificar fecha
        await Assertions.Expect(Page.Locator("#inputFechaInicio")).ToBeEnabledAsync();
        await Page.Locator("#inputFechaInicio").FillAsync("2027-06-20T10:00");

        // And: Modificar fecha fin
        await Page.Locator("#inputFechaFin").FillAsync("2027-06-20T11:00");

        // And: Envía formulario
        await Page.Locator("button.btn-primary[type='submit']").ClickAsync();

        // Then: Mensaje de éxito visible
        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("Modificacion exitosa");

        Assert.True(
            successMessage,
            $"Se esperaba mensaje de éxito. URL actual: {Page.Url}");
    }

    [Fact]
    public async Task Empleado_GestionarRutinas()
    {
        // Given: Empleado logueado, navega a /Rutinas/gestionRutinas
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        await Page.GotoAsync($"{BaseUrl}/gestionRutinas");
        await Assertions.Expect(Page.Locator("#formGestionRutinas")).ToBeVisibleAsync();

        // When: Selecciona cliente y entrenador, llena observaciones
        await Page.Locator("#inputUsuario").SelectOptionAsync(new SelectOptionValue { Index = 1 });
        await Page.Locator("#inputEntrenador").SelectOptionAsync(new SelectOptionValue { Index = 1 });
        await Page.Locator("#inputObservaciones").FillAsync("Rutina E2E Test");

        // And: Envía formulario
        await Page.Locator("button.btn-primary[type='submit']").ClickAsync();
        
        // Then: Mensaje de éxito visible en SweetAlert
        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("Registro exitoso");

        Assert.True(
            successMessage,
            $"Se esperaba mensaje de éxito. URL actual: {Page.Url}");
    }

    [Fact]
    public async Task Empleado_AsignarEjerciciosARutina()
    {
        // Given: Empleado logueado
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // When: Navega a Asignacion de Ejercicios
        await Page.GotoAsync($"{BaseUrl}/asignarEjercicios");

        // Then: Formulario visible
        await Assertions.Expect(Page.Locator("#formGestionRutinas")).ToBeVisibleAsync();

        // When: Flujo cascada - seleccionar cliente primero
        await Page.Locator("#inputCliente").SelectOptionAsync(new SelectOptionValue { Index = 1 });

        // Then: inputRutina se habilita, seleccionarlo
        await Assertions.Expect(Page.Locator("#inputRutina")).ToBeEnabledAsync();
        await Page.Locator("#inputRutina").SelectOptionAsync(new SelectOptionValue { Index = 1 });

        // Then: inputEjercicio se habilita, seleccionarlo
        await Assertions.Expect(Page.Locator("#inputEjercicio")).ToBeEnabledAsync();
        await Page.Locator("#inputEjercicio").SelectOptionAsync(new SelectOptionValue { Index = 1 });

        // When: Llenar campos numéricos
        await Page.Locator("#inputSets").FillAsync("3");
        await Page.Locator("#inputRepeticiones").FillAsync("12");

        // And: Envía formulario
        await Page.Locator("button.btn-primary[type='submit']").ClickAsync();

// Then: Mensaje de éxito visible en SweetAlert
        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("Registro exitoso");

        Assert.True(
            successMessage,
            $"Se esperaba mensaje de éxito. URL actual: {Page.Url}");
    }

    #endregion
}