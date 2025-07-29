import { realizarPeticionAPI } from './httpClient.js';
export class ScheduleViewerInscripciones {
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
    
    const element = event.currentTarget
    const scheduleId = element.getAttribute("data-idhora")
    this.updateHiddenInput(scheduleId)
    // Ejecutar pre-reserva antes de continuar
    
    if (!scheduleId) {
      console.error("ID de horario no encontrado")
      return
    }

    // Remover selección anterior
    this.clearSelection()

    // Seleccionar nuevo elemento
    this.selectSchedule(element, scheduleId)

    // Disparar evento personalizado
    this.dispatchSelectionEvent(scheduleId)
        
  }

  /**
   * Método para registrar una pre-reserva de horario
   * @returns {Promise<boolean>} true si fue exitosa, false si hubo error
   */
  async registrarPreReservaDeHorario() {
    // Validar que haya un horario seleccionado
    const inputFkHoraLaboral = document.getElementById('fkHoraLaboral');
    
    const inputFecha = document.getElementById('fechaDeLaClase');

    
    if (!inputFecha.reportValidity()) {
      return false;
    }
    if (!inputFkHoraLaboral.reportValidity()) {
      return false;
    }
    

    // Obtener los datos pertinentes
    
    const idUsuarioQueReserva = 16; // Aquí puedes cambiar por el usuario real si lo tienes
    const fechaTentativa = inputFecha.value;
    const idHoraLaboral = parseInt(inputFkHoraLaboral.value);

    const body = {
      idUsuarioQueReserva,
      fechaTentativa,
      idHoraLaboral
    };

    try {
      const response = await realizarPeticionAPI('Horarios/preReservarHorario', body, undefined, 'POST');
      if (response.success) {
        // Se puede mostrar un mensaje si se desea
        // alert('Pre-reserva registrada exitosamente.');
        return true;
      } else {
        let errorMessage = 'Error al registrar la pre-reserva';
        if (response.errors && response.errors.length > 0) {
          errorMessage += ': ' + response.errors.map(e => e.message).join(', ');
        } else if (response.message) {
          errorMessage += ': ' + response.message;
        }
        alert(errorMessage);
        return false;
      }
    } catch (error) {
      console.error('Error al registrar pre-reserva:', error);
      alert('Error al registrar la pre-reserva: ' + error.message);
      return false;
    }
  }

  /**
   * Selecciona un horario específico
   * @param {HTMLElement} element - Elemento DOM al qu selle aplicara la animacion
   * 
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
      bubbles: true
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
} 

    
