

















import { realizarPeticionAPI, obtenerEndpoint } from './httpClient.js';
import { showMessage, iconTypes, showComplexDialog } from './messageManager.mjs';





















export class ScheduleViewerInscripciones {
  constructor(containerId) {
    this.container = document.getElementById(containerId)
    this.dateElement = null
    this.gridElement = null
    this.inputFkHoraLaboral = null
    this.selectedScheduleId = null
    this.selectedIdClaseProgramada = null
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
    // input might belong to a form outside this partial; query by name then fallback to global id
    this.inputFkHoraLaboral = this.container?.querySelector('[name="fkHoraLaboral"]') || document.getElementById("fkHoraLaboral")
    this.checkElement = document.getElementById("ocultarPreReservados")
  }

  /**
   * Configura los event listeners
   */
  bindEvents() {
    // Guard: el checkbox "ocultarPreReservados" solo existe cuando el partial
    // _HorariosDelDia se renderiza con model="true" (ej. inscripción usa false).
    if (this.checkElement) {
      this.checkElement.addEventListener("change", (event) => {
        const ocultar = event.target.checked;
        this.togglePreReservados(ocultar);
      });
    }

    
    
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
    element.dataset.idClaseProgramada = schedule.idClaseProgramada ?? ''
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
    let apliedClass = "";
    let stateClass = "";
    const baseClass = "schedule-viewer__item";
    if(!estado){
      stateClass = `${baseClass}--disponible`;
    }else{
      stateClass = `${baseClass}--${estado}`
    }
    apliedClass= `${baseClass} ${stateClass}`;

    return  apliedClass;
  }

  /**
   * Maneja el evento click en un horario
   * @param {Event} event - Evento de click
   */
  async handleScheduleClick(event) {
    const element = event.currentTarget
    const scheduleId = element.getAttribute("data-idhora")
    const idClaseProgramada = element.dataset.idClaseProgramada

    if (!scheduleId) {
      console.error("ID de horario no encontrado")
      return
    }

    // 1. Mostrar confirmación antes de pre-reserva
    const confirmacion = await showComplexDialog(
      iconTypes.warning,
      "¿Deseas reservar ese horario?, la reserva dura solo 5 minutos"
    );
    if (!confirmacion.isConfirmed) {
      return
    }

    // 2. Extraer y guardar idClaseProgramada
    this.selectedIdClaseProgramada = idClaseProgramada

    // 3. Actualizar hidden inputs
    this.updateHiddenInput(scheduleId)

    // 4. Ejecutar pre-reserva
    const idPreReserva = await this.registrarPreReservaDeHorario()
    if (idPreReserva <= 0) {
      showMessage(iconTypes.error, "No se pudo reservar el horario, aun asi puedes intentar programar tu clase")
      return
    }

    // 5. Guardar idPreReserva en localStorage
    localStorage.setItem("idPreReserva", idPreReserva.toString())

    // 6. Remover selección anterior
    this.clearSelection()

    // 7. Seleccionar nuevo elemento
    this.selectSchedule(element, scheduleId)

    // 8. Disparar evento personalizado
    this.dispatchSelectionEvent(scheduleId)

    // 9. Scroll hacia el label de horario seleccionado
    this.scrollToSelectedLabel()
  }

  /**
   * Registra una pre-reserva de horario de inscripción.
   * @returns {Promise<number>} idPreReserva si fue exitosa, 0 si hubo error
   */
  async registrarPreReservaDeHorario() {
    const inputFkHoraLaboral = document.getElementById('fkHoraLaboral')
    const inputFecha = document.getElementById('fechaDeLaClase')
    const inputClase = document.getElementById('inputClase')
    const inputEntrenador = document.getElementById('inputEntrenador')

    if (!inputFkHoraLaboral?.reportValidity()) return 0
    if (!inputFecha?.reportValidity()) return 0
    if (!inputClase?.reportValidity()) return 0
    if (!inputEntrenador?.reportValidity()) return 0

    const body = {
      fechaTentativa: inputFecha.value,
      idHoraLaboral: parseInt(inputFkHoraLaboral.value),
      idClase: parseInt(inputClase.value),
      idEntrenador: inputEntrenador.value,
      idClaseProgramada: parseInt(this.selectedIdClaseProgramada || '0')
    }

    try {
      const endpointPath = obtenerEndpoint('ENDPOINT_HORARIOS_PRERESERVARHORARIOINSCRIPCION', '/Horarios/preReservarHorarioInscripcion')
      const response = await realizarPeticionAPI(endpointPath, body, undefined, 'POST')
      if (response.success) {
        return response.payload ?? 0
      } else {
        let errorMessage = 'Error al registrar la pre-reserva'
        if (response.errors?.length > 0) {
          errorMessage += ': ' + response.errors.map(e => e.message).join(', ')
        } else if (response.message) {
          errorMessage += ': ' + response.message
        }
        console.error(errorMessage)
        return 0
      }
    } catch (error) {
      console.error('Error al registrar pre-reserva:', error)
      return 0
    }
  }

  /**
   * Desplaza el scroll suavemente hacia el label de horario seleccionado
   */
  scrollToSelectedLabel() {
    const label = document.getElementById('labelHorarioSeleccionado')
    const offset = 60
    if (label) {
      const rect = label.getBoundingClientRect()
      const y = rect.top + window.pageYOffset - offset
      window.scrollTo({ top: y, behavior: 'smooth' })
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

    
