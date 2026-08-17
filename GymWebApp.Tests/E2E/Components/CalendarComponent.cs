using System.Globalization;
using Microsoft.Playwright;

namespace GymWebApp.Tests.E2E.Components;

/// <summary>
/// Component Object for the calendar shared by the E2E pages.
/// The component deliberately depends only on the DOM contract shared by
/// Calendar and CalendarInscripcion.
/// </summary>
public sealed class CalendarComponent
{
    private static readonly string[] SpanishMonths =
    [
        "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
        "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    ];

    private readonly IPage _page;

    public CalendarComponent(IPage page)
    {
        _page = page ?? throw new ArgumentNullException(nameof(page));
    }

    public ILocator Calendar => _page.Locator("#calendar");
    public ILocator MonthButton => _page.Locator("#monthButton");
    public ILocator YearButton => _page.Locator("#yearButton");

    public async Task WaitForCalendarRenderedAsync()
    {
        await MonthButton.WaitForAsync(new LocatorWaitForOptions
        {
            State = WaitForSelectorState.Attached,
            Timeout = 15_000
        });
    }

    public async Task<(int Month, int Year)> GetVisibleMonthYearAsync()
    {
        await WaitForCalendarRenderedAsync();

        var monthText = (await MonthButton.InnerTextAsync()).Trim();
        var yearText = (await YearButton.InnerTextAsync()).Trim();
        var month = Array.FindIndex(
            SpanishMonths,
            value => string.Equals(value, monthText, StringComparison.OrdinalIgnoreCase)) + 1;

        if (month == 0)
        {
            throw new InvalidOperationException($"El calendario mostró un mes no reconocido: '{monthText}'.");
        }

        if (!int.TryParse(yearText, NumberStyles.Integer, CultureInfo.InvariantCulture, out var year))
        {
            throw new InvalidOperationException($"El calendario mostró un año no válido: '{yearText}'.");
        }

        return (month, year);
    }

    public async Task NavigateToMonthYearAsync(DateTime targetDate)
    {
        await WaitForCalendarRenderedAsync();
        var visible = await GetVisibleMonthYearAsync();

        if (visible.Year != targetDate.Year)
        {
            await YearButton.ClickAsync();
            await _page.WaitForTimeoutAsync(250);

            var nextMoves = 0;
            var previousMoves = 0;

            while (!await IsYearVisibleAsync(targetDate.Year))
            {
                var rangeStart = await GetYearsRangeStartAsync();
                if (targetDate.Year > rangeStart)
                {
                    if (++nextMoves > 12)
                    {
                        throw new InvalidOperationException("No se pudo encontrar el año destino en el calendario.");
                    }

                    await _page.Locator("#nextButton").ClickAsync();
                }
                else
                {
                    if (++previousMoves > 12)
                    {
                        throw new InvalidOperationException("No se pudo encontrar el año destino en el calendario.");
                    }

                    await _page.Locator("#prevButton").ClickAsync();
                }

                await _page.WaitForTimeoutAsync(250);
            }

            await YearCell(targetDate.Year).ClickAsync();
            await _page.WaitForTimeoutAsync(250);

            await MonthCell(targetDate.Month).ClickAsync();
            await _page.WaitForTimeoutAsync(250);
        }

        var dateSelector = $"button[data-fecha='{targetDate:yyyy-MM-dd}']";
        await _page.Locator(dateSelector).ClickAsync();
        await _page.WaitForTimeoutAsync(250);

        var finalVisible = await GetVisibleMonthYearAsync();
        AssertMonthYear(finalVisible, targetDate);
    }

    public Task NavigateToDateAsync(DateTime targetDate) => NavigateToMonthYearAsync(targetDate);

    public async Task<ILocator> SelectFirstAvailableDayAsync()
    {
        await WaitForCalendarRenderedAsync();
        var day = _page.Locator("button.calendar-cell:not(.calendar-cell--disabled)").First;
        await day.ClickAsync();
        await _page.WaitForTimeoutAsync(250);
        return day;
    }

    public async Task<string?> SelectHorarioDestinoAsync()
    {
        const string selectScheduleScript = @"() => {
            const items = Array.from(document.querySelectorAll(
                '.schedule-viewer__item:not(.schedule-viewer__item--ocupado)'));
            const item = items.find(element => element.dataset.idClaseProgramada);
            if (!item) return null;
            item.classList.add('schedule-viewer__item--selected');
            return item.dataset.idClaseProgramada ?? null;
        }";

        return await _page.EvaluateAsync<string?>(selectScheduleScript);
    }

    /// <summary>
    /// Navega al mes/año de <paramref name="targetDate"/> y marca el horario
    /// cuyo <c>data-id-clase-programada</c> sea exactamente <paramref name="idClaseProgramada"/>.
    /// </summary>
    /// <param name="idClaseProgramada">ID de la clase programada a seleccionar.</param>
    /// <param name="targetDate">Fecha del día que debe estar visible en el calendario.</param>
    /// <returns>El ID de la clase programada seleccionada, o null si no se encontró el elemento.</returns>
    public async Task<string?> SelectHorarioDestinoByIdAsync(string idClaseProgramada, DateOnly targetDate)
    {
        await NavigateToMonthYearAsync(targetDate.ToDateTime(TimeOnly.MinValue));
        await _page.WaitForTimeoutAsync(300);

        // El ID se pasa como argumento para evitar inyección de script.
        return await _page.EvaluateAsync<string?>(@"
            (id) => {
                const item = document.querySelector(
                    `.schedule-viewer__item[data-id-clase-programada='${id}']`);
                if (!item) return null;
                item.classList.add('schedule-viewer__item--selected');
                return item.dataset.idClaseProgramada ?? null;
            }", idClaseProgramada);
    }

    private ILocator YearCell(int year) =>
        _page.Locator("button.calendar-cell--year")
            .Filter(new LocatorFilterOptions { HasText = year.ToString(CultureInfo.InvariantCulture) });

    private ILocator MonthCell(int month) =>
        _page.Locator("button.calendar-cell--month")
            .Filter(new LocatorFilterOptions { HasText = SpanishMonths[month - 1] });

    private async Task<bool> IsYearVisibleAsync(int year)
    {
        return await YearCell(year).CountAsync() > 0;
    }

    private async Task<int> GetYearsRangeStartAsync()
    {
        var years = _page.Locator("button.calendar-cell--year");
        var firstYear = await years.First.InnerTextAsync();
        return int.Parse(firstYear.Trim(), CultureInfo.InvariantCulture);
    }

    private static void AssertMonthYear((int Month, int Year) visible, DateTime targetDate)
    {
        if (visible.Month != targetDate.Month || visible.Year != targetDate.Year)
        {
            throw new InvalidOperationException(
                $"El calendario quedó en {visible.Month}/{visible.Year}, se esperaba {targetDate.Month}/{targetDate.Year}.");
        }
    }
}
