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
        clientId = parseInt(comboSelected.value);
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
            if (estadoOption.value == citaSelected.fkEntrenador) {
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
    const response = await fetch("http://localhost:5274/api/getCitasAgendadas?idUsuario=" + clientId);
    const jsonResponse = await response.json();
    if (!jsonResponse.ok) {
        console.log(jsonResponse.message);
        return;
    }
    citas = jsonResponse.data;
}
const getEntrenadoresDisponibles = async () => {
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
    const response = await fetch("http://localhost:5274/api/getDuracionCita");
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

});