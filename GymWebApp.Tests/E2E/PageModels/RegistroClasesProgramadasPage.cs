using Microsoft.Playwright;
using GymWebApp.Tests.E2E.Components;

namespace GymWebApp.Tests.E2E.PageModels;

public sealed class RegistroClasesProgramadasPage
{
    private readonly IPage _page;

    public RegistroClasesProgramadasPage(IPage page)
    {
        _page = page ?? throw new ArgumentNullException(nameof(page));
        Calendar = new CalendarComponent(page);
    }

    public CalendarComponent Calendar { get; }
    public ILocator Title => _page.Locator("h1");
    public ILocator ClassSelect => _page.Locator("#inputClase");
    public ILocator TrainerSelect => _page.Locator("#inputEntrenador");
    public ILocator MaximumCapacityInput => _page.Locator("#inputCupoMaximo");
    public ILocator RegisterButton => _page.Locator("#registrarClaseProgramadaBtn");
    public ILocator ScheduleItems => _page.Locator(".schedule-viewer__item");

    public async Task GoToAsync(string baseUrl)
    {
        await _page.GotoAsync($"{baseUrl.TrimEnd('/')}/Clases/registroClasesProgramadas");
        await Calendar.WaitForCalendarRenderedAsync();
    }

    public Task SelectDateAsync(DateOnly date) =>
        Calendar.NavigateToMonthYearAsync(date.ToDateTime(TimeOnly.MinValue));

    public Task SelectFirstAvailableDayAsync() => Calendar.SelectFirstAvailableDayAsync();

    public Task SelectClassAsync(string value) => ClassSelect.SelectOptionAsync(value);

    public Task SelectTrainerAsync(string value) => TrainerSelect.SelectOptionAsync(value);

    public Task FillMaximumCapacityAsync(string capacity) => MaximumCapacityInput.FillAsync(capacity);

    public Task RegisterAsync() => RegisterButton.ClickAsync();
}
