import { realizarPeticionAPI, getSignalRBaseUrl } from './httpClient.js';
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

async function onClienteChange() {
    const idCliente = comboCliente.value;
    if (!idCliente) {
        resetComboInscripcion();
        return;
    }

    try {
        const response = await realizarPeticionAPI('/inscripciones/cliente', undefined, { idCliente });
        const inscripciones = response.payload || response;

        comboInscripcion.innerHTML = '<option value="">Seleccione una inscripción...</option>';
        (inscripciones || []).forEach(ins => {
            const option = document.createElement('option');
            option.value = ins.idInscripcion;
            option.textContent = `${ins.nombreClase} — ${ins.fechaDeLaClase}`;
            option.dataset.idClaseProgramada = ins.idClaseProgramada;
            comboInscripcion.appendChild(option);
        });
        comboInscripcion.disabled = false;
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
    const idClaseProgramada = selected?.dataset?.idClaseProgramada;
    if (!idClaseProgramada) return;

    try {
        const response = await realizarPeticionAPI('/clases/obtenerClasesProgramadasPorId', undefined, { idClase: idClaseProgramada });
        const data = response.payload || response;

        horarios = {};
        (data || []).forEach(item => {
            const fecha = new Date(item.fechaDisponible || item.fecha);
            const anio = fecha.getFullYear();
            const mes = fecha.getMonth();
            const dia = fecha.getDate();

            if (!horarios[anio]) horarios[anio] = {};
            if (!horarios[anio][mes]) horarios[anio][mes] = {};
            if (!horarios[anio][mes][dia]) horarios[anio][mes][dia] = [];

            horarios[anio][mes][dia].push({
                idHora: item.idHora,
                horaInicio: item.horaInicio,
                horaFin: item.horaFin,
                fecha,
                labelHorario: `${item.horaInicio} - ${item.horaFin}`,
                estado: item.estado || 'disponible'
            });
        });

        updateCalendarDisponibleDates();
        actualizarVistaFecha(calendarInstance?.selectedDate || new Date());
    } catch (error) {
        console.error('Error al consultar clases programadas:', error);
    }
}

function updateCalendarDisponibleDates() {
    if (!calendarInstance) return;
    const today = new Date();
    const monthSchedules = Object.values(horarios[today.getFullYear()]?.[today.getMonth()] || {}).flat();
    calendarInstance.disponibleDates = monthSchedules;
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
    const fecha = event.detail.fecha;
    const monthSchedules = Object.values(horarios[fecha.getFullYear()]?.[fecha.getMonth()] || {}).flat();

    if (calendarInstance) {
        calendarInstance.disponibleDates = monthSchedules;
        calendarInstance.render();
    }
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
    const selected = comboInscripcion.options[comboInscripcion.selectedIndex];
    const idClaseProgramada = selected?.dataset?.idClaseProgramada;
    const idCliente = comboCliente.value;
    const idNuevaClase = scheduleViewerInstance?.getSelectedScheduleId();

    if (!idNuevaClase) {
        showMessage(iconTypes.warning, 'Seleccione un horario en el calendario');
        return;
    }

    try {
        const response = await realizarPeticionAPI('/inscripciones/reagendar', {
            idInscripcion,
            idClaseProgramada,
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
    comboInscripcion.innerHTML = '<option value="">Primero seleccione un cliente...</option>';
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
