using Microsoft.Playwright;

using BL.Utils.Enums;
using GymWebApp.Tests.E2E.Common;
using GymWebApp.Tests.Integration.Helpers;
using GymWebApp.Tests.SharedHelpers;

namespace GymWebApp.Tests.E2E.Features;

[Collection("E2E HappyPaths")]
public class E2EHappyPathsTests : PlaywrightTestBase
{
    public E2EHappyPathsTests(E2eContainerHelper e2eContainerHelper, PlaywrightHelper playwrightHelper) 
        : base(e2eContainerHelper, playwrightHelper) { }

    private string BaseUrl => E2eContainerHelper.NginxBaseUrl;

    #region 1. Público - Registro de Cuenta

    [Fact]
    public async Task Cliente_CrearCuenta()
    {
        // Given: Usuario en página de registro /signUp
        await Page.GotoAsync($"{BaseUrl}/signUp");

        // When: Completa formulario con email, contraseña y datos requeridos, envía formulario
        var timestamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
        var newEmail = $"testuser{timestamp}@test.com";

        await Page.FillAsync("input[name='correo']", newEmail);
        await Page.FillAsync("input[name='contrasena']", "Test1234*");
        await Page.FillAsync("input[name='ContrasenaConfirmacion']", "Test1234*");
        await Page.FillAsync("input[name='nombre']", "Test");
        await Page.FillAsync("input[name='apellido']", "User");
        await Page.FillAsync("input[name='fechaDeNacimiento']", "2000-01-15");
        await Page.FillAsync("input[name='direccion']", "Calle Test 123");
        await Page.FillAsync("input[name='curp']", "ABCD123456HMBCDN09");
        await Page.FillAsync("input[name='telefono']", "5551234567");
        await Page.ClickAsync("button.sign");

        // Then: Muestra el mensaje de éxito exacto del backend en #validationSummary
        var validationError = Page.Locator("#validationSummary");
        await Assertions.Expect(validationError).ToBeVisibleAsync();
        await Assertions.Expect(validationError).ToHaveTextAsync("Usuario registrado exitosamente");
    }

    #endregion

    #region 2. Cliente - Login

    [Fact]
    public async Task Cliente_Login_AccedeDashboard()
    {
        // Given: Usuario en página de login /signIn
        await Page.GotoAsync($"{BaseUrl}/signIn");

        // When: Ingresa credenciales de cliente y envía formulario
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserClienteEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserClientePassword);
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
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserClienteEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserClientePassword);
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
        
        var yearCheckbox = Page.Locator("#year2025");
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
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
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
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
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

        await Page.Locator("div.swal2-container").WaitForAsync();
        // Then: Mensaje de éxito visible en la UI
        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("Registro exitoso");
        Assert.True(
            successMessage,
            $"Se esperaba mensaje de éxito. URL actual: {Page.Url}");
    }

    #endregion

    #region 7. Empleado - Gestionar Duración Citas Medición

    [Fact]
    public async Task Empleado_GestionarDuracionCitasMedicion()
    {
        // Given: Empleado logueado
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
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
        await Page.Locator("div.swal2-container").WaitForAsync();
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
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // When: Navega a registro de clases programadas
        await Page.GotoAsync($"{BaseUrl}/Clases/registroClasesProgramadas");
    
        // Then: Calendario visible (usa locator que tiene espera implícita)
        await Assertions.Expect(Page.Locator("#calendarGrid")).ToBeVisibleAsync();

        // When: Obtiene un horario disponible futuro desde la BD para robustez ante días festivos
        var connectionString = E2eContainerHelper.Instance.HostConnectionString;
        var slot = await HorariosHelper.ObtenerUnHorarioDisponible(
            connectionString!, FiltroFecha.Mayor, FiltroHora.SinFiltro);
        Assert.True(slot.HasValue, "No hay horarios disponibles posteriores a hoy en la BD.");

        // And: Navega el calendario a la fecha obtenida y selecciona el día exacto
        var registroPage = new PageModels.RegistroClasesProgramadasPage(Page);
        await registroPage.SelectDateAsync(slot.Value.FechaDisponible);

        // Then: ScheduleViewer se renderiza con horarios
        await Assertions.Expect(Page.Locator(".schedule-viewer__item").Nth(0)).ToBeVisibleAsync();

        // When: Llenar formulario de clase programada
        await Page.Locator("#inputClase").SelectOptionAsync(new SelectOptionValue { Index = 1 });
        await Page.Locator("#inputEntrenador").SelectOptionAsync(new SelectOptionValue { Index = 1 });
        await Page.Locator("#inputCupoMaximo").FillAsync("20");

        // And: Selecciona horario disponible del schedule viewer
        var horarioDisponible = Page.Locator("button.schedule-viewer__item--disponible").Nth(0);
        await Assertions.Expect(horarioDisponible).ToBeVisibleAsync();
        await horarioDisponible.ClickAsync();
        var modalConfirmacion = Page.Locator("button.swal2-confirm.swal2-styled");
        await Assertions.Expect(modalConfirmacion).ToBeVisibleAsync();
        await modalConfirmacion.ClickAsync();
        // And: Envía formulario
        await Page.Locator("#registrarClaseProgramadaBtn").ClickAsync();
        await Page.Locator("div.swal2-container").WaitForAsync();
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
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // Setup: Registrar clase programada para asegurar que comboClases tenga opciones con horarios disponibles
        var datosClase = await ClasesProgramadasHelper.GenerarClaseProgramadaAsync(
            E2eContainerHelper.HostConnectionString);

        var (claseRegistrada, idClaseProgramada) = await ClasesProgramadasHelper.RegistrarClaseProgramadaAsync(
            E2eContainerHelper.HostConnectionString, datosClase);

        // When: Navega a inscripción de clases y selecciona cliente y clase
        var inscripcionPage = new PageModels.InscripcionAClasesPage(Page);
        await inscripcionPage.GoToAsync(BaseUrl);
        await Assertions.Expect(inscripcionPage.ClientSelect).ToBeVisibleAsync();
        var connectionString = E2eContainerHelper.Instance.HostConnectionString;
        var minHoraRow = await DatabaseHelper.ExecuteQuerySingleAsync(
            connectionString,
            "SELECT horaInicio AS MinHora FROM horasLaborales WHERE idHora = @idHora",
            new Dictionary<string, object?>
            {
                { "@idHora", claseRegistrada.fkHoraLaboral }
            }
        );
        var minHora = (TimeSpan)minHoraRow!["MinHora"];
        
        var clockDate = claseRegistrada.fechaDeLaClase.Value
            .ToDateTime(TimeOnly.FromTimeSpan(minHora));
        await Page.Clock.SetFixedTimeAsync(clockDate);
        // Seleccionar un cliente
        await inscripcionPage.SelectClientAsync(new SelectOptionValue { Index = 1 });

        // Seleccionar la clase exacta que registramos. La UI posiciona automáticamente
        // el calendario en la fecha de la clase y renderiza el horario correspondiente.
        await inscripcionPage.SelectClassAsync(claseRegistrada.fkClase!.Value.ToString());

        // Seleccionar el horario exacto por ID de clase programada
        await inscripcionPage.SelectScheduleByIdAsync(idClaseProgramada.ToString());

        // Aceptar el diálogo de confirmación de pre-reserva
        var modalConfirmacion = Page.Locator("button.swal2-confirm.swal2-styled");
        await Assertions.Expect(modalConfirmacion).ToBeVisibleAsync();
        await modalConfirmacion.ClickAsync();

        // Esperar a que la pre-reserva termine y el hidden input #idProgramacionClase se setee
        await inscripcionPage.WaitForScheduleSelectionAsync();

        await inscripcionPage.SubmitAsync();
        string innerHtml = await Page.Locator("div.swal2-container").InnerHTMLAsync();
        //var pageContent = await Page.ContentAsync();
        var successMessage = innerHtml.Contains("Inscripción exitosa");


        Assert.True(
            successMessage,
            $"Se esperaba mensaje de éxito");
    }

    [Fact]
    public async Task Empleado_RegistrarCita()
    {
        // Given: Empleado logueado, navega a /Citas/registrarCita
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
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
        
        // Seleccionar cliente y entrenador usando CitasHelper
        var clienteId = await CitasHelper.GetClienteIdAsync(E2eContainerHelper.HostConnectionString);
        var entrenadorId = await CitasHelper.GetEntrenadorIdAsync(E2eContainerHelper.HostConnectionString);
        await Page.SelectOptionAsync("#inputCliente", clienteId);
        await Page.SelectOptionAsync("#inputEntrenador", entrenadorId);
        
        // Click en botón submit "Agendar"
        await Page.ClickAsync("button.btn-primary.fix-margin");
        await Page.Locator("div.swal2-container").WaitForAsync();
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
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        await Assertions.Expect(Page.Locator("#sidebar")).ToBeVisibleAsync();

        // Setup: Registrar una cita en BD para asegurar que hay opciones en el dropdown
        var citaRegistrada = await CitasHelper.GenerarYRegistrarCitaObject(E2eContainerHelper.HostConnectionString);

        // When: Navega a modificar cita
        await Page.GotoAsync($"{BaseUrl}/modificarCita");

        // Then: Formulario visible
        await Assertions.Expect(Page.Locator("#formModificarCita")).ToBeVisibleAsync();

        // Select the user that has scheduled appointments
        await Page.SelectOptionAsync("#inputCliente", citaRegistrada.fkCliente);

        // Then: Input de cita se habilita, seleccionarlo
        
        await Assertions.Expect(Page.Locator("#inputCita")).ToBeVisibleAsync();
        var valorCita = await Page.Locator("#inputCita option").Nth(1).GetAttributeAsync("value");
        await Page.Locator("#inputCita").SelectOptionAsync(valorCita);

        // Then: Campos se habilitan, modificar fecha
        await Assertions.Expect(Page.Locator("#inputFechaInicio")).ToBeEnabledAsync();

        await Page.Locator("#inputFechaInicio").FillAsync("2027-06-20T10:00");
        // And: Modificar fecha fin
        await Page.Locator("#inputFechaFin").FillAsync("2027-06-20T11:00");
        var entrenadorSeleccionado = await Page.Locator("#inputEntrenador option").Nth(1).GetAttributeAsync("value");
        await Page.Locator("#inputEntrenador").SelectOptionAsync(entrenadorSeleccionado);
        // And: Envía formulario
        await Page.Locator("button.btn-primary[type='submit']").ClickAsync();

        
        // Wait for SweetAlert to appear
        await Page.Locator("div.swal2-container").WaitForAsync();

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
        // Given: Empleado logueado
        await Page.GotoAsync($"{BaseUrl}/signIn");
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
        await Page.ClickAsync("button.sign");
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);

        // When: Navega a gestión de rutinas
        await Page.GotoAsync($"{BaseUrl}/gestionRutinas");
        await Assertions.Expect(Page.Locator("#formGestionRutinas")).ToBeVisibleAsync();

        // Select cliente
        await Page.Locator("#inputUsuario").SelectOptionAsync(new SelectOptionValue { Index = 1 });

        // Select entrenador
        await Page.Locator("#inputEntrenador").SelectOptionAsync(new SelectOptionValue { Index = 1 });

        // Fill observaciones
        await Page.Locator("#inputObservaciones").FillAsync("Rutina E2E Test");

        // Submit
        await Page.Locator("button.btn-primary[type='submit']").ClickAsync();

        // Then: Mensaje de éxito visible en SweetAlert
        await Page.Locator("div.swal2-container").WaitForAsync();
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
        await Page.FillAsync("input[name='correo']", E2ETestSettings.TestUserEmail);
        await Page.FillAsync("input[name='contrasena']", E2ETestSettings.TestUserPassword);
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
        await Page.Locator("div.swal2-container").WaitForAsync();
        var pageContent = await Page.ContentAsync();
        var successMessage = pageContent.Contains("Registro exitoso");

        Assert.True(
            successMessage,
            $"Se esperaba mensaje de éxito. URL actual: {Page.Url}");
    }

    #endregion
}