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

        // Then: Verificar que el gráfico se mostró (errorMessageContainer vacío)
        var errorMessage = Page.Locator("#errorMessageContainer");
        await Assertions.Expect(errorMessage).Not.ToBeVisibleAsync();
        
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
        await Assertions.Expect(Page.Locator("#formGestionRutinas")).ToBeVisibleAsync();

        // When: Llenar datos de duración
        await Page.Locator("input[name='duracion']").FillAsync("2");
        await Page.Locator("input[name='frecuenciaNotificaciones']").FillAsync("30");

// And: Envía formulario
        await Page.Locator("button.btn-primary[type='submit']").ClickAsync();

        // Then: Mensaje de éxito visible
        await Assertions.Expect(
            Page.Locator("text=/Registro exitoso/i")
        ).ToBeVisibleAsync();
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
        await Page.GotoAsync($"{BaseUrl}/registroClasesProgramadas");

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
        await Page.Locator("button[type='submit']").ClickAsync();

        // Then: Mensaje de éxito visible en la UI
        await Assertions.Expect(
            Page.Locator("text=/exitosamente/i")
        ).ToBeVisibleAsync();
    }

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
        var successMessage = pageContent.Contains("exitosa") ||
                          pageContent.Contains("Inscripción exitosa");

        Assert.True(
            successMessage || Page.Url.Contains("empleados") || Page.Url.Contains("clase"),
            $"Se esperaba mensaje de éxito o redirección. URL actual: {Page.Url}");
    }

    [Fact]
    public async Task Empleado_RegistrarCita()
    {
        // Given: Empleado logueado, navega a /registrarCita
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");
        // When: Completa formulario de cita y envía
        await Page.GotoAsync($"{BaseUrl}/registrarCita");
        await Assertions.Expect(Page.Locator("#formGestionRutinas")).ToBeVisibleAsync();

        
        // Seleccionar tipo de cita: "Medicion" (value="Medicion")
        await Page.SelectOptionAsync("select[id*='inputTipoCita']", "Medicion");
        
        // Llenar fecha inicio
        await Page.FillAsync("input[id*='inputFechaInicio']", "2027-06-15T14:00");
        
        // Llenar fecha fin
        await Page.FillAsync("input[id*='inputFechaFin']", "2027-06-15T15:00");
        
        // Seleccionar cliente (Index = 1 = segundo option)
        await Page.Locator("select[id='inputCliente']").SelectOptionAsync(new[] { "1" });
        
        // Seleccionar entrenador (Index = 1 = segundo option)
        await Page.Locator("select[id='inputEntrenador']").Nth(0).SelectOptionAsync(new[] { "1" });
        
        // Click en botón submit "Agendar"
        await Page.ClickAsync("button.btn-primary.fix-margin");

        // Then: Cita registrada exitosamente
        await Assertions.Expect(Page.Locator("select[name='fkUsuario']")).ToBeVisibleAsync();

        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("Registro exitoso");

        Assert.True(
            successMessage ,
            $"Se esperaba mensaje de éxito o redirección. URL actual: {Page.Url}");
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
        await Assertions.Expect(Page.Locator("#formGestionRutinas")).ToBeVisibleAsync();

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
        await Assertions.Expect(
            Page.Locator("text=/Consulta exitosa/i")
        ).ToBeVisibleAsync();
    }

    [Fact]
    public async Task Empleado_GestionarRutinas()
    {
        // Given: Empleado logueado, navega a /gestionRutinas
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", _employeeEmail);
        await Page.FillAsync("input[name='contrasena']", _employeePassword);
        await Page.ClickAsync("button.sign");

        
        await Page.GotoAsync($"{BaseUrl}/gestionRutinas");
        await Assertions.Expect(Page.Locator("#formGestionRutinas")).ToBeVisibleAsync();
        // Then: Formulario visible
        await Assertions.Expect(Page.Locator("#formGestionRutinas")).ToBeVisibleAsync();

        // When: Selecciona cliente y entrenador, llena observaciones
        await Page.Locator("#inputUsuario").SelectOptionAsync(new SelectOptionValue { Index = 1 });
        await Page.Locator("#inputEntrenador").SelectOptionAsync(new SelectOptionValue { Index = 1 });
        await Page.Locator("#inputObservaciones").FillAsync("Rutina E2E Test");

        // And: Envía formulario
        await Page.Locator("button.btn-primary[type='submit']").ClickAsync();
        
        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("Registro exitoso");

        Assert.True(
            successMessage,
            $"Se esperaba mensaje de éxito o redirección. URL actual: {Page.Url}");
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
        await Page.GotoAsync($"{BaseUrl}/AsignarEjercicios");

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

// Then: Mensaje de éxito visible
            await Assertions.Expect(
            Page.Locator("text=/Registro exitoso/i")
        ).ToBeVisibleAsync();
    }

    #endregion
}