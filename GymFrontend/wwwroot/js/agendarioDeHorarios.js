/**
 * Archivo principal para el agendador de horarios
 * Maneja la integración entre el calendario y el visualizador de horarios
 */

// Variables globales para las instancias
let calendarInstance;
let scheduleViewerInstance;

/**
 * Formatea una fecha en el formato especificado
 * @param {Date} date - Objeto Date a formatear
 * @returns {string} Fecha formateada como "viernes, 27 de junio del 2025"
 */
function formatearFecha(date) {
    const diasSemana = [
        'domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'
    ];
    
    const meses = [
        'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
        'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    
    const diaSemana = diasSemana[date.getDay()];
    const dia = date.getDate();
    const mes = meses[date.getMonth()];
    const año = date.getFullYear();
    
    return `${diaSemana}, ${dia} de ${mes} del ${año}`;
}

/**
 * Maneja el evento de fecha seleccionada en el calendario
 * @param {CustomEvent} event - Evento personalizado con la fecha seleccionada
 */
function handleSelectedDate(event) {
    const selectedDate = event.detail.fecha;
    const fechaFormateada = formatearFecha(selectedDate);
    
    // Actualizar el visualizador de horarios con la fecha seleccionada
    if (scheduleViewerInstance) {
        scheduleViewerInstance.setSelectedDate(fechaFormateada);
    }
    
    console.log('Fecha seleccionada en agendador:', fechaFormateada);
}

/**
 * Inicializa las instancias del calendario y visualizador de horarios
 */
function inicializarAgendador() {
    // Crear instancia del calendario
    const calendarContainer = document.getElementById('calendar');
    if (calendarContainer) {
        calendarInstance = new Calendar('calendar');
        console.log('Calendario inicializado');
    }
    
    // Crear instancia del visualizador de horarios
    const scheduleContainer = document.getElementById('scheduleViewer');
    if (scheduleContainer) {
        scheduleViewerInstance = new ScheduleViewer('scheduleViewer');
        console.log('Visualizador de horarios inicializado');
    }
    
    // Configurar event listener para el evento personalizado
    document.addEventListener('fechaSeleccionada', handleSelectedDate);
}

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', inicializarAgendador); 