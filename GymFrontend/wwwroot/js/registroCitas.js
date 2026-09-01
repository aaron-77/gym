import { showMessage, iconTypes } from './messageManager.mjs';
import { obtenerEndpoint } from './httpClient.js';
let clients = [];
let entrenadores = [];
let duracionCita = null;
let ejercicios = [];
let clientId = null;
let rutinaId = null;
let exercideId = null;
let $inputTipoCita = null;

export async function enviarFormularioRegistrarCita(event) {
    event.preventDefault();

    const form = event.target;
    if (!form.checkValidity()) {
        event.stopPropagation();
        form.classList.add('was-validated');
        return;
    }

    const formData = new FormData(form);

    try {
        const submitBtn = form.querySelector('button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Guardando...';

        const path = obtenerEndpoint('ENDPOINT_CITAS_REGISTRARCITA', "/registrarCita");
        const response = await fetch(path, {
            method: 'POST',
            body: formData
        });

        if (!response.ok) {
            throw new Error('Error al procesar la solicitud');
        }

        const data = await response.json();

        if (data.success) {
            await showMessage(iconTypes.success, data.message || 'Cita registrada correctamente');
            form.reset();
            form.classList.remove('was-validated');
            // Disable dependent fields
            const desactivableElements = document.querySelectorAll('.desactivable');
            for (let element of desactivableElements) {
                element.disabled = true;
            }
        } else {
            await showMessage(iconTypes.error, data.message || 'Error al registrar la cita');
        }
    } catch (error) {
        console.error('Error:', error);
        await showMessage(iconTypes.error, error.message || 'Error al registrar la cita');
    } finally {
        const submitBtn = form.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = 'Agendar';
        }
    }
}

export async function enviarFormularioDuracionCitas(event) {
    event.preventDefault();

    const form = event.target;
    if (!form.checkValidity()) {
        event.stopPropagation();
        form.classList.add('was-validated');
        return;
    }

    const formData = new FormData(form);

    const submitBtn = form.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;

    try {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Guardando...';

        const path = obtenerEndpoint('ENDPOINT_CITAS_DURACIONCITASMEDICIONPAGE', "/duracionCitasMedicionPage");
        const response = await fetch(path, {
            method: 'POST',
            body: formData
        });

        if (!response.ok) {
            throw new Error('Error al procesar la solicitud');
        }

        const data = await response.json();

        if (data.success) {
            await showMessage(iconTypes.success, data.message || 'Duracion guardada correctamente');
            form.classList.remove('was-validated');
        } else {
            await showMessage(iconTypes.error, data.message || 'Error al guardar la duracion');
        }
    } catch (error) {
        console.error('Error:', error);
        await showMessage(iconTypes.error, error.message || 'Error al guardar la duracion');
    } finally {
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
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

const calculateEndDate = () => {
    const $fechaInicio = document.getElementById("inputFechaInicio");
    const newDate = new Date($fechaInicio.value);
    newDate.setHours(newDate.getHours() + duracionCita);
    const $fechaFin = document.getElementById("inputFechaFin");
    $fechaFin.value = formatearFecha(newDate);
    console.log("fecha fin", formatearFecha(newDate));

}
const handleSelectedAction = async (ev) => {
    const comboSelected = ev.currentTarget;
    enableElements(comboSelected.id);
    if (comboSelected.id == "inputTipoCita") {
        await getDuracionCitas();
        console.log(duracionCita);
    }
    if (comboSelected.id == "inputFechaInicio") {
        await getEntrenaoresDisponibles();
        fillComboEntrenadores();
        
    }
    if ($inputTipoCita.value == "Medicion") {
        calculateEndDate();
    }
}
const enableElements = (activaedCombo) => {
    let desactivableElements = document.querySelectorAll(".desactivable");
    desactivableElements.forEach((element, index) => {
        if (element.id == activaedCombo) {
            desactivableElements[index + 1].disabled = false;
        }
    });
    
}

const disableElements = () => {
    const descactivableElements = document.querySelectorAll(".desactivable");
    for (let element of descactivableElements) {
        element.disabled = true;
    }
}
const getDuracionCitas = async () => {
    const response = await fetch(obtenerEndpoint('ENDPOINT_CITAS_GETDURACIONCITA', "/getDuracionCita")); // MODIFICADO: Usar endpoint del frontend sin /api
    const jsonResponse = await response.json();
    if (!jsonResponse.success) { // MODIFICADO: Usar success
        console.log(jsonResponse.message);
        return;
    }
    duracionCita = parseInt(jsonResponse.payload); // MODIFICADO: Usar payload
}
import { convertirADateLocal, formatLocalDateTimeForQuery } from './dateUtils.mjs';

const getEntrenaoresDisponibles = async () => {
    const fechaInicio = convertirADateLocal(document.getElementById("inputFechaInicio").value);
    const fechaInicioForQueryParameter = formatLocalDateTimeForQuery(fechaInicio);
    const response = await fetch(obtenerEndpoint('ENDPOINT_CITAS_OBTENERENTRENADORESDISPONIBLES', "/obtenerEntrenadoresDisponibles") + "?fechaReferencia=" + encodeURIComponent(fechaInicioForQueryParameter)); // send local datetime string

    const jsonResponse = await response.json();
    if (!jsonResponse.success) { // MODIFICADO: Usar success
        if (jsonResponse.payload.length == 0) { // MODIFICADO: Usar payload
            await showMessage(iconTypes.warning, 'No hay trainers disponibles, elige otra fecha');
        }
        console.log(jsonResponse.message);
        return;
    }
    entrenadores = jsonResponse.payload; // MODIFICADO: Usar payload
}

function fillComboEntrenadores() {
    var select = document.getElementById('inputEntrenador');
    select.innerHTML = "";
    let defalutoption = document.createElement('option');
    defalutoption.value = null;
    defalutoption.text = "Selecciona un entrenador"; // MODIFICADO: Texto
    select.appendChild(defalutoption);
    entrenadores.forEach(function (entrenador) { // MODIFICADO: client a entrenador
        let option = document.createElement('option');
        option.value = entrenador.usuarioID; // MODIFICADO: client.usuarioID a entrenador.usuarioID
        option.text = entrenador.nombre + " " + entrenador.apellido; // MODIFICADO: client.nombre a entrenador.nombre
        select.appendChild(option);
    });
}
// ELIMINADO: Función para obtener clientes (ya se carga en la vista)
// const getClientes = async() => {
//     const response = await fetch("/api/obtenerClientes");
//     const jsonResponse = await response.json();
//     if (!jsonResponse.success) {
//         console.log(jsonResponse.message);
//         return;
//     }
//     clients = jsonResponse.payload;
// }

// ELIMINADO: Función para llenar el combo de clientes (ya se llena en la vista)
// function fillComboClients() {
//     var select = document.getElementById('inputCliente');
//     select.innerHTML = "";
//     let defalutoption = document.createElement('option');
//     defalutoption.value = null;
//     defalutoption.text = "Selecciona un cliente";
//     select.appendChild(defalutoption);
//     clients.forEach(function (client) {
//         let option = document.createElement('option');
//         option.value = client.usuarioID;
//         option.text = client.nombre + " " + client.apellido;
//         select.appendChild(option);
//     });
// }

function fillCitasAgendadas() {
    let select = document.getElementById('inputRutina');
    select.innerHTML = "";
    let defalutoption = document.createElement('option');
    defalutoption.value = null;
    defalutoption.text = "Selecciona una rutina";
    select.appendChild(defalutoption);
    rutinas.forEach((rutina) => {
        let option = document.createElement('option');
        option.value = rutina.rutinaId;
        option.text = rutina.rutinaId + " " + rutina.observaciones;
        select.appendChild(option);
    });
}

function fillComboEjercicios() {
    var select = document.getElementById('inputEjercicio');
    select.innerHTML = "";
    let defalutoption = document.createElement('option');
    defalutoption.value = null;
    defalutoption.text = "Selecciona un ejercicio";
    select.appendChild(defalutoption);  
    ejercicios.forEach((ejericio) => {
        let option = document.createElement('option');
        option.value = ejericio.ejercicioID;
        option.text = ejericio.nombreEjercicio;
        select.appendChild(option);
    });
}


addEventListener("DOMContentLoaded", async () => {
    //disableElements();
    $inputTipoCita = document.getElementById("inputTipoCita");
    const $fechaInicio = document.getElementById("inputFechaInicio");
    $inputTipoCita?.addEventListener('change', handleSelectedAction);
    $fechaInicio?.addEventListener('change', handleSelectedAction);
    
    // Agregar listeners para los formularios
    const formularioRegistrarCita = document.getElementById("formRegistrarCita");
    if (formularioRegistrarCita) {
        formularioRegistrarCita.addEventListener('submit', enviarFormularioRegistrarCita);
    }
    
    const formularioDuracionCitas = document.getElementById("formDuracionCitas");
    if (formularioDuracionCitas) {
        formularioDuracionCitas.addEventListener('submit', enviarFormularioDuracionCitas);
    }

    // ELIMINADO: Llamada y llenado de clientes (ya se carga en la vista)
    // await getClientes(); 
    // fillComboClients(); 

})