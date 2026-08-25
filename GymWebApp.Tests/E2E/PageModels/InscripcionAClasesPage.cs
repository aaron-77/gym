using Microsoft.Playwright;
using GymWebApp.Tests.E2E.Components;

namespace GymWebApp.Tests.E2E.PageModels;

public sealed class InscripcionAClasesPage
{
    private readonly IPage _page;

    public InscripcionAClasesPage(IPage page)
    {
        _page = page ?? throw new ArgumentNullException(nameof(page));
        Calendar = new CalendarComponent(page);
    }

    public CalendarComponent Calendar { get; }
    public ILocator ClassSelect => _page.Locator("#comboClases");
    public ILocator ClientSelect => _page.Locator("#comboCliente");
    public ILocator ScheduleItems => _page.Locator("button.schedule-viewer__item[data-idhora]");
    public ILocator SubmitButton => _page.Locator("button.btn-primary[type='submit']");

    public async Task GoToAsync(string baseUrl)
    {
        await _page.GotoAsync($"{baseUrl.TrimEnd('/')}/Clases/inscripcionAClases");
        await Calendar.WaitForCalendarRenderedAsync();
    }

    public async Task SelectClassAsync(string value)
    {
        await ClassSelect.SelectOptionAsync(value);

        // Esperar a que handleClaseSelected termine completamente:
        // 1. La API call setea #inputClase y #inputEntrenador
        // 2. El calendario renderiza y el scheduler carga horarios con idClaseProgramada
        await _page.WaitForFunctionAsync(
            $"() => document.getElementById('inputClase').value === '{value}' " +
            "&& document.getElementById('inputEntrenador').value !== '' " +
            "&& document.querySelector('.schedule-viewer__item[data-id-clase-programada]:not([data-id-clase-programada=\"\"])') !== null",
            new PageWaitForFunctionOptions { Timeout = 15_000 });
    }

    public Task SelectClassAsync(SelectOptionValue value) => ClassSelect.SelectOptionAsync(value);

    public Task SelectClientAsync(string value) => ClientSelect.SelectOptionAsync(value);

    public Task SelectClientAsync(SelectOptionValue value) => ClientSelect.SelectOptionAsync(value);

    public Task SelectDateAsync(DateOnly date) =>
        Calendar.NavigateToMonthYearAsync(date.ToDateTime(TimeOnly.MinValue));

    public Task SelectFirstScheduleAsync() => ScheduleItems.First.ClickAsync();

    /// <summary>
    /// Selecciona el horario cuya clase programada tenga el ID exacto
    /// <paramref name="idClaseProgramada"/>. Asume que la UI ya renderizó el scheduler
    /// para la fecha correspondiente (por ejemplo, tras seleccionar la clase).
    /// </summary>
    /// <param name="idClaseProgramada">ID de la clase programada destino.</param>
    public async Task SelectScheduleByIdAsync(string idClaseProgramada)
    {
        var scheduleItem = _page.Locator(
            $".schedule-viewer__item[data-id-clase-programada='{idClaseProgramada}']");
        await scheduleItem.WaitForAsync(new LocatorWaitForOptions
        {
            State = WaitForSelectorState.Visible,
            Timeout = 15_000
        });
        await scheduleItem.ClickAsync();
    }

    /// <summary>
    /// Espera a que la pre-reserva termine y el evento scheduleSelected
    /// setee el hidden input #idProgramacionClase con un valor no vacío.
    /// </summary>
    public async Task WaitForScheduleSelectionAsync()
    {
        await _page.WaitForFunctionAsync(
            "() => document.getElementById('idProgramacionClase').value !== ''",
            new PageWaitForFunctionOptions { Timeout = 15_000 });
    }

    public Task SubmitAsync() => SubmitButton.ClickAsync();
}
