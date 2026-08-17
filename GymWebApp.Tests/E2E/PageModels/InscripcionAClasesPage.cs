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

    public Task SelectClassAsync(string value) => ClassSelect.SelectOptionAsync(value);

    public Task SelectClientAsync(string value) => ClientSelect.SelectOptionAsync(value);

    public Task SelectDateAsync(DateOnly date) =>
        Calendar.NavigateToMonthYearAsync(date.ToDateTime(TimeOnly.MinValue));

    public Task SelectFirstScheduleAsync() => ScheduleItems.First.ClickAsync();

    public Task SubmitAsync() => SubmitButton.ClickAsync();
}
