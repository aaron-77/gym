/**
 * Archivo principal para el agendador de horarios
 * Maneja la integración entre el calendario y el visualizador de horarios
 */

import { realizarPeticionAPI, getApiBaseUrl, getNginxBaseUrl, getSignalRBaseUrl } from './httpClient.js';
import { Calendar } from './calendario.js';
import { ScheduleViewer } from './horariosDelDia.js';
import { formDataToJson } from './formDataToJson.js';
import { showMessage,iconTypes } from './messageManager.mjs';
// Variables globales para las instancias
let calendarInstance;
let scheduleViewerInstance;

// Variable global para el catálogo de clases
let catalogoClases = [];

let horariosFormateados = [];
let horarios = {};
const formulario = document.getElementById("claseProgramadaForm");

// Variables para SignalR
let signalRConnection = null;
let isSignalRConnected = false;

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
    return arregloHorarios.map(horario =>{
        let fechaDeHorario = horario.fechaDisponible || horario.fecha;
        //let labelHorario = (horario.horaInicio)? `${horario.horaInicio} - ${horario.horaFin}`: horario.labelHorario;
        return {
            idHora: horario.idHora,
            horaInicio: horario.horaInicio,
            horaFin: horario.horaFin,
            fecha: new Date(fechaDeHorario),
            labelHorario:`${horario.horaInicio} - ${horario.horaFin}` ,
            estado: 'disponible'
        }
    });
}

/**
 * Formatea un arreglo de horarios pre-reservados al formato requerido
 * @param {Array} arregloHorarios - Array de objetos con horarios pre-reservados
 * @returns {Array} Array de objetos formateados con estructura {idHora, fecha, labelHorario, estado}
 */
function obtenerHorariosPreReservadosFormateados(arregloHorarios) {
    return arregloHorarios.map(horario => ({
        idHora: horario.idHora,
        fecha: new Date(horario.fechaDisponible),
        labelHorario: `${horario.horaInicio} - ${horario.horaFin}`,
        estado: 'prereservado'
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
        
        // se elimina el horario en caso de que ya exista, para manetener solo las versiones mas actuales
        const horariosFiltrados = horarios[año][mes][dia].filter(horarioExistente => horarioExistente.idHora != horario.idHora)
        horariosFiltrados.push(horario);
        // Agregar horario a la posición correspondiente
        horarios[año][mes][dia]= horariosFiltrados;
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
    const horariosDeDiaSeleccionado = horarios[año][mes][dia];
    return (horariosDeDiaSeleccionado && Array.isArray(horariosDeDiaSeleccionado))?horariosDeDiaSeleccionado: [];
    
    
}

/**
 * Obtiene los horarios para una fecha seleccionada que tengan un estado determinado
 * @param {Date} fechaSeleccionada - Fecha seleccionada en el calendario
 * @param {Date} estado - estado que deben tener los horarios recuperados
 * @returns {Array} Lista de horarios para esa fecha
 */
function obtenerHorariosPorFechaYEstado(fechaSeleccionada,estado) {
    const dia = fechaSeleccionada.getDate();
    const mes = fechaSeleccionada.getMonth();
    const año = fechaSeleccionada.getFullYear();
    let horariosDeDiaSeleccionado = horarios[año][mes][dia].filter(horario => horario.estado === estado);
    return (horariosDeDiaSeleccionado && Array.isArray(horariosDeDiaSeleccionado))?horariosDeDiaSeleccionado: [];
    
    
}

/**
 * Maneja el evento de fecha seleccionada en el calendario
 * @param {CustomEvent} event - Evento personalizado con la fecha seleccionada
 */
function handleSelectedDate(event) {
    const selectedDate = event.detail.fecha;
    const fechaFormateada = formatearFecha(selectedDate);
    const inputFechaSeleccionada = document.getElementById("fechaDeLaClase");
    if (inputFechaSeleccionada) inputFechaSeleccionada.value = selectedDate.toLocaleDateString('sv-SE');
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
    let  existenHorariosEnEseMes = false;
    if(horarios?.[año]?.[mes]){
         existenHorariosEnEseMes = Object.entries(horarios[año][mes]).some(([key, value]) => {
        // cada entry es un array con el numero de dia en la posicion 1(el par tiene la forma [numeroDeDia,arregloConLosHorariosDelDia]) y el valor de esa propiedad en la posicion 1 del array
        return value.some((horarioDelDiaItem => horarioDelDiaItem.estado=='disponible'));// se recorren los horarios del dia buscando que exista almenos 1 con estado disponible
    });
    }
    

    return existenHorariosEnEseMes;
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
        const responseHorariosDisponibles = await realizarPeticionAPI('/Horarios/obtenerHorariosDisponibles', undefined, params);
        const responsePreReservas = await realizarPeticionAPI('/Horarios/obtenerPreReservas', undefined, params);
        
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
    const fechaParam = fecha instanceof Date ? fecha.toLocaleDateString('sv-SE') : fecha;
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
    // Inicializar SignalR primero
    await inicializarSignalR();
    
    // Realizar peticiones al API
    try {
        console.log('Realizando peticiones al API...');
        
        // Obtener horarios
        const horarios = await obtenerHorariosNuevos();
        
        console.log('Pre-reservas obtenidas:',horarios.preReservasDeHorario);
        console.log('Horarios disponibles obtenidos:', horarios.horariosDisponibles);
        // Agregar horarios al estado del app
        agregarHorarios(horarios.horariosDisponibles, horarios.preReservasDeHorario);
        // Obtener entrenadores y llenar combobox
        const entrenadores = await obtenerEntrenadores();
        console.log('Entrenadores obtenidos:', entrenadores);
        
        // Buscar el combobox de entrenadores y llenarlo
        const comboboxEntrenadores = document.getElementById('inputEntrenador');
        
        fillCombobox(comboboxEntrenadores, {
            valueProperty: 'usuarioID',
            textProperty: ["nombre","apellido"]
        }, entrenadores);
        
        // Obtener clases y llenar combobox
        const clases = await obtenerClases();
        console.log('Clases obtenidas:', clases);
        
        // Buscar el combobox de clases y llenarlo
        const comboboxClases = document.getElementById('inputClase');
        
        fillCombobox(comboboxClases, {
            valueProperty: 'claseID',
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
        // Seleccionar por defecto la opción 'disponible' si existe usando findIndex, sin validar existencia del combobox
        const indexDisponible = Array.from(comboboxEstados.options).findIndex(opt => opt.text.trim().toLowerCase() === 'disponible');
        comboboxEstados.selectedIndex = indexDisponible;
        
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
    document.addEventListener('scheduleSelected', handleSelectedSchedule);

    const changedDateEvent = new CustomEvent('changedDate', {
        detail: {
                fecha: calendarInstance.selectedDate
        }
    });
    document.dispatchEvent(changedDateEvent);
}

// Inicializar cuando el DOM esté listo o inmediatamente si ya está cargado
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', inicializarAgendador);
} else {
    inicializarAgendador();
}

// Cerrar conexión SignalR cuando se cierre la página
window.addEventListener('beforeunload', cerrarConexionSignalR);

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
        const response = await realizarPeticionAPI('/obtenerUsuariosPorRol', undefined, params);
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
        const response = await realizarPeticionAPI('/Clases/obtenerClases', undefined, params);
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
        const response = await realizarPeticionAPI('/Clases/obtenerEstadosDeClasesProgramdas');
        return response.payload || [];
    } catch (error) {
        console.error('Error al obtener estados de clases programadas:', error);
        return [];
    }
}


/**
 * Función para registrar una clase programada usando FormData
 * @param {Event} event - Evento del formulario
 */
async function registrarClaseProgramada(event) {
    event.preventDefault();
    if (!formulario.checkValidity()) {
        event.stopPropagation();
        return;
    }
    formulario.classList.add('was-validated');
    try {
        // Obtener el formulario
        const formulario = event.target;
        
        // Crear objeto FormData con los datos del formulario
        const formData = new FormData(formulario);
        
        // Imprimir los campos del FormData después de crearlo
        console.log('Campos del FormData después de crearlo:');
        for (let [key, value] of formData.entries()) {
            console.log(`${key}: ${value}`);
        }

        const idPrereserva = getFromLocalStorage("idPreReserva");
        // Agregar solo los campos adicionales requeridos
        formData.append('idUsuarioQueReserva', 'jasjkskmamsasma');
        formData.append('idPreservaDeHorario', idPrereserva);
        
        // Convertir FormData a objeto JSON usando la función importada
        const datosClaseProgramada = formDataToJson(formData);
        
        console.log('Datos a enviar:', datosClaseProgramada);
        
        // Realizar la petición POST al endpoint
        const response = await realizarPeticionAPI('/clases/registrarClaseProgramada', datosClaseProgramada);
        
        if (response.success) {
            showMessage(iconTypes.success,'Clase programada registrada exitosamente con ID: ');
  
            // Limpiar el formulario
            limpiarFormularioExeptoFecha(formulario);
            // Limpiar la  del horario
            if (scheduleViewerInstance) {
                scheduleViewerInstance.clearSelection();
                document.getElementById('fkHoraLaboral').value = '';
            }
            // Actualizar el label de horario seleccionado
            const label = document.getElementById('labelHorarioSeleccionado');
            if (label) {
                label.textContent = 'Horario seleccionado: ninguno';
            }
            
        } else {
            showMessage(iconTypes.success,response.message);
            let detailedErrors = '';
            if (response.errors && response.errors.length > 0) {
                detailedErrors += ': ' + response.errors.map(e => e.message).join(', ');
                console.log(detailedErrors)
            } 
            
        }
        formulario.classList.remove('was-validated');
    } catch (error) {
        showMessage(iconTypes.success,response.message);
        console.error('Error al registrar clase programada:', error);
    }
} 


formulario.addEventListener('submit', registrarClaseProgramada);

/**
 * Inicializa la conexión SignalR con el servidor
 * @returns {Promise<void>}
 */
async function inicializarSignalR() {
    try {
        // Verificar si SignalR está disponible
        if (typeof signalR === 'undefined') {
            console.warn('SignalR no está disponible. Asegúrate de incluir la librería SignalR.');
            return;
        }

        // Obtener la URL base del API desde la configuración
        const signalRBaseUrl = getSignalRBaseUrl();
        const signalRUrl = `${signalRBaseUrl}/reservacionesHub`;
        
        // Crear la conexión al hub
        signalRConnection = new signalR.HubConnectionBuilder()
            .withUrl(signalRUrl)
            .withAutomaticReconnect([0, 2000, 10000, 30000]) // Estrategia de reconexión automática
            .configureLogging(signalR.LogLevel.Information)
            .build();

        // Configurar event listeners para la conexión
        configurarEventosConexionSignalR();

        // Configurar event listeners para los métodos del hub
        configurarMetodosHubSignalR();

        // Iniciar la conexión
        await signalRConnection.start();
        console.log('Conexión SignalR establecida correctamente');
        isSignalRConnected = true;

    } catch (error) {
        console.error('Error al conectar con SignalR:', error);
        isSignalRConnected = false;
    }
}

/**
 * Configura los eventos de la conexión SignalR
 */
function configurarEventosConexionSignalR() {
    if (!signalRConnection) return;

    // Evento cuando la conexión se establece
    signalRConnection.onreconnected((connectionId) => {
        console.log('SignalR reconectado con ID:', connectionId);
        isSignalRConnected = true;
        // Recargar datos después de la reconexión
        recargarDatosDespuesReconexion();
    });

    // Evento cuando la conexión se pierde
    signalRConnection.onclose((error) => {
        console.log('Conexión SignalR cerrada:', error);
        isSignalRConnected = false;
    });

    // Evento cuando hay un error en la conexión
    signalRConnection.onreconnecting((error) => {
        console.log('Reconectando SignalR:', error);
        isSignalRConnected = false;
    });
}

/**
 * Configura los métodos del hub para recibir actualizaciones
 */
function configurarMetodosHubSignalR() {
    if (!signalRConnection) return;

    // Método para recibir actualizaciones de horarios disponibles
    signalRConnection.on('actualizarHorariosDisponibles', (respuesta) => {
        console.log('Actualización de horarios disponibles recibida:', respuesta);
        manejarActualizacionHorariosDisponibles(respuesta);
    });

    // Método para recibir actualizaciones de pre-reservas
    signalRConnection.on('actualizarPreReservasDeHorario', (respuesta) => {
        console.log('Actualización de pre-reservas recibida:', respuesta);
        manejarActualizacionPreReservas(respuesta);
    });
}

/**
 * Maneja las actualizaciones de horarios disponibles recibidas por SignalR
 * @param {Object} respuesta - Respuesta del servidor con los horarios disponibles
 */
function manejarActualizacionHorariosDisponibles(respuesta) {
    try {
        if (respuesta && respuesta.success && respuesta.payload) {
            // Limpiar completamente el objeto horarios
            limpiarHorariosPorFechaYEstado(calendarInstance.selectedDate,'disponible');
            let horariosPrereservadosExistentes = obtenerHorariosPorFechaYEstado(calendarInstance.selectedDate,'prereservado');
            // Agregar los nuevos horarios disponibles
            const horariosDisponibles = respuesta.payload;
            agregarHorarios(horariosDisponibles, horariosPrereservadosExistentes);
            
            
            // Actualizar la vista si hay una fecha seleccionada
            if (calendarInstance && calendarInstance.selectedDate) {
                actualizarVistaFechaSeleccionada(calendarInstance.selectedDate);
            }
            
            console.log('Horarios disponibles actualizados correctamente');
        } else {
            console.warn('Respuesta de horarios disponibles inválida:', respuesta);
        }
    } catch (error) {
        console.error('Error al manejar actualización de horarios disponibles:', error);
    }
}

/**
 * Maneja las actualizaciones de pre-reservas recibidas por SignalR
 * @param {Object} respuesta - Respuesta del servidor con las pre-reservas
 */
function manejarActualizacionPreReservas(respuesta) {
    try {
        if (respuesta && respuesta.success && respuesta.payload) {
            // Limpiar completamente el objeto horarios
            limpiarHorariosPorFechaYEstado(calendarInstance.selectedDate,'prereservado');
            let horariosDisponiblesExistentes = obtenerHorariosPorFechaYEstado(calendarInstance.selectedDate,'disponible');
            // Agregar las nuevas pre-reservas
            const preReservas = respuesta.payload;
            agregarHorarios(horariosDisponiblesExistentes, preReservas);
            
            // Actualizar la vista si hay una fecha seleccionada
            if (calendarInstance && calendarInstance.selectedDate) {   
                actualizarVistaFechaSeleccionada(calendarInstance.selectedDate);
            }
            
            console.log('Pre-reservas actualizadas correctamente');
        } else {
            console.warn('Respuesta de pre-reservas inválida:', respuesta);
        }
    } catch (error) {
        console.error('Error al manejar actualización de pre-reservas:', error);
    }
}

/**
 * Limpia completamente el objeto horarios y lo reinicia como un objeto vacío
 */
function limpiarHorarios() {
    horarios = {};
}
function limpiarHorariosPorFechaYEstado(fecha,estado){
    const año = fecha.getFullYear();
    const mes = fecha.getMonth();
    const dia = fecha.getDate();
    let horariosFiltrados  = []
    try {
        horariosFiltrados = horarios[año][mes][dia].filter(horario => horario.estado != estado);    
        horarios[año][mes][dia] = horariosFiltrados;
    } catch (error) {
      console.log("error al limpiar los horarios: ", error);  
    }
    
}

/**
 * Actualiza la vista para una fecha seleccionada después de recibir actualizaciones
 * @param {Date} fecha - Fecha seleccionada
 */
function actualizarVistaFechaSeleccionada(fecha) {
    const añoDeFechaSeleccionada = fecha.getFullYear();
    const mesDeFechaSeleccionada = fecha.getMonth();
    const diaDeFechaSeleccionada = fecha.getDate();
    
    // Verificar si existen horarios para el día, mes y año de la fecha seleccionada
    const existenHorariosParaEsaFecha = horarios[añoDeFechaSeleccionada][mesDeFechaSeleccionada][diaDeFechaSeleccionada];
    
    // Si no existen horarios para esa fecha, deshabilitar el día en el calendario
     if (!existenHorariosParaEsaFecha && calendarInstance) {
        const botonDia = calendarInstance.obtenerDiaDelMesHtml(fecha);
        if (botonDia) {
            calendarInstance.deshabilitarDia(botonDia);
        }
    } 
    
    if (scheduleViewerInstance) {
        const horariosDelDia = obtenerHorariosPorFecha(fecha);
        const fechaFormateada = formatearFecha(fecha);
        scheduleViewerInstance.setSelectedDate(fechaFormateada);
        scheduleViewerInstance.loadSchedules(horariosDelDia);
    }
    
    // Actualizar el calendario si es necesario
    /*
    if (calendarInstance) {
        const año = fecha.getFullYear();
        const mes = fecha.getMonth();
        const horariosDelMes = Object.values(horarios[año][mes] || {}).flat();
        calendarInstance.disponibleDates = horariosDelMes;
        calendarInstance.render();
    }
        */
}

/**
 * Recarga los datos después de una reconexión de SignalR
 */
async function recargarDatosDespuesReconexion() {
    try {
        console.log('Recargando datos después de reconexión...');
        
        // Obtener horarios actualizados
        const horariosData = await obtenerHorariosNuevos();
        
        // Limpiar completamente y agregar horarios
        limpiarHorarios();
        agregarHorarios(horariosData.horariosDisponibles, horariosData.preReservasDeHorario);
        
        // Actualizar vistas si es necesario
        if (calendarInstance && calendarInstance.selectedDate) {
            actualizarVistaFechaSeleccionada(calendarInstance.selectedDate);
        }
        
        console.log('Datos recargados correctamente después de reconexión');
    } catch (error) {
        console.error('Error al recargar datos después de reconexión:', error);
    }
}

/**
 * Limpia todos los inputs y combobox del formulario excepto el campo de la fecha
 * @param {HTMLFormElement} formulario - El formulario a limpiar
 */
function limpiarFormularioExeptoFecha(formulario) {
    // Obtener el input de la fecha
    const inputFecha = document.getElementById("fechaDeLaClase");
    // Guardar el valor de la fecha
    const valorFecha = inputFecha ? inputFecha.value : null;
    formulario.reset();
    // Restaurar el valor de la fecha
    if (inputFecha && valorFecha !== null) {
        inputFecha.value = valorFecha;
    }

}


/**
 * Cierra la conexión SignalR de forma segura
 */
async function cerrarConexionSignalR() {
    try {
        if (signalRConnection && isSignalRConnected) {
            await signalRConnection.stop();
            console.log('Conexión SignalR cerrada correctamente');
        }
        isSignalRConnected = false;
    } catch (error) {
        console.error('Error al cerrar conexión SignalR:', error);
    }
}
function handleSelectedSchedule (event){
    // Mostrar la fecha y hora seleccionada en el label
    const label = document.getElementById("labelHorarioSeleccionado");
    if (label) {
      const horario = event.detail.schedule;
      // Obtener la fecha seleccionada del header del calendario
      const fecha = document.getElementById("scheduleDate")?.textContent || "";
      const inputFkHoraLaboral = document.getElementById("fkHoraLaboral");
      if (inputFkHoraLaboral && horario) inputFkHoraLaboral.value = horario.idHora;
      if (horario && fecha) {
        label.textContent = `Seleccionaste: ${fecha} - ${horario.labelHorario}`;
      } else if (horario) {
        label.textContent = `Horario seleccionado: ${horario.labelHorario}`;
      } else {
        label.textContent = "No hay horario seleccionado";
      }
    }    
}

