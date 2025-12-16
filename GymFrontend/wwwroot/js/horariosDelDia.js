import { realizarPeticionAPI } from './httpClient.js';
import { showMessage,iconTypes,showSimpleDialog,showComplexDialog } from './messageManager.mjs';
export class ScheduleViewer {
  constructor(containerId) {
    this.container = document.getElementById(containerId)
    this.dateElement = null
    this.gridElement = null
    this.inputFkHoraLaboral = null
    this.selectedScheduleId = null
    this.schedules = []
    this.checkElement = null

    
  }

  /**
   * Inicializa el visualizador de horarios
   */
  init() {
    this.cacheElements()
    this.bindEvents()
  }

  /**
   * Cachea los elementos DOM para mejor rendimiento
   */
  cacheElements() {
    this.dateElement = this.container?.querySelector("#scheduleDate")
    this.gridElement = this.container?.querySelector("#scheduleGrid")
    this.inputFkHoraLaboral = document.getElementById("fkHoraLaboral")
    this.checkElement = document.getElementById("ocultarPreReservados")
  }

  /**
   * Configura los event listeners
   */
  bindEvents() {
    this.checkElement.addEventListener("change", (event) => {
      const ocultar = event.target.checked;
      this.togglePreReservados(ocultar);
    });

    
    
  }

  /**
   * Establece la fecha seleccionada en el header
   * @param {string} dateString - Fecha formateada como string
   */
  setSelectedDate(dateString) {
    if (!this.dateElement) {
      console.error("Elemento de fecha no encontrado")
      return
    }

    this.dateElement.textContent = dateString
    this.addFadeAnimation(this.dateElement)
  }

  /**
   * Carga y renderiza los horarios disponibles
   * @param {Array} schedulesArray - Array de objetos con horarios
   */
  loadSchedules(schedulesArray) {
    if (!Array.isArray(schedulesArray)) {
      console.error("El parámetro debe ser un array")
      return
    }

    this.schedules = schedulesArray
    this.renderSchedules()
  }

  /**
   * Renderiza los elementos de horarios en el grid
   */
  renderSchedules() {
    if (!this.gridElement) {
      console.error("Elemento grid no encontrado")
      return
    }

    // Limpiar contenido anterior
    this.clearGrid()

    // Mostrar estado de carga
    this.setLoadingState(true)

    // Simular carga asíncrona
    
      this.schedules.forEach((schedule, index) => {
        const scheduleElement = this.createScheduleElement(schedule)
         // Configurar evento click solo si no está ocupado
        if (scheduleElement.estado !== "ocupado") {
          scheduleElement.addEventListener("click", (event) => {
            this.handleScheduleClick(event)
          });
        }
        this.gridElement.appendChild(scheduleElement)

        // Animación escalonada
        setTimeout(() => {
          scheduleElement.style.opacity = "1";
          scheduleElement.style.transform = "translateY(0)";
        }, index * 50)
    

        this.setLoadingState(false)
      })
  }
  

  /**
   * Crea un elemento individual de horario
   * @param {Object} schedule - Objeto con datos del horario
   * @returns {HTMLElement} Elemento DOM del horario
   */
  createScheduleElement(schedule) {
    const element = document.createElement("button")
    element.className = this.getScheduleElementClasses(schedule.estado)
    element.setAttribute("data-idhora", schedule.idHora)
    element.textContent = schedule.labelHorario
    element.type = "button"

    // Configurar estado inicial para animación
    element.style.opacity = "0"
    element.style.transform = "translateY(10px)"
    element.style.transition = "all 0.3s ease"

    // Aplica la clase CSS si el estado es exactamente 'prereservado'
    if (schedule.estado === "prereservado") {
      element.classList.add("schedule-viewer__item--prereservado-disabled");
    }

    return element
  }

  /**
   * Obtiene las clases CSS para un elemento de horario
   * @param {string} estado - Estado del horario
   * @returns {string} Clases CSS concatenadas
   */
  getScheduleElementClasses(estado) {
    const baseClass = "schedule-viewer__item"
    const stateClass = `${baseClass}--${estado}`

    return `${baseClass} ${stateClass}`
  }

  /**
   * Maneja el evento click en un horario
   * @param {Event} event - Evento de click
   */
  async handleScheduleClick(event) {
    // Mostrar prompt de confirmación
    const element = event.currentTarget
    const confirmacion = await showComplexDialog(iconTypes.warning, "¿Deseas reservar ese horario?,la reserva dura solo 5 minutos"); 
    console.log(confirmacion)
    if (!confirmacion.isConfirmed) {

      return;
    }
    
    const scheduleId = element.getAttribute("data-idhora")
    this.updateHiddenInput(scheduleId)
    // Ejecutar pre-reserva antes de continuar
    const idPreReserva = await this.registrarPreReservaDeHorario();
    if (idPreReserva <= 0) {
     showMessage(iconTypes.error, "Error al registrar la pre-reserva");
      return;
    }
    
    if (!scheduleId) {
      showMessage(iconTypes.error, "ID de horario no encontrado");
      return
    }
    saveToLocalStorage("idPreReserva", idPreReserva);
    // Remover selección anterior
    this.clearSelection()

    // Seleccionar nuevo elemento
    this.selectSchedule(element, scheduleId)

    // Actualizar campo oculto
    

    // Disparar evento personalizado
    this.dispatchSelectionEvent(scheduleId)

    // Scroll hacia el label de horario seleccionado
    this.scrollToSelectedLabel()
  }

  /**
   * Método para registrar una pre-reserva de horario
   * @returns {Promise<boolean>} true si fue exitosa, false si hubo error
   */
  async registrarPreReservaDeHorario() {
    // Validar que haya un horario seleccionado
    const inputFkHoraLaboral = document.getElementById('fkHoraLaboral');
    
    const inputFecha = document.getElementById('fechaDeLaClase');
    const inputFkEntrenador = document.getElementById('inputEntrenador');
    const inputIdClase = document.getElementById('inputClase');
    if (!inputFkEntrenador.reportValidity()) {
      return false;
    }
    if (!inputIdClase.reportValidity()) {
      return false;
    }
    if (!inputFecha.reportValidity()) {
      return false;
    }
    if (!inputFkHoraLaboral.reportValidity()) {
      return false;
    }
    

    // Obtener los datos pertinentes
    
    const idUsuarioQueReserva = ''; // Aquí puedes cambiar por el usuario real si lo tienes
    const fechaTentativa = inputFecha.value;
    const idHoraLaboral = parseInt(inputFkHoraLaboral.value);
    const idEntrenador = inputFkEntrenador.value;     
    const idClase = parseInt(inputIdClase.value);
    const body = {
      idUsuarioQueReserva,
      fechaTentativa,
      idHoraLaboral,
      idClase,
      idEntrenador
    };

    try {
      const response = await realizarPeticionAPI('/Horarios/preReservarHorario', body, undefined, 'POST');
      if (response.success) {
        // Se puede mostrar un mensaje si se desea

        //se retorna el id de la pre-reserva registrada
        return response.payload;
      } else {
        let detailedError = 'Error al registrar la pre-reserva';
        if (response.errors && response.errors.length > 0) {
          detailedError += ': ' + response.errors.map(e => e.message).join(', ');
          console.log(detailedError)
        } 
        showMessage(iconTypes.error, "No se pudo reservar el horario, aun asi puedes intentar programar tu clase");
        return 0;
      }
    } catch (error) {
      showMessage(iconTypes.error, "No se pudo reservar el horario, aun asi puedes intentar programar tu clase");
      console.error('Error al registrar pre-reserva:', error);
      
      return false;
    }
  }

  /**
   * Selecciona un horario específico
   * @param {HTMLElement} element - Elemento DOM del horario
   * @param {string} scheduleId - ID del horario
   */
  selectSchedule(element, scheduleId) {
    element.classList.add("schedule-viewer__item--selected")
    this.selectedScheduleId = scheduleId

    // Animación de selección
    element.style.transform = "scale(1.05)"
    setTimeout(() => {
      element.style.transform = ""
    }, 200)
  }

  /**
   * Limpia la selección actual
   */
  clearSelection() {
    const selectedElements = this.gridElement?.querySelectorAll(".schedule-viewer__item--selected")
    selectedElements?.forEach((element) => {
      element.classList.remove("schedule-viewer__item--selected")
    })
    this.selectedScheduleId = null
  }

  /**
   * Actualiza el campo oculto con el ID seleccionado
   * @param {string} scheduleId - ID del horario seleccionado
   */
  updateHiddenInput(scheduleId) {
    if (this.inputFkHoraLaboral) {
      this.inputFkHoraLaboral.value = scheduleId
    }
  }

  /**
   * Dispara un evento personalizado cuando se selecciona un horario
   * @param {string} scheduleId - ID del horario seleccionado
   */
  dispatchSelectionEvent(scheduleId) {
    const event = new CustomEvent("scheduleSelected", {
      detail: {
        scheduleId: scheduleId,
        schedule: this.getScheduleById(scheduleId),
      },
    })

    this.container?.dispatchEvent(event)
  }

  /**
   * Obtiene un horario por su ID
   * @param {string} scheduleId - ID del horario
   * @returns {Object|null} Objeto del horario o null si no se encuentra
   */
  getScheduleById(scheduleId) {
    return this.schedules.find((schedule) => schedule.idHora.toString() === scheduleId.toString()) || null
  }

  /**
   * Limpia el contenido del grid
   */
  clearGrid() {
    if (this.gridElement) {
      this.gridElement.innerHTML = ""
    }
  }

  /**
   * Establece el estado de carga
   * @param {boolean} isLoading - Estado de carga
   */
  setLoadingState(isLoading) {
    if (!this.container) return

    if (isLoading) {
      this.container.classList.add("schedule-viewer--loading")
    } else {
      this.container.classList.remove("schedule-viewer--loading")
    }
  }

  /**
   * Añade animación de fade a un elemento
   * @param {HTMLElement} element - Elemento a animar
   */
  addFadeAnimation(element) {
    element.style.opacity = "0"
    element.style.transform = "translateY(-5px)"

    setTimeout(() => {
      element.style.transition = "all 0.3s ease"
      element.style.opacity = "1"
      element.style.transform = "translateY(0)"
    }, 50)
  }

  /**
   * Obtiene el ID del horario seleccionado actualmente
   * @returns {string|null} ID del horario seleccionado
   */
  getSelectedScheduleId() {
    return this.selectedScheduleId
  }

  /**
   * Obtiene todos los horarios cargados
   * @returns {Array} Array de horarios
   */
  getSchedules() {
    return [...this.schedules]
  }

  /**
   * Filtra horarios por estado
   * @param {string} estado - Estado a filtrar
   * @returns {Array} Horarios filtrados
   */
  getSchedulesByState(estado) {
    return this.schedules.filter((schedule) => schedule.estado === estado)
  }

  /**
   * Destruye la instancia y limpia event listeners
   */
  destroy() {
    this.clearGrid()
    this.selectedScheduleId = null
    this.schedules = []
  }

  /**
   * Oculta o muestra los horarios pre-reservados
   * @param {boolean} ocultar - True para ocultar, false para mostrar
   */
  togglePreReservados(ocultar) {
    const preReservadosElements = this.gridElement?.querySelectorAll('.schedule-viewer__item--prereservado')
    
    if (preReservadosElements) {
      preReservadosElements.forEach(element => {
        element.style.display = ocultar ? 'none' : 'flex'
      })
    }
  }

  /**
   * Desplaza el scroll suavemente hacia el label de horario seleccionado
   */
  scrollToSelectedLabel() {
    const label = document.getElementById('labelHorarioSeleccionado');
    const offset = 60; // Ajusta este valor según la altura de tu menú fijo
    
    if (label) {
      const rect = label.getBoundingClientRect();
      const y = rect.top + window.pageYOffset - offset;
      window.scrollTo({ top: y, behavior: 'smooth' });
    }
  }

  handleSelectedDay(event) {
    event.preventDefault();
    this.clearAnteriorSelectedDays();
    const seletedElement = event.currentTarget;
    seletedElement.classList.add('calendar-cell--selected');
    const selectedDay = parseInt(seletedElement.textContent);
    this.selectedDate.setDate(selectedDay);
    const fechaFormateada = this.selectedDate.toLocaleDateString('sv-SE');
    
    

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
}

// Utilidades para integración con otros módulos
const ScheduleViewerUtils = {
  /**
   * Formatea una fecha para mostrar en el header
   * @param {Date} date - Fecha a formatear
   * @returns {string} Fecha formateada
   */
  formatDateForHeader(date) {
    return date.toLocaleDateString("es-ES", {
      weekday: "long",
      year: "numeric",
      month: "long",
      day: "numeric",
    })
  },

  /**
   * Valida un array de horarios
   * @param {Array} schedules - Array a validar
   * @returns {boolean} True si es válido
   */
  validateSchedulesArray(schedules) {
    if (!Array.isArray(schedules)) return false

    return schedules.every(
      (schedule) =>
        schedule.hasOwnProperty("idHora") &&
        schedule.hasOwnProperty("labelHorario") &&
        schedule.hasOwnProperty("estado") &&
        ["disponible", "prereservado", "ocupado"].includes(schedule.estado),
    )
  },
}


// Inicialización automática

// Exportar para uso en módulos
if (typeof module !== "undefined" && module.exports) {
  module.exports = { ScheduleViewer, ScheduleViewerUtils }
} 