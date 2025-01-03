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
    const response = await fetch("http://localhost:5274/api/getDuracionCita");
    const jsonResponse = await response.json();
    if (!jsonResponse.ok) {
        console.log(jsonResponse.message);
        return;
    }
    duracionCita = parseInt(jsonResponse.data);
}
const getEntrenaoresDisponibles = async () => {
    const fechaInicio = document.getElementById("inputFechaInicio").value;
    const response = await fetch("http://localhost:5274/api/obtenerEntrenadoresDisponibles?fechaInicio=" + fechaInicio);

    const jsonResponse = await response.json();
    if (!jsonResponse.ok) {
        if (jsonResponse.data.length = 0) {
            alert("No hay entrenadores disponibles, elige otra fecha");
        }
        console.log(jsonResponse.message);
        return;
    }
    entrenadores = jsonResponse.data;
}

function fillComboEntrenadores() {
    var select = document.getElementById('inputEntrenador');
    select.innerHTML = "";
    let defalutoption = document.createElement('option');
    defalutoption.value = null;
    defalutoption.text = "Selecciona un cliente";
    select.appendChild(defalutoption);
    entrenadores.forEach(function (client) {
        let option = document.createElement('option');
        option.value = client.usuarioID;
        option.text = client.nombre + " " + client.apellido;
        select.appendChild(option);
    });
}
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
    $inputTipoCita.addEventListener('change', handleSelectedAction);
    $fechaInicio.addEventListener('change', handleSelectedAction);
    

})