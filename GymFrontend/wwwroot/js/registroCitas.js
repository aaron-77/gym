let clients = [];
let entrenadores = [];
let duracionCita = null;
let ejercicios = [];
let clientId = null;
let rutinaId = null;
let exercideId = null;
let $inputTipoCita = null;


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
    const response = await fetch("/getDuracionCita"); // MODIFICADO: Usar endpoint del frontend sin /api
    const jsonResponse = await response.json();
    if (!jsonResponse.success) { // MODIFICADO: Usar success
        console.log(jsonResponse.message);
        return;
    }
    duracionCita = parseInt(jsonResponse.payload); // MODIFICADO: Usar payload
}
const getEntrenaoresDisponibles = async () => {
    const fechaInicio =new Date(document.getElementById("inputFechaInicio").value);
    const fechaInicioISO = fechaInicio.toISOString();
    const fechaInicioForQueryParameter = encodeURIComponent(fechaInicioISO);
    const response = await fetch("/obtenerEntrenadoresDisponibles?fechaReferencia=" + fechaInicioForQueryParameter); // MODIFICADO: Usar endpoint del frontend sin /api

    const jsonResponse = await response.json();
    if (!jsonResponse.success) { // MODIFICADO: Usar success
        if (jsonResponse.payload.length == 0) { // MODIFICADO: Usar payload
            alert("No hay entrenadores disponibles, elige otra fecha");
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
function convertirADateLocal(valorInput) {
    if (!valorInput) return null;

    // Parsear como fecha local
    const [fechaParte, horaParte = '00:00'] = valorInput.split('T');
    const [año, mes, dia] = fechaParte.split('-').map(Number);
    const [hora, minuto] = horaParte.split(':').map(Number);

    // Crear Date en hora LOCAL
    return new Date(año, mes - 1, dia, hora, minuto, 0);
}

addEventListener("DOMContentLoaded", async () => {
    //disableElements();
    $inputTipoCita = document.getElementById("inputTipoCita");
    const $fechaInicio = document.getElementById("inputFechaInicio");
    $inputTipoCita.addEventListener('change', handleSelectedAction);
    $fechaInicio.addEventListener('change', handleSelectedAction);
    
    // ELIMINADO: Llamada y llenado de clientes (ya se carga en la vista)
    // await getClientes(); 
    // fillComboClients(); 

})