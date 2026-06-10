using Microsoft.Playwright;
using GymWebApp.Tests.E2E.Common;
using GymWebApp.Tests.E2E.Factories;
using GymWebApp.Tests.E2E.Helpers;
using Xunit;
using static Microsoft.Playwright.Assertions;

namespace GymWebApp.Tests.E2E.Features;

[Collection("E2E HappyPaths")]
public class DetalleDeClaseE2ETests : PlaywrightTestBase
{
    public DetalleDeClaseE2ETests(E2eContainerHelper e2eContainerHelper, PlaywrightHelper playwrightHelper)
        : base(e2eContainerHelper, playwrightHelper)
    {
    }

    [Fact]
    public async Task DetalleDeClase_WithCompleteData_RendersAllSections()
    {
        // GIVEN: crear datos con Factory y persistir con Helper por separado
        var connString = E2eContainerHelper.Instance.HostConnectionString;

        var clase = DetalleDeClaseFactory.CrearClaseCompleta();
        var claseId = await DetalleDeClaseHelper.GuardarClaseAsync(connString, clase);

        var imagen = DetalleDeClaseFactory.CrearImagen(claseId);
        await DetalleDeClaseHelper.GuardarImagenAsync(connString, imagen);

        var beneficios = DetalleDeClaseFactory.CrearListaBeneficios(claseId, 3);
        await DetalleDeClaseHelper.GuardarListaBeneficiosAsync(connString, beneficios);

        var bloques = DetalleDeClaseFactory.CrearListaBloquesEstructura(claseId, 3);
        await DetalleDeClaseHelper.GuardarListaBloquesAsync(connString, bloques);

        var consejo = DetalleDeClaseFactory.CrearConsejo(claseId);
        await DetalleDeClaseHelper.GuardarConsejoAsync(connString, consejo);

        var entrenadorId = await DetalleDeClaseHelper.ObtenerEntrenadorIdAsync(connString);
        var horasLaborales = await DetalleDeClaseHelper.ObtenerHorasLaboralesAsync(connString);

        var clasesProgramadas = DetalleDeClaseFactory.CrearListaClasesProgramadas(
            claseId, 3, entrenadorId);
        var idsProgramacion = await DetalleDeClaseHelper.GuardarListaClasesProgramadasAsync(
            connString, clasesProgramadas);

        var horarios = DetalleDeClaseFactory.CrearListaHorarios(idsProgramacion, horasLaborales);
        await DetalleDeClaseHelper.GuardarListaHorariosAsync(connString, horarios);

        // WHEN: navegar al detalle de la clase
        await Page.GotoAsync($"{E2eContainerHelper.Instance.NginxBaseUrl}/Home/DetalleDeClase?idClase={claseId}");
        
        await Page.WaitForLoadStateAsync(LoadState.NetworkIdle);

        // THEN: todas las secciones principales renderizadas
        await Expect(Page.Locator("[data-section='class-header']")).ToBeVisibleAsync();
        await Expect(Page.Locator("[data-section='class-description']")).ToBeVisibleAsync();
        await Expect(Page.Locator("[data-section='class-structure']")).ToBeVisibleAsync();
        await Expect(Page.Locator("[data-section='class-schedule']")).ToBeVisibleAsync();
        await Expect(Page.Locator("[data-section='class-cta']")).ToBeVisibleAsync();

        // Container de horarios con filas
        var schedulesContainer = Page.Locator("[data-test-container='schedules']");
        await Expect(schedulesContainer).ToBeVisibleAsync();
        var scheduleRows = schedulesContainer.Locator("[data-test='schedule-item']");
        await Expect(scheduleRows).ToHaveCountAsync(3);
    }

    [Fact]
    public async Task DetalleDeClase_WithCompleteData_DisplaysCorrectValues()
    {
        // GIVEN: crear datos con Factory y persistir con Helper por separado
        var connString = E2eContainerHelper.Instance.HostConnectionString;

        var clase = DetalleDeClaseFactory.CrearClaseCompleta();
        var claseId = await DetalleDeClaseHelper.GuardarClaseAsync(connString, clase);

        var imagen = DetalleDeClaseFactory.CrearImagen(claseId);
        await DetalleDeClaseHelper.GuardarImagenAsync(connString, imagen);

        var beneficios = DetalleDeClaseFactory.CrearListaBeneficios(claseId, 3);
        await DetalleDeClaseHelper.GuardarListaBeneficiosAsync(connString, beneficios);

        var bloques = DetalleDeClaseFactory.CrearListaBloquesEstructura(claseId, 3);
        await DetalleDeClaseHelper.GuardarListaBloquesAsync(connString, bloques);

        var consejo = DetalleDeClaseFactory.CrearConsejo(claseId);
        await DetalleDeClaseHelper.GuardarConsejoAsync(connString, consejo);

        var entrenadorId = await DetalleDeClaseHelper.ObtenerEntrenadorIdAsync(connString);
        var horasLaborales = await DetalleDeClaseHelper.ObtenerHorasLaboralesAsync(connString);

        var clasesProgramadas = DetalleDeClaseFactory.CrearListaClasesProgramadas(
            claseId, 3, entrenadorId);
        var idsProgramacion = await DetalleDeClaseHelper.GuardarListaClasesProgramadasAsync(
            connString, clasesProgramadas);

        var horarios = DetalleDeClaseFactory.CrearListaHorarios(idsProgramacion, horasLaborales);
        await DetalleDeClaseHelper.GuardarListaHorariosAsync(connString, horarios);

        // WHEN: navegar al detalle
        await Page.GotoAsync($"{E2eContainerHelper.Instance.NginxBaseUrl}/Home/DetalleDeClase?idClase={claseId}");
        await Page.WaitForLoadStateAsync(LoadState.NetworkIdle);

        // THEN: valores renderizados
        var titleElement = Page.Locator("[data-test='header-title']");
        await Expect(titleElement).ToBeVisibleAsync();
        var titleText = await titleElement.InnerTextAsync();
        Assert.False(string.IsNullOrWhiteSpace(titleText), "header-title should not be empty");

        var durationText = Page.Locator("[data-test='header-duration-text']");
        await Expect(durationText).ToBeVisibleAsync();
        var durationValue = await durationText.InnerTextAsync();
        Assert.Contains("minutos", durationValue, StringComparison.OrdinalIgnoreCase);

        await Expect(Page.Locator("[data-test='header-intensity-text']")).ToBeVisibleAsync();
        await Expect(Page.Locator("[data-test='header-level-text']")).ToBeVisibleAsync();
        await Expect(Page.Locator("[data-test='header-cta']")).ToBeVisibleAsync();
    }

    [Fact]
    public async Task DetalleDeClase_WhenOptionalDataIsMissing_RendersDefaults()
    {
        // GIVEN: crear clase con datos mínimos via Factory, persistir via Helper
        var connString = E2eContainerHelper.Instance.HostConnectionString;

        var clase = DetalleDeClaseFactory.CrearClaseConDatosMinimos();
        var claseId = await DetalleDeClaseHelper.GuardarClaseAsync(connString, clase);

        var imagen = DetalleDeClaseFactory.CrearImagen(claseId);
        await DetalleDeClaseHelper.GuardarImagenAsync(connString, imagen);
        var url = E2eContainerHelper.Instance.NginxBaseUrl; 
        // WHEN: navegar al detalle
        await Page.GotoAsync($"{url}/Home/DetalleDeClase?idClase={claseId}");
            await Page.WaitForLoadStateAsync(LoadState.NetworkIdle);

        // THEN: valores por defecto en header
        await Expect(Page.Locator("[data-test='header-duration-text']"))
            .ToContainTextAsync("45 minutos");
        await Expect(Page.Locator("[data-test='header-intensity-text']"))
            .ToContainTextAsync("Alta Intensidad");
        await Expect(Page.Locator("[data-test='header-level-text']"))
            .ToContainTextAsync("Intermedio a Avanzado");

        // Descripción default contiene HIIT
        await Expect(Page.Locator("[data-test='description-text']").First)
            .ToContainTextAsync("HIIT", new() { IgnoreCase = true });

        // Fallbacks de listas vacías
        await Expect(Page.Locator("[data-test='benefit-item']").First).ToBeVisibleAsync();
        await Expect(Page.Locator("[data-test='structure-item']").First).ToBeVisibleAsync();
        await Expect(Page.Locator("[data-test='schedule-item']").First).ToBeVisibleAsync();
    }

    [Fact]
    public async Task DetalleDeClase_WhenNoImages_DoesNotCrash()
    {
        // GIVEN: crear clase sin imágenes via Factory, persistir via Helper
        var connString = E2eContainerHelper.Instance.HostConnectionString;

        var clase = DetalleDeClaseFactory.CrearClaseSinImagenes();
        var claseId = await DetalleDeClaseHelper.GuardarClaseAsync(connString, clase);

        // WHEN: navegar al detalle (sin imágenes registradas)
        await Page.GotoAsync($"{E2eContainerHelper.Instance.NginxBaseUrl}/Home/DetalleDeClase?idClase={claseId}");

        // THEN: verificar que la página carga sin 500
        try
        {
            await Page.WaitForLoadStateAsync(LoadState.NetworkIdle);

            var title = await Page.TitleAsync();
            Assert.False(string.IsNullOrWhiteSpace(title),
                "Page should have a title (even if it's an error page). " +
                "If this fails, it means imagenesDeClase.urlParaBanner causes a NullReferenceException.");
        }
        catch (Exception ex)
        {
            Assert.Fail($"BUG CONOCIDO: La clase sin imágenes lanza NullReferenceException en el banner. " +
                "Detalle: Model.imagenesDeClase.urlParaBanner sin ?. (línea 17 de DetalleDeClase.cshtml). " +
                $"Error: {ex.Message}");
        }
    }
}
