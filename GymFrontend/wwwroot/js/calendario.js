export class Calendar {
  constructor(containerId, disponibleDates = []) {
      this.container = document.getElementById(containerId);
      this.currentDate = new Date();
      this.inputFechaDeLaClase = document.getElementById('fechaDeLaClase')
      this.selectedDate = new Date();
      this.viewMode = 'days'; // 'days', 'months', 'years'
      this.monthNames = [
          'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
          'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
      ];
      this.dayNames = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
      this.disponibleDates = disponibleDates;      
      const fechaFormateada = this.selectedDate.toLocaleDateString('sv-SE'); // Formato YYYY-MM-DD
      this.inputFechaDeLaClase.value=fechaFormateada;
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

      prevButton?.addEventListener('click', (ev) => this.navigatePrevious(ev));
      nextButton?.addEventListener('click', (ev) => this.navigateNext(ev));
      monthButton?.addEventListener('click', (ev) => this.showMonthView(ev));
      yearButton?.addEventListener('click', (ev) => this.showYearView(ev));
  }
// param newDate recibe el nuevo objeto fecha que se pretende aisgnar
  isValidPrevNavigation(newDate){
    let validationResult = true;
    
    if(newDate < this.currentDate){
        validationResult = false;
    }
    return validationResult;
    
  }
  // if supply subtracted months must be negative number
  simulateChangeMonth(addedOrSubstractedMonths){
    const newMonth = new Date(this.selectedDate);
    newMonth.setMonth(this.selectedDate.getMonth() + addedOrSubstractedMonths ); 

    return newMonth;
  }
  // if supply subtracted years must be negative number
  simulateChangeYear(addedOrSubstractedYears){
    const newYear = new Date(this.selectedDate);
    newYear.setFullYear(this.selectedDate.getFullYear() + addedOrSubstractedMonths ); 
    return newYear;
  }
  /**
   * Navega al período anterior según el modo de vista actual
   */
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
    if(!resultValidation){
        return false;
    }

    
    const changedDateEvent = new CustomEvent('changedDate', {
        detail: {
                fecha: this.selectedDate
        }
    });
    document.dispatchEvent(changedDateEvent);
    
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
      
      const changedDateEvent = new CustomEvent('changedDate', {
        detail: {
          fecha: this.selectedDate
        }
      });
      document.dispatchEvent(changedDateEvent);
  }

  /**
   * Cambia el mes actual
   * @param {number} direction - Dirección del cambio (-1 o 1)
   */
  changeMonth(direction) {
      this.selectedDate.setMonth(this.selectedDate.getMonth() + direction);
      this.renderWithTransition();
  }

  /**
   * Cambia el año actual
   * @param {number} direction - Dirección del cambio (-1 o 1)
   */
  changeYear(direction) {
      this.selectedDate.setFullYear(this.selectedDate.getFullYear() + direction);
      this.renderWithTransition();
  }

  /**
   * Cambia el rango de años mostrado
   * @param {number} direction - Dirección del cambio (-10 o 10)
   */
  changeYearRange(direction) {
      this.selectedDate.setFullYear(this.selectedDate.getFullYear() + direction);
      this.renderWithTransition();
  }

  /**
   * Muestra la vista de meses
   */
  showMonthView(ev) {
    ev.preventDefault();
      this.viewMode = 'months';
      this.renderWithTransition();
  }

  /**
   * Muestra la vista de años
   */
  showYearView(ev) {
        ev.preventDefault();
      this.viewMode = 'years';
      this.renderWithTransition();
  }

  /**
   * Muestra la vista de días para un mes específico
   * @param {number} month - Mes seleccionado (0-11)
   */
  showDaysView(month) {
      this.selectedDate.setMonth(month);
      this.viewMode = 'days';
      this.renderWithTransition();
  }

  /**
   * Selecciona un año específico y muestra los meses
   * @param {number} year - Año seleccionado
   */
  selectYear(year) {
      this.selectedDate.setFullYear(year);
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
      
      monthButton.textContent = this.monthNames[this.selectedDate.getMonth()];
      yearButton.textContent = this.selectedDate.getFullYear();
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
      let today = new Date();
      //se pone la hora en cero por que no se utiizara y evita problemas en compraciones
      today.setHours(0,0,0,0);
      
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
          const fechaParaElBoton = new Date(`${day.year}-${day.month + 1}-${day.day}`).toLocaleDateString('sv-SE');
          button.dataset.fecha= fechaParaElBoton;
          if (day.isToday) {
              button.classList.add('calendar-cell--today');
          }
          if (day.isOtherMonth) {
              button.classList.add('calendar-cell--other-month');
          }
          if(day.day == this.selectedDate.getDate()){
            button.classList.add('calendar-cell--selected');
          }

          // Generar la fecha usando el año y mes de currentDate y el día que se está renderizando
          const year = day.year;
          const month = day.month;
          const fechaGenerada = new Date(year, month, day.day);
          // se coloca la hora en 0 para hacer comparar solo año,mes y dia
          fechaGenerada.setHours(0,0,0,0);      
          // disponibleDates es un arreglo de objetos con propiedad fecha tipo Date
          const estaDisponible = (this.disponibleDates || []).some(obj =>
              obj.fecha.getFullYear() === fechaGenerada.getFullYear() &&
              obj.fecha.getMonth() === fechaGenerada.getMonth() &&
              obj.fecha.getDate() === fechaGenerada.getDate()
          );

          // Si la fecha generada no está en disponibleDates, deshabilitar el botón y aplica la clase de fondo rojo
          if ((fechaGenerada < today) || !estaDisponible ) {
              this.deshabilitarDia(button);
          } else {
              button.addEventListener('click', (event) => this.handleSelectedDay(event));
          }

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
            }else{
                button.classList.add('.calendar-month-cell--disabled')
                button.disabled= true;
            }
          
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
      
      const currentYear = this.selectedDate.getFullYear();
      const startYear = Math.floor(currentYear / 10) * 10;
      
      for (let i = 0; i < 12; i++) {
          const year = startYear + i;
          const button = this.createElement('button', 'calendar-cell calendar-cell--year', year);
          button.type = 'button';
          const possibleNewMonth = new Date(this.selectedDate);
          possibleNewMonth.setFullYear(year);          
          const resultValidation = this.isValidPrevNavigation(possibleNewMonth);
          if(resultValidation){
            button.addEventListener('click', () => this.selectYear(year));
          }else{
            button.disabled = true;
          }
          
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
    const scheduleViewer = document.getElementById('scheduleViewer');
    const offset = 60; // Ajusta este valor según la altura de tu menú fijo
    
    if (scheduleViewer) {
        // Obtener la posición del contenedor completo del schedule-viewer
        const rect = scheduleViewer.getBoundingClientRect();
        const y = rect.top + window.pageYOffset - offset;
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
    const year = this.selectedDate.getFullYear();
    const month = this.selectedDate.getMonth();
    return this.selectedDate;
    
  }
  
  handleSelectedDay (ev){
    ev.preventDefault();
    this.clearAnteriorSelectedDays();
    const seletedElement = ev.currentTarget;
    seletedElement.classList.add('calendar-cell--selected');
    const selectedDay = parseInt(seletedElement.textContent);
    this.selectedDate.setDate(selectedDay);
    
    // Asignar la fecha seleccionada al input fechaDeLaClase
    const fechaDeLaClaseInput = document.getElementById('fechaDeLaClase');
    
      const fechaFormateada = this.selectedDate.toLocaleDateString('sv-SE'); // Formato YYYY-MM-DD
      fechaDeLaClaseInput.value = fechaFormateada;
      console.log("fecha formateada ",fechaFormateada);
      console.log("fecha plana ",this.selectedDate);
      console.log("valor del input date ", fechaDeLaClaseInput.value);
    
    
    // Emitir evento personalizado con la fecha seleccionada
    const fechaSeleccionadaEvent = new CustomEvent('fechaSeleccionada', {
      detail: {
        fecha: this.selectedDate
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
      const year = this.selectedDate.getFullYear();
      const month = this.selectedDate.getMonth();
      const today = new Date();
      
      // Primer día del mes
      const firstDay = new Date(year, month, 1);
      const lastDay = new Date(year, month + 1, 0);
      
      // Días a mostrar del mes anterior
      const startDate = new Date(firstDay);
      startDate.setDate(startDate.getDate() - firstDay.getDay());
      console.log(`START DATE ${startDate.toLocaleTimeString()}`)
      
      // Días a mostrar del mes siguiente
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
              isOtherYear:!isCurrentYear,
              month:currentDate.getMonth(),
              year:currentDate.getFullYear(),
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

  /**
   * Deshabilita un botón y agrega la clase CSS para indicar que está deshabilitado
   * @param {HTMLButtonElement} button - El botón a deshabilitar
   */
  deshabilitarDia(button) {
      button.disabled = true;
      button.classList.add('calendar-cell--disabled');
  }

  /**
   * Obtiene el botón HTML del día del mes que coincida con la fecha proporcionada
   * @param {Date} fecha - La fecha para buscar el botón correspondiente
   * @returns {HTMLButtonElement|null} El botón encontrado o null si no existe
   */
  obtenerDiaDelMesHtml(fecha) {
      const fechaFormateada = fecha.toLocaleDateString('sv-SE'); // Formato YYYY-MM-DD
      const boton = this.container.querySelector(`button[data-fecha="${fechaFormateada}"]`);
      return boton;
  }
}

// Inicialización automática cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('calendar')) {
      new Calendar('calendar');
  }
});