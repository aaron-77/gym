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

// Variable global para el catálogo de clases
let catalogoClases = [];

let horariosFormateados = [];
let horarios = {};

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
 * Agrega horarios disponibles y pre-reservados al arreglo horariosFormateados
 * @param {Array} horariosDisponibles - Array de objetos con horarios disponibles
 * @param {Array} horariosPreReservados - Array de objetos con horarios pre-reservados
 */
function agregarHorarios(horariosDisponibles, horariosPreReservados) {
    const horariosDisponiblesFormateados = obtenerHorariosDisponiblesFormateados(horariosDisponibles);
    const horariosPreReservadosFormateados = obtenerHorariosPreReservadosFormateados(horariosPreReservados);
    
    // Combinar todos los horarios formateados
    const todosLosHorarios = [...horariosDisponiblesFormateados, ...horariosPreReservadosFormateados];
    
    // Organizar horarios por año, mes y día
    todosLosHorarios.forEach(horario => {
        const fecha = horario.fecha;
        const año = fecha.getFullYear();
        const mes = fecha.getMonth();
        const dia = fecha.getDate();
        // Inicializar estructura si no existe
        if (!horarios[año]) {
            horarios[año] = {};
        }
        if (!horarios[año][mes]) {
            horarios[año][mes] = {};
        }
        if (!horarios[año][mes][dia]) {
            horarios[año][mes][dia] = [];
        }
        // Agregar horario a la posición correspondiente
        horarios[año][mes][dia].push(horario);
    });
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
    return horarios[año][mes][dia];
    
    
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
 * Verifica si existen horarios para una fecha específica en el objeto horarios
 * @param {Date} fecha - Fecha a verificar
 * @returns {boolean} True si existen horarios, false en caso contrario
 */
function existenEsosHorarios(fecha) {
    const año = fecha.getFullYear();
    const mes = fecha.getMonth();
    const dia = fecha.getDate();
    
    return horarios[año] && horarios[año][mes] && horarios[año][mes][dia] && horarios[año][mes][dia].length > 0;
}

/**
 * Obtiene horarios disponibles y pre-reservados para una fecha específica
 * @param {string} fecha - Fecha en formato ISO para el query param
 * @returns {Object} Objeto con horariosDisponibles y preReservasDeHorario
 */
async function obtenerHorariosNuevos(fecha = null) {
    try {
        const params = {};
        if (fecha) {  // solo agrega fecha si no es null o undefined
            params.fecha = fecha;
        }
        const responseHorariosDisponibles = await realizarPeticionAPI('Horarios/obtenerHorariosDisponibles', undefined, params);
        const responsePreReservas = await realizarPeticionAPI('Horarios/obtenerPreReservas', undefined, params);
        
        // Extraer los datos del payload si la respuesta tiene estructura DTOResponse
        const horariosDisponibles = responseHorariosDisponibles.payload || responseHorariosDisponibles;
        const preReservasDeHorario = responsePreReservas.payload || responsePreReservas;
        
        return {
            horariosDisponibles,
            preReservasDeHorario
        };
    } catch (error) {
        console.error('Error al obtener horarios:', error);
        return {
            horariosDisponibles: [],
            preReservasDeHorario: []
        };
    }
}

/**
 * Maneja el evento changedDate para recargar horarios según la fecha seleccionada
 * @param {CustomEvent} event - Evento personalizado con la fecha seleccionada
 */
async function handleChangeMonthOrYear(event) {
    const fecha = event.detail.fecha;
    // Formatear la fecha a ISO para el query param
    const fechaParam = fecha instanceof Date ? fecha.toISOString() : fecha;
    let horariosDelDia = [];
    if (!existenEsosHorarios(fecha)) {
        // Obtener horarios disponibles y pre-reservados para la fecha
        try {
            const horariosData = await obtenerHorariosNuevos(fechaParam);
            // Agregar horarios usando la función agregarHorarios
            agregarHorarios(horariosData.horariosDisponibles, horariosData.preReservasDeHorario);                 
        } catch (error) {
            console.error('Error al recargar horarios por fecha:', error);
        }
    } 
     // Obtener horarios del día después de agregarlos
     const año = calendarInstance.selectedDate.getFullYear();
     const mes = calendarInstance.selectedDate.getMonth();
     const dia = calendarInstance.selectedDate.getDate();
     horariosDelDia = Object.values(horarios[año][mes]).flat();
    // Código común después de la condición
    if(calendarInstance){
        calendarInstance.disponibleDates = horariosDelDia;
        calendarInstance.render();
    }
    
    const selectedDateEvent = new CustomEvent('fechaSeleccionada', {
        detail: {
          fecha: calendarInstance.selectedDate
        }
      });
    document.dispatchEvent(selectedDateEvent);
}

/**
 * Inicializa las instancias del calendario y visualizador de horarios
 */
async function inicializarAgendador() {
    // Realizar peticiones al API
    try {
        console.log('Realizando peticiones al API...');
        
        // Obtener horarios
        const horarios = await obtenerHorariosNuevos();
        
        console.log('Pre-reservas obtenidas:', horarios.preReservasDeHorario);
        console.log('Horarios disponibles obtenidos:', horarios.horariosDisponibles);
        // Agregar horarios al estado del app
        agregarHorarios(horarios.horariosDisponibles, horarios.preReservasDeHorario);
        // Obtener entrenadores y llenar combobox
        const entrenadores = await obtenerEntrenadores();
        console.log('Entrenadores obtenidos:', entrenadores);
        
        // Buscar el combobox de entrenadores y llenarlo
        const comboboxEntrenadores = document.getElementById('inputEntrenador');
        
        fillCombobox(comboboxEntrenadores, {
            valueProperty: 'usuarioId',
            textProperty: ["nombre","apellido"]
        }, entrenadores);
        
        // Obtener clases y llenar combobox
        const clases = await obtenerClases();
        console.log('Clases obtenidas:', clases);
        
        // Buscar el combobox de clases y llenarlo
        const comboboxClases = document.getElementById('inputClase');
        
        fillCombobox(comboboxClases, {
            valueProperty: 'claseId',
            textProperty: 'nombreClase'
        }, clases);
        
        // Obtener estados de clases programadas y llenar combobox
        const estadosClasesProgramadas = await obtenerEstadosClasesProgramadas();
        console.log('Estados de clases programadas obtenidos:', estadosClasesProgramadas);
        
        // Buscar el combobox de estados y llenarlo
        const comboboxEstados = document.getElementById('inputEstadoActividad');
        
        fillCombobox(comboboxEstados, {
            valueProperty: 'idEstadoClaseProgramada',
            textProperty: 'nombresEstado'
        }, estadosClasesProgramadas);
            
        
        
    } catch (error) {
        console.error('Error al inicializar datos del API:', error);
    }
    
    // Crear instancia del calendario
    const calendarContainer = document.getElementById('calendar');
    const today = new Date();
    if (calendarContainer) {
        const monthSchedules = Object.values(horarios[today.getFullYear()][today.getMonth()]).flat();
        calendarInstance = new Calendar('calendar',monthSchedules );
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

    const changedDateEvent = new CustomEvent('changedDate', {
        detail: {
                fecha: calendarInstance.selectedDate
        }
    });
    document.dispatchEvent(changedDateEvent);
}

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', inicializarAgendador);

/**
 * Llena un combobox con datos de un arreglo de objetos
 * @param {HTMLElement} combobox - Elemento HTML select a llenar
 * @param {Object} config - Objeto con propiedades valueProperty y textProperty
 * @param {string} config.valueProperty - Nombre de la propiedad para el valor del option
 * @param {string|Array} config.textProperty - Nombre de la propiedad o arreglo de propiedades para el texto del option
 * @param {Array} datos - Arreglo de objetos con los datos para llenar el combobox
 */
function fillCombobox(combobox, config, datos) {
    // Limpiar opciones existentes
    combobox.innerHTML = '';
    
    // Agregar opción por defecto
    const optionDefault = document.createElement('option');
    optionDefault.value = '';
    optionDefault.textContent = 'Seleccione una opción...';
    combobox.appendChild(optionDefault);
    
    // Agregar opciones con los datos
    datos.forEach(item => {
        const option = document.createElement('option');
        option.value = item[config.valueProperty];
        
        // Manejar textProperty como string o array
        let textContent = '';
        if (Array.isArray(config.textProperty)) {
            // Si es un arreglo, concatenar los valores de las propiedades usando reduce
            textContent = config.textProperty
                .reduce((acc, prop) => acc ? `${acc} ${item[prop]}` : item[prop], '');
        } else {
            // Si es una propiedad simple, usar el valor directamente
            textContent = item[config.textProperty];
        }
        
        option.textContent = textContent;
        combobox.appendChild(option);
    });
}

/**
 * Obtiene los entrenadores disponibles del API
 * @returns {Array} Lista de entrenadores activos
 */
async function obtenerEntrenadores() {
    try {
        const params = {
            rol: 'empleado',
            estado: 'activo'
        };
        const response = await realizarPeticionAPI('obtenerUsuariosPorRol', undefined, params);
        return response.payload || [];
    } catch (error) {
        console.error('Error al obtener entrenadores:', error);
        return [];
    }
}

/**
 * Obtiene las clases disponibles del API
 * @returns {Array} Lista de clases disponibles
 */
async function obtenerClases() {
    try {
        const params = {
            activa: true
        };
        const response = await realizarPeticionAPI('clases/obtenerClases', undefined, params);
        return response.payload || [];
    } catch (error) {
        console.error('Error al obtener clases:', error);
        return [];
    }
}

/**
 * Obtiene los estados de clases programadas del API
 * @returns {Array} Lista de estados de clases programadas
 */
async function obtenerEstadosClasesProgramadas() {
    try {
        const response = await realizarPeticionAPI('clases/obtenerEstadosDeClasesProgramdas');
        return response.payload || [];
    } catch (error) {
        console.error('Error al obtener estados de clases programadas:', error);
        return [];
    }
} 