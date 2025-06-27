class Calendar {
  constructor(containerId) {
      this.container = document.getElementById(containerId);
      this.currentDate = new Date();
      this.viewMode = 'days'; // 'days', 'months', 'years'
      this.monthNames = [
          'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
          'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
      ];
      this.dayNames = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
      
      this.init();
  }

  /**
   * Inicializa el calendario y configura los event listeners
   */
  init() {
      this.bindEvents();
      this.render();
  }

  /**
   * Configura todos los event listeners del calendario
   */
  bindEvents() {
      const prevButton = this.container.querySelector('#prevButton');
      const nextButton = this.container.querySelector('#nextButton');
      const monthButton = this.container.querySelector('#monthButton');
      const yearButton = this.container.querySelector('#yearButton');

      prevButton?.addEventListener('click', () => this.navigatePrevious());
      nextButton?.addEventListener('click', () => this.navigateNext());
      monthButton?.addEventListener('click', () => this.showMonthView());
      yearButton?.addEventListener('click', () => this.showYearView());
  }

  /**
   * Navega al período anterior según el modo de vista actual
   */
  navigatePrevious() {
      switch (this.viewMode) {
          case 'days':
              this.changeMonth(-1);
              break;
          case 'months':
              this.changeYear(-1);
              break;
          case 'years':
              this.changeYearRange(-10);
              break;
      }
  }

  /**
   * Navega al período siguiente según el modo de vista actual
   */
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
  }

  /**
   * Cambia el mes actual
   * @param {number} direction - Dirección del cambio (-1 o 1)
   */
  changeMonth(direction) {
      this.currentDate.setMonth(this.currentDate.getMonth() + direction);
      this.renderWithTransition();
  }

  /**
   * Cambia el año actual
   * @param {number} direction - Dirección del cambio (-1 o 1)
   */
  changeYear(direction) {
      this.currentDate.setFullYear(this.currentDate.getFullYear() + direction);
      this.renderWithTransition();
  }

  /**
   * Cambia el rango de años mostrado
   * @param {number} direction - Dirección del cambio (-10 o 10)
   */
  changeYearRange(direction) {
      this.currentDate.setFullYear(this.currentDate.getFullYear() + direction);
      this.renderWithTransition();
  }

  /**
   * Muestra la vista de meses
   */
  showMonthView() {
      this.viewMode = 'months';
      this.renderWithTransition();
  }

  /**
   * Muestra la vista de años
   */
  showYearView() {
      this.viewMode = 'years';
      this.renderWithTransition();
  }

  /**
   * Muestra la vista de días para un mes específico
   * @param {number} month - Mes seleccionado (0-11)
   */
  showDaysView(month) {
      this.currentDate.setMonth(month);
      this.viewMode = 'days';
      this.renderWithTransition();
  }

  /**
   * Selecciona un año específico y muestra los meses
   * @param {number} year - Año seleccionado
   */
  selectYear(year) {
      this.currentDate.setFullYear(year);
      this.viewMode = 'months';
      this.renderWithTransition();
  }

  /**
   * Renderiza el calendario con transición suave
   */
  renderWithTransition() {
      const content = this.container.querySelector('.calendar-content');
      
      // Aplicar clase de transición
      content.classList.add('calendar-content--transitioning');
      
      setTimeout(() => {
          this.render();
          content.classList.remove('calendar-content--transitioning');
          content.classList.add('calendar-content--entering');
          
          setTimeout(() => {
              content.classList.remove('calendar-content--entering');
          }, 300);
      }, 150);
  }

  /**
   * Renderiza el calendario completo
   */
  render() {
      this.updateHeader();
      this.updateContent();
  }

  /**
   * Actualiza el header del calendario
   */
  updateHeader() {
      const monthButton = this.container.querySelector('#monthButton');
      const yearButton = this.container.querySelector('#yearButton');
      
      monthButton.textContent = this.monthNames[this.currentDate.getMonth()];
      yearButton.textContent = this.currentDate.getFullYear();
  }

  /**
   * Actualiza el contenido del calendario según el modo de vista
   */
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

  /**
   * Renderiza la vista de días
   * @param {HTMLElement} grid - Elemento grid del calendario
   */
  renderDaysView(grid) {
      grid.className = 'calendar-grid calendar-grid--days';
      grid.innerHTML = '';
      
      // Agregar headers de días de la semana
      this.dayNames.forEach(day => {
          const dayHeader = this.createElement('div', 'day-header', day);
          grid.appendChild(dayHeader);
      });
      
      // Obtener días del mes
      const days = this.getDaysInMonth();
      
      days.forEach(day => {
          const button = this.createElement('button', 'calendar-cell', day.day);
          button.type = 'button';
          if (day.isToday) {
              button.classList.add('calendar-cell--today');
          }
          
          if (day.isOtherMonth) {
              button.classList.add('calendar-cell--other-month');
          }
          button.addEventListener('click', (event) => this.handleSelectedDay(event));
          
          grid.appendChild(button);
      });
  }

  /**
   * Renderiza la vista de meses
   * @param {HTMLElement} grid - Elemento grid del calendario
   */
  renderMonthsView(grid) {
      grid.className = 'calendar-grid calendar-grid--months';
      grid.innerHTML = '';
      
      this.monthNames.forEach((month, index) => {
          const button = this.createElement('button', 'calendar-cell calendar-cell--month', month);
          button.type = 'button';
          button.addEventListener('click', () => { this.currentDate.setMonth(index); this.showDaysView(index)});
          grid.appendChild(button);
      });
  }

  /**
   * Renderiza la vista de años
   * @param {HTMLElement} grid - Elemento grid del calendario
   */
  renderYearsView(grid) {
      grid.className = 'calendar-grid calendar-grid--years';
      grid.innerHTML = '';
      
      const currentYear = this.currentDate.getFullYear();
      const startYear = Math.floor(currentYear / 10) * 10;
      
      for (let i = 0; i < 12; i++) {
          const year = startYear + i;
          const button = this.createElement('button', 'calendar-cell calendar-cell--year', year);
          button.type = 'button';
          button.addEventListener('click', () => this.selectYear(year));
          grid.appendChild(button);
      }
  }
  clearAnteriorSelectedDays (){
    const anteriorSelectedDays = document.getElementsByClassName('calendar-cell--selected');
    for(let day of anteriorSelectedDays){
        day.classList.remove('calendar-cell--selected');
    }
  }
  
  /**
   * Desplaza el scroll suavemente hacia el header del visualizador de horarios
   */
  scrollToScheduleViewer() {
    const header = document.querySelector('.schedule-viewer__header');
    const offset = 60; // Ajusta este valor según la altura de tu menú fijo
    if (header) {
        const y = header.getBoundingClientRect().top + window.pageYOffset - offset;
        window.scrollTo({ top: y, behavior: 'smooth' });
    }
  }
  
  /**
   * Obtiene la fecha seleccionada en el calendario
   * @param {HTMLElement} dayElement - Elemento del día clickeado
   * @returns {Object} Objeto con información de la fecha seleccionada
   */
  getSelectedDate(dayElement) {
    const dayNumber = parseInt(dayElement.textContent);
    // Obtener el año y mes actual del calendario
    const year = this.currentDate.getFullYear();
    const month = this.currentDate.getMonth();
    return this.currentDate;
    
  }
  
  handleSelectedDay (ev){
    ev.preventDefault();
    this.clearAnteriorSelectedDays();
    const seletedElement = ev.currentTarget;
    seletedElement.classList.add('calendar-cell--selected');
    const selectedDay = parseInt(seletedElement.textContent);
    this.currentDate.setDate(selectedDay);
    
    // Obtener la fecha seleccionada
    const selectedDateInfo = this.getSelectedDate(ev.currentTarget);
    
    // Emitir evento personalizado con la fecha seleccionada
    const fechaSeleccionadaEvent = new CustomEvent('fechaSeleccionada', {
      detail: {
        fecha: selectedDateInfo
      }
    });
    
    document.dispatchEvent(fechaSeleccionadaEvent);
    
    // Scroll suave hacia el header del visualizador de horarios
    this.scrollToScheduleViewer();
  }

  /**
   * Obtiene todos los días a mostrar en el calendario mensual
   * @returns {Array} Array de objetos con información de cada día
   */
  getDaysInMonth() {
      const year = this.currentDate.getFullYear();
      const month = this.currentDate.getMonth();
      const today = new Date();
      
      // Primer día del mes
      const firstDay = new Date(year, month, 1);
      const lastDay = new Date(year, month + 1, 0);
      
      // Días a mostrar del mes anterior
      const startDate = new Date(firstDay);
      startDate.setDate(startDate.getDate() - firstDay.getDay());
      
      // Días a mostrar del mes siguiente
      const endDate = new Date(lastDay);
      const remainingDays = 6 - lastDay.getDay();
      endDate.setDate(endDate.getDate() + remainingDays);
      
      const days = [];
      const currentDate = new Date(startDate);
      
      while (currentDate <= endDate) {
          const isCurrentMonth = currentDate.getMonth() === month;
          const isToday = this.isSameDay(currentDate, today);
          
          days.push({
              day: currentDate.getDate(),
              isCurrentMonth,
              isOtherMonth: !isCurrentMonth,
              isToday,
              date: new Date(currentDate)
          });
          
          currentDate.setDate(currentDate.getDate() + 1);
      }
      
      return days;
  }

  /**
   * Verifica si dos fechas son el mismo día
   * @param {Date} date1 - Primera fecha
   * @param {Date} date2 - Segunda fecha
   * @returns {boolean} True si son el mismo día
   */
  isSameDay(date1, date2) {
      return date1.getDate() === date2.getDate() &&
             date1.getMonth() === date2.getMonth() &&
             date1.getFullYear() === date2.getFullYear();
  }

  /**
   * Crea un elemento HTML con clase y contenido
   * @param {string} tag - Tag del elemento
   * @param {string} className - Clases CSS
   * @param {string} content - Contenido del elemento
   * @returns {HTMLElement} Elemento creado
   */
  createElement(tag, className, content) {
      const element = document.createElement(tag);
      element.className = className;
      element.textContent = content;
      return element;
  }
}

// Inicialización automática cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('calendar')) {
      new Calendar('calendar');
  }
});