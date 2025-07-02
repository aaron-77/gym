/**
 * Archivo principal para el agendador de horarios
 * Maneja la integración entre el calendario y el visualizador de horarios
 */

import { realizarPeticionAPI } from './httpClient.js';
import { Calendar } from './calendario.js';
import { ScheduleViewer } from './horariosDelDia.js';
// Variables globales para las instancias
let calendarInstance;
let scheduleViewerInstance;

// Variables globales para los datos de horarios
let preReservasDeHorario = [];
let horariosDisponibles = [];
let horariosFormateados = [];

// Array de nombres de meses para el algoritmo
const meses = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
];

/**
 * Objeto de horarios simulados
 * Estructura: {2025: {enero: [{idHora, fecha, labelHorario, estado}, ...], ...}}
 */
const horariosSimulados = {
    2025: {
        enero: [
            { idHora: 1, fecha: new Date(2025, 0, 27, 8, 0), labelHorario: '08:00 - 09:00', estado: 'disponible' },
            { idHora: 2, fecha: new Date(2025, 0, 27, 9, 0), labelHorario: '09:00 - 10:00', estado: 'ocupado' },
            { idHora: 3, fecha: new Date(2025, 0, 27, 10, 0), labelHorario: '10:00 - 11:00', estado: 'prereservado' }
        ],
        febrero: [
            { idHora: 4, fecha: new Date(2025, 1, 3, 8, 0), labelHorario: '08:00 - 09:00', estado: 'disponible' },
            { idHora: 5, fecha: new Date(2025, 1, 3, 9, 0), labelHorario: '09:00 - 10:00', estado: 'disponible' },
            { idHora: 6, fecha: new Date(2025, 1, 3, 10, 0), labelHorario: '10:00 - 11:00', estado: 'ocupado' }
        ],
        junio: [
            { idHora: 7, fecha: new Date(2025, 5, 10, 8, 0), labelHorario: '08:00 - 09:00', estado: 'disponible' },
            { idHora: 8, fecha: new Date(2025, 5, 10, 9, 0), labelHorario: '09:00 - 10:00', estado: 'ocupado' },
            { idHora: 9, fecha: new Date(2025, 5, 10, 10, 0), labelHorario: '10:00 - 11:00', estado: 'prereservado' },
            { idHora: 10, fecha: new Date(2025, 5, 15, 8, 0), labelHorario: '08:00 - 09:00', estado: 'disponible' },
            { idHora: 11, fecha: new Date(2025, 5, 15, 9, 0), labelHorario: '09:00 - 10:00', estado: 'ocupado' },
            { idHora: 12, fecha: new Date(2025, 5, 15, 10, 0), labelHorario: '10:00 - 11:00', estado: 'prereservado' },
            { idHora: 13, fecha: new Date(2025, 5, 27, 8, 0), labelHorario: '08:00 - 09:00', estado: 'disponible' },
            { idHora: 14, fecha: new Date(2025, 5, 27, 9, 0), labelHorario: '09:00 - 10:00', estado: 'ocupado' },
            { idHora: 15, fecha: new Date(2025, 5, 27, 10, 0), labelHorario: '10:00 - 11:00', estado: 'prereservado' }
        ]
    }
    // ... puedes agregar más años
};

/**
 * Determina las fechas con horarios pre-reservados usando el algoritmo del ejemplo
 * @param {Array} preReservasDeHorario - Array de objetos con horarios pre-reservados
 * @returns {Object} Objeto con años y meses que tienen horarios pre-reservados
 */
function determinarFechasConHorariosPreReservados(preReservasDeHorario) {
    const resultado = preReservasDeHorario.reduce((acc, item) => {
        const fecha = new Date(item.fechaReservada);
        const anio = fecha.getFullYear();
        const mes = meses[fecha.getMonth()]; // nombre de mes

        if (!acc[anio]) acc[anio] = new Set();
        acc[anio].add(mes);

        return acc;
    }, {});

    // Convertimos los sets a arrays
    for (const anio in resultado) {
        resultado[anio] = Array.from(resultado[anio]);
    }

    return resultado;
}

/**
 * Determina las fechas con horarios disponibles usando el algoritmo del ejemplo
 * @param {Array} horariosDisponibles - Array de objetos con horarios disponibles
 * @returns {Object} Objeto con años y meses que tienen horarios disponibles
 */
function determinarFechasConHorariosDisponibles(horariosDisponibles) {
    const resultado = horariosDisponibles.reduce((acc, item) => {
        const fecha = new Date(item.fechaDisponible);
        const anio = fecha.getFullYear();
        const mes = meses[fecha.getMonth()]; // nombre de mes

        if (!acc[anio]) acc[anio] = new Set();
        acc[anio].add(mes);

        return acc;
    }, {});

    // Convertimos los sets a arrays
    for (const anio in resultado) {
        resultado[anio] = Array.from(resultado[anio]);
    }

    return resultado;
}

/**
 * Formatea un arreglo de horarios disponibles al formato requerido
 * @param {Array} arregloHorarios - Array de objetos con horarios disponibles
 * @returns {Array} Array de objetos formateados con estructura {idHora, fecha, labelHorario, estado}
 */
function obtenerHorariosDisponiblesFormateados(arregloHorarios) {
    return arregloHorarios.map(horario => ({
        idHora: horario.idHora,
        fecha: new Date(horario.fechaDisponible),
        labelHorario: `${horario.horaInicio} - ${horario.horaFin}`,
        estado: 'disponible'
    }));
}

/**
 * Formatea un arreglo de horarios pre-reservados al formato requerido
 * @param {Array} arregloHorarios - Array de objetos con horarios pre-reservados
 * @returns {Array} Array de objetos formateados con estructura {idHora, fecha, labelHorario, estado}
 */
function obtenerHorariosPreReservadosFormateados(arregloHorarios) {
    return arregloHorarios.map(horario => ({
        idHora: horario.idHora,
        fecha: new Date(horario.fechaReservada),
        labelHorario: `${horario.horaInicio} - ${horario.horaFin}`,
        estado: 'preReservasDeHorario'
    }));
}

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
 * Obtiene los horarios para una fecha seleccionada
 * @param {Date} fechaSeleccionada - Fecha seleccionada en el calendario
 * @returns {Array} Lista de horarios para esa fecha
 */
function obtenerHorariosPorFecha(fechaSeleccionada) {
    const dia = fechaSeleccionada.getDate();
    const mes = fechaSeleccionada.getMonth();
    const año = fechaSeleccionada.getFullYear();
    
    // Filtrar horarios formateados por fecha exacta
    return horariosFormateados.filter(horario => {
        const horarioFecha = horario.fecha;
        return horarioFecha.getDate() === dia &&
               horarioFecha.getMonth() === mes &&
               horarioFecha.getFullYear() === año;
    });
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
        // Obtener los horarios para la fecha seleccionada
        const horarios = obtenerHorariosPorFecha(selectedDate);
        scheduleViewerInstance.setSelectedDate(fechaFormateada);
        scheduleViewerInstance.loadSchedules(horarios)
    }
    
    console.log('Fecha seleccionada en agendador:', fechaFormateada);
}

/**
 * Maneja el evento changedDate para recargar horarios según la fecha seleccionada
 * @param {CustomEvent} event - Evento personalizado con la fecha seleccionada
 */
async function handleChangeMonthOrYear(event) {
    const fecha = event.detail.fecha;
    // Formatear la fecha a ISO para el query param
    const fechaParam = fecha instanceof Date ? fecha.toISOString() : fecha;
    // Obtener horarios disponibles y pre-reservados para la fecha
    try {
        horariosDisponibles = await realizarPeticionAPI('Horarios/obtenerHorariosDisponibles', undefined, { fecha: fechaParam });
        preReservasDeHorario = await realizarPeticionAPI('Horarios/obtenerPreReservas', undefined, { fecha: fechaParam });
        // Formatear ambos arreglos y unirlos
        const horariosDisponiblesFormateados = obtenerHorariosDisponiblesFormateados(horariosDisponibles);
        const horariosPreReservadosFormateados = obtenerHorariosPreReservadosFormateados(preReservasDeHorario);
        horariosFormateados = [...horariosDisponiblesFormateados, ...horariosPreReservadosFormateados];
        if(calendarInstance){
            calendarInstance.disponibleDates = horariosFormateados;
            calendarInstance.render();
            
        }
        const selectedDateEvent = new CustomEvent('fechaSeleccionada', {
            detail: {
              fecha: calendarInstance.selectedDate
            }
          });
        document.dispatchEvent(selectedDateEvent);
        
    } catch (error) {
        console.error('Error al recargar horarios por fecha:', error);
    }
}

/**
 * Inicializa las instancias del calendario y visualizador de horarios
 */
async function inicializarAgendador() {
    // Realizar peticiones al API
    try {
        console.log('Realizando peticiones al API...');
        
        // Petición para obtener pre-reservas
        preReservasDeHorario = await realizarPeticionAPI('Horarios/obtenerPreReservas');
        console.log('Pre-reservas obtenidas:', preReservasDeHorario);
        
        // Petición para obtener horarios disponibles
        horariosDisponibles = await realizarPeticionAPI('Horarios/obtenerHorariosDisponibles');
        console.log('Horarios disponibles obtenidos:', horariosDisponibles);
        
        // Determinar fechas con horarios
        const fechasPreReservadas = determinarFechasConHorariosPreReservados(preReservasDeHorario);
        const fechasDisponibles = determinarFechasConHorariosDisponibles(horariosDisponibles);
        
        console.log('Fechas con pre-reservas:', fechasPreReservadas);
        console.log('Fechas con horarios disponibles:', fechasDisponibles);
        
        // Formatear y agregar horarios al arreglo horariosFormateados
        const horariosDisponiblesFormateados = obtenerHorariosDisponiblesFormateados(horariosDisponibles);
        const horariosPreReservadosFormateados = obtenerHorariosPreReservadosFormateados(preReservasDeHorario);
        
        horariosFormateados = [...horariosDisponiblesFormateados, ...horariosPreReservadosFormateados];
        console.log('Horarios formateados:', horariosFormateados);
        
    } catch (error) {
        console.error('Error al inicializar datos del API:', error);
    }
    
    // Crear instancia del calendario
    const calendarContainer = document.getElementById('calendar');
    if (calendarContainer) {
        calendarInstance = new Calendar('calendar',horariosFormateados);
        calendarInstance.init();
    }
    
    // Crear instancia del visualizador de horarios
    const scheduleContainer = document.getElementById('scheduleViewer');
    if (scheduleContainer) {
        scheduleViewerInstance = new ScheduleViewer('scheduleViewer');
        scheduleViewerInstance.init();
        console.log('Visualizador de horarios inicializado');
    }
    
    // Configurar event listener para el evento personalizado
    document.addEventListener('fechaSeleccionada', handleSelectedDate);
    document.addEventListener('changedDate', handleChangeMonthOrYear);
}

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', inicializarAgendador); 