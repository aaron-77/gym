import { showMessage, iconTypes } from './messageManager.mjs';
import { getNginxBaseUrl, realizarPeticionAPI, obtenerEndpoint } from './httpClient.js';

let clients = [];
let citas = [];
let entrenadores = [];
let estados = ["Agendada", "Completada", "Cancelada"];
let clientId = null;
let citaId = null;
let citaSelected = null;
let estadoSelected = null;
let duracionCita = null;
let $inputClientes = null;
let $inputCitas = null;
let $inputFechaInicio = null;
let $inputFechaFin = null;

export async function enviarFormularioModificarCita(event) {
    event.preventDefault();

    const form = event.target;
    if (!form.checkValidity()) {
        event.stopPropagation();
        form.classList.add('was-validated');
        return;
    }

    const formData = new FormData(form);

    // Convertir FormData a objeto JSON directamente
    const citaData = Object.fromEntries(formData.entries());

    try {
        const submitBtn = form.querySelector('button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Guardando...';

        const data = await realizarPeticionAPI(obtenerEndpoint('ENDPOINT_CITAS_MODIFICARCITA', '/modificarCita'), citaData);

        // El API devuelve DTOResponse, verificar success
        if (data.success) {
            await showMessage(iconTypes.success, data.message || 'Cita modificada correctamente');
            form.classList.remove('was-validated');
        } else {
            await showMessage(iconTypes.error, data.message || 'Error al modificar la cita');
        }
    } catch (error) {
        console.error('Error:', error);
        await showMessage(iconTypes.error, error.message || 'Error al modificar la cita');
    } finally {
        const submitBtn = form.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = 'Modificar';
        }
    }
}


const formatearFecha = (fecha) => {
    const ano = fecha.getFullYear();
    const mes = ('0' + (fecha.getMonth() + 1)).slice(-2);
    const dia = ('0' + fecha.getDate()).slice(-2);
    const horas = ('0' + fecha.getHours()).slice(-2);
    const minutos = ('0' + fecha.getMinutes()).slice(-2);
    const segundos = ('0' + fecha.getSeconds()).slice(-2);

    return `${ano}-${mes}-${dia} ${horas}:${minutos}:${segundos}`;
}


const handleSelectedAction = async (ev) => {
    const comboSelected = ev.currentTarget;
    enableElements(comboSelected.id);

    if (comboSelected.id == "inputCliente") {
        //asignar clienteID
        //get Citas
        //fillCitasAgendadas
        clientId = comboSelected.value;
        await getCitasAgendadas();
        fillCitasAgendadas();
    }
    if (comboSelected.id == "inputCita") {
        //asignar cita seleccionada
        //fill fecha inicio y fecha fin
        //asignamos fecaINicio
       
        citaId = parseInt(comboSelected.value);
        citaSelected = citas.find(citaArr => citaArr.id == citaId);
        for (let estadoOption of document.getElementById("inputEstado").children) {
            if (estadoOption.value == citaSelected.estado) {
                estadoOption.selected = true;
            }
        }

        
        $inputFechaInicio.value = citaSelected.fechaInicioCita;
        $inputFechaFin.value = citaSelected.fechaFinCita;
        $inputFechaFin.disabled = false;
        enableElements(comboSelected.id);
        await getEntrenadoresDisponibles();
        fillComboEntrenadores();
        for (let estadoOption of document.getElementById("inputEntrenador").children) {
            if (estadoOption.value.toLowerCase() == citaSelected.fkEntrenador.toLowerCase()) {
                estadoOption.selected = true;
            }
        }
    }
    if (comboSelected.id == "inputFechaInicio") {
        if ($inputFechaInicio.value != null) {
            $inputFechaFin.disabled = false;
        }
        citaId = parseInt($inputCitas.value);
        citaSelected = citas.find(citaArr => citaArr.id == citaId);
        if (citaSelected.tipoCita == "medicion") {
            await getDuracionCitas();
            calculateEndDate();
        }
        //asignamos fecha inicio
        await getEntrenadoresDisponibles();
        fillComboEntrenadores();
        //enncaso de no haber entrenadores borrar los datos de fecha inicio y fin y oligar a que den otra
        // o conservar a cita tal y como esta
    }
}
const enableElements = (activaedCombo) => {
    let desactivableElements = document.querySelectorAll(".desactivable");
    desactivableElements.forEach((element, index) => {
        if (activaedCombo == "inputCliente") {
            desactivableElements[0].disabled = false;
        } else {
            desactivableElements[index].disabled = false;
        }
        
    });

}

const disableElements = () => {
    const descactivableElements = document.querySelectorAll(".desactivable");
    for (let element of descactivableElements) {
        element.disabled = true;
    }
}
const getCitasAgendadas = async () => {
    const response = await fetch(obtenerEndpoint('ENDPOINT_CITAS_OBTENERCITASAGENDADASDELCLIENTE', "/obtenerCitasAgendadasDelCliente") + "?idUsuario=" + clientId);
    const jsonResponse = await response.json();
    if (!jsonResponse.success) {
        console.log(jsonResponse.message);
        return;
    }
    citas = jsonResponse.payload;
}
import { convertirADateLocal, formatLocalDateTimeForQuery } from './dateUtils.mjs';

const getEntrenadoresDisponibles = async () => {
    const fechaInicio = convertirADateLocal(document.getElementById("inputFechaInicio").value);
    const fechaInicioForQueryParameter = formatLocalDateTimeForQuery(fechaInicio);
    const response = await fetch(obtenerEndpoint('ENDPOINT_CITAS_OBTENERENTRENADORESDISPONIBLES', "/obtenerEntrenadoresDisponibles") + "?fechaReferencia=" + fechaInicioForQueryParameter);

    const jsonResponse = await response.json();
    if (!jsonResponse.success) {
        if (jsonResponse.payload.length == 0) {
            await showMessage(iconTypes.warning, 'No hay trainers disponibles, elige otra fecha');
        }
        console.log(jsonResponse.message);
        return;
    }
    entrenadores = jsonResponse.payload;
}

function fillComboEntrenadores() {
    var select = document.getElementById('inputEntrenador');
    select.innerHTML = "";
    let defalutoption = document.createElement('option');
    defalutoption.value = null;
    defalutoption.text = "Selecciona un entrenador";
    select.appendChild(defalutoption);
    entrenadores.forEach(function (client) {
        let option = document.createElement('option');
        option.value = client.usuarioID;
        option.text = client.nombre + " " + client.apellido;
        select.appendChild(option);
    });
}
function fillCitasAgendadas() {
    let select = document.getElementById('inputCita');
    select.innerHTML = "";
    let defalutoption = document.createElement('option');
    defalutoption.value = null;
    defalutoption.text = "Selecciona una cita";
    select.appendChild(defalutoption);
    citas.forEach((cita) => {
        let option = document.createElement('option');
        option.value = cita.id;
        option.text = cita.id + " " + cita.tipoCita;
        select.appendChild(option);
    });
}


function fillEstados() {
    let select = document.getElementById('inputEstado');
    select.innerHTML = "";
    estados.forEach((estado) => {
        let option = document.createElement('option');
        option.value = estado;
        option.text = estado;
        select.appendChild(option);
    });
}
const getDuracionCitas = async () => {
    // Usar ruta relativa ya que es un endpoint del frontend
    const path = obtenerEndpoint('ENDPOINT_CITAS_GETDURACIONCITA', "/getDuracionCita");
    
    const response = await fetch(path);
    const jsonResponse = await response.json();
    if (!jsonResponse.ok) {
        console.log(jsonResponse.message);
        return;
    }
    duracionCita = parseInt(jsonResponse.data);
}

const calculateEndDate = () => {
    const $fechaInicio = document.getElementById("inputFechaInicio");
    const newDate = new Date($fechaInicio.value);
    newDate.setHours(newDate.getHours() + duracionCita);
    const $fechaFin = document.getElementById("inputFechaFin");
    $fechaFin.value = formatearFecha(newDate);
    console.log("fecha fin", formatearFecha(newDate));

}


addEventListener("DOMContentLoaded", async () => {
    disableElements();
    fillEstados();
    $inputClientes = document.getElementById("inputCliente");
    $inputCitas = document.getElementById("inputCita");
    $inputFechaInicio = document.getElementById("inputFechaInicio");
    $inputFechaFin = document.getElementById("inputFechaFin");
    $inputClientes.addEventListener('change', handleSelectedAction);
    $inputCitas.addEventListener('change', handleSelectedAction);
    $inputFechaInicio.addEventListener('change', handleSelectedAction);

    // Agregar listener para el formulario de modificar cita
    const formularioModificarCita = document.getElementById("formModificarCita");
    if (formularioModificarCita) {
        formularioModificarCita.addEventListener('submit', enviarFormularioModificarCita);
    }

});