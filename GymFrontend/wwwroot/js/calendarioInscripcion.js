




































































































export class CalendarInscripcion {
    constructor(containerId, monthDates = [], selectedDayHandler = null, statusDeterminator = null) {
        this.container = document.getElementById(containerId);
        this.currentDate = new Date();
        this.inputFechaDeLaClase = document.getElementById('fechaDeLaClase')
        this.selectedDate = new Date();
        this.viewMode = 'days'; // 'days', 'months',monthDates 'years'
        this.monthNames = [
            'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
            'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ];
        this.dayNames = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
        this.monthDates = monthDates;
        this.selectedDayHandler = selectedDayHandler;
        this.statusDeterminator = statusDeterminator;
        const fechaFormateada = this.selectedDate.toLocaleDateString('sv-SE'); // Formato YYYY-MM-DD
        this.inputFechaDeLaClase.value = fechaFormateada;
    }

    init() {
        this.bindEvents();
        this.render();
        this.selectFirstDisponibleDay()
    }

    bindEvents() {
        const prevButton = this.container.querySelector('#prevButton');
        const nextButton = this.container.querySelector('#nextButton');
        const monthButton = this.container.querySelector('#monthButton');
        const yearButton = this.container.querySelector('#yearButton');

        prevButton?.addEventListener('click', (ev) => this.navigatePrevious(ev));
        nextButton?.addEventListener('click', (ev) => this.navigateNext(ev));
        monthButton?.addEventListener('click', (ev) => this.showMonthView(ev));
        yearButton?.addEventListener('click', (ev) => this.showYearView(ev));
    }



    isValidPrevNavigation(newDate) {
        let validationResult = true;
        if (newDate < this.currentDate) {
            validationResult = false;
        }
        return validationResult;
    }
    simulateChangeMonth(addedOrSubstractedMonths) {
        const newMonth = new Date(this.selectedDate);
        newMonth.setMonth(this.selectedDate.getMonth() + addedOrSubstractedMonths);
        return newMonth;
    }
    simulateChangeYear(addedOrSubstractedYears) {
        const newYear = new Date(this.selectedDate);
        newYear.setFullYear(this.selectedDate.getFullYear() + addedOrSubstractedYears);
        return newYear;
    }
    navigatePrevious() {
        let resultValidation = false;
        switch (this.viewMode) {
            case 'days':
                const newMonth = this.simulateChangeMonth(-1);
                resultValidation = this.isValidPrevNavigation(newMonth, 'month');
                if (!resultValidation) {
                    return false;
                }
                this.changeMonth(-1);
                break;
            case 'months':
                const newYear = this.simulateChangeYear(-1);
                resultValidation = this.isValidPrevNavigation(newYear, 'year');
                if (!resultValidation) {
                    return false;
                }
                this.changeYear(-1);
                break;
            case 'years':
                const newYear2 = this.simulateChangeYear(-10);
                resultValidation = this.isValidPrevNavigation(newYear2, 'year');
                if (!resultValidation) {
                    return false;
                }
                this.changeYearRange(-10);
                break;
            default:
                resultValidation = false;

        }

        if (!resultValidation) {
            return false;
        }

    }
    navigateNext() {
        switch (this.viewMode) {
            case 'days':
                this.changeMonth(1);
                break;
            case 'months':
                this.changeYear(1);
                break;
            case 'years':
                this.changeYearRange(10);
                break;
        }
        const changedDateEvent = new CustomEvent('changedDate', {
            detail: {
                fecha: this.selectedDate
            }
        });
        document.dispatchEvent(changedDateEvent);
    }
    changeMonth(direction) {
        this.selectedDate.setMonth(this.selectedDate.getMonth() + direction);
        this.renderWithTransition();

        /* $firstDisponibleCalendarDay = this.getFirstDisponibleDay();
        if ($firstDisponibleCalendarDay) {
            this.seleccionarDia($firstDisponibleCalendarDay);
        } */
    }
    
    changeYear(direction) {
        this.selectedDate.setFullYear(this.selectedDate.getFullYear() + direction);
        this.renderWithTransition();
        /* $firstDisponibleCalendarDay = this.getFirstDisponibleDay();
        if ($firstDisponibleCalendarDay) {
            this.seleccionarDia($firstDisponibleCalendarDay);
        } */
    }
    changeYearRange(direction) {
        this.selectedDate.setFullYear(this.selectedDate.getFullYear() + direction);
        this.renderWithTransition();
        $firstDisponibleCalendarDay = this.getFirstDisponibleDay();
        /* if ($firstDisponibleCalendarDay) {
            this.seleccionarDia($firstDisponibleCalendarDay);
        } */
    }
    showMonthView(ev) {
        ev.preventDefault();
        this.viewMode = 'months';
        this.renderWithTransition();
        $firstDisponibleCalendarDay = this.getFirstDisponibleDay();
        /* if ($firstDisponibleCalendarDay) {
            this.seleccionarDia($firstDisponibleCalendarDay);
        } */
    }
    showYearView(ev) {
        ev.preventDefault();
        this.viewMode = 'years';
        this.renderWithTransition();
        $firstDisponibleCalendarDay = this.getFirstDisponibleDay();
        /* if ($firstDisponibleCalendarDay) {
            this.seleccionarDia($firstDisponibleCalendarDay);
        } */
    }
    showDaysView(month) {
        this.selectedDate.setMonth(month);
        this.viewMode = 'days';
        this.renderWithTransition();
        /* $firstDisponibleCalendarDay = this.getFirstDisponibleDay();
        if ($firstDisponibleCalendarDay) {
            this.seleccionarDia($firstDisponibleCalendarDay);
        } */
    }
    selectYear(year) {
        this.selectedDate.setFullYear(year);
        this.viewMode = 'months';
        this.renderWithTransition();
        /* $firstDisponibleCalendarDay = this.getFirstDisponibleDay();
        if ($firstDisponibleCalendarDay) {
            this.seleccionarDia($firstDisponibleCalendarDay);
        } */
    }
    renderWithTransition() {
        const content = this.container.querySelector('.calendar-content');
        content.classList.add('calendar-content--transitioning');
        setTimeout(() => {
            this.render();
            this.selectFirstDisponibleDay()
            content.classList.remove('calendar-content--transitioning');
            content.classList.add('calendar-content--entering');
            setTimeout(() => {
                content.classList.remove('calendar-content--entering');
            }, 300);
        }, 150);
    }
    render() {
        this.updateHeader();
        this.updateContent();
    }
    updateHeader() {
        const monthButton = this.container.querySelector('#monthButton');
        const yearButton = this.container.querySelector('#yearButton');
        monthButton.textContent = this.monthNames[this.selectedDate.getMonth()];
        yearButton.textContent = this.selectedDate.getFullYear();
    }
    updateContent() {
        const grid = this.container.querySelector('#calendarGrid');
        switch (this.viewMode) {
            case 'days':
                this.renderDaysView(grid);
                break;
            case 'months':
                this.renderMonthsView(grid);
                break;
            case 'years':
                this.renderYearsView(grid);
                break;
        }
    }
    renderDaysView(grid) {
        grid.className = 'calendar-grid calendar-grid--days';
        grid.innerHTML = '';
        let today = new Date();
        today.setHours(0, 0, 0, 0);
        this.dayNames.forEach(day => {
            const dayHeader = this.createElement('div', 'day-header', day);
            grid.appendChild(dayHeader);
        });
        const days = this.getDaysInMonth();
        days.forEach(day => {
            const button = this.createElement('button', 'calendar-cell', day.day);
            button.type = 'button';
            const fechaParaElBoton = new Date(`${day.year}-${day.month + 1}-${day.day}`).toLocaleDateString('sv-SE');
            button.dataset.fecha = fechaParaElBoton;
            if (day.isToday) {
                button.classList.add('calendar-cell--today');
            }
            if (day.isOtherMonth) {
                button.classList.add('calendar-cell--other-month');
            }
            /* if (day.date.getMonth() == this.selectedDate.getMonth() &&
                day.date.getDate() == this.selectedDate.getDate()) {
                button.classList.add('calendar-cell--selected');
            } */
            const year = day.year;
            const month = day.month;
            const fechaGenerada = new Date(year, month, day.day);
            fechaGenerada.setHours(0, 0, 0, 0);
            // Determinar disponibilidad usando statusDeterminator si existe, si no, usar lógica por defecto
            let estaDisponible = true;

            if (this.statusDeterminator && (typeof this.statusDeterminator == "function")) {
                estaDisponible = this.statusDeterminator(this.monthDates, fechaGenerada);
            }


            if ((fechaGenerada < today) || !estaDisponible) {
                this.deshabilitarDia(button);
            } else {

                button.addEventListener('click', (ev) => this.handleSelectedDay(ev));

            }
            grid.appendChild(button);
        });
    }
    renderMonthsView(grid) {
        grid.className = 'calendar-grid calendar-grid--months';
        grid.innerHTML = '';
        this.monthNames.forEach((month, index) => {
            const button = this.createElement('button', 'calendar-cell calendar-cell--month', month);
            button.type = 'button';
            const possibleNewMonth = new Date(this.selectedDate);
            possibleNewMonth.setMonth(index);
            const resultValidation = this.isValidPrevNavigation(possibleNewMonth);
            if (resultValidation) {
                button.addEventListener('click', (ev) => {
                    ev.preventDefault();
                    this.selectedDate.setMonth(index);
                    const changedDateEvent = new CustomEvent('changedDate', {
                        detail: {
                            fecha: this.selectedDate
                        }
                    });
                    document.dispatchEvent(changedDateEvent);
                    this.showDaysView(index)
                });
            } else {
                button.classList.add('.calendar-month-cell--disabled')
                button.disabled = true;
            }
            grid.appendChild(button);
        });
    }
    renderYearsView(grid) {
        grid.className = 'calendar-grid calendar-grid--years';
        grid.innerHTML = '';
        const currentYear = this.selectedDate.getFullYear();
        const startYear = Math.floor(currentYear / 10) * 10;
        for (let i = 0; i < 12; i++) {
            const year = startYear + i;
            const button = this.createElement('button', 'calendar-cell calendar-cell--year', year);
            button.type = 'button';
            const possibleNewMonth = new Date(this.selectedDate);
            possibleNewMonth.setFullYear(year);
            const resultValidation = this.isValidPrevNavigation(possibleNewMonth);
            if (resultValidation) {
                button.addEventListener('click', () => this.selectYear(year));
            } else {
                button.disabled = true;
            }
            grid.appendChild(button);
        }
    }
    clearAnteriorSelectedDays() {
        const anteriorSelectedDays = document.getElementsByClassName('calendar-cell--selected');
        for (let day of anteriorSelectedDays) {
            day.classList.remove('calendar-cell--selected');
        }
    }

    getSelectedDate(dayElement) {
        const dayNumber = parseInt(dayElement.textContent);
        const year = this.selectedDate.getFullYear();
        const month = this.selectedDate.getMonth();
        return this.selectedDate;
    }
    handleSelectedDay(ev) {
        ev.preventDefault();
        this.clearAnteriorSelectedDays();
        const seletedElement = ev.currentTarget;
        seletedElement.classList.add('calendar-cell--selected');
        const selectedDay = parseInt(seletedElement.textContent);
        this.selectedDate.setDate(selectedDay);
        const fechaDeLaClaseInput = document.getElementById('fechaDeLaClase');
        const fechaFormateada = this.selectedDate.toLocaleDateString('sv-SE'); // Formato YYYY-MM-DD
        fechaDeLaClaseInput.value = fechaFormateada;
        console.log("fecha formateada ", fechaFormateada);
        console.log("fecha plana ", this.selectedDate);
        console.log("valor del input date ", fechaDeLaClaseInput.value);
        const fechaSeleccionadaEvent = new CustomEvent('fechaSeleccionada', {
            detail: {
                fecha: this.selectedDate
            }
        });
        document.dispatchEvent(fechaSeleccionadaEvent);
    }
    getDaysInMonth() {
        const year = this.selectedDate.getFullYear();
        const month = this.selectedDate.getMonth();
        const today = new Date();
        const firstDay = new Date(year, month, 1);
        const lastDay = new Date(year, month + 1, 0);
        const startDate = new Date(firstDay);
        startDate.setDate(startDate.getDate() - firstDay.getDay());
        const endDate = new Date(lastDay);
        const remainingDays = 6 - lastDay.getDay();
        endDate.setDate(endDate.getDate() + remainingDays);
        const days = [];
        const currentDate = new Date(startDate);
        while (currentDate <= endDate) {
            const isCurrentMonth = currentDate.getMonth() === month;
            const isCurrentYear = currentDate.getFullYear() === year;
            const isToday = this.isSameDay(currentDate, today);
            days.push({
                day: currentDate.getDate(),
                isCurrentMonth,
                isOtherMonth: !isCurrentMonth,
                isOtherYear: !isCurrentYear,
                month: currentDate.getMonth(),
                year: currentDate.getFullYear(),
                isToday,
                date: new Date(currentDate)
            });
            currentDate.setDate(currentDate.getDate() + 1);
        }
        return days;
    }
    isSameDay(date1, date2) {
        return date1.getDate() === date2.getDate() &&
            date1.getMonth() === date2.getMonth() &&
            date1.getFullYear() === date2.getFullYear();
    }
    createElement(tag, className, content) {
        const element = document.createElement(tag);
        element.className = className;
        element.textContent = content;
        return element;
    }
    deshabilitarDia(button) {
        button.disabled = true;
        button.classList.add('calendar-cell--disabled');
    }
    obtenerDiaDelMesHtmlPorFecha(fecha) {
        const fechaFormateada = fecha.toLocaleDateString('sv-SE'); // Formato YYYY-MM-DD
        const boton = this.container.querySelector(`button[data-fecha="${fechaFormateada}"]`);
        return boton;
    }
    getFirstDisponibleDay() {
        const $firstDisponibleCalendarDay = document.querySelector('.calendar-cell:not(.calendar-cell--disabled)');
            
        return $firstDisponibleCalendarDay;
    }
    setAndHighlightCalendarDay($calendarDay) {
        const diaSeleccionado = parseInt($calendarDay.textContent);
        this.selectedDate.setDate(diaSeleccionado);
        $calendarDay.classList.add('calendar-cell--selected');
    }
    selectFirstDisponibleDay(){
        const $firstCalendarDisponibleDay = this.getFirstDisponibleDay();
        if ($firstCalendarDisponibleDay) {
            this.setAndHighlightCalendarDay($firstCalendarDisponibleDay);
        }
    }

    clickHandlerOfSelectedDay(event) {
        this.selectedDayHandler(event);
    }
}

