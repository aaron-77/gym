import { realizarPeticionAPI } from './httpClient.js';
import { CalendarInscripcion } from './calendarioInscripcion.js';
import { ScheduleViewerInscripciones } from './inscriptorDeClasesScheduler.js';
import { formDataToJson } from './formDataToJson.js';
import { showMessage,iconTypes,showSimpleDialog,showComplexDialog } from './messageManager.mjs';
// Variables globales
let calendarInstance;
let scheduleViewerInstance;
let horarios = {};
let signalRConnection = null;
let isSignalRConnected = false;
let horaLaboralSeleccionada = null;
let idProgramacionClaseSeleccionada = null;
let comboClases = document.getElementById('comboClases');
// Referencias globales a los inputs
let inputFechaSeleccionada = document.getElementById('fechaDeLaClase');
let inputHoraSeleccionada = document.getElementById('fkHoraLaboral');
let idClaseSeleccionada = null;
/**
 * Formatea un arreglo de clases disponibles al formato requerido
 * @param {Array} arregloClases - Array de objetos con clases disponibles
 * @returns {Array} Array de objetos formateados con estructura {idHora, fecha, labelHorario, estado}
 */
function obtenerHorariosDisponiblesFormateados(arregloClases) {
    return arregloClases.map(clase => ({
        idHora: clase.idHora,
        fecha: new Date(clase.fechaDeLaClase),
        labelHorario: `${clase.horaInicio} - ${clase.horaFin}`,
        ...clase
    }));
}

/**
 * Agrega clases disponibles al objeto horarios
 * @param {Array} clasesDisponibles - Array de objetos con clases disponibles
 */
function agregarHorarios(clasesDisponibles) {

    // Organizar horarios por año, mes y día
    clasesDisponibles.forEach(horario => {
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
        // se elimina el horario en caso de que ya exista, para mantener solo las versiones más actuales
        let horariosFiltrados = horarios[año][mes][dia].filter(horarioExistente => horarioExistente.idHora != horario.idHora);
        horariosFiltrados.push(horario);
        horariosFiltrados = horariosFiltrados.filter(horarioExistente => horarioExistente.cupoDisponible >= 1);        
        horarios[año][mes][dia] = horariosFiltrados;
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
    const horariosDeDiaSeleccionado = horarios[año]?.[mes]?.[dia];
    return (horariosDeDiaSeleccionado && Array.isArray(horariosDeDiaSeleccionado)) ? horariosDeDiaSeleccionado : [];
}

function obtenerClasesDelMes(fechaSeleccionada) {
    const mes = fechaSeleccionada.getMonth();
    const año = fechaSeleccionada.getFullYear();
    const clasesDelMes = Object.values(horarios[año][mes]).flat();
    return clasesDelMes;
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
    const horariosDelMesSeleccionado = horarios[año]?.[mes];
    const existenDatosEnEseMes = (horariosDelMesSeleccionado) ? Object.keys(horariosDelMesSeleccionado).length > 0 : false;
    return horariosDelMesSeleccionado && existenDatosEnEseMes;
}

/**
 * Obtiene clases disponibles para una fecha específica
 * @param {string} fecha - Fecha en formato ISO para el query param
 * @returns {Object} Objeto con clasesDisponibles
 */
async function obtenerClasesDisponibles() {
    try {
        const params = {};
        params.activa = true;

        const response = await realizarPeticionAPI('clases/obtenerClases', undefined, params);
        const clasesDisponibles = response.payload || response;
        console.log("CLASES DISPONIBLES CONSULTADAS:", clasesDisponibles);
        return clasesDisponibles
    } catch (error) {
        console.error('Error al obtener clases disponibles:', error);
        return {
            clasesDisponibles: []
        };
    }
}

/**
 * Obtiene clases programadas para un idClase específico
 * @param {number} idClase - ID de la clase a consultar
 * @returns {Object} Objeto con clasesProgramadas
 */
async function obtenerClasesProgramadas(idClase = null) {
    try {
        const params = {};
        if (idClase) {
            params.idClase = idClase;
        }
        const response = await realizarPeticionAPI('clases/obtenerClasesProgramadasPorId', undefined, params);
        const clasesProgramadas = response.payload || response;

        return clasesProgramadas

    } catch (error) {
        console.error('Error al obtener clases programadas:', error);
        return {
            clasesProgramadas: []
        };
    }
}



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
 * Determina si hay al menos una clase programada para la fecha analizada
 * @param {Array} clasesProgramadas - Array de objetos con clases programadas
 * @param {Date|int} fechaAnalizada - Fecha a analizar (puede ser Date o timestamp)
 * @returns {boolean} true si existe al menos una clase programada para esa fecha
 */
function statusDeterminator(clasesProgramadas, fechaAnalizada) {
    try {
        // Normalizar fechaAnalizada a formato YYYY-MM-DD
        let fechaStr;
        if (fechaAnalizada instanceof Date) {
            fechaStr = fechaAnalizada.toLocaleDateString('sv-SE');
        } else if (typeof fechaAnalizada === 'string') {
            fechaStr = new Date(fechaAnalizada).toLocaleDateString('sv-SE');
        } comboClases
        return clasesProgramadas.some(clase => {
            const claseFecha = new Date(clase.fechaDeLaClase).toLocaleDateString('sv-SE');
            return claseFecha === fechaStr;
        });
    } catch (error) {
        console.error('Error en statusDeterminator:', error);
        return false;
    }
}

/**
 * Inicializa el calendario de inscripción
 * @param {string} containerId
 * @param {Array} disponibleDates
 * @param {function} selectedDayHandler
 * @param {function} statusDeterminator
 */
function inicializarCalendario(containerId, disponibleDates = [], selectedDayHandler = null, statusDeterminator = null) {
    try {
        let clasesDelMesDeClaseSeleccionada = disponibleDates.length > 0 ? disponibleDates : obtenerClasesDelMes(new Date()).filter(claseProgramada => claseProgramada.fkClase === idClaseSeleccionada);
        
        calendarInstance = new CalendarInscripcion(containerId, clasesDelMesDeClaseSeleccionada, selectedDayHandler, statusDeterminator);
        calendarInstance.init();
        
        document.dispatchEvent(new CustomEvent('fechaSeleccionada', {
            detail: {
                fecha: calendarInstance.selectedDate
            }
        }));
    } catch (error) {
        console.error('Error al inicializar el calendario:', error);
    }
}

/**
 * Handler para cuando se selecciona una clase disponible en el combo
 * @param {Event} event
 */
async function claseDisponibleSeleccionadaHandler(event) {
    try {
        event.preventDefault();
        // Obtener el valor seleccionado en el combo usando el form (solo hay un form)
        const combo = document.querySelector('form').getElementById("comboClases");
        idClaseSeleccionada = parseInt(combo.value);
        // 3. Llamar a obtenerClasesProgramadas con el id de la clase seleccionada
        const { clasesProgramadas } = await obtenerClasesProgramadas(idClaseSeleccionada);
        // 4. Llamar a agregarHorarios con el resultado
        agregarHorarios(clasesProgramadas);
        // 5. (Puedes agregar aquí lógica adicional si es necesario)
    } catch (error) {
        console.error('Error en claseDisponibleSeleccionadaHandler:', error);
    }
}

/**
 * Función lambda para cargar el agendador con las clases programadas de una fecha
 * @param {Date} fechaDeLasClasesProgramadas - Fecha para cargar las clases programadas
 */
const cargarAgendador = (fechaDeLasClasesProgramadas) => {
    const clasesProgramadasDelDia = obtenerHorariosPorFecha(fechaDeLasClasesProgramadas);
    calendarInstance.loadSchedules(clasesProgramadasDelDia);

};

/**
 * Maneja el evento de selección de clase en el comboClases
 */
async function handleClaseSelected(ev) {
    try {
        idClaseSeleccionada = parseInt(ev.currentTarget.value);
        if (!idClaseSeleccionada) {
            return;
        }
        if (!existeClaseEnHorarios(horarios, 'fkClase', idClaseSeleccionada)) {

            const clasesProgramadas = await obtenerClasesProgramadas(idClaseSeleccionada);
            const clasesProgramadasFormateadas = obtenerHorariosDisponiblesFormateados(clasesProgramadas);
            agregarHorarios(clasesProgramadasFormateadas); 
            
        }
        let clasesProgramadasMensualesDeClaseSeleccionada = obtenerClasesDelMes(new Date()).filter(clase => clase.fkClase === idClaseSeleccionada);
        inicializarCalendario('calendar', clasesProgramadasMensualesDeClaseSeleccionada, null, hayClasesDisponibles);
        inicializarAgendador();
         document.dispatchEvent(new CustomEvent('fechaSeleccionada', {
            detail: {
                fecha: calendarInstance.selectedDate
            }
        }));

    } catch (error) {obtenerHorariosPorFecha
        console.error('Error en handleClaseSelected:', error);
    }
}

/**
 * Inicializa el inscriptor de clases: carga clases disponibles, agrega horarios y llena el combobox de clases
 */
async function inicializarInscriptor() {
    try {
        bindEvents();
        await inicializarSignalR();

        // Cargar clases disponibles
        const clasesDisponibles = await obtenerClasesDisponibles();
        const clientes = await obtenerClientes('cliente');
        comboClases = document.getElementById('comboClases');
        const comboClientes = document.getElementById('comboCliente');
        fillCombobox(comboClases, {
            valueProperty: 'claseID',
            textProperty: 'nombreClase'
        }, clasesDisponibles);

        fillCombobox(comboClientes, {
            valueProperty: 'usuarioID',
            textProperty: ['nombre', 'apellido']
        }, clientes);


    } catch (error) {
        console.error('Error al inicializar el inscriptor:', error);
    }
}

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

        // Crear la conexión al hub
        signalRConnection = new signalR.HubConnectionBuilder()
            .withUrl('http://localhost:5274/reservacionesHub')
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
        // Puedes agregar aquí lógica para recargar datos si es necesario
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
    signalRConnection.on('actualizarCuposDeClases', (respuesta) => {
        console.log('Actualización de cupos de clases recibida:', respuesta);
        manejarActualizacionDeCuposDeClases(respuesta);
    });

    // Nuevo método para clases programadas
    signalRConnection.on('actualizarClasesProgramadas', (respuesta) => {
        console.log('Actualización de clases programadas recibida:', respuesta);
        manejarActualizacionDeCuposDeClases(respuesta);
    });
}

/**
 * Maneja las actualizaciones de cupos de clases recibidas por SignalR
 * @param {Object} respuesta - Respuesta del servidor con los horarios disponibles
 */
function manejarActualizacionDeCuposDeClases(respuesta) {
    try {
        if (respuesta && respuesta.success && respuesta.payload) {
            const existenHorariosParaEsaFecha = horarios[calendarInstance.selectedDate.getFullYear()][calendarInstance.selectedDate.getMonth()][calendarInstance.selectedDate.getDate()];
            // Limpiar completamente el objeto horarios
            limpiarHorariosPorFecha(calendarInstance.selectedDate, 'disponible');
            // Agregar los nuevos horarios disponibles
            const clasesProgramadas = obtenerHorariosDisponiblesFormateados(respuesta.payload);
            agregarHorarios(clasesProgramadas);
            // Actualizar la vista si hay una fecha seleccionada
            if (calendarInstance && calendarInstance.selectedDate) {

                // Aquí deberías tener una función para actualizar la vista, si la tienes
                actualizarHtmlElementDiaSeleccionado(calendarInstance.selectedDate);
                const selectedDate = calendarInstance.selectedDate;
                const fechaFormateada = formatearFecha(selectedDate);
                const idClase = parseInt(comboClases.value);
                let claseSeleccionada = obtenerHorariosPorFecha(selectedDate).filter(claseProgramada => claseProgramada.idHora === horaLaboralSeleccionada);
                actualizarClasesDisponiblesPorClaseIdEnScheduler(selectedDate, idClase, fechaFormateada);
                reseleccionarHorario(horaLaboralSeleccionada,claseSeleccionada);
            } if (!existenHorariosParaEsaFecha && calendarInstance) {
                const botonDia = calendarInstance.obtenerDiaDelMesHtml(fecha);
                if (botonDia) {
                    calendarInstance.deshabilitarDia(botonDia);
                }
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
 * Limpia completamente el objeto horarios y lo reinicia como un objeto vacío
 */
function limpiarHorarios() {
    horarios = {};
}

/**
 * Limpia los horarios de un día y estado específico
 */
function limpiarHorariosPorFecha(fecha) {
    const año = fecha.getFullYear();
    const mes = fecha.getMonth();
    const dia = fecha.getDate();
    let horariosFiltrados = [];
    try {
        horariosFiltrados = horarios[año][mes][dia];
        horarios[año][mes][dia] = horariosFiltrados;
    } catch (error) {
        console.log('error al limpiar los horarios: ', error);
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

function actualizarHtmlElementDiaSeleccionado(fecha) {
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

    /* if (scheduleViewerInstance) {
        const horariosDelDia = obtenerHorariosPorFecha(fecha);
        const fechaFormateada = formatearFecha(fecha);
        scheduleViewerInstance.setSelectedDate(fechaFormateada);
        scheduleViewerInstance.loadSchedules(horariosDelDia);
        reseleccionarHorario(horaLaboralSeleccionada);
    } */

}

function scrollToScheduleViewer() {
    const scheduleViewer = document.getElementById('scheduleViewer');
    const offset = 60; // Ajusta este valor según la altura de tu menú fijo
    if (scheduleViewer) {
        const rect = scheduleViewer.getBoundingClientRect();
        const y = rect.top + window.pageYOffset - offset;
        window.scrollTo({ top: y, behavior: 'smooth' });
    }
}
//maneja el evento externo generado por calendarioInscripcion.js a seleccionar un dia en el calendario
// este evento sincroniza la seleccion de la fecha en el calendario con cualquier otra accion
//que tenga que se realizada por el componente principal o cualquier otro componente externo o archivo javascript independiente
function handleSelectedDate(ev) {
    const selectedDate = ev.detail.fecha;
    const fechaFormateada = formatearFecha(selectedDate);
    const inputFechaSeleccionada = document.getElementById("fechaDeLaClase");
    inputFechaSeleccionada.value = selectedDate.toLocaleDateString('sv-SE');
    scrollToScheduleViewer();
    // Actualizar el visualizador de horarios con la fecha seleccionada
    if (scheduleViewerInstance) {
        const idClase = parseInt(comboClases.value);
        // Obtener los horarios para la fecha seleccionada
        actualizarClasesDisponiblesPorClaseIdEnScheduler(selectedDate, idClase, fechaFormateada)
    }

    console.log('Fecha seleccionada en agendador:', fechaFormateada);
}

function handleSelectedSchedule(event) {

    const horario = event.detail.schedule;
    // Obtener la fecha seleccionada del header del calendario
    const fecha = document.getElementById("scheduleDate")?.textContent || "";
    const inputFkHoraLaboral = document.getElementById("fkHoraLaboral");
    const inputIdProgramacionClase = document.getElementById("idProgramacionClase");
    inputFkHoraLaboral.value = horario.idHora;
    horaLaboralSeleccionada = horario.idHora;
    inputIdProgramacionClase.value = horario.idClaseProgramada;

    if (horario) {
        asignarValorLabelEntrenador(horario.nombreEntrenador)
        asignarValorLabelEspaciosDisponibles(horario.cupoDisponible);
    } else {
        asignarValorLabelEntrenador("no has seleccionado una clase");
        asignarValorLabelEspaciosDisponibles("no has seleccionado una clase");
    }
    scrollToSelectedLabel();
}

/**
* Asigna el evento 'fechaSeleccionada' y usa handleSelectedDate como escuchador
*/
function bindEvents() {
    document.addEventListener('fechaSeleccionada', handleSelectedDate);
    document.addEventListener('scheduleSelected', handleSelectedSchedule);
    comboClases.addEventListener('change', handleClaseSelected);
    const formularioInscripcion = document.getElementById('formInscripcionClase');
    formularioInscripcion.addEventListener('submit', inscribirAClase);
}
function scrollToSelectedLabel() {
    const label = document.getElementById('labelHorarioSeleccionado');
    const offset = 60; // Ajusta este valor según la altura de tu menú fijo

    if (label) {
        const rect = label.getBoundingClientRect();
        const y = rect.top + window.pageYOffset - offset;
        window.scrollTo({ top: y, behavior: 'smooth' });
    }
}

/**
 * Actualiza el cupo disponible de una clase programada específica
 * @param {Date} fecha - Fecha de la clase programada
 * @param {number} idProgramacionClase - ID de la programación de clase
 * @param {number} cupoActualizado - Nuevo valor del cupo disponible
 */
function actualizarCupoDeClaseProgramada(fecha, idProgramacionClase, cupoActualizado) {
    try {
        // Extraer año, mes y día de la fecha
        const año = fecha.getFullYear();
        const mes = fecha.getMonth() + 1;
        const dia = fecha.getDate();

        // Intentar acceder directamente a los índices
        const horariosDia = horarios[año][mes][dia];
        const claseProgramada = horariosDia.find(h => h.idProgramacionClase === idProgramacionClase);
        claseProgramada.cupoDisponible = cupoActualizado;

    } catch (error) {
        console.error(`Error al actualizar cupo: No se encontró la estructura para fecha=${fecha}, idProgramacionClase=${idProgramacionClase}`, error);
    }
}

/**
 * Verifica si hay clases disponibles para una fecha específica
 * @param {Array} clasesProgramadas - Array de clases programadas
 * @param {Date} fecha - Fecha a verificar
 * @returns {boolean} True si hay al menos una clase disponible para esa fecha
 */
function hayClasesDisponibles(clasesProgramadas, fecha) {
    let result = false;
    try {
        
        // Convertir la fecha recibida a formato YYYY-MM-DD
        const fechaStr = fecha.toLocaleDateString('sv-SE');

        // Verificar si existe al menos una clase que cumpla las condiciones
        return clasesProgramadas.some(clase => {
            const fechaClase = new Date(clase.fecha).toLocaleDateString('sv-SE');
            result = fechaClase === fechaStr && clase.cupoDisponible >= 1;
            return result;
        });
        
    } catch (error) {
        console.error('Error en hayClasesDisponibles:', error);
        result = false;
    }
    return result;
}

/**
 * Inicializa el agendador de clases, incluyendo calendario y visualizador
 * @param {string} calendarContainerId - ID del contenedor del calendario
 * @param {string} scheduleContainerId - ID del contenedor del visualizador
 */scheduleViewer
function inicializarAgendador(scheduleContainerId = 'scheduleViewer') {
    try {
        const scheduleContainer = document.getElementById(scheduleContainerId);
        if (scheduleContainer) {
            scheduleViewerInstance = new ScheduleViewerInscripciones(scheduleContainerId);
            scheduleViewerInstance.init();
            console.log('Visualizador de horarios inicializado');
        }
        console.log('Agendador inicializado correctamente');
    } catch (error) {
        console.error('Error al inicializar el agendador:', error);
    }
}

/**
 * Busca una clase específica basada en fecha y hora
 * @param {string|Date} fechaDeLaClase - Fecha de la clase a buscar
 * @param {number} idHoraDeLaClase - ID del horario de la clase
 * @param {Array} datos - Array de clases programadas
 * @returns {Object|null} Objeto de la clase encontrada o null si no existe
 */
function obtenerClaseSeleccionada(fechaDeLaClase, idHoraDeLaClase, datos) {
    try {
        const fechaBuscada = fechaDeLaClase.toLocaleDateString('sv-SE');

        const claseEncontrada = datos.find(clase => {
            const fechaClase = clase.fecha.toLocaleDateString('sv-SE');
            return fechaClase === fechaBuscada && clase.idHora === idHoraDeLaClase;
        });

        return claseEncontrada || null;

    } catch (error) {
        console.error('Error en obtenerClaseSeleccionada:', error);
        return null;
    }
}



/**
 * Obtiene los valores seleccionados de fecha y hora
 * @returns {Object|null} Objeto con fecha y hora seleccionadas o null si no hay selección
 */
function obtenerFechaYHoraSeleccionados() {
    try {
        if (!inputFechaSeleccionada || !inputHoraSeleccionada) {
            console.warn('Los inputs de fecha u hora no están disponibles');
            return null;
        }

        const fechaSeleccionada = inputFechaSeleccionada.value;
        const idHoraSeleccionada = parseInt(inputHoraSeleccionada.value);

        if (!fechaSeleccionada || !idHoraSeleccionada) {
            console.warn('No hay fecha u hora seleccionada');
            return null;
        }

        return {
            fecha: new Date(fechaSeleccionada),
            idHora: idHoraSeleccionada
        };
    } catch (error) {
        console.error('Error al obtener valores seleccionados:', error);
        return null;
    }
}

/**
 * Muestra el nombre del entrenador en la etiqueta correspondiente
 * @param {string} nombreEntrenador - Nombre del entrenador a mostrar
 */
function asignarValorLabelEntrenador(nombreEntrenador) {
    try {
        const labelEntrenador = document.getElementById('labelEntrenador');
        labelEntrenador.textContent = nombreEntrenador || 'No hay entrenador asignado';

    } catch (error) {
        console.error('Error al mostrar nombre del entrenador:', error);
    }
}

/**
 * Muestra el número de espacios disponibles en la etiqueta correspondiente
 * @param {string} textoParaElLabel - Texto a mostrar en el label
 */
function asignarValorLabelEspaciosDisponibles(textoParaElLabel) {
    try {
        const labelEspacios = document.getElementById('labelEspaciosDisponibles');
        labelEspacios.textContent = textoParaElLabel || 'No hay información de espacios disponibles';

    } catch (error) {
        console.error('Error al mostrar espacios disponibles:', error);
    }
}

async function inscribirAClase(event) {
    let formulario = event.currentTarget;
    event.preventDefault();

    if (!formulario.checkValidity()) {
        
        event.stopPropagation();
        return;
    }
    formulario.classList.add('was-validated');
    try {
        // Crear objeto FormData con los datos del formulario
        const formData = new FormData(formulario);

        // Imprimir los campos del FormData después de crearlo

        formData.delete("fechaDeLaClase");
        formData.delete("comboClases");
        formData.delete("fkHoraLaboral");
        console.log('Campos del FormData después de quitarle campos:');
        for (let [key, value] of formData.entries()) {
            console.log(`${key}: ${value}`);
        }

        // Convertir FormData a objeto JSON usando la función importada
        const datosClaseProgramada = formDataToJson(formData);
        console.log('Datos a enviar:', datosClaseProgramada);
        // Realizar la petición POST al endpoint
        const response = await realizarPeticionAPI('clases/inscribirAClase', datosClaseProgramada);

        if (response.success) {
            showMessage(iconTypes.success,'Inscripción exitosa' );
            // Limpiar el formulario
            //limpiarFormularioCompleto(formulario);
            limpiarFormularioPorCampos(formulario, ["idCliente", "fkHoraLaboral", "idProgramacionClase"]);
            // Limpiar la  del horario
            if (scheduleViewerInstance) {
                scheduleViewerInstance.clearSelection();
                document.getElementById('fkHoraLaboral').value = '';
            }
            // Actualizar el label de horario seleccionado
            const labelEntrenador = document.getElementById('labelEntrenador');
            const labelEspaciosDisponibles = document.getElementById('labelEspaciosDisponibles');
            labelEntrenador.textContent = 'Selecciona una clase';
            labelEspaciosDisponibles.textContent = '0';
        } else {
            showMessage(iconTypes.error,response.message || 'Error al inscribir el cliente');
            let detailedError = 'La inscripcion ha fallado';
            if (response.errors && response.errors.length > 0) {
                detailedError += ': ' + response.errors.map(e => e.message).join(', ');
            } 
            
        }
        formulario.classList.remove('was-validated');
    } catch (error) {
        showMessage(iconTypes.error,'No se pudo inscribir el cliente');
        console.error('Error al registrar clase programada:', error);
        
    }
}

/**
 * Obtiene los clientes filtrados por rol y estado
 * @param {string} rol - Rol de los usuarios a consultar
 * @param {string} estado - Estado de los usuarios (por defecto "activo")
 * @returns {Promise<Array>} Array con los clientes encontrados
 */
async function obtenerClientes(rol, estado = "activo") {
    try {
        const params = {
            rol: rol,
            estado: estado
        };

        const response = await realizarPeticionAPI('obtenerUsuariosPorRol', undefined, params);
        const clientes = response.payload || response;
        console.log("CLIENTES CONSULTADOS:", clientes);
        return clientes;
    } catch (error) {
        console.error('Error al obtener clientes:', error);
        return [];
    }
}
function limpiarFormularioCompleto(formulario) {
    formulario.reset();
}

/**
 * Limpia campos específicos de un formulario
 * @param {HTMLFormElement} formulario - El formulario HTML que contiene los campos
 * @param {string[]} camposQueLimpiar - Array con los valores los "name" de los inputs a limpiar(se usa la propiedad name no el id del input)
 * @example
 * // Limpiar solo campos específicos
 * limpiarFormularioPorCampos(miFormulario, ['nombre', 'email', 'telefono']);
 */
function limpiarFormularioPorCampos(formulario, camposQueLimpiar) {
    try {
        if (!(formulario instanceof HTMLFormElement)) {
            throw new Error('El parámetro formulario debe ser un elemento HTML de tipo form');
        }

        if (!Array.isArray(camposQueLimpiar)) {
            throw new Error('camposQueLimpiar debe ser un array de strings');
        }

        camposQueLimpiar.forEach(inputName => {
            // se usa propiedad name del input para buscarlo no el id
            const campo = formulario.elements[inputName];
            if (campo) {
                if (campo.tagName.toLowerCase() === 'select') {
                    // Para elementos select, seleccionar la primera opción
                    campo.selectedIndex = 0;
                } else {
                    // Para otros elementos, limpiar el valor
                    campo.value = '';
                }
            } else {
                console.warn(`Campo '${inputName}' no encontrado en el formulario`);
            }
        });
    } catch (error) {
        console.error('Error al limpiar campos del formulario:', error);
    }
}
function actualizarClasesDisponiblesPorClaseIdEnScheduler(selectedDate,idClase, fechaFormateada) {
    const horariosDeClaseSeleccionada = obtenerHorariosPorFecha(selectedDate).filter(claseProgramada => claseProgramada.fkClase === idClase);
    scheduleViewerInstance.setSelectedDate(fechaFormateada);
    scheduleViewerInstance.loadSchedules(horariosDeClaseSeleccionada)
    
}

/**
 * Verifica si existe una clase con el ID especificado en la estructura de horarios
 * @param {number} idClase - ID de la clase a buscar
 * @returns {boolean} True si encuentra la clase, false en caso contrario
 */
function existeClaseEnHorarios(datos, nombrePropiedad, valorDePropiedadBuscado) {
    try {
        // Iterar sobre los años
        for (const año in horarios) {
            // Iterar sobre los meses
            for (const mes in datos[año]) {
                // Iterar sobre los días
                for (const dia in datos[año][mes]) {
                    // Obtener el array de horarios del día
                    const horariosDelDia = datos[año][mes][dia];

                    // Buscar si existe algún horario con el idClase especificado
                    if (horariosDelDia.some(horario => horario[nombrePropiedad] === valorDePropiedadBuscado)) {
                        return true;
                    }
                }
            }
        }
        return false;

    } catch (error) {
        console.error('Error al buscar clase en horarios:', error);
        return false;
    }
}

/**
 * Reselecciona un horario específico en el visualizador de horarios
 * @param {number} idHoraSeleccionada - ID del horario a reseleccionar
 * @returns {boolean} true si encontró y reseleccionó el horario, false si no
 */
function reseleccionarHorario(idHoraSeleccionada,claseSeleccionada) {
    try {
        // Buscar el botón del horario
        const botonHorario = document.querySelector(`.schedule-viewer__item[data-idhora="${idHoraSeleccionada}"]`);
            // Simular click en el botón
        botonHorario.click();
        // O alternativamente, disparar evento personalizado
        const event = new CustomEvent('scheduleSelected', {
            detail: {
                scheduleId:claseSeleccionada[0].idHora,
                schedule: claseSeleccionada[0]
            },
                bubbles: true
        });
        botonHorario.dispatchEvent(event);
        return true;
    } catch (error) {
        console.error('Error al reseleccionar horario:', error);
        return false;
    }
}

inicializarInscriptor();