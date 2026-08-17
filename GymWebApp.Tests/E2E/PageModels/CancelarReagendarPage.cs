using Microsoft.Playwright;
using GymWebApp.Tests.E2E.Components;
using static Microsoft.Playwright.Assertions;

namespace GymWebApp.Tests.E2E.PageModels;

public sealed class CancelarReagendarPage
{
    private readonly IPage _page;

    public CancelarReagendarPage(IPage page)
    {
        _page = page ?? throw new ArgumentNullException(nameof(page));
        Calendar = new CalendarComponent(page);
    }

    public CalendarComponent Calendar { get; }
    public ILocator Title => _page.Locator("h1");
    public ILocator ClientSelect => _page.Locator("#comboCliente");
    public ILocator EnrollmentSelect => _page.Locator("#comboInscripcion");
    public ILocator RescheduleCheckbox => _page.Locator("#checkReagendar");
    public ILocator ExecuteButton => _page.Locator("#btnEjecutar");
    public ILocator ScheduleItems => _page.Locator(".schedule-viewer__item");

    public async Task GoToAsync(string baseUrl)
    {
        await _page.GotoAsync($"{baseUrl.TrimEnd('/')}/Inscripciones/cancelarReagendar");
        await Calendar.WaitForCalendarRenderedAsync();
    }

    public Task SelectClientAsync(string value) => ClientSelect.SelectOptionAsync(value);

    /// <summary>
    /// Espera a que se carguen las inscripciones y selecciona la opción cuyo
    /// atributo <c>value</c> coincide exactamente con el ID recibido.
    /// </summary>
    /// <param name="idInscripcion">ID de la inscripción a seleccionar.</param>
    public async Task SelectEnrollmentAsync(string idInscripcion)
    {
        await Expect(EnrollmentSelect).ToBeEnabledAsync(new LocatorAssertionsToBeEnabledOptions
        {
            Timeout = 15_000
        });

        await EnrollmentSelect.SelectOptionAsync(idInscripcion);
    }

    public async Task SelectFirstEnrollmentAsync()
    {
        await Expect(EnrollmentSelect).ToBeEnabledAsync(new LocatorAssertionsToBeEnabledOptions
        {
            Timeout = 15_000
        });

        var firstOption = EnrollmentSelect.Locator("option:not([value=''])").First;
        var value = await firstOption.GetAttributeAsync("value");
        await EnrollmentSelect.SelectOptionAsync(value!);
    }

    public Task EnableReschedulingAsync() => RescheduleCheckbox.CheckAsync();

    public Task SelectDateAsync(DateOnly date) =>
        Calendar.NavigateToMonthYearAsync(date.ToDateTime(TimeOnly.MinValue));

    public Task SelectFirstAvailableDayAsync() => Calendar.SelectFirstAvailableDayAsync();

    public Task<string?> SelectDestinationScheduleAsync() => Calendar.SelectHorarioDestinoAsync();

    /// <summary>
    /// Navega al día <paramref name="fecha"/> y selecciona el horario cuya clase programada
    /// tenga el ID exacto <paramref name="idClaseProgramada"/>.
    /// </summary>
    /// <param name="idClaseProgramada">ID de la clase programada destino.</param>
    /// <param name="fecha">Fecha del día destino para posicionar el calendario.</param>
    /// <returns>El ID de la clase programada seleccionada, o null si no se encontró.</returns>
    public async Task<string?> SelectDestinationByIdAsync(string idClaseProgramada, DateOnly fecha)
    {
        return await Calendar.SelectHorarioDestinoByIdAsync(idClaseProgramada, fecha);
    }

    public async Task WaitForSchedulesLoadedAsync()
    {
        var selectableSchedule = _page.Locator(
            ".schedule-viewer__item:not(.schedule-viewer__item--ocupado)[data-id-clase-programada]:not([data-id-clase-programada=''])");
        await selectableSchedule.First.WaitForAsync(new LocatorWaitForOptions
        {
            State = WaitForSelectorState.Attached,
            Timeout = 15_000
        });
    }

    public Task ExecuteAsync() => ExecuteButton.ClickAsync();
}
