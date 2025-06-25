class ScheduleViewer {
  constructor(containerId) {
    this.container = document.getElementById(containerId)
    this.dateElement = null
    this.gridElement = null
    this.hiddenInput = null
    this.selectedScheduleId = null
    this.schedules = []

    this.init()
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
    this.hiddenInput = document.getElementById("fkHoraLaboral")
  }

  /**
   * Configura los event listeners
   */
  bindEvents() {
    // Los eventos se configuran dinámicamente en cada elemento de horario
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
    setTimeout(() => {
      this.schedules.forEach((schedule, index) => {
        const scheduleElement = this.createScheduleElement(schedule)
        this.gridElement.appendChild(scheduleElement)

        // Animación escalonada
        setTimeout(() => {
          scheduleElement.style.opacity = "1"
          scheduleElement.style.transform = "translateY(0)"
        }, index * 50)
      })

      this.setLoadingState(false)
    }, 300)
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

    // Configurar evento click solo si no está ocupado
    if (schedule.estado !== "ocupado") {
      element.addEventListener("click", (event) => {
        this.handleScheduleClick(event)
      })
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
  handleScheduleClick(event) {
    const element = event.currentTarget
    const scheduleId = element.getAttribute("data-idhora")

    if (!scheduleId) {
      console.error("ID de horario no encontrado")
      return
    }

    // Remover selección anterior
    this.clearSelection()

    // Seleccionar nuevo elemento
    this.selectSchedule(element, scheduleId)

    // Actualizar campo oculto
    this.updateHiddenInput(scheduleId)

    // Disparar evento personalizado
    this.dispatchSelectionEvent(scheduleId)
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
    if (this.hiddenInput) {
      this.hiddenInput.value = scheduleId
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
document.addEventListener("DOMContentLoaded", () => {
  const scheduleContainer = document.getElementById("scheduleViewer")
  if (scheduleContainer) {
    window.scheduleViewer = new ScheduleViewer("scheduleViewer")

    // Event listener para el evento personalizado
    scheduleContainer.addEventListener("scheduleSelected", (event) => {
      console.log("Horario seleccionado:", event.detail)
    })
  }
})

// Exportar para uso en módulos
if (typeof module !== "undefined" && module.exports) {
  module.exports = { ScheduleViewer, ScheduleViewerUtils }
} 