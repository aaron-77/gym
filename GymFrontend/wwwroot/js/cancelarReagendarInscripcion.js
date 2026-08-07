import { realizarPeticionAPI, getSignalRBaseUrl, obtenerFechaReferencia } from './httpClient.js';
import { Calendar } from './calendario.js';
import { ScheduleViewer } from './horariosDelDia.js';
import { showMessage, iconTypes } from './messageManager.mjs';

let calendarInstance = null;
let scheduleViewerInstance = null;
let signalRConnection = null;
let isSignalRConnected = false;
let horarios = {};

const comboCliente = document.getElementById('comboCliente');
const comboInscripcion = document.getElementById('comboInscripcion');
const checkReagendar = document.getElementById('checkReagendar');
const contenedorCalendario = document.getElementById('contenedorCalendario');
const contenedorScheduler = document.getElementById('contenedorScheduler');
const btnEjecutar = document.getElementById('btnEjecutar');
const btnLimpiar = document.getElementById('btnLimpiar');

async function init() {
    await initSignalR();
    bindEvents();
}

function bindEvents() {
    comboCliente.addEventListener('change', onClienteChange);
    comboInscripcion.addEventListener('change', onInscripcionChange);
    checkReagendar.addEventListener('change', onReagendarToggle);
    btnEjecutar.addEventListener('click', onEjecutarClick);
    btnLimpiar.addEventListener('click', resetUI);
    document.addEventListener('fechaSeleccionada', onFechaSeleccionada);
    document.addEventListener('changedDate', onChangedDate);
}

function fillComboBox(combobox, items, defaultText, mapFn) {
    if (!combobox) {
        console.error('fillComboBox: el elemento combobox es null');
        return;
    }

    combobox.innerHTML = `<option value="">${defaultText}</option>`;

    if (items && items.length > 0) {
        items.forEach(item => {
            const result = mapFn(item);
            const option = document.createElement('option');
            option.value = result.value;
            option.textContent = result.text;
            if (result.dataset) {
                Object.entries(result.dataset).forEach(([key, val]) => {
                    option.dataset[key] = val;
                });
            }
            combobox.appendChild(option);
        });
        combobox.disabled = false;
    } else {
        combobox.disabled = true;
    }
}

async function onClienteChange() {
    const idCliente = comboCliente.value;
    if (!idCliente) {
        resetComboInscripcion();
        return;
    }

    try {
        const response = await realizarPeticionAPI('/inscripciones/cliente', undefined, { idCliente });
        const inscripciones = response.payload || response;

        fillComboBox(comboInscripcion, inscripciones, 'Seleccione una inscripción...', ins => ({
            value: ins.idInscripcion,
            text: `${ins.nombreClase} — ${ins.fechaDeLaClase}`,
            dataset: { idClaseProgramada: ins.idClaseProgramada, fkClase: ins.fkClase }
        }));
    } catch {
        showMessage(iconTypes.error, 'Error al obtener inscripciones del cliente');
    }
}

function onInscripcionChange() {
    if (checkReagendar.checked && comboInscripcion.value) {
        fetchClasesProgramadas();
    }
}

async function onReagendarToggle() {
    if (checkReagendar.checked) {
        contenedorCalendario.classList.remove('d-none');
        contenedorScheduler.classList.remove('d-none');
        btnEjecutar.textContent = 'Reagendar';

        if (!calendarInstance) {
            calendarInstance = new Calendar('calendar');
            calendarInstance.init();
        }
        if (!scheduleViewerInstance) {
            scheduleViewerInstance = new ScheduleViewer('scheduleViewer');
            scheduleViewerInstance.init();
        }

        if (comboInscripcion.value) {
            await fetchClasesProgramadas();
        }
    } else {
        contenedorCalendario.classList.add('d-none');
        contenedorScheduler.classList.add('d-none');
        btnEjecutar.textContent = 'Cancelar';
    }
}

async function fetchClasesProgramadas() {
    const selected = comboInscripcion.options[comboInscripcion.selectedIndex];
    const fkClase = selected?.dataset?.fkClase;
    if (!fkClase) return;

    try {
        const response = await realizarPeticionAPI('/clases/obtenerClasesProgramadasPorId', undefined, { idClase: fkClase, fecha: obtenerFechaReferencia() });
        const data = response.payload || response;

        horarios = {};
        (data || []).forEach(item => {
            const fecha = new Date(item.fechaDeLaClase);
            const anio = fecha.getFullYear();
            const mes = fecha.getMonth();
            const dia = fecha.getDate();

            if (!horarios[anio]) horarios[anio] = {};
            if (!horarios[anio][mes]) horarios[anio][mes] = {};
            if (!horarios[anio][mes][dia]) horarios[anio][mes][dia] = [];

            horarios[anio][mes][dia].push({
                idHora: item.idHora,
                idClaseProgramada: item.idClaseProgramada,
                horaInicio: item.horaInicio,
                horaFin: item.horaFin,
                fecha,
                labelHorario: `${item.horaInicio} - ${item.horaFin}`,
                estado: item.estado || 'disponible'
            });
        });

        // Poblar hidden inputs requeridos por registrarPreReservaDeHorario
        // (fkClase y fkEntrenador son los mismos para todos los horarios de esta clase)
        if (data && data.length > 0) {
            const inputClase = document.getElementById('inputClase');
            const inputEntrenador = document.getElementById('inputEntrenador');
            if (inputClase) inputClase.value = data[0].fkClase;
            if (inputEntrenador) inputEntrenador.value = data[0].fkEntrenador;
        }

        // Seleccionar el primer día con horarios al iniciar el calendario
        // (el backend solo devuelve fechas desde hoy, así que el mínimo global es el primer día válido)
        const primeraFecha = getPrimeraFechaConHorarios();
        if (primeraFecha && calendarInstance) {
            calendarInstance.selectedDate = primeraFecha;

            // Sincronizar input oculto: selectedDate es property plana, no reactiva.
            // La pre-reserva de horarios lee esta fecha al clickear un horario.
            const inputFecha = document.getElementById('fechaDeLaClase');
            if (inputFecha) inputFecha.value = primeraFecha.toLocaleDateString('sv-SE');
        }

        updateCalendarDisponibleDates();
        actualizarVistaFecha(calendarInstance?.selectedDate || new Date());
    } catch (error) {
        console.error('Error al consultar clases programadas:', error);
    }
}

/**
 * Devuelve el arreglo plano de horarios del mes de la fecha dada.
 * horarios[anio][mes] es un objeto agrupado por día: { [dia]: [horarios] }.
 * disponibleDates requiere un arreglo plano de objetos con propiedad fecha.
 */
function getMonthSchedules(fecha) {
    return Object.values(horarios[fecha.getFullYear()]?.[fecha.getMonth()] || {}).flat();
}

/**
 * Obtiene el primer día con horarios cargados.
 * El backend filtra fechas >= fecha de referencia (hoy), por lo que el mínimo
 * global (año → mes → día) es el primer día válido del calendario.
 */
function getPrimeraFechaConHorarios() {
    const anios = Object.keys(horarios).map(Number);
    if (anios.length === 0) return null;

    const anio = Math.min(...anios);
    const meses = Object.keys(horarios[anio]).map(Number);
    const mes = Math.min(...meses);
    const dias = Object.keys(horarios[anio][mes]).map(Number);
    const dia = Math.min(...dias);

    return new Date(anio, mes, dia);
}

function updateCalendarDisponibleDates() {
    if (!calendarInstance) return;
    calendarInstance.disponibleDates = getMonthSchedules(calendarInstance.selectedDate);
    calendarInstance.render();
}

function getSchedulesForDate(fecha) {
    return horarios[fecha.getFullYear()]?.[fecha.getMonth()]?.[fecha.getDate()] || [];
}

function formatDate(date) {
    const dias = ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'];
    const meses = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    return `${dias[date.getDay()]}, ${date.getDate()} de ${meses[date.getMonth()]} del ${date.getFullYear()}`;
}

function onFechaSeleccionada(event) {
    const fecha = event.detail.fecha;
    actualizarVistaFecha(fecha);
}

function onChangedDate(event) {
    if (!calendarInstance) return;
    calendarInstance.disponibleDates = getMonthSchedules(event.detail.fecha);
    calendarInstance.render();
}

function actualizarVistaFecha(fecha) {
    const schedules = getSchedulesForDate(fecha);
    if (scheduleViewerInstance) {
        scheduleViewerInstance.setSelectedDate(formatDate(fecha));
        scheduleViewerInstance.loadSchedules(schedules);
    }
}

async function onEjecutarClick() {
    const idInscripcion = comboInscripcion.value;
    if (!idInscripcion) {
        showMessage(iconTypes.warning, 'Seleccione una inscripción');
        return;
    }

    if (checkReagendar.checked) {
        await ejecutarReagendar(idInscripcion);
    } else {
        await ejecutarCancelar(idInscripcion);
    }
}

async function ejecutarCancelar(idInscripcion) {
    try {
        const response = await realizarPeticionAPI('/inscripciones/cancelar', { idInscripcion });
        if (response.success) {
            showMessage(iconTypes.success, 'Inscripción cancelada exitosamente');
            resetUI();
        } else {
            showMessage(iconTypes.error, response.message || 'Error al cancelar inscripción');
        }
    } catch {
        showMessage(iconTypes.error, 'Error al cancelar inscripción');
    }
}

async function ejecutarReagendar(idInscripcion) {
    const idCliente = comboCliente.value;

    // La clase programada destino es la del horario seleccionado en el calendario.
    // El id correcto es idClaseProgramada (IdProgramacionClase), NO idHora
    // (que es el id de la franja de horario laboral).
    const selectedEl = document.querySelector('.schedule-viewer__item--selected');
    const idNuevaClase = selectedEl?.dataset?.idClaseProgramada;

    if (!idNuevaClase) {
        showMessage(iconTypes.warning, 'Seleccione un horario en el calendario');
        return;
    }

    try {
        const response = await realizarPeticionAPI('/inscripciones/reagendar', {
            idInscripcion,
            idClaseProgramada: idNuevaClase,
            idCliente
        });
        if (response.success) {
            showMessage(iconTypes.success, 'Inscripción reagendada exitosamente');
            resetUI();
        } else {
            showMessage(iconTypes.error, response.message || 'Error al reagendar inscripción');
        }
    } catch {
        showMessage(iconTypes.error, 'Error al reagendar inscripción');
    }
}

function resetUI() {
    comboCliente.value = '';
    resetComboInscripcion();
    checkReagendar.checked = false;
    contenedorCalendario.classList.add('d-none');
    contenedorScheduler.classList.add('d-none');
    btnEjecutar.textContent = 'Cancelar';
    horarios = {};
    if (scheduleViewerInstance) {
        scheduleViewerInstance.clearSelection();
        scheduleViewerInstance.clearGrid();
    }
}

function resetComboInscripcion() {
    fillComboBox(comboInscripcion, null, 'Primero seleccione un cliente...', () => ({}));
    comboInscripcion.disabled = true;
}

async function initSignalR() {
    try {
        if (typeof signalR === 'undefined') return;

        const baseUrl = getSignalRBaseUrl();
        signalRConnection = new signalR.HubConnectionBuilder()
            .withUrl(`${baseUrl}/reservacionesHub`)
            .withAutomaticReconnect([0, 2000, 10000, 30000])
            .configureLogging(signalR.LogLevel.Information)
            .build();

        signalRConnection.on('actualizarClasesProgramadas', onSignalRClasesProgramadas);
        signalRConnection.on('actualizarCuposDeClases', onSignalRCupos);

        signalRConnection.onreconnected(() => { isSignalRConnected = true; });
        signalRConnection.onclose(() => { isSignalRConnected = false; });
        signalRConnection.onreconnecting(() => { isSignalRConnected = false; });

        await signalRConnection.start();
        isSignalRConnected = true;
    } catch (error) {
        console.error('Error al conectar SignalR:', error);
    }
}

function onSignalRClasesProgramadas(respuesta) {
    if (respuesta?.success !== false && calendarInstance) {
        const idClaseProgramada = obtenerIdClaseProgramada();
        if (idClaseProgramada) fetchClasesProgramadas();
    }
}

function onSignalRCupos(respuesta) {
    if (calendarInstance?.selectedDate) {
        actualizarVistaFecha(calendarInstance.selectedDate);
    }
}

function obtenerIdClaseProgramada() {
    const selected = comboInscripcion.options[comboInscripcion.selectedIndex];
    return selected?.dataset?.idClaseProgramada;
}

window.addEventListener('beforeunload', async () => {
    if (signalRConnection && isSignalRConnected) {
        await signalRConnection.stop();
    }
});

document.addEventListener('DOMContentLoaded', init);
